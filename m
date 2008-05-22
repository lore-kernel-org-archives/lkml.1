Return-Path: <linux-kernel-owner+w=401wt.eu-S1759616AbYEVWT6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759616AbYEVWT6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 18:19:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765514AbYEVWTb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 18:19:31 -0400
Received: from el-out-1112.google.com ([209.85.162.177]:8842 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765123AbYEVWT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 18:19:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=tuRPvGHvdkUIcdLLgORncziZhEcbAkRXpU4HHntb/5ODwdPTCYNiXPQ7n83JGtK9ugtRJfopJVlS9AvuVToANQftpGbQ/uzeJyS+f7X/HIJaXpqzBZmcZm1vVoCPLir8xU/rPGo2o6/mRQkOlku+sTYEns9GxQaUqKQehtXs8UA=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: [PATCH] x86: extend e820 ealy_res support 32bit - fix v2
Date: Thu, 22 May 2008 15:20:18 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200805110030.15510.yhlu.kernel@gmail.com> <200805180118.57863.yhlu.kernel@gmail.com> <200805211840.18619.yhlu.kernel@gmail.com>
In-Reply-To: <200805211840.18619.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805221520.19259.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] x86: extend e820 ealy_res support 32bit - fix v2

use find_e820_area to find addess for new RAMDISK, instead of using ram blindly

also print out low ram and bootmap info

v2: remove extra -1 in reaseve_early calling
    panic if can not find space for new RAMDISK

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

Index: linux-2.6/arch/x86/kernel/setup_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup_32.c
+++ linux-2.6/arch/x86/kernel/setup_32.c
@@ -466,11 +466,11 @@ static bool do_relocate_initrd = false;
 
 static void __init reserve_initrd(void)
 {
-	unsigned long ramdisk_image = boot_params.hdr.ramdisk_image;
-	unsigned long ramdisk_size  = boot_params.hdr.ramdisk_size;
-	unsigned long ramdisk_end   = ramdisk_image + ramdisk_size;
-	unsigned long end_of_lowmem = max_low_pfn << PAGE_SHIFT;
-	unsigned long ramdisk_here;
+	u64 ramdisk_image = boot_params.hdr.ramdisk_image;
+	u64 ramdisk_size  = boot_params.hdr.ramdisk_size;
+	u64 ramdisk_end   = ramdisk_image + ramdisk_size;
+	u64 end_of_lowmem = max_low_pfn << PAGE_SHIFT;
+	u64 ramdisk_here;
 
 	if (!boot_params.hdr.type_of_loader ||
 	    !ramdisk_image || !ramdisk_size)
@@ -478,14 +478,8 @@ static void __init reserve_initrd(void)
 
 	initrd_start = 0;
 
-	if (ramdisk_end < ramdisk_image) {
-		free_bootmem(ramdisk_image, ramdisk_size);
-		printk(KERN_ERR "initrd wraps around end of memory, "
-		       "disabling initrd\n");
-		return;
-	}
 	if (ramdisk_size >= end_of_lowmem/2) {
-		free_bootmem(ramdisk_image, ramdisk_size);
+		free_early(ramdisk_image, ramdisk_end);
 		printk(KERN_ERR "initrd too large to handle, "
 		       "disabling initrd\n");
 		return;
@@ -495,8 +489,7 @@ static void __init reserve_initrd(void)
 		/* All in lowmem, easy case */
 		/*
 		 * don't need to reserve again, already reserved early
-		 * in i386_start_kernel, and early_res_to_bootmem
-		 * convert that to reserved in bootmem
+		 * in i386_start_kernel
 		 */
 		initrd_start = ramdisk_image + PAGE_OFFSET;
 		initrd_end = initrd_start+ramdisk_size;
@@ -504,11 +497,18 @@ static void __init reserve_initrd(void)
 	}
 
 	/* We need to move the initrd down into lowmem */
-	ramdisk_here = (end_of_lowmem - ramdisk_size) & PAGE_MASK;
+	ramdisk_here = find_e820_area(min_low_pfn<<PAGE_SHIFT,
+				 end_of_lowmem, ramdisk_size,
+				 PAGE_SIZE);
+
+	if (ramdisk_here == -1ULL)
+		panic("Cannot find placce for new RAMDISK of size %lld\n",
+			 ramdisk_size);
 
 	/* Note: this includes all the lowmem currently occupied by
 	   the initrd, we rely on that fact to keep the data intact. */
-	reserve_bootmem(ramdisk_here, ramdisk_size, BOOTMEM_DEFAULT);
+	reserve_early(ramdisk_here, ramdisk_here + ramdisk_size,
+			 "NEW RAMDISK");
 	initrd_start = ramdisk_here + PAGE_OFFSET;
 	initrd_end   = initrd_start + ramdisk_size;
 
@@ -519,10 +519,10 @@ static void __init reserve_initrd(void)
 
 static void __init relocate_initrd(void)
 {
-	unsigned long ramdisk_image = boot_params.hdr.ramdisk_image;
-	unsigned long ramdisk_size  = boot_params.hdr.ramdisk_size;
-	unsigned long end_of_lowmem = max_low_pfn << PAGE_SHIFT;
-	unsigned long ramdisk_here;
+	u64 ramdisk_image = boot_params.hdr.ramdisk_image;
+	u64 ramdisk_size  = boot_params.hdr.ramdisk_size;
+	u64 end_of_lowmem = max_low_pfn << PAGE_SHIFT;
+	u64 ramdisk_here;
 	unsigned long slop, clen, mapaddr;
 	char *p, *q;
 
@@ -540,6 +540,8 @@ static void __init relocate_initrd(void)
 		memcpy(q, p, clen);
 		q += clen;
 		/* need to free these low pages...*/
+		printk(KERN_INFO "Freeing old partial RAMDISK %08llx-%08llx\n",
+			 ramdisk_image, ramdisk_image + clen - 1);
 		free_bootmem(ramdisk_image, clen);
 		ramdisk_image += clen;
 		ramdisk_size  -= clen;
@@ -560,6 +562,11 @@ static void __init relocate_initrd(void)
 		ramdisk_size  -= clen;
 	}
 	/* high pages is not converted by early_res_to_bootmem */
+	ramdisk_image = boot_params.hdr.ramdisk_image;
+	ramdisk_size  = boot_params.hdr.ramdisk_size;
+	printk(KERN_INFO "Copied RAMDISK from %016llx - %016llx to %08llx - %08llx\n",
+		ramdisk_image, ramdisk_image + ramdisk_size - 1,
+		ramdisk_here, ramdisk_here + ramdisk_size - 1);
 }
 
 #endif /* CONFIG_BLK_DEV_INITRD */
