Return-Path: <linux-kernel-owner+w=401wt.eu-S1755561AbYDHIs2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755561AbYDHIs2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 04:48:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752434AbYDHIsV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 04:48:21 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:58014 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691AbYDHIsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 04:48:20 -0400
Date: Tue, 8 Apr 2008 10:49:03 +0200
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <andi@firstfloor.org>
Subject: iommu: use symbolic constants, not hardcoded numbers
Message-ID: <20080408084903.GA28510@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Move symbolic constants into gart.h, and use them instead of hardcoded
constant.

Signed-off-by: Pavel Machek <pavel@suse.cz>

diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
index faf3229..fd3c475 100644
--- a/arch/x86/kernel/pci-gart_64.c
+++ b/arch/x86/kernel/pci-gart_64.c
@@ -599,13 +599,13 @@ static __init int init_k8_gatt(struct ag
 		dev = k8_northbridges[i];
 		gatt_reg = __pa(gatt) >> 12;
 		gatt_reg <<= 4;
-		pci_write_config_dword(dev, 0x98, gatt_reg);
-		pci_read_config_dword(dev, 0x90, &ctl);
+		pci_write_config_dword(dev, AMD64_GARTTABLEBASE, gatt_reg);
+		pci_read_config_dword(dev, AMD64_GARTAPERTURECTL, &ctl);
 
-		ctl |= 1;
-		ctl &= ~((1<<4) | (1<<5));
+		ctl |= GARTEN;
+		ctl &= ~(DISGARTCPU | DISGARTIO);
 
-		pci_write_config_dword(dev, 0x90, ctl);
+		pci_write_config_dword(dev, AMD64_GARTAPERTURECTL, ctl);
 	}
 	flush_gart();
 
diff --git a/drivers/char/agp/amd64-agp.c b/drivers/char/agp/amd64-agp.c
index d8200ac..25d6422 100644
--- a/drivers/char/agp/amd64-agp.c
+++ b/drivers/char/agp/amd64-agp.c
@@ -16,28 +16,9 @@ #include <linux/mmzone.h>
 #include <asm/page.h>		/* PAGE_SIZE */
 #include <asm/e820.h>
 #include <asm/k8.h>
+#include <asm/gart.h>
 #include "agp.h"
 
-/* PTE bits. */
-#define GPTE_VALID	1
-#define GPTE_COHERENT	2
-
-/* Aperture control register bits. */
-#define GARTEN		(1<<0)
-#define DISGARTCPU	(1<<4)
-#define DISGARTIO	(1<<5)
-
-/* GART cache control register bits. */
-#define INVGART		(1<<0)
-#define GARTPTEERR	(1<<1)
-
-/* K8 On-cpu GART registers */
-#define AMD64_GARTAPERTURECTL	0x90
-#define AMD64_GARTAPERTUREBASE	0x94
-#define AMD64_GARTTABLEBASE	0x98
-#define AMD64_GARTCACHECTL	0x9c
-#define AMD64_GARTEN		(1<<0)
-
 /* NVIDIA K8 registers */
 #define NVIDIA_X86_64_0_APBASE		0x10
 #define NVIDIA_X86_64_1_APBASE1		0x50
@@ -165,7 +146,7 @@ static int amd64_fetch_size(void)
  * In a multiprocessor x86-64 system, this function gets
  * called once for each CPU.
  */
-static u64 amd64_configure (struct pci_dev *hammer, u64 gatt_table)
+static u64 amd64_configure(struct pci_dev *hammer, u64 gatt_table)
 {
 	u64 aperturebase;
 	u32 tmp;
@@ -181,7 +162,7 @@ static u64 amd64_configure (struct pci_d
 	addr >>= 12;
 	tmp = (u32) addr<<4;
 	tmp &= ~0xf;
-	pci_write_config_dword (hammer, AMD64_GARTTABLEBASE, tmp);
+	pci_write_config_dword(hammer, AMD64_GARTTABLEBASE, tmp);
 
 	/* Enable GART translation for this hammer. */
 	pci_read_config_dword(hammer, AMD64_GARTAPERTURECTL, &tmp);
diff --git a/include/asm-x86/gart.h b/include/asm-x86/gart.h
index 90958ed..248e577 100644
--- a/include/asm-x86/gart.h
+++ b/include/asm-x86/gart.h
@@ -5,6 +5,7 @@ extern void pci_iommu_shutdown(void);
 extern void no_iommu_init(void);
 extern int force_iommu, no_iommu;
 extern int iommu_detected;
+extern int agp_amd64_init(void);
 #ifdef CONFIG_GART_IOMMU
 extern void gart_iommu_init(void);
 extern void gart_iommu_shutdown(void);
@@ -31,4 +32,24 @@ static inline void gart_iommu_shutdown(v
 
 #endif
 
+/* PTE bits. */
+#define GPTE_VALID	1
+#define GPTE_COHERENT	2
+
+/* Aperture control register bits. */
+#define GARTEN		(1<<0)
+#define DISGARTCPU	(1<<4)
+#define DISGARTIO	(1<<5)
+
+/* GART cache control register bits. */
+#define INVGART		(1<<0)
+#define GARTPTEERR	(1<<1)
+
+/* K8 On-cpu GART registers */
+#define AMD64_GARTAPERTURECTL	0x90
+#define AMD64_GARTAPERTUREBASE	0x94
+#define AMD64_GARTTABLEBASE	0x98
+#define AMD64_GARTCACHECTL	0x9c
+#define AMD64_GARTEN		(1<<0)
+
 #endif

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
