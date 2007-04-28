Return-Path: <linux-kernel-owner+w=401wt.eu-S1031008AbXD1EKQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031008AbXD1EKQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 00:10:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031009AbXD1EKQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 00:10:16 -0400
Received: from web32409.mail.mud.yahoo.com ([68.142.207.202]:38532 "HELO
	web32409.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1031008AbXD1EKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 00:10:13 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Sat, 28 Apr 2007 00:10:13 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=ld1MLqOFiszZQgLY/nRdTt4NjweMvRPc7CvgBsThyx1/FyiEtagD/xA2ttldtDU09VMuOvqp4o4SE5p956tXRx8SeKNShI0JsEEO28Mh1kt3D0n4Slu02llkn59+YERiQY6QiJiEA3cGUpXjspX0c3GtNRYVYvWzgUV7A/WJYdo=;
X-YMail-OSG: 6hGBPFkVM1lSx5ly54MT2hptGQZp2BBq0a2JYto4Dj.s.43zE7OQ3Ryr7vZx1Q6477VvSVj.1ShPRiZi52IQuE2IfhYLQ5ari6K9m40k441TNYf1NIaeFVuZiXxkrA--
Date: Fri, 27 Apr 2007 21:03:33 -0700 (PDT)
From: Giridhar Pemmasani <pgiri@yahoo.com>
Subject: [PATCH] Allow __vmalloc with GFP_ATOMIC
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <539764.53941.qm@web32409.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Until 2.6.19, __vmalloc with GFP_ATOMIC was possible, but __get_vm_area_node
would allocate the node itself with GFP_KERNEL, causing a warning. In 2.6.19,
this was "fixed" by using the same flags that were passed to __vmalloc also
in __get_vm_area_node. However, __get_vm_area_node does
BUG_ON(in_interrupt()) now, since vmlist_lock is obtained without disabling
bottom-half's. The patch below uses bh disabled lock for vmlist_lock, so that
__vmalloc can be used in interrupt context.

In 2.6.21, __vmalloc with GFP_ATOMIC is used by arch/um/kernel/process.c;
__vmalloc is also used in ntfs, xfs, but it is not clear to me if they use it
with GFP_ATOMIC or GFP_KERNEL.

Thanks,
Giri

Signed-off-by: Giridhar Pemmasani <pgiri@yahoo.com>
---
--- linux-2.6.21.orig/./arch/arm/mm/ioremap.c	2007-04-25 23:08:32.000000000
-0400
+++ linux-2.6.21.new/./arch/arm/mm/ioremap.c	2007-04-27 23:29:27.000000000
-0400
@@ -363,7 +363,7 @@
 	 * all the mappings before the area can be reclaimed
 	 * by someone else.
 	 */
-	write_lock(&vmlist_lock);
+	write_lock_bh(&vmlist_lock);
 	for (p = &vmlist ; (tmp = *p) ; p = &tmp->next) {
 		if((tmp->flags & VM_IOREMAP) && (tmp->addr == addr)) {
 			if (tmp->flags & VM_ARM_SECTION_MAPPING) {
@@ -376,7 +376,7 @@
 			break;
 		}
 	}
-	write_unlock(&vmlist_lock);
+	write_unlock_bh(&vmlist_lock);
 #endif
 
 	if (!section_mapping)
--- linux-2.6.21.orig/./arch/i386/mm/ioremap.c	2007-04-25 23:08:32.000000000
-0400
+++ linux-2.6.21.new/./arch/i386/mm/ioremap.c	2007-04-27 23:29:27.000000000
-0400
@@ -180,12 +180,12 @@
 	   in parallel. Reuse of the virtual address is prevented by
 	   leaving it in the global lists until we're done with it.
 	   cpa takes care of the direct mappings. */
-	read_lock(&vmlist_lock);
+	read_lock_bh(&vmlist_lock);
 	for (p = vmlist; p; p = p->next) {
 		if (p->addr == addr)
 			break;
 	}
-	read_unlock(&vmlist_lock);
+	read_unlock_bh(&vmlist_lock);
 
 	if (!p) {
 		printk("iounmap: bad address %p\n", addr);
--- linux-2.6.21.orig/./arch/x86_64/mm/ioremap.c	2007-04-25
23:08:32.000000000 -0400
+++ linux-2.6.21.new/./arch/x86_64/mm/ioremap.c	2007-04-27 23:29:27.000000000
-0400
@@ -175,12 +175,12 @@
 	   in parallel. Reuse of the virtual address is prevented by
 	   leaving it in the global lists until we're done with it.
 	   cpa takes care of the direct mappings. */
-	read_lock(&vmlist_lock);
+	read_lock_bh(&vmlist_lock);
 	for (p = vmlist; p; p = p->next) {
 		if (p->addr == addr)
 			break;
 	}
-	read_unlock(&vmlist_lock);
+	read_unlock_bh(&vmlist_lock);
 
 	if (!p) {
 		printk("iounmap: bad address %p\n", addr);
--- linux-2.6.21.orig/./fs/proc/kcore.c	2007-04-25 23:08:32.000000000 -0400
+++ linux-2.6.21.new/./fs/proc/kcore.c	2007-04-27 23:29:27.000000000 -0400
@@ -335,7 +335,7 @@
 			if (!elf_buf)
 				return -ENOMEM;
 
-			read_lock(&vmlist_lock);
+			read_lock_bh(&vmlist_lock);
 			for (m=vmlist; m && cursize; m=m->next) {
 				unsigned long vmstart;
 				unsigned long vmsize;
@@ -363,7 +363,7 @@
 				memcpy(elf_buf + (vmstart - start),
 					(char *)vmstart, vmsize);
 			}
-			read_unlock(&vmlist_lock);
+			read_unlock_bh(&vmlist_lock);
 			if (copy_to_user(buffer, elf_buf, tsz)) {
 				kfree(elf_buf);
 				return -EFAULT;
--- linux-2.6.21.orig/./fs/proc/mmu.c	2007-04-25 23:08:32.000000000 -0400
+++ linux-2.6.21.new/./fs/proc/mmu.c	2007-04-27 23:29:41.000000000 -0400
@@ -47,7 +47,7 @@
 
 		prev_end = VMALLOC_START;
 
-		read_lock(&vmlist_lock);
+		read_lock_bh(&vmlist_lock);
 
 		for (vma = vmlist; vma; vma = vma->next) {
 			unsigned long addr = (unsigned long) vma->addr;
@@ -72,6 +72,6 @@
 		if (VMALLOC_END - prev_end > vmi->largest_chunk)
 			vmi->largest_chunk = VMALLOC_END - prev_end;
 
-		read_unlock(&vmlist_lock);
+		read_unlock_bh(&vmlist_lock);
 	}
 }
--- linux-2.6.21.orig/./mm/vmalloc.c	2007-04-25 23:08:32.000000000 -0400
+++ linux-2.6.21.new/./mm/vmalloc.c	2007-04-27 23:33:17.000000000 -0400
@@ -168,7 +168,7 @@
 	unsigned long align = 1;
 	unsigned long addr;
 
-	BUG_ON(in_interrupt());
+	BUG_ON(in_irq());
 	if (flags & VM_IOREMAP) {
 		int bit = fls(size);
 
@@ -193,7 +193,7 @@
 	 */
 	size += PAGE_SIZE;
 
-	write_lock(&vmlist_lock);
+	write_lock_bh(&vmlist_lock);
 	for (p = &vmlist; (tmp = *p) != NULL ;p = &tmp->next) {
 		if ((unsigned long)tmp->addr < addr) {
 			if((unsigned long)tmp->addr + tmp->size >= addr)
@@ -220,12 +220,12 @@
 	area->pages = NULL;
 	area->nr_pages = 0;
 	area->phys_addr = 0;
-	write_unlock(&vmlist_lock);
+	write_unlock_bh(&vmlist_lock);
 
 	return area;
 
 out:
-	write_unlock(&vmlist_lock);
+	write_unlock_bh(&vmlist_lock);
 	kfree(area);
 	if (printk_ratelimit())
 		printk(KERN_WARNING "allocation failed: out of vmalloc space - use
vmalloc=<size> to increase size.\n");
@@ -305,9 +305,9 @@
 struct vm_struct *remove_vm_area(void *addr)
 {
 	struct vm_struct *v;
-	write_lock(&vmlist_lock);
+	write_lock_bh(&vmlist_lock);
 	v = __remove_vm_area(addr);
-	write_unlock(&vmlist_lock);
+	write_unlock_bh(&vmlist_lock);
 	return v;
 }
 
@@ -364,7 +364,7 @@
  */
 void vfree(void *addr)
 {
-	BUG_ON(in_interrupt());
+	BUG_ON(in_irq());
 	__vunmap(addr, 1);
 }
 EXPORT_SYMBOL(vfree);
@@ -380,7 +380,7 @@
  */
 void vunmap(void *addr)
 {
-	BUG_ON(in_interrupt());
+	BUG_ON(in_irq());
 	__vunmap(addr, 0);
 }
 EXPORT_SYMBOL(vunmap);
@@ -530,10 +530,10 @@
 
 	ret = __vmalloc(size, GFP_KERNEL | __GFP_HIGHMEM | __GFP_ZERO,
PAGE_KERNEL);
 	if (ret) {
-		write_lock(&vmlist_lock);
+		write_lock_bh(&vmlist_lock);
 		area = __find_vm_area(ret);
 		area->flags |= VM_USERMAP;
-		write_unlock(&vmlist_lock);
+		write_unlock_bh(&vmlist_lock);
 	}
 	return ret;
 }
@@ -604,10 +604,10 @@
 
 	ret = __vmalloc(size, GFP_KERNEL | __GFP_ZERO, PAGE_KERNEL);
 	if (ret) {
-		write_lock(&vmlist_lock);
+		write_lock_bh(&vmlist_lock);
 		area = __find_vm_area(ret);
 		area->flags |= VM_USERMAP;
-		write_unlock(&vmlist_lock);
+		write_unlock_bh(&vmlist_lock);
 	}
 	return ret;
 }
@@ -623,7 +623,7 @@
 	if ((unsigned long) addr + count < count)
 		count = -(unsigned long) addr;
 
-	read_lock(&vmlist_lock);
+	read_lock_bh(&vmlist_lock);
 	for (tmp = vmlist; tmp; tmp = tmp->next) {
 		vaddr = (char *) tmp->addr;
 		if (addr >= vaddr + tmp->size - PAGE_SIZE)
@@ -647,7 +647,7 @@
 		} while (--n > 0);
 	}
 finished:
-	read_unlock(&vmlist_lock);
+	read_unlock_bh(&vmlist_lock);
 	return buf - buf_start;
 }
 
@@ -661,7 +661,7 @@
 	if ((unsigned long) addr + count < count)
 		count = -(unsigned long) addr;
 
-	read_lock(&vmlist_lock);
+	read_lock_bh(&vmlist_lock);
 	for (tmp = vmlist; tmp; tmp = tmp->next) {
 		vaddr = (char *) tmp->addr;
 		if (addr >= vaddr + tmp->size - PAGE_SIZE)
@@ -684,7 +684,7 @@
 		} while (--n > 0);
 	}
 finished:
-	read_unlock(&vmlist_lock);
+	read_unlock_bh(&vmlist_lock);
 	return buf - buf_start;
 }
 
@@ -712,7 +712,7 @@
 	if ((PAGE_SIZE-1) & (unsigned long)addr)
 		return -EINVAL;
 
-	read_lock(&vmlist_lock);
+	read_lock_bh(&vmlist_lock);
 	area = __find_vm_area(addr);
 	if (!area)
 		goto out_einval_locked;
@@ -722,7 +722,7 @@
 
 	if (usize + (pgoff << PAGE_SHIFT) > area->size - PAGE_SIZE)
 		goto out_einval_locked;
-	read_unlock(&vmlist_lock);
+	read_unlock_bh(&vmlist_lock);
 
 	addr += pgoff << PAGE_SHIFT;
 	do {
@@ -742,7 +742,7 @@
 	return ret;
 
 out_einval_locked:
-	read_unlock(&vmlist_lock);
+	read_unlock_bh(&vmlist_lock);
 	return -EINVAL;
 }
 EXPORT_SYMBOL(remap_vmalloc_range);


__________________________________________________
Do You Yahoo!?
Tired of spam?  Yahoo! Mail has the best spam protection around 
http://mail.yahoo.com 
