Return-Path: <linux-kernel-owner+w=401wt.eu-S1758185AbXGOVmG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758185AbXGOVmG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 17:42:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752636AbXGOVly
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 17:41:54 -0400
Received: from havoc.gtf.org ([69.61.125.42]:59427 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752841AbXGOVlx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 17:41:53 -0400
Date: Sun, 15 Jul 2007 17:41:52 -0400
From: Jeff Garzik <jeff@garzik.org>
To: kkeil@suse.de, linux-kernel@vger.kernel.org,
       isdn4linux@listserv.isdn4linux.de
Cc: Andrew Morton <akpm@linux-foundation.org>, surya.prabhakar@wipro.com
Subject: [PATCH 2/2] HiSax netjet_u: convert to PCI hotplug API
Message-ID: <20070715214152.GB9702@havoc.gtf.org>
References: <20070715095716.GA20949@havoc.gtf.org> <20070715214030.GA9702@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070715214030.GA9702@havoc.gtf.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


commit 6aea604ccf18368d9f9dedabfe00404c6289c8a4
Author: Jeff Garzik <jeff@garzik.org>
Date:   Sun Jul 15 17:37:10 2007 -0400

    [ISDN] HiSax: convert NETjet-U to PCI hotplug API; further HiSax libificatio
    
    1) Using previous nj_u code movement, we can easily convert it to the
    hotplug API similar to nj_s.
    
    2) Additional HiSax exports and cleanups found during this work, most
    notably the creation of a sister kernel module libhisax.ko.  libhisax
    creation is solely managed through the Makefile.

    [NOTE: changes in #2 should be "moved up" in the patch series -jg]
    
    Signed-off-by: Jeff Garzik <jeff@garzik.org>
---

 drivers/isdn/hisax/Kconfig     |    2 
 drivers/isdn/hisax/Makefile    |   53 +++++++++++----------
 drivers/isdn/hisax/config.c    |   40 ++++++++--------
 drivers/isdn/hisax/hisax_cfg.h |    2 
 drivers/isdn/hisax/isdnl1.c    |    8 ++-
 drivers/isdn/hisax/nj_s.c      |   13 -----
 drivers/isdn/hisax/nj_u.c      |  100 +++++++++++++++++++++++++++++------------
 drivers/isdn/hisax/q931.c      |    4 +
 8 files changed, 137 insertions(+), 85 deletions(-)

6aea604ccf18368d9f9dedabfe00404c6289c8a4
diff --git a/drivers/isdn/hisax/Kconfig b/drivers/isdn/hisax/Kconfig
index 38601b2..1da3cd6 100644
--- a/drivers/isdn/hisax/Kconfig
+++ b/drivers/isdn/hisax/Kconfig
@@ -248,7 +248,7 @@ config HISAX_NETJET
 	  settings.
 
 config HISAX_NETJET_U
-	bool "NETspider U card"
+	tristate "NETspider U card"
 	depends on PCI && (BROKEN || !(SPARC || PPC || PARISC || M68K || (MIPS && !CPU_LITTLE_ENDIAN) || FRV))
 	help
 	  This enables HiSax support for the Netspider U interface ISDN card
diff --git a/drivers/isdn/hisax/Makefile b/drivers/isdn/hisax/Makefile
index bf57c43..a37e211 100644
--- a/drivers/isdn/hisax/Makefile
+++ b/drivers/isdn/hisax/Makefile
@@ -6,7 +6,7 @@
 
 EXTRA_CFLAGS      += -DHISAX_MAX_CARDS=$(CONFIG_HISAX_MAX_CARDS)
 
-obj-$(CONFIG_ISDN_DRV_HISAX)		+= hisax.o
+obj-$(CONFIG_ISDN_DRV_HISAX)		+= hisax.o libhisax.o
 obj-$(CONFIG_HISAX_SEDLBAUER_CS)	+= sedlbauer_cs.o
 obj-$(CONFIG_HISAX_ELSA_CS)		+= elsa_cs.o
 obj-$(CONFIG_HISAX_AVM_A1_CS)		+= avma1_cs.o
@@ -15,7 +15,12 @@ obj-$(CONFIG_HISAX_ST5481)		+= hisax_st5481.o
 obj-$(CONFIG_HISAX_HFCUSB)		+= hfc_usb.o
 obj-$(CONFIG_HISAX_HFC4S8S)		+= hfc4s8s_l1.o
 obj-$(CONFIG_HISAX_FRITZ_PCIPNP)        += hisax_isac.o hisax_fcpcipnp.o
-obj-$(CONFIG_HISAX_NETJET)		+= nj_s.o # netjet.o isac.o arcofi.o
+obj-$(CONFIG_HISAX_NETJET)		+= netjet_s.o libhisax.o
+obj-$(CONFIG_HISAX_NETJET_U)		+= netjet_u.o libhisax.o
+
+netjet_s-objs				:= nj_s.o
+netjet_u-objs				:= nj_u.o icc.o
+libhisax-objs				:= netjet.o isac.o arcofi.o
 
 ifdef CONFIG_HISAX_HDLC
 obj-$(CONFIG_ISDN_DRV_HISAX)		+= isdnhdlc.o
@@ -32,32 +37,30 @@ hisax-$(CONFIG_HISAX_EURO)		+= l3dss1.o
 hisax-$(CONFIG_HISAX_NI1)		+= l3ni1.o
 hisax-$(CONFIG_HISAX_1TR6)		+= l3_1tr6.o
 
-hisax-$(CONFIG_HISAX_16_0)		+= teles0.o isac.o arcofi.o hscx.o
-hisax-$(CONFIG_HISAX_16_3)		+= teles3.o isac.o arcofi.o hscx.o
-hisax-$(CONFIG_HISAX_TELESPCI)		+= telespci.o isac.o arcofi.o hscx.o
-hisax-$(CONFIG_HISAX_S0BOX)		+= s0box.o isac.o arcofi.o hscx.o
-hisax-$(CONFIG_HISAX_AVM_A1)		+= avm_a1.o isac.o arcofi.o hscx.o
-hisax-$(CONFIG_HISAX_AVM_A1_PCMCIA)	+= avm_a1p.o isac.o arcofi.o hscx.o
-hisax-$(CONFIG_HISAX_FRITZPCI)		+= avm_pci.o isac.o arcofi.o
-hisax-$(CONFIG_HISAX_ELSA)		+= elsa.o isac.o arcofi.o hscx.o
-hisax-$(CONFIG_HISAX_IX1MICROR2)	+= ix1_micro.o isac.o arcofi.o hscx.o
-hisax-$(CONFIG_HISAX_DIEHLDIVA)		+= diva.o isac.o arcofi.o hscx.o ipacx.o 
-hisax-$(CONFIG_HISAX_ASUSCOM)		+= asuscom.o isac.o arcofi.o hscx.o
-hisax-$(CONFIG_HISAX_TELEINT)		+= teleint.o isac.o arcofi.o hfc_2bs0.o
-hisax-$(CONFIG_HISAX_SEDLBAUER)		+= sedlbauer.o isac.o arcofi.o hscx.o \
-					   isar.o
-hisax-$(CONFIG_HISAX_SPORTSTER)		+= sportster.o isac.o arcofi.o hscx.o
-hisax-$(CONFIG_HISAX_MIC)		+= mic.o isac.o arcofi.o hscx.o
-hisax-$(CONFIG_HISAX_NETJET_U)		+= nj_u.o netjet.o icc.o
+hisax-$(CONFIG_HISAX_16_0)		+= teles0.o hscx.o
+hisax-$(CONFIG_HISAX_16_3)		+= teles3.o hscx.o
+hisax-$(CONFIG_HISAX_TELESPCI)		+= telespci.o hscx.o
+hisax-$(CONFIG_HISAX_S0BOX)		+= s0box.o hscx.o
+hisax-$(CONFIG_HISAX_AVM_A1)		+= avm_a1.o hscx.o
+hisax-$(CONFIG_HISAX_AVM_A1_PCMCIA)	+= avm_a1p.o hscx.o
+hisax-$(CONFIG_HISAX_FRITZPCI)		+= avm_pci.o 
+hisax-$(CONFIG_HISAX_ELSA)		+= elsa.o hscx.o
+hisax-$(CONFIG_HISAX_IX1MICROR2)	+= ix1_micro.o hscx.o
+hisax-$(CONFIG_HISAX_DIEHLDIVA)		+= diva.o hscx.o ipacx.o 
+hisax-$(CONFIG_HISAX_ASUSCOM)		+= asuscom.o hscx.o
+hisax-$(CONFIG_HISAX_TELEINT)		+= teleint.o fc_2bs0.o
+hisax-$(CONFIG_HISAX_SEDLBAUER)		+= sedlbauer.o hscx.o isar.o
+hisax-$(CONFIG_HISAX_SPORTSTER)		+= sportster.o hscx.o
+hisax-$(CONFIG_HISAX_MIC)		+= mic.o hscx.o
 hisax-$(CONFIG_HISAX_HFCS)		+= hfcscard.o hfc_2bds0.o
 hisax-$(CONFIG_HISAX_HFC_PCI)		+= hfc_pci.o
 hisax-$(CONFIG_HISAX_HFC_SX)		+= hfc_sx.o
-hisax-$(CONFIG_HISAX_NICCY)		+= niccy.o isac.o arcofi.o hscx.o
-hisax-$(CONFIG_HISAX_ISURF)		+= isurf.o isac.o arcofi.o isar.o
-hisax-$(CONFIG_HISAX_HSTSAPHIR)		+= saphir.o isac.o arcofi.o hscx.o
-hisax-$(CONFIG_HISAX_BKM_A4T)		+= bkm_a4t.o isac.o arcofi.o jade.o
-hisax-$(CONFIG_HISAX_SCT_QUADRO)	+= bkm_a8.o isac.o arcofi.o hscx.o
-hisax-$(CONFIG_HISAX_GAZEL)		+= gazel.o isac.o arcofi.o hscx.o
+hisax-$(CONFIG_HISAX_NICCY)		+= niccy.o hscx.o
+hisax-$(CONFIG_HISAX_ISURF)		+= isurf.o sar.o
+hisax-$(CONFIG_HISAX_HSTSAPHIR)		+= saphir.o hscx.o
+hisax-$(CONFIG_HISAX_BKM_A4T)		+= bkm_a4t.o jade.o
+hisax-$(CONFIG_HISAX_SCT_QUADRO)	+= bkm_a8.o hscx.o
+hisax-$(CONFIG_HISAX_GAZEL)		+= gazel.o hscx.o
 hisax-$(CONFIG_HISAX_W6692)		+= w6692.o
 hisax-$(CONFIG_HISAX_ENTERNOW_PCI)	+= enternow_pci.o amd7930_fn.o
 
diff --git a/drivers/isdn/hisax/config.c b/drivers/isdn/hisax/config.c
index f9abd8a..03c73e0 100644
--- a/drivers/isdn/hisax/config.c
+++ b/drivers/isdn/hisax/config.c
@@ -24,6 +24,7 @@
 #include <linux/kernel_stat.h>
 #include <linux/workqueue.h>
 #include <linux/interrupt.h>
+#include <linux/pci.h>
 #define HISAX_STATUS_BUFSIZE 4096
 
 /*
@@ -270,13 +271,6 @@ const char *CardType[] = {
 #define DEFAULT_CFG {0,0,0,0}
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
@@ -535,10 +529,6 @@ extern int setup_gazel(struct IsdnCard *card);
 extern int setup_w6692(struct IsdnCard *card);
 #endif
 
-#if CARD_NETJET_U
-extern int setup_netjet_u(struct IsdnCard *card);
-#endif
-
 #if CARD_FN_ENTERNOW_PCI
 extern int setup_enternow_pci(struct IsdnCard *card);
 #endif
@@ -957,11 +947,6 @@ static int hisax_cs_setup_card(struct IsdnCard *card)
 		ret = setup_w6692(card);
 		break;
 #endif
-#if CARD_NETJET_U
-	case ISDN_CTYPE_NETJET_U:
-		ret = setup_netjet_u(card);
-		break;
-#endif
 #if CARD_FN_ENTERNOW_PCI
 	case ISDN_CTYPE_ENTERNOW:
 		ret = setup_enternow_pci(card);
@@ -973,6 +958,7 @@ static int hisax_cs_setup_card(struct IsdnCard *card)
 
 	/* list of ISDN_CTYPE_xxx support moved to a modular driver */
 	case ISDN_CTYPE_NETJET_S:
+	case ISDN_CTYPE_NETJET_U:
 		printk(KERN_WARNING "HiSax: Support for %s Card has moved "
 		       "to separate PCI driver module\n",
 		       CardType[card->typ]);
@@ -1433,11 +1419,15 @@ static int __init HiSax_init(void)
 			cards[j].para[2] = mem[i];
 			break;
 		case ISDN_CTYPE_ELSA_PCI:
-		case ISDN_CTYPE_NETJET_S:
 		case ISDN_CTYPE_TELESPCI:
 		case ISDN_CTYPE_W6692:
+			break;
+
+		/* the following block are excluded from std HiSax init */
+		case ISDN_CTYPE_NETJET_S:
 		case ISDN_CTYPE_NETJET_U:
 			break;
+
 		case ISDN_CTYPE_BKM_A4T:
 			break;
 		case ISDN_CTYPE_SCT_QUADRO:
@@ -1515,6 +1505,19 @@ static void __exit HiSax_exit(void)
 	printk(KERN_INFO "HiSax module removed\n");
 }
 
