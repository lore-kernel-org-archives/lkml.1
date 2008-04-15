Return-Path: <linux-kernel-owner+w=401wt.eu-S1764110AbYDODlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764110AbYDODlT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 23:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762337AbYDODlH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 23:41:07 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:33792 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762279AbYDODlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 23:41:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=reply-to:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=Ki7qYQO+q2x1mPzvmfn4o/9LKlW+yPk0O7lkPtxWEYn9LzYqogEEN3C9XBzkGFE73xifp772tYY6waEy+wR5kswCi51cKHLTh0yG8u+8pNW0XTRtnTBf/yVwoF4TdHRUpCwP8oniwNvDKPJZ9MbgcjZQZDmb8DwaL27TEwCpq6s=
Reply-To: yhlu.kernel@gmail.com
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86_64: allocate gart aperture from 512M
Date: Mon, 14 Apr 2008 20:40:37 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: kernel list <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804142040.37701.yhlu.kernel@gmail.com>
From: Yinghai Lu <yhlu.kernel.send@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] x86_64: allocate gart aperture from 512M

because we try to reserve dma32 early, so we have chance to get aperture
from 64M

with some sequence aperture allocated from RAM, could become E820_RESERVED.

and then if folling up one kexec one big kernel that uncompressed size is above

64M could have conflict with still using gart.

So allocate gart aperture from 512M instead.

Also change the fallback_aper_order to 5, because we don't have chance to get
2G or 4G aperture.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

Index: linux-2.6/arch/x86/kernel/aperture_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/aperture_64.c
+++ linux-2.6/arch/x86/kernel/aperture_64.c
@@ -55,8 +55,9 @@ static u32 __init allocate_aperture(void
 	u32 aper_size;
 	void *p;
 
-	if (fallback_aper_order > 7)
-		fallback_aper_order = 7;
+	/* aper_size should <= 1G */
+	if (fallback_aper_order > 5)
+		fallback_aper_order = 5;
 	aper_size = (32 * 1024 * 1024) << fallback_aper_order;
 
 	/*
@@ -65,7 +66,20 @@ static u32 __init allocate_aperture(void
 	 * memory. Unfortunately we cannot move it up because that would
 	 * make the IOMMU useless.
 	 */
-	p = __alloc_bootmem_nopanic(aper_size, aper_size, 0);
+	/*
+	 * using 512M as goal, in case kexec will load kernel_big
+	 * that will do the on position decompress, and  could overlap with
+	 * that positon with gart that is used.
+	 * sequende:
+	 * kernel_small
+	 * ==> kexec (with kdump trigger path or previous doesn't shutdown gart)
+	 * ==> kernel_small(gart area become e820_reserved)
+	 * ==> kexec (with kdump trigger path or previous doesn't shutdown gart)
+	 * ==> kerne_big (uncompressed size will be big than 64M or 128M)
+	 * so don't use 512M below as gart iommu, leave the space for kernel
+	 * code for safe
+	 */
+	p = __alloc_bootmem_nopanic(aper_size, aper_size, 512ULL<<20);
 	if (!p || __pa(p)+aper_size > 0xffffffff) {
 		printk(KERN_ERR
 			"Cannot allocate aperture memory hole (%p,%uK)\n",
Index: linux-2.6/arch/x86/kernel/pci-dma.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/pci-dma.c
+++ linux-2.6/arch/x86/kernel/pci-dma.c
@@ -77,10 +77,14 @@ void __init dma32_reserve_bootmem(void)
 	if (end_pfn <= MAX_DMA32_PFN)
 		return;
 
+	/*
+	 * check aperture_64.c allocate_aperture() for reason about
+	 * using 512M as goal
+	 */
 	align = 64ULL<<20;
 	size = round_up(dma32_bootmem_size, align);
 	dma32_bootmem_ptr = __alloc_bootmem_nopanic(size, align,
-				 __pa(MAX_DMA_ADDRESS));
+				 512ULL<<20);
 	if (dma32_bootmem_ptr)
 		dma32_bootmem_size = size;
 	else
