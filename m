Return-Path: <linux-kernel-owner+w=401wt.eu-S1763828AbYBNXpX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763828AbYBNXpX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 18:45:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932905AbYBNXk0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 18:40:26 -0500
Received: from havoc.gtf.org ([69.61.125.42]:46781 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761204AbYBNXkR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 18:40:17 -0500
Message-Id: <76d8e6b586330ddc681b8a3fd9054a8416173312.1203031878.git.jeff@garzik.org>
In-Reply-To: <74fc75b3eadfa82aee70b855e9944b5439a259d5.1203031878.git.jeff@garzik.org>
References: <74fc75b3eadfa82aee70b855e9944b5439a259d5.1203031878.git.jeff@garzik.org>
From: Jeff Garzik <jeff@garzik.org>
To: linux-kernel@vger.kernel.org, kkeil@suse.de,
       isdn4linux@listserv.isdn4linux.de
Date: Wed, 31 Oct 2007 01:12:15 -0400
Subject: [PATCH 10/14] [ISDN] HiSax gazel: convert to modern ISA/PCI probing
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
---
 drivers/isdn/hisax/Kconfig  |    3 +-
 drivers/isdn/hisax/Makefile |    2 +-
 drivers/isdn/hisax/config.c |   25 +----
 drivers/isdn/hisax/gazel.c  |  248 ++++++++++++++++++++++++++++++++----------
 4 files changed, 194 insertions(+), 84 deletions(-)

diff --git a/drivers/isdn/hisax/Kconfig b/drivers/isdn/hisax/Kconfig
index 14951c0..dbc296e 100644
--- a/drivers/isdn/hisax/Kconfig
+++ b/drivers/isdn/hisax/Kconfig
@@ -306,7 +306,8 @@ config HISAX_SCT_QUADRO
 	  settings.
 
 config HISAX_GAZEL
-	bool "Gazel cards"
+	tristate "Gazel cards"
+	depends on (ISA || PCI)
 	help
 	  This enables HiSax support for the Gazel cards.
 
diff --git a/drivers/isdn/hisax/Makefile b/drivers/isdn/hisax/Makefile
index e03b4ce..e67bf92 100644
--- a/drivers/isdn/hisax/Makefile
+++ b/drivers/isdn/hisax/Makefile
@@ -23,6 +23,7 @@ obj-$(CONFIG_HISAX_NETJET)		+= netjet_s.o libhisax.o
 obj-$(CONFIG_HISAX_NETJET_U)		+= netjet_u.o libhisax.o
 obj-$(CONFIG_HISAX_TELESPCI)		+= telespci.o libhisax.o
 obj-$(CONFIG_HISAX_FRITZPCI)		+= avm_pci.o libhisax.o
+obj-$(CONFIG_HISAX_GAZEL)		+= gazel.o libhisax.o
 
 bkm_a4t_pci-objs			:= bkm_a4t.o jade.o
 enternow-objs				:= enternow_pci.o amd7930_fn.o
@@ -64,5 +65,4 @@ hisax-$(CONFIG_HISAX_NICCY)		+= niccy.o
 hisax-$(CONFIG_HISAX_ISURF)		+= isurf.o isar.o
 hisax-$(CONFIG_HISAX_HSTSAPHIR)		+= saphir.o
 hisax-$(CONFIG_HISAX_SCT_QUADRO)	+= bkm_a8.o
-hisax-$(CONFIG_HISAX_GAZEL)		+= gazel.o
 
diff --git a/drivers/isdn/hisax/config.c b/drivers/isdn/hisax/config.c
index 62e4b85..ec949f6 100644
--- a/drivers/isdn/hisax/config.c
+++ b/drivers/isdn/hisax/config.c
@@ -229,13 +229,6 @@ const char *CardType[] = {
 #define DEFAULT_CFG {1,0x0,0,0}
 #endif
 
-#ifdef CONFIG_HISAX_GAZEL
-#undef DEFAULT_CARD
-#undef DEFAULT_CFG
-#define DEFAULT_CARD ISDN_CTYPE_GAZEL
-#define DEFAULT_CFG {15,0x180,0,0}
-#endif
-
 #ifndef DEFAULT_CARD
 #define DEFAULT_CARD 0
 #define DEFAULT_CFG {0,0,0,0}
@@ -470,10 +463,6 @@ extern int setup_saphir(struct IsdnCard *card);
 extern int setup_sct_quadro(struct IsdnCard *card);
 #endif
 
-#if CARD_GAZEL
-extern int setup_gazel(struct IsdnCard *card);
-#endif
-
 /*
  * Find card with given driverId
  */
@@ -858,11 +847,6 @@ static int __devinit hisax_cs_setup_card(struct IsdnCard *card)
 		ret = setup_sct_quadro(card);
 		break;
 #endif
-#if CARD_GAZEL
-	case ISDN_CTYPE_GAZEL:
-		ret = setup_gazel(card);
-		break;
-#endif
 	case ISDN_CTYPE_DYNAMIC:
 		ret = 2;
 		break;
@@ -875,6 +859,7 @@ static int __devinit hisax_cs_setup_card(struct IsdnCard *card)
 	case ISDN_CTYPE_NETJET_U:
 	case ISDN_CTYPE_TELESPCI:
 	case ISDN_CTYPE_FRITZPCI:
+	case ISDN_CTYPE_GAZEL:
 		printk(KERN_WARNING "HiSax: Support for %s Card has moved "
 		       "to separate PCI driver module\n",
 		       CardType[card->typ]);
@@ -1322,7 +1307,6 @@ static int __init HiSax_init(void)
 		case ISDN_CTYPE_ACERP10:
 		case ISDN_CTYPE_S0BOX:
 		case ISDN_CTYPE_HSTSAPHIR:
-		case ISDN_CTYPE_GAZEL:
 		case ISDN_CTYPE_HFC_SX:
 		case ISDN_CTYPE_HFC_SP_PCMCIA:
 			cards[j].para[0] = irq[i];
@@ -1345,6 +1329,7 @@ static int __init HiSax_init(void)
 		case ISDN_CTYPE_NETJET_U:
 		case ISDN_CTYPE_TELESPCI:
 		case ISDN_CTYPE_FRITZPCI:
+		case ISDN_CTYPE_GAZEL:
 			break;
 
 		case ISDN_CTYPE_SCT_QUADRO:
@@ -1830,12 +1815,6 @@ static struct pci_device_id hisax_pci_tbl[] __devinitdata = {
 	{PCI_VENDOR_ID_ELSA,     PCI_DEVICE_ID_ELSA_MICROLINK,   PCI_ANY_ID, PCI_ANY_ID},
 	{PCI_VENDOR_ID_ELSA,     PCI_DEVICE_ID_ELSA_QS3000,      PCI_ANY_ID, PCI_ANY_ID},
 #endif
-#ifdef CONFIG_HISAX_GAZEL
-	{PCI_VENDOR_ID_PLX,      PCI_DEVICE_ID_PLX_R685,         PCI_ANY_ID, PCI_ANY_ID},
-	{PCI_VENDOR_ID_PLX,      PCI_DEVICE_ID_PLX_R753,         PCI_ANY_ID, PCI_ANY_ID},
-	{PCI_VENDOR_ID_PLX,      PCI_DEVICE_ID_PLX_DJINN_ITOO,   PCI_ANY_ID, PCI_ANY_ID},
-	{PCI_VENDOR_ID_PLX,      PCI_DEVICE_ID_PLX_OLITEC,       PCI_ANY_ID, PCI_ANY_ID},
-#endif
 #ifdef CONFIG_HISAX_SCT_QUADRO
 	{PCI_VENDOR_ID_PLX,      PCI_DEVICE_ID_PLX_9050,         PCI_ANY_ID, PCI_ANY_ID},
 #endif
diff --git a/drivers/isdn/hisax/gazel.c b/drivers/isdn/hisax/gazel.c
index 0ea3b46..4855e2a 100644
--- a/drivers/isdn/hisax/gazel.c
+++ b/drivers/isdn/hisax/gazel.c
@@ -13,12 +13,21 @@
 
 #include <linux/init.h>
 #include "hisax.h"
+#include "hisax_proto.h"
 #include "isac.h"
 #include "hscx.h"
 #include "isdnl1.h"
 #include "ipac.h"
+#include <linux/isa.h>
 #include <linux/pci.h>
 
+static int gazel_protocol;		/* 0 == use DEFAULT_PROTO */
+
+#ifdef CONFIG_ISA
+static int gazel_irq;			/* 0 == no ISA probing */
+static int gazel_io_base;		/* 0 == no ISA probing */
+#endif /* CONFIG_ISA */
+
 static const char *gazel_revision = "$Revision: 2.19.2.4 $";
 
 #define R647      1
@@ -483,7 +492,8 @@ reserve_regions(struct IsdnCard *card, struct IsdnCardState *cs)
 	return 1;
 }
 
-static int __devinit
+#ifdef CONFIG_ISA
+static void __devinit
 setup_gazelisa(struct IsdnCard *card, struct IsdnCardState *cs)
 {
 	printk(KERN_INFO "Gazel: ISA PnP card automatic recognition\n");
@@ -527,58 +537,35 @@ setup_gazelisa(struct IsdnCard *card, struct IsdnCardState *cs)
 			       cs->irq, cs->hw.gazel.ipac);
 			break;
 	}
-
-	return (0);
 }
