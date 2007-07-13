Return-Path: <linux-kernel-owner+w=401wt.eu-S937284AbXGMWo6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937284AbXGMWo6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 18:44:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934809AbXGMWof
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 18:44:35 -0400
Received: from ns2.uludag.org.tr ([193.140.100.220]:59069 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932554AbXGMWoe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 18:44:34 -0400
From: "=?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur" <caglar@pardus.org.tr>
Reply-To: caglar@pardus.org.tr
Organization: =?utf-8?q?T=C3=9CB=C4=B0TAK_/?= UEKAE
Subject: [PATCH 1/12] drivers/isdn/hisax/avm_pci.c: replace pci_find_device with pci_get_device
Date: Sat, 14 Jul 2007 01:44:19 +0300
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Disposition: inline
To: LKML <linux-kernel@vger.kernel.org>
Cc: kkeil@suse.de, kai.germaschewski@gmx.de, isdn4linux@listserv.isdn4linux.de
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <200707140144.20855.caglar@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Following patch replaces pci_find_device with pci_get_device to avoid 
following compiliation warning;

drivers/isdn/hisax/avm_pci.c: In function `setup_avm_pcipnp':
drivers/isdn/hisax/avm_pci.c:792: warning: `pci_find_device' is deprecated 
(declared at include/linux/pci.h:478)

Signed-off-by: S.Çağlar Onur <caglar@pardus.org.tr>

---
 drivers/isdn/hisax/avm_pci.c |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

Index: linux-2.6/drivers/isdn/hisax/avm_pci.c
===================================================================
--- linux-2.6.orig/drivers/isdn/hisax/avm_pci.c
+++ linux-2.6/drivers/isdn/hisax/avm_pci.c
@@ -789,19 +789,19 @@ setup_avm_pcipnp(struct IsdnCard *card)
 	}
 #endif
 #ifdef CONFIG_PCI
-	if ((dev_avm = pci_find_device(PCI_VENDOR_ID_AVM,
+	if ((dev_avm = pci_get_device(PCI_VENDOR_ID_AVM,
 		PCI_DEVICE_ID_AVM_A1,  dev_avm))) {
 		if (pci_enable_device(dev_avm))
-			return(0);
+			goto dev_avm_cleanup;
 		cs->irq = dev_avm->irq;
 		if (!cs->irq) {
 			printk(KERN_ERR "FritzPCI: No IRQ for PCI card found\n");
-			return(0);
+			goto dev_avm_cleanup;
 		}
 		cs->hw.avm.cfg_reg = pci_resource_start(dev_avm, 1);
 		if (!cs->hw.avm.cfg_reg) {
 			printk(KERN_ERR "FritzPCI: No IO-Adr for PCI card found\n");
-			return(0);
+			goto dev_avm_cleanup;
 		}
 		cs->subtyp = AVM_FRITZ_PCI;
 	} else {
@@ -822,7 +822,7 @@ ready:
 		       CardType[card->typ],
 		       cs->hw.avm.cfg_reg,
 		       cs->hw.avm.cfg_reg + 31);
-		return (0);
+		goto dev_avm_cleanup;
 	}
 	switch (cs->subtyp) {
 	  case AVM_FRITZ_PCI:
@@ -842,7 +842,7 @@ ready:
 		break;
 	  default:
 	  	printk(KERN_WARNING "AVM unknown subtype %d\n", cs->subtyp);
-	  	return(0);
+		goto dev_avm_cleanup;
 	}
 	printk(KERN_INFO "HiSax: %s config irq:%d base:0x%X\n",
 		(cs->subtyp == AVM_FRITZ_PCI) ? "AVM Fritz!PCI" : "AVM Fritz!PnP",
@@ -858,5 +858,10 @@ ready:
 	cs->irq_func = &avm_pcipnp_interrupt;
 	cs->writeisac(cs, ISAC_MASK, 0xFF);
 	ISACVersion(cs, (cs->subtyp == AVM_FRITZ_PCI) ? "AVM PCI:" : "AVM PnP:");
+	pci_dev_put(dev_avm);
 	return (1);
+
+dev_avm_cleanup:
+	pci_dev_put(dev_avm);
+	return (0);
 }

-- 
S.Çağlar Onur <caglar@pardus.org.tr>
http://cekirdek.pardus.org.tr/~caglar/

Linux is like living in a teepee. No Windows, no Gates and an Apache in house!
