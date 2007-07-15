Return-Path: <linux-kernel-owner+w=401wt.eu-S1757536AbXGOVkm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757536AbXGOVkm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 17:40:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751962AbXGOVkd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 17:40:33 -0400
Received: from havoc.gtf.org ([69.61.125.42]:59419 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751756AbXGOVkc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 17:40:32 -0400
Date: Sun, 15 Jul 2007 17:40:30 -0400
From: Jeff Garzik <jeff@garzik.org>
To: kkeil@suse.de, linux-kernel@vger.kernel.org,
       isdn4linux@listserv.isdn4linux.de
Cc: Andrew Morton <akpm@linux-foundation.org>, surya.prabhakar@wipro.com
Subject: [PATCH 1/2] HiSax netjet_u: code movement; hotplug API prep
Message-ID: <20070715214030.GA9702@havoc.gtf.org>
References: <20070715095716.GA20949@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070715095716.GA20949@havoc.gtf.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This patch, and the one following it, are both checked into
jgarzik/misc-2.6.git#isdn-pci.


commit 76476624e28f2686b87f90eb106b6672e22dcc2c
Author: Jeff Garzik <jeff@garzik.org>
Date:   Sun Jul 15 16:59:01 2007 -0400

    [ISDN] HiSax netjet_u: split setup into 3 smaller functions
    
    No behavior changes, just code movement.  Prep for PCI hotplug API.
    
    Signed-off-by: Jeff Garzik <jeff@garzik.org>
---

 drivers/isdn/hisax/nj_u.c |  167 +++++++++++++++++++++++++---------------------
 1 file changed, 93 insertions(+), 74 deletions(-)

76476624e28f2686b87f90eb106b6672e22dcc2c
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
