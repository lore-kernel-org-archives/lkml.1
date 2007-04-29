Return-Path: <linux-kernel-owner+w=401wt.eu-S1755153AbXD2LJD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755153AbXD2LJD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 07:09:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756372AbXD2LIo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 07:08:44 -0400
Received: from py-out-1112.google.com ([64.233.166.176]:10684 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756350AbXD2LIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 07:08:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mail-followup-to:mime-version:content-type:content-disposition:user-agent;
        b=BXpW6pfuJG5r8pfiJYjiBxmSwEnolk/BAjWlllfTjK9SRk2gMfpP/WcvgsawOkE0/4cCKJo6XlknUknP4AKbIj1b34RhZOKsomIt8ytyLj8+HysUTaLLMw8l4n0p1NvqTGdHmO996op/N/y0jTrE7cGL0cEXmhnDJ3CiVs22cmM=
Date: Sun, 29 Apr 2007 20:02:49 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Matt Mackall <mpm@selenic.com>
Subject: [PATCH] slob: fix page order calculation on not 4KB page
Message-ID: <20070429110249.GA12187@APFDCB5C>
Mail-Followup-To: Akinobu Mita <akinobu.mita@gmail.com>,
	linux-kernel@vger.kernel.org, Matt Mackall <mpm@selenic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

SLOB doesn't caluclate correct page order when page size is not 4KB.
This patch fixes it with using get_order() instead of find_order()
which is SLOB version of get_order().

Cc: Matt Mackall <mpm@selenic.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>

Index: 2.6-mm/mm/slob.c
===================================================================
--- 2.6-mm.orig/mm/slob.c
+++ 2.6-mm/mm/slob.c
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
@@ -318,7 +309,7 @@ void *kmem_cache_alloc(struct kmem_cache
 	if (c->size < PAGE_SIZE)
 		b = slob_alloc(c->size, flags, c->align);
 	else
-		b = (void *)__get_free_pages(flags, find_order(c->size));
+		b = (void *)__get_free_pages(flags, get_order(c->size));
 
 	if (c->ctor)
 		c->ctor(b, c, SLAB_CTOR_CONSTRUCTOR);
@@ -345,7 +336,7 @@ void kmem_cache_free(struct kmem_cache *
 	if (c->size < PAGE_SIZE)
 		slob_free(b, c->size);
 	else
-		free_pages((unsigned long)b, find_order(c->size));
+		free_pages((unsigned long)b, get_order(c->size));
 }
 EXPORT_SYMBOL(kmem_cache_free);
 
