Return-Path: <linux-kernel-owner+w=401wt.eu-S1759654AbXJLT2C@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759654AbXJLT2C (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 15:28:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756334AbXJLT1t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 15:27:49 -0400
Received: from havoc.gtf.org ([69.61.125.42]:39862 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756244AbXJLT1q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 15:27:46 -0400
Date: Fri, 12 Oct 2007 15:27:45 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, kkeil@suse.de,
       isdn4linux@listserv.isdn4linux.de, Greg KH <greg@kroah.com>
Subject: [git patches] ISDN: prep for PCI hotplug API conversion
Message-ID: <20071012192745.GA766@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Tested and ack'd by Karsten (ISDN maintainer).

Just code movement.  The actual PCI hotplug conversions are done for all
but one ISDN driver, but all those conversions are untested.

On the road towards killing pci_find_device...

Please pull from 'isdn-cleanups' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/misc-2.6.git isdn-cleanups

to receive the following updates:

 drivers/isdn/hisax/avm_pci.c   |  224 +++++++++++-------
 drivers/isdn/hisax/bkm_a8.c    |    8 -
 drivers/isdn/hisax/diva.c      |  513 +++++++++++++++++++++++-----------------
 drivers/isdn/hisax/elsa.c      |  494 ++++++++++++++++++++++-----------------
 drivers/isdn/hisax/sedlbauer.c |  276 ++++++++++++---------
 drivers/isdn/hisax/telespci.c  |    8 +-
 drivers/isdn/hisax/w6692.c     |    7 +-
 7 files changed, 868 insertions(+), 662 deletions(-)

Jeff Garzik (5):
      [ISDN] Remove CONFIG_PCI ifdefs from 100% PCI source code
      [ISDN] HiSax avm_pci: split setup into three smaller functions
      [ISDN] HiSax elsa: split huge setup function into four smaller functions
      [ISDN] HiSax sedlbauer: move ISAPNP and PCI code into functions of their own
      [ISDN] HiSax diva: split setup into three smaller functions

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
diff --git a/drivers/isdn/hisax/bkm_a8.c b/drivers/isdn/hisax/bkm_a8.c
index 6339bb4..99ef3b4 100644
--- a/drivers/isdn/hisax/bkm_a8.c
+++ b/drivers/isdn/hisax/bkm_a8.c
@@ -20,8 +20,6 @@
 #include <linux/pci.h>
 #include "bkm_ax.h"
 
-#ifdef CONFIG_PCI
-
 #define	ATTEMPT_PCI_REMAPPING	/* Required for PLX rev 1 */
 
 extern const char *CardType[];
@@ -279,12 +277,9 @@ static u_char pci_bus __devinitdata = 0;
 static u_char pci_device_fn __devinitdata = 0;
 static u_char pci_irq __devinitdata = 0;
 
-#endif /* CONFIG_PCI */
-
 int __devinit
 setup_sct_quadro(struct IsdnCard *card)
 {
-#ifdef CONFIG_PCI
 	struct IsdnCardState *cs = card->cs;
 	char tmp[64];
 	u_int found = 0;
@@ -442,7 +437,4 @@ setup_sct_quadro(struct IsdnCard *card)
 		sct_quadro_subtypes[cs->subtyp],
 		readreg(cs->hw.ax.base, cs->hw.ax.data_adr, IPAC_ID));
 	return (1);
-#else
-	printk(KERN_ERR "HiSax: bkm_a8 only supported on PCI Systems\n");
-#endif /* CONFIG_PCI */
 }
diff --git a/drivers/isdn/hisax/diva.c b/drivers/isdn/hisax/diva.c
index 6eebeb4..8267450 100644
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
-
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
@@ -1206,3 +994,290 @@ ready:
 	}
 	return (1);
 }
