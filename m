Return-Path: <linux-kernel-owner+w=401wt.eu-S932835AbZLGANr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932835AbZLGANr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 19:13:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758440AbZLGANn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 19:13:43 -0500
Received: from kroah.org ([198.145.64.141]:34566 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758533AbZLGANc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 19:13:32 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Sun Dec  6 16:06:53 2009
Message-Id: <20091207000653.772759765@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Sun, 06 Dec 2009 16:00:51 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Eric Dumazet <eric.dumazet@gmail.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [075/119] net: fix sk_forward_alloc corruption
References: <20091206235936.208334321@mini.kroah.org>
Content-Disposition: inline; filename=net-fix-sk_forward_alloc-corruption.patch
In-Reply-To: <20091207000938.GA24743@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Eric Dumazet <eric.dumazet@gmail.com>

[ Upstream commit: 9d410c796067686b1e032d54ce475b7055537138 ]

On UDP sockets, we must call skb_free_datagram() with socket locked,
or risk sk_forward_alloc corruption. This requirement is not respected
in SUNRPC.

Add a convenient helper, skb_free_datagram_locked() and use it in SUNRPC

Reported-by: Francis Moreau <francis.moro@gmail.com>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/linux/skbuff.h |    2 ++
 net/core/datagram.c    |   10 +++++++++-
 net/ipv4/udp.c         |    4 +---
 net/ipv6/udp.c         |    4 +---
 net/sunrpc/svcsock.c   |   10 +++++-----
 5 files changed, 18 insertions(+), 12 deletions(-)

--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1761,6 +1761,8 @@ extern int	       skb_copy_datagram_cons
 						     int to_offset,
 						     int size);
 extern void	       skb_free_datagram(struct sock *sk, struct sk_buff *skb);
+extern void	       skb_free_datagram_locked(struct sock *sk,
+						struct sk_buff *skb);
 extern int	       skb_kill_datagram(struct sock *sk, struct sk_buff *skb,
 					 unsigned int flags);
 extern __wsum	       skb_checksum(const struct sk_buff *skb, int offset,
--- a/net/core/datagram.c
+++ b/net/core/datagram.c
@@ -223,6 +223,15 @@ void skb_free_datagram(struct sock *sk, 
 	consume_skb(skb);
 	sk_mem_reclaim_partial(sk);
 }
+EXPORT_SYMBOL(skb_free_datagram);
+
+void skb_free_datagram_locked(struct sock *sk, struct sk_buff *skb)
+{
+	lock_sock(sk);
+	skb_free_datagram(sk, skb);
+	release_sock(sk);
+}
+EXPORT_SYMBOL(skb_free_datagram_locked);
 
 /**
  *	skb_kill_datagram - Free a datagram skbuff forcibly
@@ -749,5 +758,4 @@ unsigned int datagram_poll(struct file *
 EXPORT_SYMBOL(datagram_poll);
 EXPORT_SYMBOL(skb_copy_and_csum_datagram_iovec);
 EXPORT_SYMBOL(skb_copy_datagram_iovec);
-EXPORT_SYMBOL(skb_free_datagram);
 EXPORT_SYMBOL(skb_recv_datagram);
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -987,9 +987,7 @@ try_again:
 		err = ulen;
 
 out_free:
-	lock_sock(sk);
-	skb_free_datagram(sk, skb);
-	release_sock(sk);
+	skb_free_datagram_locked(sk, skb);
 out:
 	return err;
 
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -288,9 +288,7 @@ try_again:
 		err = ulen;
 
 out_free:
-	lock_sock(sk);
-	skb_free_datagram(sk, skb);
-	release_sock(sk);
+	skb_free_datagram_locked(sk, skb);
 out:
 	return err;
 
--- a/net/sunrpc/svcsock.c
+++ b/net/sunrpc/svcsock.c
@@ -110,7 +110,7 @@ static void svc_release_skb(struct svc_r
 		rqstp->rq_xprt_ctxt = NULL;
 
 		dprintk("svc: service %p, releasing skb %p\n", rqstp, skb);
-		skb_free_datagram(svsk->sk_sk, skb);
+		skb_free_datagram_locked(svsk->sk_sk, skb);
 	}
 }
 
@@ -537,7 +537,7 @@ static int svc_udp_recvfrom(struct svc_r
 			printk("rpcsvc: received unknown control message:"
 			       "%d/%d\n",
 			       cmh->cmsg_level, cmh->cmsg_type);
-		skb_free_datagram(svsk->sk_sk, skb);
+		skb_free_datagram_locked(svsk->sk_sk, skb);
 		return 0;
 	}
 	svc_udp_get_dest_address(rqstp, cmh);
@@ -548,18 +548,18 @@ static int svc_udp_recvfrom(struct svc_r
 		if (csum_partial_copy_to_xdr(&rqstp->rq_arg, skb)) {
 			local_bh_enable();
 			/* checksum error */
-			skb_free_datagram(svsk->sk_sk, skb);
+			skb_free_datagram_locked(svsk->sk_sk, skb);
 			return 0;
 		}
 		local_bh_enable();
-		skb_free_datagram(svsk->sk_sk, skb);
+		skb_free_datagram_locked(svsk->sk_sk, skb);
 	} else {
 		/* we can use it in-place */
 		rqstp->rq_arg.head[0].iov_base = skb->data +
 			sizeof(struct udphdr);
 		rqstp->rq_arg.head[0].iov_len = len;
 		if (skb_checksum_complete(skb)) {
-			skb_free_datagram(svsk->sk_sk, skb);
+			skb_free_datagram_locked(svsk->sk_sk, skb);
 			return 0;
 		}
 		rqstp->rq_xprt_ctxt = skb;


