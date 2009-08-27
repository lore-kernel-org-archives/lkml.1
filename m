Return-Path: <linux-kernel-owner+w=401wt.eu-S1751102AbZH0REP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751102AbZH0REP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 13:04:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751017AbZH0REP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 13:04:15 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:34851 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750984AbZH0REO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 13:04:14 -0400
Subject: [PATCH 2/2] kmemleak: Ignore the aperture memory hole on x86_64
To: x86@kernel.org, linux-kernel@vger.kernel.org
From: Catalin Marinas <catalin.marinas@arm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Date: Thu, 27 Aug 2009 18:02:58 +0100
Message-ID: <20090827170258.27901.83613.stgit@pc1117.cambridge.arm.com>
In-Reply-To: <20090827165927.27901.97270.stgit@pc1117.cambridge.arm.com>
References: <20090827165927.27901.97270.stgit@pc1117.cambridge.arm.com>
User-Agent: StGit/0.15-rc2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Aug 2009 17:02:59.0207 (UTC) FILETIME=[3AD37970:01CA2738]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This block is allocated with alloc_bootmem() and scanned by kmemleak but
the kernel direct mapping may no longer exist. This patch tells kmemleak
to ignore this memory hole. The dma32_bootmem_ptr in
dma32_reserve_bootmem() is also ignored.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/aperture_64.c |    6 ++++++
 arch/x86/kernel/pci-dma.c     |    6 ++++++
 2 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/aperture_64.c b/arch/x86/kernel/aperture_64.c
index 676debf..128111d 100644
--- a/arch/x86/kernel/aperture_64.c
+++ b/arch/x86/kernel/aperture_64.c
@@ -20,6 +20,7 @@
 #include <linux/bitops.h>
 #include <linux/ioport.h>
 #include <linux/suspend.h>
+#include <linux/kmemleak.h>
 #include <asm/e820.h>
 #include <asm/io.h>
 #include <asm/iommu.h>
@@ -94,6 +95,11 @@ static u32 __init allocate_aperture(void)
 	 * code for safe
 	 */
 	p = __alloc_bootmem_nopanic(aper_size, aper_size, 512ULL<<20);
+	/*
+	 * Kmemleak should not scan this block as it may not be mapped via the
+	 * kernel direct mapping.
+	 */
+	kmemleak_ignore(p);
 	if (!p || __pa(p)+aper_size > 0xffffffff) {
 		printk(KERN_ERR
 			"Cannot allocate aperture memory hole (%p,%uK)\n",
diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index 1a041bc..fa80f60 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -3,6 +3,7 @@
 #include <linux/dmar.h>
 #include <linux/bootmem.h>
 #include <linux/pci.h>
+#include <linux/kmemleak.h>
 
 #include <asm/proto.h>
 #include <asm/dma.h>
@@ -88,6 +89,11 @@ void __init dma32_reserve_bootmem(void)
 	size = roundup(dma32_bootmem_size, align);
 	dma32_bootmem_ptr = __alloc_bootmem_nopanic(size, align,
 				 512ULL<<20);
+	/*
+	 * Kmemleak should not scan this block as it may not be mapped via the
+	 * kernel direct mapping.
+	 */
+	kmemleak_ignore(dma32_bootmem_ptr);
 	if (dma32_bootmem_ptr)
 		dma32_bootmem_size = size;
 	else

