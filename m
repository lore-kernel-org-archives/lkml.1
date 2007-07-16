Return-Path: <linux-kernel-owner+w=401wt.eu-S1758064AbXGPHwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758064AbXGPHwS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 03:52:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752889AbXGPHwM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 03:52:12 -0400
Received: from havoc.gtf.org ([69.61.125.42]:60641 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752513AbXGPHwK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 03:52:10 -0400
Date: Mon, 16 Jul 2007 03:52:06 -0400
From: Jeff Garzik <jeff@garzik.org>
To: kkeil@suse.de, linux-kernel@vger.kernel.org,
       isdn4linux@listserv.isdn4linux.de
Cc: Andrew Morton <akpm@linux-foundation.org>, surya.prabhakar@wipro.com
Subject: [PATCH] HiSax telespci: convert to PCI hotplug API
Message-ID: <20070716075206.GA26527@havoc.gtf.org>
References: <20070715095716.GA20949@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070715095716.GA20949@havoc.gtf.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


commit 6a95b63013e6bdd316dca39053174cb1add4b555
Author: Jeff Garzik <jeff@garzik.org>
Date:   Mon Jul 16 03:49:25 2007 -0400

    [ISDN] HiSax: convert telespci to PCI hotplug API
    
    Also, some exports needed now that arocfi and hscx are being picked up
    via libhisax.

    [like other patches, the non-telespci changes in this patch need to
    be moved earlier in the patch series, before pushing upstream -jg]
    
    Signed-off-by: Jeff Garzik <jeff@garzik.org>

 drivers/isdn/hisax/Kconfig    |    2 
 drivers/isdn/hisax/Makefile   |   36 +++++++-------
 drivers/isdn/hisax/arcofi.c   |    4 +
 drivers/isdn/hisax/config.c   |   21 +-------
 drivers/isdn/hisax/hscx.c     |    7 ++
 drivers/isdn/hisax/telespci.c |  106 ++++++++++++++++++++++++++++++------------
 6 files changed, 111 insertions(+), 65 deletions(-)

6a95b63013e6bdd316dca39053174cb1add4b555
diff --git a/drivers/isdn/hisax/Kconfig b/drivers/isdn/hisax/Kconfig
index aa3ba1d..7dd47cc 100644
--- a/drivers/isdn/hisax/Kconfig
+++ b/drivers/isdn/hisax/Kconfig
@@ -109,7 +109,7 @@ config HISAX_16_3
 	  non-standard IRQ/port settings.
 
 config HISAX_TELESPCI
-	bool "Teles PCI"
+	tristate "Teles PCI"
 	depends on PCI && (BROKEN || !(SPARC || PPC || PARISC || M68K || (MIPS && !CPU_LITTLE_ENDIAN) || FRV))
 	help
 	  This enables HiSax support for the Teles PCI.
diff --git a/drivers/isdn/hisax/Makefile b/drivers/isdn/hisax/Makefile
index d1b543c..a4ca3e9 100644
--- a/drivers/isdn/hisax/Makefile
+++ b/drivers/isdn/hisax/Makefile
@@ -21,12 +21,13 @@ obj-$(CONFIG_HISAX_ENTERNOW_PCI)	+= enternow.o libhisax.o
 obj-$(CONFIG_HISAX_BKM_A4T)		+= bkm_a4t_pci.o libhisax.o
 obj-$(CONFIG_HISAX_W6692)		+= w6692.o libhisax.o
 obj-$(CONFIG_HISAX_HFC_PCI)		+= hfc_pci.o libhisax.o
+obj-$(CONFIG_HISAX_TELESPCI)		+= telespci.o
 
 bkm_a4t_pci-objs			:= bkm_a4t.o jade.o
 enternow-objs				:= enternow_pci.o amd7930_fn.o
 netjet_s-objs				:= nj_s.o
 netjet_u-objs				:= nj_u.o icc.o
-libhisax-objs				:= netjet.o isac.o arcofi.o
+libhisax-objs				:= netjet.o isac.o arcofi.o hscx.o
 
 ifdef CONFIG_HISAX_HDLC
 obj-$(CONFIG_ISDN_DRV_HISAX)		+= isdnhdlc.o
@@ -43,26 +44,25 @@ hisax-$(CONFIG_HISAX_EURO)		+= l3dss1.o
 hisax-$(CONFIG_HISAX_NI1)		+= l3ni1.o
 hisax-$(CONFIG_HISAX_1TR6)		+= l3_1tr6.o
 
-hisax-$(CONFIG_HISAX_16_0)		+= teles0.o hscx.o
-hisax-$(CONFIG_HISAX_16_3)		+= teles3.o hscx.o
-hisax-$(CONFIG_HISAX_TELESPCI)		+= telespci.o hscx.o
-hisax-$(CONFIG_HISAX_S0BOX)		+= s0box.o hscx.o
-hisax-$(CONFIG_HISAX_AVM_A1)		+= avm_a1.o hscx.o
-hisax-$(CONFIG_HISAX_AVM_A1_PCMCIA)	+= avm_a1p.o hscx.o
+hisax-$(CONFIG_HISAX_16_0)		+= teles0.o
+hisax-$(CONFIG_HISAX_16_3)		+= teles3.o
+hisax-$(CONFIG_HISAX_S0BOX)		+= s0box.o
+hisax-$(CONFIG_HISAX_AVM_A1)		+= avm_a1.o
+hisax-$(CONFIG_HISAX_AVM_A1_PCMCIA)	+= avm_a1p.o
 hisax-$(CONFIG_HISAX_FRITZPCI)		+= avm_pci.o 
-hisax-$(CONFIG_HISAX_ELSA)		+= elsa.o hscx.o
-hisax-$(CONFIG_HISAX_IX1MICROR2)	+= ix1_micro.o hscx.o
-hisax-$(CONFIG_HISAX_DIEHLDIVA)		+= diva.o hscx.o ipacx.o 
-hisax-$(CONFIG_HISAX_ASUSCOM)		+= asuscom.o hscx.o
+hisax-$(CONFIG_HISAX_ELSA)		+= elsa.o
+hisax-$(CONFIG_HISAX_IX1MICROR2)	+= ix1_micro.o
+hisax-$(CONFIG_HISAX_DIEHLDIVA)		+= diva.o ipacx.o 
+hisax-$(CONFIG_HISAX_ASUSCOM)		+= asuscom.o
 hisax-$(CONFIG_HISAX_TELEINT)		+= teleint.o fc_2bs0.o
-hisax-$(CONFIG_HISAX_SEDLBAUER)		+= sedlbauer.o hscx.o isar.o
-hisax-$(CONFIG_HISAX_SPORTSTER)		+= sportster.o hscx.o
-hisax-$(CONFIG_HISAX_MIC)		+= mic.o hscx.o
+hisax-$(CONFIG_HISAX_SEDLBAUER)		+= sedlbauer.o isar.o
+hisax-$(CONFIG_HISAX_SPORTSTER)		+= sportster.o
+hisax-$(CONFIG_HISAX_MIC)		+= mic.o
 hisax-$(CONFIG_HISAX_HFCS)		+= hfcscard.o hfc_2bds0.o
 hisax-$(CONFIG_HISAX_HFC_SX)		+= hfc_sx.o
-hisax-$(CONFIG_HISAX_NICCY)		+= niccy.o hscx.o
+hisax-$(CONFIG_HISAX_NICCY)		+= niccy.o
 hisax-$(CONFIG_HISAX_ISURF)		+= isurf.o sar.o
-hisax-$(CONFIG_HISAX_HSTSAPHIR)		+= saphir.o hscx.o
-hisax-$(CONFIG_HISAX_SCT_QUADRO)	+= bkm_a8.o hscx.o
-hisax-$(CONFIG_HISAX_GAZEL)		+= gazel.o hscx.o
+hisax-$(CONFIG_HISAX_HSTSAPHIR)		+= saphir.o
+hisax-$(CONFIG_HISAX_SCT_QUADRO)	+= bkm_a8.o
+hisax-$(CONFIG_HISAX_GAZEL)		+= gazel.o
 
diff --git a/drivers/isdn/hisax/arcofi.c b/drivers/isdn/hisax/arcofi.c
index d30ce5b..bf2e10d 100644
--- a/drivers/isdn/hisax/arcofi.c
+++ b/drivers/isdn/hisax/arcofi.c
@@ -132,3 +132,7 @@ init_arcofi(struct IsdnCardState *cs) {
 	init_waitqueue_head(&cs->dc.isac.arcofi_wait);
 	test_and_set_bit(HW_ARCOFI, &cs->HW_Flags);
 }
+
+EXPORT_SYMBOL(init_arcofi);
+EXPORT_SYMBOL(clear_arcofi);
+EXPORT_SYMBOL(arcofi_fsm);
diff --git a/drivers/isdn/hisax/config.c b/drivers/isdn/hisax/config.c
index 3960233..eb754eb 100644
--- a/drivers/isdn/hisax/config.c
+++ b/drivers/isdn/hisax/config.c
@@ -145,13 +145,6 @@ const char *CardType[] = {
 #define DEFAULT_CFG {15,0xd0000,0xd80,0}
 #endif
 
-#ifdef CONFIG_HISAX_TELESPCI
-#undef DEFAULT_CARD
-#undef DEFAULT_CFG
-#define DEFAULT_CARD ISDN_CTYPE_TELESPCI
-#define DEFAULT_CFG {0,0,0,0}
-#endif
-
 #ifdef CONFIG_HISAX_IX1MICROR2
 #undef DEFAULT_CARD
 #undef DEFAULT_CFG
@@ -420,10 +413,6 @@ extern int setup_teles3(struct IsdnCard *card);
 extern int setup_s0box(struct IsdnCard *card);
 #endif
 
-#if CARD_TELESPCI
-extern int setup_telespci(struct IsdnCard *card);
-#endif
-
 #if CARD_AVM_A1
 extern int setup_avm_a1(struct IsdnCard *card);
 #endif
@@ -794,11 +783,6 @@ static int hisax_cs_setup_card(struct IsdnCard *card)
 		ret = setup_s0box(card);
 		break;
 #endif
-#if CARD_TELESPCI
-	case ISDN_CTYPE_TELESPCI:
-		ret = setup_telespci(card);
-		break;
-#endif
 #if CARD_AVM_A1
 	case ISDN_CTYPE_A1:
 		ret = setup_avm_a1(card);
@@ -906,6 +890,7 @@ static int hisax_cs_setup_card(struct IsdnCard *card)
 	case ISDN_CTYPE_BKM_A4T:
 	case ISDN_CTYPE_W6692:
 	case ISDN_CTYPE_HFC_PCI:
+	case ISDN_CTYPE_TELESPCI:
 		printk(KERN_WARNING "HiSax: Support for %s Card has moved "
 		       "to separate PCI driver module\n",
 		       CardType[card->typ]);
@@ -1365,7 +1350,6 @@ static int __init HiSax_init(void)
 			cards[j].para[2] = mem[i];
 			break;
 		case ISDN_CTYPE_ELSA_PCI:
-		case ISDN_CTYPE_TELESPCI:
 			break;
 
 		/* the following block are excluded from std HiSax init */
@@ -1375,6 +1359,7 @@ static int __init HiSax_init(void)
 		case ISDN_CTYPE_BKM_A4T:
 		case ISDN_CTYPE_W6692:
 		case ISDN_CTYPE_HFC_PCI:
+		case ISDN_CTYPE_TELESPCI:
 			break;
 
 		case ISDN_CTYPE_SCT_QUADRO:
@@ -1878,7 +1863,7 @@ static struct pci_device_id hisax_pci_tbl[] __devinitdata = {
 #ifdef CONFIG_HISAX_SEDLBAUER
 	{PCI_VENDOR_ID_TIGERJET, PCI_DEVICE_ID_TIGERJET_100,     PCI_ANY_ID,PCI_ANY_ID},
 #endif
-#if defined(CONFIG_HISAX_TELESPCI) || defined(CONFIG_HISAX_SCT_QUADRO)
+#if defined(CONFIG_HISAX_SCT_QUADRO)
 	{PCI_VENDOR_ID_ZORAN,    PCI_DEVICE_ID_ZORAN_36120,      PCI_ANY_ID,PCI_ANY_ID},
 #endif
 	{ }				/* Terminating entry */
diff --git a/drivers/isdn/hisax/hscx.c b/drivers/isdn/hisax/hscx.c
index c8f9951..09e1546 100644
--- a/drivers/isdn/hisax/hscx.c
+++ b/drivers/isdn/hisax/hscx.c
@@ -274,3 +274,10 @@ inithscxisac(struct IsdnCardState *cs, int part)
 		cs->writeisac(cs, ISAC_CMDR, 0x41);
 	}
 }
+
+EXPORT_SYMBOL(HscxVersion);
+EXPORT_SYMBOL(inithscxisac);
+EXPORT_SYMBOL(clear_pending_hscx_ints);
+EXPORT_SYMBOL(hscx_l2l1);
+EXPORT_SYMBOL(open_hscxstate);
+EXPORT_SYMBOL(modehscx);
diff --git a/drivers/isdn/hisax/telespci.c b/drivers/isdn/hisax/telespci.c
index d09f6d0..ebb6716 100644
--- a/drivers/isdn/hisax/telespci.c
+++ b/drivers/isdn/hisax/telespci.c
@@ -14,12 +14,14 @@
 
 #include <linux/init.h>
 #include "hisax.h"
+#include "hisax_proto.h"
 #include "isac.h"
 #include "hscx.h"
 #include "isdnl1.h"
 #include <linux/pci.h>
 
-extern const char *CardType[];
+static int teles_protocol;		/* 0 == use DEFAULT_PROTO */
+
 static const char *telespci_revision = "$Revision: 2.23.2.3 $";
 
 #define ZORAN_PO_RQ_PEN	0x02000000
@@ -284,44 +286,37 @@ TelesPCI_card_msg(struct IsdnCardState *cs, int mt, void *arg)
 	return(0);
 }
 
