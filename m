Return-Path: <linux-kernel-owner+w=401wt.eu-S1755500AbYAGNvP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755500AbYAGNvP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 08:51:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753610AbYAGNu7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 08:50:59 -0500
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:47159 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753751AbYAGNuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 08:50:55 -0500
Date: Mon, 7 Jan 2008 19:20:38 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>, hpa@zytor.com,
       tglx@linutronix.de
Subject: [PATCH -mm/x86] revert i386: handle an initrd in highmem (Was Re:
	2.6.24-rc6-mm1)
Message-ID: <20080107135038.GA19568@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <20071222233056.d652743e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071222233056.d652743e.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew, Ingo, Thomas, Peter,

x86: revert i386: handle an initrd in highmem

The patch caused a failure while booting a kexec kernel.
(http://lkml.org/lkml/2008/1/7/42 has the bisect details.)

The following patch reverts it.

Signed-off-by: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/boot/header.S     |    5 -
 arch/x86/kernel/setup_32.c |  113 +++++++--------------------------------------
 2 files changed, 19 insertions(+), 99 deletions(-)

Index: linux-2.6.24-rc6/arch/x86/boot/header.S
===================================================================
--- linux-2.6.24-rc6.orig/arch/x86/boot/header.S
+++ linux-2.6.24-rc6/arch/x86/boot/header.S
@@ -195,13 +195,10 @@ cmd_line_ptr:	.long	0		# (Header version
 					# can be located anywhere in
 					# low memory 0x10000 or higher.
 
-ramdisk_max:	.long 0x7fffffff
+ramdisk_max:	.long (-__PAGE_OFFSET-(512 << 20)-1) & 0x7fffffff
 					# (Header version 0x0203 or later)
 					# The highest safe address for
 					# the contents of an initrd
-					# The current kernel allows up to 4 GB,
-					# but leave it at 2 GB to avoid
-					# possible bootloader bugs.
 
 kernel_alignment:  .long CONFIG_PHYSICAL_ALIGN	#physical addr alignment
 						#required for protected mode
Index: linux-2.6.24-rc6/arch/x86/kernel/setup_32.c
===================================================================
--- linux-2.6.24-rc6.orig/arch/x86/kernel/setup_32.c
+++ linux-2.6.24-rc6/arch/x86/kernel/setup_32.c
@@ -583,95 +583,6 @@ static void __init relocate_initrd(void)
 
 #endif /* CONFIG_BLK_DEV_INITRD */
 
-#ifdef CONFIG_BLK_DEV_INITRD
-
-static bool do_relocate_initrd = false;
-
-static void __init reserve_initrd(void)
-{
-	unsigned long ramdisk_image = boot_params.hdr.ramdisk_image;
-	unsigned long ramdisk_size  = boot_params.hdr.ramdisk_size;
-	unsigned long ramdisk_end   = ramdisk_image + ramdisk_size;
-	unsigned long end_of_lowmem = max_low_pfn << PAGE_SHIFT;
-	unsigned long ramdisk_here;
-
-	if (ramdisk_end < ramdisk_image) {
-		printk(KERN_ERR "initrd wraps around end of memory\n"
-		       KERN_ERR "disabling initrd\n");
-		initrd_start = 0;
-		return;
-	}
-	if (ramdisk_size >= end_of_lowmem/2) {
-		printk(KERN_ERR "initrd too large to handle\n"
-		       KERN_ERR "disabling initrd\n");
-		initrd_start = 0;
-		return;
-	}
-	if (ramdisk_end <= end_of_lowmem) {
-		/* All in lowmem, easy case */
-		reserve_bootmem(ramdisk_image, ramdisk_size);
-		initrd_start = ramdisk_image + PAGE_OFFSET;
-		initrd_end = initrd_start+ramdisk_size;
-		return;
-	}
-
-	/* We need to move the initrd down into lowmem */
-	ramdisk_here = (end_of_lowmem - ramdisk_size) & PAGE_MASK;
-
-	/* Note: this includes all the lowmem currently occupied by
-	   the initrd, we rely on that fact to keep the data intact. */
-	reserve_bootmem(ramdisk_here, ramdisk_size);
-	initrd_start = ramdisk_here + PAGE_OFFSET;
-	initrd_end   = initrd_start + ramdisk_size;
-
-	do_relocate_initrd = true;
-}
-
-#define MAX_MAP_CHUNK	(NR_FIX_BTMAPS << PAGE_SHIFT)
-
-static void __init relocate_initrd(void)
-{
-	unsigned long ramdisk_image = boot_params.hdr.ramdisk_image;
-	unsigned long ramdisk_size  = boot_params.hdr.ramdisk_size;
-	unsigned long end_of_lowmem = max_low_pfn << PAGE_SHIFT;
-	unsigned long ramdisk_here;
-	unsigned long slop, clen, mapaddr;
-	char *p, *q;
-
-	if (!do_relocate_initrd)
-		return;		/* Nothing to do here... */
-
-	ramdisk_here = initrd_start - PAGE_OFFSET;
-	q = (char *)initrd_start;
-
-	/* Copy any lowmem portion of the initrd */
-	if (ramdisk_image < end_of_lowmem) {
-		clen = end_of_lowmem - ramdisk_image;
-		p = (char *)__va(ramdisk_image);
-		memcpy(q, p, clen);
-		q += clen;
-		ramdisk_image += clen;
-		ramdisk_size  -= clen;
-	}
-
-	/* Copy the highmem portion of the initrd */
-	while (ramdisk_size) {
-		slop = ramdisk_image & ~PAGE_MASK;
-		clen = ramdisk_size;
-		if (clen > MAX_MAP_CHUNK-slop)
-			clen = MAX_MAP_CHUNK-slop;
-		mapaddr = ramdisk_image & PAGE_MASK;
-		p = bt_ioremap(mapaddr, clen+slop);
-		memcpy(q, p+slop, clen);
-		bt_iounmap(p, clen+slop);
-		q += clen;
-		ramdisk_image += clen;
-		ramdisk_size  -= clen;
-	}
-}
-
-#endif /* CONFIG_BLK_DEV_INITRD */
-
 void __init setup_bootmem_allocator(void)
 {
 	unsigned long bootmap_size;
@@ -730,8 +641,24 @@ void __init setup_bootmem_allocator(void
 #endif
 	numa_kva_reserve();
 #ifdef CONFIG_BLK_DEV_INITRD
-	if (boot_params.hdr.type_of_loader && boot_params.hdr.ramdisk_image)
-		reserve_initrd();
+	if (boot_params.hdr.type_of_loader && boot_params.hdr.ramdisk_image) {
+		unsigned long ramdisk_image = boot_params.hdr.ramdisk_image;
+		unsigned long ramdisk_size  = boot_params.hdr.ramdisk_size;
+		unsigned long ramdisk_end   = ramdisk_image + ramdisk_size;
+		unsigned long end_of_lowmem = max_low_pfn << PAGE_SHIFT;
+
+		if (ramdisk_end <= end_of_lowmem) {
+			reserve_bootmem(ramdisk_image, ramdisk_size,
+							BOOTMEM_DEFAULT);
+			initrd_start = ramdisk_image + PAGE_OFFSET;
+			initrd_end = initrd_start+ramdisk_size;
+		} else {
+			printk(KERN_ERR "initrd extends beyond end of memory "
+			       "(0x%08lx > 0x%08lx)\ndisabling initrd\n",
+			       ramdisk_end, end_of_lowmem);
+			initrd_start = 0;
+		}
+	}
 #endif
 	reserve_crashkernel();
 }
@@ -890,10 +817,6 @@ void __init setup_arch(char **cmdline_p)
 	relocate_initrd();
 #endif
 
-#ifdef CONFIG_BLK_DEV_INITRD
-	relocate_initrd();
-#endif
-
 	dmi_scan_machine();
 
 	io_delay_init();

--
regards
Dhaval
