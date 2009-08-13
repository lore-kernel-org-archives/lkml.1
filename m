Return-Path: <linux-kernel-owner+w=401wt.eu-S1756047AbZHMUOa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756047AbZHMUOa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 16:14:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755843AbZHMT7R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 15:59:17 -0400
Received: from kroah.org ([198.145.64.141]:41647 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755698AbZHMT7O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 15:59:14 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Aug 13 12:51:25 2009
Message-Id: <20090813195125.668127635@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 13 Aug 2009 12:49:42 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Eric Dumazet <eric.dumazet@gmail.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 07/74] net: sk_prot_alloc() should not blindly overwrite memory
References: <20090813194935.985368088@mini.kroah.org>
Content-Disposition: inline; filename=net-sk_prot_alloc-should-not-blindly-overwrite-memory.patch
In-Reply-To: <20090813195705.GA22393@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Eric Dumazet <eric.dumazet@gmail.com>

[ Upstream commit e912b1142be8f1e2c71c71001dc992c6e5eb2ec1 ]

Some sockets use SLAB_DESTROY_BY_RCU, and our RCU code correctness
depends on sk->sk_nulls_node.next being always valid. A NULL
value is not allowed as it might fault a lockless reader.

Current sk_prot_alloc() implementation doesnt respect this hypothesis,
calling kmem_cache_alloc() with __GFP_ZERO. Just call memset() around
the forbidden field.

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/core/sock.c |   19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -935,8 +935,23 @@ static struct sock *sk_prot_alloc(struct
 	struct kmem_cache *slab;
 
 	slab = prot->slab;
-	if (slab != NULL)
-		sk = kmem_cache_alloc(slab, priority);
+	if (slab != NULL) {
+		sk = kmem_cache_alloc(slab, priority & ~__GFP_ZERO);
+		if (!sk)
+			return sk;
+		if (priority & __GFP_ZERO) {
+			/*
+			 * caches using SLAB_DESTROY_BY_RCU should let
+			 * sk_node.next un-modified. Special care is taken
+			 * when initializing object to zero.
+			 */
+			if (offsetof(struct sock, sk_node.next) != 0)
+				memset(sk, 0, offsetof(struct sock, sk_node.next));
+			memset(&sk->sk_node.pprev, 0,
+			       prot->obj_size - offsetof(struct sock,
+							 sk_node.pprev));
+		}
+	}
 	else
 		sk = kmalloc(prot->obj_size, priority);
 


