Return-Path: <linux-kernel-owner+w=401wt.eu-S1758241AbYAHIbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758241AbYAHIbT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 03:31:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756801AbYAHIbK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 03:31:10 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35478 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755948AbYAHIbJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 03:31:09 -0500
Date: Tue, 8 Jan 2008 09:30:44 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixer <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, vgoyal@redhat.com,
       hbabu@us.ibm.com, kexec@lists.infradead.org
Subject: Re: [PATCH] i386: handle an initrd in highmem (version 2)
Message-ID: <20080108083044.GI31838@elte.hu>
References: <200801080502.m0852rhW017142@tazenda.hos.anvin.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801080502.m0852rhW017142@tazenda.hos.anvin.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> Fix crash on NUMA reported by Dhaval Giani (reported as being a kexec 
> issue.)

here's the delta fix.

	Ingo

Index: linux-x86.q/arch/x86/kernel/setup_32.c
===================================================================
--- linux-x86.q.orig/arch/x86/kernel/setup_32.c
+++ linux-x86.q/arch/x86/kernel/setup_32.c
@@ -510,16 +510,20 @@ static void __init reserve_initrd(void)
 	unsigned long end_of_lowmem = max_low_pfn << PAGE_SHIFT;
 	unsigned long ramdisk_here;
 
+	initrd_start = 0;
+
+	if (!boot_params.hdr.type_of_loader ||
+	    !ramdisk_image || !ramdisk_size)
+		return;		/* No initrd provided by bootloader */
+
 	if (ramdisk_end < ramdisk_image) {
-		printk(KERN_ERR "initrd wraps around end of memory\n"
-		       KERN_ERR "disabling initrd\n");
-		initrd_start = 0;
+		printk(KERN_ERR "initrd wraps around end of memory, "
+		       "disabling initrd\n");
 		return;
 	}
 	if (ramdisk_size >= end_of_lowmem/2) {
-		printk(KERN_ERR "initrd too large to handle\n"
-		       KERN_ERR "disabling initrd\n");
-		initrd_start = 0;
+		printk(KERN_ERR "initrd too large to handle, "
+		       "disabling initrd\n");
 		return;
 	}
 	if (ramdisk_end <= end_of_lowmem) {
@@ -554,9 +558,10 @@ static void __init relocate_initrd(void)
 	char *p, *q;
 
 	if (!do_relocate_initrd)
-		return;		/* Nothing to do here... */
+		return;
 
 	ramdisk_here = initrd_start - PAGE_OFFSET;
+
 	q = (char *)initrd_start;
 
 	/* Copy any lowmem portion of the initrd */
@@ -642,11 +647,10 @@ void __init setup_bootmem_allocator(void
 	 */
 	find_smp_config();
 #endif
-	numa_kva_reserve();
 #ifdef CONFIG_BLK_DEV_INITRD
-	if (boot_params.hdr.type_of_loader && boot_params.hdr.ramdisk_image)
-		reserve_initrd();
+	reserve_initrd();
 #endif
+	numa_kva_reserve();
 	reserve_crashkernel();
 }
 
@@ -799,12 +803,13 @@ void __init setup_arch(char **cmdline_p)
 	/*
 	 * NOTE: at this point the bootmem allocator is fully available.
 	 */
-	paravirt_post_allocator_init();
 
 #ifdef CONFIG_BLK_DEV_INITRD
 	relocate_initrd();
 #endif
 
+	paravirt_post_allocator_init();
+
 	dmi_scan_machine();
 
 	io_delay_init();
Index: linux-x86.q/arch/x86/mm/discontig_32.c
===================================================================
--- linux-x86.q.orig/arch/x86/mm/discontig_32.c
+++ linux-x86.q/arch/x86/mm/discontig_32.c
@@ -288,8 +288,8 @@ unsigned long __init setup_memory(void)
 
 #ifdef CONFIG_BLK_DEV_INITRD
 	/* Numa kva area is below the initrd */
-	if (boot_params.hdr.type_of_loader && boot_params.hdr.ramdisk_image)
-		kva_start_pfn = PFN_DOWN(boot_params.hdr.ramdisk_image)
+	if (initrd_start)
+		kva_start_pfn = PFN_DOWN(initrd_start - PAGE_OFFSET)
 			- kva_pages;
 #endif
 	kva_start_pfn -= kva_start_pfn & (PTRS_PER_PTE-1);
