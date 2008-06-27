Return-Path: <linux-kernel-owner+w=401wt.eu-S932290AbYF0XMi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932290AbYF0XMi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 19:12:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764789AbYF0W7w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 18:59:52 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:13675 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764699AbYF0W7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 18:59:17 -0400
Message-Id: <20080627225803.846190706@ldl.fc.hp.com>
References: <20080627225651.663174474@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Fri, 27 Jun 2008 16:57:18 -0600
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Len Brown <lenb@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: Adam Belay <ambx1@neo.rr.com>
Cc: Adam M Belay <abelay@mit.edu>
Cc: Li Shaohua <shaohua.li@intel.com>
Cc: Matthieu Castet <castet.matthieu@free.fr>
Cc: Thomas Renninger <trenn@suse.de>
Cc: Rene Herman <rene.herman@keyaccess.nl>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Jiri Slaby <jirislaby@gmail.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [patch 27/28] PNP: avoid legacy IDE IRQs
Content-Disposition: inline; filename=pnp-legacy-ide-irq
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If an IDE controller is in compatibility mode, it expects to use
IRQs 14 and 15, so PNP should avoid them.

This patch should resolve this problem report:
  parallel driver grabs IRQ14 preventing legacy SFF ATA controller from working
  https://bugzilla.novell.com/show_bug.cgi?id=375836

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

Index: work14/drivers/pnp/resource.c
===================================================================
--- work14.orig/drivers/pnp/resource.c	2008-06-17 16:40:04.000000000 -0600
+++ work14/drivers/pnp/resource.c	2008-06-24 15:39:08.000000000 -0600
@@ -286,6 +286,61 @@ static irqreturn_t pnp_test_handler(int 
 	return IRQ_HANDLED;
 }
 
+#ifdef CONFIG_PCI
+static int pci_dev_uses_irq(struct pnp_dev *pnp, struct pci_dev *pci,
+			    unsigned int irq)
+{
+	u32 class;
+	u8 progif;
+
+	if (pci->irq == irq) {
+		dev_dbg(&pnp->dev, "device %s using irq %d\n",
+			pci_name(pci), irq);
+		return 1;
+	}
+
+	/*
+	 * See pci_setup_device() and ata_pci_sff_activate_host() for
+	 * similar IDE legacy detection.
+	 */
+	pci_read_config_dword(pci, PCI_CLASS_REVISION, &class);
+	class >>= 8;		/* discard revision ID */
+	progif = class & 0xff;
+	class >>= 8;
+
+	if (class == PCI_CLASS_STORAGE_IDE) {
+		/*
+		 * Unless both channels are native-PCI mode only,
+		 * treat the compatibility IRQs as busy.
+		 */
+		if ((progif & 0x5) != 0x5)
+			if (pci_get_legacy_ide_irq(pci, 0) == irq ||
+			    pci_get_legacy_ide_irq(pci, 1) == irq) {
+				dev_dbg(&pnp->dev, "legacy IDE device %s "
+					"using irq %d\n", pci_name(pci), irq);
+				return 1;
+			}
+	}
+
+	return 0;
+}
+#endif
+
+static int pci_uses_irq(struct pnp_dev *pnp, unsigned int irq)
+{
+#ifdef CONFIG_PCI
+	struct pci_dev *pci = NULL;
+
+	for_each_pci_dev(pci) {
+		if (pci_dev_uses_irq(pnp, pci, irq)) {
+			pci_dev_put(pci);
+			return 1;
+		}
+	}
+#endif
+	return 0;
+}
+
 int pnp_check_irq(struct pnp_dev *dev, struct resource *res)
 {
 	int i;
@@ -317,18 +372,9 @@ int pnp_check_irq(struct pnp_dev *dev, s
 		}
 	}
 
-#ifdef CONFIG_PCI
 	/* check if the resource is being used by a pci device */
-	{
-		struct pci_dev *pci = NULL;
-		for_each_pci_dev(pci) {
-			if (pci->irq == *irq) {
-				pci_dev_put(pci);
-				return 0;
-			}
-		}
-	}
-#endif
+	if (pci_uses_irq(dev, *irq))
+		return 0;
 
 	/* check if the resource is already in use, skip if the
 	 * device is active because it itself may be in use */

-- 