+#endif /* CONFIG_ISA */
 
-#ifdef CONFIG_PCI_LEGACY
-static struct pci_dev *dev_tel __devinitdata = NULL;
-
+#ifdef CONFIG_PCI
 static int __devinit
-setup_gazelpci(struct IsdnCardState *cs)
+setup_gazelpci(struct IsdnCard *card)
 {
 	u_int pci_ioaddr0 = 0, pci_ioaddr1 = 0;
 	u_char pci_irq = 0, found;
-	u_int nbseek, seekcard;
+	u_int seekcard;
+	struct IsdnCardState *cs = card->cs;
+	struct pci_dev *dev_tel = (void *) card->para[0];
 
 	printk(KERN_WARNING "Gazel: PCI card automatic recognition\n");
 
 	found = 0;
-	seekcard = PCI_DEVICE_ID_PLX_R685;
-	for (nbseek = 0; nbseek < 4; nbseek++) {
-		if ((dev_tel = pci_find_device(PCI_VENDOR_ID_PLX,
-					seekcard, dev_tel))) {
-			if (pci_enable_device(dev_tel))
-				return 1;
-			pci_irq = dev_tel->irq;
-			pci_ioaddr0 = pci_resource_start(dev_tel, 1);
-			pci_ioaddr1 = pci_resource_start(dev_tel, 2);
-			found = 1;
-		}
-		if (found)
-			break;
-		else {
-			switch (seekcard) {
-				case PCI_DEVICE_ID_PLX_R685:
-					seekcard = PCI_DEVICE_ID_PLX_R753;
-					break;
-				case PCI_DEVICE_ID_PLX_R753:
-					seekcard = PCI_DEVICE_ID_PLX_DJINN_ITOO;
-					break;
-				case PCI_DEVICE_ID_PLX_DJINN_ITOO:
-					seekcard = PCI_DEVICE_ID_PLX_OLITEC;
-					break;
-			}
-		}
-	}
-	if (!found) {
-		printk(KERN_WARNING "Gazel: No PCI card found\n");
-		return (1);
-	}
+	seekcard = dev_tel->device;
+
+	if (pci_enable_device(dev_tel))
+		return 1;
+	pci_irq = dev_tel->irq;
+	pci_ioaddr0 = pci_resource_start(dev_tel, 1);
+	pci_ioaddr1 = pci_resource_start(dev_tel, 2);
+
 	if (!pci_irq) {
 		printk(KERN_WARNING "Gazel: No IRQ for PCI card found\n");
 		return 1;
 	}
+
 	cs->hw.gazel.pciaddr[0] = pci_ioaddr0;
 	cs->hw.gazel.pciaddr[1] = pci_ioaddr1;
 	setup_isac(cs);
@@ -620,10 +607,10 @@ setup_gazelpci(struct IsdnCardState *cs)
 
 	return (0);
 }
