Return-Path: <linux-kernel-owner+w=401wt.eu-S1759792AbYFCWcv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759792AbYFCWcv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 18:32:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755680AbYFCWck
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 18:32:40 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42503 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753700AbYFCWcj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 18:32:39 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@suse.cz>
Subject: Re: >3G => iommu => suspend problems -- was Re: SB600 AHCI: Hard Disk Corruption
Date: Wed, 4 Jun 2008 00:33:20 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Patrick <ragamuffin@datacomm.ch>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <1211717435.6038.53.camel@localhost.localdomain> <1211815881.6140.19.camel@localhost.localdomain> <20080527112236.GA13957@elf.ucw.cz>
In-Reply-To: <20080527112236.GA13957@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806040033.20736.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 27 of May 2008, Pavel Machek wrote:
> Hi!
> 
> > > Can you try this one? It should prevent suspend in the broken cases,
> > > but allow it in mem=4G config.
> > 
> > Sure!
> > 
> > root@babar:/usr/src/linux-2.6.25# patch -p1 < /home/pat/patch-2.6.26-rc3.gart-suspend
> > patching file arch/x86/kernel/pci-gart_64.c
> > Hunk #4 succeeded at 629 with fuzz 2 (offset 11 lines).
> > 
> > .....make; cp bzImage /boot; reboot....
> 
> Thanks!
> 
> This goes on top of the second patch... it makes it work.
> 
> 								Pavel
> 
> For iommu suspend/resume code to work, functions it calls may not be
> __init.
> 
> Signed-off-by: Pavel Machek <pavel@suse.cz>

I consolidated some of your patches sent in this thread and made the result
apply to the current -git.  It hasn't been tested yet, but does it look good?

It's on top of the patch that adds the GART sysdev.

Thanks,
Rafael

---
Handle GART IOMMU suspend and resume.

Not-yet-signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 arch/x86/kernel/aperture_64.c |   34 ++++++++++++++++---------
 arch/x86/kernel/k8.c          |    2 -
 arch/x86/kernel/pci-gart_64.c |   55 +++++++++++++++++++++++++++++-------------
 include/asm-x86/gart.h        |    2 +
 4 files changed, 63 insertions(+), 30 deletions(-)

Index: linux-2.6/arch/x86/kernel/pci-gart_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/pci-gart_64.c
+++ linux-2.6/arch/x86/kernel/pci-gart_64.c
@@ -549,14 +549,50 @@ static __init unsigned read_aperture(str
 	return aper_base;
 }
 
