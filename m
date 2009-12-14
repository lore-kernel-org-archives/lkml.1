Return-Path: <linux-kernel-owner+w=401wt.eu-S932582AbZLNTYm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932582AbZLNTYm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 14:24:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932542AbZLNTYh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 14:24:37 -0500
Received: from gw1.cosmosbay.com ([212.99.114.194]:55854 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932428AbZLNTYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 14:24:35 -0500
Message-ID: <4B2690E7.4030303@gmail.com>
Date: Mon, 14 Dec 2009 20:24:23 +0100
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; fr; rv:1.9.1.5) Gecko/20091204 Thunderbird/3.0
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: "David S. Miller" <davem@davemloft.net>,
       Neil Horman <nhorman@tuxdriver.com>, Netdev <netdev@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: packet_sendmsg_spkt sleeping from invalid context
References: <20091214175211.GA5102@nowhere>
In-Reply-To: <20091214175211.GA5102@nowhere>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Mon, 14 Dec 2009 20:24:24 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 14/12/2009 18:52, Frederic Weisbecker a écrit :
> Hi,
> 
> I don't know if it has been reported already.
> I get the following warning on boot, with latest upstream tree:
> 
> [   32.776502] sched: BUG: sleeping function called from invalid context at mm/slab.c:3032
> [   32.802173] sched: in_atomic(): 1, irqs_disabled(): 0, pid: 3555, name: dhclient3
> [   32.821141] 1 lock held by dhclient3/3555:
> [   32.821147]  #0:  (rcu_read_lock){.+.+.+}, at: [<ffffffff815d177d>] packet_sendmsg_spkt+0x7d/0x2c0
> [   32.821174] Pid: 3555, comm: dhclient3 Tainted: G        W  2.6.32-tip+ #134
> [   32.821181] Call Trace:
> [   32.821194]  [<ffffffff810811c3>] ? __debug_show_held_locks+0x13/0x30
> [   32.821207]  [<ffffffff8103d6b8>] __might_sleep+0x118/0x140
> [   32.821219]  [<ffffffff81110c23>] kmem_cache_alloc+0x173/0x190
> [   32.821231]  [<ffffffff815483d9>] __alloc_skb+0x49/0x170
> [   32.821241]  [<ffffffff81542238>] sock_wmalloc+0x38/0x80
> [   32.821250]  [<ffffffff815d182b>] packet_sendmsg_spkt+0x12b/0x2c0
> [   32.821260]  [<ffffffff815d177d>] ? packet_sendmsg_spkt+0x7d/0x2c0
> [   32.821272]  [<ffffffff8153ded7>] sock_sendmsg+0x127/0x140
> [   32.821285]  [<ffffffff8106f4a0>] ? autoremove_wake_function+0x0/0x40
> [   32.821297]  [<ffffffff810f467b>] ? might_fault+0x7b/0xd0
> [   32.821306]  [<ffffffff810f467b>] ? might_fault+0x7b/0xd0
> [   32.821318]  [<ffffffff815401aa>] ? move_addr_to_kernel+0x6a/0x70
> [   32.821328]  [<ffffffff8154029f>] sys_sendto+0xef/0x120
> [   32.821340]  [<ffffffff81131479>] ? mntput_no_expire+0x29/0x110
> [   32.821355]  [<ffffffff810027db>] system_call_fastpath+0x16/0x1b
> 

Thanks for the report Frederic.

We could partly revert the original commit, but as we wanted to avoid touching 
device refcount, and af_packet might be the only real abuser, we could
try following patch instead.

Thanks

[PATCH] packet: dont call sleeping function while holding rcu_read_lock()

commit 654d1f8a019dfa06d (packet: less dev_put() calls)
introduced a problem, calling a potentially sleeping function from a
rcu_read_lock() protected section.

Fix this by releasing lock before the sock_wmalloc() call.
After skb allocation, we redo device lookup and appropriate tests.

Reported-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
---
 net/packet/af_packet.c |   36 +++++++++++++-----------------------
 1 file changed, 13 insertions(+), 23 deletions(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 0205621..19ceadc 100644
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
@@ -456,27 +457,21 @@ static int packet_sendmsg_spkt(struct kiocb *iocb, struct socket *sock,
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
+	if (!skb) {
+		size_t reserved = LL_RESERVED_SPACE(dev);
 
-	if (skb == NULL)
-		goto out_unlock;
-
-	/*
-	 *	Fill it in
-	 */
+		rcu_read_unlock();
+		skb = sock_wmalloc(sk, len + reserved, 0, GFP_KERNEL);
+		if (skb == NULL)
+			return -ENOBUFS;
+		skb_reserve(skb, reserved);
+		goto retry;
+	}
 
 	/* FIXME: Save some space for broken drivers that write a
 	 * hard header at transmission time by themselves. PPP is the
 	 * notable one here. This should really be fixed at the driver level.
 	 */
-	skb_reserve(skb, LL_RESERVED_SPACE(dev));
 	skb_reset_network_header(skb);
 
 	/* Try to align data part correctly */
@@ -494,20 +489,15 @@ static int packet_sendmsg_spkt(struct kiocb *iocb, struct socket *sock,
 	skb->priority = sk->sk_priority;
 	skb->mark = sk->sk_mark;
 	if (err)
-		goto out_free;
-
-	/*
-	 *	Now send it
-	 */
+		goto out_unlock;
 
 	dev_queue_xmit(skb);
 	rcu_read_unlock();
 	return len;
 
-out_free:
-	kfree_skb(skb);
 out_unlock:
 	rcu_read_unlock();
+	kfree_skb(skb);
 	return err;
 }
 
