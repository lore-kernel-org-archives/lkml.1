Return-Path: <linux-kernel-owner+w=401wt.eu-S1759593AbYE2T7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759593AbYE2T7T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 15:59:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755159AbYE2T7E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 15:59:04 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:34417 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753989AbYE2T7B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 15:59:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=u2KWw0RgMl6RksE5j7A+qT/1y8xy83vGMEGXbja39Jq0TVZxnmD5CSvYIsRs3wz4fM8425HV4tbi/tErhQyl9jFSSzeI1unEPL3K12wu9AR9W1K13RGS1oHwrLsvHEPLNkgekL+yJTzHqdBVJeSxcYI9J5xio3O/O2A1I577poE=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: [PATCH] x86: extend e820 early_res support 32bit -fix #3
Date: Thu, 29 May 2008 12:56:36 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200805110030.15510.yhlu.kernel@gmail.com> <200805211840.18619.yhlu.kernel@gmail.com> <200805251000.10205.yhlu.kernel@gmail.com>
In-Reply-To: <200805251000.10205.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805291256.36898.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


introduce init_pg_table_start, so xen PV could specify the value.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

Index: linux-2.6/arch/x86/kernel/head32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/head32.c
+++ linux-2.6/arch/x86/kernel/head32.c
@@ -76,7 +76,8 @@ void __init i386_start_kernel(void)
 		reserve_early(ramdisk_image, ramdisk_end, "RAMDISK");
 	}
 #endif
-	reserve_early(__pa_symbol(&_end), init_pg_tables_end, "INIT_PG_TABLE");
+	reserve_early(init_pg_tables_start, init_pg_tables_end,
+			"INIT_PG_TABLE");
 
 	reserve_ebda_region();
 
Index: linux-2.6/arch/x86/kernel/head_32.S
===================================================================
--- linux-2.6.orig/arch/x86/kernel/head_32.S
+++ linux-2.6/arch/x86/kernel/head_32.S
@@ -194,6 +194,7 @@ default_entry:
 	xorl %ebx,%ebx				/* %ebx is kept at zero */
 
 	movl $pa(pg0), %edi
+	movl %edi, pa(init_pg_tables_start)
 	movl $pa(swapper_pg_pmd), %edx
 	movl $PTE_ATTR, %eax
 10:
@@ -228,6 +229,7 @@ default_entry:
 page_pde_offset = (__PAGE_OFFSET >> 20);
 
 	movl $pa(pg0), %edi
+	movl %edi, pa(init_pg_tables_start)
 	movl $pa(swapper_pg_dir), %edx
 	movl $PTE_ATTR, %eax
 10:
Index: linux-2.6/arch/x86/kernel/setup_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup_32.c
+++ linux-2.6/arch/x86/kernel/setup_32.c
@@ -72,6 +72,7 @@
 /* This value is set up by the early boot code to point to the value
    immediately after the boot time page tables.  It contains a *physical*
    address, and must not be in the .bss segment! */
+unsigned long init_pg_tables_start __initdata = ~0UL;
 unsigned long init_pg_tables_end __initdata = ~0UL;
 
 /*
@@ -486,6 +487,10 @@ static void __init reserve_initrd(void)
 		return;
 	}
 
+	printk(KERN_INFO "old RAMDISK: %08llx - %08llx\n", ramdisk_image,
+			ramdisk_end);
+
+
 	if (ramdisk_end <= end_of_lowmem) {
 		/* All in lowmem, easy case */
 		/*
@@ -512,6 +517,8 @@ static void __init reserve_initrd(void)
 			 "NEW RAMDISK");
 	initrd_start = ramdisk_here + PAGE_OFFSET;
 	initrd_end   = initrd_start + ramdisk_size;
+	printk(KERN_INFO "Allocated new RAMDISK: %08llx - %08llx\n",
+			 ramdisk_here, ramdisk_here + ramdisk_size);
 
 	do_relocate_initrd = true;
 }
Index: linux-2.6/arch/x86/lguest/boot.c
===================================================================
--- linux-2.6.orig/arch/x86/lguest/boot.c
+++ linux-2.6/arch/x86/lguest/boot.c
@@ -1012,6 +1012,7 @@ __init void lguest_init(void)
 	 * clobbered.  The Launcher places our initial pagetables somewhere at
 	 * the top of our physical memory, so we don't need extra space: set
 	 * init_pg_tables_end to the end of the kernel. */
+	init_pg_tables_start = __pa(pg0);
 	init_pg_tables_end = __pa(pg0);
 
 	/* Load the %fs segment register (the per-cpu segment register) with
@@ -1065,9 +1066,9 @@ __init void lguest_init(void)
 	pm_power_off = lguest_power_off;
 	machine_ops.restart = lguest_restart;
 
-	/* Now we're set up, call start_kernel() in init/main.c and we proceed
+	/* Now we're set up, call i386_start_kernel() in head32.c and we proceed
 	 * to boot as normal.  It never returns. */
-	start_kernel();
+	i386_start_kernel();
 }
 /*
  * This marks the end of stage II of our journey, The Guest.
Index: linux-2.6/arch/x86/xen/enlighten.c
===================================================================
--- linux-2.6.orig/arch/x86/xen/enlighten.c
+++ linux-2.6/arch/x86/xen/enlighten.c
@@ -1228,6 +1228,7 @@ asmlinkage void __init xen_start_kernel(
 
 	pgd = (pgd_t *)xen_start_info->pt_base;
 
+	init_pg_tables_start = __pa(pgd);
 	init_pg_tables_end = __pa(pgd) + xen_start_info->nr_pt_frames*PAGE_SIZE;
 
 	init_mm.pgd = pgd; /* use the Xen pagetables to start */
@@ -1266,5 +1267,5 @@ asmlinkage void __init xen_start_kernel(
 	}
 
 	/* Start the world */
-	start_kernel();
+	i386_start_kernel();
 }
Index: linux-2.6/include/asm-x86/setup.h
===================================================================
--- linux-2.6.orig/include/asm-x86/setup.h
+++ linux-2.6/include/asm-x86/setup.h
@@ -53,9 +53,11 @@ extern struct boot_params boot_params;
 char * __init machine_specific_memory_setup(void);
 char *memory_setup(void);
 
-extern unsigned long init_pg_tables_end;
 
+void __init i386_start_kernel(void);
 
+extern unsigned long init_pg_tables_start;
+extern unsigned long init_pg_tables_end;
 
 #endif /* __i386__ */
 #endif /* _SETUP */
