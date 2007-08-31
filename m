Return-Path: <linux-kernel-owner+w=401wt.eu-S1757871AbXHaHsz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757871AbXHaHsz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 03:48:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753556AbXHaHsq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 03:48:46 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:34533 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753127AbXHaHsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 03:48:45 -0400
Date: Fri, 31 Aug 2007 00:48:45 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Jan Dittmer <jdi@l4x.org>, Adrian Bunk <bunk@kernel.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-alpha@vger.kernel.org
Subject: Re: [1/4] 2.6.23-rc4: known regressions
In-Reply-To: <46D7108D.9090104@l4x.org>
Message-ID: <Pine.LNX.4.64.0708310043250.14694@schroedinger.engr.sgi.com>
References: <46D5902C.1040905@googlemail.com> <46D5B544.4030708@l4x.org>
 <20070829234734.GA26410@stusta.de> <Pine.LNX.4.64.0708291736010.4526@schroedinger.engr.sgi.com>
 <46D66D49.20300@l4x.org> <Pine.LNX.4.64.0708301112030.7975@schroedinger.engr.sgi.com>
 <46D7108D.9090104@l4x.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here is the fix for alpha:



>From clameter@sgi.com Thu Aug 30 14:13:57 2007
Subject: SLUB: Force inlining for functions in slub_def.h

Some compilers (especially older gcc releases) may skip inlining sometimes 
which will lead to link failures. Force the inlining of keyfunctions in 
slub_def.h to avoid these issues.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Acked-by: Jan Dittmer <jdi@l4x.org>

---
 include/linux/slub_def.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: linux-2.6/include/linux/slub_def.h
===================================================================
--- linux-2.6.orig/include/linux/slub_def.h	2007-08-30 14:12:25.000000000 -0700
+++ linux-2.6/include/linux/slub_def.h	2007-08-30 14:13:07.000000000 -0700
@@ -78,7 +78,7 @@ extern struct kmem_cache kmalloc_caches[
  * Sorry that the following has to be that ugly but some versions of GCC
  * have trouble with constant propagation and loops.
  */
-static inline int kmalloc_index(size_t size)
+static __always_inline int kmalloc_index(size_t size)
 {
 	if (!size)
 		return 0;
@@ -133,7 +133,7 @@ static inline int kmalloc_index(size_t s
  * This ought to end up with a global pointer to the right cache
  * in kmalloc_caches.
  */
-static inline struct kmem_cache *kmalloc_slab(size_t size)
+static __always_inline struct kmem_cache *kmalloc_slab(size_t size)
 {
 	int index = kmalloc_index(size);
 
@@ -166,7 +166,7 @@ static inline struct kmem_cache *kmalloc
 void *kmem_cache_alloc(struct kmem_cache *, gfp_t);
 void *__kmalloc(size_t size, gfp_t flags);
 
-static inline void *kmalloc(size_t size, gfp_t flags)
+static __always_inline void *kmalloc(size_t size, gfp_t flags)
 {
 	if (__builtin_constant_p(size) && !(flags & SLUB_DMA)) {
 		struct kmem_cache *s = kmalloc_slab(size);
@@ -183,7 +183,7 @@ static inline void *kmalloc(size_t size,
 void *__kmalloc_node(size_t size, gfp_t flags, int node);
 void *kmem_cache_alloc_node(struct kmem_cache *, gfp_t flags, int node);
 
-static inline void *kmalloc_node(size_t size, gfp_t flags, int node)
+static __always_inline void *kmalloc_node(size_t size, gfp_t flags, int node)
 {
 	if (__builtin_constant_p(size) && !(flags & SLUB_DMA)) {
 		struct kmem_cache *s = kmalloc_slab(size);
