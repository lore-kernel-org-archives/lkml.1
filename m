Return-Path: <linux-kernel-owner+w=401wt.eu-S1759977AbXGXHrk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759977AbXGXHrk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 03:47:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750912AbXGXHra
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 03:47:30 -0400
Received: from havoc.gtf.org ([69.61.125.42]:56071 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750822AbXGXHr3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 03:47:29 -0400
Date: Tue, 24 Jul 2007 03:47:28 -0400
From: Jeff Garzik <jeff@garzik.org>
To: kkeil@suse.de, isdn4linux@listserv.isdn4linux.de,
       LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, surya.prabhakar@wipro.com
Subject: [PATCH 1/3] HiSax avm_pci: split setup into smaller functions
Message-ID: <20070724074728.GA15062@havoc.gtf.org>
References: <20070724074653.GA14987@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070724074653.GA14987@havoc.gtf.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


commit 56069967cb9da3d3853955d78602b47bce78b585
Author: Jeff Garzik <jeff@garzik.org>
Date:   Tue Jul 24 01:24:46 2007 -0400

    [ISDN] HiSax avm_pci: split setup into three smaller functions
    
    Prepare for new ISA/PNP/PCI APIs.
    
    Signed-off-by: Jeff Garzik <jeff@garzik.org>

 drivers/isdn/hisax/avm_pci.c |  224 ++++++++++++++++++++++++++-----------------
 1 file changed, 136 insertions(+), 88 deletions(-)

56069967cb9da3d3853955d78602b47bce78b585
diff --git a/drivers/isdn/hisax/avm_pci.c b/drivers/isdn/hisax/avm_pci.c
index b04a178..f8b7978 100644
--- a/drivers/isdn/hisax/avm_pci.c
+++ b/drivers/isdn/hisax/avm_pci.c
@@ -20,7 +20,6 @@
 #include <linux/isapnp.h>
 #include <linux/interrupt.h>
 
-extern const char *CardType[];
 static const char *avm_pci_rev = "$Revision: 1.29.2.4 $";
 
 #define  AVM_FRITZ_PCI		1
@@ -726,100 +725,15 @@ AVM_card_msg(struct IsdnCardState *cs, int mt, void *arg)
 	return(0);
 }
 
