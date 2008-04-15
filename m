Return-Path: <linux-kernel-owner+w=401wt.eu-S1760786AbYDOKnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760786AbYDOKnU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 06:43:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752761AbYDOKnM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 06:43:12 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:39568 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677AbYDOKnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 06:43:11 -0400
Date: Tue, 15 Apr 2008 12:43:57 +0200
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>
Subject: gart: factor out common code
Message-ID: <20080415104357.GA13441@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup gart handling on amd64 a bit: move common code into
enable_gart_translation , and use symbolic register names where
appropriate.

Signed-off-by: Pavel Machek <pavel@suse.cz>

---
commit 43cfc0427c14f482e36adac447409c82b5cbbe09
tree fc873f1b75d5f1be05978124e7d9a9a31efc2d23
parent 5c9a05115efe1572a05bb1ba155b1e7870374a37
author Pavel <pavel@amd.ucw.cz> Tue, 15 Apr 2008 12:42:29 +0200
committer Pavel <pavel@amd.ucw.cz> Tue, 15 Apr 2008 12:42:29 +0200

 arch/x86/kernel/pci-gart_64.c |   23 ++++++-----------------
 drivers/char/agp/amd64-agp.c  |   30 ++++++++++--------------------
 include/asm-x86/gart.h        |   17 +++++++++++++++++
 3 files changed, 33 insertions(+), 37 deletions(-)

diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
index fd3c475..035dc61 100644
--- a/arch/x86/kernel/pci-gart_64.c
+++ b/arch/x86/kernel/pci-gart_64.c
@@ -534,8 +534,8 @@ static __init unsigned read_aperture(str
 	unsigned aper_size = 0, aper_base_32, aper_order;
 	u64 aper_base;
 
-	pci_read_config_dword(dev, 0x94, &aper_base_32);
-	pci_read_config_dword(dev, 0x90, &aper_order);
+	pci_read_config_dword(dev, AMD64_GARTAPERTUREBASE, &aper_base_32);
+	pci_read_config_dword(dev, AMD64_GARTAPERTURECTL, &aper_order);
 	aper_order = (aper_order >> 1) & 7;
 
 	aper_base = aper_base_32 & 0x7fff;
@@ -593,19 +593,8 @@ static __init int init_k8_gatt(struct ag
 	agp_gatt_table = gatt;
 
 	for (i = 0; i < num_k8_northbridges; i++) {
-		u32 gatt_reg;
-		u32 ctl;
-
 		dev = k8_northbridges[i];
-		gatt_reg = __pa(gatt) >> 12;
-		gatt_reg <<= 4;
-		pci_write_config_dword(dev, AMD64_GARTTABLEBASE, gatt_reg);
-		pci_read_config_dword(dev, AMD64_GARTAPERTURECTL, &ctl);
-
-		ctl |= GARTEN;
-		ctl &= ~(DISGARTCPU | DISGARTIO);
-
-		pci_write_config_dword(dev, AMD64_GARTAPERTURECTL, ctl);
+		enable_gart_translation(dev, __pa(gatt));
 	}
 	flush_gart();
 
@@ -646,11 +635,11 @@ void gart_iommu_shutdown(void)
 		u32 ctl;
 
 		dev = k8_northbridges[i];
-		pci_read_config_dword(dev, 0x90, &ctl);
+		pci_read_config_dword(dev, AMD64_GARTAPERTURECTL, &ctl);
 
-		ctl &= ~1;
+		ctl &= ~GARTEN;
 
-		pci_write_config_dword(dev, 0x90, ctl);
+		pci_write_config_dword(dev, AMD64_GARTAPERTURECTL, ctl);
 	}
 }
 
