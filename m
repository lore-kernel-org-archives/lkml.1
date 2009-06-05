Return-Path: <linux-kernel-owner+w=401wt.eu-S1754480AbZFECOs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754480AbZFECOs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 22:14:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752292AbZFECOl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 22:14:41 -0400
Received: from hera.kernel.org ([140.211.167.34]:49333 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751347AbZFECOk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 22:14:40 -0400
Message-ID: <4A287F7E.1000402@kernel.org>
Date: Thu, 04 Jun 2009 19:14:22 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: make 64 bit to use relocate_initrd too
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


found one system memory (according e820) is not covered by mtrr.
mtrr_trim_memory converts portion memory to reserved.
but bootloader put the initrd in that range already.

need to have 64bit to use relocate_initrd too.

[ Impact: fix using initrd when mtrr_trim_memory happen ]

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/setup.c |   15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

Index: linux-2.6/arch/x86/kernel/setup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup.c
+++ linux-2.6/arch/x86/kernel/setup.c
@@ -301,15 +301,13 @@ static void __init reserve_brk(void)
 
 #ifdef CONFIG_BLK_DEV_INITRD
 
-#ifdef CONFIG_X86_32
-
 #define MAX_MAP_CHUNK	(NR_FIX_BTMAPS << PAGE_SHIFT)
 static void __init relocate_initrd(void)
 {
 
 	u64 ramdisk_image = boot_params.hdr.ramdisk_image;
 	u64 ramdisk_size  = boot_params.hdr.ramdisk_size;
-	u64 end_of_lowmem = max_low_pfn << PAGE_SHIFT;
+	u64 end_of_lowmem = max_low_pfn_mapped << PAGE_SHIFT;
 	u64 ramdisk_here;
 	unsigned long slop, clen, mapaddr;
 	char *p, *q;
@@ -365,14 +363,13 @@ static void __init relocate_initrd(void)
 		ramdisk_image, ramdisk_image + ramdisk_size - 1,
 		ramdisk_here, ramdisk_here + ramdisk_size - 1);
 }
-#endif
 
 static void __init reserve_initrd(void)
 {
 	u64 ramdisk_image = boot_params.hdr.ramdisk_image;
 	u64 ramdisk_size  = boot_params.hdr.ramdisk_size;
 	u64 ramdisk_end   = ramdisk_image + ramdisk_size;
-	u64 end_of_lowmem = max_low_pfn << PAGE_SHIFT;
+	u64 end_of_lowmem = max_low_pfn_mapped << PAGE_SHIFT;
 
 	if (!boot_params.hdr.type_of_loader ||
 	    !ramdisk_image || !ramdisk_size)
@@ -402,14 +399,8 @@ static void __init reserve_initrd(void)
 		return;
 	}
 
-#ifdef CONFIG_X86_32
 	relocate_initrd();
-#else
-	printk(KERN_ERR "initrd extends beyond end of memory "
-	       "(0x%08llx > 0x%08llx)\ndisabling initrd\n",
-	       ramdisk_end, end_of_lowmem);
-	initrd_start = 0;
-#endif
+
 	free_early(ramdisk_image, ramdisk_end);
 }
 #else
