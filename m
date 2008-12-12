Return-Path: <linux-kernel-owner+w=401wt.eu-S1757515AbYLLAbo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757515AbYLLAbo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 19:31:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756335AbYLLAbe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 19:31:34 -0500
Received: from mail.suse.de ([195.135.220.2]:52188 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756201AbYLLAbc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 19:31:32 -0500
Date: Fri, 12 Dec 2008 01:31:30 +0100
From: Nick Piggin <npiggin@suse.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>
Subject: [rfc][patch] mm: kfree_size
Message-ID: <20081212003130.GA24497@wotan.suse.de>
References: <20081212002518.GH8294@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081212002518.GH8294@wotan.suse.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Introduce kfree_size(). Some allocators can do a better job at kfree if the
size of the freed object is known in advance. skb layer in the networking
stack can use kfree intensively, and in that case, the size information should
be hot in cache, so it should be a win to use kfree_size here.

Allocators which don't care so much could just define kfree_size to kfree.

Thoughts? Any other good candidate callers?

---
 include/linux/slqb_def.h |   15 +++++++++++++++
 mm/slqb.c                |   12 ++++++++++++
 net/core/skbuff.c        |    7 ++++++-
 3 files changed, 33 insertions(+), 1 deletion(-)

Index: linux-2.6/include/linux/slqb_def.h
===================================================================
--- linux-2.6.orig/include/linux/slqb_def.h
+++ linux-2.6/include/linux/slqb_def.h
@@ -222,6 +222,21 @@ void *__kmalloc(size_t size, gfp_t flags
 
 #define KMALLOC_HEADER (ARCH_KMALLOC_MINALIGN < sizeof(void *) ? sizeof(void *) : ARCH_KMALLOC_MINALIGN)
 
+void __kfree_size(const void *mem, size_t size);
+static __always_inline void kfree_size(void *mem, size_t size)
+{
+	if (__builtin_constant_p(size)) {
+		struct kmem_cache *s;
+
+		s = kmalloc_slab(size, 0);
+		if (unlikely(ZERO_OR_NULL_PTR(s)))
+			return;
+
+		kmem_cache_free(s, mem);
+	}
+	__kfree_size(mem, size);
+}
+
 static __always_inline void *kmalloc(size_t size, gfp_t flags)
 {
 	if (__builtin_constant_p(size)) {
Index: linux-2.6/mm/slqb.c
===================================================================
--- linux-2.6.orig/mm/slqb.c
+++ linux-2.6/mm/slqb.c
@@ -2118,6 +2118,18 @@ void *__kmalloc_node(size_t size, gfp_t
 EXPORT_SYMBOL(__kmalloc_node);
 #endif
 
+void __kfree_size(const void *mem, size_t size)
+{
+	struct kmem_cache *s;
+
+	s = get_slab(size, 0);
+
+	if (unlikely(ZERO_OR_NULL_PTR(s)))
+		return;
+
+	kmem_cache_free(s, mem);
+}
+
 size_t ksize(const void *object)
 {
 	struct slqb_page *page;
Index: linux-2.6/net/core/skbuff.c
===================================================================
--- linux-2.6.orig/net/core/skbuff.c
+++ linux-2.6/net/core/skbuff.c
@@ -336,6 +336,11 @@ static void skb_release_data(struct sk_b
 	if (!skb->cloned ||
 	    !atomic_sub_return(skb->nohdr ? (1 << SKB_DATAREF_SHIFT) + 1 : 1,
 			       &skb_shinfo(skb)->dataref)) {
+#ifdef NET_SKBUFF_DATA_USES_OFFSET
+		int size = skb->end;
+#else
+		int size = skb->end - skb->head;
+#endif
 		if (skb_shinfo(skb)->nr_frags) {
 			int i;
 			for (i = 0; i < skb_shinfo(skb)->nr_frags; i++)
@@ -345,7 +350,7 @@ static void skb_release_data(struct sk_b
 		if (skb_shinfo(skb)->frag_list)
 			skb_drop_fraglist(skb);
 
-		kfree(skb->head);
+		kfree_size(skb->head, size);
 	}
 }
 
