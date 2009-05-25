Return-Path: <linux-kernel-owner+w=401wt.eu-S1758294AbZEYBSt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758294AbZEYBSt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 21:18:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753756AbZEYBSl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 21:18:41 -0400
Received: from oblivion.subreption.com ([66.240.236.22]:55187 "EHLO
	mail.subreption.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752033AbZEYBSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 21:18:40 -0400
Date: Sun, 24 May 2009 18:17:24 -0700
From: "Larry H." <research@subreption.com>
To: Rik van Riel <riel@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@osdl.org>, linux-mm@kvack.org,
       Ingo Molnar <mingo@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       pageexec@freemail.hu
Subject: [PATCH] Sanitize memory on kfree() and kmem_cache_free()
Message-ID: <20090525011724.GS13971@oblivion.subreption.com>
References: <20090520183045.GB10547@oblivion.subreption.com> <4A15A8C7.2030505@redhat.com> <20090522073436.GA3612@elte.hu> <20090522113809.GB13971@oblivion.subreption.com> <20090523124944.GA23042@elte.hu> <4A187BDE.5070601@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A187BDE.5070601@redhat.com>
Organization: Subreption LLC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Was Re: [patch 0/5] Support for sanitization flag in low-level page
allocator)

On 18:42 Sat 23 May     , Rik van Riel wrote:
> Ingo Molnar wrote:
>
>> What you are missing is that your patch makes _no technical sense_ if you 
>> allow the same information to leak over the kernel stack. Kernel stacks 
>> can be freed and reused, swapped out and thus 'exposed'.
>
> Kernel stacks may be freed and reused, but Larry's latest
> patch takes care of that by clearing them at page free
> time.

[PATCH] Sanitize memory on kfree() and kmem_cache_free()

This depends on the previous sanitize-mem.patch and implements object
clearing for SLAB and SLUB. Only the SLUB allocator has been tested,
and this patch successfully enforces clearing on kfree() for both
standard caches and private ones (through kmem_cache_free()).

The following test results can be observed when this patch is applied
along sanitize-mem:

   Name 	  Result 	 Object
  ---------------------------------------
   get_free_page 	OK. 	 e4011000
       vmalloc(256) 	OK. 	 e632e000
      vmalloc(2048) 	OK. 	 e6331000
      vmalloc(4096) 	OK. 	 e6334000
      vmalloc(8192) 	OK. 	 e6337000
     vmalloc(32768) 	OK. 	 e633b000
         kmalloc-32 	OK. 	 e5009904
         kmalloc-64 	OK. 	 e404bc04
         kmalloc-96 	OK. 	 e5230b44
        kmalloc-128 	OK. 	 e5221f84
        kmalloc-256 	OK. 	 e4104304
        kmalloc-512 	OK. 	 e40a9804
       kmalloc-1024 	OK. 	 e5137404
       kmalloc-2048 	OK. 	 e5277004
       kmalloc-4096 	OK. 	 e415c004
       kmalloc-8192 	OK. 	 e4092004

Without both:

   Name 	  Result 	 Object
  ---------------------------------------
   get_free_page 	FAILED. 	 e412d000
       vmalloc(256) 	FAILED. 	 e6020000
      vmalloc(2048) 	FAILED. 	 e6023000
      vmalloc(4096) 	FAILED. 	 e6026000
      vmalloc(8192) 	FAILED. 	 e6029000
     vmalloc(32768) 	FAILED. 	 e602d000
         kmalloc-32 	FAILED. 	 e5009924
         kmalloc-64 	FAILED. 	 e5146fc4
         kmalloc-96 	FAILED. 	 e5320d84
        kmalloc-128 	FAILED. 	 e5019484
        kmalloc-256 	FAILED. 	 e4128104
        kmalloc-512 	FAILED. 	 e40df804
       kmalloc-1024 	FAILED. 	 e4a36c04
       kmalloc-2048 	FAILED. 	 e4159004
       kmalloc-4096 	FAILED. 	 e417f004
       kmalloc-8192 	FAILED. 	 e4180004

It takes care of handling empty slabs by ignoring them to avoid
duplication of the clearing operation. In addition, it performs
basic validation of the object and cache pointers, since it is
lacking for kmem_cache_free(). Furthermore, when a cache has
poisoning enabled (SLAB_POISON), the clearing process is skipped,
since poisoning itself will overwrite the object's contents with
a known pattern.

Signed-off-by: Larry Highsmith <research@subreption.com>

---
 mm/slab.c |    9 +++++++++
 mm/slub.c |   32 ++++++++++++++++++++++++++++++++
 2 files changed, 41 insertions(+)

Index: linux-2.6/mm/slab.c
===================================================================
--- linux-2.6.orig/mm/slab.c
+++ linux-2.6/mm/slab.c
@@ -3520,6 +3520,15 @@ static inline void __cache_free(struct k
 	objp = cache_free_debugcheck(cachep, objp, __builtin_return_address(0));
 
 	/*
+	 * If unconditional memory sanitization is enabled, the object is
+	 * cleared before it's put back into the cache. Using obj_offset and
+	 * obj_size we can coexist with the debugging (redzone, poisoning, etc)
+	 * facilities.
+	 */
+	if (sanitize_all_mem)
+		memset(objp + obj_offset(cachep), 0, obj_size(cachep));
+
+	/*
 	 * Skip calling cache_free_alien() when the platform is not numa.
 	 * This will avoid cache misses that happen while accessing slabp (which
 	 * is per page memory  reference) to get nodeid. Instead use a global
Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c
+++ linux-2.6/mm/slub.c
@@ -1269,6 +1269,36 @@ static inline int lock_and_freeze_slab(s
 }
 
 /*
+ * Slab object sanitization
+ */
+static void sanitize_slab_obj(struct kmem_cache *s, struct page *page, void *object)
+{
+	if (!sanitize_all_mem)
+		return;
+
+	/* SLAB_POISON makes clearing unnecessary */
+	if (s->offset || unlikely(s->flags & SLAB_POISON))
+		return;
+
+	/*
+	 * The slab is empty, it will be returned to page allocator by
+	 * discard_slab()->__slab_free(). It will be cleared there, thus
+	 * we skip it here.
+	 */
+	if (unlikely(!page->inuse))
+		return;
+
+	/* Validate that pointer indeed belongs to slab page */
+	if (!PageSlab(page) || (page->slab != s))
+		return;
+
+	if (!check_valid_pointer(s, page, object))
+		return;
+
+	memset(object, 0, s->objsize);
+}
+
+/*
  * Try to allocate a partial slab from a specific node.
  */
 static struct page *get_partial_node(struct kmem_cache_node *n)
@@ -1741,6 +1771,7 @@ void kmem_cache_free(struct kmem_cache *
 
 	page = virt_to_head_page(x);
 
+	sanitize_slab_obj(s, page, x);
 	slab_free(s, page, x, _RET_IP_);
 }
 EXPORT_SYMBOL(kmem_cache_free);
@@ -2752,6 +2783,7 @@ void kfree(const void *x)
 		put_page(page);
 		return;
 	}
+	sanitize_slab_obj(page->slab, page, object);
 	slab_free(page->slab, page, object, _RET_IP_);
 }
 EXPORT_SYMBOL(kfree);

