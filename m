Return-Path: <linux-kernel-owner+w=401wt.eu-S1761437AbZGAAer@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761437AbZGAAer (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 20:34:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759857AbZGAAaS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 20:30:18 -0400
Received: from kroah.org ([198.145.64.141]:34362 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759696AbZGAAaK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 20:30:10 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jun 30 17:03:59 2009
Message-Id: <20090701000358.988293686@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 30 Jun 2009 17:00:01 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [patch 17/30] x86: handle initrd that extends into unusable memory
References: <20090630235944.868879272@mini.kroah.org>
Content-Disposition: inline; filename=x86-handle-initrd-that-extends-into-unusable-memory.patch
In-Reply-To: <20090701002817.GA6156@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Yinghai Lu <yinghai@kernel.org>

commit 8c5dd8f43367f4f266dd616f11658005bc2d20ef upstream.

On a system where system memory (according e820) is not covered by
mtrr, mtrr_trim_memory converts a portion of memory to reserved, but
bootloader has already put the initrd in that range.

Thus, we need to have 64bit to use relocate_initrd too.

[ Impact: fix using initrd when mtrr_trim_memory happen ]

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/setup.c |   15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -250,15 +250,13 @@ static inline void copy_edd(void)
 
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
@@ -314,14 +312,13 @@ static void __init relocate_initrd(void)
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
@@ -351,14 +348,8 @@ static void __init reserve_initrd(void)
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


