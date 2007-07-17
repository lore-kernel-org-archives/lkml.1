Return-Path: <linux-kernel-owner+w=401wt.eu-S933631AbXGQWBx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933631AbXGQWBx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 18:01:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757530AbXGQWBn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 18:01:43 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55673 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755289AbXGQWBl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 18:01:41 -0400
Date: Tue, 17 Jul 2007 18:01:30 -0400
From: Jeff Garzik <jgarzik@redhat.com>
To: akpm@linux-foundation.org, torvalds@linux-foundation.org, kkeil@suse.de
Cc: isdn4linux@listserv.isdn4linux.de, linux-kernel@vger.kernel.org
Subject: [git patches] ISDN code movement
Message-ID: <20070717220130.GH28448@devserv.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


ISDN holds the largest concentrated block of drivers using
pci_find_device() rather than PCI hotplug API, or at least the
properly-refcounted pci_get_device().

Over the weekend I converted several of these drivers to the PCI
hotplug API.  That approach still needs verifying by ISDN people, but I
feel that pure code movement, no-code-change style patches should be
pushed upstream sooner rather than later.

Thus, speaking strictly, the only code changes are
* that which is necessary to call split-out functions from the old code site
* removal of CONFIG_PCI ifdefs, and !CONFIG_PCI dead code guaranteed as
  such by Kconfig dependencies
* hfc_pci: removal of "return;" at the tail of some functions

The code should behave precisely the same as before.  Any bug or change
in behavior is an easily bisectable regression.   But hopefully this is
as close to an equivalent-transformation change as there can be.

This sets us up to be in great shape to support PCI hotplug API, and
I've already done that work (branch isdn-pci, DO NOT PULL that one).

Please pull from 'isdn-cleanup' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/misc-2.6.git isdn-cleanup

to receive the following updates:

 drivers/isdn/hisax/bkm_a4t.c      |  108 ++++++++++-------
 drivers/isdn/hisax/config.c       |  233 ++++++++++++++++++++++---------------
 drivers/isdn/hisax/enternow_pci.c |  165 ++++++++++++++------------
 drivers/isdn/hisax/hfc_pci.c      |  191 +++++++++++++++----------------
 drivers/isdn/hisax/nj_s.c         |  194 +++++++++++++++++--------------
 drivers/isdn/hisax/nj_u.c         |  167 +++++++++++++++------------
 6 files changed, 586 insertions(+), 472 deletions(-)

Jeff Garzik (7):
      [ISDN] HiSax: move card setup into separate function
      [ISDN] HiSax: move card state alloc/setup code into separate functions
      [ISDN] HiSax netjet_s: code movement, prep for hotplug
      [ISDN] HiSax netjet_u: split setup into 3 smaller functions
      [ISDN] HiSax enternow: split setup into 3 smaller functions
      [ISDN] HiSax bkm_a4t: split setup into two smaller functions
      [ISDN] HiSax hfc_pci: minor cleanups

diff --git a/drivers/isdn/hisax/bkm_a4t.c b/drivers/isdn/hisax/bkm_a4t.c
index 871310d..3d1bdc8 100644
--- a/drivers/isdn/hisax/bkm_a4t.c
+++ b/drivers/isdn/hisax/bkm_a4t.c
@@ -255,54 +255,38 @@ BKM_card_msg(struct IsdnCardState *cs, int mt, void *arg)
 	return (0);
 }
 
-static struct pci_dev *dev_a4t __devinitdata = NULL;
+static int __devinit a4t_pci_probe(struct pci_dev *dev_a4t,
+				   struct IsdnCardState *cs,
+				   u_int *found,
+				   u_int *pci_memaddr)
+{
+	u16 sub_sys;
+	u16 sub_vendor;
+
+	sub_vendor = dev_a4t->subsystem_vendor;
+	sub_sys = dev_a4t->subsystem_device;
+	if ((sub_sys == PCI_DEVICE_ID_BERKOM_A4T) && (sub_vendor == PCI_VENDOR_ID_BERKOM)) {
+		if (pci_enable_device(dev_a4t))
+			return (0);	/* end loop & function */
+		*found = 1;
+		*pci_memaddr = pci_resource_start(dev_a4t, 0);
+		cs->irq = dev_a4t->irq;
+		return (1);		/* end loop */
+	}
 
-int __devinit
-setup_bkm_a4t(struct IsdnCard *card)
+	return (-1);			/* continue looping */
+}
+
+static int __devinit a4t_cs_init(struct IsdnCard *card,
+				 struct IsdnCardState *cs,
+				 u_int pci_memaddr)
 {
-	struct IsdnCardState *cs = card->cs;
-	char tmp[64];
-	u_int pci_memaddr = 0, found = 0;
 	I20_REGISTER_FILE *pI20_Regs;
-#ifdef CONFIG_PCI
-#endif
-
-	strcpy(tmp, bkm_a4t_revision);
-	printk(KERN_INFO "HiSax: T-Berkom driver Rev. %s\n", HiSax_getrev(tmp));
-	if (cs->typ == ISDN_CTYPE_BKM_A4T) {
-		cs->subtyp = BKM_A4T;
-	} else
-		return (0);
 
-#ifdef CONFIG_PCI
-	while ((dev_a4t = pci_find_device(PCI_VENDOR_ID_ZORAN,
-		PCI_DEVICE_ID_ZORAN_36120, dev_a4t))) {
-		u16 sub_sys;
-		u16 sub_vendor;
-
-		sub_vendor = dev_a4t->subsystem_vendor;
-		sub_sys = dev_a4t->subsystem_device;
-		if ((sub_sys == PCI_DEVICE_ID_BERKOM_A4T) && (sub_vendor == PCI_VENDOR_ID_BERKOM)) {
-			if (pci_enable_device(dev_a4t))
-				return(0);
-			found = 1;
-			pci_memaddr = pci_resource_start(dev_a4t, 0);
-			cs->irq = dev_a4t->irq;
-			break;
-		}
-	}
-	if (!found) {
-		printk(KERN_WARNING "HiSax: %s: Card not found\n", CardType[card->typ]);
-		return (0);
-	}
 	if (!cs->irq) {		/* IRQ range check ?? */
 		printk(KERN_WARNING "HiSax: %s: No IRQ\n", CardType[card->typ]);
 		return (0);
 	}
-	if (!pci_memaddr) {
-		printk(KERN_WARNING "HiSax: %s: No Memory base address\n", CardType[card->typ]);
-		return (0);
-	}
 	cs->hw.ax.base = (long) ioremap(pci_memaddr, 4096);
 	/* Check suspecious address */
 	pI20_Regs = (I20_REGISTER_FILE *) (cs->hw.ax.base);
@@ -317,11 +301,7 @@ setup_bkm_a4t(struct IsdnCard *card)
 	cs->hw.ax.jade_adr = cs->hw.ax.base + PO_OFFSET;
 	cs->hw.ax.isac_ale = GCS_1;
 	cs->hw.ax.jade_ale = GCS_3;
-#else
-	printk(KERN_WARNING "HiSax: %s: NO_PCI_BIOS\n", CardType[card->typ]);
-	printk(KERN_WARNING "HiSax: %s: unable to configure\n", CardType[card->typ]);
-	return (0);
-#endif				/* CONFIG_PCI */
+
 	printk(KERN_INFO "HiSax: %s: Card configured at 0x%lX IRQ %d\n",
 	       CardType[card->typ], cs->hw.ax.base, cs->irq);
 
@@ -339,5 +319,43 @@ setup_bkm_a4t(struct IsdnCard *card)
 	ISACVersion(cs, "Telekom A4T:");
 	/* Jade version */
 	JadeVersion(cs, "Telekom A4T:");
+
 	return (1);
 }