-#ifdef CONFIG_PCI
-static struct pci_dev *dev_avm __devinitdata = NULL;
-#endif
-#ifdef __ISAPNP__
-static struct pnp_card *pnp_avm_c __devinitdata = NULL;
-#endif
-
-int __devinit
-setup_avm_pcipnp(struct IsdnCard *card)
+static int __devinit avm_setup_rest(struct IsdnCardState *cs)
 {
 	u_int val, ver;
-	struct IsdnCardState *cs = card->cs;
-	char tmp[64];
 
-	strcpy(tmp, avm_pci_rev);
-	printk(KERN_INFO "HiSax: AVM PCI driver Rev. %s\n", HiSax_getrev(tmp));
-	if (cs->typ != ISDN_CTYPE_FRITZPCI)
-		return (0);
-	if (card->para[1]) {
-		/* old manual method */
-		cs->hw.avm.cfg_reg = card->para[1];
-		cs->irq = card->para[0];
-		cs->subtyp = AVM_FRITZ_PNP;
-		goto ready;
-	}
-#ifdef __ISAPNP__
-	if (isapnp_present()) {
-		struct pnp_dev *pnp_avm_d = NULL;
-		if ((pnp_avm_c = pnp_find_card(
-			ISAPNP_VENDOR('A', 'V', 'M'),
-			ISAPNP_FUNCTION(0x0900), pnp_avm_c))) {
-			if ((pnp_avm_d = pnp_find_dev(pnp_avm_c,
-				ISAPNP_VENDOR('A', 'V', 'M'),
-				ISAPNP_FUNCTION(0x0900), pnp_avm_d))) {
-				int err;
-
-				pnp_disable_dev(pnp_avm_d);
-				err = pnp_activate_dev(pnp_avm_d);
-				if (err<0) {
-					printk(KERN_WARNING "%s: pnp_activate_dev ret(%d)\n",
-						__FUNCTION__, err);
-					return(0);
-				}
-				cs->hw.avm.cfg_reg =
-					pnp_port_start(pnp_avm_d, 0);
-				cs->irq = pnp_irq(pnp_avm_d, 0);
-				if (!cs->irq) {
-					printk(KERN_ERR "FritzPnP:No IRQ\n");
-					return(0);
-				}
-				if (!cs->hw.avm.cfg_reg) {
-					printk(KERN_ERR "FritzPnP:No IO address\n");
-					return(0);
-				}
-				cs->subtyp = AVM_FRITZ_PNP;
-				goto ready;
-			}
-		}
-	} else {
-		printk(KERN_INFO "FritzPnP: no ISA PnP present\n");
-	}
-#endif
-#ifdef CONFIG_PCI
-	if ((dev_avm = pci_find_device(PCI_VENDOR_ID_AVM,
-		PCI_DEVICE_ID_AVM_A1,  dev_avm))) {
-		if (pci_enable_device(dev_avm))
-			return(0);
-		cs->irq = dev_avm->irq;
-		if (!cs->irq) {
-			printk(KERN_ERR "FritzPCI: No IRQ for PCI card found\n");
-			return(0);
-		}
-		cs->hw.avm.cfg_reg = pci_resource_start(dev_avm, 1);
-		if (!cs->hw.avm.cfg_reg) {
-			printk(KERN_ERR "FritzPCI: No IO-Adr for PCI card found\n");
-			return(0);
-		}
-		cs->subtyp = AVM_FRITZ_PCI;
-	} else {
-		printk(KERN_WARNING "FritzPCI: No PCI card found\n");
-		return(0);
-	}
-	cs->irq_flags |= IRQF_SHARED;
-#else
-	printk(KERN_WARNING "FritzPCI: NO_PCI_BIOS\n");
-	return (0);
-#endif /* CONFIG_PCI */
-ready:
 	cs->hw.avm.isac = cs->hw.avm.cfg_reg + 0x10;
 	if (!request_region(cs->hw.avm.cfg_reg, 32,
 		(cs->subtyp == AVM_FRITZ_PCI) ? "avm PCI" : "avm PnP")) {
 		printk(KERN_WARNING
-		       "HiSax: %s config port %x-%x already in use\n",
-		       CardType[card->typ],
+		       "HiSax: Fritz!PCI/PNP config port %x-%x already in use\n",
 		       cs->hw.avm.cfg_reg,
 		       cs->hw.avm.cfg_reg + 31);
 		return (0);
@@ -860,3 +774,137 @@ ready:
 	ISACVersion(cs, (cs->subtyp == AVM_FRITZ_PCI) ? "AVM PCI:" : "AVM PnP:");
 	return (1);
 }
+
+#ifndef __ISAPNP__
+
+static int __devinit avm_pnp_setup(struct IsdnCardState *cs)
+{
+	return(1);	/* no-op: success */
+}
+
+#else
+
+static struct pnp_card *pnp_avm_c __devinitdata = NULL;
+
+static int __devinit avm_pnp_setup(struct IsdnCardState *cs)
+{
+	struct pnp_dev *pnp_avm_d = NULL;
+
+	if (!isapnp_present())
+		return(1);	/* no-op: success */
+
+	if ((pnp_avm_c = pnp_find_card(
+		ISAPNP_VENDOR('A', 'V', 'M'),
+		ISAPNP_FUNCTION(0x0900), pnp_avm_c))) {
+		if ((pnp_avm_d = pnp_find_dev(pnp_avm_c,
+			ISAPNP_VENDOR('A', 'V', 'M'),
+			ISAPNP_FUNCTION(0x0900), pnp_avm_d))) {
+			int err;
+
+			pnp_disable_dev(pnp_avm_d);
+			err = pnp_activate_dev(pnp_avm_d);
+			if (err<0) {
+				printk(KERN_WARNING "%s: pnp_activate_dev ret(%d)\n",
+					__FUNCTION__, err);
+				return(0);
+			}
+			cs->hw.avm.cfg_reg =
+				pnp_port_start(pnp_avm_d, 0);
+			cs->irq = pnp_irq(pnp_avm_d, 0);
+			if (!cs->irq) {
+				printk(KERN_ERR "FritzPnP:No IRQ\n");
+				return(0);
+			}
+			if (!cs->hw.avm.cfg_reg) {
+				printk(KERN_ERR "FritzPnP:No IO address\n");
+				return(0);
+			}
+			cs->subtyp = AVM_FRITZ_PNP;
+
+			return (2);	/* goto 'ready' label */
+		}
+	}
+
+	return (1);
+}
+
+#endif /* __ISAPNP__ */
+
+#ifndef CONFIG_PCI
+
+static int __devinit avm_pci_setup(struct IsdnCardState *cs)
+{
+	return(1);	/* no-op: success */
+}
+
+#else
+
+static struct pci_dev *dev_avm __devinitdata = NULL;
+
+static int __devinit avm_pci_setup(struct IsdnCardState *cs)
+{
+	if ((dev_avm = pci_find_device(PCI_VENDOR_ID_AVM,
+		PCI_DEVICE_ID_AVM_A1, dev_avm))) {
+
+		if (pci_enable_device(dev_avm))
+			return(0);
+
+		cs->irq = dev_avm->irq;
+		if (!cs->irq) {
+			printk(KERN_ERR "FritzPCI: No IRQ for PCI card found\n");
+			return(0);
+		}
+
+		cs->hw.avm.cfg_reg = pci_resource_start(dev_avm, 1);
+		if (!cs->hw.avm.cfg_reg) {
+			printk(KERN_ERR "FritzPCI: No IO-Adr for PCI card found\n");
+			return(0);
+		}
+
+		cs->subtyp = AVM_FRITZ_PCI;
+	} else {
+		printk(KERN_WARNING "FritzPCI: No PCI card found\n");
+		return(0);
+	}
+
+	cs->irq_flags |= IRQF_SHARED;
+
+	return (1);
+}
+
+#endif /* CONFIG_PCI */
+
+int __devinit
+setup_avm_pcipnp(struct IsdnCard *card)
+{
+	struct IsdnCardState *cs = card->cs;
+	char tmp[64];
+	int rc;
+
+	strcpy(tmp, avm_pci_rev);
+	printk(KERN_INFO "HiSax: AVM PCI driver Rev. %s\n", HiSax_getrev(tmp));
+
+	if (cs->typ != ISDN_CTYPE_FRITZPCI)
+		return (0);
+
+	if (card->para[1]) {
+		/* old manual method */
+		cs->hw.avm.cfg_reg = card->para[1];
+		cs->irq = card->para[0];
+		cs->subtyp = AVM_FRITZ_PNP;
+		goto ready;
+	}
+
+	rc = avm_pnp_setup(cs);
+	if (rc < 1)
+		return (0);
+	if (rc == 2)
+		goto ready;
+
+	rc = avm_pci_setup(cs);
+	if (rc < 1)
+		return (0);
+
+ready:
+	return avm_setup_rest(cs);
+}