-static struct pci_dev *dev_tel __devinitdata = NULL;
-
-int __devinit
+static int __devinit
 setup_telespci(struct IsdnCard *card)
 {
 	struct IsdnCardState *cs = card->cs;
+	struct pci_dev *dev_tel = (void *) card->para[0];
 	char tmp[64];
 
 #ifdef __BIG_ENDIAN
 #error "not running on big endian machines now"
 #endif
+
 	strcpy(tmp, telespci_revision);
 	printk(KERN_INFO "HiSax: Teles/PCI driver Rev. %s\n", HiSax_getrev(tmp));
-	if (cs->typ != ISDN_CTYPE_TELESPCI)
-		return (0);
-#ifdef CONFIG_PCI
-	if ((dev_tel = pci_find_device (PCI_VENDOR_ID_ZORAN, PCI_DEVICE_ID_ZORAN_36120, dev_tel))) {
-		if (pci_enable_device(dev_tel))
-			return(0);
-		cs->irq = dev_tel->irq;
-		if (!cs->irq) {
-			printk(KERN_WARNING "Teles: No IRQ for PCI card found\n");
-			return(0);
-		}
-		cs->hw.teles0.membase = ioremap(pci_resource_start(dev_tel, 0),
-			PAGE_SIZE);
-		printk(KERN_INFO "Found: Zoran, base-address: 0x%llx, irq: 0x%x\n",
-			(unsigned long long)pci_resource_start(dev_tel, 0),
-			dev_tel->irq);
-	} else {
-		printk(KERN_WARNING "TelesPCI: No PCI card found\n");
+	WARN_ON(cs->typ != ISDN_CTYPE_TELESPCI);
+
+	if (pci_enable_device(dev_tel))
+		return(0);
+	cs->irq = dev_tel->irq;
+	if (!cs->irq) {
+		printk(KERN_WARNING "Teles: No IRQ for PCI card found\n");
+		return(0);
+	}
+	cs->hw.teles0.membase = ioremap(pci_resource_start(dev_tel, 0),
+		PAGE_SIZE);
+	if (!cs->hw.teles0.membase) {
+		printk(KERN_WARNING "Teles: ioremap failed\n");
 		return(0);
 	}
-#else
-	printk(KERN_WARNING "HiSax: Teles/PCI and NO_PCI_BIOS\n");
-	printk(KERN_WARNING "HiSax: Teles/PCI unable to config\n");
-	return (0);
-#endif /* CONFIG_PCI */
+	printk(KERN_INFO "Found: Zoran, base-address: 0x%llx, irq: 0x%x\n",
+		(unsigned long long)pci_resource_start(dev_tel, 0),
+		dev_tel->irq);
 
 	/* Initialize Zoran PCI controller */
 	writel(0x00000000, cs->hw.teles0.membase + 0x28);
@@ -334,7 +329,7 @@ setup_telespci(struct IsdnCard *card)
 
 	printk(KERN_INFO
 	       "HiSax: %s config irq:%d mem:%p\n",
-	       CardType[cs->typ], cs->irq,
+	       "telespci", cs->irq,
 	       cs->hw.teles0.membase);
 
 	setup_isac(cs);
@@ -357,3 +352,58 @@ setup_telespci(struct IsdnCard *card)
 	}
 	return (1);
 }
