Return-Path: <linux-kernel-owner+w=401wt.eu-S1760578AbYB0WvI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760578AbYB0WvI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 17:51:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757195AbYB0WuY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 17:50:24 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:55225 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754383AbYB0WuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 17:50:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=I9t4BsaEmwgJpgs8Xfe2C1XSON4qfPhMnAnhqLvaedaoCGLqQrVxXg7U+ATvDb6UlSOQRaWZd8Fb6D6ewRqe4RcTR1Yoj35wboepOnilbU9C60cuawnefdOrtuPpR/edAMG/IGM3SSFA8a3xiR/MY9svgXbacVP2O1fKT0+vql4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 2/3] ide-cs: manage I/O resources in driver
Date: Thu, 28 Feb 2008 00:03:29 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802280003.29312.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Make idecs_register() return pointer to hwif structure instead of
  hwif's index.

* Store pointer to hwif structure instead of hwif's index in ide_info_t
  (fixes ide-cs for IDE[6-9]_MAJOR major numbers).

* Remove no longer needed ide_major[].

* Tell IDE layer to not manage resources by setting hwif->mmio flag.

* Use {request,release}_region() for resources management.

* Use driver name for resources management.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/legacy/ide-cs.c |   70 ++++++++++++++++++++++++++++++--------------
 1 file changed, 48 insertions(+), 22 deletions(-)

Index: b/drivers/ide/legacy/ide-cs.c
===================================================================
--- a/drivers/ide/legacy/ide-cs.c
+++ b/drivers/ide/legacy/ide-cs.c
@@ -51,6 +51,8 @@
 #include <pcmcia/cisreg.h>
 #include <pcmcia/ciscode.h>
 
+#define DRV_NAME "ide-cs"
+
 /*====================================================================*/
 
 /* Module parameters */
@@ -72,16 +74,11 @@ static char *version =
 
 /*====================================================================*/
 
-static const char ide_major[] = {
-    IDE0_MAJOR, IDE1_MAJOR, IDE2_MAJOR, IDE3_MAJOR,
-    IDE4_MAJOR, IDE5_MAJOR
-};
-
 typedef struct ide_info_t {
 	struct pcmcia_device	*p_dev;
+	ide_hwif_t		*hwif;
     int		ndev;
     dev_node_t	node;
-    int		hd;
 } ide_info_t;
 
 static void ide_release(struct pcmcia_device *);
