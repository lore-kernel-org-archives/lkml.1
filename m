Return-Path: <linux-kernel-owner+w=401wt.eu-S932382AbXDFTqm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932382AbXDFTqm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 15:46:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932406AbXDFTql
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 15:46:41 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:40805 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932382AbXDFTqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 15:46:40 -0400
Date: Fri, 6 Apr 2007 12:46:39 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Hugh Dickins <hugh@veritas.com>, Nick Piggin <npiggin@suse.de>,
       dgc@sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Make page->private usable in compound pages V1
In-Reply-To: <20070405164300.a5d24329.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0704061245210.23939@schroedinger.engr.sgi.com>
References: <20070405223651.21698.77505.sendpatchset@schroedinger.engr.sgi.com>
 <20070405164300.a5d24329.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Apr 2007, Andrew Morton wrote:

> A new virt_to_head_page() is needed.

Add virt_to_head_page and consolidate code in slab and slub.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

Index: linux-2.6.21-rc5-mm4/include/linux/mm.h
===================================================================
--- linux-2.6.21-rc5-mm4.orig/include/linux/mm.h	2007-04-06 19:35:51.000000000 +0000
+++ linux-2.6.21-rc5-mm4/include/linux/mm.h	2007-04-06 19:42:53.000000000 +0000
@@ -316,6 +316,12 @@
 	atomic_inc(&page->_count);
 }
 
+static inline struct page *virt_to_head_page(const void *x)
+{
+	struct page *page = virt_to_page(x);
+	return compound_head(page);
+}
+
 /*
  * Setup the page count before being freed into the page allocator for
  * the first time (boot or memory hotplug)
Index: linux-2.6.21-rc5-mm4/mm/slab.c
===================================================================
--- linux-2.6.21-rc5-mm4.orig/mm/slab.c	2007-04-06 19:38:58.000000000 +0000
+++ linux-2.6.21-rc5-mm4/mm/slab.c	2007-04-06 19:41:57.000000000 +0000
@@ -614,20 +614,19 @@
 
 static inline struct slab *page_get_slab(struct page *page)
 {
-	page = compound_head(page);
 	BUG_ON(!PageSlab(page));
 	return (struct slab *)page->lru.prev;
 }
 
 static inline struct kmem_cache *virt_to_cache(const void *obj)
 {
-	struct page *page = virt_to_page(obj);
+	struct page *page = virt_to_head_page(obj);
 	return page_get_cache(page);
 }
 
 static inline struct slab *virt_to_slab(const void *obj)
 {
-	struct page *page = virt_to_page(obj);
+	struct page *page = virt_to_head_page(obj);
 	return page_get_slab(page);
 }
 
@@ -2884,7 +2883,7 @@
 
 	objp -= obj_offset(cachep);
 	kfree_debugcheck(objp);
-	page = virt_to_page(objp);
+	page = virt_to_head_page(objp);
 
 	slabp = page_get_slab(page);
 
@@ -3108,7 +3107,7 @@
 		struct slab *slabp;
 		unsigned objnr;
 
-		slabp = page_get_slab(virt_to_page(objp));
+		slabp = page_get_slab(virt_to_head_page(objp));
 		objnr = (unsigned)(objp - slabp->s_mem) / cachep->buffer_size;
 		slab_bufctl(slabp)[objnr] = BUFCTL_ACTIVE;
 	}
Index: linux-2.6.21-rc5-mm4/mm/slub.c
===================================================================
--- linux-2.6.21-rc5-mm4.orig/mm/slub.c	2007-04-06 19:37:49.000000000 +0000
+++ linux-2.6.21-rc5-mm4/mm/slub.c	2007-04-06 19:38:56.000000000 +0000
@@ -1297,9 +1297,7 @@
 {
 	struct page * page;
 
-	page = virt_to_page(x);
-
-	page = compound_head(page);
+	page = virt_to_head_page(x);
 
 	if (unlikely(PageError(page) && (s->flags & SLAB_STORE_USER)))
 		set_tracking(s, x, 1);
@@ -1310,7 +1308,7 @@
 /* Figure out on which slab object the object resides */
 static struct page *get_object_page(const void *x)
 {
-	struct page *page = compound_head(virt_to_page(x));
+	struct page *page = virt_to_head_page(x);
 
 	if (!PageSlab(page))
 		return NULL;
@@ -1952,7 +1950,7 @@
 	if (!x)
 		return;
 
-	page = compound_head(virt_to_page(x));
+	page = virt_to_head_page(x);
 
 	s = page->slab;
 
@@ -1988,7 +1986,7 @@
 		return NULL;
 	}
 
-	page = compound_head(virt_to_page(p));
+	page = virt_to_head_page(p);
 
 	new_cache = get_slab(new_size, flags);
 