+
+#ifdef CONFIG_ISA
+
+static int __devinit setup_diva_isa(struct IsdnCard *card)
+{
+	struct IsdnCardState *cs = card->cs;
+	u_char val;
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
diff --git a/drivers/isdn/hisax/elsa.c b/drivers/isdn/hisax/elsa.c
index fab3e4e..0c1351b 100644
--- a/drivers/isdn/hisax/elsa.c
+++ b/drivers/isdn/hisax/elsa.c
@@ -30,8 +30,6 @@
 #include <linux/serial.h>
 #include <linux/serial_reg.h>
 
-extern const char *CardType[];
-
 static const char *Elsa_revision = "$Revision: 2.32.2.4 $";
 static const char *Elsa_Types[] =
 {"None", "PC", "PCC-8", "PCC-16", "PCF", "PCF-Pro",
@@ -832,8 +830,75 @@ probe_elsa(struct IsdnCardState *cs)
 	return (CARD_portlist[i]);
 }
 
-static 	struct pci_dev *dev_qs1000 __devinitdata = NULL;
-static 	struct pci_dev *dev_qs3000 __devinitdata = NULL;
+static int __devinit
+setup_elsa_isa(struct IsdnCard *card)
+{
+	struct IsdnCardState *cs = card->cs;
+	u_char val;
+
+	cs->hw.elsa.base = card->para[0];
+	printk(KERN_INFO "Elsa: Microlink IO probing\n");
+	if (cs->hw.elsa.base) {
+		if (!(cs->subtyp = probe_elsa_adr(cs->hw.elsa.base,
+						  cs->typ))) {
+			printk(KERN_WARNING
+			       "Elsa: no Elsa Microlink at %#lx\n",
+			       cs->hw.elsa.base);
+			return (0);
+		}
+	} else
+		cs->hw.elsa.base = probe_elsa(cs);
+
+	if (!cs->hw.elsa.base) {
+		printk(KERN_WARNING
+		       "No Elsa Microlink found\n");
+		return (0);
+	}
+
+	cs->hw.elsa.cfg = cs->hw.elsa.base + ELSA_CONFIG;
+	cs->hw.elsa.ctrl = cs->hw.elsa.base + ELSA_CONTROL;
+	cs->hw.elsa.ale = cs->hw.elsa.base + ELSA_ALE;
+	cs->hw.elsa.isac = cs->hw.elsa.base + ELSA_ISAC;
+	cs->hw.elsa.itac = cs->hw.elsa.base + ELSA_ITAC;
+	cs->hw.elsa.hscx = cs->hw.elsa.base + ELSA_HSCX;
+	cs->hw.elsa.trig = cs->hw.elsa.base + ELSA_TRIG_IRQ;
+	cs->hw.elsa.timer = cs->hw.elsa.base + ELSA_START_TIMER;
+	val = bytein(cs->hw.elsa.cfg);
+	if (cs->subtyp == ELSA_PC) {
+		const u_char CARD_IrqTab[8] =
+		{7, 3, 5, 9, 0, 0, 0, 0};
+		cs->irq = CARD_IrqTab[(val & ELSA_IRQ_IDX_PC) >> 2];
+	} else if (cs->subtyp == ELSA_PCC8) {
+		const u_char CARD_IrqTab[8] =
+		{7, 3, 5, 9, 0, 0, 0, 0};
+		cs->irq = CARD_IrqTab[(val & ELSA_IRQ_IDX_PCC8) >> 4];
+	} else {
+		const u_char CARD_IrqTab[8] =
+		{15, 10, 15, 3, 11, 5, 11, 9};
+		cs->irq = CARD_IrqTab[(val & ELSA_IRQ_IDX) >> 3];
+	}
+	val = bytein(cs->hw.elsa.ale) & ELSA_HW_RELEASE;
+	if (val < 3)
+		val |= 8;
+	val += 'A' - 3;
+	if (val == 'B' || val == 'C')
+		val ^= 1;
+	if ((cs->subtyp == ELSA_PCFPRO) && (val = 'G'))
+		val = 'C';
+	printk(KERN_INFO
+	       "Elsa: %s found at %#lx Rev.:%c IRQ %d\n",
+	       Elsa_Types[cs->subtyp],
+	       cs->hw.elsa.base,
+	       val, cs->irq);
+	val = bytein(cs->hw.elsa.ale) & ELSA_S0_POWER_BAD;
+	if (val) {
+		printk(KERN_WARNING
+		   "Elsa: Microlink S0 bus power bad\n");
+		cs->hw.elsa.status |= ELSA_BAD_PWR;
+	}
+
+	return (1);
+}
 
 #ifdef __ISAPNP__
 static struct isapnp_device_id elsa_ids[] __devinitdata = {
@@ -848,233 +913,194 @@ static struct isapnp_device_id elsa_ids[] __devinitdata = {
 
 static struct isapnp_device_id *ipid __devinitdata = &elsa_ids[0];
 static struct pnp_card *pnp_c __devinitdata = NULL;
-#endif
+#endif	/* __ISAPNP__ */
 
-int __devinit
-setup_elsa(struct IsdnCard *card)
+static int __devinit
+setup_elsa_isapnp(struct IsdnCard *card)
 {
-	int bytecnt;
-	u_char val;
 	struct IsdnCardState *cs = card->cs;
-	char tmp[64];
 
-	strcpy(tmp, Elsa_revision);
-	printk(KERN_INFO "HiSax: Elsa driver Rev. %s\n", HiSax_getrev(tmp));
-	cs->hw.elsa.ctrl_reg = 0;
-	cs->hw.elsa.status = 0;
-	cs->hw.elsa.MFlag = 0;
-	cs->subtyp = 0;
-	if (cs->typ == ISDN_CTYPE_ELSA) {
-		cs->hw.elsa.base = card->para[0];
-		printk(KERN_INFO "Elsa: Microlink IO probing\n");
-		if (cs->hw.elsa.base) {
-			if (!(cs->subtyp = probe_elsa_adr(cs->hw.elsa.base,
-							  cs->typ))) {
-				printk(KERN_WARNING
-				       "Elsa: no Elsa Microlink at %#lx\n",
-				       cs->hw.elsa.base);
-				return (0);
-			}
-		} else
-			cs->hw.elsa.base = probe_elsa(cs);
-		if (cs->hw.elsa.base) {
-			cs->hw.elsa.cfg = cs->hw.elsa.base + ELSA_CONFIG;
-			cs->hw.elsa.ctrl = cs->hw.elsa.base + ELSA_CONTROL;
-			cs->hw.elsa.ale = cs->hw.elsa.base + ELSA_ALE;
-			cs->hw.elsa.isac = cs->hw.elsa.base + ELSA_ISAC;
-			cs->hw.elsa.itac = cs->hw.elsa.base + ELSA_ITAC;
-			cs->hw.elsa.hscx = cs->hw.elsa.base + ELSA_HSCX;
-			cs->hw.elsa.trig = cs->hw.elsa.base + ELSA_TRIG_IRQ;
-			cs->hw.elsa.timer = cs->hw.elsa.base + ELSA_START_TIMER;
-			val = bytein(cs->hw.elsa.cfg);
-			if (cs->subtyp == ELSA_PC) {
-				const u_char CARD_IrqTab[8] =
-				{7, 3, 5, 9, 0, 0, 0, 0};
-				cs->irq = CARD_IrqTab[(val & ELSA_IRQ_IDX_PC) >> 2];
-			} else if (cs->subtyp == ELSA_PCC8) {
-				const u_char CARD_IrqTab[8] =
-				{7, 3, 5, 9, 0, 0, 0, 0};
-				cs->irq = CARD_IrqTab[(val & ELSA_IRQ_IDX_PCC8) >> 4];
-			} else {
-				const u_char CARD_IrqTab[8] =
-				{15, 10, 15, 3, 11, 5, 11, 9};
-				cs->irq = CARD_IrqTab[(val & ELSA_IRQ_IDX) >> 3];
-			}
-			val = bytein(cs->hw.elsa.ale) & ELSA_HW_RELEASE;
-			if (val < 3)
-				val |= 8;
-			val += 'A' - 3;
-			if (val == 'B' || val == 'C')
-				val ^= 1;
-			if ((cs->subtyp == ELSA_PCFPRO) && (val = 'G'))
-				val = 'C';
-			printk(KERN_INFO
-			       "Elsa: %s found at %#lx Rev.:%c IRQ %d\n",
-			       Elsa_Types[cs->subtyp],
-			       cs->hw.elsa.base,
-			       val, cs->irq);
-			val = bytein(cs->hw.elsa.ale) & ELSA_S0_POWER_BAD;
-			if (val) {
-				printk(KERN_WARNING
-				   "Elsa: Microlink S0 bus power bad\n");
-				cs->hw.elsa.status |= ELSA_BAD_PWR;
-			}
-		} else {
-			printk(KERN_WARNING
-			       "No Elsa Microlink found\n");
-			return (0);
-		}
-	} else if (cs->typ == ISDN_CTYPE_ELSA_PNP) {
 #ifdef __ISAPNP__
-		if (!card->para[1] && isapnp_present()) {
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
+	if (!card->para[1] && isapnp_present()) {
+		struct pnp_dev *pnp_d;
+		while(ipid->card_vendor) {
+			if ((pnp_c = pnp_find_card(ipid->card_vendor,
+				ipid->card_device, pnp_c))) {
+				pnp_d = NULL;
+				if ((pnp_d = pnp_find_dev(pnp_c,
+					ipid->vendor, ipid->function, pnp_d))) {
+					int err;
+
+					printk(KERN_INFO "HiSax: %s detected\n",
+						(char *)ipid->driver_data);
+					pnp_disable_dev(pnp_d);
+					err = pnp_activate_dev(pnp_d);
+					if (err<0) {
+						printk(KERN_WARNING "%s: pnp_activate_dev ret(%d)\n",
+							__FUNCTION__, err);
+						return(0);
+					}
+					card->para[1] = pnp_port_start(pnp_d, 0);
+					card->para[0] = pnp_irq(pnp_d, 0);
+
+					if (!card->para[0] || !card->para[1]) {
+						printk(KERN_ERR "Elsa PnP:some resources are missing %ld/%lx\n",
+							card->para[0], card->para[1]);
 						pnp_disable_dev(pnp_d);
-						err = pnp_activate_dev(pnp_d);
-						if (err<0) {
-							printk(KERN_WARNING "%s: pnp_activate_dev ret(%d)\n",
-								__FUNCTION__, err);
-							return(0);
-						}
-						card->para[1] = pnp_port_start(pnp_d, 0);
-						card->para[0] = pnp_irq(pnp_d, 0);
-
-						if (!card->para[0] || !card->para[1]) {
-							printk(KERN_ERR "Elsa PnP:some resources are missing %ld/%lx\n",
-								card->para[0], card->para[1]);
-							pnp_disable_dev(pnp_d);
-							return(0);
-						}
-						if (ipid->function == ISAPNP_FUNCTION(0x133))
-							cs->subtyp = ELSA_QS1000;
-						else
-							cs->subtyp = ELSA_QS3000;
-						break;
-					} else {
-						printk(KERN_ERR "Elsa PnP: PnP error card found, no device\n");
 						return(0);
 					}
+					if (ipid->function == ISAPNP_FUNCTION(0x133))
+						cs->subtyp = ELSA_QS1000;
+					else
+						cs->subtyp = ELSA_QS3000;
+					break;
+				} else {
+					printk(KERN_ERR "Elsa PnP: PnP error card found, no device\n");
+					return(0);
 				}
-				ipid++;
-				pnp_c=NULL;
-			} 
-			if (!ipid->card_vendor) {
-				printk(KERN_INFO "Elsa PnP: no ISAPnP card found\n");
-				return(0);
 			}
+			ipid++;
+			pnp_c=NULL;
+		} 
+		if (!ipid->card_vendor) {
+			printk(KERN_INFO "Elsa PnP: no ISAPnP card found\n");
+			return(0);
 		}
-#endif
-		if (card->para[1] && card->para[0]) { 
-			cs->hw.elsa.base = card->para[1];
-			cs->irq = card->para[0];
-			if (!cs->subtyp)
-				cs->subtyp = ELSA_QS1000;
-		} else {
-			printk(KERN_ERR "Elsa PnP: no parameter\n");
-		}
-		cs->hw.elsa.cfg = cs->hw.elsa.base + ELSA_CONFIG;
-		cs->hw.elsa.ale = cs->hw.elsa.base + ELSA_ALE;
-		cs->hw.elsa.isac = cs->hw.elsa.base + ELSA_ISAC;
-		cs->hw.elsa.hscx = cs->hw.elsa.base + ELSA_HSCX;
-		cs->hw.elsa.trig = cs->hw.elsa.base + ELSA_TRIG_IRQ;
-		cs->hw.elsa.timer = cs->hw.elsa.base + ELSA_START_TIMER;
-		cs->hw.elsa.ctrl = cs->hw.elsa.base + ELSA_CONTROL;
-		printk(KERN_INFO
-		       "Elsa: %s defined at %#lx IRQ %d\n",
-		       Elsa_Types[cs->subtyp],
-		       cs->hw.elsa.base,
-		       cs->irq);
-	} else if (cs->typ == ISDN_CTYPE_ELSA_PCMCIA) {
+	}
+#endif	/* __ISAPNP__ */
+
+	if (card->para[1] && card->para[0]) { 
 		cs->hw.elsa.base = card->para[1];
 		cs->irq = card->para[0];
-		val = readreg(cs->hw.elsa.base + 0, cs->hw.elsa.base + 2, IPAC_ID);
-		if ((val == 1) || (val == 2)) { /* IPAC version 1.1/1.2 */
-			cs->subtyp = ELSA_PCMCIA_IPAC;
-			cs->hw.elsa.ale = cs->hw.elsa.base + 0;
-			cs->hw.elsa.isac = cs->hw.elsa.base + 2;
-			cs->hw.elsa.hscx = cs->hw.elsa.base + 2;
-			test_and_set_bit(HW_IPAC, &cs->HW_Flags);
-		} else {
-			cs->subtyp = ELSA_PCMCIA;
-			cs->hw.elsa.ale = cs->hw.elsa.base + ELSA_ALE_PCM;
-			cs->hw.elsa.isac = cs->hw.elsa.base + ELSA_ISAC_PCM;
-			cs->hw.elsa.hscx = cs->hw.elsa.base + ELSA_HSCX;
-		}
-		cs->hw.elsa.timer = 0;
-		cs->hw.elsa.trig = 0;
-		cs->hw.elsa.ctrl = 0;
-		cs->irq_flags |= IRQF_SHARED;
-		printk(KERN_INFO
-		       "Elsa: %s defined at %#lx IRQ %d\n",
-		       Elsa_Types[cs->subtyp],
-		       cs->hw.elsa.base,
-		       cs->irq);
-	} else if (cs->typ == ISDN_CTYPE_ELSA_PCI) {
+		if (!cs->subtyp)
+			cs->subtyp = ELSA_QS1000;
+	} else {
+		printk(KERN_ERR "Elsa PnP: no parameter\n");
+	}
+	cs->hw.elsa.cfg = cs->hw.elsa.base + ELSA_CONFIG;
+	cs->hw.elsa.ale = cs->hw.elsa.base + ELSA_ALE;
+	cs->hw.elsa.isac = cs->hw.elsa.base + ELSA_ISAC;
+	cs->hw.elsa.hscx = cs->hw.elsa.base + ELSA_HSCX;
+	cs->hw.elsa.trig = cs->hw.elsa.base + ELSA_TRIG_IRQ;
+	cs->hw.elsa.timer = cs->hw.elsa.base + ELSA_START_TIMER;
+	cs->hw.elsa.ctrl = cs->hw.elsa.base + ELSA_CONTROL;
+	printk(KERN_INFO
+	       "Elsa: %s defined at %#lx IRQ %d\n",
+	       Elsa_Types[cs->subtyp],
+	       cs->hw.elsa.base,
+	       cs->irq);
+
+	return (1);
+}
+
+static void __devinit
+setup_elsa_pcmcia(struct IsdnCard *card)
+{
+	struct IsdnCardState *cs = card->cs;
+	u_char val;
+
+	cs->hw.elsa.base = card->para[1];
+	cs->irq = card->para[0];
+	val = readreg(cs->hw.elsa.base + 0, cs->hw.elsa.base + 2, IPAC_ID);
+	if ((val == 1) || (val == 2)) { /* IPAC version 1.1/1.2 */
+		cs->subtyp = ELSA_PCMCIA_IPAC;
+		cs->hw.elsa.ale = cs->hw.elsa.base + 0;
+		cs->hw.elsa.isac = cs->hw.elsa.base + 2;
+		cs->hw.elsa.hscx = cs->hw.elsa.base + 2;
+		test_and_set_bit(HW_IPAC, &cs->HW_Flags);
+	} else {
+		cs->subtyp = ELSA_PCMCIA;
+		cs->hw.elsa.ale = cs->hw.elsa.base + ELSA_ALE_PCM;
+		cs->hw.elsa.isac = cs->hw.elsa.base + ELSA_ISAC_PCM;
+		cs->hw.elsa.hscx = cs->hw.elsa.base + ELSA_HSCX;
+	}
+	cs->hw.elsa.timer = 0;
+	cs->hw.elsa.trig = 0;
+	cs->hw.elsa.ctrl = 0;
+	cs->irq_flags |= IRQF_SHARED;
+	printk(KERN_INFO
+	       "Elsa: %s defined at %#lx IRQ %d\n",
+	       Elsa_Types[cs->subtyp],
+	       cs->hw.elsa.base,
+	       cs->irq);
+}
+
 #ifdef CONFIG_PCI
-		cs->subtyp = 0;
-		if ((dev_qs1000 = pci_find_device(PCI_VENDOR_ID_ELSA,
-			PCI_DEVICE_ID_ELSA_MICROLINK, dev_qs1000))) {
-			if (pci_enable_device(dev_qs1000))
-				return(0);
-			cs->subtyp = ELSA_QS1000PCI;
-			cs->irq = dev_qs1000->irq;
-			cs->hw.elsa.cfg = pci_resource_start(dev_qs1000, 1);
-			cs->hw.elsa.base = pci_resource_start(dev_qs1000, 3);
-		} else if ((dev_qs3000 = pci_find_device(PCI_VENDOR_ID_ELSA,
-			PCI_DEVICE_ID_ELSA_QS3000, dev_qs3000))) {
-			if (pci_enable_device(dev_qs3000))
-				return(0);
-			cs->subtyp = ELSA_QS3000PCI;
-			cs->irq = dev_qs3000->irq;
-			cs->hw.elsa.cfg = pci_resource_start(dev_qs3000, 1);
-			cs->hw.elsa.base = pci_resource_start(dev_qs3000, 3);
-		} else {
-			printk(KERN_WARNING "Elsa: No PCI card found\n");
+static 	struct pci_dev *dev_qs1000 __devinitdata = NULL;
+static 	struct pci_dev *dev_qs3000 __devinitdata = NULL;
+
+static int __devinit
+setup_elsa_pci(struct IsdnCard *card)
+{
+	struct IsdnCardState *cs = card->cs;
+
+	cs->subtyp = 0;
+	if ((dev_qs1000 = pci_find_device(PCI_VENDOR_ID_ELSA,
+		PCI_DEVICE_ID_ELSA_MICROLINK, dev_qs1000))) {
+		if (pci_enable_device(dev_qs1000))
 			return(0);
-		}
-		if (!cs->irq) {
-			printk(KERN_WARNING "Elsa: No IRQ for PCI card found\n");
+		cs->subtyp = ELSA_QS1000PCI;
+		cs->irq = dev_qs1000->irq;
+		cs->hw.elsa.cfg = pci_resource_start(dev_qs1000, 1);
+		cs->hw.elsa.base = pci_resource_start(dev_qs1000, 3);
+	} else if ((dev_qs3000 = pci_find_device(PCI_VENDOR_ID_ELSA,
+		PCI_DEVICE_ID_ELSA_QS3000, dev_qs3000))) {
+		if (pci_enable_device(dev_qs3000))
 			return(0);
-		}
+		cs->subtyp = ELSA_QS3000PCI;
+		cs->irq = dev_qs3000->irq;
+		cs->hw.elsa.cfg = pci_resource_start(dev_qs3000, 1);
+		cs->hw.elsa.base = pci_resource_start(dev_qs3000, 3);
+	} else {
+		printk(KERN_WARNING "Elsa: No PCI card found\n");
+		return(0);
+	}
+	if (!cs->irq) {
+		printk(KERN_WARNING "Elsa: No IRQ for PCI card found\n");
+		return(0);
+	}
+
+	if (!(cs->hw.elsa.base && cs->hw.elsa.cfg)) {
+		printk(KERN_WARNING "Elsa: No IO-Adr for PCI card found\n");
+		return(0);
+	}
+	if ((cs->hw.elsa.cfg & 0xff) || (cs->hw.elsa.base & 0xf)) {
+		printk(KERN_WARNING "Elsa: You may have a wrong PCI bios\n");
+		printk(KERN_WARNING "Elsa: If your system hangs now, read\n");
+		printk(KERN_WARNING "Elsa: Documentation/isdn/README.HiSax\n");
+	}
+	cs->hw.elsa.ale  = cs->hw.elsa.base;
+	cs->hw.elsa.isac = cs->hw.elsa.base +1;
+	cs->hw.elsa.hscx = cs->hw.elsa.base +1; 
+	test_and_set_bit(HW_IPAC, &cs->HW_Flags);
+	cs->hw.elsa.timer = 0;
+	cs->hw.elsa.trig  = 0;
+	cs->irq_flags |= IRQF_SHARED;
+	printk(KERN_INFO
+	       "Elsa: %s defined at %#lx/0x%x IRQ %d\n",
+	       Elsa_Types[cs->subtyp],
+	       cs->hw.elsa.base,
+	       cs->hw.elsa.cfg,
+	       cs->irq);
+
+	return (1);
+}
 
-		if (!(cs->hw.elsa.base && cs->hw.elsa.cfg)) {
-			printk(KERN_WARNING "Elsa: No IO-Adr for PCI card found\n");
-			return(0);
-		}
-		if ((cs->hw.elsa.cfg & 0xff) || (cs->hw.elsa.base & 0xf)) {
-			printk(KERN_WARNING "Elsa: You may have a wrong PCI bios\n");
-			printk(KERN_WARNING "Elsa: If your system hangs now, read\n");
-			printk(KERN_WARNING "Elsa: Documentation/isdn/README.HiSax\n");
-		}
-		cs->hw.elsa.ale  = cs->hw.elsa.base;
-		cs->hw.elsa.isac = cs->hw.elsa.base +1;
-		cs->hw.elsa.hscx = cs->hw.elsa.base +1; 
-		test_and_set_bit(HW_IPAC, &cs->HW_Flags);
-		cs->hw.elsa.timer = 0;
-		cs->hw.elsa.trig  = 0;
-		cs->irq_flags |= IRQF_SHARED;
-		printk(KERN_INFO
-		       "Elsa: %s defined at %#lx/0x%x IRQ %d\n",
-		       Elsa_Types[cs->subtyp],
-		       cs->hw.elsa.base,
-		       cs->hw.elsa.cfg,
-		       cs->irq);
 #else
-		printk(KERN_WARNING "Elsa: Elsa PCI and NO_PCI_BIOS\n");
-		printk(KERN_WARNING "Elsa: unable to config Elsa PCI\n");
-		return (0);
+
+static void __devinit
+setup_elsa_pci(struct IsdnCard *card)
+{
+	return (1);
+}
 #endif /* CONFIG_PCI */
-	} else 
-		return (0);
+
+static int __devinit
+setup_elsa_common(struct IsdnCard *card)
+{
+	struct IsdnCardState *cs = card->cs;
+	u_char val;
+	int bytecnt;
 
 	switch (cs->subtyp) {
 		case ELSA_PC:
@@ -1104,8 +1130,7 @@ setup_elsa(struct IsdnCard *card)
 	   here, it would fail. */
 	if (cs->typ != ISDN_CTYPE_ELSA_PCMCIA && !request_region(cs->hw.elsa.base, bytecnt, "elsa isdn")) {
 		printk(KERN_WARNING
-		       "HiSax: %s config port %#lx-%#lx already in use\n",
-		       CardType[card->typ],
+		       "HiSax: ELSA config port %#lx-%#lx already in use\n",
 		       cs->hw.elsa.base,
 		       cs->hw.elsa.base + bytecnt);
 		return (0);
@@ -1113,8 +1138,7 @@ setup_elsa(struct IsdnCard *card)
 	if ((cs->subtyp == ELSA_QS1000PCI) || (cs->subtyp == ELSA_QS3000PCI)) {
 		if (!request_region(cs->hw.elsa.cfg, 0x80, "elsa isdn pci")) {
 			printk(KERN_WARNING
-			       "HiSax: %s pci port %x-%x already in use\n",
-				CardType[card->typ],
+			       "HiSax: ELSA pci port %x-%x already in use\n",
 				cs->hw.elsa.cfg,
 				cs->hw.elsa.cfg + 0x80);
 			release_region(cs->hw.elsa.base, bytecnt);
@@ -1186,3 +1210,41 @@ setup_elsa(struct IsdnCard *card)
 	}
 	return (1);
 }
+
+int __devinit
+setup_elsa(struct IsdnCard *card)
+{
+	int rc;
+	struct IsdnCardState *cs = card->cs;
+	char tmp[64];
+
+	strcpy(tmp, Elsa_revision);
+	printk(KERN_INFO "HiSax: Elsa driver Rev. %s\n", HiSax_getrev(tmp));
+	cs->hw.elsa.ctrl_reg = 0;
+	cs->hw.elsa.status = 0;
+	cs->hw.elsa.MFlag = 0;
+	cs->subtyp = 0;
+
+	if (cs->typ == ISDN_CTYPE_ELSA) {
+		rc = setup_elsa_isa(card);
+		if (!rc)
+			return (0);
+
+	} else if (cs->typ == ISDN_CTYPE_ELSA_PNP) {
+		rc = setup_elsa_isapnp(card);
+		if (!rc)
+			return (0);
+
+	} else if (cs->typ == ISDN_CTYPE_ELSA_PCMCIA)
+		setup_elsa_pcmcia(card);
+
+	else if (cs->typ == ISDN_CTYPE_ELSA_PCI) {
+		rc = setup_elsa_pci(card);
+		if (!rc)
+			return (0);
+
+	} else 
+		return (0);
+
+	return setup_elsa_common(card);
+}
diff --git a/drivers/isdn/hisax/sedlbauer.c b/drivers/isdn/hisax/sedlbauer.c
index ad06f3c..03dfc32 100644
--- a/drivers/isdn/hisax/sedlbauer.c
+++ b/drivers/isdn/hisax/sedlbauer.c
@@ -518,8 +518,6 @@ Sedl_card_msg(struct IsdnCardState *cs, int mt, void *arg)
 	return(0);
 }
 
-static struct pci_dev *dev_sedl __devinitdata = NULL;
-
 #ifdef __ISAPNP__
 static struct isapnp_device_id sedl_ids[] __devinitdata = {
 	{ ISAPNP_VENDOR('S', 'A', 'G'), ISAPNP_FUNCTION(0x01),
@@ -533,15 +531,158 @@ static struct isapnp_device_id sedl_ids[] __devinitdata = {
 
 static struct isapnp_device_id *ipid __devinitdata = &sedl_ids[0];
 static struct pnp_card *pnp_c __devinitdata = NULL;
-#endif
+
+static int __devinit
+setup_sedlbauer_isapnp(struct IsdnCard *card, int *bytecnt)
+{
+	struct IsdnCardState *cs = card->cs;
+	struct pnp_dev *pnp_d;
+
+	if (!isapnp_present())
+		return -1;
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
+
+				if (!card->para[0] || !card->para[1]) {
+					printk(KERN_ERR "Sedlbauer PnP:some resources are missing %ld/%lx\n",
+						card->para[0], card->para[1]);
+					pnp_disable_dev(pnp_d);
+					return(0);
+				}
+				cs->hw.sedl.cfg_reg = card->para[1];
+				cs->irq = card->para[0];
+				if (ipid->function == ISAPNP_FUNCTION(0x2)) {
+					cs->subtyp = SEDL_SPEED_FAX;
+					cs->hw.sedl.chip = SEDL_CHIP_ISAC_ISAR;
+					*bytecnt = 16;
+				} else {
+					cs->subtyp = SEDL_SPEED_CARD_WIN;
+					cs->hw.sedl.chip = SEDL_CHIP_TEST;
+				}
+
+				return (1);
+			} else {
+				printk(KERN_ERR "Sedlbauer PnP: PnP error card found, no device\n");
+				return(0);
+			}
+		}
+		ipid++;
+		pnp_c = NULL;
+	} 
+
+	printk(KERN_INFO "Sedlbauer PnP: no ISAPnP card found\n");
+	return -1;
+}
+#else
+
+static int __devinit
+setup_sedlbauer_isapnp(struct IsdnCard *card, int *bytecnt)
+{
+	return -1;
+}
+#endif /* __ISAPNP__ */
+
+#ifdef CONFIG_PCI
+static struct pci_dev *dev_sedl __devinitdata = NULL;
+
+static int __devinit
+setup_sedlbauer_pci(struct IsdnCard *card)
+{
+	struct IsdnCardState *cs = card->cs;
+	u16 sub_vendor_id, sub_id;
+
+	if ((dev_sedl = pci_find_device(PCI_VENDOR_ID_TIGERJET,
+			PCI_DEVICE_ID_TIGERJET_100, dev_sedl))) {
+		if (pci_enable_device(dev_sedl))
+			return(0);
+		cs->irq = dev_sedl->irq;
+		if (!cs->irq) {
+			printk(KERN_WARNING "Sedlbauer: No IRQ for PCI card found\n");
+			return(0);
+		}
+		cs->hw.sedl.cfg_reg = pci_resource_start(dev_sedl, 0);
+	} else {
+		printk(KERN_WARNING "Sedlbauer: No PCI card found\n");
+		return(0);
+	}
+	cs->irq_flags |= IRQF_SHARED;
+	cs->hw.sedl.bus = SEDL_BUS_PCI;
+	sub_vendor_id = dev_sedl->subsystem_vendor;
+	sub_id = dev_sedl->subsystem_device;
+	printk(KERN_INFO "Sedlbauer: PCI subvendor:%x subid %x\n",
+		sub_vendor_id, sub_id);
+	printk(KERN_INFO "Sedlbauer: PCI base adr %#x\n",
+		cs->hw.sedl.cfg_reg);
+	if (sub_id != PCI_SUB_ID_SEDLBAUER) {
+		printk(KERN_ERR "Sedlbauer: unknown sub id %#x\n", sub_id);
+		return(0);
+	}
+	if (sub_vendor_id == PCI_SUBVENDOR_SPEEDFAX_PYRAMID) {
+		cs->hw.sedl.chip = SEDL_CHIP_ISAC_ISAR;
+		cs->subtyp = SEDL_SPEEDFAX_PYRAMID;
+	} else if (sub_vendor_id == PCI_SUBVENDOR_SPEEDFAX_PCI) {
+		cs->hw.sedl.chip = SEDL_CHIP_ISAC_ISAR;
+		cs->subtyp = SEDL_SPEEDFAX_PCI;
+	} else if (sub_vendor_id == PCI_SUBVENDOR_HST_SAPHIR3) {
+		cs->hw.sedl.chip = SEDL_CHIP_IPAC;
+		cs->subtyp = HST_SAPHIR3;
+	} else if (sub_vendor_id == PCI_SUBVENDOR_SEDLBAUER_PCI) {
+		cs->hw.sedl.chip = SEDL_CHIP_IPAC;
+		cs->subtyp = SEDL_SPEED_PCI;
+	} else {
+		printk(KERN_ERR "Sedlbauer: unknown sub vendor id %#x\n",
+			sub_vendor_id);
+		return(0);
+	}
+
+	cs->hw.sedl.reset_on = SEDL_ISAR_PCI_ISAR_RESET_ON;
+	cs->hw.sedl.reset_off = SEDL_ISAR_PCI_ISAR_RESET_OFF;
+	byteout(cs->hw.sedl.cfg_reg, 0xff);
+	byteout(cs->hw.sedl.cfg_reg, 0x00);
+	byteout(cs->hw.sedl.cfg_reg+ 2, 0xdd);
+	byteout(cs->hw.sedl.cfg_reg+ 5, 0); /* disable all IRQ */
+	byteout(cs->hw.sedl.cfg_reg +3, cs->hw.sedl.reset_on);
+	mdelay(2);
+	byteout(cs->hw.sedl.cfg_reg +3, cs->hw.sedl.reset_off);
+	mdelay(10);
+
+	return (1);
+}
+
+#else
+
+static int __devinit
+setup_sedlbauer_pci(struct IsdnCard *card)
+{
+	return (1);
+}
+
+#endif /* CONFIG_PCI */
 
 int __devinit
 setup_sedlbauer(struct IsdnCard *card)
 {
-	int bytecnt, ver, val;
+	int bytecnt = 8, ver, val, rc;
 	struct IsdnCardState *cs = card->cs;
 	char tmp[64];
-	u16 sub_vendor_id, sub_id;
 
 	strcpy(tmp, Sedlbauer_revision);
 	printk(KERN_INFO "HiSax: Sedlbauer driver Rev. %s\n", HiSax_getrev(tmp));
@@ -569,124 +710,21 @@ setup_sedlbauer(struct IsdnCard *card)
 			bytecnt = 16;
 		}
 	} else {
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
-
-						if (!card->para[0] || !card->para[1]) {
-							printk(KERN_ERR "Sedlbauer PnP:some resources are missing %ld/%lx\n",
-								card->para[0], card->para[1]);
-							pnp_disable_dev(pnp_d);
-							return(0);
-						}
-						cs->hw.sedl.cfg_reg = card->para[1];
-						cs->irq = card->para[0];
-						if (ipid->function == ISAPNP_FUNCTION(0x2)) {
-							cs->subtyp = SEDL_SPEED_FAX;
-							cs->hw.sedl.chip = SEDL_CHIP_ISAC_ISAR;
-							bytecnt = 16;
-						} else {
-							cs->subtyp = SEDL_SPEED_CARD_WIN;
-							cs->hw.sedl.chip = SEDL_CHIP_TEST;
-						}
-						goto ready;
-					} else {
-						printk(KERN_ERR "Sedlbauer PnP: PnP error card found, no device\n");
-						return(0);
-					}
-				}
-				ipid++;
-				pnp_c = NULL;
-			} 
-			if (!ipid->card_vendor) {
-				printk(KERN_INFO "Sedlbauer PnP: no ISAPnP card found\n");
-			}
-		}
-#endif
-/* Probe for Sedlbauer speed pci */
-#ifdef CONFIG_PCI
-		if ((dev_sedl = pci_find_device(PCI_VENDOR_ID_TIGERJET,
-				PCI_DEVICE_ID_TIGERJET_100, dev_sedl))) {
-			if (pci_enable_device(dev_sedl))
-				return(0);
-			cs->irq = dev_sedl->irq;
-			if (!cs->irq) {
-				printk(KERN_WARNING "Sedlbauer: No IRQ for PCI card found\n");
-				return(0);
-			}
-			cs->hw.sedl.cfg_reg = pci_resource_start(dev_sedl, 0);
-		} else {
-			printk(KERN_WARNING "Sedlbauer: No PCI card found\n");
-			return(0);
-		}
-		cs->irq_flags |= IRQF_SHARED;
-		cs->hw.sedl.bus = SEDL_BUS_PCI;
-		sub_vendor_id = dev_sedl->subsystem_vendor;
-		sub_id = dev_sedl->subsystem_device;
-		printk(KERN_INFO "Sedlbauer: PCI subvendor:%x subid %x\n",
-			sub_vendor_id, sub_id);
-		printk(KERN_INFO "Sedlbauer: PCI base adr %#x\n",
-			cs->hw.sedl.cfg_reg);
-		if (sub_id != PCI_SUB_ID_SEDLBAUER) {
-			printk(KERN_ERR "Sedlbauer: unknown sub id %#x\n", sub_id);
-			return(0);
-		}
-		if (sub_vendor_id == PCI_SUBVENDOR_SPEEDFAX_PYRAMID) {
-			cs->hw.sedl.chip = SEDL_CHIP_ISAC_ISAR;
-			cs->subtyp = SEDL_SPEEDFAX_PYRAMID;
-		} else if (sub_vendor_id == PCI_SUBVENDOR_SPEEDFAX_PCI) {
-			cs->hw.sedl.chip = SEDL_CHIP_ISAC_ISAR;
-			cs->subtyp = SEDL_SPEEDFAX_PCI;
-		} else if (sub_vendor_id == PCI_SUBVENDOR_HST_SAPHIR3) {
-			cs->hw.sedl.chip = SEDL_CHIP_IPAC;
-			cs->subtyp = HST_SAPHIR3;
-		} else if (sub_vendor_id == PCI_SUBVENDOR_SEDLBAUER_PCI) {
-			cs->hw.sedl.chip = SEDL_CHIP_IPAC;
-			cs->subtyp = SEDL_SPEED_PCI;
-		} else {
-			printk(KERN_ERR "Sedlbauer: unknown sub vendor id %#x\n",
-				sub_vendor_id);
-			return(0);
-		}
+		rc = setup_sedlbauer_isapnp(card, &bytecnt);
+		if (!rc)
+			return (0);
+		if (rc > 0)
+			goto ready;
+
+		/* Probe for Sedlbauer speed pci */
+		rc = setup_sedlbauer_pci(card);
+		if (!rc)
+			return (0);
+
 		bytecnt = 256;
-		cs->hw.sedl.reset_on = SEDL_ISAR_PCI_ISAR_RESET_ON;
-		cs->hw.sedl.reset_off = SEDL_ISAR_PCI_ISAR_RESET_OFF;
-		byteout(cs->hw.sedl.cfg_reg, 0xff);
-		byteout(cs->hw.sedl.cfg_reg, 0x00);
-		byteout(cs->hw.sedl.cfg_reg+ 2, 0xdd);
-		byteout(cs->hw.sedl.cfg_reg+ 5, 0); /* disable all IRQ */
-		byteout(cs->hw.sedl.cfg_reg +3, cs->hw.sedl.reset_on);
-		mdelay(2);
-		byteout(cs->hw.sedl.cfg_reg +3, cs->hw.sedl.reset_off);
-		mdelay(10);
-#else
-		printk(KERN_WARNING "Sedlbauer: NO_PCI_BIOS\n");
-		return (0);
-#endif /* CONFIG_PCI */
 	}	
 
-#ifdef __ISAPNP__
 ready:	
-#endif
 
 	/* In case of the sedlbauer pcmcia card, this region is in use,
 	 * reserved for us by the card manager. So we do not check it
diff --git a/drivers/isdn/hisax/telespci.c b/drivers/isdn/hisax/telespci.c
index d09f6d0..4393003 100644
--- a/drivers/isdn/hisax/telespci.c
+++ b/drivers/isdn/hisax/telespci.c
@@ -295,11 +295,12 @@ setup_telespci(struct IsdnCard *card)
 #ifdef __BIG_ENDIAN
 #error "not running on big endian machines now"
 #endif
+
 	strcpy(tmp, telespci_revision);
 	printk(KERN_INFO "HiSax: Teles/PCI driver Rev. %s\n", HiSax_getrev(tmp));
 	if (cs->typ != ISDN_CTYPE_TELESPCI)
 		return (0);
-#ifdef CONFIG_PCI
+
 	if ((dev_tel = pci_find_device (PCI_VENDOR_ID_ZORAN, PCI_DEVICE_ID_ZORAN_36120, dev_tel))) {
 		if (pci_enable_device(dev_tel))
 			return(0);
@@ -317,11 +318,6 @@ setup_telespci(struct IsdnCard *card)
 		printk(KERN_WARNING "TelesPCI: No PCI card found\n");
 		return(0);
 	}
-#else
-	printk(KERN_WARNING "HiSax: Teles/PCI and NO_PCI_BIOS\n");
-	printk(KERN_WARNING "HiSax: Teles/PCI unable to config\n");
-	return (0);
-#endif /* CONFIG_PCI */
 
 	/* Initialize Zoran PCI controller */
 	writel(0x00000000, cs->hw.teles0.membase + 0x28);
diff --git a/drivers/isdn/hisax/w6692.c b/drivers/isdn/hisax/w6692.c
index 3aeceaf..39129b9 100644
--- a/drivers/isdn/hisax/w6692.c
+++ b/drivers/isdn/hisax/w6692.c
@@ -1009,7 +1009,7 @@ setup_w6692(struct IsdnCard *card)
 	printk(KERN_INFO "HiSax: W6692 driver Rev. %s\n", HiSax_getrev(tmp));
 	if (cs->typ != ISDN_CTYPE_W6692)
 		return (0);
-#ifdef CONFIG_PCI
+
 	while (id_list[id_idx].vendor_id) {
 		dev_w6692 = pci_find_device(id_list[id_idx].vendor_id,
 					    id_list[id_idx].device_id,
@@ -1061,11 +1061,6 @@ setup_w6692(struct IsdnCard *card)
 		       cs->hw.w6692.iobase + 255);
 		return (0);
 	}
-#else
-	printk(KERN_WARNING "HiSax: W6692 and NO_PCI_BIOS\n");
-	printk(KERN_WARNING "HiSax: W6692 unable to config\n");
-	return (0);
-#endif				/* CONFIG_PCI */
 
 	printk(KERN_INFO
 	       "HiSax: %s config irq:%d I/O:%x\n",