@@ -576,10 +583,17 @@ void __init setup_bootmem_allocator(void
 				 PAGE_SIZE);
 	if (bootmap == -1L)
 		panic("Cannot find bootmem map of size %ld\n", bootmap_size);
+	reserve_early(bootmap, bootmap + bootmap_size, "BOOTMAP");
+#ifdef CONFIG_BLK_DEV_INITRD
+	reserve_initrd();
+#endif
 	bootmap_size = init_bootmem(bootmap >> PAGE_SHIFT, max_low_pfn);
+	printk(KERN_INFO "  low ram: %08lx - %08lx\n",
+		 min_low_pfn<<PAGE_SHIFT, max_low_pfn<<PAGE_SHIFT);
+	printk(KERN_INFO "  bootmap %08lx - %08lx\n",
+		 bootmap, bootmap + bootmap_size);
 	register_bootmem_low_pages(max_low_pfn);
 	early_res_to_bootmem(0, max_low_pfn<<PAGE_SHIFT);
-	reserve_bootmem(bootmap, bootmap_size, BOOTMEM_DEFAULT);
 
 #ifdef CONFIG_ACPI_SLEEP
 	/*
@@ -593,9 +607,6 @@ void __init setup_bootmem_allocator(void
 	 */
 	find_smp_config();
 #endif
-#ifdef CONFIG_BLK_DEV_INITRD
-	reserve_initrd();
-#endif
 	numa_kva_reserve();
 	reserve_crashkernel();
 
