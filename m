Return-Path: <linux-kernel-owner+w=401wt.eu-S937435AbXGMWq1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937435AbXGMWq1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 18:46:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936812AbXGMWom
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 18:44:42 -0400
Received: from ns2.uludag.org.tr ([193.140.100.220]:59077 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S936663AbXGMWol (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 18:44:41 -0400
From: "=?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur" <caglar@pardus.org.tr>
Reply-To: caglar@pardus.org.tr
Organization: =?utf-8?q?T=C3=9CB=C4=B0TAK_/?= UEKAE
Subject: [PATCH 3/12] drivers/isdn/hisax/gazel.c: replace pci_find_device with pci_get_device
Date: Sat, 14 Jul 2007 01:44:26 +0300
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Disposition: inline
To: LKML <linux-kernel@vger.kernel.org>
Cc: kkeil@suse.de, kai.germaschewski@gmx.de, isdn4linux@listserv.isdn4linux.de
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <200707140144.27338.caglar@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Following patch replaces pci_find_device with pci_get_device to avoid 
following compiliation warning;

drivers/isdn/hisax/gazel.c: In function `setup_gazelpci':
drivers/isdn/hisax/gazel.c:549: warning: `pci_find_device' is deprecated 
(declared at include/linux/pci.h:478)

Signed-off-by: S.Çağlar Onur <caglar@pardus.org.tr>

---
 drivers/isdn/hisax/gazel.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

Index: linux-2.6/drivers/isdn/hisax/gazel.c
===================================================================
--- linux-2.6.orig/drivers/isdn/hisax/gazel.c
+++ linux-2.6/drivers/isdn/hisax/gazel.c
@@ -546,10 +546,10 @@ setup_gazelpci(struct IsdnCardState *cs)
 	found = 0;
 	seekcard = PCI_DEVICE_ID_PLX_R685;
 	for (nbseek = 0; nbseek < 4; nbseek++) {
-		if ((dev_tel = pci_find_device(PCI_VENDOR_ID_PLX,
+		if ((dev_tel = pci_get_device(PCI_VENDOR_ID_PLX,
 					seekcard, dev_tel))) {
 			if (pci_enable_device(dev_tel))
-				return 1;
+				goto dev_tel_cleanup;
 			pci_irq = dev_tel->irq;
 			pci_ioaddr0 = pci_resource_start(dev_tel, 1);
 			pci_ioaddr1 = pci_resource_start(dev_tel, 2);
@@ -577,7 +577,7 @@ setup_gazelpci(struct IsdnCardState *cs)
 	}
 	if (!pci_irq) {
 		printk(KERN_WARNING "Gazel: No IRQ for PCI card found\n");
-		return 1;
+		goto dev_tel_cleanup;
 	}
 	cs->hw.gazel.pciaddr[0] = pci_ioaddr0;
 	cs->hw.gazel.pciaddr[1] = pci_ioaddr1;
@@ -618,7 +618,12 @@ setup_gazelpci(struct IsdnCardState *cs)
 			break;
 	}
 
+	pci_dev_put(dev_tel);
 	return (0);
+
+dev_tel_cleanup:
+	pci_dev_put(dev_tel);
+	return (1);
 }
 
 int __devinit

-- 
S.Çağlar Onur <caglar@pardus.org.tr>
http://cekirdek.pardus.org.tr/~caglar/

Linux is like living in a teepee. No Windows, no Gates and an Apache in house!