+
+static struct pci_dev *dev_a4t __devinitdata = NULL;
+
+int __devinit
+setup_bkm_a4t(struct IsdnCard *card)
+{
+	struct IsdnCardState *cs = card->cs;
+	char tmp[64];
+	u_int pci_memaddr = 0, found = 0;
+	int ret;
+
+	strcpy(tmp, bkm_a4t_revision);
+	printk(KERN_INFO "HiSax: T-Berkom driver Rev. %s\n", HiSax_getrev(tmp));
+	if (cs->typ == ISDN_CTYPE_BKM_A4T) {
+		cs->subtyp = BKM_A4T;
+	} else
+		return (0);
+
+	while ((dev_a4t = pci_find_device(PCI_VENDOR_ID_ZORAN,
+		PCI_DEVICE_ID_ZORAN_36120, dev_a4t))) {
+		ret = a4t_pci_probe(dev_a4t, cs, &found, &pci_memaddr);
+		if (!ret)
+			return (0);
+		if (ret > 0)
+			break;
+	}
+	if (!found) {
+		printk(KERN_WARNING "HiSax: %s: Card not found\n", CardType[card->typ]);
+		return (0);
+	}
+	if (!pci_memaddr) {
+		printk(KERN_WARNING "HiSax: %s: No Memory base address\n", CardType[card->typ]);
+		return (0);
+	}
+
+	return a4t_cs_init(card, cs, pci_memaddr);
+}
diff --git a/drivers/isdn/hisax/config.c b/drivers/isdn/hisax/config.c
index a43162c..5f7907e 100644
--- a/drivers/isdn/hisax/config.c
+++ b/drivers/isdn/hisax/config.c
@@ -847,95 +847,10 @@ static int init_card(struct IsdnCardState *cs)
 	return 3;
 }
 
