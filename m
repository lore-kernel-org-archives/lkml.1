Return-Path: <linux-kernel-owner+w=401wt.eu-S1762915AbXGPF1v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762915AbXGPF1v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 01:27:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751781AbXGPF1m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 01:27:42 -0400
Received: from havoc.gtf.org ([69.61.125.42]:60345 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751432AbXGPF1l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 01:27:41 -0400
Date: Mon, 16 Jul 2007 01:27:41 -0400
From: Jeff Garzik <jeff@garzik.org>
To: kkeil@suse.de, linux-kernel@vger.kernel.org,
       isdn4linux@listserv.isdn4linux.de
Cc: Andrew Morton <akpm@linux-foundation.org>, surya.prabhakar@wipro.com
Subject: [PATCH 3/7] HiSax bkm_a4t: split setup into smaller functions
Message-ID: <20070716052741.GC21782@havoc.gtf.org>
References: <20070715095716.GA20949@havoc.gtf.org> <20070716052647.GA21782@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070716052647.GA21782@havoc.gtf.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


commit f3068817e23a05dbeeaa7dced579c7b64045b7ea
Author: Jeff Garzik <jeff@garzik.org>
Date:   Sun Jul 15 19:58:24 2007 -0400

    [ISDN] HiSax bkm_a4t: split setup into two smaller functions
    
    No behavior changes, just code movement.  Prep for PCI hotplug API.
    
    Well, CONFIG_PCI useless ifdef was removed.
    
    Signed-off-by: Jeff Garzik <jeff@garzik.org>

 drivers/isdn/hisax/bkm_a4t.c |  108 +++++++++++++++++++++++++------------------
 1 file changed, 63 insertions(+), 45 deletions(-)

f3068817e23a05dbeeaa7dced579c7b64045b7ea
diff --git a/drivers/isdn/hisax/bkm_a4t.c b/drivers/isdn/hisax/bkm_a4t.c
index 871310d..3d1bdc8 100644
--- a/drivers/isdn/hisax/bkm_a4t.c
+++ b/drivers/isdn/hisax/bkm_a4t.c
@@ -255,54 +255,38 @@ BKM_card_msg(struct IsdnCardState *cs, int mt, void *arg)
 	return (0);
 }
 