+
+static int __devinit teles_pci_init_one(struct pci_dev *pdev,
+				      const struct pci_device_id *ent)
+{
+	struct IsdnCard icard = { ISDN_CTYPE_TELESPCI, };
+	int cardnr;
+
+	icard.para[0] = (unsigned long) pdev;
+	icard.para[1] = ent->driver_data;
+	if (!teles_protocol)
+		icard.protocol = DEFAULT_PROTO;
+	else
+		icard.protocol = teles_protocol;
+
+	cardnr = hisax_init_hotplug(&icard, setup_telespci);
+	if (cardnr < 0)
+		return -ENODEV;
+	
+	pci_set_drvdata(pdev, (void *)(unsigned long) cardnr);
+	return 0;
+}
+
+static struct pci_device_id teles_pci_table[] = {
+	{ PCI_VENDOR_ID_ZORAN, PCI_DEVICE_ID_ZORAN_36120,
+	  PCI_ANY_ID, PCI_ANY_ID, },
+
+	{ }		/* terminate list */
+};
+
+static struct pci_driver teles_pci_driver = {
+	.name		= "telespci",
+	.id_table	= teles_pci_table,
+	.probe		= teles_pci_init_one,
+	.remove		= hisax_pci_remove_one,
+};
+
+static int __init teles_mod_init(void)
+{
+	return pci_register_driver(&teles_pci_driver);
+}
+
+static void __exit teles_mod_exit(void)
+{
+	pci_unregister_driver(&teles_pci_driver);
+}
+
+module_init(teles_mod_init);
+module_exit(teles_mod_exit);
+
+module_param_named(protocol, teles_protocol, int, 0444);
+MODULE_PARM_DESC(protocol, "Values 0 (default) through 4. See ISDN_PTYPE_xxx in linux/isdnif.h");
+
+MODULE_DEVICE_TABLE(pci, teles_pci_table);
+MODULE_DESCRIPTION("ISDN HiSax Teles PCI driver");
+MODULE_LICENSE("GPL");
