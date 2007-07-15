Return-Path: <linux-kernel-owner+w=401wt.eu-S1760669AbXGOKAW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760669AbXGOKAW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 06:00:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757173AbXGOKAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 06:00:06 -0400
Received: from havoc.gtf.org ([69.61.125.42]:57850 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756864AbXGOKAD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 06:00:03 -0400
Date: Sun, 15 Jul 2007 06:00:01 -0400
From: Jeff Garzik <jeff@garzik.org>
To: kkeil@suse.de, linux-kernel@vger.kernel.org,
       isdn4linux@listserv.isdn4linux.de
Cc: Andrew Morton <akpm@linux-foundation.org>, surya.prabhakar@wipro.com
Subject: [PATCH 4/5] HiSax netjet_s: code movement, prep for hotplug
Message-ID: <20070715100001.GD21220@havoc.gtf.org>
References: <20070715095716.GA20949@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070715095716.GA20949@havoc.gtf.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


commit a60e908ca7bb2b8fe9e42e2108f4040c1d708b64
Author: Jeff Garzik <jeff@garzik.org>
Date:   Sun Jul 15 04:25:35 2007 -0400

    [ISDN] HiSax netjet_s: code movement, prep for hotplug
    
    1) Remove CONFIG_PCI ifdefs.  PCI is required in Kconfig.
    
    2) Break up setup_netjet_s() into three separate internal functions.
    This helps facilitate upcoming use of PCI hotplug API, and in addition
    makes the code much easier to follow.
    
    No code is changed, just moved around.  I even kept the out-of-favor
    "return(0)" style used in the current source code.
    
    Signed-off-by: Jeff Garzik <jeff@garzik.org>

 drivers/isdn/hisax/nj_s.c |  194 +++++++++++++++++++++++++---------------------
 1 file changed, 108 insertions(+), 86 deletions(-)

a60e908ca7bb2b8fe9e42e2108f4040c1d708b64
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
