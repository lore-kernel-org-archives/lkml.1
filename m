Return-Path: <linux-kernel-owner+w=401wt.eu-S1755121AbYFZBCn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755121AbYFZBCn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 21:02:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755238AbYFZBBk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 21:01:40 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:3760 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754847AbYFZBBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 21:01:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=pYtx+6VX9V3RIjS68UffSKcBXTSJ+Adwq/+H3DDa5hHE1CyDLYOAHrOS+Rbn5V6jmp
         qBdHCWXLHqGqi2l7RzT+r9ZbGh3/hER7OtmEKqymEU0nABBqilPbxLpCOVOsTXDE7h7+
         Q3PGM84oKjCTIZ8rj6lEiJn6hOeQ56dbqbQGw=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 03/16] x86: update reserve_initrd to support 64bit
Date: Wed, 25 Jun 2008 17:49:26 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200806251748.06743.yhlu.kernel@gmail.com>
In-Reply-To: <200806251748.06743.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806251749.26274.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

Index: linux-2.6/arch/x86/kernel/setup_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup_32.c
+++ linux-2.6/arch/x86/kernel/setup_32.c
@@ -186,43 +186,18 @@ static inline void copy_edd(void)
 
 #ifdef CONFIG_BLK_DEV_INITRD
 
-static void __init relocate_initrd(void);
+#ifdef CONFIG_X86_32
 
-static void __init reserve_initrd(void)
+#define MAX_MAP_CHUNK	(NR_FIX_BTMAPS << PAGE_SHIFT)
+static void __init relocate_initrd(void)
 {
+
 	u64 ramdisk_image = boot_params.hdr.ramdisk_image;
 	u64 ramdisk_size  = boot_params.hdr.ramdisk_size;
-	u64 ramdisk_end   = ramdisk_image + ramdisk_size;
 	u64 end_of_lowmem = max_low_pfn << PAGE_SHIFT;
 	u64 ramdisk_here;
-
-	if (!boot_params.hdr.type_of_loader ||
-	    !ramdisk_image || !ramdisk_size)
-		return;		/* No initrd provided by bootloader */
-
-	initrd_start = 0;
-
-	if (ramdisk_size >= (end_of_lowmem>>1)) {
-		free_early(ramdisk_image, ramdisk_end);
-		printk(KERN_ERR "initrd too large to handle, "
-		       "disabling initrd\n");
-		return;
-	}
-
-	printk(KERN_INFO "old RAMDISK: %08llx - %08llx\n", ramdisk_image,
-			ramdisk_end);
-
-
-	if (ramdisk_end <= end_of_lowmem) {
-		/* All in lowmem, easy case */
-		/*
-		 * don't need to reserve again, already reserved early
-		 * in i386_start_kernel
-		 */
-		initrd_start = ramdisk_image + PAGE_OFFSET;
-		initrd_end = initrd_start + ramdisk_size;
-		return;
-	}
+	unsigned long slop, clen, mapaddr;
+	char *p, *q;
 
 	/* We need to move the initrd down into lowmem */
 	ramdisk_here = find_e820_area(0, end_of_lowmem, ramdisk_size,
@@ -241,22 +216,6 @@ static void __init reserve_initrd(void)
 	printk(KERN_INFO "Allocated new RAMDISK: %08llx - %08llx\n",
 			 ramdisk_here, ramdisk_here + ramdisk_size);
 
-	relocate_initrd();
-}
-
-#define MAX_MAP_CHUNK	(NR_FIX_BTMAPS << PAGE_SHIFT)
-
-static void __init relocate_initrd(void)
-{
-	u64 ramdisk_image = boot_params.hdr.ramdisk_image;
-	u64 ramdisk_size  = boot_params.hdr.ramdisk_size;
-	u64 end_of_lowmem = max_low_pfn << PAGE_SHIFT;
-	u64 ramdisk_here;
-	unsigned long slop, clen, mapaddr;
-	char *p, *q;
-
-	ramdisk_here = initrd_start - PAGE_OFFSET;
-
 	q = (char *)initrd_start;
 
 	/* Copy any lowmem portion of the initrd */
@@ -286,18 +245,60 @@ static void __init relocate_initrd(void)
 	/* high pages is not converted by early_res_to_bootmem */
 	ramdisk_image = boot_params.hdr.ramdisk_image;
 	ramdisk_size  = boot_params.hdr.ramdisk_size;
-	printk(KERN_INFO "Copied RAMDISK from %016llx - %016llx to %08llx - %08llx\n",
+	printk(KERN_INFO "Move RAMDISK from %016llx - %016llx to"
+		" %08llx - %08llx\n",
 		ramdisk_image, ramdisk_image + ramdisk_size - 1,
 		ramdisk_here, ramdisk_here + ramdisk_size - 1);
+}
+#endif
 
-	/*
-	 * need to free old one, otherwise init cross max_low_pfn could be
-	 * converted to bootmem
-	 */
-	free_early(ramdisk_image, ramdisk_image+ramdisk_size);
+static void __init reserve_initrd(void)
+{
+	u64 ramdisk_image = boot_params.hdr.ramdisk_image;
+	u64 ramdisk_size  = boot_params.hdr.ramdisk_size;
+	u64 ramdisk_end   = ramdisk_image + ramdisk_size;
+	u64 end_of_lowmem = max_low_pfn << PAGE_SHIFT;
+
+	if (!boot_params.hdr.type_of_loader ||
+	    !ramdisk_image || !ramdisk_size)
+		return;		/* No initrd provided by bootloader */
+
+	initrd_start = 0;
+
+	if (ramdisk_size >= (end_of_lowmem>>1)) {
+		free_early(ramdisk_image, ramdisk_end);
+		printk(KERN_ERR "initrd too large to handle, "
+		       "disabling initrd\n");
+		return;
+	}
+
+	printk(KERN_INFO "RAMDISK: %08llx - %08llx\n", ramdisk_image,
+			ramdisk_end);
+
+
+	if (ramdisk_end <= end_of_lowmem) {
+		/* All in lowmem, easy case */
+		/*
+		 * don't need to reserve again, already reserved early
+		 * in i386_start_kernel
+		 */
+		initrd_start = ramdisk_image + PAGE_OFFSET;
+		initrd_end = initrd_start + ramdisk_size;
+		return;
+	}
+
+#ifdef CONFIG_X86_32
+	relocate_initrd();
+#else
+	printk(KERN_ERR "initrd extends beyond end of memory "
+	       "(0x%08llx > 0x%08llx)\ndisabling initrd\n",
+	       ramdisk_end, end_of_lowmem);
+	initrd_start = 0;
+#endif
+	free_early(ramdisk_image, ramdisk_end);
 }
 #else
-void __init reserve_initrd(void)
+static void __init reserve_initrd(void)
 {
 }
 #endif /* CONFIG_BLK_DEV_INITRD */