-static int checkcard(int cardnr, char *id, int *busy_flag, struct module *lockowner)
+static int hisax_cs_setup_card(struct IsdnCard *card)
 {
-	int ret = 0;
-	struct IsdnCard *card = cards + cardnr;
-	struct IsdnCardState *cs;
+	int ret;
 
-	cs = kzalloc(sizeof(struct IsdnCardState), GFP_ATOMIC);
-	if (!cs) {
-		printk(KERN_WARNING
-		       "HiSax: No memory for IsdnCardState(card %d)\n",
-		       cardnr + 1);
-		goto out;
-	}
-	card->cs = cs;
-	spin_lock_init(&cs->statlock);
-	spin_lock_init(&cs->lock);
-	cs->chanlimit = 2;	/* maximum B-channel number */
-	cs->logecho = 0;	/* No echo logging */
-	cs->cardnr = cardnr;
-	cs->debug = L1_DEB_WARN;
-	cs->HW_Flags = 0;
-	cs->busy_flag = busy_flag;
-	cs->irq_flags = I4L_IRQ_FLAG;
-#if TEI_PER_CARD
-	if (card->protocol == ISDN_PTYPE_NI1)
-		test_and_set_bit(FLG_TWO_DCHAN, &cs->HW_Flags);
-#else
-	test_and_set_bit(FLG_TWO_DCHAN, &cs->HW_Flags);
-#endif
-	cs->protocol = card->protocol;
-
-	if (card->typ <= 0 || card->typ > ISDN_CTYPE_COUNT) {
-		printk(KERN_WARNING
-		       "HiSax: Card Type %d out of range\n", card->typ);
-		goto outf_cs;
-	}
-	if (!(cs->dlog = kmalloc(MAX_DLOG_SPACE, GFP_ATOMIC))) {
-		printk(KERN_WARNING
-		       "HiSax: No memory for dlog(card %d)\n", cardnr + 1);
-		goto outf_cs;
-	}
-	if (!(cs->status_buf = kmalloc(HISAX_STATUS_BUFSIZE, GFP_ATOMIC))) {
-		printk(KERN_WARNING
-		       "HiSax: No memory for status_buf(card %d)\n",
-		       cardnr + 1);
-		goto outf_dlog;
-	}
-	cs->stlist = NULL;
-	cs->status_read = cs->status_buf;
-	cs->status_write = cs->status_buf;
-	cs->status_end = cs->status_buf + HISAX_STATUS_BUFSIZE - 1;
-	cs->typ = card->typ;
-#ifdef MODULE
-	cs->iif.owner = lockowner;
-#endif
-	strcpy(cs->iif.id, id);
-	cs->iif.channels = 2;
-	cs->iif.maxbufsize = MAX_DATA_SIZE;
-	cs->iif.hl_hdrlen = MAX_HEADER_LEN;
-	cs->iif.features =
-		ISDN_FEATURE_L2_X75I |
-		ISDN_FEATURE_L2_HDLC |
-		ISDN_FEATURE_L2_HDLC_56K |
-		ISDN_FEATURE_L2_TRANS |
-		ISDN_FEATURE_L3_TRANS |
-#ifdef	CONFIG_HISAX_1TR6
-		ISDN_FEATURE_P_1TR6 |
-#endif
-#ifdef	CONFIG_HISAX_EURO
-		ISDN_FEATURE_P_EURO |
-#endif
-#ifdef	CONFIG_HISAX_NI1
-		ISDN_FEATURE_P_NI1 |
-#endif
-		0;
-
-	cs->iif.command = HiSax_command;
-	cs->iif.writecmd = NULL;
-	cs->iif.writebuf_skb = HiSax_writebuf_skb;
-	cs->iif.readstat = HiSax_readstatus;
-	register_isdn(&cs->iif);
-	cs->myid = cs->iif.channels;
-	printk(KERN_INFO
-	       "HiSax: Card %d Protocol %s Id=%s (%d)\n", cardnr + 1,
-	       (card->protocol == ISDN_PTYPE_1TR6) ? "1TR6" :
-	       (card->protocol == ISDN_PTYPE_EURO) ? "EDSS1" :
-	       (card->protocol == ISDN_PTYPE_LEASED) ? "LEASED" :
-	       (card->protocol == ISDN_PTYPE_NI1) ? "NI1" :
-	       "NONE", cs->iif.id, cs->myid);
 	switch (card->typ) {
 #if CARD_TELES0
 	case ISDN_CTYPE_16_0:
@@ -1094,13 +1009,115 @@ static int checkcard(int cardnr, char *id, int *busy_flag, struct module *lockow
 		printk(KERN_WARNING
 		       "HiSax: Support for %s Card not selected\n",
 		       CardType[card->typ]);
-		ll_unload(cs);
+		ret = 0;
+		break;
+	}
+
+	return ret;
+}
+
+static int hisax_cs_new(int cardnr, char *id, struct IsdnCard *card,
+			struct IsdnCardState **cs_out, int *busy_flag,
+			struct module *lockowner)
+{
+	struct IsdnCardState *cs;
+
+	*cs_out = NULL;
+
+	cs = kzalloc(sizeof(struct IsdnCardState), GFP_ATOMIC);
+	if (!cs) {
+		printk(KERN_WARNING
+		       "HiSax: No memory for IsdnCardState(card %d)\n",
+		       cardnr + 1);
+		goto out;
+	}
+	card->cs = cs;
+	spin_lock_init(&cs->statlock);
+	spin_lock_init(&cs->lock);
+	cs->chanlimit = 2;	/* maximum B-channel number */
+	cs->logecho = 0;	/* No echo logging */
+	cs->cardnr = cardnr;
+	cs->debug = L1_DEB_WARN;
+	cs->HW_Flags = 0;
+	cs->busy_flag = busy_flag;
+	cs->irq_flags = I4L_IRQ_FLAG;
+#if TEI_PER_CARD
+	if (card->protocol == ISDN_PTYPE_NI1)
+		test_and_set_bit(FLG_TWO_DCHAN, &cs->HW_Flags);
+#else
+	test_and_set_bit(FLG_TWO_DCHAN, &cs->HW_Flags);
+#endif
+	cs->protocol = card->protocol;
+
+	if (card->typ <= 0 || card->typ > ISDN_CTYPE_COUNT) {
+		printk(KERN_WARNING
+		       "HiSax: Card Type %d out of range\n", card->typ);
 		goto outf_cs;
 	}
-	if (!ret) {
-		ll_unload(cs);
+	if (!(cs->dlog = kmalloc(MAX_DLOG_SPACE, GFP_ATOMIC))) {
+		printk(KERN_WARNING
+		       "HiSax: No memory for dlog(card %d)\n", cardnr + 1);
 		goto outf_cs;
 	}
+	if (!(cs->status_buf = kmalloc(HISAX_STATUS_BUFSIZE, GFP_ATOMIC))) {
+		printk(KERN_WARNING
+		       "HiSax: No memory for status_buf(card %d)\n",
+		       cardnr + 1);
+		goto outf_dlog;
+	}
+	cs->stlist = NULL;
+	cs->status_read = cs->status_buf;
+	cs->status_write = cs->status_buf;
+	cs->status_end = cs->status_buf + HISAX_STATUS_BUFSIZE - 1;
+	cs->typ = card->typ;
+#ifdef MODULE
+	cs->iif.owner = lockowner;
+#endif
+	strcpy(cs->iif.id, id);
+	cs->iif.channels = 2;
+	cs->iif.maxbufsize = MAX_DATA_SIZE;
+	cs->iif.hl_hdrlen = MAX_HEADER_LEN;
+	cs->iif.features =
+		ISDN_FEATURE_L2_X75I |
+		ISDN_FEATURE_L2_HDLC |
+		ISDN_FEATURE_L2_HDLC_56K |
+		ISDN_FEATURE_L2_TRANS |
+		ISDN_FEATURE_L3_TRANS |
+#ifdef	CONFIG_HISAX_1TR6
+		ISDN_FEATURE_P_1TR6 |
+#endif
+#ifdef	CONFIG_HISAX_EURO
+		ISDN_FEATURE_P_EURO |
+#endif
+#ifdef	CONFIG_HISAX_NI1
+		ISDN_FEATURE_P_NI1 |
+#endif
+		0;
+
+	cs->iif.command = HiSax_command;
+	cs->iif.writecmd = NULL;
+	cs->iif.writebuf_skb = HiSax_writebuf_skb;
+	cs->iif.readstat = HiSax_readstatus;
+	register_isdn(&cs->iif);
+	cs->myid = cs->iif.channels;
+
+	*cs_out = cs;
+	return 1;	/* success */
+
+outf_dlog:
+	kfree(cs->dlog);
+outf_cs:
+	kfree(cs);
+	card->cs = NULL;
+out:
+	return 0;	/* error */
+}
+
+static int hisax_cs_setup(int cardnr, struct IsdnCard *card,
+			  struct IsdnCardState *cs)
+{
+	int ret;
+
 	if (!(cs->rcvbuf = kmalloc(MAX_DFRAME_LEN_L1, GFP_ATOMIC))) {
 		printk(KERN_WARNING "HiSax: No memory for isac rcvbuf\n");
 		ll_unload(cs);
@@ -1143,11 +1160,41 @@ static int checkcard(int cardnr, char *id, int *busy_flag, struct module *lockow
 	if (!test_bit(HW_ISAR, &cs->HW_Flags))
 		ll_run(cs, 0);
 
-	ret = 1;
+	return 1;
+
+outf_cs:
+	kfree(cs);
+	card->cs = NULL;
+	return ret;
+}
+
+static int checkcard(int cardnr, char *id, int *busy_flag, struct module *lockowner)
+{
+	int ret;
+	struct IsdnCard *card = cards + cardnr;
+	struct IsdnCardState *cs;
+
+	ret = hisax_cs_new(cardnr, id, card, &cs, busy_flag, lockowner);
+	if (!ret)
+		return 0;
+
+	printk(KERN_INFO
+	       "HiSax: Card %d Protocol %s Id=%s (%d)\n", cardnr + 1,
+	       (card->protocol == ISDN_PTYPE_1TR6) ? "1TR6" :
+	       (card->protocol == ISDN_PTYPE_EURO) ? "EDSS1" :
+	       (card->protocol == ISDN_PTYPE_LEASED) ? "LEASED" :
+	       (card->protocol == ISDN_PTYPE_NI1) ? "NI1" :
+	       "NONE", cs->iif.id, cs->myid);
+
+	ret = hisax_cs_setup_card(card);
+	if (!ret) {
+		ll_unload(cs);
+		goto outf_cs;
+	}
+
+	ret = hisax_cs_setup(cardnr, card, cs);
 	goto out;
 
- outf_dlog:
-	kfree(cs->dlog);
  outf_cs:
 	kfree(cs);
 	card->cs = NULL;
diff --git a/drivers/isdn/hisax/enternow_pci.c b/drivers/isdn/hisax/enternow_pci.c
index b45de9d..b73027f 100644
--- a/drivers/isdn/hisax/enternow_pci.c
+++ b/drivers/isdn/hisax/enternow_pci.c
@@ -300,98 +300,72 @@ enpci_interrupt(int intno, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-
-static struct pci_dev *dev_netjet __devinitdata = NULL;
-
-/* called by config.c */
-int __devinit
-setup_enternow_pci(struct IsdnCard *card)
+static int __devinit en_pci_probe(struct pci_dev *dev_netjet,
+				  struct IsdnCardState *cs)
 {
-	int bytecnt;
-	struct IsdnCardState *cs = card->cs;
-	char tmp[64];
-
-#ifdef CONFIG_PCI
-#ifdef __BIG_ENDIAN
-#error "not running on big endian machines now"
-#endif
-        strcpy(tmp, enternow_pci_rev);
-	printk(KERN_INFO "HiSax: Formula-n Europe AG enter:now ISDN PCI driver Rev. %s\n", HiSax_getrev(tmp));
-	if (cs->typ != ISDN_CTYPE_ENTERNOW)
+	if (pci_enable_device(dev_netjet))
 		return(0);
-	test_and_clear_bit(FLG_LOCK_ATOMIC, &cs->HW_Flags);
-
-	for ( ;; )
-	{
-		if ((dev_netjet = pci_find_device(PCI_VENDOR_ID_TIGERJET,
-			PCI_DEVICE_ID_TIGERJET_300,  dev_netjet))) {
-			if (pci_enable_device(dev_netjet))
-				return(0);
-			cs->irq = dev_netjet->irq;
-			if (!cs->irq) {
-				printk(KERN_WARNING "enter:now PCI: No IRQ for PCI card found\n");
-				return(0);
-			}
-			cs->hw.njet.base = pci_resource_start(dev_netjet, 0);
-			if (!cs->hw.njet.base) {
-				printk(KERN_WARNING "enter:now PCI: No IO-Adr for PCI card found\n");
-				return(0);
-			}
-                        /* checks Sub-Vendor ID because system crashes with Traverse-Card */
-			if ((dev_netjet->subsystem_vendor != 0x55) ||
-				(dev_netjet->subsystem_device != 0x02)) {
-				printk(KERN_WARNING "enter:now: You tried to load this driver with an incompatible TigerJet-card\n");
-                                printk(KERN_WARNING "Use type=20 for Traverse NetJet PCI Card.\n");
-                                return(0);
-                        }
-		} else {
-                        printk(KERN_WARNING "enter:now PCI: No PCI card found\n");
-			return(0);
-		}
-
-		cs->hw.njet.auxa = cs->hw.njet.base + NETJET_AUXDATA;
-		cs->hw.njet.isac = cs->hw.njet.base + 0xC0; // Fenster zum AMD
-
-		/* Reset an */
-		cs->hw.njet.ctrl_reg = 0x07;  // geändert von 0xff
-		outb(cs->hw.njet.ctrl_reg, cs->hw.njet.base + NETJET_CTRL);
-		/* 20 ms Pause */
-		mdelay(20);
+	cs->irq = dev_netjet->irq;
+	if (!cs->irq) {
+		printk(KERN_WARNING "enter:now PCI: No IRQ for PCI card found\n");
+		return(0);
+	}
+	cs->hw.njet.base = pci_resource_start(dev_netjet, 0);
+	if (!cs->hw.njet.base) {
+		printk(KERN_WARNING "enter:now PCI: No IO-Adr for PCI card found\n");
+		return(0);
+	}
+	/* checks Sub-Vendor ID because system crashes with Traverse-Card */
+	if ((dev_netjet->subsystem_vendor != 0x55) ||
+	    (dev_netjet->subsystem_device != 0x02)) {
+		printk(KERN_WARNING "enter:now: You tried to load this driver with an incompatible TigerJet-card\n");
+		printk(KERN_WARNING "Use type=20 for Traverse NetJet PCI Card.\n");
+		return(0);
+	}
 
-		cs->hw.njet.ctrl_reg = 0x30;  /* Reset Off and status read clear */
-		outb(cs->hw.njet.ctrl_reg, cs->hw.njet.base + NETJET_CTRL);
-		mdelay(10);
+	return(1);
+}
 
-		cs->hw.njet.auxd = 0x00; // war 0xc0
-		cs->hw.njet.dmactrl = 0;
+static void __devinit en_cs_init(struct IsdnCard *card,
+				 struct IsdnCardState *cs)
+{
+	cs->hw.njet.auxa = cs->hw.njet.base + NETJET_AUXDATA;
+	cs->hw.njet.isac = cs->hw.njet.base + 0xC0; // Fenster zum AMD
 
-		outb(~TJ_AMD_IRQ, cs->hw.njet.base + NETJET_AUXCTRL);
-		outb(TJ_AMD_IRQ, cs->hw.njet.base + NETJET_IRQMASK1);
-		outb(cs->hw.njet.auxd, cs->hw.njet.auxa);
+	/* Reset an */
+	cs->hw.njet.ctrl_reg = 0x07;  // geändert von 0xff
+	outb(cs->hw.njet.ctrl_reg, cs->hw.njet.base + NETJET_CTRL);
+	/* 20 ms Pause */
+	mdelay(20);
 
-		break;
-	}
-#else
+	cs->hw.njet.ctrl_reg = 0x30;  /* Reset Off and status read clear */
+	outb(cs->hw.njet.ctrl_reg, cs->hw.njet.base + NETJET_CTRL);
+	mdelay(10);
 
-	printk(KERN_WARNING "enter:now PCI: NO_PCI_BIOS\n");
-	printk(KERN_WARNING "enter:now PCI: unable to config Formula-n enter:now ISDN PCI ab\n");
-	return (0);
+	cs->hw.njet.auxd = 0x00; // war 0xc0
+	cs->hw.njet.dmactrl = 0;
 
-#endif /* CONFIG_PCI */
+	outb(~TJ_AMD_IRQ, cs->hw.njet.base + NETJET_AUXCTRL);
+	outb(TJ_AMD_IRQ, cs->hw.njet.base + NETJET_IRQMASK1);
+	outb(cs->hw.njet.auxd, cs->hw.njet.auxa);
+}
 
-	bytecnt = 256;
+static int __devinit en_cs_init_rest(struct IsdnCard *card,
+				     struct IsdnCardState *cs)
+{
+	const int bytecnt = 256;
 
 	printk(KERN_INFO
 		"enter:now PCI: PCI card configured at 0x%lx IRQ %d\n",
 		cs->hw.njet.base, cs->irq);
 	if (!request_region(cs->hw.njet.base, bytecnt, "Fn_ISDN")) {
 		printk(KERN_WARNING
-			   "HiSax: %s config port %lx-%lx already in use\n",
-			   CardType[card->typ],
-			   cs->hw.njet.base,
-			   cs->hw.njet.base + bytecnt);
+		       "HiSax: enter:now config port %lx-%lx already in use\n",
+		       cs->hw.njet.base,
+		       cs->hw.njet.base + bytecnt);
 		return (0);
 	}
+
 	setup_Amd7930(cs);
 	cs->hw.njet.last_is0 = 0;
         /* macro rByteAMD */
@@ -407,5 +381,44 @@ setup_enternow_pci(struct IsdnCard *card)
 	cs->irq_func = &enpci_interrupt;
 	cs->irq_flags |= IRQF_SHARED;
 
-        return (1);
+	return (1);
+}
+
+static struct pci_dev *dev_netjet __devinitdata = NULL;
+
+/* called by config.c */
+int __devinit
+setup_enternow_pci(struct IsdnCard *card)
+{
+	int ret;
+	struct IsdnCardState *cs = card->cs;
+	char tmp[64];
+
+#ifdef __BIG_ENDIAN
+#error "not running on big endian machines now"
+#endif
+
+        strcpy(tmp, enternow_pci_rev);
+	printk(KERN_INFO "HiSax: Formula-n Europe AG enter:now ISDN PCI driver Rev. %s\n", HiSax_getrev(tmp));
+	if (cs->typ != ISDN_CTYPE_ENTERNOW)
+		return(0);
+	test_and_clear_bit(FLG_LOCK_ATOMIC, &cs->HW_Flags);
+
+	for ( ;; )
+	{
+		if ((dev_netjet = pci_find_device(PCI_VENDOR_ID_TIGERJET,
+			PCI_DEVICE_ID_TIGERJET_300,  dev_netjet))) {
+			ret = en_pci_probe(dev_netjet, cs);
+			if (!ret)
+				return(0);
+		} else {
+                        printk(KERN_WARNING "enter:now PCI: No PCI card found\n");
+			return(0);
+		}
+
+		en_cs_init(card, cs);
+		break;
+	}
+
+        return en_cs_init_rest(card, cs);
 }
diff --git a/drivers/isdn/hisax/hfc_pci.c b/drivers/isdn/hisax/hfc_pci.c
index 8a48a3c..077080a 100644
--- a/drivers/isdn/hisax/hfc_pci.c
+++ b/drivers/isdn/hisax/hfc_pci.c
@@ -6,7 +6,7 @@
  *              based on existing driver for CCD hfc ISA cards
  * Copyright    by Werner Cornelius  <werner@isdn4linux.de>
  *              by Karsten Keil      <keil@isdn4linux.de>
- * 
+ *
  * This software may be used and distributed according to the terms
  * of the GNU General Public License, incorporated herein by reference.
  *
@@ -67,8 +67,6 @@ static const PCI_ENTRY id_list[] =
 };
 
 
-#ifdef CONFIG_PCI
-
 /******************************************/
 /* free hardware resources used by driver */
 /******************************************/
@@ -237,7 +235,7 @@ static void hfcpci_clear_fifo_rx(struct IsdnCardState *cs, int fifo)
 	if (fifo_state)
 	        cs->hw.hfcpci.fifo_en |= fifo_state;
 	Write_hfc(cs, HFCPCI_FIFO_EN, cs->hw.hfcpci.fifo_en);
-}   
+}
 
 /***************************************/
 /* clear the desired B-channel tx fifo */
@@ -263,7 +261,7 @@ static void hfcpci_clear_fifo_tx(struct IsdnCardState *cs, int fifo)
 	if (fifo_state)
 	        cs->hw.hfcpci.fifo_en |= fifo_state;
 	Write_hfc(cs, HFCPCI_FIFO_EN, cs->hw.hfcpci.fifo_en);
-}   
+}
 
 /*********************************************/
 /* read a complete B-frame out of the buffer */
