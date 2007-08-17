Return-Path: <linux-kernel-owner+w=401wt.eu-S1761391AbXHQSXi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761391AbXHQSXi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 14:23:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752779AbXHQSX1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 14:23:27 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46107 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751897AbXHQSXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 14:23:25 -0400
Date: Fri, 17 Aug 2007 11:22:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Satyam Sharma <satyam@infradead.org>
Cc: Arjan van de Ven <arjan@infradead.org>, Tim Bird <tim.bird@am.sony.com>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: kfree(0) - ok?
Message-Id: <20070817112253.e6a7cb33.akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0708150454480.6482@enigma.security.iitk.ac.in>
References: <46C233CB.9000602@am.sony.com>
	<1187132149.2618.2.camel@laptopd505.fenrus.org>
	<alpine.LFD.0.999.0708150454480.6482@enigma.security.iitk.ac.in>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Aug 2007 05:12:41 +0530 (IST)
Satyam Sharma <satyam@infradead.org> wrote:

> [PATCH] {slub, slob}: use unlikely() for kfree(ZERO_OR_NULL_PTR) check
> 
> Considering kfree(NULL) would normally occur only in error paths and
> kfree(ZERO_SIZE_PTR) is uncommon as well, so let's use unlikely() for
> the condition check in SLUB's and SLOB's kfree() to optimize for the
> common case. SLAB has this already.

I went through my current versions of slab/slub/slub and came up with this:

diff -puN mm/slob.c~slub-slob-use-unlikely-for-kfreezero_or_null_ptr-check mm/slob.c
--- a/mm/slob.c~slub-slob-use-unlikely-for-kfreezero_or_null_ptr-check
+++ a/mm/slob.c
@@ -360,7 +360,7 @@ static void slob_free(void *block, int s
 	slobidx_t units;
 	unsigned long flags;
 
-	if (ZERO_OR_NULL_PTR(block))
+	if (unlikely(ZERO_OR_NULL_PTR(block)))
 		return;
 	BUG_ON(!size);
 
@@ -466,7 +466,7 @@ void kfree(const void *block)
 {
 	struct slob_page *sp;
 
-	if (ZERO_OR_NULL_PTR(block))
+	if (unlikely(ZERO_OR_NULL_PTR(block)))
 		return;
 
 	sp = (struct slob_page *)virt_to_page(block);
@@ -484,7 +484,7 @@ size_t ksize(const void *block)
 {
 	struct slob_page *sp;
 
-	if (ZERO_OR_NULL_PTR(block))
+	if (unlikely(ZERO_OR_NULL_PTR(block)))
 		return 0;
 
 	sp = (struct slob_page *)virt_to_page(block);
diff -puN mm/slub.c~slub-slob-use-unlikely-for-kfreezero_or_null_ptr-check mm/slub.c
--- a/mm/slub.c~slub-slob-use-unlikely-for-kfreezero_or_null_ptr-check
+++ a/mm/slub.c
@@ -2434,7 +2434,7 @@ size_t ksize(const void *object)
 	struct page *page;
 	struct kmem_cache *s;
 
-	if (ZERO_OR_NULL_PTR(object))
+	if (unlikely(ZERO_OR_NULL_PTR(object)))
 		return 0;
 
 	page = get_object_page(object);
@@ -2468,7 +2468,7 @@ void kfree(const void *x)
 {
 	struct page *page;
 
-	if (ZERO_OR_NULL_PTR(x))
+	if (unlikely(ZERO_OR_NULL_PTR(x)))
 		return;
 
 	page = virt_to_head_page(x);
@@ -2785,7 +2785,7 @@ void *__kmalloc_track_caller(size_t size
 							get_order(size));
 	s = get_slab(size, gfpflags);
 
-	if (ZERO_OR_NULL_PTR(s))
+	if (unlikely(ZERO_OR_NULL_PTR(s)))
 		return s;
 
 	return slab_alloc(s, gfpflags, -1, caller);
@@ -2801,7 +2801,7 @@ void *__kmalloc_node_track_caller(size_t
 							get_order(size));
 	s = get_slab(size, gfpflags);
 
-	if (ZERO_OR_NULL_PTR(s))
+	if (unlikely(ZERO_OR_NULL_PTR(s)))
 		return s;
 
 	return slab_alloc(s, gfpflags, node, caller);
_

Which is getting pretty idiotic:

akpm:/usr/src/25> grep ZERO_OR_NULL_PTR */*.c
mm/slab.c:              BUG_ON(ZERO_OR_NULL_PTR(cachep->slabp_cache));
mm/slab.c:      if (unlikely(ZERO_OR_NULL_PTR(cachep)))
mm/slab.c:      if (unlikely(ZERO_OR_NULL_PTR(cachep)))
mm/slab.c:      if (unlikely(ZERO_OR_NULL_PTR(objp)))
mm/slab.c:      if (unlikely(ZERO_OR_NULL_PTR(objp)))
mm/slob.c:      if (unlikely(ZERO_OR_NULL_PTR(block)))
mm/slob.c:      if (unlikely(ZERO_OR_NULL_PTR(block)))
mm/slob.c:      if (unlikely(ZERO_OR_NULL_PTR(block)))
mm/slub.c:      if (unlikely(ZERO_OR_NULL_PTR(s)))
mm/slub.c:      if (unlikely(ZERO_OR_NULL_PTR(s)))
mm/slub.c:      if (unlikely(ZERO_OR_NULL_PTR(object)))
mm/slub.c:      if (unlikely(ZERO_OR_NULL_PTR(x)))
mm/slub.c:      if (unlikely(ZERO_OR_NULL_PTR(s)))
mm/slub.c:      if (unlikely(ZERO_OR_NULL_PTR(s)))

are we seeing a pattern here?  We could stick the unlikely inside
ZERO_OR_NULL_PTR() itself.  That's a little bit sleazy though - there might
be future callsites at which it is likely, who knows?

I guess we can stick with the idiotic patch ;)
