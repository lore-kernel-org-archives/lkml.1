Return-Path: <linux-kernel-owner+w=401wt.eu-S1757423AbXHBMnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757423AbXHBMnU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 08:43:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755395AbXHBMnF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 08:43:05 -0400
Received: from havoc.gtf.org ([69.61.125.42]:43145 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755458AbXHBMnD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 08:43:03 -0400
Date: Thu, 2 Aug 2007 08:43:01 -0400
From: Jeff Garzik <jeff@garzik.org>
To: kkeil@suse.de, isdn4linux@listserv.isdn4linux.de,
       LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, surya.prabhakar@wipro.com
Subject: [PATCH 2/4] diva: split setup into three smaller functions
Message-ID: <20070802124301.GB29074@havoc.gtf.org>
References: <20070724074653.GA14987@havoc.gtf.org> <20070802124200.GA29074@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070802124200.GA29074@havoc.gtf.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This patch was committed to the 'isdn-pci' branch of
git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/misc-2.6.git

commit 5bc15a177ea173e02b8f43f67d524c781eb8f758
Author: Jeff Garzik <jeff@garzik.org>
Date:   Thu Aug 2 05:45:30 2007 -0400

    [ISDN] HiSax diva: split setup into three smaller functions

 drivers/isdn/hisax/diva.c |  512 ++++++++++++++++++++++++++--------------------
 1 file changed, 293 insertions(+), 219 deletions(-)

5bc15a177ea173e02b8f43f67d524c781eb8f758
diff --git a/drivers/isdn/hisax/diva.c b/drivers/isdn/hisax/diva.c
index 6eebeb4..6fc59ec 100644
--- a/drivers/isdn/hisax/diva.c
+++ b/drivers/isdn/hisax/diva.c
@@ -25,8 +25,6 @@
 #include <linux/pci.h>
 #include <linux/isapnp.h>
 
-extern const char *CardType[];
-
 static const char *Diva_revision = "$Revision: 1.33.2.6 $";
 
 #define byteout(addr,val) outb(val,addr)
@@ -906,225 +904,15 @@ Diva_card_msg(struct IsdnCardState *cs, int mt, void *arg)
 	return(0);
 }
 
