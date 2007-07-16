Return-Path: <linux-kernel-owner+w=401wt.eu-S1758312AbXGPF1A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758312AbXGPF1A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 01:27:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751781AbXGPF0v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 01:26:51 -0400
Received: from havoc.gtf.org ([69.61.125.42]:60333 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751714AbXGPF0u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 01:26:50 -0400
Date: Mon, 16 Jul 2007 01:26:47 -0400
From: Jeff Garzik <jeff@garzik.org>
To: kkeil@suse.de, linux-kernel@vger.kernel.org,
       isdn4linux@listserv.isdn4linux.de
Cc: Andrew Morton <akpm@linux-foundation.org>, surya.prabhakar@wipro.com
Subject: [PATCH 1/7] HiSax enternow: split setup into smaller functions
Message-ID: <20070716052647.GA21782@havoc.gtf.org>
References: <20070715095716.GA20949@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070715095716.GA20949@havoc.gtf.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


commit a95641cdd42177eb0e9a772c591ca5383ee9c8ae
Author: Jeff Garzik <jeff@garzik.org>
Date:   Sun Jul 15 19:25:45 2007 -0400

    [ISDN] HiSax enternow: split setup into 3 smaller functions
    
    No behavior changes, just code movement.  Prep for PCI hotplug API.

    [also: removed CONFIG_PCI tests and CardType references]
    
    Signed-off-by: Jeff Garzik <jeff@garzik.org>

 drivers/isdn/hisax/enternow_pci.c |  165 ++++++++++++++++++++------------------
 1 file changed, 89 insertions(+), 76 deletions(-)

a95641cdd42177eb0e9a772c591ca5383ee9c8ae
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
