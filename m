Return-Path: <linux-kernel-owner+w=401wt.eu-S1759435AbXHWD1R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759435AbXHWD1R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 23:27:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757156AbXHWD07
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 23:26:59 -0400
Received: from n6.bullet.re3.yahoo.com ([68.142.237.91]:26478 "HELO
	n6.bullet.re3.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759050AbXHWD06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 23:26:58 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 484724.82868.bm@rrr1.mail.re1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Reply-To:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=6ZNg7KwtRe92aNaIszVY6EWOhL6yIHuVS6OrRIxrE2xH6a2sWfIMfmfToRNqLmBix6qzFHIgZk6YQZsFoYvEQmmrzJr7ReaBuzk3iyfJy0I292vHcMQ/aSemlLH4teUH1os8YLegeNeFETNotnIM3ePGpTLKMCKgguFxpsiABa4=;
X-YMail-OSG: hZehV_MVM1nM1TmOd8m4fFlvmv1gemqRDIUHHpOxNqG21hDc4nSLqSbs0wSBHN_oG8ngIVbtUUIt7mMJlDmr___Y
Date: Wed, 22 Aug 2007 20:24:21 -0700 (PDT)
From: Scott Thompson <postfailathushmaildotcom@yahoo.com>
Reply-To: postfail@hushmail.com
Subject: [PATCH 1 of 5 resend ] /drivers/char ioremap balancing/ returncode check
To: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Cc: jirislaby@gmail.com
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <714365.11931.qm@web44915.mail.sp1.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

patchset against 2.6.23-rc3.  
corrects missing ioremap return checks and balancing on iounmap calls, integrated changes per list
recommendations on the original set of patches..
patch 1--> sx.c adds an int rc to the void fix_sx_pci, which is checked on fix_sx_pci call

Warning -- cleanup handler here may miss additional required cleanup as has occurred on other
portions of ioremap audit.

This patch had been submitted previously but hushmail client caused wordwrap issues, resending
with different mail client.

Signed-off-by: Scott Thompson <postfail <at> hushmail.com>
----------------------------------------------------------
diff --git a/drivers/char/hpet.c b/drivers/char/hpet.c
index 77bf4aa..2eb860d 100644
--- a/drivers/char/hpet.c
+++ b/drivers/char/hpet.c
@@ -936,6 +936,12 @@ static acpi_status hpet_resources(struct acpi_resource *res
 		hdp->hd_phys_address = addr.minimum;
 		hdp->hd_address = ioremap(addr.minimum, addr.address_length);
 
+		if (!hdp->hd_address) {
+			printk(KERN_ERR "%s: ioremap failed\n",
+				__FUNCTION__);
+			return -ENOMEM;
+		}
+
 		if (hpet_is_known(hdp)) {
 			printk(KERN_DEBUG "%s: 0x%lx is busy\n",
 				__FUNCTION__, hdp->hd_phys_address);
@@ -953,6 +959,12 @@ static acpi_status hpet_resources(struct acpi_resource *res,
 		hdp->hd_address = ioremap(fixmem32->address,
 						HPET_RANGE_SIZE);
 
+		if (!hdp->hd_address) {
+			printk(KERN_ERR "%s: ioremap failed\n",
+				__FUNCTION__);
+			return -ENOMEM;
+		}
+
 		if (hpet_is_known(hdp)) {
 			printk(KERN_DEBUG "%s: 0x%lx is busy\n",
 				__FUNCTION__, hdp->hd_phys_address);
diff --git a/drivers/char/moxa.c b/drivers/char/moxa.c
index ed76f0a..4a40fcf 100644
--- a/drivers/char/moxa.c
+++ b/drivers/char/moxa.c
@@ -447,6 +447,16 @@ static int __init moxa_init(void)
 	for (i = 0; i < numBoards; i++) {
 		moxa_boards[i].basemem = ioremap(moxa_boards[i].baseAddr,
 				0x4000);
+		if (!moxa_boards[i].basemem) { 
+			for (;i > 0;i--)
+				if (moxa_boards[i].basemem)
+					iounmap(moxa_boards[i].basemem);
+
+#ifdef CONFIG_PCI
+				pci_unregister_driver(&moxa_pci_driver);
+#endif
+			return -ENOMEM; 
+		}
 	}
 
 	return retval;
diff --git a/drivers/char/sx.c b/drivers/char/sx.c
index 85a2328..9d67077 100644
--- a/drivers/char/sx.c
+++ b/drivers/char/sx.c
@@ -2615,7 +2615,7 @@ static struct eisa_driver sx_eisadriver = {
    EEprom.  As the bit is read/write for the CPU, we can fix it here,
    if we detect that it isn't set correctly. -- REW */
 
-static void __devinit fix_sx_pci(struct pci_dev *pdev, struct sx_board *board)
+static int __devinit fix_sx_pci(struct pci_dev *pdev, struct sx_board *board)
 {
 	unsigned int hwbase;
 	void __iomem *rebase;
@@ -2627,13 +2627,20 @@ static void __devinit fix_sx_pci(struct pci_dev *pdev
 	pci_read_config_dword(pdev, PCI_BASE_ADDRESS_0, &hwbase);
 	hwbase &= PCI_BASE_ADDRESS_MEM_MASK;
 	rebase = ioremap(hwbase, 0x80);
+	if (!rebase) {
+		printk(KERN_ERR  "sx:ioremap fail, unable to perform"
+				    "cntrl reg fix\n");
+		return -ENOMEM;
+	}
+		
 	t = readl(rebase + CNTRL_REG_OFFSET);
 	if (t != CNTRL_REG_GOODVALUE) {
-		printk(KERN_DEBUG "sx: performing cntrl reg fix: %08x -> "
+		printk(KERN_INFO "sx: performing cntrl reg fix: %08x -> "
 			"%08x\n", t, CNTRL_REG_GOODVALUE);
 		writel(CNTRL_REG_GOODVALUE, rebase + CNTRL_REG_OFFSET);
 	}
 	iounmap(rebase);
+	return 0;
 }
 #endif
 
@@ -2692,7 +2699,10 @@ static int __devinit sx_pci_probe(struct pci_dev *pdev,
 		goto err_unmap;
 	}
 
-	fix_sx_pci(pdev, board);
+	if (fix_sx_pci(pdev, board)){
+		retval = -ENOMEM;
+		goto err_unmap;
+	}
 
 	pci_set_drvdata(pdev, board);
 
diff --git a/drivers/char/vr41xx_giu.c b/drivers/char/vr41xx_giu.c
index e5ed091..c5ec2fa 100644
--- a/drivers/char/vr41xx_giu.c
+++ b/drivers/char/vr41xx_giu.c
@@ -639,8 +639,11 @@ static int __devinit giu_probe(struct platform_device *dev)
 	}
 
 	irq = platform_get_irq(dev, 0);
-	if (irq < 0 || irq >= NR_IRQS)
+	if (irq < 0 || irq >= NR_IRQS) {
+		iounmap(giu_base);
+		unregister_chrdev(major, "GIU");
 		return -EBUSY;
+	}
 
 	return cascade_irq(irq, giu_get_irq);
 }



       
____________________________________________________________________________________
Building a website is a piece of cake. Yahoo! Small Business gives you all the tools to get online.
http://smallbusiness.yahoo.com/webhosting 

