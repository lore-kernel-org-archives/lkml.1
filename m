Return-Path: <linux-kernel-owner+w=401wt.eu-S1761596AbYBPUeX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761596AbYBPUeX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 15:34:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759717AbYBPU3z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 15:29:55 -0500
Received: from havoc.gtf.org ([69.61.125.42]:35436 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758896AbYBPU3Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 15:29:25 -0500
Message-Id: <d5735ebdee5ad127195d76aabfcdcf0c84f69e93.1203189978.git.jeff@garzik.org>
In-Reply-To: <167d76873c13943668c7f4443bfa60bb1552ecb2.1203189978.git.jeff@garzik.org>
References: <167d76873c13943668c7f4443bfa60bb1552ecb2.1203189978.git.jeff@garzik.org>
From: Jeff Garzik <jeff@garzik.org>
To: kkeil@suse.de, isdn4linux@listserv.isdn4linux.de,
       linux-kernel@vger.kernel.org
Date: Thu, 2 Aug 2007 08:37:15 -0400
Subject: [PATCH 14/14] [ISDN] HiSax bkm_a8: convert to PCI hotplug API
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
---
 drivers/isdn/hisax/Kconfig  |    4 +-
 drivers/isdn/hisax/Makefile |    2 +-
 drivers/isdn/hisax/bkm_a8.c |  186 +++++++++++++++++++++++++++++-------------
 drivers/isdn/hisax/config.c |   48 +-----------
 4 files changed, 133 insertions(+), 107 deletions(-)

diff --git a/drivers/isdn/hisax/Kconfig b/drivers/isdn/hisax/Kconfig
index 36af79f..8e18f7c 100644
--- a/drivers/isdn/hisax/Kconfig
+++ b/drivers/isdn/hisax/Kconfig
@@ -298,8 +298,8 @@ config HISAX_BKM_A4T
 	  settings.
 
 config HISAX_SCT_QUADRO
-	bool "Scitel Quadro card"
-	depends on PCI && PCI_LEGACY
+	tristate "Scitel Quadro card"
+	depends on PCI
 	help
 	  This enables HiSax support for the Scitel Quadro card.
 
diff --git a/drivers/isdn/hisax/Makefile b/drivers/isdn/hisax/Makefile
index bef1e0e..c63dba8 100644
--- a/drivers/isdn/hisax/Makefile
+++ b/drivers/isdn/hisax/Makefile
@@ -26,6 +26,7 @@ obj-$(CONFIG_HISAX_FRITZPCI)		+= avm_pci.o libhisax.o
 obj-$(CONFIG_HISAX_GAZEL)		+= gazel.o libhisax.o
 obj-$(CONFIG_HISAX_NICCY)		+= niccy.o libhisax.o
 obj-$(CONFIG_HISAX_DIEHLDIVA)		+= hisaxdiva.o libhisax.o
+obj-$(CONFIG_HISAX_SCT_QUADRO)		+= bkm_a8.o libhisax.o
 
 bkm_a4t_pci-y				:= bkm_a4t.o jade.o
 enternow-y				:= enternow_pci.o amd7930_fn.o
@@ -65,5 +66,4 @@ hisax-$(CONFIG_HISAX_HFCS)		+= hfcscard.o hfc_2bds0.o
 hisax-$(CONFIG_HISAX_HFC_SX)		+= hfc_sx.o
 hisax-$(CONFIG_HISAX_ISURF)		+= isurf.o isar.o
 hisax-$(CONFIG_HISAX_HSTSAPHIR)		+= saphir.o
-hisax-$(CONFIG_HISAX_SCT_QUADRO)	+= bkm_a8.o
 
diff --git a/drivers/isdn/hisax/bkm_a8.c b/drivers/isdn/hisax/bkm_a8.c
index e1ff471..575506c 100644
--- a/drivers/isdn/hisax/bkm_a8.c
+++ b/drivers/isdn/hisax/bkm_a8.c
@@ -13,6 +13,7 @@
 
 #include <linux/init.h>
 #include "hisax.h"
+#include "hisax_proto.h"
 #include "isac.h"
 #include "ipac.h"
 #include "hscx.h"
@@ -20,6 +21,8 @@
 #include <linux/pci.h>
 #include "bkm_ax.h"
 
+static int a8_protocol;		/* 0 == use DEFAULT_PROTO */
+
 #define	ATTEMPT_PCI_REMAPPING	/* Required for PLX rev 1 */
 
 static const char sct_quadro_revision[] = "$Revision: 1.22.2.4 $";
@@ -267,63 +270,23 @@ sct_alloc_io(u_int adr, u_int len)
 	return(0);
 }
 