@@ -511,7 +509,6 @@ main_rec_hfcpci(struct BCState *bcs)
 	test_and_clear_bit(FLG_LOCK_ATOMIC, &cs->HW_Flags);
 	if (count && receive)
 		goto Begin;
-	return;
 }
 
 /**************************/
@@ -582,7 +579,6 @@ hfcpci_fill_dfifo(struct IsdnCardState *cs)
 
 	dev_kfree_skb_any(cs->tx_skb);
 	cs->tx_skb = NULL;
-	return;
 }
 
 /**************************/
@@ -729,7 +725,6 @@ hfcpci_fill_fifo(struct BCState *bcs)
 	dev_kfree_skb_any(bcs->tx_skb);
 	bcs->tx_skb = NULL;
 	test_and_clear_bit(BC_FLG_BUSY, &bcs->Flag);
-	return;
 }
 
 /**********************************************/
@@ -924,7 +919,6 @@ receive_emsg(struct IsdnCardState *cs)
 	test_and_clear_bit(FLG_LOCK_ATOMIC, &cs->HW_Flags);
 	if (count && receive)
 		goto Begin;
-	return;
 }				/* receive_emsg */
 
 /*********************/
@@ -1350,13 +1344,13 @@ mode_hfcpci(struct BCState *bcs, int mode, int bc)
 				cs->hw.hfcpci.sctrl_r |= SCTRL_B1_ENA;
 			}
 			if (fifo2) {
-			        cs->hw.hfcpci.last_bfifo_cnt[1] = 0;  
+			        cs->hw.hfcpci.last_bfifo_cnt[1] = 0;
 				cs->hw.hfcpci.fifo_en |= HFCPCI_FIFOEN_B2;
 				cs->hw.hfcpci.int_m1 |= (HFCPCI_INTS_B2TRANS + HFCPCI_INTS_B2REC);
 				cs->hw.hfcpci.ctmt &= ~2;
 				cs->hw.hfcpci.conn &= ~0x18;
 			} else {
-			        cs->hw.hfcpci.last_bfifo_cnt[0] = 0;  
+			        cs->hw.hfcpci.last_bfifo_cnt[0] = 0;
 				cs->hw.hfcpci.fifo_en |= HFCPCI_FIFOEN_B1;
 				cs->hw.hfcpci.int_m1 |= (HFCPCI_INTS_B1TRANS + HFCPCI_INTS_B1REC);
 				cs->hw.hfcpci.ctmt &= ~1;
@@ -1642,8 +1636,6 @@ hfcpci_card_msg(struct IsdnCardState *cs, int mt, void *arg)
 /* this variable is used as card index when more than one cards are present */
 static struct pci_dev *dev_hfcpci __devinitdata = NULL;
 
-#endif				/* CONFIG_PCI */
-
 int __devinit
 setup_hfcpci(struct IsdnCard *card)
 {
@@ -1656,96 +1648,99 @@ setup_hfcpci(struct IsdnCard *card)
 #ifdef __BIG_ENDIAN
 #error "not running on big endian machines now"
 #endif
+
 	strcpy(tmp, hfcpci_revision);
 	printk(KERN_INFO "HiSax: HFC-PCI driver Rev. %s\n", HiSax_getrev(tmp));
-#ifdef CONFIG_PCI
+
 	cs->hw.hfcpci.int_s1 = 0;
 	cs->dc.hfcpci.ph_state = 0;
 	cs->hw.hfcpci.fifo = 255;
-	if (cs->typ == ISDN_CTYPE_HFC_PCI) {
-		i = 0;
-		while (id_list[i].vendor_id) {
-			tmp_hfcpci = pci_find_device(id_list[i].vendor_id,
-						     id_list[i].device_id,
-						     dev_hfcpci);
-			i++;
-			if (tmp_hfcpci) {
-				if (pci_enable_device(tmp_hfcpci))
-					continue;
-				pci_set_master(tmp_hfcpci);
-				if ((card->para[0]) && (card->para[0] != (tmp_hfcpci->resource[ 0].start & PCI_BASE_ADDRESS_IO_MASK)))
-					continue;
-				else
-					break;
-			}
-		}
-
+	if (cs->typ != ISDN_CTYPE_HFC_PCI)
+		return(0);
+
+	i = 0;
+	while (id_list[i].vendor_id) {
+		tmp_hfcpci = pci_find_device(id_list[i].vendor_id,
+					     id_list[i].device_id,
+					     dev_hfcpci);
+		i++;
 		if (tmp_hfcpci) {
-			i--;
-			dev_hfcpci = tmp_hfcpci;	/* old device */
-			cs->hw.hfcpci.dev = dev_hfcpci;
-			cs->irq = dev_hfcpci->irq;
-			if (!cs->irq) {
-				printk(KERN_WARNING "HFC-PCI: No IRQ for PCI card found\n");
-				return (0);
-			}
-			cs->hw.hfcpci.pci_io = (char *)(unsigned long)dev_hfcpci->resource[1].start;
-			printk(KERN_INFO "HiSax: HFC-PCI card manufacturer: %s card name: %s\n", id_list[i].vendor_name, id_list[i].card_name);
-		} else {
-			printk(KERN_WARNING "HFC-PCI: No PCI card found\n");
-			return (0);
-		}
-		if (!cs->hw.hfcpci.pci_io) {
-			printk(KERN_WARNING "HFC-PCI: No IO-Mem for PCI card found\n");
-			return (0);
-		}
-		/* Allocate memory for FIFOS */
-		/* Because the HFC-PCI needs a 32K physical alignment, we */
-		/* need to allocate the double mem and align the address */
-		if (!(cs->hw.hfcpci.share_start = kmalloc(65536, GFP_KERNEL))) {
-			printk(KERN_WARNING "HFC-PCI: Error allocating memory for FIFO!\n");
-			return 0;
+			if (pci_enable_device(tmp_hfcpci))
+				continue;
+			pci_set_master(tmp_hfcpci);
+			if ((card->para[0]) && (card->para[0] != (tmp_hfcpci->resource[ 0].start & PCI_BASE_ADDRESS_IO_MASK)))
+				continue;
+			else
+				break;
 		}
-		cs->hw.hfcpci.fifos = (void *)
-		    (((ulong) cs->hw.hfcpci.share_start) & ~0x7FFF) + 0x8000;
-		pci_write_config_dword(cs->hw.hfcpci.dev, 0x80, (u_int) virt_to_bus(cs->hw.hfcpci.fifos));
-		cs->hw.hfcpci.pci_io = ioremap((ulong) cs->hw.hfcpci.pci_io, 256);
-		printk(KERN_INFO
-		       "HFC-PCI: defined at mem %p fifo %p(%#x) IRQ %d HZ %d\n",
-		       cs->hw.hfcpci.pci_io,
-		       cs->hw.hfcpci.fifos,
-		       (u_int) virt_to_bus(cs->hw.hfcpci.fifos),
-		       cs->irq, HZ);
-		spin_lock_irqsave(&cs->lock, flags);
-		pci_write_config_word(cs->hw.hfcpci.dev, PCI_COMMAND, PCI_ENA_MEMIO);	/* enable memory mapped ports, disable busmaster */
-		cs->hw.hfcpci.int_m2 = 0;	/* disable alle interrupts */
-		cs->hw.hfcpci.int_m1 = 0;
-		Write_hfc(cs, HFCPCI_INT_M1, cs->hw.hfcpci.int_m1);
-		Write_hfc(cs, HFCPCI_INT_M2, cs->hw.hfcpci.int_m2);
-		/* At this point the needed PCI config is done */
-		/* fifos are still not enabled */
-		INIT_WORK(&cs->tqueue,  hfcpci_bh);
-		cs->setstack_d = setstack_hfcpci;
-		cs->BC_Send_Data = &hfcpci_send_data;
-		cs->readisac = NULL;
-		cs->writeisac = NULL;
-		cs->readisacfifo = NULL;
-		cs->writeisacfifo = NULL;
-		cs->BC_Read_Reg = NULL;
-		cs->BC_Write_Reg = NULL;
-		cs->irq_func = &hfcpci_interrupt;
-		cs->irq_flags |= IRQF_SHARED;
-		cs->hw.hfcpci.timer.function = (void *) hfcpci_Timer;
-		cs->hw.hfcpci.timer.data = (long) cs;
-		init_timer(&cs->hw.hfcpci.timer);
-		cs->cardmsg = &hfcpci_card_msg;
-		cs->auxcmd = &hfcpci_auxcmd;
-		spin_unlock_irqrestore(&cs->lock, flags);
-		return (1);
-	} else
-		return (0);	/* no valid card type */
-#else
-	printk(KERN_WARNING "HFC-PCI: NO_PCI_BIOS\n");
-	return (0);
-#endif				/* CONFIG_PCI */
+	}
+
+	if (!tmp_hfcpci) {
+		printk(KERN_WARNING "HFC-PCI: No PCI card found\n");
+		return (0);
+	}
+
+	i--;
+	dev_hfcpci = tmp_hfcpci;	/* old device */
+	cs->hw.hfcpci.dev = dev_hfcpci;
+	cs->irq = dev_hfcpci->irq;
+	if (!cs->irq) {
+		printk(KERN_WARNING "HFC-PCI: No IRQ for PCI card found\n");
+		return (0);
+	}
+	cs->hw.hfcpci.pci_io = (char *)(unsigned long)dev_hfcpci->resource[1].start;
+	printk(KERN_INFO "HiSax: HFC-PCI card manufacturer: %s card name: %s\n", id_list[i].vendor_name, id_list[i].card_name);
+
+	if (!cs->hw.hfcpci.pci_io) {
+		printk(KERN_WARNING "HFC-PCI: No IO-Mem for PCI card found\n");
+		return (0);
+	}
+	/* Allocate memory for FIFOS */
+	/* Because the HFC-PCI needs a 32K physical alignment, we */
+	/* need to allocate the double mem and align the address */
+	if (!(cs->hw.hfcpci.share_start = kmalloc(65536, GFP_KERNEL))) {
+		printk(KERN_WARNING "HFC-PCI: Error allocating memory for FIFO!\n");
+		return 0;
+	}
+	cs->hw.hfcpci.fifos = (void *)
+	    (((ulong) cs->hw.hfcpci.share_start) & ~0x7FFF) + 0x8000;
+	pci_write_config_dword(cs->hw.hfcpci.dev, 0x80, (u_int) virt_to_bus(cs->hw.hfcpci.fifos));
+	cs->hw.hfcpci.pci_io = ioremap((ulong) cs->hw.hfcpci.pci_io, 256);
+	printk(KERN_INFO
+	       "HFC-PCI: defined at mem %p fifo %p(%#x) IRQ %d HZ %d\n",
+	       cs->hw.hfcpci.pci_io,
+	       cs->hw.hfcpci.fifos,
+	       (u_int) virt_to_bus(cs->hw.hfcpci.fifos),
+	       cs->irq, HZ);
+
+	spin_lock_irqsave(&cs->lock, flags);
+
+	pci_write_config_word(cs->hw.hfcpci.dev, PCI_COMMAND, PCI_ENA_MEMIO);	/* enable memory mapped ports, disable busmaster */
+	cs->hw.hfcpci.int_m2 = 0;	/* disable alle interrupts */
+	cs->hw.hfcpci.int_m1 = 0;
+	Write_hfc(cs, HFCPCI_INT_M1, cs->hw.hfcpci.int_m1);
+	Write_hfc(cs, HFCPCI_INT_M2, cs->hw.hfcpci.int_m2);
+	/* At this point the needed PCI config is done */
+	/* fifos are still not enabled */
+
+	INIT_WORK(&cs->tqueue,  hfcpci_bh);
+	cs->setstack_d = setstack_hfcpci;
+	cs->BC_Send_Data = &hfcpci_send_data;
+	cs->readisac = NULL;
+	cs->writeisac = NULL;
+	cs->readisacfifo = NULL;
+	cs->writeisacfifo = NULL;
+	cs->BC_Read_Reg = NULL;
+	cs->BC_Write_Reg = NULL;
+	cs->irq_func = &hfcpci_interrupt;
+	cs->irq_flags |= IRQF_SHARED;
+	cs->hw.hfcpci.timer.function = (void *) hfcpci_Timer;
+	cs->hw.hfcpci.timer.data = (long) cs;
+	init_timer(&cs->hw.hfcpci.timer);
+	cs->cardmsg = &hfcpci_card_msg;
+	cs->auxcmd = &hfcpci_auxcmd;
+
+	spin_unlock_irqrestore(&cs->lock, flags);
+
+	return (1);
 }
diff --git a/drivers/isdn/hisax/nj_s.c b/drivers/isdn/hisax/nj_s.c
index c09ffb1..fa2db87 100644
--- a/drivers/isdn/hisax/nj_s.c
+++ b/drivers/isdn/hisax/nj_s.c
@@ -148,107 +148,87 @@ NETjet_S_card_msg(struct IsdnCardState *cs, int mt, void *arg)
 	return(0);
 }
 