+#ifdef CONFIG_PCI
+void hisax_pci_remove_one(struct pci_dev *pdev)
+{
+	int cardnr = (unsigned long) pci_get_drvdata(pdev);
+
+	HiSax_closecard(cardnr);
+	pci_disable_device(pdev);
+	pci_set_drvdata(pdev, NULL);
+}
+
+EXPORT_SYMBOL(hisax_pci_remove_one);
+#endif /* CONFIG_PCI */
+
 int hisax_init_hotplug(struct IsdnCard *card, hisax_setup_func_t card_setup)
 {
 	u_char ids[16];
@@ -1927,9 +1930,6 @@ static struct pci_device_id hisax_pci_tbl[] __devinitdata = {
 #ifdef CONFIG_HISAX_SEDLBAUER
 	{PCI_VENDOR_ID_TIGERJET, PCI_DEVICE_ID_TIGERJET_100,     PCI_ANY_ID,PCI_ANY_ID},
 #endif
-#if defined(CONFIG_HISAX_NETJET_U)
-	{PCI_VENDOR_ID_TIGERJET, PCI_DEVICE_ID_TIGERJET_300,     PCI_ANY_ID,PCI_ANY_ID},
-#endif
 #if defined(CONFIG_HISAX_TELESPCI) || defined(CONFIG_HISAX_SCT_QUADRO)
 	{PCI_VENDOR_ID_ZORAN,    PCI_DEVICE_ID_ZORAN_36120,      PCI_ANY_ID,PCI_ANY_ID},
 #endif
diff --git a/drivers/isdn/hisax/hisax_cfg.h b/drivers/isdn/hisax/hisax_cfg.h
index ec309d4..dde18bf 100644
--- a/drivers/isdn/hisax/hisax_cfg.h
+++ b/drivers/isdn/hisax/hisax_cfg.h
@@ -65,3 +65,5 @@ typedef int (*hisax_setup_func_t)(struct IsdnCard *card);
 extern void	HiSax_closecard(int);
 extern int	hisax_init_pcmcia(void *, int *, IsdnCard_t *);
 extern int	hisax_init_hotplug(IsdnCard_t *, hisax_setup_func_t card_setup);
+extern void	hisax_pci_remove_one(struct pci_dev *pdev);
+
diff --git a/drivers/isdn/hisax/isdnl1.c b/drivers/isdn/hisax/isdnl1.c
index bcae2b0..c939167 100644
--- a/drivers/isdn/hisax/isdnl1.c
+++ b/drivers/isdn/hisax/isdnl1.c
@@ -451,7 +451,7 @@ Logl2Frame(struct IsdnCardState *cs, struct sk_buff *skb, char *buf, int dir)
 			(dir ? "<-" : "->"), buf, l2frames(ptr),
 			((ptr[0] & 2) >> 1) == dir ? 'C' : 'R', ptr[0] >> 2, ptr[1] >> 1);
 }
