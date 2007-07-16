Return-Path: <linux-kernel-owner+w=401wt.eu-S1763590AbXGPF2W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763590AbXGPF2W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 01:28:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751781AbXGPF2L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 01:28:11 -0400
Received: from havoc.gtf.org ([69.61.125.42]:60351 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751972AbXGPF2J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 01:28:09 -0400
Date: Mon, 16 Jul 2007 01:28:06 -0400
From: Jeff Garzik <jeff@garzik.org>
To: kkeil@suse.de, linux-kernel@vger.kernel.org,
       isdn4linux@listserv.isdn4linux.de
Cc: Andrew Morton <akpm@linux-foundation.org>, surya.prabhakar@wipro.com
Subject: [PATCH 4/7] HiSax bkm_a4t: convert to PCI hotplug API
Message-ID: <20070716052805.GD21782@havoc.gtf.org>
References: <20070715095716.GA20949@havoc.gtf.org> <20070716052647.GA21782@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070716052647.GA21782@havoc.gtf.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


commit 9e435c5da75f6edead09e1acd9b2f441e16a539d
Author: Jeff Garzik <jeff@garzik.org>
Date:   Sun Jul 15 20:26:37 2007 -0400

    [ISDN] HiSax: convert bkm_a4t to PCI hotplug API
    
    Signed-off-by: Jeff Garzik <jeff@garzik.org>

 drivers/isdn/hisax/Kconfig   |    2 
 drivers/isdn/hisax/Makefile  |    3 -
 drivers/isdn/hisax/bkm_a4t.c |  118 ++++++++++++++++++++++++++++---------------
 drivers/isdn/hisax/config.c  |   20 -------
 4 files changed, 83 insertions(+), 60 deletions(-)

9e435c5da75f6edead09e1acd9b2f441e16a539d
diff --git a/drivers/isdn/hisax/Kconfig b/drivers/isdn/hisax/Kconfig
index 7de6fda..b04503d 100644
--- a/drivers/isdn/hisax/Kconfig
+++ b/drivers/isdn/hisax/Kconfig
@@ -287,7 +287,7 @@ config HISAX_HSTSAPHIR
 	  settings.
 
 config HISAX_BKM_A4T
-	bool "Telekom A4T card"
+	tristate "Telekom A4T card"
 	depends on PCI
 	help
 	  This enables HiSax support for the Telekom A4T card.
diff --git a/drivers/isdn/hisax/Makefile b/drivers/isdn/hisax/Makefile
index db5580b..e63e2af 100644
--- a/drivers/isdn/hisax/Makefile
+++ b/drivers/isdn/hisax/Makefile
@@ -18,7 +18,9 @@ obj-$(CONFIG_HISAX_FRITZ_PCIPNP)        += hisax_isac.o hisax_fcpcipnp.o
 obj-$(CONFIG_HISAX_NETJET)		+= netjet_s.o libhisax.o
 obj-$(CONFIG_HISAX_NETJET_U)		+= netjet_u.o libhisax.o
 obj-$(CONFIG_HISAX_ENTERNOW_PCI)	+= enternow.o libhisax.o
+obj-$(CONFIG_HISAX_BKM_A4T)		+= bkm_a4t_pci.o
 
+bkm_a4t_pci-objs			:= bkm_a4t.o jade.o
 enternow-objs				:= enternow_pci.o amd7930_fn.o
 netjet_s-objs				:= nj_s.o
 netjet_u-objs				:= nj_u.o icc.o
@@ -60,7 +62,6 @@ hisax-$(CONFIG_HISAX_HFC_SX)		+= hfc_sx.o
 hisax-$(CONFIG_HISAX_NICCY)		+= niccy.o hscx.o
 hisax-$(CONFIG_HISAX_ISURF)		+= isurf.o sar.o
 hisax-$(CONFIG_HISAX_HSTSAPHIR)		+= saphir.o hscx.o
-hisax-$(CONFIG_HISAX_BKM_A4T)		+= bkm_a4t.o jade.o
 hisax-$(CONFIG_HISAX_SCT_QUADRO)	+= bkm_a8.o hscx.o
 hisax-$(CONFIG_HISAX_GAZEL)		+= gazel.o hscx.o
 hisax-$(CONFIG_HISAX_W6692)		+= w6692.o
diff --git a/drivers/isdn/hisax/bkm_a4t.c b/drivers/isdn/hisax/bkm_a4t.c
index 3d1bdc8..918afb3 100644
--- a/drivers/isdn/hisax/bkm_a4t.c
+++ b/drivers/isdn/hisax/bkm_a4t.c
@@ -13,6 +13,7 @@
 
 #include <linux/init.h>
 #include "hisax.h"
+#include "hisax_proto.h"
 #include "isac.h"
 #include "hscx.h"
 #include "jade.h"
@@ -20,7 +21,7 @@
 #include <linux/pci.h>
 #include "bkm_ax.h"
 
-extern const char *CardType[];
+static int a4t_protocol;		/* 0 == use DEFAULT_PROTO */
 
 static const char *bkm_a4t_revision = "$Revision: 1.22.2.4 $";
 
@@ -257,24 +258,21 @@ BKM_card_msg(struct IsdnCardState *cs, int mt, void *arg)
 
 static int __devinit a4t_pci_probe(struct pci_dev *dev_a4t,
 				   struct IsdnCardState *cs,
-				   u_int *found,
 				   u_int *pci_memaddr)
 {
-	u16 sub_sys;
-	u16 sub_vendor;
-
-	sub_vendor = dev_a4t->subsystem_vendor;
-	sub_sys = dev_a4t->subsystem_device;
-	if ((sub_sys == PCI_DEVICE_ID_BERKOM_A4T) && (sub_vendor == PCI_VENDOR_ID_BERKOM)) {
-		if (pci_enable_device(dev_a4t))
-			return (0);	/* end loop & function */
-		*found = 1;
-		*pci_memaddr = pci_resource_start(dev_a4t, 0);
-		cs->irq = dev_a4t->irq;
-		return (1);		/* end loop */
+	if (pci_enable_device(dev_a4t))
+		return (0);	/* error */
+
+	*pci_memaddr = pci_resource_start(dev_a4t, 0);
+	if (!(*pci_memaddr)) {
+		printk(KERN_WARNING "HiSax bkm_a4t: No Memory base address\n");
+		return (0);
 	}
 
-	return (-1);			/* continue looping */
+	cs->irq = dev_a4t->irq;
+
+	cs->hw.ax.dev = dev_a4t;
+	return (1);		/* success */
 }
 
 static int __devinit a4t_cs_init(struct IsdnCard *card,
@@ -284,7 +282,7 @@ static int __devinit a4t_cs_init(struct IsdnCard *card,
 	I20_REGISTER_FILE *pI20_Regs;
 
 	if (!cs->irq) {		/* IRQ range check ?? */
-		printk(KERN_WARNING "HiSax: %s: No IRQ\n", CardType[card->typ]);
+		printk(KERN_WARNING "HiSax: bkm_a4t: No IRQ\n");
 		return (0);
 	}
 	cs->hw.ax.base = (long) ioremap(pci_memaddr, 4096);
@@ -292,7 +290,7 @@ static int __devinit a4t_cs_init(struct IsdnCard *card,
 	pI20_Regs = (I20_REGISTER_FILE *) (cs->hw.ax.base);
 	if ((pI20_Regs->i20IntStatus & 0x8EFFFFFF) != 0) {
 		printk(KERN_WARNING "HiSax: %s address %lx-%lx suspecious\n",
-		       CardType[card->typ], cs->hw.ax.base, cs->hw.ax.base + 4096);
+		       "bkm_a4t", cs->hw.ax.base, cs->hw.ax.base + 4096);
 		iounmap((void *) cs->hw.ax.base);
 		cs->hw.ax.base = 0;
 		return (0);
@@ -303,7 +301,7 @@ static int __devinit a4t_cs_init(struct IsdnCard *card,
 	cs->hw.ax.jade_ale = GCS_3;
 
 	printk(KERN_INFO "HiSax: %s: Card configured at 0x%lX IRQ %d\n",
-	       CardType[card->typ], cs->hw.ax.base, cs->irq);
+	       "bkm_a4t", cs->hw.ax.base, cs->irq);
 
 	setup_isac(cs);
 	cs->readisac = &ReadISAC;
@@ -323,39 +321,79 @@ static int __devinit a4t_cs_init(struct IsdnCard *card,
 	return (1);
 }
 
-static struct pci_dev *dev_a4t __devinitdata = NULL;
-
 int __devinit
 setup_bkm_a4t(struct IsdnCard *card)
 {
 	struct IsdnCardState *cs = card->cs;
 	char tmp[64];
-	u_int pci_memaddr = 0, found = 0;
+	u_int pci_memaddr = 0;
 	int ret;
+	struct pci_dev *dev_a4t = (void *) card->para[0];
 
 	strcpy(tmp, bkm_a4t_revision);
 	printk(KERN_INFO "HiSax: T-Berkom driver Rev. %s\n", HiSax_getrev(tmp));
-	if (cs->typ == ISDN_CTYPE_BKM_A4T) {
-		cs->subtyp = BKM_A4T;
-	} else
-		return (0);
 
-	while ((dev_a4t = pci_find_device(PCI_VENDOR_ID_ZORAN,
-		PCI_DEVICE_ID_ZORAN_36120, dev_a4t))) {
-		ret = a4t_pci_probe(dev_a4t, cs, &found, &pci_memaddr);
-		if (!ret)
-			return (0);
-		if (ret > 0)
-			break;
-	}
-	if (!found) {
-		printk(KERN_WARNING "HiSax: %s: Card not found\n", CardType[card->typ]);
-		return (0);
-	}
-	if (!pci_memaddr) {
-		printk(KERN_WARNING "HiSax: %s: No Memory base address\n", CardType[card->typ]);
+	WARN_ON(cs->typ != ISDN_CTYPE_BKM_A4T);
+
+	cs->subtyp = BKM_A4T;
+
+	ret = a4t_pci_probe(dev_a4t, cs, &pci_memaddr);
+	if (!ret)
 		return (0);
-	}
 
 	return a4t_cs_init(card, cs, pci_memaddr);
 }
+
+static int __devinit a4t_pci_init_one(struct pci_dev *pdev,
+				      const struct pci_device_id *ent)
+{
+	struct IsdnCard icard = { ISDN_CTYPE_BKM_A4T, };
+	int cardnr;
+
+	icard.para[0] = (unsigned long) pdev;
+	if (!a4t_protocol)
+		icard.protocol = DEFAULT_PROTO;
+	else
+		icard.protocol = a4t_protocol;
+
+	cardnr = hisax_init_hotplug(&icard, setup_bkm_a4t);
+	if (cardnr < 0)
+		return -ENODEV;
+	
+	pci_set_drvdata(pdev, (void *)(unsigned long) cardnr);
+	return 0;
+}
+
+static struct pci_device_id a4t_pci_table[] = {
+	{ PCI_VENDOR_ID_ZORAN, PCI_DEVICE_ID_ZORAN_36120,
+	  PCI_VENDOR_ID_BERKOM, PCI_DEVICE_ID_BERKOM_A4T, },
+
+	{ }		/* terminate list */
+};
+
+static struct pci_driver a4t_pci_driver = {
+	.name		= "bkm_a4t",
+	.id_table	= a4t_pci_table,
+	.probe		= a4t_pci_init_one,
+	.remove		= hisax_pci_remove_one,
+};
+
+static int __init a4t_mod_init(void)
+{
+	return pci_register_driver(&a4t_pci_driver);
+}
+
+static void __exit a4t_mod_exit(void)
+{
+	pci_unregister_driver(&a4t_pci_driver);
+}
+
+module_init(a4t_mod_init);
+module_exit(a4t_mod_exit);
+
+module_param_named(protocol, a4t_protocol, int, 0444);
+MODULE_PARM_DESC(protocol, "Values 0 (default) through 4. See ISDN_PTYPE_xxx in linux/isdnif.h");
+
+MODULE_DEVICE_TABLE(pci, a4t_pci_table);
+MODULE_DESCRIPTION("ISDN HiSax BKM A4T PCI driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/isdn/hisax/config.c b/drivers/isdn/hisax/config.c
index 25320dd..2ba96d0 100644
--- a/drivers/isdn/hisax/config.c
+++ b/drivers/isdn/hisax/config.c
@@ -243,13 +243,6 @@ const char *CardType[] = {
 #define DEFAULT_CFG {5,0x250,0,0}
 #endif
 
-#ifdef CONFIG_HISAX_BKM_A4T
-#undef DEFAULT_CARD
-#undef DEFAULT_CFG
-#define DEFAULT_CARD ISDN_CTYPE_BKM_A4T
-#define DEFAULT_CFG {0,0x0,0,0}
-#endif
-
 #ifdef CONFIG_HISAX_SCT_QUADRO
 #undef DEFAULT_CARD
 #undef DEFAULT_CFG
@@ -513,10 +506,6 @@ extern int setup_isurf(struct IsdnCard *card);
 extern int setup_saphir(struct IsdnCard *card);
 #endif
 
-#if CARD_BKM_A4T
-extern int setup_bkm_a4t(struct IsdnCard *card);
-#endif
-
 #if CARD_SCT_QUADRO
 extern int setup_sct_quadro(struct IsdnCard *card);
 #endif
@@ -923,11 +912,6 @@ static int hisax_cs_setup_card(struct IsdnCard *card)
 		ret = setup_saphir(card);
 		break;
 #endif
-#if	CARD_BKM_A4T
-	case ISDN_CTYPE_BKM_A4T:
-		ret = setup_bkm_a4t(card);
-		break;
-#endif
 #if	CARD_SCT_QUADRO
 	case ISDN_CTYPE_SCT_QUADRO:
 		ret = setup_sct_quadro(card);
@@ -951,6 +935,7 @@ static int hisax_cs_setup_card(struct IsdnCard *card)
 	case ISDN_CTYPE_NETJET_S:
 	case ISDN_CTYPE_NETJET_U:
 	case ISDN_CTYPE_ENTERNOW:
+	case ISDN_CTYPE_BKM_A4T:
 		printk(KERN_WARNING "HiSax: Support for %s Card has moved "
 		       "to separate PCI driver module\n",
 		       CardType[card->typ]);
@@ -1419,10 +1404,9 @@ static int __init HiSax_init(void)
 		case ISDN_CTYPE_NETJET_S:
 		case ISDN_CTYPE_NETJET_U:
 		case ISDN_CTYPE_ENTERNOW:
-			break;
-
 		case ISDN_CTYPE_BKM_A4T:
 			break;
+
 		case ISDN_CTYPE_SCT_QUADRO:
 			if (irq[i]) {
 				cards[j].para[0] = irq[i];
