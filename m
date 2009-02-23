Return-Path: <linux-kernel-owner+w=401wt.eu-S1754182AbZBWJOn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182AbZBWJOn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 04:14:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752079AbZBWJOf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 04:14:35 -0500
Received: from smtp109.mail.mud.yahoo.com ([209.191.85.219]:23404 "HELO
	smtp109.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752011AbZBWJOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 04:14:34 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=X5nGeCAn3FxpUxQzW1T9Xg+J7sCN7A6uzZYEwQmE7K+YgJdF4ZPkQfXmHef4h7/b6Kg0FZzfH9Sks2ZmlEakPWPuiwglKV+5pSyTgZEzZBKlLNjZe4fPQRiAceMY1LyOtcIJ19Yd5qpyNNCxWn1np1vtakY8pB/YToZUM/vLJVA=  ;
X-YMail-OSG: ozVbXDUVM1l0UO6l0.Z1JWDhBJ5mrxCWcXQQCfsVKqZKiIg1tCFiHyMF32lUyr6f8fnsJPv6T8ynDt2lmCmURMjSTfumGW2gJMu.pRAtrk.AOfpbcuy8gf6o5pHbLx4z9KCAV_ZHO6Z9bTtUOeIIs2bY6ecj6cvw4IwZ9nE4GOmJsROsaxPbVGeWX5BiEw--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH RFC] vm_unmap_aliases: allow callers to inhibit TLB flush
Date: Mon, 23 Feb 2009 20:13:42 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       "the arch/x86 maintainers" <x86@kernel.org>,
       Arjan van de Ven <arjan@linux.intel.com>
References: <49416494.6040009@goop.org> <200902231514.01965.nickpiggin@yahoo.com.au> <49A25086.30606@goop.org>
In-Reply-To: <49A25086.30606@goop.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200902232013.43054.nickpiggin@yahoo.com.au>
Content-Type: text/plain;
  charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id n1N9ElwM019971

On Monday 23 February 2009 18:30:14 Jeremy Fitzhardinge wrote:> Nick Piggin wrote:> > On Friday 20 February 2009 06:11:32 Jeremy Fitzhardinge wrote:> >> Nick Piggin wrote:> >>> Then what is the point of the vm_unmap_aliases? If you are doing it> >>> for security it won't work because other CPUs might still be able> >>> to write through dangling TLBs. If you are not doing it for> >>> security then it does not need to be done at all.> >>> >> Xen will make sure any danging tlb entries are flushed before handing> >> the page out to anyone else.> >>> >>> Unless it is something strange that Xen does with the page table> >>> structure and you just need to get rid of those?> >>> >> Yeah.  A pte pointing at a page holds a reference on it, saying that it> >> belongs to the domain.  You can't return it to Xen until the refcount is> >> 0.> >> > OK. Then I will remember to find some time to get the interrupt> > safe patches working. I wonder why you can't just return it to> > Xen when (or have Xen hold it somewhere until) the refcount> > reaches 0?>> It would still need to allocate a page in the meantime, which could fail> because the domain has hit its hard memory limit (which will be the> common case, because a domain generally starts with its full compliment> of memory).   The nice thing about the exchange is that there's no> accounting to take into account.
OK, well I don't really understand the details but I trust you ifyou say it's hard :)