-static struct pci_dev *dev_netjet __devinitdata = NULL;
-
-int __devinit
-setup_netjet_s(struct IsdnCard *card)
+static int __devinit njs_pci_probe(struct pci_dev *dev_netjet,
+				   struct IsdnCardState *cs)
 {
-	int bytecnt,cfg;
-	struct IsdnCardState *cs = card->cs;
-	char tmp[64];
+	int cfg;
 
-#ifdef __BIG_ENDIAN
-#error "not running on big endian machines now"
-#endif
-	strcpy(tmp, NETjet_S_revision);
-	printk(KERN_INFO "HiSax: Traverse Tech. NETjet-S driver Rev. %s\n", HiSax_getrev(tmp));
-	if (cs->typ != ISDN_CTYPE_NETJET_S)
+	if (pci_enable_device(dev_netjet))
 		return(0);
-	test_and_clear_bit(FLG_LOCK_ATOMIC, &cs->HW_Flags);
+	pci_set_master(dev_netjet);
+	cs->irq = dev_netjet->irq;
+	if (!cs->irq) {
+		printk(KERN_WARNING "NETjet-S: No IRQ for PCI card found\n");
+		return(0);
+	}
+	cs->hw.njet.base = pci_resource_start(dev_netjet, 0);
+	if (!cs->hw.njet.base) {
+		printk(KERN_WARNING "NETjet-S: No IO-Adr for PCI card found\n");
+		return(0);
+	}
+	/* the TJ300 and TJ320 must be detected, the IRQ handling is different
+	 * unfortunatly the chips use the same device ID, but the TJ320 has
+	 * the bit20 in status PCI cfg register set
+	 */
+	pci_read_config_dword(dev_netjet, 0x04, &cfg);
+	if (cfg & 0x00100000)
+		cs->subtyp = 1; /* TJ320 */
+	else
+		cs->subtyp = 0; /* TJ300 */
+	/* 2001/10/04 Christoph Ersfeld, Formula-n Europe AG www.formula-n.com */
+	if ((dev_netjet->subsystem_vendor == 0x55) &&
+		(dev_netjet->subsystem_device == 0x02)) {
+		printk(KERN_WARNING "Netjet: You tried to load this driver with an incompatible TigerJet-card\n");
+		printk(KERN_WARNING "Use type=41 for Formula-n enter:now ISDN PCI and compatible\n");
+		return(0);
+	}
+	/* end new code */
 
-#ifdef CONFIG_PCI
+	return(1);
+}
 
