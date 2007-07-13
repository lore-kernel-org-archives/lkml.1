Return-Path: <linux-kernel-owner+w=401wt.eu-S937129AbXGMXA5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937129AbXGMXA5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 19:00:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757574AbXGMXAt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 19:00:49 -0400
Received: from ns2.uludag.org.tr ([193.140.100.220]:52907 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752296AbXGMXAs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 19:00:48 -0400
From: "=?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur" <caglar@pardus.org.tr>
Reply-To: caglar@pardus.org.tr
Organization: =?utf-8?q?T=C3=9CB=C4=B0TAK_/?= UEKAE
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/12] drivers/isdn/hisax/niccy.c: replace pci_find_device with pci_get_device
Date: Sat, 14 Jul 2007 02:00:32 +0300
User-Agent: KMail/1.9.7
Cc: kkeil@suse.de, kai.germaschewski@gmx.de, isdn4linux@listserv.isdn4linux.de
References: <200707140144.36035.caglar@pardus.org.tr>
In-Reply-To: <200707140144.36035.caglar@pardus.org.tr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200707140200.34017.caglar@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[resend] i forget to quilt refresh :(, sorry for noise

14 Tem 2007 Cts tarihinde, S.Çağlar Onur şunları yazmıştı: 
> ---
>  drivers/isdn/hisax/niccy.c |   21 +++++++++++++--------
>  1 file changed, 13 insertions(+), 8 deletions(-)

Following patch replaces pci_find_device with pci_get_device to avoid 
following compiliation warning;

drivers/isdn/hisax/niccy.c: In function `setup_niccy':
drivers/isdn/hisax/niccy.c:305: warning: `pci_find_device' is deprecated 
(declared at include/linux/pci.h:478)

Signed-off-by: S.Çağlar Onur <caglar@pardus.org.tr>

---
 drivers/isdn/hisax/niccy.c |   21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

Index: linux-2.6/drivers/isdn/hisax/niccy.c
===================================================================
--- linux-2.6.orig/drivers/isdn/hisax/niccy.c
+++ linux-2.6/drivers/isdn/hisax/niccy.c
@@ -302,29 +302,29 @@ int __devinit setup_niccy(struct IsdnCar
 #ifdef CONFIG_PCI
 		u_int pci_ioaddr;
 		cs->subtyp = 0;
-		if ((niccy_dev = pci_find_device(PCI_VENDOR_ID_SATSAGEM,
+		if ((niccy_dev = pci_get_device(PCI_VENDOR_ID_SATSAGEM,
 						 PCI_DEVICE_ID_SATSAGEM_NICCY,
 						 niccy_dev))) {
 			if (pci_enable_device(niccy_dev))
-				return 0;
+				goto niccy_dev_cleanup;
 			/* get IRQ */
 			if (!niccy_dev->irq) {
 				printk(KERN_WARNING
 				       "Niccy: No IRQ for PCI card found\n");
-				return 0;
+				goto niccy_dev_cleanup;
 			}
 			cs->irq = niccy_dev->irq;
 			cs->hw.niccy.cfg_reg = pci_resource_start(niccy_dev, 0);
 			if (!cs->hw.niccy.cfg_reg) {
 				printk(KERN_WARNING
 				       "Niccy: No IO-Adr for PCI cfg found\n");
-				return 0;
+				goto niccy_dev_cleanup;
 			}
 			pci_ioaddr = pci_resource_start(niccy_dev, 1);
 			if (!pci_ioaddr) {
 				printk(KERN_WARNING
 				       "Niccy: No IO-Adr for PCI card found\n");
-				return 0;
+				goto niccy_dev_cleanup;
 			}
 			cs->subtyp = NICCY_PCI;
 		} else {
@@ -341,7 +341,7 @@ int __devinit setup_niccy(struct IsdnCar
 			       "HiSax: %s data port %x-%x already in use\n",
 			       CardType[card->typ],
 			       cs->hw.niccy.isac, cs->hw.niccy.isac + 4);
-			return 0;
+			goto niccy_dev_cleanup;
 		}
 		if (!request_region(cs->hw.niccy.cfg_reg, 0x40, "niccy pci")) {
 			printk(KERN_WARNING
@@ -350,7 +350,7 @@ int __devinit setup_niccy(struct IsdnCar
 			       cs->hw.niccy.cfg_reg,
 			       cs->hw.niccy.cfg_reg + 0x40);
 			release_region(cs->hw.niccy.isac, 4);
-			return 0;
+			goto niccy_dev_cleanup;
 		}
 #else
 		printk(KERN_WARNING "Niccy: io0 0 and NO_PCI_BIOS\n");
@@ -376,7 +376,12 @@ int __devinit setup_niccy(struct IsdnCar
 		printk(KERN_WARNING "Niccy: wrong HSCX versions check IO "
 			"address\n");
 		release_io_niccy(cs);
-		return 0;
+		goto niccy_dev_cleanup;
 	}
+	pci_dev_put(niccy_dev);
 	return 1;
+
+niccy_dev_cleanup:
+	pci_dev_put(niccy_dev);
+	return (0);
 }


-- 
S.Çağlar Onur <caglar@pardus.org.tr>
http://cekirdek.pardus.org.tr/~caglar/

Linux is like living in a teepee. No Windows, no Gates and an Apache in house!
