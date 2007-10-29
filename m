Return-Path: <linux-kernel-owner+w=401wt.eu-S1754199AbXJ2Tkn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199AbXJ2Tkn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 15:40:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753179AbXJ2TjG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 15:39:06 -0400
Received: from havoc.gtf.org ([69.61.125.42]:42054 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752689AbXJ2TjE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 15:39:04 -0400
To: linux-kernel@vger.kernel.org, isdn4linux@listserv.isdn4linux.de
Message-Id: <0942c0b20424759ba2fc0376cc2d3573c96d46c8.1193686445.git.jeff@garzik.org>
In-Reply-To: <eb2aa159d7f722c61d637feb287bc0f2f9519b1d.1193686445.git.jeff@garzik.org>
References: <eb2aa159d7f722c61d637feb287bc0f2f9519b1d.1193686445.git.jeff@garzik.org>
From: Jeff Garzik <jeff@garzik.org>
Cc: kkeil@suse.de, akpm@linux-foundation.org
Subject: [PATCH 05/16] [ISDN] HiSax hfc_pci, w6692: convert to PCI hotplug API
Date: Mon, 29 Oct 2007 15:39:02 -0400 (EDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jeff Garzik <jeff@garzik.org>
---
 drivers/isdn/hisax/Kconfig   |    4 +-
 drivers/isdn/hisax/Makefile  |    4 +-
 drivers/isdn/hisax/config.c  |   66 +------------------
 drivers/isdn/hisax/hfc_pci.c |  142 ++++++++++++++++++++++++++++++++----------
 drivers/isdn/hisax/w6692.c   |  111 ++++++++++++++++++++++-----------
 5 files changed, 191 insertions(+), 136 deletions(-)

diff --git a/drivers/isdn/hisax/Kconfig b/drivers/isdn/hisax/Kconfig
index e2566b3..5c4343e 100644
--- a/drivers/isdn/hisax/Kconfig
+++ b/drivers/isdn/hisax/Kconfig
@@ -315,7 +315,7 @@ config HISAX_GAZEL
 	  settings.
 
 config HISAX_HFC_PCI
-	bool "HFC PCI-Bus cards"
+	tristate "HFC PCI-Bus cards"
 	depends on PCI && (BROKEN || !(SPARC || PPC || PARISC || M68K || (MIPS && !CPU_LITTLE_ENDIAN) || FRV))
 	help
 	  This enables HiSax support for the HFC-S PCI 2BDS0 based cards.
@@ -324,7 +324,7 @@ config HISAX_HFC_PCI
 	  <file:Documentation/isdn/README.hfc-pci>.
 
 config HISAX_W6692
-	bool "Winbond W6692 based cards"
+	tristate "Winbond W6692 based cards"
 	depends on PCI
 	help
 	  This enables HiSax support for Winbond W6692 based PCI ISDN cards.
diff --git a/drivers/isdn/hisax/Makefile b/drivers/isdn/hisax/Makefile
index c72fb28..c3e2ea2 100644
--- a/drivers/isdn/hisax/Makefile
+++ b/drivers/isdn/hisax/Makefile
@@ -17,6 +17,8 @@ obj-$(CONFIG_HISAX_HFC4S8S)		+= hfc4s8s_l1.o
 obj-$(CONFIG_HISAX_FRITZ_PCIPNP)        += hisax_isac.o hisax_fcpcipnp.o
 obj-$(CONFIG_HISAX_BKM_A4T)		+= bkm_a4t_pci.o libhisax.o
 obj-$(CONFIG_HISAX_ENTERNOW_PCI)	+= enternow.o libhisax.o
+obj-$(CONFIG_HISAX_HFC_PCI)		+= hfc_pci.o libhisax.o
+obj-$(CONFIG_HISAX_W6692)		+= w6692.o libhisax.o
 
 bkm_a4t_pci-objs			:= bkm_a4t.o jade.o
 enternow-objs				:= enternow_pci.o amd7930_fn.o
@@ -55,12 +57,10 @@ hisax-$(CONFIG_HISAX_MIC)		+= mic.o
 hisax-$(CONFIG_HISAX_NETJET)		+= nj_s.o
 hisax-$(CONFIG_HISAX_NETJET_U)		+= nj_u.o icc.o
 hisax-$(CONFIG_HISAX_HFCS)		+= hfcscard.o hfc_2bds0.o
-hisax-$(CONFIG_HISAX_HFC_PCI)		+= hfc_pci.o
 hisax-$(CONFIG_HISAX_HFC_SX)		+= hfc_sx.o
 hisax-$(CONFIG_HISAX_NICCY)		+= niccy.o
 hisax-$(CONFIG_HISAX_ISURF)		+= isurf.o isar.o
 hisax-$(CONFIG_HISAX_HSTSAPHIR)		+= saphir.o
 hisax-$(CONFIG_HISAX_SCT_QUADRO)	+= bkm_a8.o
 hisax-$(CONFIG_HISAX_GAZEL)		+= gazel.o
-hisax-$(CONFIG_HISAX_W6692)		+= w6692.o
 
diff --git a/drivers/isdn/hisax/config.c b/drivers/isdn/hisax/config.c
index c0f1993..afc43da 100644
--- a/drivers/isdn/hisax/config.c
+++ b/drivers/isdn/hisax/config.c
@@ -215,13 +215,6 @@ const char *CardType[] = {
 #define DEFAULT_CFG {5,0x500,0,0}
 #endif
 
-#ifdef CONFIG_HISAX_HFC_PCI
-#undef DEFAULT_CARD
-#undef DEFAULT_CFG
-#define DEFAULT_CARD ISDN_CTYPE_HFC_PCI
-#define DEFAULT_CFG {0,0,0,0}
-#endif
-
 #ifdef CONFIG_HISAX_HFC_SX
 #undef DEFAULT_CARD
 #undef DEFAULT_CFG
@@ -264,13 +257,6 @@ const char *CardType[] = {
 #define DEFAULT_CFG {15,0x180,0,0}
 #endif
 
-#ifdef CONFIG_HISAX_W6692
-#undef DEFAULT_CARD
-#undef DEFAULT_CFG
-#define DEFAULT_CARD ISDN_CTYPE_W6692
-#define DEFAULT_CFG {0,0,0,0}
-#endif
-
 #ifdef CONFIG_HISAX_NETJET_U
 #undef DEFAULT_CARD
 #undef DEFAULT_CFG
@@ -504,10 +490,6 @@ extern int setup_netjet_s(struct IsdnCard *card);
 extern int setup_hfcs(struct IsdnCard *card);
 #endif
 
-#if CARD_HFC_PCI
-extern int setup_hfcpci(struct IsdnCard *card);
-#endif
-
 #if CARD_HFC_SX
 extern int setup_hfcsx(struct IsdnCard *card);
 #endif
@@ -532,10 +514,6 @@ extern int setup_sct_quadro(struct IsdnCard *card);
 extern int setup_gazel(struct IsdnCard *card);
 #endif
 
-#if CARD_W6692
-extern int setup_w6692(struct IsdnCard *card);
-#endif
-
 #if CARD_NETJET_U
 extern int setup_netjet_u(struct IsdnCard *card);
 #endif
@@ -914,11 +892,6 @@ static int hisax_cs_setup_card(struct IsdnCard *card)
 		ret = setup_hfcs(card);
 		break;
 #endif
-#if CARD_HFC_PCI
-	case ISDN_CTYPE_HFC_PCI:
-		ret = setup_hfcpci(card);
-		break;
-#endif
 #if CARD_HFC_SX
 	case ISDN_CTYPE_HFC_SX:
 		ret = setup_hfcsx(card);
@@ -949,11 +922,6 @@ static int hisax_cs_setup_card(struct IsdnCard *card)
 		ret = setup_gazel(card);
 		break;
 #endif
-#if CARD_W6692
-	case ISDN_CTYPE_W6692:
-		ret = setup_w6692(card);
-		break;
-#endif
 #if CARD_NETJET_U
 	case ISDN_CTYPE_NETJET_U:
 		ret = setup_netjet_u(card);
@@ -965,6 +933,8 @@ static int hisax_cs_setup_card(struct IsdnCard *card)
 
 	case ISDN_CTYPE_BKM_A4T:
 	case ISDN_CTYPE_ENTERNOW:
+	case ISDN_CTYPE_HFC_PCI:
+	case ISDN_CTYPE_W6692:
 		printk(KERN_WARNING "HiSax: Support for %s Card has moved "
 		       "to separate PCI driver module\n",
 		       CardType[card->typ]);
@@ -1388,7 +1358,6 @@ static int __init HiSax_init(void)
 			break;
 #endif
 		case ISDN_CTYPE_ELSA:
-		case ISDN_CTYPE_HFC_PCI:
 			cards[j].para[0] = io[i];
 			break;
 		case ISDN_CTYPE_16_3:
@@ -1425,13 +1394,14 @@ static int __init HiSax_init(void)
 		case ISDN_CTYPE_ELSA_PCI:
 		case ISDN_CTYPE_NETJET_S:
 		case ISDN_CTYPE_TELESPCI:
-		case ISDN_CTYPE_W6692:
 		case ISDN_CTYPE_NETJET_U:
 			break;
 
 		/* the following block are excluded from std HiSax init */
 		case ISDN_CTYPE_BKM_A4T:
 		case ISDN_CTYPE_ENTERNOW:
+		case ISDN_CTYPE_HFC_PCI:
+		case ISDN_CTYPE_W6692:
 			break;
 
 		case ISDN_CTYPE_SCT_QUADRO:
@@ -1941,34 +1911,6 @@ static struct pci_device_id hisax_pci_tbl[] __devinitdata = {
 #if defined(CONFIG_HISAX_TELESPCI) || defined(CONFIG_HISAX_SCT_QUADRO)
 	{PCI_VENDOR_ID_ZORAN,    PCI_DEVICE_ID_ZORAN_36120,      PCI_ANY_ID,PCI_ANY_ID},
 #endif
-#ifdef CONFIG_HISAX_W6692
-	{PCI_VENDOR_ID_DYNALINK, PCI_DEVICE_ID_DYNALINK_IS64PH,  PCI_ANY_ID,PCI_ANY_ID},
-	{PCI_VENDOR_ID_WINBOND2, PCI_DEVICE_ID_WINBOND2_6692,    PCI_ANY_ID,PCI_ANY_ID},
-#endif
-#ifdef CONFIG_HISAX_HFC_PCI
-	{PCI_VENDOR_ID_CCD,      PCI_DEVICE_ID_CCD_2BD0,         PCI_ANY_ID, PCI_ANY_ID},
-	{PCI_VENDOR_ID_CCD,      PCI_DEVICE_ID_CCD_B000,         PCI_ANY_ID, PCI_ANY_ID},
-	{PCI_VENDOR_ID_CCD,      PCI_DEVICE_ID_CCD_B006,         PCI_ANY_ID, PCI_ANY_ID},
-	{PCI_VENDOR_ID_CCD,      PCI_DEVICE_ID_CCD_B007,         PCI_ANY_ID, PCI_ANY_ID},
-	{PCI_VENDOR_ID_CCD,      PCI_DEVICE_ID_CCD_B008,         PCI_ANY_ID, PCI_ANY_ID},
-	{PCI_VENDOR_ID_CCD,      PCI_DEVICE_ID_CCD_B009,         PCI_ANY_ID, PCI_ANY_ID},
-	{PCI_VENDOR_ID_CCD,      PCI_DEVICE_ID_CCD_B00A,         PCI_ANY_ID, PCI_ANY_ID},
-	{PCI_VENDOR_ID_CCD,      PCI_DEVICE_ID_CCD_B00B,         PCI_ANY_ID, PCI_ANY_ID},
-	{PCI_VENDOR_ID_CCD,      PCI_DEVICE_ID_CCD_B00C,         PCI_ANY_ID, PCI_ANY_ID},
-	{PCI_VENDOR_ID_CCD,      PCI_DEVICE_ID_CCD_B100,         PCI_ANY_ID, PCI_ANY_ID},
-	{PCI_VENDOR_ID_CCD,      PCI_DEVICE_ID_CCD_B700,         PCI_ANY_ID, PCI_ANY_ID},
-	{PCI_VENDOR_ID_CCD,      PCI_DEVICE_ID_CCD_B701,         PCI_ANY_ID, PCI_ANY_ID},
-	{PCI_VENDOR_ID_ABOCOM,   PCI_DEVICE_ID_ABOCOM_2BD1,      PCI_ANY_ID, PCI_ANY_ID},
-	{PCI_VENDOR_ID_ASUSTEK,  PCI_DEVICE_ID_ASUSTEK_0675,     PCI_ANY_ID, PCI_ANY_ID},
-	{PCI_VENDOR_ID_BERKOM,   PCI_DEVICE_ID_BERKOM_T_CONCEPT, PCI_ANY_ID, PCI_ANY_ID},
-	{PCI_VENDOR_ID_BERKOM,   PCI_DEVICE_ID_BERKOM_A1T,       PCI_ANY_ID, PCI_ANY_ID},
-	{PCI_VENDOR_ID_ANIGMA,   PCI_DEVICE_ID_ANIGMA_MC145575,  PCI_ANY_ID, PCI_ANY_ID},
-	{PCI_VENDOR_ID_ZOLTRIX,  PCI_DEVICE_ID_ZOLTRIX_2BD0,     PCI_ANY_ID, PCI_ANY_ID},
-	{PCI_VENDOR_ID_DIGI,     PCI_DEVICE_ID_DIGI_DF_M_IOM2_E, PCI_ANY_ID, PCI_ANY_ID},
-	{PCI_VENDOR_ID_DIGI,     PCI_DEVICE_ID_DIGI_DF_M_E,      PCI_ANY_ID, PCI_ANY_ID},
-	{PCI_VENDOR_ID_DIGI,     PCI_DEVICE_ID_DIGI_DF_M_IOM2_A, PCI_ANY_ID, PCI_ANY_ID},
-	{PCI_VENDOR_ID_DIGI,     PCI_DEVICE_ID_DIGI_DF_M_A,      PCI_ANY_ID, PCI_ANY_ID},
-#endif
 	{ }				/* Terminating entry */
 };
 
diff --git a/drivers/isdn/hisax/hfc_pci.c b/drivers/isdn/hisax/hfc_pci.c
index fba8b62..ce9e3e1 100644
--- a/drivers/isdn/hisax/hfc_pci.c
+++ b/drivers/isdn/hisax/hfc_pci.c
@@ -17,12 +17,13 @@
 
 #include <linux/init.h>
 #include "hisax.h"
+#include "hisax_proto.h"
 #include "hfc_pci.h"
 #include "isdnl1.h"
 #include <linux/pci.h>
 #include <linux/interrupt.h>
 
-extern const char *CardType[];
+static int hfc_protocol;		/* 0 == use DEFAULT_PROTO */
 
 static const char *hfcpci_revision = "$Revision: 1.48.2.4 $";
 
@@ -1632,18 +1633,14 @@ hfcpci_card_msg(struct IsdnCardState *cs, int mt, void *arg)
 	return (0);
 }
 
-
-/* this variable is used as card index when more than one cards are present */
-static struct pci_dev *dev_hfcpci __devinitdata = NULL;
-
-int __devinit
+static int __devinit
 setup_hfcpci(struct IsdnCard *card)
 {
 	u_long flags;
 	struct IsdnCardState *cs = card->cs;
 	char tmp[64];
-	int i;
-	struct pci_dev *tmp_hfcpci = NULL;
+	struct pci_dev *dev_hfcpci = (void *) card->para[0];
+	unsigned int idx = card->para[1];
 
 #ifdef __BIG_ENDIAN
 #error "not running on big endian machines now"
@@ -1655,33 +1652,12 @@ setup_hfcpci(struct IsdnCard *card)
 	cs->hw.hfcpci.int_s1 = 0;
 	cs->dc.hfcpci.ph_state = 0;
 	cs->hw.hfcpci.fifo = 255;
-	if (cs->typ != ISDN_CTYPE_HFC_PCI)
-		return(0);
-
-	i = 0;
-	while (id_list[i].vendor_id) {
-		tmp_hfcpci = pci_find_device(id_list[i].vendor_id,
-					     id_list[i].device_id,
-					     dev_hfcpci);
-		i++;
-		if (tmp_hfcpci) {
-			if (pci_enable_device(tmp_hfcpci))
-				continue;
-			pci_set_master(tmp_hfcpci);
-			if ((card->para[0]) && (card->para[0] != (tmp_hfcpci->resource[ 0].start & PCI_BASE_ADDRESS_IO_MASK)))
-				continue;
-			else
-				break;
-		}
-	}
+	WARN_ON(cs->typ != ISDN_CTYPE_HFC_PCI);
 
-	if (!tmp_hfcpci) {
-		printk(KERN_WARNING "HFC-PCI: No PCI card found\n");
+	if (pci_enable_device(dev_hfcpci))
 		return (0);
-	}
+	pci_set_master(dev_hfcpci);
 
-	i--;
-	dev_hfcpci = tmp_hfcpci;	/* old device */
 	cs->hw.hfcpci.dev = dev_hfcpci;
 	cs->irq = dev_hfcpci->irq;
 	if (!cs->irq) {
@@ -1689,7 +1665,8 @@ setup_hfcpci(struct IsdnCard *card)
 		return (0);
 	}
 	cs->hw.hfcpci.pci_io = (char *)(unsigned long)dev_hfcpci->resource[1].start;
-	printk(KERN_INFO "HiSax: HFC-PCI card manufacturer: %s card name: %s\n", id_list[i].vendor_name, id_list[i].card_name);
+	printk(KERN_INFO "HiSax: HFC-PCI card manufacturer: %s card name: %s\n",
+	       id_list[idx].vendor_name, id_list[idx].card_name);
 
 	if (!cs->hw.hfcpci.pci_io) {
 		printk(KERN_WARNING "HFC-PCI: No IO-Mem for PCI card found\n");
@@ -1744,3 +1721,102 @@ setup_hfcpci(struct IsdnCard *card)
 
 	return (1);
 }
+
+static int __devinit hfc_pci_init_one(struct pci_dev *pdev,
+				      const struct pci_device_id *ent)
+{
+	struct IsdnCard icard = { ISDN_CTYPE_HFC_PCI, };
+	int cardnr;
+
+	icard.para[0] = (unsigned long) pdev;
+	icard.para[1] = ent->driver_data;
+	if (!hfc_protocol)
+		icard.protocol = DEFAULT_PROTO;
+	else
+		icard.protocol = hfc_protocol;
+
+	cardnr = hisax_init_hotplug(&icard, setup_hfcpci);
+	if (cardnr < 0)
+		return -ENODEV;
+	
+	pci_set_drvdata(pdev, (void *)(unsigned long) cardnr);
+	return 0;
+}
+
+static struct pci_device_id hfc_pci_table[] = {
+	{ PCI_VENDOR_ID_CCD,      PCI_DEVICE_ID_CCD_2BD0,
+	  PCI_ANY_ID, PCI_ANY_ID, 0 },
+	{ PCI_VENDOR_ID_CCD,      PCI_DEVICE_ID_CCD_B000,
+	  PCI_ANY_ID, PCI_ANY_ID, 1 },
+	{ PCI_VENDOR_ID_CCD,      PCI_DEVICE_ID_CCD_B006,
+	  PCI_ANY_ID, PCI_ANY_ID, 2 },
+	{ PCI_VENDOR_ID_CCD,      PCI_DEVICE_ID_CCD_B007,
+	  PCI_ANY_ID, PCI_ANY_ID, 3 },
+	{ PCI_VENDOR_ID_CCD,      PCI_DEVICE_ID_CCD_B008,
+	  PCI_ANY_ID, PCI_ANY_ID, 4 },
+	{ PCI_VENDOR_ID_CCD,      PCI_DEVICE_ID_CCD_B009,
+	  PCI_ANY_ID, PCI_ANY_ID, 5 },
+	{ PCI_VENDOR_ID_CCD,      PCI_DEVICE_ID_CCD_B00A,
+	  PCI_ANY_ID, PCI_ANY_ID, 6 },
+	{ PCI_VENDOR_ID_CCD,      PCI_DEVICE_ID_CCD_B00B,
+	  PCI_ANY_ID, PCI_ANY_ID, 7 },
+	{ PCI_VENDOR_ID_CCD,      PCI_DEVICE_ID_CCD_B00C,
+	  PCI_ANY_ID, PCI_ANY_ID, 8 },
+	{ PCI_VENDOR_ID_CCD,      PCI_DEVICE_ID_CCD_B100,
+	  PCI_ANY_ID, PCI_ANY_ID, 9 },
+	{ PCI_VENDOR_ID_CCD,      PCI_DEVICE_ID_CCD_B700,
+	  PCI_ANY_ID, PCI_ANY_ID, 10 },
+	{ PCI_VENDOR_ID_CCD,      PCI_DEVICE_ID_CCD_B701,
+	  PCI_ANY_ID, PCI_ANY_ID, 11 },
+	{ PCI_VENDOR_ID_ABOCOM,   PCI_DEVICE_ID_ABOCOM_2BD1,
+	  PCI_ANY_ID, PCI_ANY_ID, 12 },
+	{ PCI_VENDOR_ID_ASUSTEK,  PCI_DEVICE_ID_ASUSTEK_0675,
+	  PCI_ANY_ID, PCI_ANY_ID, 13 },
+	{ PCI_VENDOR_ID_BERKOM,   PCI_DEVICE_ID_BERKOM_T_CONCEPT,
+	  PCI_ANY_ID, PCI_ANY_ID, 14 },
+	{ PCI_VENDOR_ID_BERKOM,   PCI_DEVICE_ID_BERKOM_A1T,
+	  PCI_ANY_ID, PCI_ANY_ID, 15 },
+	{ PCI_VENDOR_ID_ANIGMA,   PCI_DEVICE_ID_ANIGMA_MC145575,
+	  PCI_ANY_ID, PCI_ANY_ID, 16 },
+	{ PCI_VENDOR_ID_ZOLTRIX,  PCI_DEVICE_ID_ZOLTRIX_2BD0,
+	  PCI_ANY_ID, PCI_ANY_ID, 17 },
+	{ PCI_VENDOR_ID_DIGI,     PCI_DEVICE_ID_DIGI_DF_M_IOM2_E,
+	  PCI_ANY_ID, PCI_ANY_ID, 18 },
+	{ PCI_VENDOR_ID_DIGI,     PCI_DEVICE_ID_DIGI_DF_M_E,
+	  PCI_ANY_ID, PCI_ANY_ID, 19 },
+	{ PCI_VENDOR_ID_DIGI,     PCI_DEVICE_ID_DIGI_DF_M_IOM2_A,
+	  PCI_ANY_ID, PCI_ANY_ID, 20 },
+	{ PCI_VENDOR_ID_DIGI,     PCI_DEVICE_ID_DIGI_DF_M_A,
+	  PCI_ANY_ID, PCI_ANY_ID, 21 },
+	{ PCI_VENDOR_ID_SITECOM, PCI_DEVICE_ID_SITECOM_DC105V2,
+	  PCI_ANY_ID, PCI_ANY_ID, 22 },
+
+	{ }		/* terminate list */
+};
+
+static struct pci_driver hfc_pci_driver = {
+	.name		= "hfc_pci",
+	.id_table	= hfc_pci_table,
+	.probe		= hfc_pci_init_one,
+	.remove		= hisax_pci_remove_one,
+};
+
+static int __init hfc_mod_init(void)
+{
+	return pci_register_driver(&hfc_pci_driver);
+}
+
+static void __exit hfc_mod_exit(void)
+{
+	pci_unregister_driver(&hfc_pci_driver);
+}
+
+module_init(hfc_mod_init);
+module_exit(hfc_mod_exit);
+
+module_param_named(protocol, hfc_protocol, int, 0444);
+MODULE_PARM_DESC(protocol, "Values 0 (default) through 4. See ISDN_PTYPE_xxx in linux/isdnif.h");
+
+MODULE_DEVICE_TABLE(pci, hfc_pci_table);
+MODULE_DESCRIPTION("ISDN HiSax HFC PCI driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/isdn/hisax/w6692.c b/drivers/isdn/hisax/w6692.c
index 39129b9..f72c51b 100644
--- a/drivers/isdn/hisax/w6692.c
+++ b/drivers/isdn/hisax/w6692.c
@@ -12,11 +12,14 @@
 
 #include <linux/init.h>
 #include "hisax.h"
+#include "hisax_proto.h"
 #include "w6692.h"
 #include "isdnl1.h"
 #include <linux/interrupt.h>
 #include <linux/pci.h>
 
+static int w6692_protocol;		/* 0 == use DEFAULT_PROTO */
+
 /* table entry in the PCI devices list */
 typedef struct {
 	int vendor_id;
@@ -992,54 +995,29 @@ w6692_card_msg(struct IsdnCardState *cs, int mt, void *arg)
 	return (0);
 }
 
-static int id_idx ;
-
-static struct pci_dev *dev_w6692 __devinitdata = NULL;
-
-int __devinit
+static int __devinit
 setup_w6692(struct IsdnCard *card)
 {
 	struct IsdnCardState *cs = card->cs;
 	char tmp[64];
-	u_char found = 0;
 	u_char pci_irq = 0;
 	u_int pci_ioaddr = 0;
+	struct pci_dev *dev_w6692 = (void *) card->para[0];
 
 	strcpy(tmp, w6692_revision);
 	printk(KERN_INFO "HiSax: W6692 driver Rev. %s\n", HiSax_getrev(tmp));
-	if (cs->typ != ISDN_CTYPE_W6692)
-		return (0);
+	WARN_ON(cs->typ != ISDN_CTYPE_W6692);
 
-	while (id_list[id_idx].vendor_id) {
-		dev_w6692 = pci_find_device(id_list[id_idx].vendor_id,
-					    id_list[id_idx].device_id,
-					    dev_w6692);
-		if (dev_w6692) {
-			if (pci_enable_device(dev_w6692))
-				continue;
-			cs->subtyp = id_idx;
-			break;
-		}
-		id_idx++;
-	}
-	if (dev_w6692) {
-		found = 1;
-		pci_irq = dev_w6692->irq;
-		/* I think address 0 is allways the configuration area */
-		/* and address 1 is the real IO space KKe 03.09.99 */
-		pci_ioaddr = pci_resource_start(dev_w6692, 1);
-		/* USR ISDN PCI card TA need some special handling */
-		if (cs->subtyp == W6692_WINBOND) {
-			if ((W6692_SV_USR == dev_w6692->subsystem_vendor) &&
-			    (W6692_SD_USR == dev_w6692->subsystem_device)) {
-				cs->subtyp = W6692_USR;
-			}
-		}
-	}
-	if (!found) {
-		printk(KERN_WARNING "W6692: No PCI card found\n");
+	if (pci_enable_device(dev_w6692))
 		return (0);
-	}
+
+	cs->subtyp = card->para[1];
+
+	pci_irq = dev_w6692->irq;
+	/* I think address 0 is allways the configuration area */
+	/* and address 1 is the real IO space KKe 03.09.99 */
+	pci_ioaddr = pci_resource_start(dev_w6692, 1);
+
 	cs->irq = pci_irq;
 	if (!cs->irq) {
 		printk(KERN_WARNING "W6692: No IRQ for PCI card found\n");
@@ -1086,3 +1064,62 @@ setup_w6692(struct IsdnCard *card)
 	printk(KERN_INFO "W6692 D_RSTA=0x%X\n", ReadW6692(cs, W_D_RSTA));
 	return (1);
 }
+
+static int __devinit w6692_pci_init_one(struct pci_dev *pdev,
+				      const struct pci_device_id *ent)
+{
+	struct IsdnCard icard = { ISDN_CTYPE_W6692, };
+	int cardnr;
+
+	icard.para[0] = (unsigned long) pdev;
+	icard.para[1] = ent->driver_data;
+	if (!w6692_protocol)
+		icard.protocol = DEFAULT_PROTO;
+	else
+		icard.protocol = w6692_protocol;
+
+	cardnr = hisax_init_hotplug(&icard, setup_w6692);
+	if (cardnr < 0)
+		return -ENODEV;
+	
+	pci_set_drvdata(pdev, (void *)(unsigned long) cardnr);
+	return 0;
+}
+
+static struct pci_device_id w6692_pci_table[] = {
+	{ PCI_VENDOR_ID_DYNALINK, PCI_DEVICE_ID_DYNALINK_IS64PH,
+	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, W6692_DYNALINK },
+	{ PCI_VENDOR_ID_WINBOND2, PCI_DEVICE_ID_WINBOND2_6692,
+	  W6692_SV_USR, W6692_SD_USR, 0, 0, W6692_USR },
+	{ PCI_VENDOR_ID_WINBOND2, PCI_DEVICE_ID_WINBOND2_6692,
+	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, W6692_WINBOND },
+
+	{ }		/* terminate list */
+};
+
+static struct pci_driver w6692_pci_driver = {
+	.name		= "w6692",
+	.id_table	= w6692_pci_table,
+	.probe		= w6692_pci_init_one,
+	.remove		= hisax_pci_remove_one,
+};
+
+static int __init w6692_mod_init(void)
+{
+	return pci_register_driver(&w6692_pci_driver);
+}
+
+static void __exit w6692_mod_exit(void)
+{
+	pci_unregister_driver(&w6692_pci_driver);
+}
+
+module_init(w6692_mod_init);
+module_exit(w6692_mod_exit);
+
+module_param_named(protocol, w6692_protocol, int, 0444);
+MODULE_PARM_DESC(protocol, "Values 0 (default) through 4. See ISDN_PTYPE_xxx in linux/isdnif.h");
+
+MODULE_DEVICE_TABLE(pci, w6692_pci_table);
+MODULE_DESCRIPTION("ISDN HiSax W6692 PCI driver");
+MODULE_LICENSE("GPL");
-- 
1.5.2.4

