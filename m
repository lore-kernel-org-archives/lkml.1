Return-Path: <linux-kernel-owner+w=401wt.eu-S1757326AbYE0KXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757326AbYE0KXT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 06:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756078AbYE0KXM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 06:23:12 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:42387 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756074AbYE0KXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 06:23:11 -0400
Date: Tue, 27 May 2008 12:23:58 +0200
From: Pavel Machek <pavel@suse.cz>
To: Patrick <ragamuffin@datacomm.ch>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: >3G => iommu => suspend problems -- was Re: SB600 AHCI: Hard
	Disk Corruption
Message-ID: <20080527102358.GA9060@elf.ucw.cz>
References: <1211717435.6038.53.camel@localhost.localdomain> <20080525173825.GA4132@ucw.cz> <1211746106.6188.57.camel@localhost.localdomain> <20080525203921.GB18781@elf.ucw.cz> <20080525211016.GA32478@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080525211016.GA32478@elf.ucw.cz>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > > iommu problem? Try it with mem=3G.
> > > 
> > > YES! :-) How did you know?
> > 
> > Guess how... I hit it myself.
> > 
> > > So how are we going to get this fixed???
> > 
> > Write a patch, submit it? ;-).
> 
> Can you try this one? It should prevent suspend in the broken cases,
> but allow it in mem=4G config.

Apply this on top of previous patch, and you may get working system
_and_ all the memory...

Add resume support to pci-gart_64.c. This is neccessary for resume not
to currupt disk on >3GB machines.

Signed-off-by: Pavel Machek <pavel@suse.cz>

---
commit cc8201de538dda6c17e03fe495146e7fc755f64d
tree 9f4ece8312b59e6e14eb3a38d489ff37070d6cf1
parent db95a81f7f2106655c6ceb05a38300fd26f6ea3f
author Pavel <pavel@amd.ucw.cz> Tue, 27 May 2008 12:23:45 +0200
committer Pavel <pavel@amd.ucw.cz> Tue, 27 May 2008 12:23:45 +0200

 arch/x86/kernel/aperture_64.c |   45 +++++++++++++++++++++++++++--------------
 arch/x86/kernel/pci-gart_64.c |   28 ++++++++++++++++++++------
 drivers/char/agp/generic.c    |    2 +-
 include/asm-x86/gart.h        |    1 +
 4 files changed, 54 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kernel/aperture_64.c b/arch/x86/kernel/aperture_64.c
index 2088b6a..2571dc4 100644
--- a/arch/x86/kernel/aperture_64.c
+++ b/arch/x86/kernel/aperture_64.c
@@ -302,6 +302,32 @@ void __init early_gart_iommu_check(void)
 
 }
 
+u32 fix_aper_enabled, fix_aper_order, fix_aper_alloc;
+
+void fix_up_north_bridges(void)
+{
+	int num;
+	if (!fix_aper_enabled)
+		return;
+
+	/* Fix up the north bridges */
+	for (num = 24; num < 32; num++) {
+		if (!early_is_k8_nb(read_pci_config(0, num, 3, 0x00)))
+			continue;
+
+		/*
+		 * Don't enable translation yet. That is done later
+		 * by enable_gart_translation.
+		 *
+		 * Assume this BIOS didn't initialise the GART so
+		 * just overwrite all previous bits
+		 */
+		write_pci_config(0, num, 3, AMD64_GARTAPERTURECTL, fix_aper_order<<1);
+		write_pci_config(0, num, 3, AMD64_GARTAPERTUREBASE, fix_aper_alloc>>25);
+	}
+}
+
+
 void __init gart_iommu_hole_init(void)
 {
 	u32 aper_size, aper_alloc = 0, aper_order = 0, last_aper_order = 0;
@@ -393,19 +419,8 @@ void __init gart_iommu_hole_init(void)
 		return;
 	}
 
-	/* Fix up the north bridges */
-	for (num = 24; num < 32; num++) {
-		if (!early_is_k8_nb(read_pci_config(0, num, 3, 0x00)))
-			continue;
-
-		/*
-		 * Don't enable translation yet. That is done later
-		 * by enable_gart_translation.
-		 *
-		 * Assume this BIOS didn't initialise the GART so
-		 * just overwrite all previous bits
-		 */
-		write_pci_config(0, num, 3, AMD64_GARTAPERTURECTL, aper_order<<1);
-		write_pci_config(0, num, 3, AMD64_GARTAPERTUREBASE, aper_alloc>>25);
-	}
+	fix_aper_enabled = 1;
+	fix_aper_order = aper_order;
+	fix_aper_alloc = aper_alloc;
+	fix_up_north_bridges();
 }
diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
index 926af9c..dbd3000 100644
--- a/arch/x86/kernel/pci-gart_64.c
+++ b/arch/x86/kernel/pci-gart_64.c
@@ -549,14 +549,27 @@ static __init unsigned read_aperture(str
 	return aper_base;
 }
 
+static void enable_gart_translations(void)
+{
+	int i;
+	struct pci_dev *dev;
+
+	for (i = 0; i < num_k8_northbridges; i++) {
+		dev = k8_northbridges[i];
+		enable_gart_translation(dev, __pa(agp_gatt_table));
+	}
+}
+
 static int gart_resume(struct sys_device *dev)
 {
+	fix_up_north_bridges();
+	enable_gart_translations();
 	return 0;
 }
 
 static int gart_suspend(struct sys_device *dev, pm_message_t state)
 {
-	return -EINVAL;
+	return 0;
 }
 
 static struct sysdev_class gart_sysdev_class = {
@@ -571,6 +584,7 @@ static struct sys_device device_gart = {
 	.cls	= &gart_sysdev_class,
 };
 
+
 /*
  * Private Northbridge GATT initialization in case we cannot use the
  * AGP driver for some reason.
@@ -614,11 +628,8 @@ static __init int init_k8_gatt(struct ag
 	memset(gatt, 0, gatt_size);
 	agp_gatt_table = gatt;
 
-	for (i = 0; i < num_k8_northbridges; i++) {
-		dev = k8_northbridges[i];
-		enable_gart_translation(dev, __pa(gatt));
-	}
-	
+	enable_gart_translations();
+
 	error = sysdev_class_register(&gart_sysdev_class);
 	if (!error)
 		error = sysdev_register(&device_gart);
@@ -651,6 +662,11 @@ static const struct dma_mapping_ops gart
 	.unmap_sg			= gart_unmap_sg,
 };
 
+/* Called from native_machine_shutdown; should this use regular
+ * shutdown call from sysdev?  Why is this needed at all? Some broken
+ * BIOS can't cope with gart enabled during reboot?
+ */
+
 void gart_iommu_shutdown(void)
 {
 	struct pci_dev *dev;
diff --git a/drivers/char/agp/generic.c b/drivers/char/agp/generic.c
index 7fc0c99..7fb4d5b 100644
--- a/drivers/char/agp/generic.c
+++ b/drivers/char/agp/generic.c
@@ -43,7 +43,7 @@ #include <asm/cacheflush.h>
 #include <asm/pgtable.h>
 #include "agp.h"
 
-__u32 *agp_gatt_table;
+u32 *agp_gatt_table;
 int agp_memory_reserved;
 
 /*
diff --git a/include/asm-x86/gart.h b/include/asm-x86/gart.h
index f37d83b..6f27b14 100644
--- a/include/asm-x86/gart.h
+++ b/include/asm-x86/gart.h
@@ -93,5 +93,6 @@ static inline int __aperture_valid(u64 a
 	return 1;
 }
 
+extern void fix_up_north_bridges(void);
 
 #endif


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