-#endif
+#endif /* L2FRAME_DEBUG */
 
 static void
 l1_reset(struct FsmInst *fi, int event, void *arg)
@@ -934,4 +934,10 @@ setstack_l1_B(struct PStack *st)
 	FsmInitTimer(&st->l1.l1m, &st->l1.timer);
 }
 
+EXPORT_SYMBOL(l1_msg);
 EXPORT_SYMBOL(debugl1);
+EXPORT_SYMBOL(DChannel_proc_rcv);
+EXPORT_SYMBOL(DChannel_proc_xmt);
+#ifdef L2FRAME_DEBUG
+EXPORT_SYMBOL(Logl2Frame);
+#endif
diff --git a/drivers/isdn/hisax/nj_s.c b/drivers/isdn/hisax/nj_s.c
index 3779ccc..f804636 100644
--- a/drivers/isdn/hisax/nj_s.c
+++ b/drivers/isdn/hisax/nj_s.c
@@ -310,27 +310,17 @@ static int __devinit njs_pci_init_one(struct pci_dev *pdev,
 	return 0;
 }
 
-static void __devexit njs_pci_remove_one(struct pci_dev *pdev)
-{
-	int cardnr = (unsigned long) pci_get_drvdata(pdev);
-
-	HiSax_closecard(cardnr);
-	pci_disable_device(pdev);
-	pci_set_drvdata(pdev, NULL);
-}
-
 static struct pci_device_id njs_pci_table[] = {
 	{ PCI_VDEVICE(TIGERJET, PCI_DEVICE_ID_TIGERJET_300) },
 
 	{ }		/* terminate list */
 };