-	for ( ;; )
-	{
-		if ((dev_netjet = pci_find_device(PCI_VENDOR_ID_TIGERJET,
-			PCI_DEVICE_ID_TIGERJET_300,  dev_netjet))) {
-			if (pci_enable_device(dev_netjet))
-				return(0);
-			pci_set_master(dev_netjet);
-			cs->irq = dev_netjet->irq;
-			if (!cs->irq) {
-				printk(KERN_WARNING "NETjet-S: No IRQ for PCI card found\n");
-				return(0);
-			}
-			cs->hw.njet.base = pci_resource_start(dev_netjet, 0);
-			if (!cs->hw.njet.base) {
-				printk(KERN_WARNING "NETjet-S: No IO-Adr for PCI card found\n");
-				return(0);
-			}
-			/* the TJ300 and TJ320 must be detected, the IRQ handling is different
-			 * unfortunatly the chips use the same device ID, but the TJ320 has
-			 * the bit20 in status PCI cfg register set
-			 */
-			pci_read_config_dword(dev_netjet, 0x04, &cfg);
-			if (cfg & 0x00100000)
-				cs->subtyp = 1; /* TJ320 */
-			else
-				cs->subtyp = 0; /* TJ300 */
-			/* 2001/10/04 Christoph Ersfeld, Formula-n Europe AG www.formula-n.com */
-			if ((dev_netjet->subsystem_vendor == 0x55) &&
-				(dev_netjet->subsystem_device == 0x02)) {
-				printk(KERN_WARNING "Netjet: You tried to load this driver with an incompatible TigerJet-card\n");
-				printk(KERN_WARNING "Use type=41 for Formula-n enter:now ISDN PCI and compatible\n");
-				return(0);
-			}
-			/* end new code */
-		} else {
-			printk(KERN_WARNING "NETjet-S: No PCI card found\n");
-			return(0);
-		}
+static int __devinit njs_cs_init(struct IsdnCard *card,
+				 struct IsdnCardState *cs)
+{
 
-		cs->hw.njet.auxa = cs->hw.njet.base + NETJET_AUXDATA;
-		cs->hw.njet.isac = cs->hw.njet.base | NETJET_ISAC_OFF;
+	cs->hw.njet.auxa = cs->hw.njet.base + NETJET_AUXDATA;
+	cs->hw.njet.isac = cs->hw.njet.base | NETJET_ISAC_OFF;
 
-		cs->hw.njet.ctrl_reg = 0xff;  /* Reset On */
-		byteout(cs->hw.njet.base + NETJET_CTRL, cs->hw.njet.ctrl_reg);
-		mdelay(10);
+	cs->hw.njet.ctrl_reg = 0xff;  /* Reset On */
+	byteout(cs->hw.njet.base + NETJET_CTRL, cs->hw.njet.ctrl_reg);
+	mdelay(10);
 
-		cs->hw.njet.ctrl_reg = 0x00;  /* Reset Off and status read clear */
-		byteout(cs->hw.njet.base + NETJET_CTRL, cs->hw.njet.ctrl_reg);
-		mdelay(10);
+	cs->hw.njet.ctrl_reg = 0x00;  /* Reset Off and status read clear */
+	byteout(cs->hw.njet.base + NETJET_CTRL, cs->hw.njet.ctrl_reg);
+	mdelay(10);
 
-		cs->hw.njet.auxd = 0xC0;
-		cs->hw.njet.dmactrl = 0;
+	cs->hw.njet.auxd = 0xC0;
+	cs->hw.njet.dmactrl = 0;
 
-		byteout(cs->hw.njet.base + NETJET_AUXCTRL, ~NETJET_ISACIRQ);
-		byteout(cs->hw.njet.base + NETJET_IRQMASK1, NETJET_ISACIRQ);
-		byteout(cs->hw.njet.auxa, cs->hw.njet.auxd);
+	byteout(cs->hw.njet.base + NETJET_AUXCTRL, ~NETJET_ISACIRQ);
+	byteout(cs->hw.njet.base + NETJET_IRQMASK1, NETJET_ISACIRQ);
+	byteout(cs->hw.njet.auxa, cs->hw.njet.auxd);
 
-		switch ( ( ( NETjet_ReadIC( cs, ISAC_RBCH ) >> 5 ) & 3 ) )
-		{
-			case 0 :
-				break;
+	switch ( ( ( NETjet_ReadIC( cs, ISAC_RBCH ) >> 5 ) & 3 ) )
+	{
+		case 0 :
+			return 1;	/* end loop */
 
-			case 3 :
-				printk( KERN_WARNING "NETjet-S: NETspider-U PCI card found\n" );
-				continue;
+		case 3 :
+			printk( KERN_WARNING "NETjet-S: NETspider-U PCI card found\n" );
+			return -1;	/* continue looping */
 
-			default :
-				printk( KERN_WARNING "NETjet-S: No PCI card found\n" );
-				return 0;
-                }
-                break;
+		default :
+			printk( KERN_WARNING "NETjet-S: No PCI card found\n" );
+			return 0;	/* end loop & function */
 	}
-#else
-
-	printk(KERN_WARNING "NETjet-S: NO_PCI_BIOS\n");
-	printk(KERN_WARNING "NETjet-S: unable to config NETJET-S PCI\n");
-	return (0);
-
-#endif /* CONFIG_PCI */
+	return 1;			/* end loop */
+}
 
-	bytecnt = 256;
+static int __devinit njs_cs_init_rest(struct IsdnCard *card,
+				      struct IsdnCardState *cs)
+{
+	const int bytecnt = 256;
 
 	printk(KERN_INFO
 		"NETjet-S: %s card configured at %#lx IRQ %d\n",
@@ -273,5 +253,47 @@ setup_netjet_s(struct IsdnCard *card)
 	cs->irq_func = &netjet_s_interrupt;
 	cs->irq_flags |= IRQF_SHARED;
 	ISACVersion(cs, "NETjet-S:");
+
 	return (1);
 }
+
+static struct pci_dev *dev_netjet __devinitdata = NULL;
+
+int __devinit
+setup_netjet_s(struct IsdnCard *card)
+{
+	int ret;
+	struct IsdnCardState *cs = card->cs;
+	char tmp[64];
+
+#ifdef __BIG_ENDIAN
+#error "not running on big endian machines now"
+#endif
+	strcpy(tmp, NETjet_S_revision);
+	printk(KERN_INFO "HiSax: Traverse Tech. NETjet-S driver Rev. %s\n", HiSax_getrev(tmp));
+	if (cs->typ != ISDN_CTYPE_NETJET_S)
+		return(0);
+	test_and_clear_bit(FLG_LOCK_ATOMIC, &cs->HW_Flags);
+
+	for ( ;; )
+	{
+		if ((dev_netjet = pci_find_device(PCI_VENDOR_ID_TIGERJET,
+			PCI_DEVICE_ID_TIGERJET_300,  dev_netjet))) {
+			ret = njs_pci_probe(dev_netjet, cs);
+			if (!ret)
+				return(0);
+		} else {
+			printk(KERN_WARNING "NETjet-S: No PCI card found\n");
+			return(0);
+		}
+
+		ret = njs_cs_init(card, cs);
+		if (!ret)
+			return(0);
+		if (ret > 0)
+			break;
+		/* otherwise, ret < 0, continue looping */
+	}
+
+	return njs_cs_init_rest(card, cs);
+}
diff --git a/drivers/isdn/hisax/nj_u.c b/drivers/isdn/hisax/nj_u.c
index 8202cf3..f017d38 100644
--- a/drivers/isdn/hisax/nj_u.c
+++ b/drivers/isdn/hisax/nj_u.c
@@ -128,93 +128,69 @@ NETjet_U_card_msg(struct IsdnCardState *cs, int mt, void *arg)
 	return(0);
 }
 
-static struct pci_dev *dev_netjet __devinitdata = NULL;
-
-int __devinit
-setup_netjet_u(struct IsdnCard *card)
+static int __devinit nju_pci_probe(struct pci_dev *dev_netjet,
+				   struct IsdnCardState *cs)
 {
-	int bytecnt;
-	struct IsdnCardState *cs = card->cs;
-	char tmp[64];
-#ifdef CONFIG_PCI
-#endif
-#ifdef __BIG_ENDIAN
-#error "not running on big endian machines now"
-#endif
-	strcpy(tmp, NETjet_U_revision);
-	printk(KERN_INFO "HiSax: Traverse Tech. NETspider-U driver Rev. %s\n", HiSax_getrev(tmp));
-	if (cs->typ != ISDN_CTYPE_NETJET_U)
+	if (pci_enable_device(dev_netjet))
 		return(0);
-	test_and_clear_bit(FLG_LOCK_ATOMIC, &cs->HW_Flags);
-
-#ifdef CONFIG_PCI
+	pci_set_master(dev_netjet);
+	cs->irq = dev_netjet->irq;
+	if (!cs->irq) {
+		printk(KERN_WARNING "NETspider-U: No IRQ for PCI card found\n");
+		return(0);
+	}
+	cs->hw.njet.base = pci_resource_start(dev_netjet, 0);
+	if (!cs->hw.njet.base) {
+		printk(KERN_WARNING "NETspider-U: No IO-Adr for PCI card found\n");
+		return(0);
+	}
 
-	for ( ;; )
-	{
-		if ((dev_netjet = pci_find_device(PCI_VENDOR_ID_TIGERJET,
-			PCI_DEVICE_ID_TIGERJET_300,  dev_netjet))) {
-			if (pci_enable_device(dev_netjet))
-				return(0);
-			pci_set_master(dev_netjet);
-			cs->irq = dev_netjet->irq;
-			if (!cs->irq) {
-				printk(KERN_WARNING "NETspider-U: No IRQ for PCI card found\n");
-				return(0);
-			}
-			cs->hw.njet.base = pci_resource_start(dev_netjet, 0);
-			if (!cs->hw.njet.base) {
-				printk(KERN_WARNING "NETspider-U: No IO-Adr for PCI card found\n");
-				return(0);
-			}
-		} else {
-			printk(KERN_WARNING "NETspider-U: No PCI card found\n");
-			return(0);
-		}
+	return (1);
+}
 
-		cs->hw.njet.auxa = cs->hw.njet.base + NETJET_AUXDATA;
-		cs->hw.njet.isac = cs->hw.njet.base | NETJET_ISAC_OFF;
-		mdelay(10);
+static int __devinit nju_cs_init(struct IsdnCard *card,
+				 struct IsdnCardState *cs)
+{
+	cs->hw.njet.auxa = cs->hw.njet.base + NETJET_AUXDATA;
+	cs->hw.njet.isac = cs->hw.njet.base | NETJET_ISAC_OFF;
+	mdelay(10);
 
-		cs->hw.njet.ctrl_reg = 0xff;  /* Reset On */
-		byteout(cs->hw.njet.base + NETJET_CTRL, cs->hw.njet.ctrl_reg);
-		mdelay(10);
+	cs->hw.njet.ctrl_reg = 0xff;  /* Reset On */
+	byteout(cs->hw.njet.base + NETJET_CTRL, cs->hw.njet.ctrl_reg);
+	mdelay(10);
 
-		cs->hw.njet.ctrl_reg = 0x00;  /* Reset Off and status read clear */
-		byteout(cs->hw.njet.base + NETJET_CTRL, cs->hw.njet.ctrl_reg);
-		mdelay(10);
+	cs->hw.njet.ctrl_reg = 0x00;  /* Reset Off and status read clear */
+	byteout(cs->hw.njet.base + NETJET_CTRL, cs->hw.njet.ctrl_reg);
+	mdelay(10);
 
-		cs->hw.njet.auxd = 0xC0;
-		cs->hw.njet.dmactrl = 0;
+	cs->hw.njet.auxd = 0xC0;
+	cs->hw.njet.dmactrl = 0;
 
-		byteout(cs->hw.njet.auxa, 0);
-		byteout(cs->hw.njet.base + NETJET_AUXCTRL, ~NETJET_ISACIRQ);
-		byteout(cs->hw.njet.base + NETJET_IRQMASK1, NETJET_ISACIRQ);
-		byteout(cs->hw.njet.auxa, cs->hw.njet.auxd);
+	byteout(cs->hw.njet.auxa, 0);
+	byteout(cs->hw.njet.base + NETJET_AUXCTRL, ~NETJET_ISACIRQ);
+	byteout(cs->hw.njet.base + NETJET_IRQMASK1, NETJET_ISACIRQ);
+	byteout(cs->hw.njet.auxa, cs->hw.njet.auxd);
 
-		switch ( ( ( NETjet_ReadIC( cs, ICC_RBCH ) >> 5 ) & 3 ) )
-		{
-			case 3 :
-				break;
+	switch ( ( ( NETjet_ReadIC( cs, ICC_RBCH ) >> 5 ) & 3 ) )
+	{
+		case 3 :
+			return 1;	/* end loop */
 
-			case 0 :
-				printk( KERN_WARNING "NETspider-U: NETjet-S PCI card found\n" );
-				continue;
+		case 0 :
+			printk( KERN_WARNING "NETspider-U: NETjet-S PCI card found\n" );
+			return -1;	/* continue looping */
 
-			default :
-				printk( KERN_WARNING "NETspider-U: No PCI card found\n" );
-				return 0;
-                }
-                break;
+		default :
+			printk( KERN_WARNING "NETspider-U: No PCI card found\n" );
+			return 0;	/* end loop & function */
 	}
-#else
-
-	printk(KERN_WARNING "NETspider-U: NO_PCI_BIOS\n");
-	printk(KERN_WARNING "NETspider-U: unable to config NETspider-U PCI\n");
-	return (0);
-
-#endif /* CONFIG_PCI */
+	return 1;			/* end loop */
+}
 
-	bytecnt = 256;
+static int __devinit nju_cs_init_rest(struct IsdnCard *card,
+				      struct IsdnCardState *cs)
+{
+	const int bytecnt = 256;
 
 	printk(KERN_INFO
 		"NETspider-U: PCI card configured at %#lx IRQ %d\n",
@@ -239,5 +215,48 @@ setup_netjet_u(struct IsdnCard *card)
 	cs->irq_func = &netjet_u_interrupt;
 	cs->irq_flags |= IRQF_SHARED;
 	ICCVersion(cs, "NETspider-U:");
+
 	return (1);
 }
+
+static struct pci_dev *dev_netjet __devinitdata = NULL;
+
+int __devinit
+setup_netjet_u(struct IsdnCard *card)
+{
+	int ret;
+	struct IsdnCardState *cs = card->cs;
+	char tmp[64];
+
+#ifdef __BIG_ENDIAN
+#error "not running on big endian machines now"
+#endif
+
+	strcpy(tmp, NETjet_U_revision);
+	printk(KERN_INFO "HiSax: Traverse Tech. NETspider-U driver Rev. %s\n", HiSax_getrev(tmp));
+	if (cs->typ != ISDN_CTYPE_NETJET_U)
+		return(0);
+	test_and_clear_bit(FLG_LOCK_ATOMIC, &cs->HW_Flags);
+
+	for ( ;; )
+	{
+		if ((dev_netjet = pci_find_device(PCI_VENDOR_ID_TIGERJET,
+			PCI_DEVICE_ID_TIGERJET_300,  dev_netjet))) {
+			ret = nju_pci_probe(dev_netjet, cs);
+			if (!ret)
+				return(0);
+		} else {
+			printk(KERN_WARNING "NETspider-U: No PCI card found\n");
+			return(0);
+		}
+
+		ret = nju_cs_init(card, cs);
+		if (!ret)
+			return (0);
+		if (ret > 0)
+			break;
+		/* ret < 0 == continue looping */
+	}
+
+	return nju_cs_init_rest(card, cs);
+}
