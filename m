Return-Path: <linux-kernel-owner+w=401wt.eu-S1764053AbXGPF2t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764053AbXGPF2t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 01:28:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752458AbXGPF2l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 01:28:41 -0400
Received: from havoc.gtf.org ([69.61.125.42]:60358 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751752AbXGPF2k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 01:28:40 -0400
Date: Mon, 16 Jul 2007 01:28:39 -0400
From: Jeff Garzik <jeff@garzik.org>
To: kkeil@suse.de, linux-kernel@vger.kernel.org,
       isdn4linux@listserv.isdn4linux.de
Cc: Andrew Morton <akpm@linux-foundation.org>, surya.prabhakar@wipro.com
Subject: [PATCH 5/7] HiSax w6692: convert to PCI hotplug API
Message-ID: <20070716052839.GE21782@havoc.gtf.org>
References: <20070715095716.GA20949@havoc.gtf.org> <20070716052647.GA21782@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070716052647.GA21782@havoc.gtf.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


commit fc1418cbccc453729296fbacaeaaa13e8b71a830
Author: Jeff Garzik <jeff@garzik.org>
Date:   Sun Jul 15 21:28:34 2007 -0400

    [ISDN] HiSax: Convert w6692 driver to PCI hotplug API

    [ed.: also, some additional EXPORT_SYMBOL and Makefile fixes]
    
    Signed-off-by: Jeff Garzik <jeff@garzik.org>

 drivers/isdn/hisax/Kconfig  |    2 
 drivers/isdn/hisax/Makefile |    4 -
 drivers/isdn/hisax/config.c |   23 --------
 drivers/isdn/hisax/isdnl1.c |    2 
 drivers/isdn/hisax/lmgr.c   |    2 
 drivers/isdn/hisax/w6692.c  |  116 ++++++++++++++++++++++++++++----------------
 6 files changed, 83 insertions(+), 66 deletions(-)

fc1418cbccc453729296fbacaeaaa13e8b71a830
diff --git a/drivers/isdn/hisax/Kconfig b/drivers/isdn/hisax/Kconfig
index b04503d..03e4ea5 100644
--- a/drivers/isdn/hisax/Kconfig
+++ b/drivers/isdn/hisax/Kconfig
@@ -325,7 +325,7 @@ config HISAX_HFC_PCI
 	  <file:Documentation/isdn/README.hfc-pci>.
 
 config HISAX_W6692
-	bool "Winbond W6692 based cards"
+	tristate "Winbond W6692 based cards"
 	depends on PCI
 	help
 	  This enables HiSax support for Winbond W6692 based PCI ISDN cards.
diff --git a/drivers/isdn/hisax/Makefile b/drivers/isdn/hisax/Makefile
index e63e2af..1f02120 100644
--- a/drivers/isdn/hisax/Makefile
+++ b/drivers/isdn/hisax/Makefile
@@ -18,7 +18,8 @@ obj-$(CONFIG_HISAX_FRITZ_PCIPNP)        += hisax_isac.o hisax_fcpcipnp.o
 obj-$(CONFIG_HISAX_NETJET)		+= netjet_s.o libhisax.o
 obj-$(CONFIG_HISAX_NETJET_U)		+= netjet_u.o libhisax.o
 obj-$(CONFIG_HISAX_ENTERNOW_PCI)	+= enternow.o libhisax.o
-obj-$(CONFIG_HISAX_BKM_A4T)		+= bkm_a4t_pci.o
+obj-$(CONFIG_HISAX_BKM_A4T)		+= bkm_a4t_pci.o libhisax.o
+obj-$(CONFIG_HISAX_W6692)		+= w6692.o libhisax.o
 
 bkm_a4t_pci-objs			:= bkm_a4t.o jade.o
 enternow-objs				:= enternow_pci.o amd7930_fn.o
@@ -64,5 +65,4 @@ hisax-$(CONFIG_HISAX_ISURF)		+= isurf.o sar.o
 hisax-$(CONFIG_HISAX_HSTSAPHIR)		+= saphir.o hscx.o
 hisax-$(CONFIG_HISAX_SCT_QUADRO)	+= bkm_a8.o hscx.o
 hisax-$(CONFIG_HISAX_GAZEL)		+= gazel.o hscx.o
-hisax-$(CONFIG_HISAX_W6692)		+= w6692.o
 
diff --git a/drivers/isdn/hisax/config.c b/drivers/isdn/hisax/config.c
index 2ba96d0..163a636 100644
--- a/drivers/isdn/hisax/config.c
+++ b/drivers/isdn/hisax/config.c
@@ -257,13 +257,6 @@ const char *CardType[] = {
 #define DEFAULT_CFG {15,0x180,0,0}
 #endif
 
-#ifdef CONFIG_HISAX_W6692
-#undef DEFAULT_CARD
-#undef DEFAULT_CFG
-#define DEFAULT_CARD ISDN_CTYPE_W6692
-#define DEFAULT_CFG {0,0,0,0}
-#endif
-
 #ifndef DEFAULT_CARD
 #define DEFAULT_CARD 0
 #define DEFAULT_CFG {0,0,0,0}
@@ -514,10 +507,6 @@ extern int setup_sct_quadro(struct IsdnCard *card);
 extern int setup_gazel(struct IsdnCard *card);
 #endif
 
-#if CARD_W6692
-extern int setup_w6692(struct IsdnCard *card);
-#endif
-
 /*
  * Find card with given driverId
  */
@@ -922,11 +911,6 @@ static int hisax_cs_setup_card(struct IsdnCard *card)
 		ret = setup_gazel(card);
 		break;
 #endif
-#if CARD_W6692
-	case ISDN_CTYPE_W6692:
-		ret = setup_w6692(card);
-		break;
-#endif
 	case ISDN_CTYPE_DYNAMIC:
 		ret = 2;
 		break;
@@ -936,6 +920,7 @@ static int hisax_cs_setup_card(struct IsdnCard *card)
 	case ISDN_CTYPE_NETJET_U:
 	case ISDN_CTYPE_ENTERNOW:
 	case ISDN_CTYPE_BKM_A4T:
+	case ISDN_CTYPE_W6692:
 		printk(KERN_WARNING "HiSax: Support for %s Card has moved "
 		       "to separate PCI driver module\n",
 		       CardType[card->typ]);
@@ -1397,7 +1382,6 @@ static int __init HiSax_init(void)
 			break;
 		case ISDN_CTYPE_ELSA_PCI:
 		case ISDN_CTYPE_TELESPCI:
-		case ISDN_CTYPE_W6692:
 			break;
 
 		/* the following block are excluded from std HiSax init */
@@ -1405,6 +1389,7 @@ static int __init HiSax_init(void)
 		case ISDN_CTYPE_NETJET_U:
 		case ISDN_CTYPE_ENTERNOW:
 		case ISDN_CTYPE_BKM_A4T:
+		case ISDN_CTYPE_W6692:
 			break;
 
 		case ISDN_CTYPE_SCT_QUADRO:
@@ -1910,10 +1895,6 @@ static struct pci_device_id hisax_pci_tbl[] __devinitdata = {
 #if defined(CONFIG_HISAX_TELESPCI) || defined(CONFIG_HISAX_SCT_QUADRO)
 	{PCI_VENDOR_ID_ZORAN,    PCI_DEVICE_ID_ZORAN_36120,      PCI_ANY_ID,PCI_ANY_ID},
 #endif
-#ifdef CONFIG_HISAX_W6692
-	{PCI_VENDOR_ID_DYNALINK, PCI_DEVICE_ID_DYNALINK_IS64PH,  PCI_ANY_ID,PCI_ANY_ID},
-	{PCI_VENDOR_ID_WINBOND2, PCI_DEVICE_ID_WINBOND2_6692,    PCI_ANY_ID,PCI_ANY_ID},
-#endif
 #ifdef CONFIG_HISAX_HFC_PCI
 	{PCI_VENDOR_ID_CCD,      PCI_DEVICE_ID_CCD_2BD0,         PCI_ANY_ID, PCI_ANY_ID},
 	{PCI_VENDOR_ID_CCD,      PCI_DEVICE_ID_CCD_B000,         PCI_ANY_ID, PCI_ANY_ID},
diff --git a/drivers/isdn/hisax/isdnl1.c b/drivers/isdn/hisax/isdnl1.c
index c939167..ec81b12 100644
--- a/drivers/isdn/hisax/isdnl1.c
+++ b/drivers/isdn/hisax/isdnl1.c
@@ -935,7 +935,9 @@ setstack_l1_B(struct PStack *st)
 }
 
 EXPORT_SYMBOL(l1_msg);
+EXPORT_SYMBOL(l1_msg_b);
 EXPORT_SYMBOL(debugl1);
+EXPORT_SYMBOL(setstack_l1_B);
 EXPORT_SYMBOL(DChannel_proc_rcv);
 EXPORT_SYMBOL(DChannel_proc_xmt);
 #ifdef L2FRAME_DEBUG
diff --git a/drivers/isdn/hisax/lmgr.c b/drivers/isdn/hisax/lmgr.c
index d4f86d6..5980490 100644
--- a/drivers/isdn/hisax/lmgr.c
+++ b/drivers/isdn/hisax/lmgr.c
@@ -48,3 +48,5 @@ setstack_manager(struct PStack *st)
 {
 	st->ma.layer = hisax_manager;
 }
+
+EXPORT_SYMBOL(setstack_manager);
diff --git a/drivers/isdn/hisax/w6692.c b/drivers/isdn/hisax/w6692.c
index 3aeceaf..07d8e1e 100644
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
 int __devinit
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
-#ifdef CONFIG_PCI
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
+	WARN_ON(cs->typ != ISDN_CTYPE_W6692);
+
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
@@ -1061,11 +1039,6 @@ setup_w6692(struct IsdnCard *card)
 		       cs->hw.w6692.iobase + 255);
 		return (0);
 	}
-#else
-	printk(KERN_WARNING "HiSax: W6692 and NO_PCI_BIOS\n");
-	printk(KERN_WARNING "HiSax: W6692 unable to config\n");
-	return (0);
-#endif				/* CONFIG_PCI */
 
 	printk(KERN_INFO
 	       "HiSax: %s config irq:%d I/O:%x\n",
@@ -1091,3 +1064,62 @@ setup_w6692(struct IsdnCard *card)
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
