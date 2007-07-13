Return-Path: <linux-kernel-owner+w=401wt.eu-S937682AbXGMWuY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937682AbXGMWuY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 18:50:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760737AbXGMWp0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 18:45:26 -0400
Received: from ns2.uludag.org.tr ([193.140.100.220]:59110 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S937333AbXGMWpK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 18:45:10 -0400
From: "=?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur" <caglar@pardus.org.tr>
Reply-To: caglar@pardus.org.tr
Organization: =?utf-8?q?T=C3=9CB=C4=B0TAK_/?= UEKAE
Subject: [PATCH 11/12] drivers/isdn/hisax/telespci.c: replace pci_find_device with pci_get_device
Date: Sat, 14 Jul 2007 01:44:55 +0300
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Disposition: inline
To: LKML <linux-kernel@vger.kernel.org>
Cc: kkeil@suse.de, kai.germaschewski@gmx.de, isdn4linux@listserv.isdn4linux.de
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <200707140144.55929.caglar@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Following patch replaces pci_find_device with pci_get_device to avoid 
following compiliation warning;

drivers/isdn/hisax/telespci.c: In function `setup_telespci':
drivers/isdn/hisax/telespci.c:303: warning: `pci_find_device' is deprecated 
(declared at include/linux/pci.h:478)

Signed-off-by: S.Çağlar Onur <caglar@pardus.org.tr>

---
 drivers/isdn/hisax/telespci.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

Index: linux-2.6/drivers/isdn/hisax/telespci.c
===================================================================
--- linux-2.6.orig/drivers/isdn/hisax/telespci.c
+++ linux-2.6/drivers/isdn/hisax/telespci.c
@@ -300,13 +300,13 @@ setup_telespci(struct IsdnCard *card)
 	if (cs->typ != ISDN_CTYPE_TELESPCI)
 		return (0);
 #ifdef CONFIG_PCI
-	if ((dev_tel = pci_find_device (PCI_VENDOR_ID_ZORAN, 
PCI_DEVICE_ID_ZORAN_36120, dev_tel))) {
+	if ((dev_tel = pci_get_device (PCI_VENDOR_ID_ZORAN, 
PCI_DEVICE_ID_ZORAN_36120, dev_tel))) {
 		if (pci_enable_device(dev_tel))
-			return(0);
+			goto dev_tel_cleanup;
 		cs->irq = dev_tel->irq;
 		if (!cs->irq) {
 			printk(KERN_WARNING "Teles: No IRQ for PCI card found\n");
-			return(0);
+			goto dev_tel_cleanup;
 		}
 		cs->hw.teles0.membase = ioremap(pci_resource_start(dev_tel, 0),
 			PAGE_SIZE);
@@ -353,7 +353,13 @@ setup_telespci(struct IsdnCard *card)
 		printk(KERN_WARNING
 		 "TelesPCI: wrong HSCX versions check IO/MEM addresses\n");
 		release_io_telespci(cs);
-		return (0);
+		goto dev_tel_cleanup;
 	}
+	pci_dev_put(dev_tel);
 	return (1);
+
+dev_tel_cleanup:
+	pci_dev_put(dev_tel);
+	return (0);
+
 }

-- 
S.Çağlar Onur <caglar@pardus.org.tr>
http://cekirdek.pardus.org.tr/~caglar/

Linux is like living in a teepee. No Windows, no Gates and an Apache in house!
