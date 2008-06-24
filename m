Return-Path: <linux-kernel-owner+w=401wt.eu-S1755967AbYFXTSx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755967AbYFXTSx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 15:18:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754975AbYFXTS3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 15:18:29 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:17961 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754917AbYFXTS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 15:18:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=hJT4VgKIqS11B6lzalq27rFtBu1EfFEYURta1qMA5sA0Ff+AYahpBOMfCn/4ohZS1U
         Pat2CSYbVMGAlYukaNz2XmPRKse1rWd6MH6YvQ8kqCgZbyxTOdCV6ieCAZ+BpINnkodE
         6vBUcpYw+MJoTS+sf623ITzTImMH1xFGGLlHE=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86: introduce init_memory_mapping for 32bit #2
Date: Tue, 24 Jun 2008 12:18:58 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200806231951.10898.yhlu.kernel@gmail.com> <200806240410.47856.yhlu.kernel@gmail.com> <200806241218.14436.yhlu.kernel@gmail.com>
In-Reply-To: <200806241218.14436.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806241218.58613.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


moving relocate_initrd early

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>


---
 arch/x86/kernel/setup_32.c |   22 +++++++---------------
 arch/x86/mm/init_32.c      |    3 ---
 include/asm-x86/setup.h    |    1 -
 3 files changed, 7 insertions(+), 19 deletions(-)

Index: xy/arch/x86/kernel/setup_32.c
===================================================================
--- xy.orig/arch/x86/kernel/setup_32.c
+++ xy/arch/x86/kernel/setup_32.c
@@ -187,7 +187,7 @@ static inline void copy_edd(void)
 
 #ifdef CONFIG_BLK_DEV_INITRD
 
-static bool do_relocate_initrd = false;
+static void __init relocate_initrd(void);
 
 static void __init reserve_initrd(void)
 {
@@ -196,7 +196,6 @@ static void __init reserve_initrd(void)
 	u64 ramdisk_end   = ramdisk_image + ramdisk_size;
 	u64 end_of_lowmem = max_low_pfn << PAGE_SHIFT;
 	u64 ramdisk_here;
-	u64 ramdisk_target;
 
 	if (!boot_params.hdr.type_of_loader ||
 	    !ramdisk_image || !ramdisk_size)
@@ -243,12 +242,12 @@ static void __init reserve_initrd(void)
 	printk(KERN_INFO "Allocated new RAMDISK: %08llx - %08llx\n",
 			 ramdisk_here, ramdisk_here + ramdisk_size);
 
-	do_relocate_initrd = true;
+	relocate_initrd();
 }
 
 #define MAX_MAP_CHUNK	(NR_FIX_BTMAPS << PAGE_SHIFT)
 
-void __init post_reserve_initrd(void)
+static void __init relocate_initrd(void)
 {
 	u64 ramdisk_image = boot_params.hdr.ramdisk_image;
 	u64 ramdisk_size  = boot_params.hdr.ramdisk_size;
@@ -257,9 +256,6 @@ void __init post_reserve_initrd(void)
 	unsigned long slop, clen, mapaddr;
 	char *p, *q;
 
-	if (!do_relocate_initrd)
-		return;
-
 	ramdisk_here = initrd_start - PAGE_OFFSET;
 
 	q = (char *)initrd_start;
@@ -270,10 +266,6 @@ void __init post_reserve_initrd(void)
 		p = (char *)__va(ramdisk_image);
 		memcpy(q, p, clen);
 		q += clen;
-		/* need to free these low pages...*/
-		printk(KERN_INFO "Freeing old partial RAMDISK %08llx-%08llx\n",
-			 ramdisk_image, ramdisk_image + clen - 1);
-		free_bootmem(ramdisk_image, clen);
 		ramdisk_image += clen;
 		ramdisk_size  -= clen;
 	}
@@ -299,16 +291,16 @@ void __init post_reserve_initrd(void)
 		ramdisk_image, ramdisk_image + ramdisk_size - 1,
 		ramdisk_here, ramdisk_here + ramdisk_size - 1);
 
-	/* need to free that, otherwise init highmem will reserve it again */
+	/*
+	 * need to free old one, otherwise init cross max_low_pfn could be
+	 * converted to bootmem
+	 */
 	free_early(ramdisk_image, ramdisk_image+ramdisk_size);
 }
 #else
 void __init reserve_initrd(void)
 {
 }
-void __init post_reserve_initrd(void)
-{
-}
 #endif /* CONFIG_BLK_DEV_INITRD */
 
 #ifdef CONFIG_MCA
Index: xy/arch/x86/mm/init_32.c
===================================================================
--- xy.orig/arch/x86/mm/init_32.c
+++ xy/arch/x86/mm/init_32.c
@@ -831,9 +831,6 @@ void __init paging_init(void)
 	/*
 	 * NOTE: at this point the bootmem allocator is fully available.
 	 */
-
-	post_reserve_initrd();
-
 	remapped_pgdat_init();
 	sparse_init();
 	zone_sizes_init();
Index: xy/include/asm-x86/setup.h
===================================================================
--- xy.orig/include/asm-x86/setup.h
+++ xy/include/asm-x86/setup.h
@@ -39,7 +39,6 @@ void reserve_crashkernel(void);
 #include <asm/bootparam.h>
 
 void reserve_standard_io_resources(void);
-extern void post_reserve_initrd(void);
 
 #ifndef _SETUP
 
