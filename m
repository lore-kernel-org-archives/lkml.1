Return-Path: <linux-kernel-owner+w=401wt.eu-S1759720AbYGGWDN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759720AbYGGWDN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 18:03:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758225AbYGGWBG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 18:01:06 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:6551 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758718AbYGGWA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 18:00:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=xwBk+ma1/SwrJUGOKhCrRR1xZWX2vKYdCHqLHDqNBo60RuxvUcAKlaGy5acn9ydHYV
         6kGiNO/xCroOCsP1lx8ybKBegCJLkfgtWTotktDR851UBm665ZqSY40RDBhVFZxE92aB
         OzXTisAqAKa/nLFsyRtPUJZz0ogqOEmNyu/ok=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 9/10] ide-generic: remove ide_default_{io_base,irq}() inlines
Date: Mon, 7 Jul 2008 23:57:24 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807072357.24902.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace ide_default_{io_base,irq}() inlines by legacy_{bases,irqs}[].

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-generic.c           |   30 +++++++++++++++++++--
 include/asm-alpha/ide.h             |   24 -----------------
 include/asm-ia64/ide.h              |   29 --------------------
 include/asm-m32r/ide.h              |   50 ------------------------------------
 include/asm-mips/mach-generic/ide.h |   28 --------------------
 include/asm-x86/ide.h               |   28 --------------------
 6 files changed, 27 insertions(+), 162 deletions(-)

Index: b/drivers/ide/ide-generic.c
===================================================================
--- a/drivers/ide/ide-generic.c
+++ b/drivers/ide/ide-generic.c
@@ -20,6 +20,11 @@
 #include <linux/module.h>
 #include <linux/ide.h>
 
+/* FIXME: convert m32r to use ide_platform host driver */
+#ifdef CONFIG_M32R
+#include <asm/m32r.h>
+#endif
+
 #define DRV_NAME	"ide_generic"
 
 static int probe_mask = 0x03;
@@ -80,6 +85,21 @@ static int __init ide_generic_sysfs_init
 	return 0;
 }
 
