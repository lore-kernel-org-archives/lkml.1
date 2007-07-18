Return-Path: <linux-kernel-owner+w=401wt.eu-S1764311AbYBNXmO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764311AbYBNXmO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 18:42:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762355AbYBNXkP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 18:40:15 -0500
Received: from havoc.gtf.org ([69.61.125.42]:52810 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760955AbYBNXkJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 18:40:09 -0500
Message-Id: <a73a5a9ab1ec204f77ff99677030b0d206c0abbb.1203031878.git.jeff@garzik.org>
In-Reply-To: <74fc75b3eadfa82aee70b855e9944b5439a259d5.1203031878.git.jeff@garzik.org>
References: <74fc75b3eadfa82aee70b855e9944b5439a259d5.1203031878.git.jeff@garzik.org>
From: Jeff Garzik <jeff@garzik.org>
To: linux-kernel@vger.kernel.org, kkeil@suse.de,
       isdn4linux@listserv.isdn4linux.de
Date: Tue, 17 Jul 2007 23:46:11 -0400
Subject: [PATCH 04/14] [ISDN] HiSax bkm_a4t: convert to PCI hotplug API
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jeff Garzik <jeff@garzik.org>
---
 drivers/isdn/hisax/Kconfig   |    4 +-
 drivers/isdn/hisax/Makefile  |    3 +-
 drivers/isdn/hisax/bkm_a4t.c |  115 ++++++++++++++++++++++++++++--------------
 drivers/isdn/hisax/config.c  |   27 ++++------
 4 files changed, 92 insertions(+), 57 deletions(-)

diff --git a/drivers/isdn/hisax/Kconfig b/drivers/isdn/hisax/Kconfig
index 7832d8b..e7808f5 100644
--- a/drivers/isdn/hisax/Kconfig
+++ b/drivers/isdn/hisax/Kconfig
@@ -286,8 +286,8 @@ config HISAX_HSTSAPHIR
 	  settings.
 
 config HISAX_BKM_A4T
-	bool "Telekom A4T card"
-	depends on PCI && PCI_LEGACY
+	tristate "Telekom A4T card"
+	depends on PCI
 	help
 	  This enables HiSax support for the Telekom A4T card.
 
diff --git a/drivers/isdn/hisax/Makefile b/drivers/isdn/hisax/Makefile
index b0b09e9..42bfc2f 100644
--- a/drivers/isdn/hisax/Makefile
+++ b/drivers/isdn/hisax/Makefile
@@ -15,7 +15,9 @@ obj-$(CONFIG_HISAX_ST5481)		+= hisax_st5481.o
 obj-$(CONFIG_HISAX_HFCUSB)		+= hfc_usb.o
 obj-$(CONFIG_HISAX_HFC4S8S)		+= hfc4s8s_l1.o
 obj-$(CONFIG_HISAX_FRITZ_PCIPNP)        += hisax_isac.o hisax_fcpcipnp.o
+obj-$(CONFIG_HISAX_BKM_A4T)		+= bkm_a4t_pci.o libhisax.o
 
+bkm_a4t_pci-objs			:= bkm_a4t.o jade.o
 libhisax-objs				:= netjet.o isac.o arcofi.o hscx.o
 
 ifdef CONFIG_HISAX_HDLC
@@ -56,7 +58,6 @@ hisax-$(CONFIG_HISAX_HFC_SX)		+= hfc_sx.o
 hisax-$(CONFIG_HISAX_NICCY)		+= niccy.o
 hisax-$(CONFIG_HISAX_ISURF)		+= isurf.o isar.o
 hisax-$(CONFIG_HISAX_HSTSAPHIR)		+= saphir.o
-hisax-$(CONFIG_HISAX_BKM_A4T)		+= bkm_a4t.o jade.o
 hisax-$(CONFIG_HISAX_SCT_QUADRO)	+= bkm_a8.o
 hisax-$(CONFIG_HISAX_GAZEL)		+= gazel.o
 hisax-$(CONFIG_HISAX_W6692)		+= w6692.o
diff --git a/drivers/isdn/hisax/bkm_a4t.c b/drivers/isdn/hisax/bkm_a4t.c
index 9ca2ee5..61eda77 100644
--- a/drivers/isdn/hisax/bkm_a4t.c
+++ b/drivers/isdn/hisax/bkm_a4t.c
@@ -13,6 +13,7 @@
 
 #include <linux/init.h>
 #include "hisax.h"
+#include "hisax_proto.h"
 #include "isac.h"
 #include "hscx.h"
 #include "jade.h"
@@ -20,6 +21,8 @@
 #include <linux/pci.h>
 #include "bkm_ax.h"
 
+static int a4t_protocol;		/* 0 == use DEFAULT_PROTO */
+
 static const char *bkm_a4t_revision = "$Revision: 1.22.2.4 $";
 
 
@@ -255,24 +258,21 @@ BKM_card_msg(struct IsdnCardState *cs, int mt, void *arg)
 
 static int __devinit a4t_pci_probe(struct pci_dev *dev_a4t,
 				   struct IsdnCardState *cs,
-				   u_int *found,
 				   u_int *pci_memaddr)
 {
-	u16 sub_sys;
-	u16 sub_vendor;
-
-	sub_vendor = dev_a4t->subsystem_vendor;
-	sub_sys = dev_a4t->subsystem_device;
-	if ((sub_sys == PCI_DEVICE_ID_BERKOM_A4T) && (sub_vendor == PCI_VENDOR_ID_BERKOM)) {
-		if (pci_enable_device(dev_a4t))
-			return (0);	/* end loop & function */
-		*found = 1;
-		*pci_memaddr = pci_resource_start(dev_a4t, 0);
-		cs->irq = dev_a4t->irq;
-		return (1);		/* end loop */
+	if (pci_enable_device(dev_a4t))
+		return (0);	/* error */
+
+	*pci_memaddr = pci_resource_start(dev_a4t, 0);
+	if (!(*pci_memaddr)) {
+		printk(KERN_WARNING "HiSax bkm_a4t: No Memory base address\n");
+		return (0);
 	}
 
-	return (-1);			/* continue looping */
+	cs->irq = dev_a4t->irq;
+
+	cs->hw.ax.dev = dev_a4t;
+	return (1);		/* success */
 }
 
 static int __devinit a4t_cs_init(struct IsdnCard *card,
@@ -323,40 +323,79 @@ static int __devinit a4t_cs_init(struct IsdnCard *card,
 	return (1);
 }
 
-static struct pci_dev *dev_a4t __devinitdata = NULL;
-
-int __devinit
+static int __devinit
 setup_bkm_a4t(struct IsdnCard *card)
 {
 	struct IsdnCardState *cs = card->cs;
 	char tmp[64];
-	u_int pci_memaddr = 0, found = 0;
+	u_int pci_memaddr = 0;
 	int ret;
+	struct pci_dev *dev_a4t = (void *) card->para[0];
 
 	strcpy(tmp, bkm_a4t_revision);
 	printk(KERN_INFO "HiSax: T-Berkom driver Rev. %s\n", HiSax_getrev(tmp));
-	if (cs->typ == ISDN_CTYPE_BKM_A4T) {
-		cs->subtyp = BKM_A4T;
-	} else
-		return (0);
 
-	while ((dev_a4t = pci_find_device(PCI_VENDOR_ID_ZORAN,
-		PCI_DEVICE_ID_ZORAN_36120, dev_a4t))) {
-		ret = a4t_pci_probe(dev_a4t, cs, &found, &pci_memaddr);
-		if (!ret)
-			return (0);
-		if (ret > 0)
-			break;
-	}
-	if (!found) {
-		printk(KERN_WARNING "HiSax: Telekom A4T: Card not found\n");
-		return (0);
-	}
-	if (!pci_memaddr) {
-		printk(KERN_WARNING "HiSax: Telekom A4T: "
-		       "No Memory base address\n");
+	WARN_ON(cs->typ != ISDN_CTYPE_BKM_A4T);
+
+	cs->subtyp = BKM_A4T;
+
+	ret = a4t_pci_probe(dev_a4t, cs, &pci_memaddr);
+	if (!ret)
 		return (0);
-	}
 
 	return a4t_cs_init(card, cs, pci_memaddr);
 }
+
+static int __devinit a4t_pci_init_one(struct pci_dev *pdev,
+				      const struct pci_device_id *ent)
+{
+	struct IsdnCard icard = { ISDN_CTYPE_BKM_A4T, };
+	int cardnr;
+
+	icard.para[0] = (unsigned long) pdev;
+	if (!a4t_protocol)
+		icard.protocol = DEFAULT_PROTO;
+	else
+		icard.protocol = a4t_protocol;
+
+	cardnr = hisax_init_hotplug(&icard, setup_bkm_a4t);
+	if (cardnr < 0)
+		return -ENODEV;
+	
+	pci_set_drvdata(pdev, (void *)(unsigned long) cardnr);
+	return 0;
+}
+
+static struct pci_device_id a4t_pci_table[] = {
+	{ PCI_VENDOR_ID_ZORAN, PCI_DEVICE_ID_ZORAN_36120,
+	  PCI_VENDOR_ID_BERKOM, PCI_DEVICE_ID_BERKOM_A4T, },
+
+	{ }		/* terminate list */
+};
+
+static struct pci_driver a4t_pci_driver = {
+	.name		= "bkm_a4t",
+	.id_table	= a4t_pci_table,
+	.probe		= a4t_pci_init_one,
+	.remove		= hisax_pci_remove_one,
+};
+
+static int __init a4t_mod_init(void)
+{
+	return pci_register_driver(&a4t_pci_driver);
+}
+
+static void __exit a4t_mod_exit(void)
+{
+	pci_unregister_driver(&a4t_pci_driver);
+}
+
+module_init(a4t_mod_init);
+module_exit(a4t_mod_exit);
+
+module_param_named(protocol, a4t_protocol, int, 0444);
+MODULE_PARM_DESC(protocol, "Values 0 (default) through 4. See ISDN_PTYPE_xxx in linux/isdnif.h");
+
+MODULE_DEVICE_TABLE(pci, a4t_pci_table);
+MODULE_DESCRIPTION("ISDN HiSax BKM A4T PCI driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/isdn/hisax/config.c b/drivers/isdn/hisax/config.c
index 6112013..7638cf5 100644
--- a/drivers/isdn/hisax/config.c
+++ b/drivers/isdn/hisax/config.c
@@ -250,13 +250,6 @@ const char *CardType[] = {
 #define DEFAULT_CFG {5,0x250,0,0}
 #endif
 
-#ifdef CONFIG_HISAX_BKM_A4T
-#undef DEFAULT_CARD
-#undef DEFAULT_CFG
-#define DEFAULT_CARD ISDN_CTYPE_BKM_A4T
-#define DEFAULT_CFG {0,0x0,0,0}
-#endif
-
 #ifdef CONFIG_HISAX_SCT_QUADRO
 #undef DEFAULT_CARD
 #undef DEFAULT_CFG
@@ -531,10 +524,6 @@ extern int setup_isurf(struct IsdnCard *card);
 extern int setup_saphir(struct IsdnCard *card);
 #endif
 
-#if CARD_BKM_A4T
-extern int setup_bkm_a4t(struct IsdnCard *card);
-#endif
-
 #if CARD_SCT_QUADRO
 extern int setup_sct_quadro(struct IsdnCard *card);
 #endif
@@ -954,11 +943,6 @@ static int __devinit hisax_cs_setup_card(struct IsdnCard *card)
 		ret = setup_saphir(card);
 		break;
 #endif
-#if	CARD_BKM_A4T
-	case ISDN_CTYPE_BKM_A4T:
-		ret = setup_bkm_a4t(card);
-		break;
-#endif
 #if	CARD_SCT_QUADRO
 	case ISDN_CTYPE_SCT_QUADRO:
 		ret = setup_sct_quadro(card);
@@ -987,6 +971,14 @@ static int __devinit hisax_cs_setup_card(struct IsdnCard *card)
 	case ISDN_CTYPE_DYNAMIC:
 		ret = 2;
 		break;
+
+	case ISDN_CTYPE_BKM_A4T:
+		printk(KERN_WARNING "HiSax: Support for %s Card has moved "
+		       "to separate PCI driver module\n",
+		       CardType[card->typ]);
+		ret = 0;
+		break;
+
 	default:
 		printk(KERN_WARNING
 		       "HiSax: Support for %s Card not selected\n",
@@ -1447,8 +1439,11 @@ static int __init HiSax_init(void)
 		case ISDN_CTYPE_W6692:
 		case ISDN_CTYPE_NETJET_U:
 			break;
+
+		/* the following block are excluded from std HiSax init */
 		case ISDN_CTYPE_BKM_A4T:
 			break;
+
 		case ISDN_CTYPE_SCT_QUADRO:
 			if (irq[i]) {
 				cards[j].para[0] = irq[i];
-- 
1.5.3.8

