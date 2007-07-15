Return-Path: <linux-kernel-owner+w=401wt.eu-S1760886AbXGOKB1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760886AbXGOKB1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 06:01:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760755AbXGOKBD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 06:01:03 -0400
Received: from havoc.gtf.org ([69.61.125.42]:57855 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760657AbXGOKBA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 06:01:00 -0400
Date: Sun, 15 Jul 2007 06:00:59 -0400
From: Jeff Garzik <jeff@garzik.org>
To: kkeil@suse.de, linux-kernel@vger.kernel.org,
       isdn4linux@listserv.isdn4linux.de
Cc: Andrew Morton <akpm@linux-foundation.org>, surya.prabhakar@wipro.com
Subject: [PATCH 5/5] HiSax netjet_s: convert to PCI hotplug API
Message-ID: <20070715100059.GE21220@havoc.gtf.org>
References: <20070715095716.GA20949@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070715095716.GA20949@havoc.gtf.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


commit c5e28e9c54de0b51a0b76fccf34aeea9654ed1bc
Author: Jeff Garzik <jeff@garzik.org>
Date:   Sun Jul 15 05:44:08 2007 -0400

    [ISDN] HiSax netjet_s: convert to PCI hotplug API

    [...and other stuff found during conversion... -jgarzik]
    
    Signed-off-by: Jeff Garzik <jeff@garzik.org>

 drivers/isdn/hisax/Kconfig       |    2 
 drivers/isdn/hisax/Makefile      |    2 
 drivers/isdn/hisax/config.c      |   53 ++++--------------
 drivers/isdn/hisax/hisax_proto.h |   25 ++++++++
 drivers/isdn/hisax/isac.c        |    6 ++
 drivers/isdn/hisax/isdnl1.c      |    2 
 drivers/isdn/hisax/netjet.c      |    9 +++
 drivers/isdn/hisax/nj_s.c        |  112 ++++++++++++++++++++++++++++-----------
 8 files changed, 141 insertions(+), 70 deletions(-)

c5e28e9c54de0b51a0b76fccf34aeea9654ed1bc
diff --git a/drivers/isdn/hisax/Kconfig b/drivers/isdn/hisax/Kconfig
index 12d91fb..38601b2 100644
--- a/drivers/isdn/hisax/Kconfig
+++ b/drivers/isdn/hisax/Kconfig
@@ -237,7 +237,7 @@ config HISAX_MIC
 	  settings.
 
 config HISAX_NETJET
-	bool "NETjet card"
+	tristate "NETjet card"
 	depends on PCI && (BROKEN || !(SPARC || PPC || PARISC || M68K || (MIPS && !CPU_LITTLE_ENDIAN) || FRV))
 	help
 	  This enables HiSax support for the NetJet from Traverse
diff --git a/drivers/isdn/hisax/Makefile b/drivers/isdn/hisax/Makefile
index c7a3794..bf57c43 100644
--- a/drivers/isdn/hisax/Makefile
+++ b/drivers/isdn/hisax/Makefile
@@ -15,6 +15,7 @@ obj-$(CONFIG_HISAX_ST5481)		+= hisax_st5481.o
 obj-$(CONFIG_HISAX_HFCUSB)		+= hfc_usb.o
 obj-$(CONFIG_HISAX_HFC4S8S)		+= hfc4s8s_l1.o
 obj-$(CONFIG_HISAX_FRITZ_PCIPNP)        += hisax_isac.o hisax_fcpcipnp.o
+obj-$(CONFIG_HISAX_NETJET)		+= nj_s.o # netjet.o isac.o arcofi.o
 
 ifdef CONFIG_HISAX_HDLC
 obj-$(CONFIG_ISDN_DRV_HISAX)		+= isdnhdlc.o
@@ -47,7 +48,6 @@ hisax-$(CONFIG_HISAX_SEDLBAUER)		+= sedlbauer.o isac.o arcofi.o hscx.o \
 					   isar.o
 hisax-$(CONFIG_HISAX_SPORTSTER)		+= sportster.o isac.o arcofi.o hscx.o
 hisax-$(CONFIG_HISAX_MIC)		+= mic.o isac.o arcofi.o hscx.o
-hisax-$(CONFIG_HISAX_NETJET)		+= nj_s.o netjet.o isac.o arcofi.o
 hisax-$(CONFIG_HISAX_NETJET_U)		+= nj_u.o netjet.o icc.o
 hisax-$(CONFIG_HISAX_HFCS)		+= hfcscard.o hfc_2bds0.o
 hisax-$(CONFIG_HISAX_HFC_PCI)		+= hfc_pci.o
diff --git a/drivers/isdn/hisax/config.c b/drivers/isdn/hisax/config.c
index e5c972b..f9abd8a 100644
--- a/drivers/isdn/hisax/config.c
+++ b/drivers/isdn/hisax/config.c
@@ -19,6 +19,7 @@
 #include <linux/timer.h>
 #include <linux/init.h>
 #include "hisax.h"
+#include "hisax_proto.h"
 #include <linux/module.h>
 #include <linux/kernel_stat.h>
 #include <linux/workqueue.h>
@@ -199,13 +200,6 @@ const char *CardType[] = {
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
@@ -283,26 +277,6 @@ const char *CardType[] = {
 #define DEFAULT_CFG {0,0,0,0}
 #endif
 
-#ifdef CONFIG_HISAX_1TR6
-#define DEFAULT_PROTO ISDN_PTYPE_1TR6
-#define DEFAULT_PROTO_NAME "1TR6"
-#endif
-#ifdef CONFIG_HISAX_NI1
-#undef DEFAULT_PROTO
-#define DEFAULT_PROTO ISDN_PTYPE_NI1
-#undef DEFAULT_PROTO_NAME
-#define DEFAULT_PROTO_NAME "NI1"
-#endif
-#ifdef CONFIG_HISAX_EURO
-#undef DEFAULT_PROTO
-#define DEFAULT_PROTO ISDN_PTYPE_EURO
-#undef DEFAULT_PROTO_NAME
-#define DEFAULT_PROTO_NAME "EURO"
-#endif
-#ifndef DEFAULT_PROTO
-#define DEFAULT_PROTO ISDN_PTYPE_UNKNOWN
-#define DEFAULT_PROTO_NAME "UNKNOWN"
-#endif
 #ifndef DEFAULT_CARD
 #define DEFAULT_CARD 0
 #define DEFAULT_CFG {0,0,0,0}
@@ -521,10 +495,6 @@ extern int setup_sportster(struct IsdnCard *card);
 extern int setup_mic(struct IsdnCard *card);
 #endif
 
-#if CARD_NETJET_S
-extern int setup_netjet_s(struct IsdnCard *card);
-#endif
-
 #if CARD_HFCS
 extern int setup_hfcs(struct IsdnCard *card);
 #endif
@@ -936,11 +906,6 @@ static int hisax_cs_setup_card(struct IsdnCard *card)
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
@@ -1005,6 +970,15 @@ static int hisax_cs_setup_card(struct IsdnCard *card)
 	case ISDN_CTYPE_DYNAMIC:
 		ret = 2;
 		break;
+
+	/* list of ISDN_CTYPE_xxx support moved to a modular driver */
+	case ISDN_CTYPE_NETJET_S:
+		printk(KERN_WARNING "HiSax: Support for %s Card has moved "
+		       "to separate PCI driver module\n",
+		       CardType[card->typ]);
+		ret = 0;
+		break;
+
 	default:
 		printk(KERN_WARNING
 		       "HiSax: Support for %s Card not selected\n",
@@ -1016,7 +990,7 @@ static int hisax_cs_setup_card(struct IsdnCard *card)
 	return ret;
 }
 
-static int hisax_cs_new(int cardnr, struct IsdnCard *card,
+static int hisax_cs_new(int cardnr, char *id, struct IsdnCard *card,
 			struct IsdnCardState **cs_out, int *busy_flag,
 			struct module *lockowner)
 {
@@ -1176,7 +1150,7 @@ static int checkcard(int cardnr, char *id, int *busy_flag,
 	struct IsdnCard *card = cards + cardnr;
 	struct IsdnCardState *cs;
 
-	ret = hisax_cs_new(cardnr, card, &cs, busy_flag, lockowner);
+	ret = hisax_cs_new(cardnr, id, card, &cs, busy_flag, lockowner);
 	if (!ret)
 		return 0;
 
@@ -1583,6 +1557,7 @@ error:
 EXPORT_SYMBOL(hisax_init_pcmcia);
 EXPORT_SYMBOL(hisax_init_hotplug);
 EXPORT_SYMBOL(HiSax_closecard);
+EXPORT_SYMBOL(HiSax_getrev);
 
 #include "hisax_if.h"
 
@@ -1952,7 +1927,7 @@ static struct pci_device_id hisax_pci_tbl[] __devinitdata = {
 #ifdef CONFIG_HISAX_SEDLBAUER
 	{PCI_VENDOR_ID_TIGERJET, PCI_DEVICE_ID_TIGERJET_100,     PCI_ANY_ID,PCI_ANY_ID},
 #endif
-#if defined(CONFIG_HISAX_NETJET) || defined(CONFIG_HISAX_NETJET_U)
+#if defined(CONFIG_HISAX_NETJET_U)
 	{PCI_VENDOR_ID_TIGERJET, PCI_DEVICE_ID_TIGERJET_300,     PCI_ANY_ID,PCI_ANY_ID},
 #endif
 #if defined(CONFIG_HISAX_TELESPCI) || defined(CONFIG_HISAX_SCT_QUADRO)
diff --git a/drivers/isdn/hisax/hisax_proto.h b/drivers/isdn/hisax/hisax_proto.h
new file mode 100644
index 0000000..7eea361
--- /dev/null
+++ b/drivers/isdn/hisax/hisax_proto.h
@@ -0,0 +1,25 @@
+#ifndef __ISDN_HISAX_HISAX_PROTO_H__
+#define __ISDN_HISAX_HISAX_PROTO_H__
+
+#ifdef CONFIG_HISAX_1TR6
+#define DEFAULT_PROTO ISDN_PTYPE_1TR6
+#define DEFAULT_PROTO_NAME "1TR6"
+#endif
+#ifdef CONFIG_HISAX_NI1
+#undef DEFAULT_PROTO
+#define DEFAULT_PROTO ISDN_PTYPE_NI1
+#undef DEFAULT_PROTO_NAME
+#define DEFAULT_PROTO_NAME "NI1"
+#endif
+#ifdef CONFIG_HISAX_EURO
+#undef DEFAULT_PROTO
+#define DEFAULT_PROTO ISDN_PTYPE_EURO
+#undef DEFAULT_PROTO_NAME
+#define DEFAULT_PROTO_NAME "EURO"
+#endif
+#ifndef DEFAULT_PROTO
+#define DEFAULT_PROTO ISDN_PTYPE_UNKNOWN
+#define DEFAULT_PROTO_NAME "UNKNOWN"
+#endif
+
+#endif /* __ISDN_HISAX_HISAX_PROTO_H__ */
diff --git a/drivers/isdn/hisax/isac.c b/drivers/isdn/hisax/isac.c
index 4e9f238..b919543 100644
--- a/drivers/isdn/hisax/isac.c
+++ b/drivers/isdn/hisax/isac.c
@@ -681,3 +681,9 @@ setup_isac(struct IsdnCardState *cs)
 	cs->dbusytimer.data = (long) cs;
 	init_timer(&cs->dbusytimer);
 }
+
+EXPORT_SYMBOL(isac_interrupt);
+EXPORT_SYMBOL(initisac);
+EXPORT_SYMBOL(clear_pending_isac_ints);
+EXPORT_SYMBOL(ISACVersion);
+EXPORT_SYMBOL(setup_isac);
diff --git a/drivers/isdn/hisax/isdnl1.c b/drivers/isdn/hisax/isdnl1.c
index a14204e..bcae2b0 100644
--- a/drivers/isdn/hisax/isdnl1.c
+++ b/drivers/isdn/hisax/isdnl1.c
@@ -933,3 +933,5 @@ setstack_l1_B(struct PStack *st)
 	st->l1.Flags = 0;
 	FsmInitTimer(&st->l1.l1m, &st->l1.timer);
 }
+
+EXPORT_SYMBOL(debugl1);
diff --git a/drivers/isdn/hisax/netjet.c b/drivers/isdn/hisax/netjet.c
index 02c6fba..1e3e45b 100644
--- a/drivers/isdn/hisax/netjet.c
+++ b/drivers/isdn/hisax/netjet.c
@@ -979,3 +979,12 @@ release_io_netjet(struct IsdnCardState *cs)
 	release_region(cs->hw.njet.base, 256);
 }
 
+EXPORT_SYMBOL(NETjet_WriteICfifo);
+EXPORT_SYMBOL(NETjet_ReadICfifo);
+EXPORT_SYMBOL(NETjet_WriteIC);
+EXPORT_SYMBOL(NETjet_ReadIC);
+EXPORT_SYMBOL(write_tiger);
+EXPORT_SYMBOL(read_tiger);
+EXPORT_SYMBOL(inittiger);
+EXPORT_SYMBOL(netjet_fill_dma);
+EXPORT_SYMBOL(release_io_netjet);
diff --git a/drivers/isdn/hisax/nj_s.c b/drivers/isdn/hisax/nj_s.c
index fa2db87..3779ccc 100644
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
 
+static int njs_protocol = 0;		/* 0 == use DEFAULT_PROTO */
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
@@ -235,8 +240,7 @@ static int __devinit njs_cs_init_rest(struct IsdnCard *card,
 		cs->subtyp ? "TJ320" : "TJ300", cs->hw.njet.base, cs->irq);
 	if (!request_region(cs->hw.njet.base, bytecnt, "netjet-s isdn")) {
 		printk(KERN_WARNING
-		       "HiSax: %s config port %#lx-%#lx already in use\n",
-		       CardType[card->typ],
+		       "HiSax: NETjet-S config port %#lx-%#lx already in use\n",
 		       cs->hw.njet.base,
 		       cs->hw.njet.base + bytecnt);
 		return (0);
@@ -257,43 +261,93 @@ static int __devinit njs_cs_init_rest(struct IsdnCard *card,
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
+static void __devexit njs_pci_remove_one(struct pci_dev *pdev)
+{
+	int cardnr = (unsigned long) pci_get_drvdata(pdev);
+
+	HiSax_closecard(cardnr);
+	pci_disable_device(pdev);
+	pci_set_drvdata(pdev, NULL);
+}
+
+static struct pci_device_id njs_pci_table[] = {
+	{ PCI_VDEVICE(TIGERJET, PCI_DEVICE_ID_TIGERJET_300) },
+
+	{ }		/* terminate list */
+};
+MODULE_DEVICE_TABLE(pci, njs_pci_table);
+
+static struct pci_driver njs_pci_driver = {
+	.name		= "nj_s",
+	.id_table	= njs_pci_table,
+	.probe		= njs_pci_init_one,
+	.remove		= njs_pci_remove_one,
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
+MODULE_DESCRIPTION("ISDN HiSax NETjet-S PCI driver");
+MODULE_LICENSE("GPL");