-#endif /* CONFIG_PCI_LEGACY */
+#endif /* CONFIG_PCI */
 
-int __devinit
-setup_gazel(struct IsdnCard *card)
+static int __devinit
+setup_gazel_rest(struct IsdnCard *card)
 {
 	struct IsdnCardState *cs = card->cs;
 	char tmp[64];
@@ -632,23 +619,6 @@ setup_gazel(struct IsdnCard *card)
 	strcpy(tmp, gazel_revision);
 	printk(KERN_INFO "Gazel: Driver Revision %s\n", HiSax_getrev(tmp));
 
-	if (cs->typ != ISDN_CTYPE_GAZEL)
-		return (0);
-
-	if (card->para[0]) {
-		if (setup_gazelisa(card, cs))
-			return (0);
-	} else {
-
-#ifdef CONFIG_PCI_LEGACY
-		if (setup_gazelpci(cs))
-			return (0);
-#else
-		printk(KERN_WARNING "Gazel: Card PCI requested and NO_PCI_BIOS, unable to config\n");
-		return (0);
-#endif				/* CONFIG_PCI */
-	}
-
 	if (reserve_regions(card, cs)) {
 		return (0);
 	}
@@ -688,3 +658,163 @@ setup_gazel(struct IsdnCard *card)
 
 	return (1);
 }
