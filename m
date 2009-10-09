Return-Path: <linux-kernel-owner+w=401wt.eu-S1761012AbZJIOpJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761012AbZJIOpJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 10:45:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760950AbZJIOpI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 10:45:08 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:50129 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756828AbZJIOpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 10:45:06 -0400
Message-ID: <4ACF4C1C.4050505@gmail.com>
Date: Fri, 09 Oct 2009 16:43:40 +0200
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: "David S. Miller" <davem@davemloft.net>
CC: Herbert Xu <herbert@gondor.apana.org.au>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Ralf Hildebrandt <Ralf.Hildebrandt@charite.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Linux Netdev List <netdev@vger.kernel.org>,
       Wei Yongjun <yjwei@cn.fujitsu.com>, Takahiro Yasui <tyasui@redhat.com>,
       Hideo Aoki <haoki@redhat.com>
Subject: [PATCH] udp: Fix udp_poll() and ioctl()
References: <3onW63eFtRF.A.xXH.oMTxKB@chimera> <COE24pZSBH.A.mdH.sMTxKB@chimera> <4AC70D20.4060009@gmail.com> <4AC710DF.5070705@gmail.com> <4AC78F7C.40908@gmail.com> <4ACCB6BE.5040602@gmail.com>
In-Reply-To: <4ACCB6BE.5040602@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Fri, 09 Oct 2009 16:43:41 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet a écrit :
> Eric Dumazet a écrit :
>> Eric Dumazet a écrit :
>>> Eric Dumazet a écrit :
>>>> Rafael J. Wysocki a écrit :
>>>>> This message has been generated automatically as a part of a report
>>>>> of regressions introduced between 2.6.30 and 2.6.31.
>>>>>
>>>>> The following bug entry is on the current list of known regressions
>>>>> introduced between 2.6.30 and 2.6.31.  Please verify if it still should
>>>>> be listed and let me know (either way).
>>>>>
>>>>>
>>>>> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14301
>>>>> Subject		: WARNING: at net/ipv4/af_inet.c:154
>>>>> Submitter	: Ralf Hildebrandt <Ralf.Hildebrandt@charite.de>
>>>>> Date		: 2009-09-30 12:24 (2 days old)
>>>>> References	: http://marc.info/?l=linux-kernel&m=125431350218137&w=4
>>>>>
>> Investigation still needed...
>>
> 
> OK, my last (buggy ???) feeling is about commit 95766fff6b9a78d1
> 
> [UDP]: Add memory accounting.
> 
> (Its a two years old patch, oh well...)
> 
> Problem is the udp_poll() :
> 
> We check the first frame to be dequeued from sk_receive_queue has a good checksum.
> 
> If it doesnt, we drop the frame ( calling kfree_skb(skb); )
> 
> Problem is now we perform memory accounting on UDP, this kfree_skb()
> should be done with socket locked, but are we allowed to
> call lock_sock() from this udp_poll() context ?
> 

It seems we can lock_sock() from udp_poll() context, so here is a patch.

[PATCH] udp: Fix udp_poll()

udp_poll() can in some circumstances drop frames with incorrect checksums.

Problem is we now have to lock the socket while dropping frames, or risk
sk_forward corruption.

This bug is present since commit 95766fff6b9a78d1
([UDP]: Add memory accounting.)

While we are at it, we can correct ioctl(SIOCINQ) to also drop bad frames.

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
---
 net/ipv4/udp.c |   73 +++++++++++++++++++++++++++--------------------
 1 files changed, 43 insertions(+), 30 deletions(-)

diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 6ec6a8a..d0d436d 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -841,6 +841,42 @@ out:
 	return ret;
 }
 
+
+/**
+ *	first_packet_length	- return length of first packet in receive queue
+ *	@sk: socket
+ *
+ *	Drops all bad checksum frames, until a valid one is found.
+ *	Returns the length of found skb, or 0 if none is found.
+ */
+static unsigned int first_packet_length(struct sock *sk)
+{
+	struct sk_buff_head list_kill, *rcvq = &sk->sk_receive_queue;
+	struct sk_buff *skb;
+	unsigned int res;
+
+	__skb_queue_head_init(&list_kill);
+
+	spin_lock_bh(&rcvq->lock);
+	while ((skb = skb_peek(rcvq)) != NULL &&
+		udp_lib_checksum_complete(skb)) {
+		UDP_INC_STATS_BH(sock_net(sk), UDP_MIB_INERRORS,
+				 IS_UDPLITE(sk));
+		__skb_unlink(skb, rcvq);
+		__skb_queue_tail(&list_kill, skb);
+	}
+	res = skb ? skb->len : 0;
+	spin_unlock_bh(&rcvq->lock);
+
+	if (!skb_queue_empty(&list_kill)) {
+		lock_sock(sk);
+		__skb_queue_purge(&list_kill);
+		sk_mem_reclaim_partial(sk);
+		release_sock(sk);
+	}
+	return res;
+}
+
 /*
  *	IOCTL requests applicable to the UDP protocol
  */
@@ -857,21 +893,16 @@ int udp_ioctl(struct sock *sk, int cmd, unsigned long arg)
 
 	case SIOCINQ:
 	{
-		struct sk_buff *skb;
-		unsigned long amount;
+		unsigned int amount = first_packet_length(sk);
 
-		amount = 0;
-		spin_lock_bh(&sk->sk_receive_queue.lock);
-		skb = skb_peek(&sk->sk_receive_queue);
-		if (skb != NULL) {
+		if (amount)
 			/*
 			 * We will only return the amount
 			 * of this packet since that is all
 			 * that will be read.
 			 */
-			amount = skb->len - sizeof(struct udphdr);
-		}
-		spin_unlock_bh(&sk->sk_receive_queue.lock);
+			amount -= sizeof(struct udphdr);
+
 		return put_user(amount, (int __user *)arg);
 	}
 
@@ -1540,29 +1571,11 @@ unsigned int udp_poll(struct file *file, struct socket *sock, poll_table *wait)
 {
 	unsigned int mask = datagram_poll(file, sock, wait);
 	struct sock *sk = sock->sk;
-	int 	is_lite = IS_UDPLITE(sk);
 
 	/* Check for false positives due to checksum errors */
-	if ((mask & POLLRDNORM) &&
-	    !(file->f_flags & O_NONBLOCK) &&
-	    !(sk->sk_shutdown & RCV_SHUTDOWN)) {
-		struct sk_buff_head *rcvq = &sk->sk_receive_queue;
-		struct sk_buff *skb;
-
-		spin_lock_bh(&rcvq->lock);
-		while ((skb = skb_peek(rcvq)) != NULL &&
-		       udp_lib_checksum_complete(skb)) {
-			UDP_INC_STATS_BH(sock_net(sk),
-					UDP_MIB_INERRORS, is_lite);
-			__skb_unlink(skb, rcvq);
-			kfree_skb(skb);
-		}
-		spin_unlock_bh(&rcvq->lock);
-
-		/* nothing to see, move along */
-		if (skb == NULL)
-			mask &= ~(POLLIN | POLLRDNORM);
-	}
+	if ((mask & POLLRDNORM) && !(file->f_flags & O_NONBLOCK) &&
+	    !(sk->sk_shutdown & RCV_SHUTDOWN) && !first_packet_length(sk))
+		mask &= ~(POLLIN | POLLRDNORM);
 
 	return mask;
 
