Return-Path: <linux-kernel-owner+w=401wt.eu-S1752827AbZG1KDi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752827AbZG1KDi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 06:03:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752003AbZG1KDh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 06:03:37 -0400
Received: from mail-pz0-f204.google.com ([209.85.222.204]:39038 "EHLO
	mail-pz0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890AbZG1KDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 06:03:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=avEHov9fNgDaTvX+0VSkmb8PuI2AQf6IZX3zzY7G2X0avNHc7eU8obXKdZX8Z4Vo/p
         8fViItam43Jm0QBRFrCdbh1d2iNfMDtgwHjo48/7I/os17RgN1ba2mWVwF7lkk2pmTvc
         AhabOCIquOEHzL5oQm/d+RfpTdYLRpnugjj4A=
Date: Tue, 28 Jul 2009 18:05:47 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       xiyou.wangcong@gmail.com,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       ralf@linux-mips.org, benh@kernel.crashing.org, lethal@linux-sh.org
Subject: Re: [RFC][PATCH 3/6] kcore: unify vmalloc range entry
Message-ID: <20090728100547.GE6036@cr0.nay.redhat.com>
References: <20090724170819.2625ba07.kamezawa.hiroyu@jp.fujitsu.com> <20090724171318.684dac3e.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090724171318.684dac3e.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 24, 2009 at 05:13:18PM +0900, KAMEZAWA Hiroyuki wrote:
>From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>
>For /proc/kcore, vmalloc areas are registered per arch. But, all of
>them registers same range of [VMALLOC_START...VMALLOC_END)
>This patch unifies them.
>Note: /proc/kcore depends on CONFIG_MMU.
>
>Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Looks good.

Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>

Thanks!

>---
> arch/ia64/mm/init.c       |    7 +------
> arch/mips/mm/init.c       |    4 +---
> arch/powerpc/mm/init_32.c |    4 ----
> arch/powerpc/mm/init_64.c |    4 ----
> arch/sh/mm/init.c         |    4 +---
> arch/x86/mm/init_32.c     |    4 +---
> arch/x86/mm/init_64.c     |    4 +---
> fs/proc/kcore.c           |    5 +++++
> 8 files changed, 10 insertions(+), 26 deletions(-)
>
>Index: mmotm-2.6.31-Jul16/fs/proc/kcore.c
>===================================================================
>--- mmotm-2.6.31-Jul16.orig/fs/proc/kcore.c
>+++ mmotm-2.6.31-Jul16/fs/proc/kcore.c
>@@ -406,9 +406,14 @@ read_kcore(struct file *file, char __use
> 	return acc;
> }
> 
>+static struct kcore_list kcore_vmalloc;
>+
> static int __init proc_kcore_init(void)
> {
> 	proc_root_kcore = proc_create("kcore", S_IRUSR, NULL, &proc_kcore_operations);
>+
>+	kclist_add(&kcore_vmalloc, (void *)VMALLOC_START,
>+		VMALLOC_END - VMALLOC_START, KCORE_VMALLOC);
> 	return 0;
> }
> module_init(proc_kcore_init);
>Index: mmotm-2.6.31-Jul16/arch/x86/mm/init_32.c
>===================================================================
>--- mmotm-2.6.31-Jul16.orig/arch/x86/mm/init_32.c
>+++ mmotm-2.6.31-Jul16/arch/x86/mm/init_32.c
>@@ -857,7 +857,7 @@ static void __init test_wp_bit(void)
> 	}
> }
> 
>-static struct kcore_list kcore_mem, kcore_vmalloc;
>+static struct kcore_list kcore_mem;
> 
> void __init mem_init(void)
> {
>@@ -887,8 +887,6 @@ void __init mem_init(void)
> 	initsize =  (unsigned long) &__init_end - (unsigned long) &__init_begin;
> 
> 	kclist_add(&kcore_mem, __va(0), max_low_pfn << PAGE_SHIFT, KCORE_RAM);
>-	kclist_add(&kcore_vmalloc, (void *)VMALLOC_START,
>-		   VMALLOC_END-VMALLOC_START, KCORE_VMALLOC);
> 
> 	printk(KERN_INFO "Memory: %luk/%luk available (%dk kernel code, "
> 			"%dk reserved, %dk data, %dk init, %ldk highmem)\n",
>Index: mmotm-2.6.31-Jul16/arch/x86/mm/init_64.c
>===================================================================
>--- mmotm-2.6.31-Jul16.orig/arch/x86/mm/init_64.c
>+++ mmotm-2.6.31-Jul16/arch/x86/mm/init_64.c
>@@ -647,7 +647,7 @@ EXPORT_SYMBOL_GPL(memory_add_physaddr_to
> 
> #endif /* CONFIG_MEMORY_HOTPLUG */
> 
>-static struct kcore_list kcore_mem, kcore_vmalloc, kcore_kernel,
>+static struct kcore_list kcore_mem, kcore_kernel,
> 			 kcore_modules, kcore_vsyscall;
> 
> void __init mem_init(void)
>@@ -678,8 +678,6 @@ void __init mem_init(void)
> 
> 	/* Register memory areas for /proc/kcore */
> 	kclist_add(&kcore_mem, __va(0), max_low_pfn << PAGE_SHIFT, KCORE_RAM);
>-	kclist_add(&kcore_vmalloc, (void *)VMALLOC_START,
>-		   VMALLOC_END-VMALLOC_START, KCORE_VMALLOC);
> 	kclist_add(&kcore_kernel, &_stext, _end - _stext, KCORE_TEXT);
> 	kclist_add(&kcore_modules, (void *)MODULES_VADDR, MODULES_LEN,
> 			KCORE_OTHER);
>Index: mmotm-2.6.31-Jul16/arch/mips/mm/init.c
>===================================================================
>--- mmotm-2.6.31-Jul16.orig/arch/mips/mm/init.c
>+++ mmotm-2.6.31-Jul16/arch/mips/mm/init.c
>@@ -352,7 +352,7 @@ void __init paging_init(void)
> 	free_area_init_nodes(max_zone_pfns);
> }
> 
>-static struct kcore_list kcore_mem, kcore_vmalloc;
>+static struct kcore_list kcore_mem;
> #ifdef CONFIG_64BIT
> static struct kcore_list kcore_kseg0;
> #endif
>@@ -413,8 +413,6 @@ void __init mem_init(void)
> 				0x80000000 - 4, KCORE_TEXT);
> #endif
> 	kclist_add(&kcore_mem, __va(0), max_low_pfn << PAGE_SHIFT, KCORE_RAM);
>-	kclist_add(&kcore_vmalloc, (void *)VMALLOC_START,
>-		   VMALLOC_END-VMALLOC_START, KCORE_VMALLOC);
> 
> 	printk(KERN_INFO "Memory: %luk/%luk available (%ldk kernel code, "
> 	       "%ldk reserved, %ldk data, %ldk init, %ldk highmem)\n",
>Index: mmotm-2.6.31-Jul16/arch/powerpc/mm/init_32.c
>===================================================================
>--- mmotm-2.6.31-Jul16.orig/arch/powerpc/mm/init_32.c
>+++ mmotm-2.6.31-Jul16/arch/powerpc/mm/init_32.c
>@@ -245,7 +245,6 @@ void free_initrd_mem(unsigned long start
> #endif
> 
> #ifdef CONFIG_PROC_KCORE
>-static struct kcore_list kcore_vmem;
> 
> static int __init setup_kcore(void)
> {
>@@ -273,9 +272,6 @@ static int __init setup_kcore(void)
> 		kclist_add(kcore_mem, __va(base), size, KCORE_RAM);
> 	}
> 
>-	kclist_add(&kcore_vmem, (void *)VMALLOC_START,
>-		VMALLOC_END-VMALLOC_START, KCORE_VMALLOC);
>-
> 	return 0;
> }
> module_init(setup_kcore);
>Index: mmotm-2.6.31-Jul16/arch/ia64/mm/init.c
>===================================================================
>--- mmotm-2.6.31-Jul16.orig/arch/ia64/mm/init.c
>+++ mmotm-2.6.31-Jul16/arch/ia64/mm/init.c
>@@ -617,7 +617,7 @@ mem_init (void)
> 	long reserved_pages, codesize, datasize, initsize;
> 	pg_data_t *pgdat;
> 	int i;
>-	static struct kcore_list kcore_mem, kcore_vmem, kcore_kernel;
>+	static struct kcore_list kcore_kernel;
> 
> 	BUG_ON(PTRS_PER_PGD * sizeof(pgd_t) != PAGE_SIZE);
> 	BUG_ON(PTRS_PER_PMD * sizeof(pmd_t) != PAGE_SIZE);
>@@ -636,12 +636,7 @@ mem_init (void)
> 	BUG_ON(!mem_map);
> 	max_mapnr = max_low_pfn;
> #endif
>-
> 	high_memory = __va(max_low_pfn * PAGE_SIZE);
>-
>-	kclist_add(&kcore_mem, __va(0), max_low_pfn * PAGE_SIZE, KCORE_RAM);
>-	kclist_add(&kcore_vmem, (void *)VMALLOC_START,
>-			VMALLOC_END-VMALLOC_START, KCORE_VMALLOC);
> 	kclist_add(&kcore_kernel, _stext, _end - _stext, KCORE_TEXT);
> 
> 	for_each_online_pgdat(pgdat)
>Index: mmotm-2.6.31-Jul16/arch/powerpc/mm/init_64.c
>===================================================================
>--- mmotm-2.6.31-Jul16.orig/arch/powerpc/mm/init_64.c
>+++ mmotm-2.6.31-Jul16/arch/powerpc/mm/init_64.c
>@@ -110,7 +110,6 @@ void free_initrd_mem(unsigned long start
> #endif
> 
> #ifdef CONFIG_PROC_KCORE
>-static struct kcore_list kcore_vmem;
> 
> static int __init setup_kcore(void)
> {
>@@ -131,9 +130,6 @@ static int __init setup_kcore(void)
> 		kclist_add(kcore_mem, __va(base), size, KCORE_RAM);
> 	}
> 
>-	kclist_add(&kcore_vmem, (void *)VMALLOC_START,
>-		VMALLOC_END-VMALLOC_START, KCORE_VMALLOC);
>-
> 	return 0;
> }
> module_init(setup_kcore);
>Index: mmotm-2.6.31-Jul16/arch/sh/mm/init.c
>===================================================================
>--- mmotm-2.6.31-Jul16.orig/arch/sh/mm/init.c
>+++ mmotm-2.6.31-Jul16/arch/sh/mm/init.c
>@@ -181,7 +181,7 @@ void __init paging_init(void)
> 	set_fixmap_nocache(FIX_UNCACHED, __pa(&__uncached_start));
> }
> 
>-static struct kcore_list kcore_mem, kcore_vmalloc;
>+static struct kcore_list kcore_mem;
> 
> void __init mem_init(void)
> {
>@@ -219,8 +219,6 @@ void __init mem_init(void)
> 	initsize =  (unsigned long) &__init_end - (unsigned long) &__init_begin;
> 
> 	kclist_add(&kcore_mem, __va(0), max_low_pfn << PAGE_SHIFT, KCORE_RAM);
>-	kclist_add(&kcore_vmalloc, (void *)VMALLOC_START,
>-		   VMALLOC_END - VMALLOC_START, KCORE_VMALLOC);
> 
> 	printk(KERN_INFO "Memory: %luk/%luk available (%dk kernel code, "
> 	       "%dk data, %dk init)\n",
>