-static struct pci_dev *dev_a8 __devinitdata = NULL;
-static u16  sub_vendor_id __devinitdata = 0;
-static u16  sub_sys_id __devinitdata = 0;
-static u_char pci_bus __devinitdata = 0;
-static u_char pci_device_fn __devinitdata = 0;
-static u_char pci_irq __devinitdata = 0;
-
-int __devinit
+static int __devinit
 setup_sct_quadro(struct IsdnCard *card)
 {
 	struct IsdnCardState *cs = card->cs;
+	u_int pci_ioaddr2, pci_ioaddr3, pci_ioaddr4, pci_ioaddr5;
 	char tmp[64];
-	u_int found = 0;
-	u_int pci_ioaddr1, pci_ioaddr2, pci_ioaddr3, pci_ioaddr4, pci_ioaddr5;
+	struct pci_dev *dev_a8 = (void *) card->para[1];
+	u_int pci_ioaddr1 = pci_resource_start(dev_a8, 1);
+	u_char pci_irq = dev_a8->irq;
 
 	strcpy(tmp, sct_quadro_revision);
 	printk(KERN_INFO "HiSax: T-Berkom driver Rev. %s\n", HiSax_getrev(tmp));
-	if (cs->typ == ISDN_CTYPE_SCT_QUADRO) {
-		cs->subtyp = SCT_1;	/* Preset */
-	} else
-		return (0);
 
-	/* Identify subtype by para[0] */
-	if (card->para[0] >= SCT_1 && card->para[0] <= SCT_4)
-		cs->subtyp = card->para[0];
-	else {
-		printk(KERN_WARNING "HiSax: Scitel Quadro: Invalid "
-		       "subcontroller in configuration, default to 1\n");
-		return (0);
-	}
-	if ((cs->subtyp != SCT_1) && ((sub_sys_id != PCI_DEVICE_ID_BERKOM_SCITEL_QUADRO) ||
-		(sub_vendor_id != PCI_VENDOR_ID_BERKOM)))
-		return (0);
+	cs->subtyp = card->para[0];
+
 	if (cs->subtyp == SCT_1) {
-		while ((dev_a8 = pci_find_device(PCI_VENDOR_ID_PLX,
-			PCI_DEVICE_ID_PLX_9050, dev_a8))) {
-			
-			sub_vendor_id = dev_a8->subsystem_vendor;
-			sub_sys_id = dev_a8->subsystem_device;
-			if ((sub_sys_id == PCI_DEVICE_ID_BERKOM_SCITEL_QUADRO) &&
-				(sub_vendor_id == PCI_VENDOR_ID_BERKOM)) {
-				if (pci_enable_device(dev_a8))
-					return(0);
-				pci_ioaddr1 = pci_resource_start(dev_a8, 1);
-				pci_irq = dev_a8->irq;
-				pci_bus = dev_a8->bus->number;
-				pci_device_fn = dev_a8->devfn;
-				found = 1;
-				break;
-			}
-		}
-		if (!found) {
-			printk(KERN_WARNING "HiSax: Scitel Quadro (%s): "
-				"Card not found\n",
-				sct_quadro_subtypes[cs->subtyp]);
-			return (0);
-		}
+
 #ifdef ATTEMPT_PCI_REMAPPING
 /* HACK: PLX revision 1 bug: PLX address bit 7 must not be set */
 		if ((pci_ioaddr1 & 0x80) && (dev_a8->revision == 1)) {
@@ -345,22 +308,19 @@ setup_sct_quadro(struct IsdnCard *card)
 		       sct_quadro_subtypes[cs->subtyp]);
 		return (0);
 	}
-	pci_read_config_dword(dev_a8, PCI_BASE_ADDRESS_1, &pci_ioaddr1);
-	pci_read_config_dword(dev_a8, PCI_BASE_ADDRESS_2, &pci_ioaddr2);
-	pci_read_config_dword(dev_a8, PCI_BASE_ADDRESS_3, &pci_ioaddr3);
-	pci_read_config_dword(dev_a8, PCI_BASE_ADDRESS_4, &pci_ioaddr4);
-	pci_read_config_dword(dev_a8, PCI_BASE_ADDRESS_5, &pci_ioaddr5);
+
+	pci_ioaddr2 = pci_resource_start(dev_a8, 2);
+	pci_ioaddr3 = pci_resource_start(dev_a8, 3);
+	pci_ioaddr4 = pci_resource_start(dev_a8, 4);
+	pci_ioaddr5 = pci_resource_start(dev_a8, 5);
+
 	if (!pci_ioaddr1 || !pci_ioaddr2 || !pci_ioaddr3 || !pci_ioaddr4 || !pci_ioaddr5) {
 		printk(KERN_WARNING "HiSax: Scitel Quadro (%s): "
 		       "No IO base address(es)\n",
 		       sct_quadro_subtypes[cs->subtyp]);
 		return (0);
 	}
-	pci_ioaddr1 &= PCI_BASE_ADDRESS_IO_MASK;
-	pci_ioaddr2 &= PCI_BASE_ADDRESS_IO_MASK;
-	pci_ioaddr3 &= PCI_BASE_ADDRESS_IO_MASK;
-	pci_ioaddr4 &= PCI_BASE_ADDRESS_IO_MASK;
-	pci_ioaddr5 &= PCI_BASE_ADDRESS_IO_MASK;
+
 	/* Take over */
 	cs->irq = pci_irq;
 	cs->irq_flags |= IRQF_SHARED;
@@ -433,3 +393,113 @@ setup_sct_quadro(struct IsdnCard *card)
 		readreg(cs->hw.ax.base, cs->hw.ax.data_adr, IPAC_ID));
 	return (1);
 }