+
+#ifdef CONFIG_ISA
+
+static int __devinit gazel_isa_setup(struct IsdnCard *card)
+{
+	struct IsdnCardState *cs = card->cs;
+
+	setup_gazelisa(card, cs);
+
+	return setup_gazel_rest(card);
+}
+
+static int __devinit gazel_isa_init_one(struct device *dev, unsigned int id)
+{
+	struct IsdnCard icard = { ISDN_CTYPE_GAZEL, };
+	int cardnr;
+
+	icard.para[0] = gazel_irq;
+	icard.para[1] = gazel_io_base;
+	if (!gazel_protocol)
+		icard.protocol = DEFAULT_PROTO;
+	else
+		icard.protocol = gazel_protocol;
+
+	cardnr = hisax_init_hotplug(&icard, gazel_isa_setup);
+	if (cardnr < 0)
+		return -ENODEV;
+	
+	dev_set_drvdata(dev, (void *)(unsigned long) cardnr);
+	return 0;
+}
+
+static int __devexit gazel_isa_remove_one(struct device *dev, unsigned int id)
+{
+	int cardnr = (unsigned long) dev_get_drvdata(dev);
+
+	HiSax_closecard(cardnr);
+	return 0;
+}
+
+static struct isa_driver gazel_isa_driver = {
+	.probe		= gazel_isa_init_one,
+	.remove		= __devexit_p(gazel_isa_remove_one),
+	.driver = {
+		.owner	= THIS_MODULE,
+		.name	= "gazel_pci",
+	},
+};
+
+#endif /* CONFIG_ISA */
+
+#ifdef CONFIG_PCI
+
+static int __devinit gazel_pci_setup(struct IsdnCard *card)
+{
+	if (setup_gazelpci(card))
+		return 1;	/* error */
+
+	return setup_gazel_rest(card);
+}
+
+static int __devinit gazel_pci_init_one(struct pci_dev *pdev,
+				      const struct pci_device_id *ent)
+{
+	struct IsdnCard icard = { ISDN_CTYPE_GAZEL, };
+	int cardnr;
+
+	icard.para[0] = (unsigned long) pdev;
+	if (!gazel_protocol)
+		icard.protocol = DEFAULT_PROTO;
+	else
+		icard.protocol = gazel_protocol;
+
+	cardnr = hisax_init_hotplug(&icard, gazel_pci_setup);
+	if (cardnr < 0)
+		return -ENODEV;
+	
+	pci_set_drvdata(pdev, (void *)(unsigned long) cardnr);
+	return 0;
+}
+
+static struct pci_device_id gazel_pci_table[] = {
+	{ PCI_VDEVICE(PLX, PCI_DEVICE_ID_PLX_R685) },
+	{ PCI_VDEVICE(PLX, PCI_DEVICE_ID_PLX_R753) },
+	{ PCI_VDEVICE(PLX, PCI_DEVICE_ID_PLX_DJINN_ITOO) },
+	{ PCI_VDEVICE(PLX, PCI_DEVICE_ID_PLX_OLITEC) },
+
+	{ }		/* terminate list */
+};
+
+static struct pci_driver gazel_pci_driver = {
+	.name		= "gazel_pci",
+	.id_table	= gazel_pci_table,
+	.probe		= gazel_pci_init_one,
+	.remove		= hisax_pci_remove_one,
+};
+
+#endif /* CONFIG_PCI */
+
+static int __init gazel_mod_init(void)
+{
+	int rc = 0;
+
+#ifdef CONFIG_ISA
+	if (gazel_irq && gazel_io_base) {
+		rc = isa_register_driver(&gazel_isa_driver, 1);
+		if (rc)
+			return rc;
+	}
+#endif /* CONFIG_ISA */
+
+#ifdef CONFIG_PCI
+	rc = pci_register_driver(&gazel_pci_driver);
+	if (rc)
+		goto err_out_isa;
+#endif /* CONFIG_PCI */
+
+	return 0;
+
+#ifdef CONFIG_PCI
+err_out_isa:
+
+#ifdef CONFIG_ISA
+	if (gazel_irq && gazel_io_base)
+		isa_unregister_driver(&gazel_isa_driver);
+#endif /* CONFIG_ISA */
+
+	return rc;
+#endif /* CONFIG_PCI */
+}
+
+static void __exit gazel_mod_exit(void)
+{
+#ifdef CONFIG_PCI
+	pci_unregister_driver(&gazel_pci_driver);
+#endif /* CONFIG_PCI */
+
+#ifdef CONFIG_ISA
+	if (gazel_irq && gazel_io_base)
+		isa_unregister_driver(&gazel_isa_driver);
+#endif /* CONFIG_ISA */
+}
+
+module_init(gazel_mod_init);
+module_exit(gazel_mod_exit);
+
+#ifdef CONFIG_ISA
+module_param_named(irq, gazel_irq, int, 0444);
+MODULE_PARM_DESC(irq, "ISA IRQ.  Zero disables ISA support (default).");
+
+module_param_named(io, gazel_io_base, int, 0444);
+MODULE_PARM_DESC(io, "ISA I/O base.  Zero disables ISA support (default).");
+#endif /* CONFIG_ISA */
+
+module_param_named(protocol, gazel_protocol, int, 0444);
+MODULE_PARM_DESC(protocol, "Values 0 (default) through 4. See ISDN_PTYPE_xxx in linux/isdnif.h");
+
+MODULE_DEVICE_TABLE(pci, gazel_pci_table);
+MODULE_DESCRIPTION("ISDN HiSax Gazel PCI/ISA driver");
+MODULE_LICENSE("GPL");
-- 
1.5.3.8

