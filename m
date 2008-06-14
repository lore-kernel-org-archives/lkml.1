Return-Path: <linux-kernel-owner+w=401wt.eu-S1758760AbYFNDGq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758760AbYFNDGq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 23:06:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757615AbYFNDGi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 23:06:38 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:39700 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757583AbYFNDGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 23:06:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=CxP9XEjF3/ArI039C5HQOXtgXdIYOcFNjS+eORO8kwABxHLJiuS3yIAbQgFhocHa1p
         f2aWyKInjjr1k4YLw8bwtt+HvjCFunGwg9MYyxET1CowzNPzaHLPDkgj6LY8ts17qNTY
         1hFPxMkMW7yEHooseBtt+TMX7kpghYGjc3Kp4=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] x86: cleanup reloated_initrd
Date: Fri, 13 Jun 2008 20:07:03 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200806132005.45836.yhlu.kernel@gmail.com>
In-Reply-To: <200806132005.45836.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806132007.03576.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


1. move that before zone_sizes_init ...
2. add free_early for one old one, otherwise it will be be reserved again when
   init highmem.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

Index: linux-2.6/arch/x86/kernel/setup_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup_32.c
+++ linux-2.6/arch/x86/kernel/setup_32.c
@@ -585,6 +585,9 @@ static void __init relocate_initrd(void)
 	printk(KERN_INFO "Copied RAMDISK from %016llx - %016llx to %08llx - %08llx\n",
 		ramdisk_image, ramdisk_image + ramdisk_size - 1,
 		ramdisk_here, ramdisk_here + ramdisk_size - 1);
+
+	/* need to free that, otherwise init highmem will reserve it again */
+	free_early(ramdisk_image, ramdisk_image+ramdisk_size);
 }
 
 #endif /* CONFIG_BLK_DEV_INITRD */
@@ -813,10 +816,6 @@ void __init setup_arch(char **cmdline_p)
 		init_ohci1394_dma_on_all_controllers();
 #endif
 
-	remapped_pgdat_init();
-	sparse_init();
-	zone_sizes_init();
-
 	/*
 	 * NOTE: at this point the bootmem allocator is fully available.
 	 */
@@ -825,6 +824,10 @@ void __init setup_arch(char **cmdline_p)
 	relocate_initrd();
 #endif
 
+	remapped_pgdat_init();
+	sparse_init();
+	zone_sizes_init();
+
 	paravirt_post_allocator_init();
 
 	dmi_scan_machine();
