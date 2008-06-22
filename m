Return-Path: <linux-kernel-owner+w=401wt.eu-S1754168AbYFVJqb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168AbYFVJqb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 05:46:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751675AbYFVJqF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 05:46:05 -0400
Received: from rv-out-0506.google.com ([209.85.198.226]:11679 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbYFVJqB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 05:46:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=Kbh7kVDPsj7srOFEe3LANATkRnb5umrodUSaqE/zffpVY0+iClLwReuyDsUYYXbMD6
         +1POOZ039OKi0hLYLggjuk7RFj6HnNFhgCFx2OXi2oOt0HbKPi4LKG4n51kU6CfmYwt9
         J5LGgsqeYUnCJmR537NsOB9AcO12IvI0NzxYA=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] x86: introduce reserve_initrd
Date: Sun, 22 Jun 2008 02:46:58 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200806180215.53755.yhlu.kernel@gmail.com> <200806220244.50256.yhlu.kernel@gmail.com> <200806220245.39289.yhlu.kernel@gmail.com>
In-Reply-To: <200806220245.39289.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806220246.58958.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/setup_32.c |   16 ++++++++-----
 arch/x86/kernel/setup_64.c |   53 ++++++++++++++++++++++++---------------------
 arch/x86/mm/init_32.c      |    6 +----
 include/asm-x86/setup.h    |    2 +
 4 files changed, 43 insertions(+), 34 deletions(-)

Index: linux-2.6/arch/x86/kernel/setup_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup_32.c
+++ linux-2.6/arch/x86/kernel/setup_32.c
@@ -337,7 +337,7 @@ void __init reserve_initrd(void)
 		 * in i386_start_kernel
 		 */
 		initrd_start = ramdisk_image + PAGE_OFFSET;
-		initrd_end = initrd_start+ramdisk_size;
+		initrd_end = initrd_start + ramdisk_size;
 		return;
 	}
 
@@ -364,7 +364,7 @@ void __init reserve_initrd(void)
 
 #define MAX_MAP_CHUNK	(NR_FIX_BTMAPS << PAGE_SHIFT)
 
-static void __init relocate_initrd(void)
+static void __init post_reserve_initrd(void)
 {
 	u64 ramdisk_image = boot_params.hdr.ramdisk_image;
 	u64 ramdisk_size  = boot_params.hdr.ramdisk_size;
@@ -418,7 +418,13 @@ static void __init relocate_initrd(void)
 	/* need to free that, otherwise init highmem will reserve it again */
 	free_early(ramdisk_image, ramdisk_image+ramdisk_size);
 }
-
+#else
+void __init reserve_initrd(void)
+{
+}
+static void __init post_reserve_initrd(void)
+{
+}
 #endif /* CONFIG_BLK_DEV_INITRD */
 
 /*
@@ -638,9 +644,7 @@ void __init setup_arch(char **cmdline_p)
 	 * NOTE: at this point the bootmem allocator is fully available.
 	 */
 
-#ifdef CONFIG_BLK_DEV_INITRD
-	relocate_initrd();
-#endif
+	post_reserve_initrd();
 
 	remapped_pgdat_init();
 	sparse_init();
Index: linux-2.6/arch/x86/kernel/setup_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup_64.c
+++ linux-2.6/arch/x86/kernel/setup_64.c
@@ -154,6 +154,33 @@ static inline void copy_edd(void)
 }
 #endif
 