+
+enum {
+	a8_bri_count	= 4,
+};
+
+struct a8_pci_bri {
+	int		cardnr;
+};
+
+struct a8_pci_info {
+	struct a8_pci_bri	bri[a8_bri_count];
+};
+
+static int __devinit a8_pci_init_one(struct pci_dev *pdev,
+				      const struct pci_device_id *ent)
+{
+	struct IsdnCard icard = { ISDN_CTYPE_SCT_QUADRO, };
+	int rc, i, found = 0;
+	struct a8_pci_info *api;
+
+	rc = pci_enable_device(pdev);
+	if (rc)
+		return rc;
+
+	api = kzalloc(sizeof(*api), GFP_KERNEL);
+	if (!api) {
+		rc = -ENOMEM;
+		goto err_out;
+	}
+
+	icard.para[1] = (unsigned long) pdev;
+	if (!a8_protocol)
+		icard.protocol = DEFAULT_PROTO;
+	else
+		icard.protocol = a8_protocol;
+
+	for (i = 0; i < a8_bri_count; i++) {
+		icard.para[0] = SCT_1 + i;
+		api->bri[i].cardnr =
+			hisax_init_hotplug(&icard, setup_sct_quadro);
+		if (api->bri[i].cardnr >= 0)
+			found = 1;
+	}
+
+	if (!found) {
+		rc = -ENODEV;
+		goto err_out_api;
+	}
+
+	pci_set_drvdata(pdev, api);
+	return 0;
+
+err_out_api:
+	kfree(api);
+err_out:
+	pci_disable_device(pdev);
+	return rc;
+}
+
+static void __devexit a8_pci_remove_one(struct pci_dev *pdev)
+{
+	struct a8_pci_info *api = pci_get_drvdata(pdev);
+	int i;
+
+	pci_set_drvdata(pdev, NULL);
+
+	for (i = 0; i < a8_bri_count; i++) {
+		struct a8_pci_bri *bri = &api->bri[i];
+
+		if (bri->cardnr >= 0)
+			HiSax_closecard(bri->cardnr);
+	}
+
+	kfree(api);
+	pci_disable_device(pdev);
+}
+
+static struct pci_device_id a8_pci_table[] = {
+	{ PCI_VENDOR_ID_PLX, PCI_DEVICE_ID_PLX_9050,
+	  PCI_VENDOR_ID_BERKOM, PCI_DEVICE_ID_BERKOM_SCITEL_QUADRO, },
+
+	{ }		/* terminate list */
+};
+
+static struct pci_driver a8_pci_driver = {
+	.name		= "bkm_a8",
+	.id_table	= a8_pci_table,
+	.probe		= a8_pci_init_one,
+	.remove		= __devexit_p(a8_pci_remove_one),
+};
+
+static int __init a8_mod_init(void)
+{
+	return pci_register_driver(&a8_pci_driver);
+}
+
+static void __exit a8_mod_exit(void)
+{
+	pci_unregister_driver(&a8_pci_driver);
+}
+
+module_init(a8_mod_init);
+module_exit(a8_mod_exit);
+
+module_param_named(protocol, a8_protocol, int, 0444);
+MODULE_PARM_DESC(protocol, "Values 0 (default) through 4. See ISDN_PTYPE_xxx in linux/isdnif.h");
+
+MODULE_DEVICE_TABLE(pci, a8_pci_table);
+MODULE_DESCRIPTION("ISDN HiSax BKM SCT QUADRO (A8) PCI driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/isdn/hisax/config.c b/drivers/isdn/hisax/config.c
index f7d0818..2aa435b 100644
--- a/drivers/isdn/hisax/config.c
+++ b/drivers/isdn/hisax/config.c
@@ -208,13 +208,6 @@ const char *CardType[] = {
 #define DEFAULT_CFG {5,0x250,0,0}
 #endif
 
-#ifdef CONFIG_HISAX_SCT_QUADRO
-#undef DEFAULT_CARD
-#undef DEFAULT_CFG
-#define DEFAULT_CARD ISDN_CTYPE_SCT_QUADRO
-#define DEFAULT_CFG {1,0x0,0,0}
-#endif
-
 #ifndef DEFAULT_CARD
 #define DEFAULT_CARD 0
 #define DEFAULT_CFG {0,0,0,0}
@@ -434,10 +427,6 @@ extern int setup_isurf(struct IsdnCard *card);
 extern int setup_saphir(struct IsdnCard *card);
 #endif
 
-#if CARD_SCT_QUADRO
-extern int setup_sct_quadro(struct IsdnCard *card);
-#endif
-
 /*
  * Find card with given driverId
  */
@@ -808,11 +797,6 @@ static int __devinit hisax_cs_setup_card(struct IsdnCard *card)
 		ret = setup_saphir(card);
 		break;
 #endif
-#if	CARD_SCT_QUADRO
-	case ISDN_CTYPE_SCT_QUADRO:
-		ret = setup_sct_quadro(card);
-		break;
-#endif
 	case ISDN_CTYPE_DYNAMIC:
 		ret = 2;
 		break;
@@ -828,6 +812,7 @@ static int __devinit hisax_cs_setup_card(struct IsdnCard *card)
 	case ISDN_CTYPE_GAZEL:
 	case ISDN_CTYPE_NICCY:
 	case ISDN_CTYPE_DIEHLDIVA:
+	case ISDN_CTYPE_SCT_QUADRO:
 		printk(KERN_WARNING "HiSax: Support for %s Card has moved "
 		       "to separate PCI driver module\n",
 		       CardType[card->typ]);
@@ -1299,32 +1284,9 @@ static int __init HiSax_init(void)
 		case ISDN_CTYPE_GAZEL:
 		case ISDN_CTYPE_NICCY:
 		case ISDN_CTYPE_DIEHLDIVA:
-			break;
-
 		case ISDN_CTYPE_SCT_QUADRO:
-			if (irq[i]) {
-				cards[j].para[0] = irq[i];
-			} else {
-				/* QUADRO is a 4 BRI card */
-				cards[j++].para[0] = 1;
-				/* we need to check if further cards can be added */
-				if (j < HISAX_MAX_CARDS) {
-					cards[j].typ = ISDN_CTYPE_SCT_QUADRO;
-					cards[j].protocol = protocol[i];
-					cards[j++].para[0] = 2;
-				}
-				if (j < HISAX_MAX_CARDS) {
-					cards[j].typ = ISDN_CTYPE_SCT_QUADRO;
-					cards[j].protocol = protocol[i];
-					cards[j++].para[0] = 3;
-				}
-				if (j < HISAX_MAX_CARDS) {
-					cards[j].typ = ISDN_CTYPE_SCT_QUADRO;
-					cards[j].protocol = protocol[i];
-					cards[j].para[0] = 4;
-				}
-			}
 			break;
+
 		}
 		j++;
 	}
