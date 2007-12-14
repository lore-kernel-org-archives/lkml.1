Return-Path: <linux-kernel-owner+w=401wt.eu-S1759470AbXLNTcO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759470AbXLNTcO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 14:32:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758748AbXLNTYp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 14:24:45 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:38874 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754751AbXLNTXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 14:23:35 -0500
Message-Id: <20071214154441.728241000@chello.nl>
References: <20071214153907.770251000@chello.nl>
User-Agent: quilt/0.45-1
Date: Fri, 14 Dec 2007 16:39:26 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, netdev@vger.kernel.org, trond.myklebust@fys.uio.no
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 19/29] netvm: prevent a TCP specific deadlock
Content-Disposition: inline; filename=netvm-tcp-deadlock.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
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
@@ -756,7 +756,8 @@ static inline struct inode *SOCK_INODE(s
 }
 
 extern void __sk_stream_mem_reclaim(struct sock *sk);
-extern int sk_stream_mem_schedule(struct sock *sk, int size, int kind);
+extern int sk_stream_mem_schedule(struct sock *sk, struct sk_buff *skb,
+		int size, int kind);
 
 #define SK_STREAM_MEM_QUANTUM ((int)PAGE_SIZE)
 
@@ -774,13 +775,13 @@ static inline void sk_stream_mem_reclaim
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
 	struct proto *prot = sk->sk_prot;
@@ -225,7 +225,8 @@ int sk_stream_mem_schedule(struct sock *
 	/* Over hard limit. */
 	if (atomic_read(prot->memory_allocated) > prot->sysctl_mem[2]) {
 		prot->enter_memory_pressure();
-		goto suppress_allocation;
+		if (!skb || (skb && !skb_emergency(skb)))
+			goto suppress_allocation;
 	}
 
 	/* Under pressure. */

--

