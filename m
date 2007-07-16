Return-Path: <linux-kernel-owner+w=401wt.eu-S1760195AbXGPF10@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760195AbXGPF10 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 01:27:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752458AbXGPF1R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 01:27:17 -0400
Received: from havoc.gtf.org ([69.61.125.42]:60342 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751781AbXGPF1P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 01:27:15 -0400
Date: Mon, 16 Jul 2007 01:27:14 -0400
From: Jeff Garzik <jeff@garzik.org>
To: kkeil@suse.de, linux-kernel@vger.kernel.org,
       isdn4linux@listserv.isdn4linux.de
Cc: Andrew Morton <akpm@linux-foundation.org>, surya.prabhakar@wipro.com
Subject: [PATCH 2/7] HiSax enternow: convert to PCI hotplug API
Message-ID: <20070716052714.GB21782@havoc.gtf.org>
References: <20070715095716.GA20949@havoc.gtf.org> <20070716052647.GA21782@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070716052647.GA21782@havoc.gtf.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


commit 6c1225fd2735f698f59122209dd3c74d2e50ec28
Author: Jeff Garzik <jeff@garzik.org>
Date:   Sun Jul 15 19:41:21 2007 -0400

    [ISDN] HiSax enternow_pci: convert to PCI hotplug API
    
    Also, fix driver name in netjet_u.
    
    Signed-off-by: Jeff Garzik <jeff@garzik.org>

 drivers/isdn/hisax/Kconfig        |    2 
 drivers/isdn/hisax/Makefile       |    3 -
 drivers/isdn/hisax/config.c       |   11 ----
 drivers/isdn/hisax/enternow_pci.c |   91 +++++++++++++++++++++++++++-----------
 drivers/isdn/hisax/nj_u.c         |    2 
 5 files changed, 71 insertions(+), 38 deletions(-)

6c1225fd2735f698f59122209dd3c74d2e50ec28
diff --git a/drivers/isdn/hisax/Kconfig b/drivers/isdn/hisax/Kconfig
index 1da3cd6..7de6fda 100644
--- a/drivers/isdn/hisax/Kconfig
+++ b/drivers/isdn/hisax/Kconfig
@@ -341,7 +341,7 @@ config HISAX_HFC_SX
 	  cards. This code is not finished yet.
 
 config HISAX_ENTERNOW_PCI
-	bool "Formula-n enter:now PCI card"
+	tristate "Formula-n enter:now PCI card"
 	depends on HISAX_NETJET && PCI && (BROKEN || !(SPARC || PPC || PARISC || M68K || (MIPS && !CPU_LITTLE_ENDIAN) || FRV))
 	help
 	  This enables HiSax support for the Formula-n enter:now PCI
diff --git a/drivers/isdn/hisax/Makefile b/drivers/isdn/hisax/Makefile
index a37e211..db5580b 100644
--- a/drivers/isdn/hisax/Makefile
+++ b/drivers/isdn/hisax/Makefile
@@ -17,7 +17,9 @@ obj-$(CONFIG_HISAX_HFC4S8S)		+= hfc4s8s_l1.o
 obj-$(CONFIG_HISAX_FRITZ_PCIPNP)        += hisax_isac.o hisax_fcpcipnp.o
 obj-$(CONFIG_HISAX_NETJET)		+= netjet_s.o libhisax.o
 obj-$(CONFIG_HISAX_NETJET_U)		+= netjet_u.o libhisax.o
+obj-$(CONFIG_HISAX_ENTERNOW_PCI)	+= enternow.o libhisax.o
 
+enternow-objs				:= enternow_pci.o amd7930_fn.o
 netjet_s-objs				:= nj_s.o
 netjet_u-objs				:= nj_u.o icc.o
 libhisax-objs				:= netjet.o isac.o arcofi.o
@@ -62,5 +64,4 @@ hisax-$(CONFIG_HISAX_BKM_A4T)		+= bkm_a4t.o jade.o
 hisax-$(CONFIG_HISAX_SCT_QUADRO)	+= bkm_a8.o hscx.o
 hisax-$(CONFIG_HISAX_GAZEL)		+= gazel.o hscx.o
 hisax-$(CONFIG_HISAX_W6692)		+= w6692.o
-hisax-$(CONFIG_HISAX_ENTERNOW_PCI)	+= enternow_pci.o amd7930_fn.o
 
diff --git a/drivers/isdn/hisax/config.c b/drivers/isdn/hisax/config.c
index 03c73e0..25320dd 100644
--- a/drivers/isdn/hisax/config.c
+++ b/drivers/isdn/hisax/config.c
@@ -529,10 +529,6 @@ extern int setup_gazel(struct IsdnCard *card);
 extern int setup_w6692(struct IsdnCard *card);
 #endif
 
-#if CARD_FN_ENTERNOW_PCI
-extern int setup_enternow_pci(struct IsdnCard *card);
-#endif
-
 /*
  * Find card with given driverId
  */
@@ -947,11 +943,6 @@ static int hisax_cs_setup_card(struct IsdnCard *card)
 		ret = setup_w6692(card);
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
@@ -959,6 +950,7 @@ static int hisax_cs_setup_card(struct IsdnCard *card)
 	/* list of ISDN_CTYPE_xxx support moved to a modular driver */
 	case ISDN_CTYPE_NETJET_S:
 	case ISDN_CTYPE_NETJET_U:
+	case ISDN_CTYPE_ENTERNOW:
 		printk(KERN_WARNING "HiSax: Support for %s Card has moved "
 		       "to separate PCI driver module\n",
 		       CardType[card->typ]);
@@ -1426,6 +1418,7 @@ static int __init HiSax_init(void)
 		/* the following block are excluded from std HiSax init */
 		case ISDN_CTYPE_NETJET_S:
 		case ISDN_CTYPE_NETJET_U:
+		case ISDN_CTYPE_ENTERNOW:
 			break;
 
 		case ISDN_CTYPE_BKM_A4T:
diff --git a/drivers/isdn/hisax/enternow_pci.c b/drivers/isdn/hisax/enternow_pci.c
index b73027f..978b99a 100644
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
@@ -384,8 +380,6 @@ static int __devinit en_cs_init_rest(struct IsdnCard *card,
 	return (1);
 }
 
-static struct pci_dev *dev_netjet __devinitdata = NULL;
-
 /* called by config.c */
 int __devinit
 setup_enternow_pci(struct IsdnCard *card)
@@ -393,6 +387,7 @@ setup_enternow_pci(struct IsdnCard *card)
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
diff --git a/drivers/isdn/hisax/nj_u.c b/drivers/isdn/hisax/nj_u.c
index e391eae..370535a 100644
--- a/drivers/isdn/hisax/nj_u.c
+++ b/drivers/isdn/hisax/nj_u.c
@@ -281,7 +281,7 @@ static struct pci_device_id nju_pci_table[] = {
 };
 
 static struct pci_driver nju_pci_driver = {
-	.name		= "nj_s",
+	.name		= "nj_u",
 	.id_table	= nju_pci_table,
 	.probe		= nju_pci_init_one,
 	.remove		= hisax_pci_remove_one,
