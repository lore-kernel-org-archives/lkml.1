Return-Path: <linux-kernel-owner+w=401wt.eu-S1754904AbYATR2x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754904AbYATR2x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 12:28:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753475AbYATR2o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 12:28:44 -0500
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:9919 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753428AbYATR2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 12:28:43 -0500
Date: Sun, 20 Jan 2008 18:28:40 +0100
From: Andi Kleen <andi@firstfloor.org>
To: mingo@elte.hu, Jeremy Fitzhardinge <jeremy@goop.org>, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, venkatesh.pallipadi@intel.com
Subject: [PATCH] Fix early_ioremap on x86-64
Message-ID: <20080120172840.GA24608@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 20 Jan 2008 17:22:27.0866 (UTC) FILETIME=[07BEEFA0:01C85B89]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix early_ioremap on x86-64

[Venki, sorry for blaming PAT for this earlier. It was innocent.]
[Note the patch is on top of git-x86 + gbpages applied. I think
there will be an trivial reject without gbpages-direct applied first]

I had ACPI failures on several machines since a few days. Symptom
was NUMA nodes not getting detected or worse cores not getting detected.
They all came from ACPI not being able to read various of its tables. I finally
bisected it down to Jeremy's "put _PAGE_GLOBAL into PAGE_KERNEL" change.
With that the fix was fairly obvious. The problem was that early_ioremap()
didn't use a "_all" flush that would affect the global PTEs too. So 
with global bits getting used everywhere now an early_ioremap would
not actually flush a mapping if something else was mapped previously
on that slot (which can happen with early_iounmap inbetween)

This patch changes all flushes in init_64.c to be __flush_tlb_all()
and fixes the problem here.

Signed-off-by: Andi Kleen <ak@suse.de>

Index: linux/arch/x86/mm/init_64.c
===================================================================
--- linux.orig/arch/x86/mm/init_64.c
+++ linux/arch/x86/mm/init_64.c
@@ -242,7 +242,7 @@ void *early_ioremap(unsigned long addr, 
 		addr &= PMD_MASK;
 		for (i = 0; i < pmds; i++, addr += PMD_SIZE)
 			set_pmd(pmd+i, __pmd(addr | __PAGE_KERNEL_LARGE_EXEC));
-		__flush_tlb();
+		__flush_tlb_all();
 		printk(KERN_CONT "%016ld\n", vaddr);
 		return (void *)vaddr;
 	next:
@@ -265,7 +265,7 @@ void early_iounmap(void *addr, unsigned 
 	pmd = level2_kernel_pgt + pmd_index(vaddr);
 	for (i = 0; i < pmds; i++)
 		pmd_clear(pmd + i);
-	__flush_tlb();
+	__flush_tlb_all();
 }
 
 static unsigned long direct_entry(unsigned long paddr)
@@ -339,7 +339,7 @@ static void __meminit phys_pud_init(pud_
 		spin_unlock(&init_mm.page_table_lock);
 		unmap_low_page(pmd);
 	}
-	__flush_tlb();
+	__flush_tlb_all();
 } 
 
 static void __init find_early_table_space(unsigned long end)
