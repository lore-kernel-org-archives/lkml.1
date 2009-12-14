Return-Path: <linux-kernel-owner+w=401wt.eu-S1756367AbZLNVjt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756367AbZLNVjt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 16:39:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754049AbZLNVjr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 16:39:47 -0500
Received: from gw1.cosmosbay.com ([212.99.114.194]:42437 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753260AbZLNVjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 16:39:46 -0500
Message-ID: <4B26B09A.7050607@gmail.com>
Date: Mon, 14 Dec 2009 22:39:38 +0100
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; fr; rv:1.9.1.5) Gecko/20091204 Thunderbird/3.0
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: "David S. Miller" <davem@davemloft.net>,
       Neil Horman <nhorman@tuxdriver.com>, Netdev <netdev@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: packet_sendmsg_spkt sleeping from invalid context
References: <20091214175211.GA5102@nowhere> <4B2690E7.4030303@gmail.com> <20091214205231.GB5037@nowhere> <4B26AD65.1020004@gmail.com> <20091214213002.GA5203@nowhere>
In-Reply-To: <20091214213002.GA5203@nowhere>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Mon, 14 Dec 2009 22:39:39 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 14/12/2009 22:30, Frederic Weisbecker a écrit :
> On Mon, Dec 14, 2009 at 10:25:57PM +0100, Eric Dumazet wrote:
>> Le 14/12/2009 21:52, Frederic Weisbecker a écrit :
>>>
>>> I also wonder. Are you using PREEMPT_RCU ?
>>
>> Not at all :)
>>
>> But yes, this is illegal to do the memcpy_fromiovec() in rcu_read_lock() context.
> 
> 
> I've just tested, and with rcu preempt it is mute, no warning :)
> 
> 
>>> That may explain why you haven't seen this issue because
>>> might_sleep() doesn't see you are in a rcu read locked
>>> section as preemption is not disabled, but it is illegal to
>>> voluntarily sleep in such area (although it's fine with
>>> preempt rcu) as doing so with non-prempt RCU config would barf.
>>>
>>> I'm trying a patch to handle that.
>>
>> As you want, I also have a patch testing right now :)
> 
> 
> But mine is to teach might_sleep() to handle rcu preempt case,
> not to fix this net dev thing.
> 
> But I'll happily test the fix you have :)
> 

OK here it is, I tested it with PREEMPT_RCU as well

Thanks !

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 0205621..bc17351 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -415,7 +415,7 @@ static int packet_sendmsg_spkt(struct kiocb *iocb, struct socket *sock,
 {
 	struct sock *sk = sock->sk;
 	struct sockaddr_pkt *saddr = (struct sockaddr_pkt *)msg->msg_name;
-	struct sk_buff *skb;
+	struct sk_buff *skb = NULL;
 	struct net_device *dev;
 	__be16 proto = 0;
 	int err;
@@ -437,6 +437,7 @@ static int packet_sendmsg_spkt(struct kiocb *iocb, struct socket *sock,
 	 */
 
 	saddr->spkt_device[13] = 0;
+retry:
 	rcu_read_lock();
 	dev = dev_get_by_name_rcu(sock_net(sk), saddr->spkt_device);
 	err = -ENODEV;
@@ -456,58 +457,48 @@ static int packet_sendmsg_spkt(struct kiocb *iocb, struct socket *sock,
 	if (len > dev->mtu + dev->hard_header_len)
 		goto out_unlock;
 
-	err = -ENOBUFS;
-	skb = sock_wmalloc(sk, len + LL_RESERVED_SPACE(dev), 0, GFP_KERNEL);
-
-	/*
-	 * If the write buffer is full, then tough. At this level the user
-	 * gets to deal with the problem - do your own algorithmic backoffs.
-	 * That's far more flexible.
-	 */
-
-	if (skb == NULL)
-		goto out_unlock;
-
-	/*
-	 *	Fill it in
-	 */
-
-	/* FIXME: Save some space for broken drivers that write a
-	 * hard header at transmission time by themselves. PPP is the
-	 * notable one here. This should really be fixed at the driver level.
-	 */
-	skb_reserve(skb, LL_RESERVED_SPACE(dev));
-	skb_reset_network_header(skb);
-
-	/* Try to align data part correctly */
-	if (dev->header_ops) {
-		skb->data -= dev->hard_header_len;
-		skb->tail -= dev->hard_header_len;
-		if (len < dev->hard_header_len)
-			skb_reset_network_header(skb);
+	if (!skb) {
+		size_t reserved = LL_RESERVED_SPACE(dev);
+		unsigned int hhlen = dev->header_ops ? dev->hard_header_len : 0;
+
+		rcu_read_unlock();
+		skb = sock_wmalloc(sk, len + reserved, 0, GFP_KERNEL);
+		if (skb == NULL)
+			return -ENOBUFS;
+		skb_reserve(skb, reserved);
+		/* FIXME: Save some space for broken drivers that write a hard
+		 * header at transmission time by themselves. PPP is the notable
+		 * one here. This should really be fixed at the driver level.
+		 */
+		skb_reset_network_header(skb);
+
+		/* Try to align data part correctly */
+		if (hhlen) {
+			skb->data -= hhlen;
+			skb->tail -= hhlen;
+			if (len < hhlen)
+				skb_reset_network_header(skb);
+		}
+		err = memcpy_fromiovec(skb_put(skb, len), msg->msg_iov, len);
+		if (err)
+			goto out_free;
+		goto retry;
 	}
 
-	/* Returns -EFAULT on error */
-	err = memcpy_fromiovec(skb_put(skb, len), msg->msg_iov, len);
+
 	skb->protocol = proto;
 	skb->dev = dev;
 	skb->priority = sk->sk_priority;
 	skb->mark = sk->sk_mark;
-	if (err)
-		goto out_free;
-
-	/*
-	 *	Now send it
-	 */
 
 	dev_queue_xmit(skb);
 	rcu_read_unlock();
 	return len;
 
-out_free:
-	kfree_skb(skb);
 out_unlock:
 	rcu_read_unlock();
+out_free:
+	kfree_skb(skb);
 	return err;
 }
 

