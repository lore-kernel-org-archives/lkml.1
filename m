Return-Path: <linux-kernel-owner+w=401wt.eu-S932586Ab0AGBZJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932586Ab0AGBZJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 20:25:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752531Ab0AGBZH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 20:25:07 -0500
Received: from mga01.intel.com ([192.55.52.88]:38106 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755978Ab0AGBZF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 20:25:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,232,1262592000"; 
   d="scan'208";a="529127993"
Date: Thu, 7 Jan 2010 09:24:59 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Nick Piggin <npiggin@suse.de>,
       Andi Kleen <andi@firstfloor.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Christoph Lameter <cl@linux-foundation.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [RFC][PATCH] vmalloc: simplify vread()/vwrite()
Message-ID: <20100107012458.GA9073@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vread()/vwrite() is only called from kcore/kmem to access one page at
a time.  So the logic can be vastly simplified.

The changes are:
- remove the vmlist walk and rely solely on vmalloc_to_page()
- replace the VM_IOREMAP check with (page && page_is_ram(pfn))

The VM_IOREMAP check is introduced in commit d0107eb07320b for per-cpu
alloc. Kame, would you double check if this change is OK for that
purpose?

The page_is_ram() check is necessary because kmap_atomic() is not
designed to work with non-RAM pages.

Even for a RAM page, we don't own the page, and cannot assume it's a
_PAGE_CACHE_WB page. So I wonder whether it's necessary to do another
patch to call reserve_memtype() before kmap_atomic() to ensure cache
consistency?

TODO: update comments accordingly

CC: Tejun Heo <tj@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>
CC: Nick Piggin <npiggin@suse.de>
CC: Andi Kleen <andi@firstfloor.org> 
CC: Hugh Dickins <hugh.dickins@tiscali.co.uk>
CC: Christoph Lameter <cl@linux-foundation.org>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/vmalloc.c |  196 ++++++++++---------------------------------------
 1 file changed, 40 insertions(+), 156 deletions(-)

--- linux-mm.orig/mm/vmalloc.c	2010-01-04 10:23:12.000000000 +0800
+++ linux-mm/mm/vmalloc.c	2010-01-05 12:42:40.000000000 +0800
@@ -1646,87 +1646,6 @@ void *vmalloc_32_user(unsigned long size
 }
 EXPORT_SYMBOL(vmalloc_32_user);
 
-/*
- * small helper routine , copy contents to buf from addr.
- * If the page is not present, fill zero.
- */
-
-static int aligned_vread(char *buf, char *addr, unsigned long count)
-{
-	struct page *p;
-	int copied = 0;
-
-	while (count) {
-		unsigned long offset, length;
-
-		offset = (unsigned long)addr & ~PAGE_MASK;
-		length = PAGE_SIZE - offset;
-		if (length > count)
-			length = count;
-		p = vmalloc_to_page(addr);
-		/*
-		 * To do safe access to this _mapped_ area, we need
-		 * lock. But adding lock here means that we need to add
-		 * overhead of vmalloc()/vfree() calles for this _debug_
-		 * interface, rarely used. Instead of that, we'll use
-		 * kmap() and get small overhead in this access function.
-		 */
-		if (p) {
-			/*
-			 * we can expect USER0 is not used (see vread/vwrite's
-			 * function description)
-			 */
-			void *map = kmap_atomic(p, KM_USER0);
-			memcpy(buf, map + offset, length);
-			kunmap_atomic(map, KM_USER0);
-		} else
-			memset(buf, 0, length);
-
-		addr += length;
-		buf += length;
-		copied += length;
-		count -= length;
-	}
-	return copied;
-}
-
-static int aligned_vwrite(char *buf, char *addr, unsigned long count)
-{
-	struct page *p;
-	int copied = 0;
-
-	while (count) {
-		unsigned long offset, length;
-
-		offset = (unsigned long)addr & ~PAGE_MASK;
-		length = PAGE_SIZE - offset;
-		if (length > count)
-			length = count;
-		p = vmalloc_to_page(addr);
-		/*
-		 * To do safe access to this _mapped_ area, we need
-		 * lock. But adding lock here means that we need to add
-		 * overhead of vmalloc()/vfree() calles for this _debug_
-		 * interface, rarely used. Instead of that, we'll use
-		 * kmap() and get small overhead in this access function.
-		 */
-		if (p) {
-			/*
-			 * we can expect USER0 is not used (see vread/vwrite's
-			 * function description)
-			 */
-			void *map = kmap_atomic(p, KM_USER0);
-			memcpy(map + offset, buf, length);
-			kunmap_atomic(map, KM_USER0);
-		}
-		addr += length;
-		buf += length;
-		copied += length;
-		count -= length;
-	}
-	return copied;
-}
-
 /**
  *	vread() -  read vmalloc area in a safe way.
  *	@buf:		buffer for reading data
@@ -1757,49 +1676,34 @@ static int aligned_vwrite(char *buf, cha
 
 long vread(char *buf, char *addr, unsigned long count)
 {
-	struct vm_struct *tmp;
-	char *vaddr, *buf_start = buf;
-	unsigned long buflen = count;
-	unsigned long n;
-
-	/* Don't allow overflow */
-	if ((unsigned long) addr + count < count)
-		count = -(unsigned long) addr;
+	struct page *p;
+	void *map;
+	int offset = (unsigned long)addr & (PAGE_SIZE - 1);
 
-	read_lock(&vmlist_lock);
-	for (tmp = vmlist; count && tmp; tmp = tmp->next) {
-		vaddr = (char *) tmp->addr;
-		if (addr >= vaddr + tmp->size - PAGE_SIZE)
-			continue;
-		while (addr < vaddr) {
-			if (count == 0)
-				goto finished;
-			*buf = '\0';
-			buf++;
-			addr++;
-			count--;
-		}
-		n = vaddr + tmp->size - PAGE_SIZE - addr;
-		if (n > count)
-			n = count;
-		if (!(tmp->flags & VM_IOREMAP))
-			aligned_vread(buf, addr, n);
-		else /* IOREMAP area is treated as memory hole */
-			memset(buf, 0, n);
-		buf += n;
-		addr += n;
-		count -= n;
-	}
-finished:
-	read_unlock(&vmlist_lock);
+	/* Assume subpage access */
+	BUG_ON(count > PAGE_SIZE - offset);
 
-	if (buf == buf_start)
+	p = vmalloc_to_page(addr);
+	if (!p || !page_is_ram(page_to_pfn(p))) {
+		memset(buf, 0, count);
 		return 0;
-	/* zero-fill memory holes */
-	if (buf != buf_start + buflen)
-		memset(buf, 0, buflen - (buf - buf_start));
+	}
 
-	return buflen;
+	/*
+	 * To do safe access to this _mapped_ area, we need
+	 * lock. But adding lock here means that we need to add
+	 * overhead of vmalloc()/vfree() calles for this _debug_
+	 * interface, rarely used. Instead of that, we'll use
+	 * kmap() and get small overhead in this access function.
+	 *
+	 * we can expect USER0 is not used (see vread/vwrite's
+	 * function description)
+	 */
+	map = kmap_atomic(p, KM_USER0);
+	memcpy(buf, map + offset, count);
+	kunmap_atomic(map, KM_USER0);
+
+	return count;
 }
 
 /**
@@ -1834,44 +1738,24 @@ finished:
 
 long vwrite(char *buf, char *addr, unsigned long count)
 {
-	struct vm_struct *tmp;
-	char *vaddr;
-	unsigned long n, buflen;
-	int copied = 0;
-
-	/* Don't allow overflow */
-	if ((unsigned long) addr + count < count)
-		count = -(unsigned long) addr;
-	buflen = count;
+	struct page *p;
+	void *map;
+	int offset = (unsigned long)addr & (PAGE_SIZE - 1);
 