+void __init reserve_initrd(void)
+{
+#ifdef CONFIG_BLK_DEV_INITRD
+	if (boot_params.hdr.type_of_loader && boot_params.hdr.ramdisk_image) {
+		unsigned long ramdisk_image = boot_params.hdr.ramdisk_image;
+		unsigned long ramdisk_size  = boot_params.hdr.ramdisk_size;
+		unsigned long ramdisk_end   = ramdisk_image + ramdisk_size;
+		unsigned long end_of_mem    = end_pfn << PAGE_SHIFT;
+
+		if (ramdisk_end <= end_of_mem) {
+			/*
+			 * don't need to reserve again, already reserved early
+			 * in x86_64_start_kernel, and early_res_to_bootmem
+			 * will convert that to reserved in bootmem
+			 */
+			initrd_start = ramdisk_image + PAGE_OFFSET;
+			initrd_end = initrd_start+ramdisk_size;
+		} else {
+			free_early(ramdisk_image, ramdisk_end);
+			printk(KERN_ERR "initrd extends beyond end of memory "
+			       "(0x%08lx > 0x%08lx)\ndisabling initrd\n",
+			       ramdisk_end, end_of_mem);
+			initrd_start = 0;
+		}
+	}
+#endif
+}
 /*
  * setup_arch - architecture-specific boot-time initializations
  *
@@ -251,6 +278,8 @@ void __init setup_arch(char **cmdline_p)
 		end_pfn = e820_end_of_ram();
 	}
 
+	reserve_initrd();
+
 	num_physpages = end_pfn;
 
 	check_efer();
@@ -307,30 +336,6 @@ void __init setup_arch(char **cmdline_p)
 	*/
 	find_smp_config();
 #endif
-#ifdef CONFIG_BLK_DEV_INITRD
-	if (boot_params.hdr.type_of_loader && boot_params.hdr.ramdisk_image) {
-		unsigned long ramdisk_image = boot_params.hdr.ramdisk_image;
-		unsigned long ramdisk_size  = boot_params.hdr.ramdisk_size;
-		unsigned long ramdisk_end   = ramdisk_image + ramdisk_size;
-		unsigned long end_of_mem    = end_pfn << PAGE_SHIFT;
-
-		if (ramdisk_end <= end_of_mem) {
-			/*
-			 * don't need to reserve again, already reserved early
-			 * in x86_64_start_kernel, and early_res_to_bootmem
-			 * convert that to reserved in bootmem
-			 */
-			initrd_start = ramdisk_image + PAGE_OFFSET;
-			initrd_end = initrd_start+ramdisk_size;
-		} else {
-			free_bootmem(ramdisk_image, ramdisk_size);
-			printk(KERN_ERR "initrd extends beyond end of memory "
-			       "(0x%08lx > 0x%08lx)\ndisabling initrd\n",
-			       ramdisk_end, end_of_mem);
-			initrd_start = 0;
-		}
-	}
-#endif
 	reserve_crashkernel();
 
 	reserve_ibft_region();
Index: linux-2.6/arch/x86/mm/init_32.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/init_32.c
+++ linux-2.6/arch/x86/mm/init_32.c
@@ -597,8 +597,6 @@ void __init zone_sizes_init(void)
 }
 #endif /* !CONFIG_NEED_MULTIPLE_NODES */
 
-extern void reserve_initrd(void);
-
 void __init setup_bootmem_allocator(void)
 {
 	int i;
@@ -613,9 +611,9 @@ void __init setup_bootmem_allocator(void
 	if (bootmap == -1L)
 		panic("Cannot find bootmem map of size %ld\n", bootmap_size);
 	reserve_early(bootmap, bootmap + bootmap_size, "BOOTMAP");
-#ifdef CONFIG_BLK_DEV_INITRD
+
 	reserve_initrd();
-#endif
+
 	bootmap_size = init_bootmem(bootmap >> PAGE_SHIFT, max_low_pfn);
 	printk(KERN_INFO "  mapped low ram: 0 - %08lx\n",
 		 max_pfn_mapped<<PAGE_SHIFT);
Index: linux-2.6/include/asm-x86/setup.h
===================================================================
--- linux-2.6.orig/include/asm-x86/setup.h
+++ linux-2.6/include/asm-x86/setup.h
@@ -39,6 +39,8 @@ void reserve_crashkernel(void);
 #include <asm/bootparam.h>
 
 void reserve_standard_io_resources(void);
+void reserve_initrd(void);
+
 
 #ifndef _SETUP
 
