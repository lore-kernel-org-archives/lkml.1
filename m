Return-Path: <linux-kernel-owner+w=401wt.eu-S1764191AbZDHVCV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764191AbZDHVCV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 17:02:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756947AbZDHVCK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 17:02:10 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:13361 "EHLO
	SG2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755169AbZDHVCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 17:02:08 -0400
X-BigFish: VPS-2(zz936fKzz1202hzzz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KHSVQW-01-E6D-01
From: Mark Langsdorf <mark.langsdorf@amd.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] Enable GART-IOMMU only after setting up protection methods
Date: Wed, 8 Apr 2009 16:08:55 -0500
User-Agent: KMail/1.9.10
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
References: <200903171457.25582.mark.langsdorf@amd.com>
In-Reply-To: <200903171457.25582.mark.langsdorf@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <200904081608.55746.mark.langsdorf@amd.com>
X-OriginalArrivalTime: 08 Apr 2009 21:01:53.0926 (UTC) FILETIME=[3EBD4260:01C9B88D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current code to set up the GART as an IOMMU enables GART
translations before it removes the aperture from the kernel
memory map, sets the GART PTEs to UC, sets up the guard and
scratch pages, or does a wbinvd().  This leaves the possibility
of cache aliasing open and can cause system crashes.

Re-order the code and add tlbflush so as to enable the 
GART translations only after all safeguards are in place and
the tlb has been flushed.

AMD has tested this patch and seen no adverse effects.

Signed-off-by: Mark Langsdorf <mark.langsdorf@amd.com>

diff -r 0d1744c7acc7 arch/x86/kernel/pci-gart_64.c
--- a/arch/x86/kernel/pci-gart_64.c	Fri Mar 27 16:47:28 2009 -0500
+++ b/arch/x86/kernel/pci-gart_64.c	Mon Mar 30 15:05:47 2009 -0500
@@ -38,6 +38,7 @@
 #include <asm/swiotlb.h>
 #include <asm/dma.h>
 #include <asm/k8.h>
+#include <asm/tlbflush.h>
 
 static unsigned long iommu_bus_base;	/* GART remapping area (physical) */
 static unsigned long iommu_size;	/* size of remapping area bytes */
@@ -682,9 +683,9 @@
 	if (set_memory_uc((unsigned long)gatt, gatt_size >> PAGE_SHIFT))
 		panic("Could not set GART PTEs to uncacheable pages");
 
+	wbinvd();
+
 	agp_gatt_table = gatt;
-
-	enable_gart_translations();
 
 	error = sysdev_class_register(&gart_sysdev_class);
 	if (!error)
@@ -855,6 +856,11 @@
 	for (i = EMERGENCY_PAGES; i < iommu_pages; i++)
 		iommu_gatt_base[i] = gart_unmapped_entry;
 
+	wbinvd();
+	flush_tlb_all();
+
+	enable_gart_translations();
+
 	flush_gart();
 	dma_ops = &gart_dma_ops;
 }

