Return-Path: <linux-kernel-owner+w=401wt.eu-S935107AbXGMWqr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935107AbXGMWqr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 18:46:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937074AbXGMWoq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 18:44:46 -0400
Received: from ns2.uludag.org.tr ([193.140.100.220]:59081 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S937044AbXGMWop (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 18:44:45 -0400
From: "=?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur" <caglar@pardus.org.tr>
Reply-To: caglar@pardus.org.tr
Organization: =?utf-8?q?T=C3=9CB=C4=B0TAK_/?= UEKAE
Subject: [PATCH 4/12] drivers/isdn/hisax/bkm_a8.c: replace pci_find_device with pci_get_device
Date: Sat, 14 Jul 2007 01:44:30 +0300
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Disposition: inline
To: LKML <linux-kernel@vger.kernel.org>
Cc: kkeil@suse.de, kai.germaschewski@gmx.de, isdn4linux@listserv.isdn4linux.de
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <200707140144.31157.caglar@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Following patch replaces pci_find_device with pci_get_device to avoid 
following compiliation warning;

drivers/isdn/hisax/bkm_a8.c: In function `setup_sct_quadro':
drivers/isdn/hisax/bkm_a8.c:312: warning: `pci_find_device' is deprecated 
(declared at include/linux/pci.h:478)

Signed-off-by: S.Çağlar Onur <caglar@pardus.org.tr>

---
 drivers/isdn/hisax/bkm_a8.c |   22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

Index: linux-2.6/drivers/isdn/hisax/bkm_a8.c
===================================================================
--- linux-2.6.orig/drivers/isdn/hisax/bkm_a8.c
+++ linux-2.6/drivers/isdn/hisax/bkm_a8.c
@@ -309,7 +309,7 @@ setup_sct_quadro(struct IsdnCard *card)
 		(sub_vendor_id != PCI_VENDOR_ID_BERKOM)))
 		return (0);
 	if (cs->subtyp == SCT_1) {
-		while ((dev_a8 = pci_find_device(PCI_VENDOR_ID_PLX,
+		while ((dev_a8 = pci_get_device(PCI_VENDOR_ID_PLX,
 			PCI_DEVICE_ID_PLX_9050, dev_a8))) {
 			
 			sub_vendor_id = dev_a8->subsystem_vendor;
@@ -317,7 +317,7 @@ setup_sct_quadro(struct IsdnCard *card)
 			if ((sub_sys_id == PCI_DEVICE_ID_BERKOM_SCITEL_QUADRO) &&
 				(sub_vendor_id == PCI_VENDOR_ID_BERKOM)) {
 				if (pci_enable_device(dev_a8))
-					return(0);
+					goto dev_a8_cleanup;
 				pci_ioaddr1 = pci_resource_start(dev_a8, 1);
 				pci_irq = dev_a8->irq;
 				pci_bus = dev_a8->bus->number;
@@ -352,7 +352,7 @@ setup_sct_quadro(struct IsdnCard *card)
 		printk(KERN_WARNING "HiSax: %s (%s): No IRQ\n",
 		       CardType[card->typ],
 		       sct_quadro_subtypes[cs->subtyp]);
-		return (0);
+		goto dev_a8_cleanup;
 	}
 	pci_read_config_dword(dev_a8, PCI_BASE_ADDRESS_1, &pci_ioaddr1);
 	pci_read_config_dword(dev_a8, PCI_BASE_ADDRESS_2, &pci_ioaddr2);
@@ -363,7 +363,7 @@ setup_sct_quadro(struct IsdnCard *card)
 		printk(KERN_WARNING "HiSax: %s (%s): No IO base address(es)\n",
 		       CardType[card->typ],
 		       sct_quadro_subtypes[cs->subtyp]);
-		return (0);
+		goto dev_a8_cleanup;
 	}
 	pci_ioaddr1 &= PCI_BASE_ADDRESS_IO_MASK;
 	pci_ioaddr2 &= PCI_BASE_ADDRESS_IO_MASK;
@@ -384,9 +384,9 @@ setup_sct_quadro(struct IsdnCard *card)
 		case 1:
 			cs->hw.ax.base = pci_ioaddr5 + 0x00;
 			if (sct_alloc_io(pci_ioaddr1, 128))
-				return(0);
+				goto dev_a8_cleanup;
 			if (sct_alloc_io(pci_ioaddr5, 64))
-				return(0);
+				goto dev_a8_cleanup;
 			/* disable all IPAC */
 			writereg(pci_ioaddr5, pci_ioaddr5 + 4,
 				IPAC_MASK, 0xFF);
@@ -400,17 +400,17 @@ setup_sct_quadro(struct IsdnCard *card)
 		case 2:
 			cs->hw.ax.base = pci_ioaddr4 + 0x08;
 			if (sct_alloc_io(pci_ioaddr4, 64))
-				return(0);
+				goto dev_a8_cleanup;
 			break;
 		case 3:
 			cs->hw.ax.base = pci_ioaddr3 + 0x10;
 			if (sct_alloc_io(pci_ioaddr3, 64))
-				return(0);
+				goto dev_a8_cleanup;
 			break;
 		case 4:
 			cs->hw.ax.base = pci_ioaddr2 + 0x20;
 			if (sct_alloc_io(pci_ioaddr2, 64))
-				return(0);
+				goto dev_a8_cleanup;
 			break;
 	}	
 	/* For isac and hscx data path */
@@ -441,8 +441,12 @@ setup_sct_quadro(struct IsdnCard *card)
 		CardType[card->typ],
 		sct_quadro_subtypes[cs->subtyp],
 		readreg(cs->hw.ax.base, cs->hw.ax.data_adr, IPAC_ID));
+	pci_dev_put(dev_a8);
 	return (1);
 #else
 	printk(KERN_ERR "HiSax: bkm_a8 only supported on PCI Systems\n");
 #endif /* CONFIG_PCI */
+dev_a8_cleanup:
+	pci_dev_put(dev_a8);
+	return 0;
 }

-- 
S.Çağlar Onur <caglar@pardus.org.tr>
http://cekirdek.pardus.org.tr/~caglar/

Linux is like living in a teepee. No Windows, no Gates and an Apache in house!
