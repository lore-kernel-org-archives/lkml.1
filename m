Return-Path: <linux-kernel-owner+w=401wt.eu-S934138AbXEUTae@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934138AbXEUTae (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 15:30:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764703AbXEUTVq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 15:21:46 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:46400 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765429AbXEUTVp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 15:21:45 -0400
Message-Id: <20070521191710.026899000@sous-sol.org>
References: <20070521191612.800400000@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Mon, 21 May 2007 12:16:27 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       torvalds@linux-foundation.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       akinobu.mita@gmail.com, mpm@selenic.com
Subject: [patch 15/69] slob: fix page order calculation on not 4KB page
Content-Disposition: inline; filename=slob-fix-page-order-calculation-on-not-4kb-page.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Akinobu Mita <akinobu.mita@gmail.com>

SLOB doesn't calculate correct page order when page size is not 4KB.  This
patch fixes it with using get_order() instead of find_order() which is SLOB
version of get_order().

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Acked-by: Matt Mackall <mpm@selenic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---

 mm/slob.c |   15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

--- linux-2.6.21.1.orig/mm/slob.c
+++ linux-2.6.21.1/mm/slob.c
@@ -150,15 +150,6 @@ static void slob_free(void *block, int s
 	spin_unlock_irqrestore(&slob_lock, flags);
 }
 
-static int FASTCALL(find_order(int size));
-static int fastcall find_order(int size)
-{
-	int order = 0;
-	for ( ; size > 4096 ; size >>=1)
-		order++;
-	return order;
-}
-
 void *__kmalloc(size_t size, gfp_t gfp)
 {
 	slob_t *m;
@@ -174,7 +165,7 @@ void *__kmalloc(size_t size, gfp_t gfp)
 	if (!bb)
 		return 0;
 
-	bb->order = find_order(size);
+	bb->order = get_order(size);
 	bb->pages = (void *)__get_free_pages(gfp, bb->order);
 
 	if (bb->pages) {
@@ -284,7 +275,7 @@ void *kmem_cache_alloc(struct kmem_cache
 	if (c->size < PAGE_SIZE)
 		b = slob_alloc(c->size, flags, c->align);
 	else
-		b = (void *)__get_free_pages(flags, find_order(c->size));
+		b = (void *)__get_free_pages(flags, get_order(c->size));
 
 	if (c->ctor)
 		c->ctor(b, c, SLAB_CTOR_CONSTRUCTOR);
@@ -311,7 +302,7 @@ void kmem_cache_free(struct kmem_cache *
 	if (c->size < PAGE_SIZE)
 		slob_free(b, c->size);
 	else
-		free_pages((unsigned long)b, find_order(c->size));
+		free_pages((unsigned long)b, get_order(c->size));
 }
 EXPORT_SYMBOL(kmem_cache_free);
 

-- 