+#if defined(CONFIG_PLAT_M32700UT) || defined(CONFIG_PLAT_MAPPI2) \
+	|| defined(CONFIG_PLAT_OPSPUT)
+static const u16 legacy_bases[] = { 0x1f0 };
+static const int legacy_irqs[]  = { PLD_IRQ_CFIREQ };
+#elif defined(CONFIG_PLAT_MAPPI3)
+static const u16 legacy_bases[] = { 0x1f0, 0x170 };
+static const int legacy_irqs[]  = { PLD_IRQ_CFIREQ, PLD_IRQ_IDEIREQ };
+#elif defined(CONFIG_ALPHA)
+static const u16 legacy_bases[] = { 0x1f0, 0x170, 0x1e8, 0x168 };
+static const int legacy_irqs[]  = { 14, 15, 11, 10 };
+#else
+static const u16 legacy_bases[] = { 0x1f0, 0x170, 0x1e8, 0x168, 0x1e0, 0x160 };
+static const int legacy_irqs[]  = { 14, 15, 11, 10, 8, 12 };
+#endif
+
 static int __init ide_generic_init(void)
 {
 	hw_regs_t hw[MAX_HWIFS], *hws[MAX_HWIFS];
@@ -94,8 +114,8 @@ static int __init ide_generic_init(void)
 	printk(KERN_INFO DRV_NAME ": please use \"probe_mask=0x3f\" module "
 			 "parameter for probing all legacy ISA IDE ports\n");
 
-	for (i = 0; i < MAX_HWIFS; i++) {
-		io_addr = ide_default_io_base(i);
+	for (i = 0; i < ARRAY_SIZE(legacy_bases); i++) {
+		io_addr = legacy_bases[i];
 
 		hws[i] = NULL;
 
@@ -117,7 +137,11 @@ static int __init ide_generic_init(void)
 
 			memset(&hw[i], 0, sizeof(hw[i]));
 			ide_std_init_ports(&hw[i], io_addr, io_addr + 0x206);
-			hw[i].irq = ide_default_irq(io_addr);
+#ifdef CONFIG_IA64
+			hw[i].irq = isa_irq_to_vector(legacy_irqs[i]);
+#else
+			hw[i].irq = legacy_irqs[i];
+#endif
 			hw[i].chipset = ide_generic;
 
 			hws[i] = &hw[i];
Index: b/include/asm-alpha/ide.h
===================================================================
--- a/include/asm-alpha/ide.h
+++ b/include/asm-alpha/ide.h
@@ -13,30 +13,6 @@
 
 #ifdef __KERNEL__
 
-static inline int ide_default_irq(unsigned long base)
-{
-	switch (base) {
-		case 0x1f0: return 14;
-		case 0x170: return 15;
-		case 0x1e8: return 11;
-		case 0x168: return 10;
-		default:
-			return 0;
-	}
-}
-
-static inline unsigned long ide_default_io_base(int index)
-{
-	switch (index) {
-		case 0:	return 0x1f0;
-		case 1:	return 0x170;
-		case 2: return 0x1e8;
-		case 3: return 0x168;
-		default:
-			return 0;
-	}
-}
-
 #include <asm-generic/ide_iops.h>
 
 #endif /* __KERNEL__ */
Index: b/include/asm-ia64/ide.h
===================================================================
--- a/include/asm-ia64/ide.h
+++ b/include/asm-ia64/ide.h
@@ -13,37 +13,8 @@
 
 #ifdef __KERNEL__
 
-
 #include <linux/irq.h>
 
-static inline int ide_default_irq(unsigned long base)
-{
-	switch (base) {
-	      case 0x1f0: return isa_irq_to_vector(14);
-	      case 0x170: return isa_irq_to_vector(15);
-	      case 0x1e8: return isa_irq_to_vector(11);
-	      case 0x168: return isa_irq_to_vector(10);
-	      case 0x1e0: return isa_irq_to_vector(8);
-	      case 0x160: return isa_irq_to_vector(12);
-	      default:
-		return 0;
-	}
-}
-
-static inline unsigned long ide_default_io_base(int index)
-{
-	switch (index) {
-	      case 0: return 0x1f0;
-	      case 1: return 0x170;
-	      case 2: return 0x1e8;
-	      case 3: return 0x168;
-	      case 4: return 0x1e0;
-	      case 5: return 0x160;
-	      default:
-		return 0;
-	}
-}
-
 #include <asm-generic/ide_iops.h>
 
 #endif /* __KERNEL__ */
Index: b/include/asm-m32r/ide.h
===================================================================
--- a/include/asm-m32r/ide.h
+++ b/include/asm-m32r/ide.h
@@ -13,56 +13,6 @@
 
 #ifdef __KERNEL__
 
-#include <asm/m32r.h>
-
-static __inline__ int ide_default_irq(unsigned long base)
-{
-	switch (base) {
-#if defined(CONFIG_PLAT_M32700UT) || defined(CONFIG_PLAT_MAPPI2) \
-	|| defined(CONFIG_PLAT_OPSPUT)
-		case 0x1f0: return PLD_IRQ_CFIREQ;
-		default:
-			return 0;
-#elif defined(CONFIG_PLAT_MAPPI3)
-		case 0x1f0: return PLD_IRQ_CFIREQ;
-		case 0x170: return PLD_IRQ_IDEIREQ;
-		default:
-			return 0;
-#else
-		case 0x1f0: return 14;
-		case 0x170: return 15;
-		case 0x1e8: return 11;
-		case 0x168: return 10;
-		case 0x1e0: return 8;
-		case 0x160: return 12;
-		default:
-			return 0;
-#endif
-	}
-}
-
-static __inline__ unsigned long ide_default_io_base(int index)
-{
-	switch (index) {
-#if defined(CONFIG_PLAT_M32700UT) || defined(CONFIG_PLAT_MAPPI2) \
-	|| defined(CONFIG_PLAT_OPSPUT)
-		case 0:	return 0x1f0;
-#elif defined(CONFIG_PLAT_MAPPI3)
-		case 0:	return 0x1f0;
-		case 1:	return 0x170;
-#else
-		case 0:	return 0x1f0;
-		case 1:	return 0x170;
-		case 2: return 0x1e8;
-		case 3: return 0x168;
-		case 4: return 0x1e0;
-		case 5: return 0x160;
-#endif
-		default:
-			return 0;
-	}
-}
-
 #include <asm-generic/ide_iops.h>
 
 #endif /* __KERNEL__ */
Index: b/include/asm-mips/mach-generic/ide.h
===================================================================
--- a/include/asm-mips/mach-generic/ide.h
+++ b/include/asm-mips/mach-generic/ide.h
@@ -48,34 +48,6 @@ found:
 #endif
 }
 
-static __inline__ int ide_default_irq(unsigned long base)
-{
-	switch (base) {
-		case 0x1f0: return 14;
-		case 0x170: return 15;
-		case 0x1e8: return 11;
-		case 0x168: return 10;
-		case 0x1e0: return 8;
-		case 0x160: return 12;
-		default:
-			return 0;
-	}
-}
-
-static __inline__ unsigned long ide_default_io_base(int index)
-{
-	switch (index) {
-	case 0: return 0x1f0;
-	case 1: return 0x170;
-	case 2: return 0x1e8;
-	case 3: return 0x168;
-	case 4: return 0x1e0;
-	case 5: return 0x160;
-	default:
-		return 0;
-	}
-}
-
 /* MIPS port and memory-mapped I/O string operations.  */
 static inline void __ide_flush_prologue(void)
 {
Index: b/include/asm-x86/ide.h
===================================================================
--- a/include/asm-x86/ide.h
+++ b/include/asm-x86/ide.h
@@ -11,34 +11,6 @@
 
 #ifdef __KERNEL__
 
-static __inline__ int ide_default_irq(unsigned long base)
-{
-	switch (base) {
-		case 0x1f0: return 14;
-		case 0x170: return 15;
-		case 0x1e8: return 11;
-		case 0x168: return 10;
-		case 0x1e0: return 8;
-		case 0x160: return 12;
-		default:
-			return 0;
-	}
-}
-
-static __inline__ unsigned long ide_default_io_base(int index)
-{
-	switch (index) {
-		case 0:	return 0x1f0;
-		case 1:	return 0x170;
-		case 2: return 0x1e8;
-		case 3: return 0x168;
-		case 4: return 0x1e0;
-		case 5: return 0x160;
-		default:
-			return 0;
-	}
-}
-
 #include <asm-generic/ide_iops.h>
 
 #endif /* __KERNEL__ */
