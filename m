Return-Path: <linux-kernel-owner+w=401wt.eu-S1763707AbYBHAfN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763707AbYBHAfN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 19:35:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932558AbYBHAbQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 19:31:16 -0500
Received: from py-out-1112.google.com ([64.233.166.178]:56846 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762470AbYBHAbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 19:31:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=I34hBAt+0XsokoRQWEnQWkr3IYyFGrVAraja8kP/HOzy+BZ/t/nyTtorS12zCDIVNkyCOpdj2GVPAgmkaDmP/RdklsJwK5IjTK8h6X5bwx6thpmQ7P/SBc3JszzcYQsRQ+AweBg3LbxfU9roe4F8TDCHGEc753x7G2ficAC56g0=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: linuxppc-dev@ozlabs.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 08 Feb 2008 01:45:23 +0100
Message-Id: <20080208004523.17746.24578.sendpatchset@localhost.localdomain>
In-Reply-To: <20080208004421.17746.32557.sendpatchset@localhost.localdomain>
References: <20080208004421.17746.32557.sendpatchset@localhost.localdomain>
Subject: [PATCH 09/18] ide: rework PowerMac media-bay support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rework PowerMac media-bay support in such way that instead of
un/registering the IDE interface we un/register IDE devices:

* Add ide_port_scan() helper for probing+registerering devices on a port.

* Rename ide_port_unregister_devices() to __ide_port_unregister_devices().

* Add ide_port_unregister_devices() helper for unregistering devices on a port.

* Add 'ide_hwif_t *cd_port' to 'struct media_bay_info', pass 'hwif' instead
  of hwif->index to media_bay_set_ide_infos() and use it to setup 'cd_port'.

* Use ide_port_unregister_devices() instead of ide_unregister()
  and ide_port_scan() instead of ide_register_hw() in media_bay_step().

* Unexport ide_register_hw() and make it static.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-probe.c        |   18 ++++++++++++++++++
 drivers/ide/ide.c              |   22 ++++++++++++++++------
 drivers/ide/ppc/pmac.c         |    3 ++-
 drivers/macintosh/mediabay.c   |   17 +++++++----------
 include/asm-powerpc/mediabay.h |    4 +++-
 include/linux/ide.h            |    6 ++----
 6 files changed, 48 insertions(+), 22 deletions(-)

Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -1490,3 +1490,21 @@ int ide_device_add(u8 idx[4], const stru
 	return ide_device_add_all(idx_all, d);
 }
 EXPORT_SYMBOL_GPL(ide_device_add);
+
+void ide_port_scan(ide_hwif_t *hwif)
+{
+	ide_port_cable_detect(hwif);
+	ide_port_init_devices(hwif);
+
+	if (ide_probe_port(hwif) < 0)
+		return;
+
+	hwif->present = 1;
+
+	ide_port_tune_devices(hwif);
+	ide_acpi_port_init_devices(hwif);
+	ide_port_setup_devices(hwif);
+	hwif_register_devices(hwif);
+	ide_proc_port_register_devices(hwif);
+}
+EXPORT_SYMBOL_GPL(ide_port_scan);
Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -506,7 +506,7 @@ void ide_remove_port_from_hwgroup(ide_hw
 }
 
 /* Called with ide_lock held. */
-static void ide_port_unregister_devices(ide_hwif_t *hwif)
+static void __ide_port_unregister_devices(ide_hwif_t *hwif)
 {
 	int i;
 
@@ -522,6 +522,18 @@ static void ide_port_unregister_devices(
 	}
 }
 
+void ide_port_unregister_devices(ide_hwif_t *hwif)
+{
+	mutex_lock(&ide_cfg_mtx);
+	spin_lock_irq(&ide_lock);
+	__ide_port_unregister_devices(hwif);
+	hwif->present = 0;
+	ide_port_init_devices_data(hwif);
+	spin_unlock_irq(&ide_lock);
+	mutex_unlock(&ide_cfg_mtx);
+}
+EXPORT_SYMBOL_GPL(ide_port_unregister_devices);
+
 /**
  *	ide_unregister		-	free an IDE interface
  *	@index: index of interface (will change soon to a pointer)
@@ -562,7 +574,7 @@ void ide_unregister(unsigned int index, 
 	hwif = &ide_hwifs[index];
 	if (!hwif->present)
 		goto abort;
-	ide_port_unregister_devices(hwif);
+	__ide_port_unregister_devices(hwif);
 	hwif->present = 0;
 
 	spin_unlock_irq(&ide_lock);
@@ -657,8 +669,8 @@ EXPORT_SYMBOL_GPL(ide_init_port_hw);
  *	Returns -1 on error.
  */
 
-int ide_register_hw(hw_regs_t *hw, void (*quirkproc)(ide_drive_t *),
-		    ide_hwif_t **hwifp)
+static int ide_register_hw(hw_regs_t *hw, void (*quirkproc)(ide_drive_t *),
+			   ide_hwif_t **hwifp)
 {
 	int index, retry = 1;
 	ide_hwif_t *hwif;
@@ -692,8 +704,6 @@ found:
 	return hwif->present ? index : -1;
 }
 
-EXPORT_SYMBOL(ide_register_hw);
-
 /*
  *	Locks for IDE setting functionality
  */
Index: b/drivers/ide/ppc/pmac.c
===================================================================
--- a/drivers/ide/ppc/pmac.c
+++ b/drivers/ide/ppc/pmac.c
@@ -1088,7 +1088,8 @@ pmac_ide_setup_device(pmac_ide_hwif_t *p
 	if (np->parent && np->parent->name
 	    && strcasecmp(np->parent->name, "media-bay") == 0) {
 #ifdef CONFIG_PMAC_MEDIABAY
-		media_bay_set_ide_infos(np->parent, pmif->regbase, pmif->irq, hwif->index);
+		media_bay_set_ide_infos(np->parent, pmif->regbase, pmif->irq,
+					hwif);
 #endif /* CONFIG_PMAC_MEDIABAY */
 		pmif->mediabay = 1;
 		if (!bidp)
Index: b/drivers/macintosh/mediabay.c
===================================================================
--- a/drivers/macintosh/mediabay.c
+++ b/drivers/macintosh/mediabay.c
@@ -79,6 +79,7 @@ struct media_bay_info {
 	int				sleeping;
 	struct semaphore		lock;
 #ifdef CONFIG_BLK_DEV_IDE_PMAC
+	ide_hwif_t			*cd_port;
 	void __iomem			*cd_base;
 	int				cd_irq;
 	int				cd_retry;
@@ -450,7 +451,7 @@ int check_media_bay_by_base(unsigned lon
 }
 
 int media_bay_set_ide_infos(struct device_node* which_bay, unsigned long base,
-			    int irq, int index)
+			    int irq, ide_hwif_t *hwif)
 {
 	int	i;
 
@@ -458,10 +459,11 @@ int media_bay_set_ide_infos(struct devic
 		struct media_bay_info* bay = &media_bays[i];
 
 		if (bay->mdev && which_bay == bay->mdev->ofdev.node) {
-			int timeout = 5000;
+			int timeout = 5000, index = hwif->index;
 			
 			down(&bay->lock);
 
+			bay->cd_port	= hwif;
  			bay->cd_base	= (void __iomem *) base;
 			bay->cd_irq	= irq;
 
@@ -553,15 +555,10 @@ static void media_bay_step(int i)
 			bay->timer = 0;
 			bay->state = mb_up;
 			if (bay->cd_index < 0) {
-				hw_regs_t hw;
-
 				printk("mediabay %d, registering IDE...\n", i);
 				pmu_suspend();
-				ide_init_hwif_ports(&hw, (unsigned long) bay->cd_base, (unsigned long) 0, NULL);
-				hw.irq = bay->cd_irq;
-				hw.chipset = ide_pmac;
-				bay->cd_index =
-					ide_register_hw(&hw, NULL, NULL);
+				ide_port_scan(bay->cd_port);
+				bay->cd_index = bay->cd_port->index;
 				pmu_resume();
 			}
 			if (bay->cd_index == -1) {
@@ -591,7 +588,7 @@ static void media_bay_step(int i)
     	        if (bay->cd_index >= 0) {
 			printk(KERN_DEBUG "Unregistering mb %d ide, index:%d\n", i,
 			       bay->cd_index);
-			ide_unregister(bay->cd_index, 1, 1);
+			ide_port_unregister_devices(bay->cd_port);
 			bay->cd_index = -1;
 		}
 	    	if (bay->cd_retry) {
Index: b/include/asm-powerpc/mediabay.h
===================================================================
--- a/include/asm-powerpc/mediabay.h
+++ b/include/asm-powerpc/mediabay.h
@@ -22,10 +22,12 @@ int check_media_bay(struct device_node *
 /* Number of bays in the machine or 0 */
 extern int media_bay_count;
 
+#ifdef CONFIG_BLK_DEV_IDE_PMAC
 int check_media_bay_by_base(unsigned long base, int what);
 /* called by IDE PMAC host driver to register IDE controller for media bay */
 int media_bay_set_ide_infos(struct device_node *which_bay, unsigned long base,
-			    int irq, int index);
+			    int irq, ide_hwif_t *hwif);
+#endif
 
 #endif /* __KERNEL__ */
 #endif /* _PPC_MEDIABAY_H */
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -189,10 +189,6 @@ struct hwif_s * ide_find_port(unsigned l
 void ide_init_port_data(struct hwif_s *, unsigned int);
 void ide_init_port_hw(struct hwif_s *, hw_regs_t *);
 
-struct ide_drive_s;
-int ide_register_hw(hw_regs_t *, void (*)(struct ide_drive_s *),
-		    struct hwif_s **);
-
 static inline void ide_std_init_ports(hw_regs_t *hw,
 				      unsigned long io_addr,
 				      unsigned long ctl_addr)
@@ -1202,6 +1198,8 @@ void ide_undecoded_slave(ide_drive_t *);
 
 int ide_device_add_all(u8 *idx, const struct ide_port_info *);
 int ide_device_add(u8 idx[4], const struct ide_port_info *);
+void ide_port_unregister_devices(ide_hwif_t *);
+void ide_port_scan(ide_hwif_t *);
 
 static inline void *ide_get_hwifdata (ide_hwif_t * hwif)
 {
