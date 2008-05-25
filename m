Return-Path: <linux-kernel-owner+w=401wt.eu-S1756843AbYEYQ7a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756843AbYEYQ7a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 12:59:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755142AbYEYQ7U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 12:59:20 -0400
Received: from wr-out-0506.google.com ([64.233.184.226]:46901 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754951AbYEYQ7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 12:59:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=sxbf8xNxJzb+gNKOzo8DnaZjpfDQtZcm7D9M7NaPmyFfUxvIhYvt8ueWUvVuPKj6gp5lYL9j6TUpopO9v6ZPfzsQl52NTtHEea9rb7RqOYl2zrKYCrsM8gZ3gG5lNPsURqC1WXyUwMowo2Mw3A+qdqs7gPBDki4gH2xudocceFA=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: [PATCH] x86: extend e820 ealy_res support 32bit - fix #2
Date: Sun, 25 May 2008 10:00:09 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200805110030.15510.yhlu.kernel@gmail.com> <200805180118.57863.yhlu.kernel@gmail.com> <200805211840.18619.yhlu.kernel@gmail.com>
In-Reply-To: <200805211840.18619.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805251000.10205.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


remove extra -1 in reseve_early calling
    panic if can not find space for new RAMDISK

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

Index: linux-2.6/arch/x86/kernel/setup_32.c
diff --git a/arch/x86/kernel/setup_32.c b/arch/x86/kernel/setup_32.c
index 361e5c9..eed7121 100644
--- a/arch/x86/kernel/setup_32.c
+++ b/arch/x86/kernel/setup_32.c
@@ -479,7 +479,7 @@ static void __init reserve_initrd(void)
 	initrd_start = 0;
 
 	if (ramdisk_size >= end_of_lowmem/2) {
-		free_early(ramdisk_image, ramdisk_image + ramdisk_size - 1);
+		free_early(ramdisk_image, ramdisk_end);
 		printk(KERN_ERR "initrd too large to handle, "
 		       "disabling initrd\n");
 		return;
@@ -501,9 +501,13 @@ static void __init reserve_initrd(void)
 				 end_of_lowmem, ramdisk_size,
 				 PAGE_SIZE);
 
+	if (ramdisk_here == -1ULL)
+		panic("Cannot find place for new RAMDISK of size %lld\n",
+			 ramdisk_size);
+
 	/* Note: this includes all the lowmem currently occupied by
 	   the initrd, we rely on that fact to keep the data intact. */
-	reserve_early(ramdisk_here, ramdisk_here + ramdisk_size - 1,
+	reserve_early(ramdisk_here, ramdisk_here + ramdisk_size,
 			 "NEW RAMDISK");
 	initrd_start = ramdisk_here + PAGE_OFFSET;
 	initrd_end   = initrd_start + ramdisk_size;
@@ -579,15 +583,15 @@ void __init setup_bootmem_allocator(void)
 				 PAGE_SIZE);
 	if (bootmap == -1L)
 		panic("Cannot find bootmem map of size %ld\n", bootmap_size);
-	reserve_early(bootmap, bootmap + bootmap_size - 1, "BOOTMAP");
+	reserve_early(bootmap, bootmap + bootmap_size, "BOOTMAP");
 #ifdef CONFIG_BLK_DEV_INITRD
 	reserve_initrd();
 #endif
 	bootmap_size = init_bootmem(bootmap >> PAGE_SHIFT, max_low_pfn);
 	printk(KERN_INFO "  low ram: %08lx - %08lx\n",
 		 min_low_pfn<<PAGE_SHIFT, max_low_pfn<<PAGE_SHIFT);
-	printk(KERN_INFO "  bootmap [%08lx -  %08lx]\n",
-		 bootmap, bootmap + bootmap_size - 1);
+	printk(KERN_INFO "  bootmap %08lx - %08lx\n",
+		 bootmap, bootmap + bootmap_size);
 	register_bootmem_low_pages(max_low_pfn);
 	early_res_to_bootmem(0, max_low_pfn<<PAGE_SHIFT);
 