-static struct pci_dev *dev_diva __devinitdata = NULL;
-static struct pci_dev *dev_diva_u __devinitdata = NULL;
-static struct pci_dev *dev_diva201 __devinitdata = NULL;
-static struct pci_dev *dev_diva202 __devinitdata = NULL;
-
-#ifdef __ISAPNP__
-static struct isapnp_device_id diva_ids[] __devinitdata = {
-	{ ISAPNP_VENDOR('G', 'D', 'I'), ISAPNP_FUNCTION(0x51),
-	  ISAPNP_VENDOR('G', 'D', 'I'), ISAPNP_FUNCTION(0x51), 
-	  (unsigned long) "Diva picola" },
-	{ ISAPNP_VENDOR('G', 'D', 'I'), ISAPNP_FUNCTION(0x51),
-	  ISAPNP_VENDOR('E', 'I', 'C'), ISAPNP_FUNCTION(0x51), 
-	  (unsigned long) "Diva picola" },
-	{ ISAPNP_VENDOR('G', 'D', 'I'), ISAPNP_FUNCTION(0x71),
-	  ISAPNP_VENDOR('G', 'D', 'I'), ISAPNP_FUNCTION(0x71), 
-	  (unsigned long) "Diva 2.0" },
-	{ ISAPNP_VENDOR('G', 'D', 'I'), ISAPNP_FUNCTION(0x71),
-	  ISAPNP_VENDOR('E', 'I', 'C'), ISAPNP_FUNCTION(0x71), 
-	  (unsigned long) "Diva 2.0" },
-	{ ISAPNP_VENDOR('G', 'D', 'I'), ISAPNP_FUNCTION(0xA1),
-	  ISAPNP_VENDOR('G', 'D', 'I'), ISAPNP_FUNCTION(0xA1), 
-	  (unsigned long) "Diva 2.01" },
-	{ ISAPNP_VENDOR('G', 'D', 'I'), ISAPNP_FUNCTION(0xA1),
-	  ISAPNP_VENDOR('E', 'I', 'C'), ISAPNP_FUNCTION(0xA1), 
-	  (unsigned long) "Diva 2.01" },
-	{ 0, }
-};
-
-static struct isapnp_device_id *ipid __devinitdata = &diva_ids[0];
-static struct pnp_card *pnp_c __devinitdata = NULL;
-#endif
-
-
-int __devinit
-setup_diva(struct IsdnCard *card)
+static int __devinit setup_diva_common(struct IsdnCardState *cs)
 {
-	int bytecnt = 8;
+	int bytecnt;
 	u_char val;
-	struct IsdnCardState *cs = card->cs;
-	char tmp[64];
 
-	strcpy(tmp, Diva_revision);
-	printk(KERN_INFO "HiSax: Eicon.Diehl Diva driver Rev. %s\n", HiSax_getrev(tmp));
-	if (cs->typ != ISDN_CTYPE_DIEHLDIVA)
-		return(0);
-	cs->hw.diva.status = 0;
-	if (card->para[1]) {
-		cs->hw.diva.ctrl_reg = 0;
-		cs->hw.diva.cfg_reg = card->para[1];
-		val = readreg(cs->hw.diva.cfg_reg + DIVA_IPAC_ADR,
-			cs->hw.diva.cfg_reg + DIVA_IPAC_DATA, IPAC_ID);
-		printk(KERN_INFO "Diva: IPAC version %x\n", val);
-		if ((val == 1) || (val==2)) {
-			cs->subtyp = DIVA_IPAC_ISA;
-			cs->hw.diva.ctrl = 0;
-			cs->hw.diva.isac = card->para[1] + DIVA_IPAC_DATA;
-			cs->hw.diva.hscx = card->para[1] + DIVA_IPAC_DATA;
-			cs->hw.diva.isac_adr = card->para[1] + DIVA_IPAC_ADR;
-			cs->hw.diva.hscx_adr = card->para[1] + DIVA_IPAC_ADR;
-			test_and_set_bit(HW_IPAC, &cs->HW_Flags);
-		} else {
-			cs->subtyp = DIVA_ISA;
-			cs->hw.diva.ctrl = card->para[1] + DIVA_ISA_CTRL;
-			cs->hw.diva.isac = card->para[1] + DIVA_ISA_ISAC_DATA;
-			cs->hw.diva.hscx = card->para[1] + DIVA_HSCX_DATA;
-			cs->hw.diva.isac_adr = card->para[1] + DIVA_ISA_ISAC_ADR;
-			cs->hw.diva.hscx_adr = card->para[1] + DIVA_HSCX_ADR;
-		}
-		cs->irq = card->para[0];
-	} else {
-#ifdef __ISAPNP__
-		if (isapnp_present()) {
-			struct pnp_dev *pnp_d;
-			while(ipid->card_vendor) {
-				if ((pnp_c = pnp_find_card(ipid->card_vendor,
-					ipid->card_device, pnp_c))) {
-					pnp_d = NULL;
-					if ((pnp_d = pnp_find_dev(pnp_c,
-						ipid->vendor, ipid->function, pnp_d))) {
-						int err;
-
-						printk(KERN_INFO "HiSax: %s detected\n",
-							(char *)ipid->driver_data);
-						pnp_disable_dev(pnp_d);
-						err = pnp_activate_dev(pnp_d);
-						if (err<0) {
-							printk(KERN_WARNING "%s: pnp_activate_dev ret(%d)\n",
-								__FUNCTION__, err);
-							return(0);
-						}
-						card->para[1] = pnp_port_start(pnp_d, 0);
-						card->para[0] = pnp_irq(pnp_d, 0);
-						if (!card->para[0] || !card->para[1]) {
-							printk(KERN_ERR "Diva PnP:some resources are missing %ld/%lx\n",
-								card->para[0], card->para[1]);
-							pnp_disable_dev(pnp_d); 
-							return(0);
-						}
-						cs->hw.diva.cfg_reg  = card->para[1];
-						cs->irq = card->para[0];
-						if (ipid->function == ISAPNP_FUNCTION(0xA1)) {
-							cs->subtyp = DIVA_IPAC_ISA;
-							cs->hw.diva.ctrl = 0;
-							cs->hw.diva.isac =
-								card->para[1] + DIVA_IPAC_DATA;
-							cs->hw.diva.hscx =
-								card->para[1] + DIVA_IPAC_DATA;
-							cs->hw.diva.isac_adr =
-								card->para[1] + DIVA_IPAC_ADR;
-							cs->hw.diva.hscx_adr =
-								card->para[1] + DIVA_IPAC_ADR;
-							test_and_set_bit(HW_IPAC, &cs->HW_Flags);
-						} else {
-							cs->subtyp = DIVA_ISA;
-							cs->hw.diva.ctrl =
-								card->para[1] + DIVA_ISA_CTRL;
-							cs->hw.diva.isac =
-								card->para[1] + DIVA_ISA_ISAC_DATA;
-							cs->hw.diva.hscx =
-								card->para[1] + DIVA_HSCX_DATA;
-							cs->hw.diva.isac_adr =
-								card->para[1] + DIVA_ISA_ISAC_ADR;
-							cs->hw.diva.hscx_adr =
-								card->para[1] + DIVA_HSCX_ADR;
-						}
-						goto ready;
-					} else {
-						printk(KERN_ERR "Diva PnP: PnP error card found, no device\n");
-						return(0);
-					}
-				}
-				ipid++;
-				pnp_c=NULL;
-			} 
-			if (!ipid->card_vendor) {
-				printk(KERN_INFO "Diva PnP: no ISAPnP card found\n");
-			}
-		}
-#endif
-#ifdef CONFIG_PCI
-		cs->subtyp = 0;
-		if ((dev_diva = pci_find_device(PCI_VENDOR_ID_EICON,
-			PCI_DEVICE_ID_EICON_DIVA20, dev_diva))) {
-			if (pci_enable_device(dev_diva))
-				return(0);
-			cs->subtyp = DIVA_PCI;
-			cs->irq = dev_diva->irq;
-			cs->hw.diva.cfg_reg = pci_resource_start(dev_diva, 2);
-		} else if ((dev_diva_u = pci_find_device(PCI_VENDOR_ID_EICON,
-			PCI_DEVICE_ID_EICON_DIVA20_U, dev_diva_u))) {
-			if (pci_enable_device(dev_diva_u))
-				return(0);
-			cs->subtyp = DIVA_PCI;
-			cs->irq = dev_diva_u->irq;
-			cs->hw.diva.cfg_reg = pci_resource_start(dev_diva_u, 2);
-		} else if ((dev_diva201 = pci_find_device(PCI_VENDOR_ID_EICON,
-			PCI_DEVICE_ID_EICON_DIVA201, dev_diva201))) {
-			if (pci_enable_device(dev_diva201))
-				return(0);
-			cs->subtyp = DIVA_IPAC_PCI;
-			cs->irq = dev_diva201->irq;
-			cs->hw.diva.pci_cfg =
-				(ulong) ioremap(pci_resource_start(dev_diva201, 0), 4096);
-			cs->hw.diva.cfg_reg =
-				(ulong) ioremap(pci_resource_start(dev_diva201, 1), 4096);
-		} else if ((dev_diva202 = pci_find_device(PCI_VENDOR_ID_EICON,
-			PCI_DEVICE_ID_EICON_DIVA202, dev_diva202))) {
-			if (pci_enable_device(dev_diva202))
-				return(0);
-			cs->subtyp = DIVA_IPACX_PCI;
-			cs->irq = dev_diva202->irq;
-			cs->hw.diva.pci_cfg =
-				(ulong) ioremap(pci_resource_start(dev_diva202, 0), 4096);
-			cs->hw.diva.cfg_reg =
-				(ulong) ioremap(pci_resource_start(dev_diva202, 1), 4096);
-		} else {
-			printk(KERN_WARNING "Diva: No PCI card found\n");
-			return(0);
-		}
-
-		if (!cs->irq) {
-			printk(KERN_WARNING "Diva: No IRQ for PCI card found\n");
-			iounmap_diva(cs);
-			return(0);
-		}
-
-		if (!cs->hw.diva.cfg_reg) {
-			printk(KERN_WARNING "Diva: No IO-Adr for PCI card found\n");
-			iounmap_diva(cs);
-			return(0);
-		}
-		cs->irq_flags |= IRQF_SHARED;
-#else
-		printk(KERN_WARNING "Diva: cfgreg 0 and NO_PCI_BIOS\n");
-		printk(KERN_WARNING "Diva: unable to config DIVA PCI\n");
-		return (0);
-#endif /* CONFIG_PCI */
-		if ((cs->subtyp == DIVA_IPAC_PCI) ||
-		    (cs->subtyp == DIVA_IPACX_PCI)   ) {
-			cs->hw.diva.ctrl = 0;
-			cs->hw.diva.isac = 0;
-			cs->hw.diva.hscx = 0;
-			cs->hw.diva.isac_adr = 0;
-			cs->hw.diva.hscx_adr = 0;
-			test_and_set_bit(HW_IPAC, &cs->HW_Flags);
-			bytecnt = 0;
-		} else {
-			cs->hw.diva.ctrl = cs->hw.diva.cfg_reg + DIVA_PCI_CTRL;
-			cs->hw.diva.isac = cs->hw.diva.cfg_reg + DIVA_PCI_ISAC_DATA;
-			cs->hw.diva.hscx = cs->hw.diva.cfg_reg + DIVA_HSCX_DATA;
-			cs->hw.diva.isac_adr = cs->hw.diva.cfg_reg + DIVA_PCI_ISAC_ADR;
-			cs->hw.diva.hscx_adr = cs->hw.diva.cfg_reg + DIVA_HSCX_ADR;
-			bytecnt = 32;
-		}
-	}
-
-#ifdef __ISAPNP__
-ready:
-#endif
+	if ((cs->subtyp == DIVA_ISA) || (cs->subtyp == DIVA_IPAC_ISA))
+		bytecnt = 8;
+	else
+		bytecnt = 32;
 
 	printk(KERN_INFO
 		"Diva: %s card configured at %#lx IRQ %d\n",
@@ -1145,7 +933,7 @@ ready:
 		if (!request_region(cs->hw.diva.cfg_reg, bytecnt, "diva isdn")) {
 			printk(KERN_WARNING
 			       "HiSax: %s config port %lx-%lx already in use\n",
-			       CardType[card->typ],
+			       "diva",
 			       cs->hw.diva.cfg_reg,
 			       cs->hw.diva.cfg_reg + bytecnt);
 			iounmap_diva(cs);
@@ -1206,3 +994,289 @@ ready:
 	}
 	return (1);
 }
+
+#ifdef CONFIG_ISA
+
+static int __devinit setup_diva_isa(struct IsdnCard *card)
+{
+	struct IsdnCardState *cs = card->cs;
+
+	if (!card->para[1])
+		return (-1);	/* card not found; continue search */
+
+	cs->hw.diva.ctrl_reg = 0;
+	cs->hw.diva.cfg_reg = card->para[1];
+	val = readreg(cs->hw.diva.cfg_reg + DIVA_IPAC_ADR,
+		cs->hw.diva.cfg_reg + DIVA_IPAC_DATA, IPAC_ID);
+	printk(KERN_INFO "Diva: IPAC version %x\n", val);
+	if ((val == 1) || (val==2)) {
+		cs->subtyp = DIVA_IPAC_ISA;
+		cs->hw.diva.ctrl = 0;
+		cs->hw.diva.isac = card->para[1] + DIVA_IPAC_DATA;
+		cs->hw.diva.hscx = card->para[1] + DIVA_IPAC_DATA;
+		cs->hw.diva.isac_adr = card->para[1] + DIVA_IPAC_ADR;
+		cs->hw.diva.hscx_adr = card->para[1] + DIVA_IPAC_ADR;
+		test_and_set_bit(HW_IPAC, &cs->HW_Flags);
+	} else {
+		cs->subtyp = DIVA_ISA;
+		cs->hw.diva.ctrl = card->para[1] + DIVA_ISA_CTRL;
+		cs->hw.diva.isac = card->para[1] + DIVA_ISA_ISAC_DATA;
+		cs->hw.diva.hscx = card->para[1] + DIVA_HSCX_DATA;
+		cs->hw.diva.isac_adr = card->para[1] + DIVA_ISA_ISAC_ADR;
+		cs->hw.diva.hscx_adr = card->para[1] + DIVA_HSCX_ADR;
+	}
+	cs->irq = card->para[0];
+
+	return (1);		/* card found */
+}
+
+#else	/* if !CONFIG_ISA */
+
+static int __devinit setup_diva_isa(struct IsdnCard *card)
+{
+	return (-1);	/* card not found; continue search */
+}
+
+#endif	/* CONFIG_ISA */
+
+#ifdef __ISAPNP__
+static struct isapnp_device_id diva_ids[] __devinitdata = {
+	{ ISAPNP_VENDOR('G', 'D', 'I'), ISAPNP_FUNCTION(0x51),
+	  ISAPNP_VENDOR('G', 'D', 'I'), ISAPNP_FUNCTION(0x51), 
+	  (unsigned long) "Diva picola" },
+	{ ISAPNP_VENDOR('G', 'D', 'I'), ISAPNP_FUNCTION(0x51),
+	  ISAPNP_VENDOR('E', 'I', 'C'), ISAPNP_FUNCTION(0x51), 
+	  (unsigned long) "Diva picola" },
+	{ ISAPNP_VENDOR('G', 'D', 'I'), ISAPNP_FUNCTION(0x71),
+	  ISAPNP_VENDOR('G', 'D', 'I'), ISAPNP_FUNCTION(0x71), 
+	  (unsigned long) "Diva 2.0" },
+	{ ISAPNP_VENDOR('G', 'D', 'I'), ISAPNP_FUNCTION(0x71),
+	  ISAPNP_VENDOR('E', 'I', 'C'), ISAPNP_FUNCTION(0x71), 
+	  (unsigned long) "Diva 2.0" },
+	{ ISAPNP_VENDOR('G', 'D', 'I'), ISAPNP_FUNCTION(0xA1),
+	  ISAPNP_VENDOR('G', 'D', 'I'), ISAPNP_FUNCTION(0xA1), 
+	  (unsigned long) "Diva 2.01" },
+	{ ISAPNP_VENDOR('G', 'D', 'I'), ISAPNP_FUNCTION(0xA1),
+	  ISAPNP_VENDOR('E', 'I', 'C'), ISAPNP_FUNCTION(0xA1), 
+	  (unsigned long) "Diva 2.01" },
+	{ 0, }
+};
+
+static struct isapnp_device_id *ipid __devinitdata = &diva_ids[0];
+static struct pnp_card *pnp_c __devinitdata = NULL;
+
+static int __devinit setup_diva_isapnp(struct IsdnCard *card)
+{
+	struct IsdnCardState *cs = card->cs;
+	struct pnp_dev *pnp_d;
+
+	if (!isapnp_present())
+		return (-1);	/* card not found; continue search */
+
+	while(ipid->card_vendor) {
+		if ((pnp_c = pnp_find_card(ipid->card_vendor,
+			ipid->card_device, pnp_c))) {
+			pnp_d = NULL;
+			if ((pnp_d = pnp_find_dev(pnp_c,
+				ipid->vendor, ipid->function, pnp_d))) {
+				int err;
+
+				printk(KERN_INFO "HiSax: %s detected\n",
+					(char *)ipid->driver_data);
+				pnp_disable_dev(pnp_d);
+				err = pnp_activate_dev(pnp_d);
+				if (err<0) {
+					printk(KERN_WARNING "%s: pnp_activate_dev ret(%d)\n",
+						__FUNCTION__, err);
+					return(0);
+				}
+				card->para[1] = pnp_port_start(pnp_d, 0);
+				card->para[0] = pnp_irq(pnp_d, 0);
+				if (!card->para[0] || !card->para[1]) {
+					printk(KERN_ERR "Diva PnP:some resources are missing %ld/%lx\n",
+						card->para[0], card->para[1]);
+					pnp_disable_dev(pnp_d); 
+					return(0);
+				}
+				cs->hw.diva.cfg_reg  = card->para[1];
+				cs->irq = card->para[0];
+				if (ipid->function == ISAPNP_FUNCTION(0xA1)) {
+					cs->subtyp = DIVA_IPAC_ISA;
+					cs->hw.diva.ctrl = 0;
+					cs->hw.diva.isac =
+						card->para[1] + DIVA_IPAC_DATA;
+					cs->hw.diva.hscx =
+						card->para[1] + DIVA_IPAC_DATA;
+					cs->hw.diva.isac_adr =
+						card->para[1] + DIVA_IPAC_ADR;
+					cs->hw.diva.hscx_adr =
+						card->para[1] + DIVA_IPAC_ADR;
+					test_and_set_bit(HW_IPAC, &cs->HW_Flags);
+				} else {
+					cs->subtyp = DIVA_ISA;
+					cs->hw.diva.ctrl =
+						card->para[1] + DIVA_ISA_CTRL;
+					cs->hw.diva.isac =
+						card->para[1] + DIVA_ISA_ISAC_DATA;
+					cs->hw.diva.hscx =
+						card->para[1] + DIVA_HSCX_DATA;
+					cs->hw.diva.isac_adr =
+						card->para[1] + DIVA_ISA_ISAC_ADR;
+					cs->hw.diva.hscx_adr =
+						card->para[1] + DIVA_HSCX_ADR;
+				}
+				return (1);		/* card found */
+			} else {
+				printk(KERN_ERR "Diva PnP: PnP error card found, no device\n");
+				return(0);
+			}
+		}
+		ipid++;
+		pnp_c=NULL;
+	} 
+
+	return (-1);	/* card not found; continue search */
+}
+
+#else	/* if !ISAPNP */
+
+static int __devinit setup_diva_isapnp(struct IsdnCard *card)
+{
+	return (-1);	/* card not found; continue search */
+}
+
+#endif	/* ISAPNP */
+
+#ifdef CONFIG_PCI
+static struct pci_dev *dev_diva __devinitdata = NULL;
+static struct pci_dev *dev_diva_u __devinitdata = NULL;
+static struct pci_dev *dev_diva201 __devinitdata = NULL;
+static struct pci_dev *dev_diva202 __devinitdata = NULL;
+
+static int __devinit setup_diva_pci(struct IsdnCard *card)
+{
+	struct IsdnCardState *cs = card->cs;
+
+	cs->subtyp = 0;
+	if ((dev_diva = pci_find_device(PCI_VENDOR_ID_EICON,
+		PCI_DEVICE_ID_EICON_DIVA20, dev_diva))) {
+		if (pci_enable_device(dev_diva))
+			return(0);
+		cs->subtyp = DIVA_PCI;
+		cs->irq = dev_diva->irq;
+		cs->hw.diva.cfg_reg = pci_resource_start(dev_diva, 2);
+	} else if ((dev_diva_u = pci_find_device(PCI_VENDOR_ID_EICON,
+		PCI_DEVICE_ID_EICON_DIVA20_U, dev_diva_u))) {
+		if (pci_enable_device(dev_diva_u))
+			return(0);
+		cs->subtyp = DIVA_PCI;
+		cs->irq = dev_diva_u->irq;
+		cs->hw.diva.cfg_reg = pci_resource_start(dev_diva_u, 2);
+	} else if ((dev_diva201 = pci_find_device(PCI_VENDOR_ID_EICON,
+		PCI_DEVICE_ID_EICON_DIVA201, dev_diva201))) {
+		if (pci_enable_device(dev_diva201))
+			return(0);
+		cs->subtyp = DIVA_IPAC_PCI;
+		cs->irq = dev_diva201->irq;
+		cs->hw.diva.pci_cfg =
+			(ulong) ioremap(pci_resource_start(dev_diva201, 0), 4096);
+		cs->hw.diva.cfg_reg =
+			(ulong) ioremap(pci_resource_start(dev_diva201, 1), 4096);
+	} else if ((dev_diva202 = pci_find_device(PCI_VENDOR_ID_EICON,
+		PCI_DEVICE_ID_EICON_DIVA202, dev_diva202))) {
+		if (pci_enable_device(dev_diva202))
+			return(0);
+		cs->subtyp = DIVA_IPACX_PCI;
+		cs->irq = dev_diva202->irq;
+		cs->hw.diva.pci_cfg =
+			(ulong) ioremap(pci_resource_start(dev_diva202, 0), 4096);
+		cs->hw.diva.cfg_reg =
+			(ulong) ioremap(pci_resource_start(dev_diva202, 1), 4096);
+	} else {
+		return (-1);	/* card not found; continue search */
+	}
+
+	if (!cs->irq) {
+		printk(KERN_WARNING "Diva: No IRQ for PCI card found\n");
+		iounmap_diva(cs);
+		return(0);
+	}
+
+	if (!cs->hw.diva.cfg_reg) {
+		printk(KERN_WARNING "Diva: No IO-Adr for PCI card found\n");
+		iounmap_diva(cs);
+		return(0);
+	}
+	cs->irq_flags |= IRQF_SHARED;
+
+	if ((cs->subtyp == DIVA_IPAC_PCI) ||
+	    (cs->subtyp == DIVA_IPACX_PCI)   ) {
+		cs->hw.diva.ctrl = 0;
+		cs->hw.diva.isac = 0;
+		cs->hw.diva.hscx = 0;
+		cs->hw.diva.isac_adr = 0;
+		cs->hw.diva.hscx_adr = 0;
+		test_and_set_bit(HW_IPAC, &cs->HW_Flags);
+	} else {
+		cs->hw.diva.ctrl = cs->hw.diva.cfg_reg + DIVA_PCI_CTRL;
+		cs->hw.diva.isac = cs->hw.diva.cfg_reg + DIVA_PCI_ISAC_DATA;
+		cs->hw.diva.hscx = cs->hw.diva.cfg_reg + DIVA_HSCX_DATA;
+		cs->hw.diva.isac_adr = cs->hw.diva.cfg_reg + DIVA_PCI_ISAC_ADR;
+		cs->hw.diva.hscx_adr = cs->hw.diva.cfg_reg + DIVA_HSCX_ADR;
+	}
+
+	return (1);		/* card found */
+}
+
+#else	/* if !CONFIG_PCI */
+
+static int __devinit setup_diva_pci(struct IsdnCard *card)
+{
+	return (-1);	/* card not found; continue search */
+}
+
+#endif	/* CONFIG_PCI */
+
+int __devinit
+setup_diva(struct IsdnCard *card)
+{
+	int rc, have_card = 0;
+	struct IsdnCardState *cs = card->cs;
+	char tmp[64];
+
+	strcpy(tmp, Diva_revision);
+	printk(KERN_INFO "HiSax: Eicon.Diehl Diva driver Rev. %s\n", HiSax_getrev(tmp));
+	if (cs->typ != ISDN_CTYPE_DIEHLDIVA)
+		return(0);
+	cs->hw.diva.status = 0;
+
+	rc = setup_diva_isa(card);
+	if (!rc)
+		return rc;
+	if (rc > 0) {
+		have_card = 1;
+		goto ready;
+	}
+
+	rc = setup_diva_isapnp(card);
+	if (!rc)
+		return rc;
+	if (rc > 0) {
+		have_card = 1;
+		goto ready;
+	}
+
+	rc = setup_diva_pci(card);
+	if (!rc)
+		return rc;
+	if (rc > 0)
+		have_card = 1;
+
+ready:
+	if (!have_card) {
+		printk(KERN_WARNING "Diva: No ISA, ISAPNP or PCI card found\n");
+		return(0);
+	}
+
+	return setup_diva_common(card->cs);
+}