-static struct pci_dev *dev_a4t __devinitdata = NULL;
+static int __devinit a4t_pci_probe(struct pci_dev *dev_a4t,
+				   struct IsdnCardState *cs,
+				   u_int *found,
+				   u_int *pci_memaddr)
+{
+	u16 sub_sys;
+	u16 sub_vendor;
+
+	sub_vendor = dev_a4t->subsystem_vendor;
+	sub_sys = dev_a4t->subsystem_device;
+	if ((sub_sys == PCI_DEVICE_ID_BERKOM_A4T) && (sub_vendor == PCI_VENDOR_ID_BERKOM)) {
+		if (pci_enable_device(dev_a4t))
+			return (0);	/* end loop & function */
+		*found = 1;
+		*pci_memaddr = pci_resource_start(dev_a4t, 0);
+		cs->irq = dev_a4t->irq;
+		return (1);		/* end loop */
+	}
 
-int __devinit
-setup_bkm_a4t(struct IsdnCard *card)
+	return (-1);			/* continue looping */
+}
+
+static int __devinit a4t_cs_init(struct IsdnCard *card,
+				 struct IsdnCardState *cs,
+				 u_int pci_memaddr)
 {
-	struct IsdnCardState *cs = card->cs;
-	char tmp[64];
-	u_int pci_memaddr = 0, found = 0;
 	I20_REGISTER_FILE *pI20_Regs;
-#ifdef CONFIG_PCI
-#endif
-
-	strcpy(tmp, bkm_a4t_revision);
-	printk(KERN_INFO "HiSax: T-Berkom driver Rev. %s\n", HiSax_getrev(tmp));
-	if (cs->typ == ISDN_CTYPE_BKM_A4T) {
-		cs->subtyp = BKM_A4T;
-	} else
-		return (0);
 
-#ifdef CONFIG_PCI
-	while ((dev_a4t = pci_find_device(PCI_VENDOR_ID_ZORAN,
-		PCI_DEVICE_ID_ZORAN_36120, dev_a4t))) {
-		u16 sub_sys;
-		u16 sub_vendor;
-
-		sub_vendor = dev_a4t->subsystem_vendor;
-		sub_sys = dev_a4t->subsystem_device;
-		if ((sub_sys == PCI_DEVICE_ID_BERKOM_A4T) && (sub_vendor == PCI_VENDOR_ID_BERKOM)) {
-			if (pci_enable_device(dev_a4t))
-				return(0);
-			found = 1;
-			pci_memaddr = pci_resource_start(dev_a4t, 0);
-			cs->irq = dev_a4t->irq;
-			break;
-		}
-	}
-	if (!found) {
-		printk(KERN_WARNING "HiSax: %s: Card not found\n", CardType[card->typ]);
-		return (0);
-	}
 	if (!cs->irq) {		/* IRQ range check ?? */
 		printk(KERN_WARNING "HiSax: %s: No IRQ\n", CardType[card->typ]);
 		return (0);
 	}
-	if (!pci_memaddr) {
-		printk(KERN_WARNING "HiSax: %s: No Memory base address\n", CardType[card->typ]);
-		return (0);
-	}
 	cs->hw.ax.base = (long) ioremap(pci_memaddr, 4096);
 	/* Check suspecious address */
 	pI20_Regs = (I20_REGISTER_FILE *) (cs->hw.ax.base);
@@ -317,11 +301,7 @@ setup_bkm_a4t(struct IsdnCard *card)
 	cs->hw.ax.jade_adr = cs->hw.ax.base + PO_OFFSET;
 	cs->hw.ax.isac_ale = GCS_1;
 	cs->hw.ax.jade_ale = GCS_3;
-#else
-	printk(KERN_WARNING "HiSax: %s: NO_PCI_BIOS\n", CardType[card->typ]);
-	printk(KERN_WARNING "HiSax: %s: unable to configure\n", CardType[card->typ]);
-	return (0);
-#endif				/* CONFIG_PCI */
+
 	printk(KERN_INFO "HiSax: %s: Card configured at 0x%lX IRQ %d\n",
 	       CardType[card->typ], cs->hw.ax.base, cs->irq);
 
@@ -339,5 +319,43 @@ setup_bkm_a4t(struct IsdnCard *card)
 	ISACVersion(cs, "Telekom A4T:");
 	/* Jade version */
 	JadeVersion(cs, "Telekom A4T:");
+
 	return (1);
 }
+
+static struct pci_dev *dev_a4t __devinitdata = NULL;
+
+int __devinit
+setup_bkm_a4t(struct IsdnCard *card)
+{
+	struct IsdnCardState *cs = card->cs;
+	char tmp[64];
+	u_int pci_memaddr = 0, found = 0;
+	int ret;
+
+	strcpy(tmp, bkm_a4t_revision);
+	printk(KERN_INFO "HiSax: T-Berkom driver Rev. %s\n", HiSax_getrev(tmp));
+	if (cs->typ == ISDN_CTYPE_BKM_A4T) {
+		cs->subtyp = BKM_A4T;
+	} else
+		return (0);
+
+	while ((dev_a4t = pci_find_device(PCI_VENDOR_ID_ZORAN,
+		PCI_DEVICE_ID_ZORAN_36120, dev_a4t))) {
+		ret = a4t_pci_probe(dev_a4t, cs, &found, &pci_memaddr);
+		if (!ret)
+			return (0);
+		if (ret > 0)
+			break;
+	}
+	if (!found) {
+		printk(KERN_WARNING "HiSax: %s: Card not found\n", CardType[card->typ]);
+		return (0);
+	}
+	if (!pci_memaddr) {
+		printk(KERN_WARNING "HiSax: %s: No Memory base address\n", CardType[card->typ]);
+		return (0);
+	}
+
+	return a4t_cs_init(card, cs, pci_memaddr);
+}
