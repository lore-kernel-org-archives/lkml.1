Return-Path: <linux-kernel-owner+w=401wt.eu-S1760440AbXGMWps@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760440AbXGMWps (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 18:45:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936095AbXGMWoj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 18:44:39 -0400
Received: from ns2.uludag.org.tr ([193.140.100.220]:59073 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S935844AbXGMWoi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 18:44:38 -0400
From: "=?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur" <caglar@pardus.org.tr>
Reply-To: caglar@pardus.org.tr
Organization: =?utf-8?q?T=C3=9CB=C4=B0TAK_/?= UEKAE
Subject: [PATCH 2/12] drivers/isdn/hisax/bkm_a4t.c: replace pci_find_device with pci_get_device
Date: Sat, 14 Jul 2007 01:44:22 +0300
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Disposition: inline
To: LKML <linux-kernel@vger.kernel.org>
Cc: kkeil@suse.de, kai.germaschewski@gmx.de, isdn4linux@listserv.isdn4linux.de
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <200707140144.24039.caglar@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Following patch replaces pci_find_device with pci_get_device to avoid 
following compiliation warning;

drivers/isdn/hisax/bkm_a4t.c: In function `setup_bkm_a4t':
drivers/isdn/hisax/bkm_a4t.c:278: warning: `pci_find_device' is deprecated 
(declared at include/linux/pci.h:478)

Signed-off-by: S.Çağlar Onur <caglar@pardus.org.tr>

---
 drivers/isdn/hisax/bkm_a4t.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

Index: linux-2.6/drivers/isdn/hisax/bkm_a4t.c
===================================================================
--- linux-2.6.orig/drivers/isdn/hisax/bkm_a4t.c
+++ linux-2.6/drivers/isdn/hisax/bkm_a4t.c
@@ -275,7 +275,7 @@ setup_bkm_a4t(struct IsdnCard *card)
 		return (0);
 
 #ifdef CONFIG_PCI
-	while ((dev_a4t = pci_find_device(PCI_VENDOR_ID_ZORAN,
+	while ((dev_a4t = pci_get_device(PCI_VENDOR_ID_ZORAN,
 		PCI_DEVICE_ID_ZORAN_36120, dev_a4t))) {
 		u16 sub_sys;
 		u16 sub_vendor;
@@ -284,7 +284,7 @@ setup_bkm_a4t(struct IsdnCard *card)
 		sub_sys = dev_a4t->subsystem_device;
 		if ((sub_sys == PCI_DEVICE_ID_BERKOM_A4T) && (sub_vendor == 
PCI_VENDOR_ID_BERKOM)) {
 			if (pci_enable_device(dev_a4t))
-				return(0);
+				goto dev_a4t_cleanup;
 			found = 1;
 			pci_memaddr = pci_resource_start(dev_a4t, 0);
 			cs->irq = dev_a4t->irq;
@@ -297,11 +297,11 @@ setup_bkm_a4t(struct IsdnCard *card)
 	}
 	if (!cs->irq) {		/* IRQ range check ?? */
 		printk(KERN_WARNING "HiSax: %s: No IRQ\n", CardType[card->typ]);
-		return (0);
+		goto dev_a4t_cleanup;
 	}
 	if (!pci_memaddr) {
 		printk(KERN_WARNING "HiSax: %s: No Memory base address\n", 
CardType[card->typ]);
-		return (0);
+		goto dev_a4t_cleanup;
 	}
 	cs->hw.ax.base = (long) ioremap(pci_memaddr, 4096);
 	/* Check suspecious address */
@@ -311,7 +311,7 @@ setup_bkm_a4t(struct IsdnCard *card)
 		       CardType[card->typ], cs->hw.ax.base, cs->hw.ax.base + 4096);
 		iounmap((void *) cs->hw.ax.base);
 		cs->hw.ax.base = 0;
-		return (0);
+		goto dev_a4t_cleanup;
 	}
 	cs->hw.ax.isac_adr = cs->hw.ax.base + PO_OFFSET;
 	cs->hw.ax.jade_adr = cs->hw.ax.base + PO_OFFSET;
@@ -339,5 +339,10 @@ setup_bkm_a4t(struct IsdnCard *card)
 	ISACVersion(cs, "Telekom A4T:");
 	/* Jade version */
 	JadeVersion(cs, "Telekom A4T:");
+	pci_dev_put(dev_a4t);
 	return (1);
+
+dev_a4t_cleanup:
+	pci_dev_put(dev_a4t);
+	return (0);
 }

-- 
S.Çağlar Onur <caglar@pardus.org.tr>
http://cekirdek.pardus.org.tr/~caglar/

Linux is like living in a teepee. No Windows, no Gates and an Apache in house!