diff --git a/drivers/char/agp/amd64-agp.c b/drivers/char/agp/amd64-agp.c
index 25d6422..7e64c3c 100644
--- a/drivers/char/agp/amd64-agp.c
+++ b/drivers/char/agp/amd64-agp.c
@@ -150,25 +150,14 @@ static u64 amd64_configure(struct pci_de
 {
 	u64 aperturebase;
 	u32 tmp;
-	u64 addr, aper_base;
+	u64 aper_base;
 
 	/* Address to map to */
-	pci_read_config_dword (hammer, AMD64_GARTAPERTUREBASE, &tmp);
+	pci_read_config_dword(hammer, AMD64_GARTAPERTUREBASE, &tmp);
 	aperturebase = tmp << 25;
 	aper_base = (aperturebase & PCI_BASE_ADDRESS_MEM_MASK);
 
-	/* address of the mappings table */
-	addr = (u64) gatt_table;
-	addr >>= 12;
-	tmp = (u32) addr<<4;
-	tmp &= ~0xf;
-	pci_write_config_dword(hammer, AMD64_GARTTABLEBASE, tmp);
-
-	/* Enable GART translation for this hammer. */
-	pci_read_config_dword(hammer, AMD64_GARTAPERTURECTL, &tmp);
-	tmp |= GARTEN;
-	tmp &= ~(DISGARTCPU | DISGARTIO);
-	pci_write_config_dword(hammer, AMD64_GARTAPERTURECTL, tmp);
+	enable_gart_translation(hammer, gatt_table);
 
 	return aper_base;
 }
@@ -207,9 +196,9 @@ static void amd64_cleanup(void)
         for (i = 0; i < num_k8_northbridges; i++) {
 		struct pci_dev *dev = k8_northbridges[i];
 		/* disable gart translation */
-		pci_read_config_dword (dev, AMD64_GARTAPERTURECTL, &tmp);
+		pci_read_config_dword(dev, AMD64_GARTAPERTURECTL, &tmp);
 		tmp &= ~AMD64_GARTEN;
-		pci_write_config_dword (dev, AMD64_GARTAPERTURECTL, tmp);
+		pci_write_config_dword(dev, AMD64_GARTAPERTURECTL, tmp);
 	}
 }
 
@@ -289,9 +278,9 @@ static __devinit int fix_northbridge(str
 	u32 nb_order, nb_base;
 	u16 apsize;
 
-	pci_read_config_dword(nb, 0x90, &nb_order);
+	pci_read_config_dword(nb, AMD64_GARTAPERTURECTL, &nb_order);
 	nb_order = (nb_order >> 1) & 7;
-	pci_read_config_dword(nb, 0x94, &nb_base);
+	pci_read_config_dword(nb, AMD64_GARTAPERTUREBASE, &nb_base);
 	nb_aper = nb_base << 25;
 	if (aperture_valid(nb_aper, (32*1024*1024)<<nb_order)) {
 		return 0;
@@ -316,8 +306,8 @@ static __devinit int fix_northbridge(str
 	if (order < 0 || !aperture_valid(aper, (32*1024*1024)<<order))
 		return -1;
 
-	pci_write_config_dword(nb, 0x90, order << 1);
-	pci_write_config_dword(nb, 0x94, aper >> 25);
+	pci_write_config_dword(nb, AMD64_GARTAPERTURECTL, order << 1);
+	pci_write_config_dword(nb, AMD64_GARTAPERTUREBASE, aper >> 25);
 
 	return 0;
 }
diff --git a/include/asm-x86/gart.h b/include/asm-x86/gart.h
index 248e577..6f22786 100644
--- a/include/asm-x86/gart.h
+++ b/include/asm-x86/gart.h
@@ -52,4 +52,21 @@ #define AMD64_GARTTABLEBASE	0x98
 #define AMD64_GARTCACHECTL	0x9c
 #define AMD64_GARTEN		(1<<0)
 
+static inline void enable_gart_translation(struct pci_dev *dev, u64 addr)
+{
+	u32 tmp, ctl;
+
+        /* address of the mappings table */
+        addr >>= 12;
+        tmp = (u32) addr<<4;
+        tmp &= ~0xf;
+        pci_write_config_dword(dev, AMD64_GARTTABLEBASE, tmp);
+
+        /* Enable GART translation for this hammer. */
+        pci_read_config_dword(dev, AMD64_GARTAPERTURECTL, &ctl);
+        ctl |= GARTEN;
+        ctl &= ~(DISGARTCPU | DISGARTIO);
+        pci_write_config_dword(dev, AMD64_GARTAPERTURECTL, ctl);
+}
+
 #endif

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
