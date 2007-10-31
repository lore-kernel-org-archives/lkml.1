Return-Path: <linux-kernel-owner+w=401wt.eu-S1761523AbYBPUd5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761523AbYBPUd5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 15:33:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759680AbYBPU3y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 15:29:54 -0500
Received: from havoc.gtf.org ([69.61.125.42]:56840 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758894AbYBPU3X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 15:29:23 -0500
Message-Id: <03ff88eef5cea6b1b18c031ab488b0710ec25604.1203189978.git.jeff@garzik.org>
In-Reply-To: <167d76873c13943668c7f4443bfa60bb1552ecb2.1203189978.git.jeff@garzik.org>
References: <167d76873c13943668c7f4443bfa60bb1552ecb2.1203189978.git.jeff@garzik.org>
From: Jeff Garzik <jeff@garzik.org>
To: kkeil@suse.de, isdn4linux@listserv.isdn4linux.de,
       linux-kernel@vger.kernel.org
Date: Wed, 31 Oct 2007 01:13:26 -0400
Subject: [PATCH 13/14] [ISDN] HiSax diva: convert to modern ISA/PNP/PCI probing
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
---
 drivers/isdn/hisax/Kconfig  |    3 +-
 drivers/isdn/hisax/Makefile |    3 +-
 drivers/isdn/hisax/config.c |   27 +---
 drivers/isdn/hisax/diva.c   |  453 ++++++++++++++++++++++++++-----------------
 4 files changed, 283 insertions(+), 203 deletions(-)

diff --git a/drivers/isdn/hisax/Kconfig b/drivers/isdn/hisax/Kconfig
index 02cdc57..36af79f 100644
--- a/drivers/isdn/hisax/Kconfig
+++ b/drivers/isdn/hisax/Kconfig
@@ -165,7 +165,8 @@ config HISAX_IX1MICROR2
 	  non-standard IRQ/port settings.
 
 config HISAX_DIEHLDIVA
-	bool "Eicon.Diehl Diva cards"
+	tristate "Eicon.Diehl Diva cards"
+	depends on (ISA || PCI)
 	help
 	  This enables HiSax support for the Eicon.Diehl Diva none PRO
 	  versions passive ISDN cards.
diff --git a/drivers/isdn/hisax/Makefile b/drivers/isdn/hisax/Makefile
index 9efd189..bef1e0e 100644
--- a/drivers/isdn/hisax/Makefile
+++ b/drivers/isdn/hisax/Makefile
@@ -25,11 +25,13 @@ obj-$(CONFIG_HISAX_TELESPCI)		+= telespci.o libhisax.o
 obj-$(CONFIG_HISAX_FRITZPCI)		+= avm_pci.o libhisax.o
 obj-$(CONFIG_HISAX_GAZEL)		+= gazel.o libhisax.o
 obj-$(CONFIG_HISAX_NICCY)		+= niccy.o libhisax.o
+obj-$(CONFIG_HISAX_DIEHLDIVA)		+= hisaxdiva.o libhisax.o
 
 bkm_a4t_pci-y				:= bkm_a4t.o jade.o
 enternow-y				:= enternow_pci.o amd7930_fn.o
 netjet_s-y				:= nj_s.o
 netjet_u-y				:= nj_u.o icc.o
+hisaxdiva-y				:= diva.o ipacx.o 
 libhisax-y				:= netjet.o isac.o arcofi.o hscx.o
 
 ifdef CONFIG_HISAX_HDLC
@@ -54,7 +56,6 @@ hisax-$(CONFIG_HISAX_AVM_A1)		+= avm_a1.o
 hisax-$(CONFIG_HISAX_AVM_A1_PCMCIA)	+= avm_a1p.o
 hisax-$(CONFIG_HISAX_ELSA)		+= elsa.o
 hisax-$(CONFIG_HISAX_IX1MICROR2)	+= ix1_micro.o
-hisax-$(CONFIG_HISAX_DIEHLDIVA)		+= diva.o ipacx.o 
 hisax-$(CONFIG_HISAX_ASUSCOM)		+= asuscom.o
 hisax-$(CONFIG_HISAX_TELEINT)		+= teleint.o hfc_2bs0.o
 hisax-$(CONFIG_HISAX_SEDLBAUER)		+= sedlbauer.o isar.o
diff --git a/drivers/isdn/hisax/config.c b/drivers/isdn/hisax/config.c
index 243c7c9..f7d0818 100644
--- a/drivers/isdn/hisax/config.c
+++ b/drivers/isdn/hisax/config.c
@@ -145,13 +145,6 @@ const char *CardType[] = {
 #define DEFAULT_CFG {5,0x390,0,0}
 #endif
 
-#ifdef CONFIG_HISAX_DIEHLDIVA
-#undef DEFAULT_CARD
-#undef DEFAULT_CFG
-#define DEFAULT_CARD ISDN_CTYPE_DIEHLDIVA
-#define DEFAULT_CFG {0,0x0,0,0}
-#endif
-
 #ifdef CONFIG_HISAX_ASUSCOM
 #undef DEFAULT_CARD
 #undef DEFAULT_CFG
@@ -405,10 +398,6 @@ extern int setup_elsa(struct IsdnCard *card);
 extern int setup_ix1micro(struct IsdnCard *card);
 #endif
 
-#if CARD_DIEHLDIVA
-extern int setup_diva(struct IsdnCard *card);
-#endif
-
 #if CARD_ASUSCOM
 extern int setup_asuscom(struct IsdnCard *card);
 #endif
@@ -771,11 +760,6 @@ static int __devinit hisax_cs_setup_card(struct IsdnCard *card)
 		ret = setup_ix1micro(card);
 		break;
 #endif
-#if CARD_DIEHLDIVA
-	case ISDN_CTYPE_DIEHLDIVA:
-		ret = setup_diva(card);
-		break;
-#endif
 #if CARD_ASUSCOM
 	case ISDN_CTYPE_ASUSCOM:
 		ret = setup_asuscom(card);
@@ -843,6 +827,7 @@ static int __devinit hisax_cs_setup_card(struct IsdnCard *card)
 	case ISDN_CTYPE_FRITZPCI:
 	case ISDN_CTYPE_GAZEL:
 	case ISDN_CTYPE_NICCY:
+	case ISDN_CTYPE_DIEHLDIVA:
 		printk(KERN_WARNING "HiSax: Support for %s Card has moved "
 		       "to separate PCI driver module\n",
 		       CardType[card->typ]);
@@ -1278,7 +1263,6 @@ static int __init HiSax_init(void)
 		case ISDN_CTYPE_ELSA_PNP:
 		case ISDN_CTYPE_ELSA_PCMCIA:
 		case ISDN_CTYPE_IX1MICROR2:
-		case ISDN_CTYPE_DIEHLDIVA:
 		case ISDN_CTYPE_ASUSCOM:
 		case ISDN_CTYPE_TELEINT:
 		case ISDN_CTYPE_SEDLBAUER:
@@ -1314,6 +1298,7 @@ static int __init HiSax_init(void)
 		case ISDN_CTYPE_FRITZPCI:
 		case ISDN_CTYPE_GAZEL:
 		case ISDN_CTYPE_NICCY:
+		case ISDN_CTYPE_DIEHLDIVA:
 			break;
 
 		case ISDN_CTYPE_SCT_QUADRO:
@@ -1782,14 +1767,6 @@ static void EChannel_proc_rcv(struct hisax_d_if *d_if)
 #include <linux/pci.h>
 
 static struct pci_device_id hisax_pci_tbl[] __devinitdata = {
-#ifdef CONFIG_HISAX_DIEHLDIVA
-	{PCI_VENDOR_ID_EICON,    PCI_DEVICE_ID_EICON_DIVA20,     PCI_ANY_ID, PCI_ANY_ID},
-	{PCI_VENDOR_ID_EICON,    PCI_DEVICE_ID_EICON_DIVA20_U,   PCI_ANY_ID, PCI_ANY_ID},
-	{PCI_VENDOR_ID_EICON,    PCI_DEVICE_ID_EICON_DIVA201,    PCI_ANY_ID, PCI_ANY_ID},
-//#########################################################################################	
-	{PCI_VENDOR_ID_EICON,    PCI_DEVICE_ID_EICON_DIVA202,    PCI_ANY_ID, PCI_ANY_ID},
-//#########################################################################################	
-#endif
 #ifdef CONFIG_HISAX_ELSA
 	{PCI_VENDOR_ID_ELSA,     PCI_DEVICE_ID_ELSA_MICROLINK,   PCI_ANY_ID, PCI_ANY_ID},
 	{PCI_VENDOR_ID_ELSA,     PCI_DEVICE_ID_ELSA_QS3000,      PCI_ANY_ID, PCI_ANY_ID},
diff --git a/drivers/isdn/hisax/diva.c b/drivers/isdn/hisax/diva.c
index 2d67085..bcaddd9 100644
--- a/drivers/isdn/hisax/diva.c
+++ b/drivers/isdn/hisax/diva.c
@@ -17,13 +17,22 @@
 
 #include <linux/init.h>
 #include "hisax.h"
+#include "hisax_proto.h"
 #include "isac.h"
 #include "hscx.h"
 #include "ipac.h"
 #include "ipacx.h"
 #include "isdnl1.h"
 #include <linux/pci.h>
-#include <linux/isapnp.h>
+#include <linux/isa.h>
+#include <linux/pnp.h>
+
+static int diva_protocol;		/* 0 == use DEFAULT_PROTO */
+
+#ifdef CONFIG_ISA
+static int diva_irq;			/* 0 == disable ISA */
+static int diva_io_base;		/* 0 == disable ISA */
+#endif
 
 static const char *Diva_revision = "$Revision: 1.33.2.6 $";
 
@@ -908,6 +917,14 @@ static int __devinit setup_diva_common(struct IsdnCardState *cs)
 {
 	int bytecnt;
 	u_char val;
+	char tmp[64];
+
+	strcpy(tmp, Diva_revision);
+	printk(KERN_INFO "HiSax: Eicon.Diehl Diva driver Rev. %s\n",
+	       HiSax_getrev(tmp));
+	if (cs->typ != ISDN_CTYPE_DIEHLDIVA)
+		return(0);
+	cs->hw.diva.status = 0;
 
 	if ((cs->subtyp == DIVA_ISA) || (cs->subtyp == DIVA_IPAC_ISA))
 		bytecnt = 8;
@@ -997,7 +1014,7 @@ static int __devinit setup_diva_common(struct IsdnCardState *cs)
 
 #ifdef CONFIG_ISA
 
-static int __devinit setup_diva_isa(struct IsdnCard *card)
+static int __devinit diva_isa_setup(struct IsdnCard *card)
 {
 	struct IsdnCardState *cs = card->cs;
 	u_char val;
@@ -1028,173 +1045,192 @@ static int __devinit setup_diva_isa(struct IsdnCard *card)
 	}
 	cs->irq = card->para[0];
 
-	return (1);		/* card found */
+	return setup_diva_common(cs);
 }
 
-#else	/* if !CONFIG_ISA */
+static int __devinit diva_isa_init_one(struct device *dev, unsigned int id)
+{
+	struct IsdnCard icard = { ISDN_CTYPE_DIEHLDIVA, };
+	int cardnr;
+
+	icard.para[0] = diva_irq;
+	icard.para[1] = diva_io_base;
+	if (!diva_protocol)
+		icard.protocol = DEFAULT_PROTO;
+	else
+		icard.protocol = diva_protocol;
 
-static int __devinit setup_diva_isa(struct IsdnCard *card)
+	cardnr = hisax_init_hotplug(&icard, diva_isa_setup);
+	if (cardnr < 0)
+		return -ENODEV;
+
+	dev_set_drvdata(dev, (void *)(unsigned long) cardnr);
+	return 0;
+}
+
+static int __devexit diva_isa_remove_one(struct device *dev, unsigned int id)
 {
-	return (-1);	/* card not found; continue search */
+	int cardnr = (unsigned long) dev_get_drvdata(dev);
+
+	HiSax_closecard(cardnr);
+	return 0;
 }
 
-#endif	/* CONFIG_ISA */
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
+static struct isa_driver diva_isa_driver = {
+	.probe		= diva_isa_init_one,
+	.remove		= __devexit_p(diva_isa_remove_one),
+	.driver = {
+		.owner	= THIS_MODULE,
+		.name	= "diva_isa",
+	},
 };
 
-static struct isapnp_device_id *ipid __devinitdata = &diva_ids[0];
-static struct pnp_card *pnp_c __devinitdata = NULL;
-
-static int __devinit setup_diva_isapnp(struct IsdnCard *card)
+#ifdef CONFIG_PNP
+static int __devinit diva_pnp_setup(struct IsdnCard *card)
 {
 	struct IsdnCardState *cs = card->cs;
-	struct pnp_dev *pnp_d;
+	struct pnp_dev *pnp_d = (void *) card->para[0];
+	int ipid_function = card->para[1];
+	int err;
+
+	printk(KERN_INFO "HiSax: DIVA PNP detected\n");
+	pnp_disable_dev(pnp_d);
+	err = pnp_activate_dev(pnp_d);
+	if (err < 0) {
+		printk(KERN_WARNING "%s: pnp_activate_dev ret(%d)\n",
+			__func__, err);
+		return(0);
+	}
+	card->para[1] = pnp_port_start(pnp_d, 0);
+	card->para[0] = pnp_irq(pnp_d, 0);
+	if (!card->para[0] || !card->para[1]) {
+		printk(KERN_ERR "Diva PnP:some resources are missing %ld/%lx\n",
+			card->para[0], card->para[1]);
+		pnp_disable_dev(pnp_d);
+		return(0);
+	}
+	cs->hw.diva.cfg_reg  = card->para[1];
+	cs->irq = card->para[0];
+	if (ipid_function == 0xA1) {
+		cs->subtyp = DIVA_IPAC_ISA;
+		cs->hw.diva.ctrl = 0;
+		cs->hw.diva.isac =
+			card->para[1] + DIVA_IPAC_DATA;
+		cs->hw.diva.hscx =
+			card->para[1] + DIVA_IPAC_DATA;
+		cs->hw.diva.isac_adr =
+			card->para[1] + DIVA_IPAC_ADR;
+		cs->hw.diva.hscx_adr =
+			card->para[1] + DIVA_IPAC_ADR;
+		test_and_set_bit(HW_IPAC, &cs->HW_Flags);
+	} else {
+		cs->subtyp = DIVA_ISA;
+		cs->hw.diva.ctrl =
+			card->para[1] + DIVA_ISA_CTRL;
+		cs->hw.diva.isac =
+			card->para[1] + DIVA_ISA_ISAC_DATA;
+		cs->hw.diva.hscx =
+			card->para[1] + DIVA_HSCX_DATA;
+		cs->hw.diva.isac_adr =
+			card->para[1] + DIVA_ISA_ISAC_ADR;
+		cs->hw.diva.hscx_adr =
+			card->para[1] + DIVA_HSCX_ADR;
+	}
 
-	if (!isapnp_present())
-		return (-1);	/* card not found; continue search */
+	return setup_diva_common(cs);
+}
 
-	while(ipid->card_vendor) {
-		if ((pnp_c = pnp_find_card(ipid->card_vendor,
-			ipid->card_device, pnp_c))) {
-			pnp_d = NULL;
-			if ((pnp_d = pnp_find_dev(pnp_c,
-				ipid->vendor, ipid->function, pnp_d))) {
-				int err;
-
-				printk(KERN_INFO "HiSax: %s detected\n",
-					(char *)ipid->driver_data);
-				pnp_disable_dev(pnp_d);
-				err = pnp_activate_dev(pnp_d);
-				if (err<0) {
-					printk(KERN_WARNING "%s: pnp_activate_dev ret(%d)\n",
-						__FUNCTION__, err);
-					return(0);
-				}
-				card->para[1] = pnp_port_start(pnp_d, 0);
-				card->para[0] = pnp_irq(pnp_d, 0);
-				if (!card->para[0] || !card->para[1]) {
-					printk(KERN_ERR "Diva PnP:some resources are missing %ld/%lx\n",
-						card->para[0], card->para[1]);
-					pnp_disable_dev(pnp_d); 
-					return(0);
-				}
-				cs->hw.diva.cfg_reg  = card->para[1];
-				cs->irq = card->para[0];
-				if (ipid->function == ISAPNP_FUNCTION(0xA1)) {
-					cs->subtyp = DIVA_IPAC_ISA;
-					cs->hw.diva.ctrl = 0;
-					cs->hw.diva.isac =
-						card->para[1] + DIVA_IPAC_DATA;
-					cs->hw.diva.hscx =
-						card->para[1] + DIVA_IPAC_DATA;
-					cs->hw.diva.isac_adr =
-						card->para[1] + DIVA_IPAC_ADR;
-					cs->hw.diva.hscx_adr =
-						card->para[1] + DIVA_IPAC_ADR;
-					test_and_set_bit(HW_IPAC, &cs->HW_Flags);
-				} else {
-					cs->subtyp = DIVA_ISA;
-					cs->hw.diva.ctrl =
-						card->para[1] + DIVA_ISA_CTRL;
-					cs->hw.diva.isac =
-						card->para[1] + DIVA_ISA_ISAC_DATA;
-					cs->hw.diva.hscx =
-						card->para[1] + DIVA_HSCX_DATA;
-					cs->hw.diva.isac_adr =
-						card->para[1] + DIVA_ISA_ISAC_ADR;
-					cs->hw.diva.hscx_adr =
-						card->para[1] + DIVA_HSCX_ADR;
-				}
-				return (1);		/* card found */
-			} else {
-				printk(KERN_ERR "Diva PnP: PnP error card found, no device\n");
-				return(0);
-			}
-		}
-		ipid++;
-		pnp_c=NULL;
-	} 
+static int __devinit diva_pnp_init_one(struct pnp_dev *pdev,
+				       const struct pnp_device_id *dev_id)
+{
+	struct IsdnCard icard = { ISDN_CTYPE_DIEHLDIVA, };
+	int cardnr;
 
-	return (-1);	/* card not found; continue search */
-}
+	icard.para[0] = (unsigned long) pdev;
+	icard.para[1] = dev_id->driver_data;
+	if (!diva_protocol)
+		icard.protocol = DEFAULT_PROTO;
+	else
+		icard.protocol = diva_protocol;
 
-#else	/* if !ISAPNP */
+	cardnr = hisax_init_hotplug(&icard, diva_pnp_setup);
+	if (cardnr < 0)
+		return -ENODEV;
 
-static int __devinit setup_diva_isapnp(struct IsdnCard *card)
+	pnp_set_drvdata(pdev, (void *)(unsigned long) cardnr);
+	return 0;
+}
+
+static void __devexit diva_pnp_remove_one(struct pnp_dev *pdev)
 {
-	return (-1);	/* card not found; continue search */
+	int cardnr = (unsigned long) pnp_get_drvdata(pdev);
+
+	HiSax_closecard(cardnr);
 }
 
-#endif	/* ISAPNP */
+static struct pnp_device_id diva_pnp_table[] = {
+	{ .id = "GDI0051", 0 },
+	{ .id = "GDI0071", 0 },
+	{ .id = "GDI00A1", 0xA1 },
+	{ .id = "EIC0051", 0 },
+	{ .id = "EIC0071", 0 },
+	{ .id = "EIC00A1", 0xA1 },
+
+	{ .id = "" }		/* terminate list */
+};
+
+MODULE_DEVICE_TABLE(pnp, diva_pnp_table);
+
+static struct pnp_driver diva_pnp_driver = {
+	.name		= "diva_pnp",
+	.id_table	= diva_pnp_table,
+	.probe		= diva_pnp_init_one,
+	.remove		= __devexit_p(diva_pnp_remove_one),
+};
+#endif /* CONFIG_PNP */
+#endif /* CONFIG_ISA */
+
+#ifdef CONFIG_PCI
 
-#ifdef CONFIG_PCI_LEGACY
-static struct pci_dev *dev_diva __devinitdata = NULL;
-static struct pci_dev *dev_diva_u __devinitdata = NULL;
-static struct pci_dev *dev_diva201 __devinitdata = NULL;
-static struct pci_dev *dev_diva202 __devinitdata = NULL;
+enum diva_board_type {
+	diva20,
+	diva20_u,
+	diva201,
+	diva202,
+};
 
-static int __devinit setup_diva_pci(struct IsdnCard *card)
+static int __devinit diva_pci_setup(struct IsdnCard *card)
 {
 	struct IsdnCardState *cs = card->cs;
+	struct pci_dev *dev_diva = (void *) card->para[0];
+	enum diva_board_type btype = card->para[1];
 
 	cs->subtyp = 0;
-	if ((dev_diva = pci_find_device(PCI_VENDOR_ID_EICON,
-		PCI_DEVICE_ID_EICON_DIVA20, dev_diva))) {
-		if (pci_enable_device(dev_diva))
-			return(0);
+	cs->irq = dev_diva->irq;
+
+	if (pci_enable_device(dev_diva))
+		return(0);
+
+	if (btype == diva20) {
 		cs->subtyp = DIVA_PCI;
-		cs->irq = dev_diva->irq;
 		cs->hw.diva.cfg_reg = pci_resource_start(dev_diva, 2);
-	} else if ((dev_diva_u = pci_find_device(PCI_VENDOR_ID_EICON,
-		PCI_DEVICE_ID_EICON_DIVA20_U, dev_diva_u))) {
-		if (pci_enable_device(dev_diva_u))
-			return(0);
+	} else if (btype == diva20_u) {
 		cs->subtyp = DIVA_PCI;
-		cs->irq = dev_diva_u->irq;
-		cs->hw.diva.cfg_reg = pci_resource_start(dev_diva_u, 2);
-	} else if ((dev_diva201 = pci_find_device(PCI_VENDOR_ID_EICON,
-		PCI_DEVICE_ID_EICON_DIVA201, dev_diva201))) {
-		if (pci_enable_device(dev_diva201))
-			return(0);
+		cs->hw.diva.cfg_reg = pci_resource_start(dev_diva, 2);
+	} else if (btype == diva201) {
 		cs->subtyp = DIVA_IPAC_PCI;
-		cs->irq = dev_diva201->irq;
 		cs->hw.diva.pci_cfg =
-			(ulong) ioremap(pci_resource_start(dev_diva201, 0), 4096);
+			(ulong) ioremap(pci_resource_start(dev_diva, 0), 4096);
 		cs->hw.diva.cfg_reg =
-			(ulong) ioremap(pci_resource_start(dev_diva201, 1), 4096);
-	} else if ((dev_diva202 = pci_find_device(PCI_VENDOR_ID_EICON,
-		PCI_DEVICE_ID_EICON_DIVA202, dev_diva202))) {
-		if (pci_enable_device(dev_diva202))
-			return(0);
+			(ulong) ioremap(pci_resource_start(dev_diva, 1), 4096);
+	} else if (btype == diva202) {
 		cs->subtyp = DIVA_IPACX_PCI;
-		cs->irq = dev_diva202->irq;
 		cs->hw.diva.pci_cfg =
-			(ulong) ioremap(pci_resource_start(dev_diva202, 0), 4096);
+			(ulong) ioremap(pci_resource_start(dev_diva, 0), 4096);
 		cs->hw.diva.cfg_reg =
-			(ulong) ioremap(pci_resource_start(dev_diva202, 1), 4096);
+			(ulong) ioremap(pci_resource_start(dev_diva, 1), 4096);
 	} else {
-		return (-1);	/* card not found; continue search */
+		BUG();
 	}
 
 	if (!cs->irq) {
@@ -1226,58 +1262,123 @@ static int __devinit setup_diva_pci(struct IsdnCard *card)
 		cs->hw.diva.hscx_adr = cs->hw.diva.cfg_reg + DIVA_HSCX_ADR;
 	}
 
-	return (1);		/* card found */
+	return setup_diva_common(cs);
 }
 
-#else	/* if !CONFIG_PCI_LEGACY */
-
-static int __devinit setup_diva_pci(struct IsdnCard *card)
+static int __devinit diva_pci_init_one(struct pci_dev *pdev,
+				      const struct pci_device_id *ent)
 {
-	return (-1);	/* card not found; continue search */
+	struct IsdnCard icard = { ISDN_CTYPE_DIEHLDIVA, };
+	int cardnr;
+
+	icard.para[0] = (unsigned long) pdev;
+	icard.para[1] = ent->driver_data;
+	if (!diva_protocol)
+		icard.protocol = DEFAULT_PROTO;
+	else
+		icard.protocol = diva_protocol;
+
+	cardnr = hisax_init_hotplug(&icard, diva_pci_setup);
+	if (cardnr < 0)
+		return -ENODEV;
+
+	pci_set_drvdata(pdev, (void *)(unsigned long) cardnr);
+	return 0;
 }
 
-#endif	/* CONFIG_PCI_LEGACY */
+static struct pci_device_id diva_pci_table[] = {
+	{ PCI_VDEVICE(EICON, PCI_DEVICE_ID_EICON_DIVA20),	diva20 },
+	{ PCI_VDEVICE(EICON, PCI_DEVICE_ID_EICON_DIVA20_U),	diva20_u },
+	{ PCI_VDEVICE(EICON, PCI_DEVICE_ID_EICON_DIVA201),	diva201 },
+//###########################################################################
+	{ PCI_VDEVICE(EICON, PCI_DEVICE_ID_EICON_DIVA202),	diva202 },
+//###########################################################################
 
-int __devinit
-setup_diva(struct IsdnCard *card)
-{
-	int rc, have_card = 0;
-	struct IsdnCardState *cs = card->cs;
-	char tmp[64];
+	{ }		/* terminate list */
+};
 
-	strcpy(tmp, Diva_revision);
-	printk(KERN_INFO "HiSax: Eicon.Diehl Diva driver Rev. %s\n", HiSax_getrev(tmp));
-	if (cs->typ != ISDN_CTYPE_DIEHLDIVA)
-		return(0);
-	cs->hw.diva.status = 0;
+static struct pci_driver diva_pci_driver = {
+	.name		= "diva",
+	.id_table	= diva_pci_table,
+	.probe		= diva_pci_init_one,
+	.remove		= hisax_pci_remove_one,
+};
 
-	rc = setup_diva_isa(card);
-	if (!rc)
-		return rc;
-	if (rc > 0) {
-		have_card = 1;
-		goto ready;
-	}
+#endif /* CONFIG_PCI */
 
-	rc = setup_diva_isapnp(card);
-	if (!rc)
-		return rc;
-	if (rc > 0) {
-		have_card = 1;
-		goto ready;
+static int __init diva_mod_init(void)
+{
+	int rc = 0;
+
+#ifdef CONFIG_ISA
+	if (diva_irq && diva_io_base) {
+		rc = isa_register_driver(&diva_isa_driver, 1);
+		if (rc)
+			return rc;
 	}
+#ifdef CONFIG_PNP
+	else {
+		rc = pnp_register_driver(&diva_pnp_driver);
+		if (rc)
+			return rc;
+	}
+#endif
+#endif /* CONFIG_ISA */
 
-	rc = setup_diva_pci(card);
-	if (!rc)
-		return rc;
-	if (rc > 0)
-		have_card = 1;
+#ifdef CONFIG_PCI
+	rc = pci_register_driver(&diva_pci_driver);
+	if (rc)
+		goto err_out_isa;
+#endif /* CONFIG_PCI */
 
-ready:
-	if (!have_card) {
-		printk(KERN_WARNING "Diva: No ISA, ISAPNP or PCI card found\n");
-		return(0);
-	}
+	return 0;
+
+#ifdef CONFIG_PCI
+err_out_isa:
+
+#ifdef CONFIG_ISA
+	if (diva_irq && diva_io_base)
+		isa_unregister_driver(&diva_isa_driver);
+#ifdef CONFIG_PNP
+	else
+		pnp_unregister_driver(&diva_pnp_driver);
+#endif /* CONFIG_PNP */
+#endif /* CONFIG_ISA */
 
-	return setup_diva_common(card->cs);
+	return rc;
+#endif /* CONFIG_PCI */
 }
+
+static void __exit diva_mod_exit(void)
+{
+#ifdef CONFIG_PCI
+	pci_unregister_driver(&diva_pci_driver);
+#endif /* CONFIG_PCI */
+
+#ifdef CONFIG_ISA
+	if (diva_irq && diva_io_base)
+		isa_unregister_driver(&diva_isa_driver);
+#ifdef CONFIG_PNP
+	else
+		pnp_unregister_driver(&diva_pnp_driver);
+#endif /* CONFIG_PNP */
+#endif /* CONFIG_ISA */
+}
+
+module_init(diva_mod_init);
+module_exit(diva_mod_exit);
+
+#ifdef CONFIG_ISA
+module_param_named(irq, diva_irq, int, 0444);
+MODULE_PARM_DESC(irq, "ISA IRQ.  Zero disables ISA support (default).");
+
+module_param_named(io, diva_io_base, int, 0444);
+MODULE_PARM_DESC(io, "ISA I/O base.  Zero disables ISA support (default).");
+#endif /* CONFIG_ISA */
+
+module_param_named(protocol, diva_protocol, int, 0444);
+MODULE_PARM_DESC(protocol, "Values 0 (default) through 4. See ISDN_PTYPE_xxx in linux/isdnif.h");
+
+MODULE_DEVICE_TABLE(pci, diva_pci_table);
+MODULE_DESCRIPTION("ISDN HiSax Diehldiva PCI/PNP/ISA driver");
+MODULE_LICENSE("GPL");
-- 
1.5.3.8

