Return-Path: <linux-kernel-owner+w=401wt.eu-S1758580AbZLGANl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758580AbZLGANl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 19:13:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758368AbZLGANj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 19:13:39 -0500
Received: from kroah.org ([198.145.64.141]:34549 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758405AbZLGAN3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 19:13:29 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Sun Dec  6 16:06:53 2009
Message-Id: <20091207000653.140690475@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Sun, 06 Dec 2009 16:00:48 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Eric Dumazet <eric.dumazet@gmail.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [072/119] udp: Fix udp_poll() and ioctl()
References: <20091206235936.208334321@mini.kroah.org>
Content-Disposition: inline; filename=udp-fix-udp_poll-and-ioctl.patch
In-Reply-To: <20091207000938.GA24743@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Eric Dumazet <eric.dumazet@gmail.com>

[ Upstream commit 85584672012ee0c3b7b8e033a1ecf7c11878e45f ]

udp_poll() can in some circumstances drop frames with incorrect checksums.

Problem is we now have to lock the socket while dropping frames, or risk
sk_forward corruption.

This bug is present since commit 95766fff6b9a78d1
([UDP]: Add memory accounting.)

While we are at it, we can correct ioctl(SIOCINQ) to also drop bad frames.

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/ipv4/udp.c |   74 +++++++++++++++++++++++++++++++++------------------------
 1 file changed, 43 insertions(+), 31 deletions(-)

--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -831,6 +831,42 @@ out:
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
@@ -847,21 +883,16 @@ int udp_ioctl(struct sock *sk, int cmd, 
 
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
 
@@ -1525,32 +1556,13 @@ unsigned int udp_poll(struct file *file,
 {
 	unsigned int mask = datagram_poll(file, sock, wait);
 	struct sock *sk = sock->sk;
-	int 	is_lite = IS_UDPLITE(sk);
 
 	/* Check for false positives due to checksum errors */
-	if ( (mask & POLLRDNORM) &&
-	     !(file->f_flags & O_NONBLOCK) &&
-	     !(sk->sk_shutdown & RCV_SHUTDOWN)){
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
-
 }
 
 struct proto udp_prot = {