+static void enable_gart_translations(void)
+{
+	int i;
+
+	for (i = 0; i < num_k8_northbridges; i++) {
+		struct pci_dev *dev;
+		u32 gatt_reg;
+		u32 ctl;
+
+		dev = k8_northbridges[i];
+		gatt_reg = __pa(agp_gatt_table) >> 12;
+		gatt_reg <<= 4;
+		pci_write_config_dword(dev, 0x98, gatt_reg);
+		pci_read_config_dword(dev, 0x90, &ctl);
+
+		ctl |= 1;
+		ctl &= ~((1<<4) | (1<<5));
+
+		pci_write_config_dword(dev, 0x90, ctl);
+	}
+}
+
+static bool fix_north_bridges;	/* call fix_up_north_bridges() on resume */
+static u32 aperture_order;	/* arguments for fix_up_north_bridges() */
+static u32 aperture_alloc;
+
+void set_gart_resume_data(u32 aper_order, u32 aper_alloc)
+{
+	fix_north_bridges = true;
+	aperture_order = aper_order;
+	aperture_alloc = aper_alloc;
+}
+
 static int gart_resume(struct sys_device *dev)
 {
+	if (fix_north_bridges)
+		fix_up_north_bridges(aperture_order, aperture_alloc);
+	enable_gart_translations();
 	return 0;
 }
 
 static int gart_suspend(struct sys_device *dev, pm_message_t state)
 {
-	return -EINVAL;
+	return 0;
 }
 
 static struct sysdev_class gart_sysdev_class = {
@@ -613,27 +649,14 @@ static __init int init_k8_gatt(struct ag
 	memset(gatt, 0, gatt_size);
 	agp_gatt_table = gatt;
 
-	for (i = 0; i < num_k8_northbridges; i++) {
-		u32 gatt_reg;
-		u32 ctl;
-
-		dev = k8_northbridges[i];
-		gatt_reg = __pa(gatt) >> 12;
-		gatt_reg <<= 4;
-		pci_write_config_dword(dev, 0x98, gatt_reg);
-		pci_read_config_dword(dev, 0x90, &ctl);
-
-		ctl |= 1;
-		ctl &= ~((1<<4) | (1<<5));
-
-		pci_write_config_dword(dev, 0x90, ctl);
-	}
+	enable_gart_translations();
 
 	error = sysdev_class_register(&gart_sysdev_class);
 	if (!error)
 		error = sysdev_register(&device_gart);
 	if (error)
 		panic("Could not register gart_sysdev -- would corrupt data on next suspend");
+
 	flush_gart();
 
 	printk(KERN_INFO "PCI-DMA: aperture base @ %x size %u KB\n",
Index: linux-2.6/arch/x86/kernel/k8.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/k8.c
+++ linux-2.6/arch/x86/kernel/k8.c
@@ -76,7 +76,7 @@ EXPORT_SYMBOL_GPL(cache_k8_northbridges)
 
 /* Ignores subdevice/subvendor but as far as I can figure out
    they're useless anyways */
-int __init early_is_k8_nb(u32 device)
+int early_is_k8_nb(u32 device)
 {
 	struct pci_device_id *id;
 	u32 vendor = device & 0xffff;
Index: linux-2.6/arch/x86/kernel/aperture_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/aperture_64.c
+++ linux-2.6/arch/x86/kernel/aperture_64.c
@@ -310,6 +310,25 @@ void __init early_gart_iommu_check(void)
 
 }
 
+void fix_up_north_bridges(u32 aper_order, u32 aper_alloc)
+{
+	int num;
+
+	/* Fix up the north bridges */
+	for (num = 24; num < 32; num++) {
+		if (!early_is_k8_nb(read_pci_config(0, num, 3, 0x00)))
+			continue;
+
+		/*
+		 * Don't enable translation yet. That is done later.
+		 * Assume this BIOS didn't initialise the GART so
+		 * just overwrite all previous bits
+		 */
+		write_pci_config(0, num, 3, 0x90, aper_order << 1);
+		write_pci_config(0, num, 3, 0x94, aper_alloc >> 25);
+	}
+}
+
 void __init gart_iommu_hole_init(void)
 {
 	u32 aper_size, aper_alloc = 0, aper_order = 0, last_aper_order = 0;
@@ -400,17 +419,6 @@ void __init gart_iommu_hole_init(void)
 		return;
 	}
 
-	/* Fix up the north bridges */
-	for (num = 24; num < 32; num++) {
-		if (!early_is_k8_nb(read_pci_config(0, num, 3, 0x00)))
-			continue;
-
-		/*
-		 * Don't enable translation yet. That is done later.
-		 * Assume this BIOS didn't initialise the GART so
-		 * just overwrite all previous bits
-		 */
-		write_pci_config(0, num, 3, 0x90, aper_order<<1);
-		write_pci_config(0, num, 3, 0x94, aper_alloc>>25);
-	}
+	fix_up_north_bridges(aper_order, aper_alloc);
+	set_gart_resume_data(aper_order, aper_alloc);
 }
Index: linux-2.6/include/asm-x86/gart.h
===================================================================
--- linux-2.6.orig/include/asm-x86/gart.h
+++ linux-2.6/include/asm-x86/gart.h
@@ -11,6 +11,8 @@ extern void gart_iommu_shutdown(void);
 extern void __init gart_parse_options(char *);
 extern void early_gart_iommu_check(void);
 extern void gart_iommu_hole_init(void);
+extern void set_gart_resume_data(u32, u32);
+extern void fix_up_north_bridges(u32, u32);
 extern int fallback_aper_order;
 extern int fallback_aper_force;
 extern int gart_iommu_aperture;
