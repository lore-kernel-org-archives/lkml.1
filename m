Return-Path: <linux-kernel-owner+w=401wt.eu-S934103AbYBNXms@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934103AbYBNXms (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 18:42:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764627AbYBNXkR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 18:40:17 -0500
Received: from havoc.gtf.org ([69.61.125.42]:52147 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761204AbYBNXkK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 18:40:10 -0500
Message-Id: <61a39b593f15e52f75902baaa69bf033c4e302ac.1203031878.git.jeff@garzik.org>
In-Reply-To: <74fc75b3eadfa82aee70b855e9944b5439a259d5.1203031878.git.jeff@garzik.org>
References: <74fc75b3eadfa82aee70b855e9944b5439a259d5.1203031878.git.jeff@garzik.org>
From: Jeff Garzik <jeff@garzik.org>
To: linux-kernel@vger.kernel.org, kkeil@suse.de,
       isdn4linux@listserv.isdn4linux.de
Date: Tue, 17 Jul 2007 23:49:07 -0400
Subject: [PATCH 05/14] [ISDN] HiSax enternow: convert to PCI hotplug API
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jeff Garzik <jeff@garzik.org>
---
 drivers/isdn/hisax/Kconfig        |    4 +-
 drivers/isdn/hisax/Makefile       |    3 +-
 drivers/isdn/hisax/config.c       |   11 +----
 drivers/isdn/hisax/enternow_pci.c |   93 ++++++++++++++++++++++++++-----------
 4 files changed, 72 insertions(+), 39 deletions(-)

diff --git a/drivers/isdn/hisax/Kconfig b/drivers/isdn/hisax/Kconfig
index e7808f5..2a69acc 100644
--- a/drivers/isdn/hisax/Kconfig
+++ b/drivers/isdn/hisax/Kconfig
@@ -340,8 +340,8 @@ config HISAX_HFC_SX
 	  cards. This code is not finished yet.
 
 config HISAX_ENTERNOW_PCI
-	bool "Formula-n enter:now PCI card"
-	depends on HISAX_NETJET && PCI && PCI_LEGACY && (BROKEN || !(SPARC || PPC || PARISC || M68K || (MIPS && !CPU_LITTLE_ENDIAN) || FRV))
+	tristate "Formula-n enter:now PCI card"
+	depends on HISAX_NETJET && PCI && (BROKEN || !(SPARC || PPC || PARISC || M68K || (MIPS && !CPU_LITTLE_ENDIAN) || FRV))
 	help
 	  This enables HiSax support for the Formula-n enter:now PCI
 	  ISDN card.
diff --git a/drivers/isdn/hisax/Makefile b/drivers/isdn/hisax/Makefile
index 42bfc2f..c72fb28 100644
--- a/drivers/isdn/hisax/Makefile
+++ b/drivers/isdn/hisax/Makefile
@@ -16,8 +16,10 @@ obj-$(CONFIG_HISAX_HFCUSB)		+= hfc_usb.o
 obj-$(CONFIG_HISAX_HFC4S8S)		+= hfc4s8s_l1.o
 obj-$(CONFIG_HISAX_FRITZ_PCIPNP)        += hisax_isac.o hisax_fcpcipnp.o
 obj-$(CONFIG_HISAX_BKM_A4T)		+= bkm_a4t_pci.o libhisax.o
+obj-$(CONFIG_HISAX_ENTERNOW_PCI)	+= enternow.o libhisax.o
 
 bkm_a4t_pci-objs			:= bkm_a4t.o jade.o
+enternow-objs				:= enternow_pci.o amd7930_fn.o
 libhisax-objs				:= netjet.o isac.o arcofi.o hscx.o
 
 ifdef CONFIG_HISAX_HDLC
@@ -61,5 +63,4 @@ hisax-$(CONFIG_HISAX_HSTSAPHIR)		+= saphir.o
 hisax-$(CONFIG_HISAX_SCT_QUADRO)	+= bkm_a8.o
 hisax-$(CONFIG_HISAX_GAZEL)		+= gazel.o
 hisax-$(CONFIG_HISAX_W6692)		+= w6692.o
-hisax-$(CONFIG_HISAX_ENTERNOW_PCI)	+= enternow_pci.o amd7930_fn.o
 
diff --git a/drivers/isdn/hisax/config.c b/drivers/isdn/hisax/config.c
index 7638cf5..90e499d 100644
--- a/drivers/isdn/hisax/config.c
+++ b/drivers/isdn/hisax/config.c
@@ -540,10 +540,6 @@ extern int setup_w6692(struct IsdnCard *card);
 extern int setup_netjet_u(struct IsdnCard *card);
 #endif
 
-#if CARD_FN_ENTERNOW_PCI
-extern int setup_enternow_pci(struct IsdnCard *card);
-#endif
-
 /*
  * Find card with given driverId
  */
@@ -963,16 +959,12 @@ static int __devinit hisax_cs_setup_card(struct IsdnCard *card)
 		ret = setup_netjet_u(card);
 		break;
 #endif
-#if CARD_FN_ENTERNOW_PCI
-	case ISDN_CTYPE_ENTERNOW:
-		ret = setup_enternow_pci(card);
-		break;
-#endif
 	case ISDN_CTYPE_DYNAMIC:
 		ret = 2;
 		break;
 
 	case ISDN_CTYPE_BKM_A4T:
+	case ISDN_CTYPE_ENTERNOW:
 		printk(KERN_WARNING "HiSax: Support for %s Card has moved "
 		       "to separate PCI driver module\n",
 		       CardType[card->typ]);
@@ -1442,6 +1434,7 @@ static int __init HiSax_init(void)
 
 		/* the following block are excluded from std HiSax init */
 		case ISDN_CTYPE_BKM_A4T:
+		case ISDN_CTYPE_ENTERNOW:
 			break;
 
 		case ISDN_CTYPE_SCT_QUADRO:
diff --git a/drivers/isdn/hisax/enternow_pci.c b/drivers/isdn/hisax/enternow_pci.c
index 39f421e..b37a483 100644
--- a/drivers/isdn/hisax/enternow_pci.c
+++ b/drivers/isdn/hisax/enternow_pci.c
@@ -61,6 +61,7 @@
 
 
 #include "hisax.h"
+#include "hisax_proto.h"
 #include "isac.h"
 #include "isdnl1.h"
 #include "amd7930_fn.h"
@@ -70,7 +71,7 @@
 #include <linux/init.h>
 #include "netjet.h"
 
-
+static int en_protocol;		/* 0 == use DEFAULT_PROTO */
 
 static const char *enternow_pci_rev = "$Revision: 1.1.4.5 $";
 
@@ -305,6 +306,8 @@ static int __devinit en_pci_probe(struct pci_dev *dev_netjet,
 {
 	if (pci_enable_device(dev_netjet))
 		return(0);
+
+	cs->hw.njet.dev = dev_netjet;
 	cs->irq = dev_netjet->irq;
 	if (!cs->irq) {
 		printk(KERN_WARNING "enter:now PCI: No IRQ for PCI card found\n");
@@ -315,13 +318,6 @@ static int __devinit en_pci_probe(struct pci_dev *dev_netjet,
 		printk(KERN_WARNING "enter:now PCI: No IO-Adr for PCI card found\n");
 		return(0);
 	}
-	/* checks Sub-Vendor ID because system crashes with Traverse-Card */
-	if ((dev_netjet->subsystem_vendor != 0x55) ||
-	    (dev_netjet->subsystem_device != 0x02)) {
-		printk(KERN_WARNING "enter:now: You tried to load this driver with an incompatible TigerJet-card\n");
-		printk(KERN_WARNING "Use type=20 for Traverse NetJet PCI Card.\n");
-		return(0);
-	}
 
 	return(1);
 }
@@ -384,15 +380,14 @@ static int __devinit en_cs_init_rest(struct IsdnCard *card,
 	return (1);
 }
 
-static struct pci_dev *dev_netjet __devinitdata = NULL;
-
 /* called by config.c */
-int __devinit
+static int __devinit
 setup_enternow_pci(struct IsdnCard *card)
 {
 	int ret;
 	struct IsdnCardState *cs = card->cs;
 	char tmp[64];
+	struct pci_dev *dev_netjet = (void *) card->para[0];
 
 #ifdef __BIG_ENDIAN
 #error "not running on big endian machines now"
@@ -400,25 +395,69 @@ setup_enternow_pci(struct IsdnCard *card)
 
         strcpy(tmp, enternow_pci_rev);
 	printk(KERN_INFO "HiSax: Formula-n Europe AG enter:now ISDN PCI driver Rev. %s\n", HiSax_getrev(tmp));
-	if (cs->typ != ISDN_CTYPE_ENTERNOW)
-		return(0);
+
+	WARN_ON(cs->typ != ISDN_CTYPE_ENTERNOW);
+
 	test_and_clear_bit(FLG_LOCK_ATOMIC, &cs->HW_Flags);
 
-	for ( ;; )
-	{
-		if ((dev_netjet = pci_find_device(PCI_VENDOR_ID_TIGERJET,
-			PCI_DEVICE_ID_TIGERJET_300,  dev_netjet))) {
-			ret = en_pci_probe(dev_netjet, cs);
-			if (!ret)
-				return(0);
-		} else {
-                        printk(KERN_WARNING "enter:now PCI: No PCI card found\n");
-			return(0);
-		}
+	ret = en_pci_probe(dev_netjet, cs);
+	if (!ret)
+		return(0);
 
-		en_cs_init(card, cs);
-		break;
-	}
+	en_cs_init(card, cs);
 
         return en_cs_init_rest(card, cs);
 }
+
+static int __devinit en_pci_init_one(struct pci_dev *pdev,
+				      const struct pci_device_id *ent)
+{
+	struct IsdnCard icard = { ISDN_CTYPE_ENTERNOW, };
+	int cardnr;
+
+	icard.para[0] = (unsigned long) pdev;
+	if (!en_protocol)
+		icard.protocol = DEFAULT_PROTO;
+	else
+		icard.protocol = en_protocol;
+
+	cardnr = hisax_init_hotplug(&icard, setup_enternow_pci);
+	if (cardnr < 0)
+		return -ENODEV;
+	
+	pci_set_drvdata(pdev, (void *)(unsigned long) cardnr);
+	return 0;
+}
+
+static struct pci_device_id en_pci_table[] = {
+	{ PCI_VENDOR_ID_TIGERJET, PCI_DEVICE_ID_TIGERJET_300, 0x55, 0x02, },
+
+	{ }		/* terminate list */
+};
+
+static struct pci_driver en_pci_driver = {
+	.name		= "enternow_pci",
+	.id_table	= en_pci_table,
+	.probe		= en_pci_init_one,
+	.remove		= hisax_pci_remove_one,
+};
+
+static int __init en_mod_init(void)
+{
+	return pci_register_driver(&en_pci_driver);
+}
+
+static void __exit en_mod_exit(void)
+{
+	pci_unregister_driver(&en_pci_driver);
+}
+
+module_init(en_mod_init);
+module_exit(en_mod_exit);
+
+module_param_named(protocol, en_protocol, int, 0444);
+MODULE_PARM_DESC(protocol, "Values 0 (default) through 4. See ISDN_PTYPE_xxx in linux/isdnif.h");
+
+MODULE_DEVICE_TABLE(pci, en_pci_table);
+MODULE_DESCRIPTION("ISDN HiSax enter:now PCI driver");
+MODULE_LICENSE("GPL");
-- 
1.5.3.8

