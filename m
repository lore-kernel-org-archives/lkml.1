Return-Path: <linux-kernel-owner+w=401wt.eu-S1758599AbYFJDps@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758599AbYFJDps (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 23:45:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753789AbYFJDpi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 23:45:38 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45409 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753501AbYFJDph (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 23:45:37 -0400
Date: Tue, 10 Jun 2008 05:45:36 +0200
From: Nick Piggin <npiggin@suse.de>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [rfc][patch] mm: vmap rewrite
Message-ID: <20080610034536.GA4115@wotan.suse.de>
References: <20080605102015.GA11366@wotan.suse.de> <4848E49B.8060505@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4848E49B.8060505@gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 06, 2008 at 09:17:47AM +0200, Jiri Slaby wrote:
> On 06/05/2008 12:20 PM, Nick Piggin wrote:
> >Rewrite the vmap allocator to use rbtrees and lazy tlb flushing, and 
> >provide a
> >fast, scalable percpu frontend for small vmaps.
> [...]
> >===================================================================
> >Index: linux-2.6/mm/vmalloc.c
> >===================================================================
> >--- linux-2.6.orig/mm/vmalloc.c
> >+++ linux-2.6/mm/vmalloc.c
> [...]
> >@@ -18,16 +19,17 @@
> [...]
> >-DEFINE_RWLOCK(vmlist_lock);
> >-struct vm_struct *vmlist;
> >-
> >-static void *__vmalloc_node(unsigned long size, gfp_t gfp_mask, pgprot_t 
> >prot,
> >-			    int node, void *caller);
> >+/** Page table manipulation functions **/
> 
> Do not use /** for non-kdoc comments.

OK, sure. What about /*** ?


> > static void vunmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned 
> > long end)
> > {
> [...]
> >@@ -103,18 +95,24 @@ static int vmap_pte_range(pmd_t *pmd, un
> > 	if (!pte)
> > 		return -ENOMEM;
> > 	do {
> >-		struct page *page = **pages;
> >-		WARN_ON(!pte_none(*pte));
> >-		if (!page)
> >+		struct page *page = pages[*nr];
> >+
> >+		if (unlikely(!pte_none(*pte))) {
> >+			WARN_ON(1);
> >+			return -EBUSY;
> >+		}
> 
> this just may be
> if (WARN_ON(!pte_none(*pte)))
>   return -EBUSY;
> 
> >+		if (unlikely(!page)) {
> >+			WARN_ON(1);
> > 			return -ENOMEM;
> >+		}
> 
> same here

Noted, but I actually don't like the syntax at all, so I won't change it.

 
> > 		set_pte_at(&init_mm, addr, pte, mk_pte(page, prot));
> >-		(*pages)++;
> >+		(*nr)++;
> > 	} while (pte++, addr += PAGE_SIZE, addr != end);
> > 	return 0;
> > }
> [...]
> >-static struct vm_struct *
> >-__get_vm_area_node(unsigned long size, unsigned long flags, unsigned long 
> >start,
> >-		unsigned long end, int node, gfp_t gfp_mask, void *caller)
> >+
> >+/** Global kva allocator **/
> 
> here too
> 
> >+static struct vmap_area *__find_vmap_area(unsigned long addr)
> > {
> >-	struct vm_struct **p, *tmp, *area;
> >-	unsigned long align = 1;
> >+        struct rb_node *n = vmap_area_root.rb_node;
> 
> It's padded by spaces here.

Hmm, thanks will fix.

 
> >+
> >+        while (n) {
> >+		struct vmap_area *va;
> >+
> >+                va = rb_entry(n, struct vmap_area, rb_node);
> >+                if (addr < va->va_start)
> >+                        n = n->rb_left;
> >+                else if (addr > va->va_start)
> >+                        n = n->rb_right;
> >+                else
> >+                        return va;
> >+        }
> >+
> >+        return NULL;
> >+}
> [...]
> >+/** Per cpu kva allocator **/
> 
> standard /* comment */
> 
> >+#define ULONG_BITS		(8*sizeof(unsigned long))
> >+#if BITS_PER_LONG < 64
> 
> Can these 2 differ?

Hmm, not sure what I was thinking there... should just use BITS_PER_LONG
I guess.

 
> >+/*
> >+ * vmap space is limited on 32 bit architectures. Ensure there is room 
> >for at
> >+ * least 16 percpu vmap blocks per CPU.
> >+ */
> >+#define VMAP_BBMAP_BITS		min(1024, (128*1024*1024 / PAGE_SIZE 
> >/ NR_CPUS / 16))
> >+#define VMAP_BBMAP_BITS		(1024) /* 4MB with 4K pages */
> >+#define VMAP_BBMAP_LONGS	BITS_TO_LONGS(VMAP_BBMAP_BITS)
> >+#define VMAP_BLOCK_SIZE		(VMAP_BBMAP_BITS * PAGE_SIZE)
> >+
> >+struct vmap_block_queue {
> >+	spinlock_t lock;
> >+	struct list_head free;
> >+	struct list_head dirty;
> >+	unsigned int nr_dirty;
> >+};
> >+
> >+struct vmap_block {
> >+	spinlock_t lock;
> >+	struct vmap_area *va;
> >+	struct vmap_block_queue *vbq;
> >+	unsigned long free, dirty;
> >+	unsigned long alloc_map[VMAP_BBMAP_LONGS];
> >+	unsigned long dirty_map[VMAP_BBMAP_LONGS];
> 
> DECLARE_BITMAP(x, VMAP_BBMAP_BITS)?

Yeah, that's nicer.

Thanks,
Nick
