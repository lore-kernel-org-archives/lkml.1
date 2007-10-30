Return-Path: <linux-kernel-owner+w=401wt.eu-S1759483AbXJ3QX1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759483AbXJ3QX1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 12:23:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756880AbXJ3QPE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 12:15:04 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47079 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755975AbXJ3QON (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 12:14:13 -0400
Message-Id: <20071030160914.457853000@chello.nl>
References: <20071030160401.296770000@chello.nl>
User-Agent: quilt/0.45-1
Date: Tue, 30 Oct 2007 17:04:22 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, netdev@vger.kernel.org, trond.myklebust@fys.uio.no
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 21/33] netvm: prevent a TCP specific deadlock
Content-Disposition: inline; filename=netvm-tcp-deadlock.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

It could happen that all !SOCK_MEMALLOC sockets have buffered so much data
that we're over the global rmem limit. This will prevent SOCK_MEMALLOC buffers
from receiving data, which will prevent userspace from running, which is needed
to reduce the buffered data.

Fix this by exempting the SOCK_MEMALLOC sockets from the rmem limit.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/net/sock.h |    7 ++++---
 net/core/stream.c  |    5 +++--
 2 files changed, 7 insertions(+), 5 deletions(-)

Index: linux-2.6/include/net/sock.h
===================================================================
--- linux-2.6.orig/include/net/sock.h
+++ linux-2.6/include/net/sock.h
@@ -743,7 +743,8 @@ static inline struct inode *SOCK_INODE(s
 }
 
 extern void __sk_stream_mem_reclaim(struct sock *sk);
-extern int sk_stream_mem_schedule(struct sock *sk, int size, int kind);
+extern int sk_stream_mem_schedule(struct sock *sk, struct sk_buff *skb,
+		int size, int kind);
 
 #define SK_STREAM_MEM_QUANTUM ((int)PAGE_SIZE)
 
@@ -761,13 +762,13 @@ static inline void sk_stream_mem_reclaim
 static inline int sk_stream_rmem_schedule(struct sock *sk, struct sk_buff *skb)
 {
 	return (int)skb->truesize <= sk->sk_forward_alloc ||
-		sk_stream_mem_schedule(sk, skb->truesize, 1);
+		sk_stream_mem_schedule(sk, skb, skb->truesize, 1);
 }
 
 static inline int sk_stream_wmem_schedule(struct sock *sk, int size)
 {
 	return size <= sk->sk_forward_alloc ||
-	       sk_stream_mem_schedule(sk, size, 0);
+	       sk_stream_mem_schedule(sk, NULL, size, 0);
 }
 
 /* Used by processes to "lock" a socket state, so that
Index: linux-2.6/net/core/stream.c
===================================================================
--- linux-2.6.orig/net/core/stream.c
+++ linux-2.6/net/core/stream.c
@@ -207,7 +207,7 @@ void __sk_stream_mem_reclaim(struct sock
 
 EXPORT_SYMBOL(__sk_stream_mem_reclaim);
 
-int sk_stream_mem_schedule(struct sock *sk, int size, int kind)
+int sk_stream_mem_schedule(struct sock *sk, struct sk_buff *skb, int size, int kind)
 {
 	int amt = sk_stream_pages(size);
 
@@ -224,7 +224,8 @@ int sk_stream_mem_schedule(struct sock *
 	/* Over hard limit. */
 	if (atomic_read(sk->sk_prot->memory_allocated) > sk->sk_prot->sysctl_mem[2]) {
 		sk->sk_prot->enter_memory_pressure();
-		goto suppress_allocation;
+		if (!skb || (skb && !skb_emergency(skb)))
+			goto suppress_allocation;
 	}
 
 	/* Under pressure. */

--