-MODULE_DEVICE_TABLE(pci, njs_pci_table);
 
 static struct pci_driver njs_pci_driver = {
 	.name		= "nj_s",
 	.id_table	= njs_pci_table,
 	.probe		= njs_pci_init_one,
-	.remove		= njs_pci_remove_one,
+	.remove		= hisax_pci_remove_one,
 };
 
 static int __init njs_mod_init(void)
@@ -349,5 +339,6 @@ module_exit(njs_mod_exit);
 module_param_named(protocol, njs_protocol, int, 0444);
 MODULE_PARM_DESC(protocol, "Values 0 (default) through 4. See ISDN_PTYPE_xxx in linux/isdnif.h");
 
+MODULE_DEVICE_TABLE(pci, njs_pci_table);
 MODULE_DESCRIPTION("ISDN HiSax NETjet-S PCI driver");
 MODULE_LICENSE("GPL");
diff --git a/drivers/isdn/hisax/nj_u.c b/drivers/isdn/hisax/nj_u.c
index f017d38..e391eae 100644
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
@@ -197,8 +203,7 @@ static int __devinit nju_cs_init_rest(struct IsdnCard *card,
 		cs->hw.njet.base, cs->irq);
 	if (!request_region(cs->hw.njet.base, bytecnt, "netspider-u isdn")) {
 		printk(KERN_WARNING
-		       "HiSax: %s config port %#lx-%#lx already in use\n",
-		       CardType[card->typ],
+		       "HiSax: NETjet-U config port %#lx-%#lx already in use\n",
 		       cs->hw.njet.base,
 		       cs->hw.njet.base + bytecnt);
 		return (0);
@@ -219,7 +224,6 @@ static int __devinit nju_cs_init_rest(struct IsdnCard *card,
 	return (1);
 }
 
-static struct pci_dev *dev_netjet __devinitdata = NULL;
 
 int __devinit
 setup_netjet_u(struct IsdnCard *card)
@@ -227,6 +231,7 @@ setup_netjet_u(struct IsdnCard *card)
 	int ret;
 	struct IsdnCardState *cs = card->cs;
 	char tmp[64];
+	struct pci_dev *dev_netjet = (void *) card->para[0];
 
 #ifdef __BIG_ENDIAN
 #error "not running on big endian machines now"
@@ -234,29 +239,70 @@ setup_netjet_u(struct IsdnCard *card)
 
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
+	.name		= "nj_s",
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
diff --git a/drivers/isdn/hisax/q931.c b/drivers/isdn/hisax/q931.c
index aacbf0d..8a4e60b 100644
--- a/drivers/isdn/hisax/q931.c
+++ b/drivers/isdn/hisax/q931.c
@@ -1520,3 +1520,7 @@ dlogframe(struct IsdnCardState *cs, struct sk_buff *skb, int dir)
 	*dp = 0;
 	HiSax_putstatus(cs, NULL, cs->dlog);
 }
+
+EXPORT_SYMBOL(dlogframe);
+EXPORT_SYMBOL(LogFrame);
+EXPORT_SYMBOL(QuickHex);
