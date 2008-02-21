Return-Path: <linux-kernel-owner+w=401wt.eu-S1764797AbYBUU11@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764797AbYBUU11 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 15:27:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757436AbYBUU1T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 15:27:19 -0500
Received: from www.tglx.de ([62.245.132.106]:46672 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755877AbYBUU1T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 15:27:19 -0500
Date: Thu, 21 Feb 2008 21:26:56 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Diego Calleja <diegocg@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: BUG?: "Cannot map mmconfig aperture"
In-Reply-To: <20080221164105.145d0cbb.diegocg@gmail.com>
Message-ID: <alpine.LFD.1.00.0802212124231.7583@apollo.tec.linutronix.de>
References: <20080220223156.578e0a5d.diegocg@gmail.com> <alpine.LFD.1.00.0802210853060.7583@apollo.tec.linutronix.de> <20080221164105.145d0cbb.diegocg@gmail.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Feb 2008, Diego Calleja wrote:
> > Hmm, that's confusing. Can you please provide a complete boot log ?
> > 
> > Thanks,
> 
> Sure

Thanks. Nothing new there. Can you please apply the patch below and
provide the output of the ioremap code ?

Thanks,

	tglx

Index: linux-2.6/arch/x86/mm/ioremap.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/ioremap.c
+++ linux-2.6/arch/x86/mm/ioremap.c
@@ -112,6 +112,7 @@ static void __iomem *__ioremap(unsigned 
 	unsigned long pfn, offset, last_addr, vaddr;
 	struct vm_struct *area;
 	pgprot_t prot;
+	int err;
 
 	/* Don't allow wraparound or zero size */
 	last_addr = phys_addr + size - 1;
@@ -130,8 +131,11 @@ static void __iomem *__ioremap(unsigned 
 	for (pfn = phys_addr >> PAGE_SHIFT; pfn < max_pfn_mapped &&
 	     (pfn << PAGE_SHIFT) < last_addr; pfn++) {
 		if (page_is_ram(pfn) && pfn_valid(pfn) &&
-		    !PageReserved(pfn_to_page(pfn)))
+		    !PageReserved(pfn_to_page(pfn))) {
+			printk(KERN_INFO "ioremap: (RAM) %lx %lu\n", phys_addr,
+			       size);
 			return NULL;
+		}
 	}
 
 	WARN_ON_ONCE(page_is_ram(pfn));
@@ -157,16 +161,23 @@ static void __iomem *__ioremap(unsigned 
 	 * Ok, go for it..
 	 */
 	area = get_vm_area(size, VM_IOREMAP);
-	if (!area)
+	if (!area) {
+		printk(KERN_INFO "ioremap: !area PR %lx %lu\n", phys_addr,
+		       size);
 		return NULL;
+	}
 	area->phys_addr = phys_addr;
 	vaddr = (unsigned long) area->addr;
 	if (ioremap_page_range(vaddr, vaddr + size, phys_addr, prot)) {
 		remove_vm_area((void *)(vaddr & PAGE_MASK));
+		printk(KERN_INFO "ioremap: IPR %lx %lu\n", phys_addr, size);
 		return NULL;
 	}
 
-	if (ioremap_change_attr(vaddr, size, mode) < 0) {
+	err = ioremap_change_attr(vaddr, size, mode);
+	if (err < 0) {
+		printk(KERN_INFO "ioremap: CPA %lx %lu %d\n", phys_addr, size,
+		       err);
 		vunmap(area->addr);
 		return NULL;
 	}