> >>> Or... what if we just allow a compile and/or boot time flag to direct> >>> that it does not want lazy vmap unmapping and it will just revert to> >>> synchronous unmapping? If Xen needs lots of flushing anyway it might> >>> not be a win anyway.> >>> >> That may be worth considering.> >> > ... in the meantime, shall we just do this for Xen? It is probably> > safer and may end up with no worse performance on Xen anyway. If> > we get more vmap users and it becomes important, you could look at> > more sophisticated ways of doing this. Eg. a page could be flagged> > if it potentially has lazy vmaps.>> OK.  Do you want to do the patch, or shall I?
Here's a start for you. I think it gets rid of all the dead code anddata without introducing any actual conditional compilation...
--- mm/vmalloc.c |   66 ++++++++++++++++++++++++++++++++++++++++++----------------- 1 file changed, 48 insertions(+), 18 deletions(-)
Index: linux-2.6/mm/vmalloc.c===================================================================--- linux-2.6.orig/mm/vmalloc.c+++ linux-2.6/mm/vmalloc.c@@ -29,6 +29,11 @@ #include <asm/uaccess.h> #include <asm/tlbflush.h> +#ifdef CONFIG_VMAP_NO_LAZY_FLUSH+#define VMAP_LAZY_FLUSHES 0+#else+#define VMAP_LAZY_FLUSHES 1+#endif  /*** Page table manipulation functions ***/ @@ -376,7 +381,7 @@ retry: found: 	if (addr + size > vend) { 		spin_unlock(&vmap_area_lock);-		if (!purged) {+		if (VMAP_LAZY_FLUSHES && !purged) { 			purge_vmap_area_lazy(); 			purged = 1; 			goto retry;@@ -413,7 +418,10 @@ static void __free_vmap_area(struct vmap 	RB_CLEAR_NODE(&va->rb_node); 	list_del_rcu(&va->list); -	call_rcu(&va->rcu_head, rcu_free_va);+	if (VMAP_LAZY_FLUSHES)+		call_rcu(&va->rcu_head, rcu_free_va);+	else+		kfree(va); }  /*@@ -450,8 +458,10 @@ static void vmap_debug_free_range(unsign 	 * faster). 	 */ #ifdef CONFIG_DEBUG_PAGEALLOC-	vunmap_page_range(start, end);-	flush_tlb_kernel_range(start, end);+	if (VMAP_LAZY_FLUSHES) {+		vunmap_page_range(start, end);+		flush_tlb_kernel_range(start, end);+	} #endif } @@ -571,10 +581,16 @@ static void purge_vmap_area_lazy(void)  */ static void free_unmap_vmap_area_noflush(struct vmap_area *va) {-	va->flags |= VM_LAZY_FREE;-	atomic_add((va->va_end - va->va_start) >> PAGE_SHIFT, &vmap_lazy_nr);-	if (unlikely(atomic_read(&vmap_lazy_nr) > lazy_max_pages()))-		try_purge_vmap_area_lazy();+	if (VMAP_LAZY_FLUSHES) {+		va->flags |= VM_LAZY_FREE;+		atomic_add((va->va_end - va->va_start) >> PAGE_SHIFT,+							&vmap_lazy_nr);+		if (unlikely(atomic_read(&vmap_lazy_nr) > lazy_max_pages()))+			try_purge_vmap_area_lazy();+	} else {+		vunmap_page_range(va->va_start, va->va_end);+		flush_tlb_kernel_range(va->va_start, va->va_end);+	} }  /*@@ -610,6 +626,15 @@ static void free_unmap_vmap_area_addr(un /*** Per cpu kva allocator ***/  /*+ * This does lazy flushing as well, so don't call it if the arch doesn't want+ * lazy vmap kva flushes... The scalability aspect should be less important+ * in that case anyway seeing as kernel tlb flushing tends not to be scalable.+ * It would be possible to make this work without lazy tlb flushing if it+ * was really a big deal.+ */+++/*  * vmap space is limited especially on 32 bit architectures. Ensure there is  * room for at least 16 percpu vmap blocks per CPU.  */@@ -877,6 +902,9 @@ void vm_unmap_aliases(void) 	int cpu; 	int flush = 0; +	if (!VMAP_LAZY_FLUSHES)+		return;+ 	if (unlikely(!vmap_initialized)) 		return; @@ -937,7 +965,7 @@ void vm_unmap_ram(const void *mem, unsig 	debug_check_no_locks_freed(mem, size); 	vmap_debug_free_range(addr, addr+size); -	if (likely(count <= VMAP_MAX_ALLOC))+	if (VMAP_LAZY_FLUSHES && likely(count <= VMAP_MAX_ALLOC)) 		vb_free(mem, size); 	else 		free_unmap_vmap_area_addr(addr);@@ -959,7 +987,7 @@ void *vm_map_ram(struct page **pages, un 	unsigned long addr; 	void *mem; -	if (likely(count <= VMAP_MAX_ALLOC)) {+	if (VMAP_LAZY_FLUSHES && likely(count <= VMAP_MAX_ALLOC)) { 		mem = vb_alloc(size, GFP_KERNEL); 		if (IS_ERR(mem)) 			return NULL;@@ -988,14 +1016,16 @@ void __init vmalloc_init(void) 	struct vm_struct *tmp; 	int i; -	for_each_possible_cpu(i) {-		struct vmap_block_queue *vbq;--		vbq = &per_cpu(vmap_block_queue, i);-		spin_lock_init(&vbq->lock);-		INIT_LIST_HEAD(&vbq->free);-		INIT_LIST_HEAD(&vbq->dirty);-		vbq->nr_dirty = 0;+	if (VMAP_LAZY_FLUSHES) {+		for_each_possible_cpu(i) {+			struct vmap_block_queue *vbq;++			vbq = &per_cpu(vmap_block_queue, i);+			spin_lock_init(&vbq->lock);+			INIT_LIST_HEAD(&vbq->free);+			INIT_LIST_HEAD(&vbq->dirty);+			vbq->nr_dirty = 0;+		} 	}  	/* Import existing vmlist entries. */ ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
