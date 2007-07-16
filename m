Return-Path: <linux-kernel-owner+w=401wt.eu-S1764482AbXGPF3j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764482AbXGPF3j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 01:29:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754800AbXGPF33
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 01:29:29 -0400
Received: from havoc.gtf.org ([69.61.125.42]:60368 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751432AbXGPF32 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 01:29:28 -0400
Date: Mon, 16 Jul 2007 01:29:27 -0400
From: Jeff Garzik <jeff@garzik.org>
To: kkeil@suse.de, linux-kernel@vger.kernel.org,
       isdn4linux@listserv.isdn4linux.de
Cc: Andrew Morton <akpm@linux-foundation.org>, surya.prabhakar@wipro.com
Subject: [PATCH 7/7] HiSax hfc_pci: convert to PCI hotplug API
Message-ID: <20070716052927.GG21782@havoc.gtf.org>
References: <20070715095716.GA20949@havoc.gtf.org> <20070716052647.GA21782@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070716052647.GA21782@havoc.gtf.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


commit 823d1521c1059611542f60f55318422e9a47982f
Author: Jeff Garzik <jeff@garzik.org>
Date:   Sun Jul 15 22:12:35 2007 -0400

    [ISDN] HiSax: convert hfc_pci driver to PCI hotplug API
    
    Also, mark several setup functions in other already-converted drivers
    static.
    
    Signed-off-by: Jeff Garzik <jeff@garzik.org>

 drivers/isdn/hisax/Kconfig        |    2 
 drivers/isdn/hisax/Makefile       |    2 
 drivers/isdn/hisax/bkm_a4t.c      |    2 
 drivers/isdn/hisax/config.c       |   44 -----------
 drivers/isdn/hisax/enternow_pci.c |    2 
 drivers/isdn/hisax/hfc_pci.c      |  142 +++++++++++++++++++++++++++++---------
 drivers/isdn/hisax/nj_u.c         |    2 
 drivers/isdn/hisax/w6692.c        |    2 
 8 files changed, 118 insertions(+), 80 deletions(-)

823d1521c1059611542f60f55318422e9a47982f
diff --git a/drivers/isdn/hisax/Kconfig b/drivers/isdn/hisax/Kconfig
index 03e4ea5..aa3ba1d 100644
--- a/drivers/isdn/hisax/Kconfig
+++ b/drivers/isdn/hisax/Kconfig
@@ -316,7 +316,7 @@ config HISAX_GAZEL
 	  settings.
 
 config HISAX_HFC_PCI
-	bool "HFC PCI-Bus cards"
+	tristate "HFC PCI-Bus cards"
 	depends on PCI && (BROKEN || !(SPARC || PPC || PARISC || M68K || (MIPS && !CPU_LITTLE_ENDIAN) || FRV))
 	help
 	  This enables HiSax support for the HFC-S PCI 2BDS0 based cards.
diff --git a/drivers/isdn/hisax/Makefile b/drivers/isdn/hisax/Makefile
index 1f02120..d1b543c 100644
--- a/drivers/isdn/hisax/Makefile
+++ b/drivers/isdn/hisax/Makefile
@@ -20,6 +20,7 @@ obj-$(CONFIG_HISAX_NETJET_U)		+= netjet_u.o libhisax.o
 obj-$(CONFIG_HISAX_ENTERNOW_PCI)	+= enternow.o libhisax.o
 obj-$(CONFIG_HISAX_BKM_A4T)		+= bkm_a4t_pci.o libhisax.o
 obj-$(CONFIG_HISAX_W6692)		+= w6692.o libhisax.o
+obj-$(CONFIG_HISAX_HFC_PCI)		+= hfc_pci.o libhisax.o
 
 bkm_a4t_pci-objs			:= bkm_a4t.o jade.o
 enternow-objs				:= enternow_pci.o amd7930_fn.o
@@ -58,7 +59,6 @@ hisax-$(CONFIG_HISAX_SEDLBAUER)		+= sedlbauer.o hscx.o isar.o
 hisax-$(CONFIG_HISAX_SPORTSTER)		+= sportster.o hscx.o
 hisax-$(CONFIG_HISAX_MIC)		+= mic.o hscx.o
 hisax-$(CONFIG_HISAX_HFCS)		+= hfcscard.o hfc_2bds0.o
-hisax-$(CONFIG_HISAX_HFC_PCI)		+= hfc_pci.o
 hisax-$(CONFIG_HISAX_HFC_SX)		+= hfc_sx.o
 hisax-$(CONFIG_HISAX_NICCY)		+= niccy.o hscx.o
 hisax-$(CONFIG_HISAX_ISURF)		+= isurf.o sar.o
diff --git a/drivers/isdn/hisax/bkm_a4t.c b/drivers/isdn/hisax/bkm_a4t.c
index 918afb3..627547f 100644
--- a/drivers/isdn/hisax/bkm_a4t.c
+++ b/drivers/isdn/hisax/bkm_a4t.c
@@ -321,7 +321,7 @@ static int __devinit a4t_cs_init(struct IsdnCard *card,
 	return (1);
 }
 
-int __devinit
+static int __devinit
 setup_bkm_a4t(struct IsdnCard *card)
 {
 	struct IsdnCardState *cs = card->cs;
diff --git a/drivers/isdn/hisax/config.c b/drivers/isdn/hisax/config.c
index 163a636..3960233 100644
--- a/drivers/isdn/hisax/config.c
+++ b/drivers/isdn/hisax/config.c
@@ -208,13 +208,6 @@ const char *CardType[] = {
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
@@ -479,10 +472,6 @@ extern int setup_mic(struct IsdnCard *card);
 extern int setup_hfcs(struct IsdnCard *card);
 #endif
 
-#if CARD_HFC_PCI
-extern int setup_hfcpci(struct IsdnCard *card);
-#endif
-
 #if CARD_HFC_SX
 extern int setup_hfcsx(struct IsdnCard *card);
 #endif
@@ -876,11 +865,6 @@ static int hisax_cs_setup_card(struct IsdnCard *card)
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
@@ -921,6 +905,7 @@ static int hisax_cs_setup_card(struct IsdnCard *card)
 	case ISDN_CTYPE_ENTERNOW:
 	case ISDN_CTYPE_BKM_A4T:
 	case ISDN_CTYPE_W6692:
+	case ISDN_CTYPE_HFC_PCI:
 		printk(KERN_WARNING "HiSax: Support for %s Card has moved "
 		       "to separate PCI driver module\n",
 		       CardType[card->typ]);
@@ -1346,7 +1331,6 @@ static int __init HiSax_init(void)
 			break;
 #endif
 		case ISDN_CTYPE_ELSA:
-		case ISDN_CTYPE_HFC_PCI:
 			cards[j].para[0] = io[i];
 			break;
 		case ISDN_CTYPE_16_3:
@@ -1390,6 +1374,7 @@ static int __init HiSax_init(void)
 		case ISDN_CTYPE_ENTERNOW:
 		case ISDN_CTYPE_BKM_A4T:
 		case ISDN_CTYPE_W6692:
+		case ISDN_CTYPE_HFC_PCI:
 			break;
 
 		case ISDN_CTYPE_SCT_QUADRO:
@@ -1523,6 +1508,7 @@ EXPORT_SYMBOL(hisax_init_pcmcia);
 EXPORT_SYMBOL(hisax_init_hotplug);
 EXPORT_SYMBOL(HiSax_closecard);
 EXPORT_SYMBOL(HiSax_getrev);
+EXPORT_SYMBOL(HiSax_putstatus);
 
 #include "hisax_if.h"
 
@@ -1895,30 +1881,6 @@ static struct pci_device_id hisax_pci_tbl[] __devinitdata = {
 #if defined(CONFIG_HISAX_TELESPCI) || defined(CONFIG_HISAX_SCT_QUADRO)
 	{PCI_VENDOR_ID_ZORAN,    PCI_DEVICE_ID_ZORAN_36120,      PCI_ANY_ID,PCI_ANY_ID},
 #endif
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
 
diff --git a/drivers/isdn/hisax/enternow_pci.c b/drivers/isdn/hisax/enternow_pci.c
index 978b99a..b1c30b8 100644
--- a/drivers/isdn/hisax/enternow_pci.c
+++ b/drivers/isdn/hisax/enternow_pci.c
@@ -381,7 +381,7 @@ static int __devinit en_cs_init_rest(struct IsdnCard *card,
 }
 
 /* called by config.c */
-int __devinit
+static int __devinit
 setup_enternow_pci(struct IsdnCard *card)
 {
 	int ret;
diff --git a/drivers/isdn/hisax/hfc_pci.c b/drivers/isdn/hisax/hfc_pci.c
index 077080a..17e11b4 100644
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
diff --git a/drivers/isdn/hisax/nj_u.c b/drivers/isdn/hisax/nj_u.c
index 370535a..b8a536f 100644
--- a/drivers/isdn/hisax/nj_u.c
+++ b/drivers/isdn/hisax/nj_u.c
@@ -225,7 +225,7 @@ static int __devinit nju_cs_init_rest(struct IsdnCard *card,
 }
 
 
-int __devinit
+static int __devinit
 setup_netjet_u(struct IsdnCard *card)
 {
 	int ret;
diff --git a/drivers/isdn/hisax/w6692.c b/drivers/isdn/hisax/w6692.c
index 07d8e1e..f72c51b 100644
--- a/drivers/isdn/hisax/w6692.c
+++ b/drivers/isdn/hisax/w6692.c
@@ -995,7 +995,7 @@ w6692_card_msg(struct IsdnCardState *cs, int mt, void *arg)
 	return (0);
 }
 
-int __devinit
+static int __devinit
 setup_w6692(struct IsdnCard *card)
 {
 	struct IsdnCardState *cs = card->cs;
