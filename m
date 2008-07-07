Return-Path: <linux-kernel-owner+w=401wt.eu-S1757573AbYGGUN2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757573AbYGGUN2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 16:13:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755513AbYGGUNR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 16:13:17 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:51898 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755594AbYGGUNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 16:13:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=E2Fmn39DLvJ9HhteFWHu+KDnIkc9zIknDywp35uF+QUQouPTH1GLCOFMAcwmCMOv+6
         hMZBIe+sOxz2Qk4yqjHEzAukShcc5qGnh8ka35lE8PGSeSvFNOBVrja5JlSsSeF0cNwt
         ODRnrBPVfsATmK6qMla8Jeit7J3BnwQg2QQQo=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH] ide: add __ide_default_irq() inline helper
Date: Mon, 7 Jul 2008 22:09:44 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807072209.44933.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add __ide_default_irq() inline helper and use it instead of
ide_default_irq() in ide-probe.c and ns87415.c (all host drivers
except IDE PCI ones always setup hwif->irq so it is enough to
check only for I/O bases 0x1f0 and 0x170).

This fixes post-2.6.25 regression since ide_default_irq()
define could shadow ide_default_irq() inline.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
for 2.6.26

 drivers/ide/ide-probe.c   |    8 ++------
 drivers/ide/pci/ns87415.c |    6 +-----
 include/linux/ide.h       |   15 +++++++++++++++
 3 files changed, 18 insertions(+), 11 deletions(-)

Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -1280,16 +1280,12 @@ static void drive_release_dev (struct de
 	complete(&drive->gendev_rel_comp);
 }
 
-#ifndef ide_default_irq
-#define ide_default_irq(irq) 0
-#endif
-
 static int hwif_init(ide_hwif_t *hwif)
 {
 	int old_irq;
 
 	if (!hwif->irq) {
-		hwif->irq = ide_default_irq(hwif->io_ports.data_addr);
+		hwif->irq = __ide_default_irq(hwif->io_ports.data_addr);
 		if (!hwif->irq) {
 			printk("%s: DISABLED, NO IRQ\n", hwif->name);
 			return 0;
@@ -1319,7 +1315,7 @@ static int hwif_init(ide_hwif_t *hwif)
 	 *	It failed to initialise. Find the default IRQ for 
 	 *	this port and try that.
 	 */
-	hwif->irq = ide_default_irq(hwif->io_ports.data_addr);
+	hwif->irq = __ide_default_irq(hwif->io_ports.data_addr);
 	if (!hwif->irq) {
 		printk("%s: Disabled unable to get IRQ %d.\n",
 			hwif->name, old_irq);
Index: b/drivers/ide/pci/ns87415.c
===================================================================
--- a/drivers/ide/pci/ns87415.c
+++ b/drivers/ide/pci/ns87415.c
@@ -220,10 +220,6 @@ static int ns87415_dma_setup(ide_drive_t
 	return 1;
 }
 
-#ifndef ide_default_irq
-#define ide_default_irq(irq) 0
-#endif
-
 static void __devinit init_hwif_ns87415 (ide_hwif_t *hwif)
 {
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
@@ -283,7 +279,7 @@ static void __devinit init_hwif_ns87415 
 	}
 
 	if (!using_inta)
-		hwif->irq = ide_default_irq(hwif->io_ports.data_addr);
+		hwif->irq = __ide_default_irq(hwif->io_ports.data_addr);
 	else if (!hwif->irq && hwif->mate && hwif->mate->irq)
 		hwif->irq = hwif->mate->irq;	/* share IRQ with mate */
 
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -196,6 +196,21 @@ static inline void ide_std_init_ports(hw
 	hw->io_ports.ctl_addr = ctl_addr;
 }
 
+/* for IDE PCI controllers in legacy mode, temporary */
+static inline int __ide_default_irq(unsigned long base)
+{
+	switch (base) {
+#ifdef CONFIG_IA64
+	case 0x1f0: return isa_irq_to_vector(14);
+	case 0x170: return isa_irq_to_vector(15);
+#else
+	case 0x1f0: return 14;
+	case 0x170: return 15;
+#endif
+	}
+	return 0;
+}
+
 #include <asm/ide.h>
 
 #if !defined(MAX_HWIFS) || defined(CONFIG_EMBEDDED)