@@ -1771,15 +1733,9 @@ static struct pci_device_id hisax_pci_tbl[] __devinitdata = {
 	{PCI_VENDOR_ID_ELSA,     PCI_DEVICE_ID_ELSA_MICROLINK,   PCI_ANY_ID, PCI_ANY_ID},
 	{PCI_VENDOR_ID_ELSA,     PCI_DEVICE_ID_ELSA_QS3000,      PCI_ANY_ID, PCI_ANY_ID},
 #endif
-#ifdef CONFIG_HISAX_SCT_QUADRO
-	{PCI_VENDOR_ID_PLX,      PCI_DEVICE_ID_PLX_9050,         PCI_ANY_ID, PCI_ANY_ID},
-#endif
 #ifdef CONFIG_HISAX_SEDLBAUER
 	{PCI_VENDOR_ID_TIGERJET, PCI_DEVICE_ID_TIGERJET_100,     PCI_ANY_ID,PCI_ANY_ID},
 #endif
-#if defined(CONFIG_HISAX_SCT_QUADRO)
-	{PCI_VENDOR_ID_ZORAN,    PCI_DEVICE_ID_ZORAN_36120,      PCI_ANY_ID,PCI_ANY_ID},
-#endif
 	{ }				/* Terminating entry */
 };
 
-- 
1.5.3.8

