Return-Path: <linux-kernel-owner+w=401wt.eu-S1764097AbYCSWjJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764097AbYCSWjJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 18:39:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761780AbYCSVKf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 17:10:35 -0400
Received: from rn-out-0910.google.com ([64.233.170.186]:37222 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764535AbYCSVKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 17:10:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=reply-to:to:subject:user-agent:cc:references:in-reply-to:mime-version:content-disposition:x-length:x-uid:date:content-type:content-transfer-encoding:message-id:from;
        b=rW0aZG1cVKXOfhepj1blow5E+1gqU8ma0fbOmqinykRaJJL8/EFRQHrrQh7PNrLedSoY6ZZ7B43wqAuxQV9A7L9qfDOVQsUYpY3810jFr8i+5DkSLZgjnYAJyVDrkqGFAjZARfxKrMhTG81o7KkFHQXLv5E1bfXEPNuKBlLsSUw=
Reply-To: yhlu.kernel@gmail.com
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 11/12] x86_64: do not reserve ramdisk two times
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Christoph Lameter <clameter@sgi.com>,
       kernel list <linux-kernel@vger.kernel.org>
References: <200803181237.33861.yhlu.kernel@gmail.com>
In-Reply-To: <200803181237.33861.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 2843
Date: Wed, 19 Mar 2008 14:04:56 -0700
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200803191404.56604.yhlu.kernel@gmail.com>
From: Yinghai Lu <yhlu.kernel.send@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] x86_64: do not reserve ramdisk two times

ramdisk is reserved via reserve_early in x86_64_start_kernel,
later early_res_to_bootmem() will convert to reservation in bootmem.

so don't need to reserve that again.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

Index: linux-2.6/arch/x86/kernel/head64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/head64.c
+++ linux-2.6/arch/x86/kernel/head64.c
@@ -110,6 +110,7 @@ void __init x86_64_start_kernel(char * r
 
 	reserve_early(__pa_symbol(&_text), __pa_symbol(&_end), "TEXT DATA BSS");
 
+#ifdef CONFIG_BLK_DEV_INITRD
 	/* Reserve INITRD */
 	if (boot_params.hdr.type_of_loader && boot_params.hdr.ramdisk_image) {
 		unsigned long ramdisk_image = boot_params.hdr.ramdisk_image;
@@ -117,6 +118,7 @@ void __init x86_64_start_kernel(char * r
 		unsigned long ramdisk_end   = ramdisk_image + ramdisk_size;
 		reserve_early(ramdisk_image, ramdisk_end, "RAMDISK");
 	}
+#endif
 
 	reserve_ebda();
 
Index: linux-2.6/arch/x86/kernel/setup_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup_64.c
+++ linux-2.6/arch/x86/kernel/setup_64.c
@@ -421,11 +421,14 @@ void __init setup_arch(char **cmdline_p)
 		unsigned long end_of_mem    = end_pfn << PAGE_SHIFT;
 
 		if (ramdisk_end <= end_of_mem) {
-			reserve_bootmem_generic(ramdisk_image, ramdisk_size);
+			/*
+			 * don't need to reserve again, already reserved early
+			 * in x86_64_start_kernel, and early_res_to_bootmem
+			 * convert that to reserved in bootmem
+			 */
 			initrd_start = ramdisk_image + PAGE_OFFSET;
 			initrd_end = initrd_start+ramdisk_size;
 		} else {
-			/* Assumes everything on node 0 */
 			free_bootmem(ramdisk_image, ramdisk_size);
 			printk(KERN_ERR "initrd extends beyond end of memory "
 			       "(0x%08lx > 0x%08lx)\ndisabling initrd\n",