-	read_lock(&vmlist_lock);
-	for (tmp = vmlist; count && tmp; tmp = tmp->next) {
-		vaddr = (char *) tmp->addr;
-		if (addr >= vaddr + tmp->size - PAGE_SIZE)
-			continue;
-		while (addr < vaddr) {
-			if (count == 0)
-				goto finished;
-			buf++;
-			addr++;
-			count--;
-		}
-		n = vaddr + tmp->size - PAGE_SIZE - addr;
-		if (n > count)
-			n = count;
-		if (!(tmp->flags & VM_IOREMAP)) {
-			aligned_vwrite(buf, addr, n);
-			copied++;
-		}
-		buf += n;
-		addr += n;
-		count -= n;
-	}
-finished:
-	read_unlock(&vmlist_lock);
-	if (!copied)
+	/* Assume subpage access */
+	BUG_ON(count > PAGE_SIZE - offset);
+
+	p = vmalloc_to_page(addr);
+	if (!p)
+		return 0;
+	if (!page_is_ram(page_to_pfn(p)))
 		return 0;
-	return buflen;
+
+	map = kmap_atomic(p, KM_USER0);
+	memcpy(map + offset, buf, count);
+	kunmap_atomic(map, KM_USER0);
+
+	return count;
 }
 
 /**
