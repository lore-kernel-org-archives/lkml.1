Return-Path: <linux-kernel-owner+w=401wt.eu-S1752989AbYJ2FqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989AbYJ2FqU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 01:46:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752204AbYJ2FqJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 01:46:09 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:14851 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752140AbYJ2FqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 01:46:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=PuJgV3E/ers07zye3MO7vzSV3YoNzUkCuOht8VQxV/qtp+jJEeYUFJC0Qym8elIeD7
         Rgk0TUkJPijJ/V+itYKgLUicWPWY+PbhAIYXMnacQyLujnmW5EUl3B7KbZ1RU/xFs7dR
         +buHK8N6Z4grMZOwA9GKw+knx8abBUQty0DPw=
Subject: [PATCH] x86: start annotating early ioremap pointers with __iomem
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 28 Oct 2008 22:46:04 -0700
Message-Id: <1225259164.20276.1.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As with regular ioremap, iounmap etc, annotate with __iomem.

Fixes the following sparse warnings, will produce some new ones
elsewhere in arch/x86 that will get worked out over time.

arch/x86/mm/ioremap.c:402:9: warning: cast removes address space of expression
arch/x86/mm/ioremap.c:406:10: warning: cast adds address space to expression (<asn:2>)
arch/x86/mm/ioremap.c:782:19: warning: Using plain integer as NULL pointer

Impact: some new sparse warnings in e820.c etc, but no functional change.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/x86/include/asm/io.h |    6 +++---
 arch/x86/mm/ioremap.c     |   22 +++++++++++-----------
 2 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/arch/x86/include/asm/io.h b/arch/x86/include/asm/io.h
index 5618a10..ac2abc8 100644
--- a/arch/x86/include/asm/io.h
+++ b/arch/x86/include/asm/io.h
@@ -82,9 +82,9 @@ extern void __iomem *ioremap_wc(unsigned long offset, unsigned long size);
 extern void early_ioremap_init(void);
 extern void early_ioremap_clear(void);
 extern void early_ioremap_reset(void);
-extern void *early_ioremap(unsigned long offset, unsigned long size);
-extern void *early_memremap(unsigned long offset, unsigned long size);
-extern void early_iounmap(void *addr, unsigned long size);
+extern void __iomem *early_ioremap(unsigned long offset, unsigned long size);
+extern void __iomem *early_memremap(unsigned long offset, unsigned long size);
+extern void early_iounmap(void __iomem *addr, unsigned long size);
 extern void __iomem *fix_ioremap(unsigned idx, unsigned long phys);
 
 
diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index ae71e11..d4c4307 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -387,7 +387,7 @@ static void __iomem *ioremap_default(resource_size_t phys_addr,
 					unsigned long size)
 {
 	unsigned long flags;
-	void *ret;
+	void __iomem *ret;
 	int err;
 
 	/*
@@ -399,11 +399,11 @@ static void __iomem *ioremap_default(resource_size_t phys_addr,
 	if (err < 0)
 		return NULL;
 
-	ret = (void *) __ioremap_caller(phys_addr, size, flags,
-					__builtin_return_address(0));
+	ret = __ioremap_caller(phys_addr, size, flags,
+			       __builtin_return_address(0));
 
 	free_memtype(phys_addr, phys_addr + size);
-	return (void __iomem *)ret;
+	return ret;
 }
 
 void __iomem *ioremap_prot(resource_size_t phys_addr, unsigned long size,
@@ -622,7 +622,7 @@ static inline void __init early_clear_fixmap(enum fixed_addresses idx)
 		__early_set_fixmap(idx, 0, __pgprot(0));
 }
 
-static void *prev_map[FIX_BTMAPS_SLOTS] __initdata;
+static void __iomem *prev_map[FIX_BTMAPS_SLOTS] __initdata;
 static unsigned long prev_size[FIX_BTMAPS_SLOTS] __initdata;
 static int __init check_early_ioremap_leak(void)
 {
@@ -645,7 +645,7 @@ static int __init check_early_ioremap_leak(void)
 }
 late_initcall(check_early_ioremap_leak);
 
-static void __init *__early_ioremap(unsigned long phys_addr, unsigned long size, pgprot_t prot)
+static void __init __iomem *__early_ioremap(unsigned long phys_addr, unsigned long size, pgprot_t prot)
 {
 	unsigned long offset, last_addr;
 	unsigned int nrpages;
@@ -713,23 +713,23 @@ static void __init *__early_ioremap(unsigned long phys_addr, unsigned long size,
 	if (early_ioremap_debug)
 		printk(KERN_CONT "%08lx + %08lx\n", offset, fix_to_virt(idx0));
 
-	prev_map[slot] = (void *) (offset + fix_to_virt(idx0));
+	prev_map[slot] = (void __iomem *)(offset + fix_to_virt(idx0));
 	return prev_map[slot];
 }
 
 /* Remap an IO device */
-void __init *early_ioremap(unsigned long phys_addr, unsigned long size)
+void __init __iomem *early_ioremap(unsigned long phys_addr, unsigned long size)
 {
 	return __early_ioremap(phys_addr, size, PAGE_KERNEL_IO);
 }
 
 /* Remap memory */
-void __init *early_memremap(unsigned long phys_addr, unsigned long size)
+void __init __iomem *early_memremap(unsigned long phys_addr, unsigned long size)
 {
 	return __early_ioremap(phys_addr, size, PAGE_KERNEL);
 }
 
-void __init early_iounmap(void *addr, unsigned long size)
+void __init early_iounmap(void __iomem *addr, unsigned long size)
 {
 	unsigned long virt_addr;
 	unsigned long offset;
@@ -779,7 +779,7 @@ void __init early_iounmap(void *addr, unsigned long size)
 		--idx;
 		--nrpages;
 	}
-	prev_map[slot] = 0;
+	prev_map[slot] = NULL;
 }
 
 void __this_fixmap_does_not_exist(void)
-- 
1.6.0.3.756.gb776d