@@ -136,24 +133,44 @@ static int ide_probe(struct pcmcia_devic
 
 static void ide_detach(struct pcmcia_device *link)
 {
+    ide_info_t *info = link->priv;
+    ide_hwif_t *hwif = info->hwif;
+
     DEBUG(0, "ide_detach(0x%p)\n", link);
 
     ide_release(link);
 
-    kfree(link->priv);
+    release_region(hwif->io_ports[IDE_CONTROL_OFFSET], 1);
+    release_region(hwif->io_ports[IDE_DATA_OFFSET], 8);
+
+    kfree(info);
 } /* ide_detach */
 
 static const struct ide_port_ops idecs_port_ops = {
 	.quirkproc		= ide_undecoded_slave,
 };
 
-static int idecs_register(unsigned long io, unsigned long ctl, unsigned long irq, struct pcmcia_device *handle)
+static ide_hwif_t *idecs_register(unsigned long io, unsigned long ctl,
+				unsigned long irq, struct pcmcia_device *handle)
 {
     ide_hwif_t *hwif;
     hw_regs_t hw;
     int i;
     u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
 
+    if (!request_region(io, 8, DRV_NAME)) {
+	printk(KERN_ERR "%s: I/O resource 0x%lX-0x%lX not free.\n",
+			DRV_NAME, io, io + 7);
+	return NULL;
+    }
+
+    if (!request_region(ctl, 1, DRV_NAME)) {
+	printk(KERN_ERR "%s: I/O resource 0x%lX not free.\n",
+			DRV_NAME, ctl);
+	release_region(io, 8);
+	return NULL;
+    }
+
     memset(&hw, 0, sizeof(hw));
     ide_std_init_ports(&hw, io, ctl);
     hw.irq = irq;
@@ -162,7 +179,7 @@ static int idecs_register(unsigned long 
 
     hwif = ide_find_port();
     if (hwif == NULL)
-	return -1;
+	goto out_release;
 
     i = hwif->index;
 
@@ -178,7 +195,13 @@ static int idecs_register(unsigned long 
 
     ide_device_add(idx, NULL);
 
-    return hwif->present ? i : -1;
+    if (hwif->present)
+	return hwif;
+
+out_release:
+    release_region(ctl, 1);
+    release_region(io, 8);
+    return NULL;
 }
 
 /*======================================================================
@@ -203,8 +226,9 @@ static int ide_config(struct pcmcia_devi
 	cistpl_cftable_entry_t dflt;
     } *stk = NULL;
     cistpl_cftable_entry_t *cfg;
-    int i, pass, last_ret = 0, last_fn = 0, hd, is_kme = 0;
+    int i, pass, last_ret = 0, last_fn = 0, is_kme = 0;
     unsigned long io_base, ctl_base;
+    ide_hwif_t *hwif;
 
     DEBUG(0, "ide_config(0x%p)\n", link);
 
@@ -300,14 +324,15 @@ static int ide_config(struct pcmcia_devi
 	outb(0x81, ctl_base+1);
 
     /* retry registration in case device is still spinning up */
-    for (hd = -1, i = 0; i < 10; i++) {
-	hd = idecs_register(io_base, ctl_base, link->irq.AssignedIRQ, link);
-	if (hd >= 0) break;
+    for (i = 0; i < 10; i++) {
+	hwif = idecs_register(io_base, ctl_base, link->irq.AssignedIRQ, link);
+	if (hwif)
+	    break;
 	if (link->io.NumPorts1 == 0x20) {
 	    outb(0x02, ctl_base + 0x10);
-	    hd = idecs_register(io_base + 0x10, ctl_base + 0x10,
-				link->irq.AssignedIRQ, link);
-	    if (hd >= 0) {
+	    hwif = idecs_register(io_base + 0x10, ctl_base + 0x10,
+				  link->irq.AssignedIRQ, link);
+	    if (hwif) {
 		io_base += 0x10;
 		ctl_base += 0x10;
 		break;
@@ -316,7 +341,7 @@ static int ide_config(struct pcmcia_devi
 	msleep(100);
     }
 
-    if (hd < 0) {
+    if (hwif == NULL) {
 	printk(KERN_NOTICE "ide-cs: ide_register() at 0x%3lx & 0x%3lx"
 	       ", irq %u failed\n", io_base, ctl_base,
 	       link->irq.AssignedIRQ);
@@ -324,10 +349,10 @@ static int ide_config(struct pcmcia_devi
     }
 
     info->ndev = 1;
-    sprintf(info->node.dev_name, "hd%c", 'a' + (hd * 2));
-    info->node.major = ide_major[hd];
+    sprintf(info->node.dev_name, "hd%c", 'a' + hwif->index * 2);
+    info->node.major = hwif->major;
     info->node.minor = 0;
-    info->hd = hd;
+    info->hwif = hwif;
     link->dev_node = &info->node;
     printk(KERN_INFO "ide-cs: %s: Vpp = %d.%d\n",
 	   info->node.dev_name, link->conf.Vpp / 10, link->conf.Vpp % 10);
@@ -358,13 +383,14 @@ failed:
 void ide_release(struct pcmcia_device *link)
 {
     ide_info_t *info = link->priv;
+    ide_hwif_t *hwif = info->hwif;
 
     DEBUG(0, "ide_release(0x%p)\n", link);
 
     if (info->ndev) {
 	/* FIXME: if this fails we need to queue the cleanup somehow
 	   -- need to investigate the required PCMCIA magic */
-	ide_unregister(info->hd);
+	ide_unregister(hwif->index);
     }
     info->ndev = 0;
 
