Return-Path: <linux-kernel-owner+w=401wt.eu-S932997AbYAaUhm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932997AbYAaUhm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 15:37:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762666AbYAaUhP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 15:37:15 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:49130 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762197AbYAaUhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 15:37:12 -0500
Date: Thu, 31 Jan 2008 12:37:25 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH] x86_64: add debug name for early_res
In-reply-to: <200801311434.31011.ak@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <ak@suse.de>, Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Message-id: <200801311237.26080.yinghai.lu@sun.com>
Organization: Sun
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7BIT
Content-disposition: inline
References: <200801291113.35974.yinghai.lu@sun.com>
 <20080131132438.GC8499@elte.hu> <200801311434.31011.ak@suse.de>
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] x86_64: add debug name for early_res

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

Index: linux-2.6/arch/x86/kernel/e820_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/e820_64.c
+++ linux-2.6/arch/x86/kernel/e820_64.c
@@ -54,30 +54,33 @@ static unsigned long __initdata end_user
 
 struct early_res {
 	unsigned long start, end;
+	char name[16];
 };
 static struct early_res early_res[MAX_EARLY_RES] __initdata = {
-	{ 0, PAGE_SIZE },			/* BIOS data page */
+	{ 0, PAGE_SIZE, "BIOS data page" },			/* BIOS data page */
 #ifdef CONFIG_SMP
-	{ SMP_TRAMPOLINE_BASE, SMP_TRAMPOLINE_BASE + 2*PAGE_SIZE },
+	{ SMP_TRAMPOLINE_BASE, SMP_TRAMPOLINE_BASE + 2*PAGE_SIZE, "SMP_TRAMPOLINE" },
 #endif
 	{}
 };
 
-void __init reserve_early(unsigned long start, unsigned long end)
+void __init reserve_early(unsigned long start, unsigned long end, char *name)
 {
 	int i;
 	struct early_res *r;
 	for (i = 0; i < MAX_EARLY_RES && early_res[i].end; i++) {
 		r = &early_res[i];
 		if (end > r->start && start < r->end)
-			panic("Overlapping early reservations %lx-%lx to %lx-%lx\n",
-			      start, end, r->start, r->end);
+			panic("Overlapping early reservations %lx-%lx %s to %lx-%lx %s\n",
+			      start, end - 1, name?name:"", r->start, r->end - 1, r->name);
 	}
 	if (i >= MAX_EARLY_RES)
 		panic("Too many early reservations");
 	r = &early_res[i];
 	r->start = start;
 	r->end = end;
+	if (name)
+		strncpy(r->name, name, sizeof(r->name) - 1);
 }
 
 void __init early_res_to_bootmem(void)
@@ -85,6 +88,8 @@ void __init early_res_to_bootmem(void)
 	int i;
 	for (i = 0; i < MAX_EARLY_RES && early_res[i].end; i++) {
 		struct early_res *r = &early_res[i];
+		printk(KERN_INFO "early res: %d [%lx-%lx] %s\n", i,
+			r->start, r->end - 1, r->name);
 		reserve_bootmem_generic(r->start, r->end - r->start);
 	}
 }
Index: linux-2.6/arch/x86/kernel/head64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/head64.c
+++ linux-2.6/arch/x86/kernel/head64.c
@@ -75,7 +75,7 @@ static __init void reserve_ebda(void)
 	if (ebda_size > 64*1024)
 		ebda_size = 64*1024;
 
-	reserve_early(ebda_addr, ebda_addr + ebda_size);
+	reserve_early(ebda_addr, ebda_addr + ebda_size, "EBDA");
 }
 
 void __init x86_64_start_kernel(char * real_mode_data)
@@ -105,14 +105,14 @@ void __init x86_64_start_kernel(char * r
 	pda_init(0);
 	copy_bootdata(__va(real_mode_data));
 
-	reserve_early(__pa_symbol(&_text), __pa_symbol(&_end));
+	reserve_early(__pa_symbol(&_text), __pa_symbol(&_end), "TEXT DATA BSS");
 
 	/* Reserve INITRD */
 	if (boot_params.hdr.type_of_loader && boot_params.hdr.ramdisk_image) {
 		unsigned long ramdisk_image = boot_params.hdr.ramdisk_image;
 		unsigned long ramdisk_size  = boot_params.hdr.ramdisk_size;
 		unsigned long ramdisk_end   = ramdisk_image + ramdisk_size;
-		reserve_early(ramdisk_image, ramdisk_end);
+		reserve_early(ramdisk_image, ramdisk_end, "RAMDISK");
 	}
 
 	reserve_ebda();
Index: linux-2.6/arch/x86/mm/init_64.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/init_64.c
+++ linux-2.6/arch/x86/mm/init_64.c
@@ -420,7 +420,7 @@ void __init_refok init_memory_mapping(un
 		mmu_cr4_features = read_cr4();
 	__flush_tlb_all();
 
-	reserve_early(table_start << PAGE_SHIFT, table_end << PAGE_SHIFT);
+	reserve_early(table_start << PAGE_SHIFT, table_end << PAGE_SHIFT, "PGTABLE");
 }
 
 #ifndef CONFIG_NUMA
Index: linux-2.6/arch/x86/mm/numa_64.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/numa_64.c
+++ linux-2.6/arch/x86/mm/numa_64.c
@@ -103,7 +103,7 @@ static int __init allocate_cachealigned_
 	}
 	pad_addr = (nodemap_addr + pad) & ~pad;
 	memnodemap = phys_to_virt(pad_addr);
-	reserve_early(nodemap_addr, nodemap_addr + nodemap_size);
+	reserve_early(nodemap_addr, nodemap_addr + nodemap_size, "MEMNODEMAP");
 
 	printk(KERN_DEBUG "NUMA: Allocated memnodemap from %lx - %lx\n",
 	       nodemap_addr, nodemap_addr + nodemap_size);
Index: linux-2.6/include/asm-x86/e820_64.h
===================================================================
--- linux-2.6.orig/include/asm-x86/e820_64.h
+++ linux-2.6/include/asm-x86/e820_64.h
@@ -41,7 +41,7 @@ extern void finish_e820_parsing(void);
 extern struct e820map e820;
 extern void update_e820(void);
 
-extern void reserve_early(unsigned long start, unsigned long end);
+extern void reserve_early(unsigned long start, unsigned long end, char *name);
 extern void early_res_to_bootmem(void);
 
 #endif/*!__ASSEMBLY__*/
