Return-Path: <linux-kernel-owner+w=401wt.eu-S1759897AbYBPUbh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759897AbYBPUbh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 15:31:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759383AbYBPU3p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 15:29:45 -0500
Received: from havoc.gtf.org ([69.61.125.42]:37782 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757563AbYBPU3P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 15:29:15 -0500
Message-Id: <f9ffcffe4932720e4c8a2a2b7535156734496782.1203189978.git.jeff@garzik.org>
In-Reply-To: <167d76873c13943668c7f4443bfa60bb1552ecb2.1203189978.git.jeff@garzik.org>
References: <167d76873c13943668c7f4443bfa60bb1552ecb2.1203189978.git.jeff@garzik.org>
From: Jeff Garzik <jeff@garzik.org>
To: kkeil@suse.de, isdn4linux@listserv.isdn4linux.de,
       linux-kernel@vger.kernel.org
Date: Tue, 17 Jul 2007 23:59:48 -0400
Subject: [PATCH 07/14] [ISDN] HiSax nj_s, nj_u: convert to PCI hotplug API
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
---
 drivers/isdn/hisax/Kconfig  |    8 ++--
 drivers/isdn/hisax/Makefile |    6 ++-
 drivers/isdn/hisax/config.c |   41 ++----------------
 drivers/isdn/hisax/nj_s.c   |  100 +++++++++++++++++++++++++++++++------------
 drivers/isdn/hisax/nj_u.c   |   99 +++++++++++++++++++++++++++++++-----------
 5 files changed, 158 insertions(+), 96 deletions(-)

diff --git a/drivers/isdn/hisax/Kconfig b/drivers/isdn/hisax/Kconfig
index a37a616..508bc2b 100644
--- a/drivers/isdn/hisax/Kconfig
+++ b/drivers/isdn/hisax/Kconfig
@@ -236,8 +236,8 @@ config HISAX_MIC
 	  settings.
 
 config HISAX_NETJET
-	bool "NETjet card"
-	depends on PCI && PCI_LEGACY && (BROKEN || !(SPARC || PPC || PARISC || M68K || (MIPS && !CPU_LITTLE_ENDIAN) || FRV))
+	tristate "NETjet card"
+	depends on PCI && (BROKEN || !(SPARC || PPC || PARISC || M68K || (MIPS && !CPU_LITTLE_ENDIAN) || FRV))
 	help
 	  This enables HiSax support for the NetJet from Traverse
 	  Technologies.
@@ -247,8 +247,8 @@ config HISAX_NETJET
 	  settings.
 
 config HISAX_NETJET_U
-	bool "NETspider U card"
-	depends on PCI && PCI_LEGACY && (BROKEN || !(SPARC || PPC || PARISC || M68K || (MIPS && !CPU_LITTLE_ENDIAN) || FRV))
+	tristate "NETspider U card"
+	depends on PCI && (BROKEN || !(SPARC || PPC || PARISC || M68K || (MIPS && !CPU_LITTLE_ENDIAN) || FRV))
 	help
 	  This enables HiSax support for the Netspider U interface ISDN card
 	  from Traverse Technologies.
diff --git a/drivers/isdn/hisax/Makefile b/drivers/isdn/hisax/Makefile
index 4cfcaba..07aaba5 100644
--- a/drivers/isdn/hisax/Makefile
+++ b/drivers/isdn/hisax/Makefile
@@ -19,9 +19,13 @@ obj-$(CONFIG_HISAX_BKM_A4T)		+= bkm_a4t_pci.o libhisax.o
 obj-$(CONFIG_HISAX_ENTERNOW_PCI)	+= enternow.o libhisax.o
 obj-$(CONFIG_HISAX_HFC_PCI)		+= hfc_pci.o libhisax.o
 obj-$(CONFIG_HISAX_W6692)		+= w6692.o libhisax.o
+obj-$(CONFIG_HISAX_NETJET)		+= netjet_s.o libhisax.o
+obj-$(CONFIG_HISAX_NETJET_U)		+= netjet_u.o libhisax.o
 
 bkm_a4t_pci-y				:= bkm_a4t.o jade.o
 enternow-y				:= enternow_pci.o amd7930_fn.o
+netjet_s-y				:= nj_s.o
+netjet_u-y				:= nj_u.o icc.o
 libhisax-y				:= netjet.o isac.o arcofi.o hscx.o
 
 ifdef CONFIG_HISAX_HDLC
@@ -54,8 +58,6 @@ hisax-$(CONFIG_HISAX_TELEINT)		+= teleint.o hfc_2bs0.o
 hisax-$(CONFIG_HISAX_SEDLBAUER)		+= sedlbauer.o isar.o
 hisax-$(CONFIG_HISAX_SPORTSTER)		+= sportster.o
 hisax-$(CONFIG_HISAX_MIC)		+= mic.o
-hisax-$(CONFIG_HISAX_NETJET)		+= nj_s.o
-hisax-$(CONFIG_HISAX_NETJET_U)		+= nj_u.o icc.o
 hisax-$(CONFIG_HISAX_HFCS)		+= hfcscard.o hfc_2bds0.o
 hisax-$(CONFIG_HISAX_HFC_SX)		+= hfc_sx.o
 hisax-$(CONFIG_HISAX_NICCY)		+= niccy.o
diff --git a/drivers/isdn/hisax/config.c b/drivers/isdn/hisax/config.c
index a70e916..f35ceea 100644
--- a/drivers/isdn/hisax/config.c
+++ b/drivers/isdn/hisax/config.c
@@ -201,13 +201,6 @@ const char *CardType[] = {
 #define DEFAULT_CFG {12,0x3e0,0,0}
 #endif
 
-#ifdef CONFIG_HISAX_NETJET
-#undef DEFAULT_CARD
-#undef DEFAULT_CFG
-#define DEFAULT_CARD ISDN_CTYPE_NETJET_S
-#define DEFAULT_CFG {0,0,0,0}
-#endif
-
 #ifdef CONFIG_HISAX_HFCS
 #undef DEFAULT_CARD
 #undef DEFAULT_CFG
@@ -257,13 +250,6 @@ const char *CardType[] = {
 #define DEFAULT_CFG {15,0x180,0,0}
 #endif
 
-#ifdef CONFIG_HISAX_NETJET_U
-#undef DEFAULT_CARD
-#undef DEFAULT_CFG
-#define DEFAULT_CARD ISDN_CTYPE_NETJET_U
-#define DEFAULT_CFG {0,0,0,0}
-#endif
-
 #ifndef DEFAULT_CARD
 #define DEFAULT_CARD 0
 #define DEFAULT_CFG {0,0,0,0}
@@ -483,10 +469,6 @@ extern int setup_sportster(struct IsdnCard *card);
 extern int setup_mic(struct IsdnCard *card);
 #endif
 
-#if CARD_NETJET_S
-extern int setup_netjet_s(struct IsdnCard *card);
-#endif
-
 #if CARD_HFCS
 extern int setup_hfcs(struct IsdnCard *card);
 #endif
@@ -515,10 +497,6 @@ extern int setup_sct_quadro(struct IsdnCard *card);
 extern int setup_gazel(struct IsdnCard *card);
 #endif
 
-#if CARD_NETJET_U
-extern int setup_netjet_u(struct IsdnCard *card);
-#endif
-
 /*
  * Find card with given driverId
  */
@@ -883,11 +861,6 @@ static int __devinit hisax_cs_setup_card(struct IsdnCard *card)
 		ret = setup_mic(card);
 		break;
 #endif
-#if CARD_NETJET_S
-	case ISDN_CTYPE_NETJET_S:
-		ret = setup_netjet_s(card);
-		break;
-#endif
 #if CARD_HFCS
 	case ISDN_CTYPE_TELES3C:
 	case ISDN_CTYPE_ACERP10:
@@ -924,11 +897,6 @@ static int __devinit hisax_cs_setup_card(struct IsdnCard *card)
 		ret = setup_gazel(card);
 		break;
 #endif
-#if CARD_NETJET_U
-	case ISDN_CTYPE_NETJET_U:
-		ret = setup_netjet_u(card);
-		break;
-#endif
 	case ISDN_CTYPE_DYNAMIC:
 		ret = 2;
 		break;
@@ -937,6 +905,8 @@ static int __devinit hisax_cs_setup_card(struct IsdnCard *card)
 	case ISDN_CTYPE_ENTERNOW:
 	case ISDN_CTYPE_HFC_PCI:
 	case ISDN_CTYPE_W6692:
+	case ISDN_CTYPE_NETJET_S:
+	case ISDN_CTYPE_NETJET_U:
 		printk(KERN_WARNING "HiSax: Support for %s Card has moved "
 		       "to separate PCI driver module\n",
 		       CardType[card->typ]);
@@ -1398,9 +1368,7 @@ static int __init HiSax_init(void)
 			cards[j].para[2] = mem[i];
 			break;
 		case ISDN_CTYPE_ELSA_PCI:
-		case ISDN_CTYPE_NETJET_S:
 		case ISDN_CTYPE_TELESPCI:
-		case ISDN_CTYPE_NETJET_U:
 			break;
 
 		/* the following block are excluded from std HiSax init */
@@ -1408,6 +1376,8 @@ static int __init HiSax_init(void)
 		case ISDN_CTYPE_ENTERNOW:
 		case ISDN_CTYPE_HFC_PCI:
 		case ISDN_CTYPE_W6692:
+		case ISDN_CTYPE_NETJET_S:
+		case ISDN_CTYPE_NETJET_U:
 			break;
 
 		case ISDN_CTYPE_SCT_QUADRO:
@@ -1906,9 +1876,6 @@ static struct pci_device_id hisax_pci_tbl[] __devinitdata = {
 #ifdef CONFIG_HISAX_SEDLBAUER
 	{PCI_VENDOR_ID_TIGERJET, PCI_DEVICE_ID_TIGERJET_100,     PCI_ANY_ID,PCI_ANY_ID},
 #endif
-#if defined(CONFIG_HISAX_NETJET) || defined(CONFIG_HISAX_NETJET_U)
-	{PCI_VENDOR_ID_TIGERJET, PCI_DEVICE_ID_TIGERJET_300,     PCI_ANY_ID,PCI_ANY_ID},
-#endif
 #if defined(CONFIG_HISAX_TELESPCI) || defined(CONFIG_HISAX_SCT_QUADRO)
 	{PCI_VENDOR_ID_ZORAN,    PCI_DEVICE_ID_ZORAN_36120,      PCI_ANY_ID,PCI_ANY_ID},
 #endif
diff --git a/drivers/isdn/hisax/nj_s.c b/drivers/isdn/hisax/nj_s.c
index 8d36ccc..248ade2 100644
--- a/drivers/isdn/hisax/nj_s.c
+++ b/drivers/isdn/hisax/nj_s.c
@@ -7,6 +7,7 @@
 
 #include <linux/init.h>
 #include "hisax.h"
+#include "hisax_proto.h"
 #include "isac.h"
 #include "isdnl1.h"
 #include <linux/pci.h>
@@ -14,6 +15,8 @@
 #include <linux/ppp_defs.h>
 #include "netjet.h"
 
+static int njs_protocol;		/* 0 == use DEFAULT_PROTO */
+
 static const char *NETjet_S_revision = "$Revision: 2.13.2.4 $";
 
 static u_char dummyrr(struct IsdnCardState *cs, int chan, u_char off)
@@ -156,6 +159,8 @@ static int __devinit njs_pci_probe(struct pci_dev *dev_netjet,
 	if (pci_enable_device(dev_netjet))
 		return(0);
 	pci_set_master(dev_netjet);
+
+	cs->hw.njet.dev = dev_netjet;
 	cs->irq = dev_netjet->irq;
 	if (!cs->irq) {
 		printk(KERN_WARNING "NETjet-S: No IRQ for PCI card found\n");
@@ -212,17 +217,17 @@ static int __devinit njs_cs_init(struct IsdnCard *card,
 	switch ( ( ( NETjet_ReadIC( cs, ISAC_RBCH ) >> 5 ) & 3 ) )
 	{
 		case 0 :
-			return 1;	/* end loop */
+			return 1;	/* found card */
 
 		case 3 :
 			printk( KERN_WARNING "NETjet-S: NETspider-U PCI card found\n" );
-			return -1;	/* continue looping */
+			return 0;	/* no NETjet-S found */
 
 		default :
 			printk( KERN_WARNING "NETjet-S: No PCI card found\n" );
-			return 0;	/* end loop & function */
+			return 0;	/* no NETjet-S found */
 	}
-	return 1;			/* end loop */
+	return 1;			/* found card */
 }
 
 static int __devinit njs_cs_init_rest(struct IsdnCard *card,
@@ -256,43 +261,84 @@ static int __devinit njs_cs_init_rest(struct IsdnCard *card,
 	return (1);
 }
 
-static struct pci_dev *dev_netjet __devinitdata = NULL;
-
-int __devinit
+static int __devinit
 setup_netjet_s(struct IsdnCard *card)
 {
 	int ret;
 	struct IsdnCardState *cs = card->cs;
 	char tmp[64];
+	struct pci_dev *dev_netjet = (void *) card->para[0];
 
 #ifdef __BIG_ENDIAN
 #error "not running on big endian machines now"
 #endif
 	strcpy(tmp, NETjet_S_revision);
 	printk(KERN_INFO "HiSax: Traverse Tech. NETjet-S driver Rev. %s\n", HiSax_getrev(tmp));
-	if (cs->typ != ISDN_CTYPE_NETJET_S)
-		return(0);
+
+	WARN_ON(cs->typ != ISDN_CTYPE_NETJET_S);
+
 	test_and_clear_bit(FLG_LOCK_ATOMIC, &cs->HW_Flags);
 
-	for ( ;; )
-	{
-		if ((dev_netjet = pci_find_device(PCI_VENDOR_ID_TIGERJET,
-			PCI_DEVICE_ID_TIGERJET_300,  dev_netjet))) {
-			ret = njs_pci_probe(dev_netjet, cs);
-			if (!ret)
-				return(0);
-		} else {
-			printk(KERN_WARNING "NETjet-S: No PCI card found\n");
-			return(0);
-		}
+	ret = njs_pci_probe(dev_netjet, cs);
+	if (!ret)
+		return(0);
 
-		ret = njs_cs_init(card, cs);
-		if (!ret)
-			return(0);
-		if (ret > 0)
-			break;
-		/* otherwise, ret < 0, continue looping */
-	}
+	ret = njs_cs_init(card, cs);
+	if (ret <= 0)
+		return(0);
 
 	return njs_cs_init_rest(card, cs);
 }
+
+static int __devinit njs_pci_init_one(struct pci_dev *pdev,
+				      const struct pci_device_id *ent)
+{
+	struct IsdnCard icard = { ISDN_CTYPE_NETJET_S, };
+	int cardnr;
+
+	icard.para[0] = (unsigned long) pdev;
+	if (!njs_protocol)
+		icard.protocol = DEFAULT_PROTO;
+	else
+		icard.protocol = njs_protocol;
+
+	cardnr = hisax_init_hotplug(&icard, setup_netjet_s);
+	if (cardnr < 0)
+		return -ENODEV;
+
+	pci_set_drvdata(pdev, (void *)(unsigned long) cardnr);
+	return 0;
+}
+
+static struct pci_device_id njs_pci_table[] = {
+	{ PCI_VDEVICE(TIGERJET, PCI_DEVICE_ID_TIGERJET_300) },
+
+	{ }		/* terminate list */
+};
+
+static struct pci_driver njs_pci_driver = {
+	.name		= "nj_s",
+	.id_table	= njs_pci_table,
+	.probe		= njs_pci_init_one,
+	.remove		= hisax_pci_remove_one,
+};
+
+static int __init njs_mod_init(void)
+{
+	return pci_register_driver(&njs_pci_driver);
+}
+
+static void __exit njs_mod_exit(void)
+{
+	pci_unregister_driver(&njs_pci_driver);
+}
+
+module_init(njs_mod_init);
+module_exit(njs_mod_exit);
+
+module_param_named(protocol, njs_protocol, int, 0444);
+MODULE_PARM_DESC(protocol, "Values 0 (default) through 4. See ISDN_PTYPE_xxx in linux/isdnif.h");
+
+MODULE_DEVICE_TABLE(pci, njs_pci_table);
+MODULE_DESCRIPTION("ISDN HiSax NETjet-S PCI driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/isdn/hisax/nj_u.c b/drivers/isdn/hisax/nj_u.c
index d306c94..b1917d2 100644
--- a/drivers/isdn/hisax/nj_u.c
+++ b/drivers/isdn/hisax/nj_u.c
@@ -7,6 +7,7 @@
 
 #include <linux/init.h>
 #include "hisax.h"
+#include "hisax_proto.h"
 #include "icc.h"
 #include "isdnl1.h"
 #include <linux/pci.h>
@@ -14,6 +15,8 @@
 #include <linux/ppp_defs.h>
 #include "netjet.h"
 
+static int nju_protocol;	/* 0 == use DEFAULT_PROTO */
+
 static const char *NETjet_U_revision = "$Revision: 2.14.2.3 $";
 
 static u_char dummyrr(struct IsdnCardState *cs, int chan, u_char off)
@@ -133,7 +136,10 @@ static int __devinit nju_pci_probe(struct pci_dev *dev_netjet,
 {
 	if (pci_enable_device(dev_netjet))
 		return(0);
+
 	pci_set_master(dev_netjet);
+
+	cs->hw.njet.dev = dev_netjet;
 	cs->irq = dev_netjet->irq;
 	if (!cs->irq) {
 		printk(KERN_WARNING "NETspider-U: No IRQ for PCI card found\n");
@@ -174,17 +180,17 @@ static int __devinit nju_cs_init(struct IsdnCard *card,
 	switch ( ( ( NETjet_ReadIC( cs, ICC_RBCH ) >> 5 ) & 3 ) )
 	{
 		case 3 :
-			return 1;	/* end loop */
+			return 1;	/* found card */
 
 		case 0 :
 			printk( KERN_WARNING "NETspider-U: NETjet-S PCI card found\n" );
-			return -1;	/* continue looping */
+			return 0;	/* no NETjet-U found */
 
 		default :
 			printk( KERN_WARNING "NETspider-U: No PCI card found\n" );
-			return 0;	/* end loop & function */
+			return 0;	/* no NETjet-U found */
 	}
-	return 1;			/* end loop */
+	return 1;			/* found card */
 }
 
 static int __devinit nju_cs_init_rest(struct IsdnCard *card,
@@ -219,14 +225,14 @@ static int __devinit nju_cs_init_rest(struct IsdnCard *card,
 	return (1);
 }
 
-static struct pci_dev *dev_netjet __devinitdata = NULL;
 
-int __devinit
+static int __devinit
 setup_netjet_u(struct IsdnCard *card)
 {
 	int ret;
 	struct IsdnCardState *cs = card->cs;
 	char tmp[64];
+	struct pci_dev *dev_netjet = (void *) card->para[0];
 
 #ifdef __BIG_ENDIAN
 #error "not running on big endian machines now"
@@ -234,29 +240,70 @@ setup_netjet_u(struct IsdnCard *card)
 
 	strcpy(tmp, NETjet_U_revision);
 	printk(KERN_INFO "HiSax: Traverse Tech. NETspider-U driver Rev. %s\n", HiSax_getrev(tmp));
-	if (cs->typ != ISDN_CTYPE_NETJET_U)
-		return(0);
+
+	WARN_ON(cs->typ != ISDN_CTYPE_NETJET_U);
+
 	test_and_clear_bit(FLG_LOCK_ATOMIC, &cs->HW_Flags);
 
-	for ( ;; )
-	{
-		if ((dev_netjet = pci_find_device(PCI_VENDOR_ID_TIGERJET,
-			PCI_DEVICE_ID_TIGERJET_300,  dev_netjet))) {
-			ret = nju_pci_probe(dev_netjet, cs);
-			if (!ret)
-				return(0);
-		} else {
-			printk(KERN_WARNING "NETspider-U: No PCI card found\n");
-			return(0);
-		}
+	ret = nju_pci_probe(dev_netjet, cs);
+	if (!ret)
 
-		ret = nju_cs_init(card, cs);
-		if (!ret)
-			return (0);
-		if (ret > 0)
-			break;
-		/* ret < 0 == continue looping */
-	}
+	ret = nju_cs_init(card, cs);
+	if (!ret)
+		return (0);
 
 	return nju_cs_init_rest(card, cs);
 }
+
+static int __devinit nju_pci_init_one(struct pci_dev *pdev,
+				      const struct pci_device_id *ent)
+{
+	struct IsdnCard icard = { ISDN_CTYPE_NETJET_U, };
+	int cardnr;
+
+	icard.para[0] = (unsigned long) pdev;
+	if (!nju_protocol)
+		icard.protocol = DEFAULT_PROTO;
+	else
+		icard.protocol = nju_protocol;
+
+	cardnr = hisax_init_hotplug(&icard, setup_netjet_u);
+	if (cardnr < 0)
+		return -ENODEV;
+
+	pci_set_drvdata(pdev, (void *)(unsigned long) cardnr);
+	return 0;
+}
+
+static struct pci_device_id nju_pci_table[] = {
+	{ PCI_VDEVICE(TIGERJET, PCI_DEVICE_ID_TIGERJET_300) },
+
+	{ }		/* terminate list */
+};
+
+static struct pci_driver nju_pci_driver = {
+	.name		= "nj_u",
+	.id_table	= nju_pci_table,
+	.probe		= nju_pci_init_one,
+	.remove		= hisax_pci_remove_one,
+};
+
+static int __init nju_mod_init(void)
+{
+	return pci_register_driver(&nju_pci_driver);
+}
+
+static void __exit nju_mod_exit(void)
+{
+	pci_unregister_driver(&nju_pci_driver);
+}
+
+module_init(nju_mod_init);
+module_exit(nju_mod_exit);
+
+module_param_named(protocol, nju_protocol, int, 0444);
+MODULE_PARM_DESC(protocol, "Values 0 (default) through 4. See ISDN_PTYPE_xxx in linux/isdnif.h");
+
+MODULE_DEVICE_TABLE(pci, nju_pci_table);
+MODULE_DESCRIPTION("ISDN HiSax NETjet-U PCI driver");
+MODULE_LICENSE("GPL");
-- 
1.5.3.8

