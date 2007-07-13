Return-Path: <linux-kernel-owner+w=401wt.eu-S937970AbXGMXC1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937970AbXGMXC1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 19:02:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759346AbXGMXCR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 19:02:17 -0400
Received: from ns2.uludag.org.tr ([193.140.100.220]:52930 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758348AbXGMXCQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 19:02:16 -0400
From: "=?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur" <caglar@pardus.org.tr>
Reply-To: caglar@pardus.org.tr
Organization: =?utf-8?q?T=C3=9CB=C4=B0TAK_/?= UEKAE
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 7/12] drivers/isdn/hisax/hfc_pci.c: replace pci_find_device with pci_get_device
Date: Sat, 14 Jul 2007 02:02:00 +0300
User-Agent: KMail/1.9.7
Cc: kkeil@suse.de, kai.germaschewski@gmx.de, isdn4linux@listserv.isdn4linux.de
References: <200707140144.43873.caglar@pardus.org.tr>
In-Reply-To: <200707140144.43873.caglar@pardus.org.tr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200707140202.01659.caglar@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[resend] i forget to quilt refresh :(, sorry for noise

14 Tem 2007 Cts tarihinde, S.Çağlar Onur şunları yazmıştı: 
> ---
>  drivers/isdn/hisax/hfc_pci.c |   13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)

Following patch replaces pci_find_device with pci_get_device to avoid 
following compiliation warning;

drivers/isdn/hisax/hfc_pci.c: In function `setup_hfcpci':
drivers/isdn/hisax/hfc_pci.c:1668: warning: `pci_find_device' is deprecated 
(declared at include/linux/pci.h:478)

Signed-off-by: S.Çağlar Onur <caglar@pardus.org.tr>

---
 drivers/isdn/hisax/hfc_pci.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

Index: linux-2.6/drivers/isdn/hisax/hfc_pci.c
===================================================================
--- linux-2.6.orig/drivers/isdn/hisax/hfc_pci.c
+++ linux-2.6/drivers/isdn/hisax/hfc_pci.c
@@ -1665,7 +1665,7 @@ setup_hfcpci(struct IsdnCard *card)
 	if (cs->typ == ISDN_CTYPE_HFC_PCI) {
 		i = 0;
 		while (id_list[i].vendor_id) {
-			tmp_hfcpci = pci_find_device(id_list[i].vendor_id,
+			tmp_hfcpci = pci_get_device(id_list[i].vendor_id,
 						     id_list[i].device_id,
 						     dev_hfcpci);
 			i++;
@@ -1687,7 +1687,7 @@ setup_hfcpci(struct IsdnCard *card)
 			cs->irq = dev_hfcpci->irq;
 			if (!cs->irq) {
 				printk(KERN_WARNING "HFC-PCI: No IRQ for PCI card found\n");
-				return (0);
+				goto tmp_hfcpci_cleanup;
 			}
 			cs->hw.hfcpci.pci_io = (char *)(unsigned 
long)dev_hfcpci->resource[1].start;
 			printk(KERN_INFO "HiSax: HFC-PCI card manufacturer: %s card name: %s\n", 
id_list[i].vendor_name, id_list[i].card_name);
@@ -1697,14 +1697,14 @@ setup_hfcpci(struct IsdnCard *card)
 		}
 		if (!cs->hw.hfcpci.pci_io) {
 			printk(KERN_WARNING "HFC-PCI: No IO-Mem for PCI card found\n");
-			return (0);
+			goto tmp_hfcpci_cleanup;
 		}
 		/* Allocate memory for FIFOS */
 		/* Because the HFC-PCI needs a 32K physical alignment, we */
 		/* need to allocate the double mem and align the address */
 		if (!(cs->hw.hfcpci.share_start = kmalloc(65536, GFP_KERNEL))) {
 			printk(KERN_WARNING "HFC-PCI: Error allocating memory for FIFO!\n");
-			return 0;
+			goto tmp_hfcpci_cleanup;
 		}
 		cs->hw.hfcpci.fifos = (void *)
 		    (((ulong) cs->hw.hfcpci.share_start) & ~0x7FFF) + 0x8000;
@@ -1741,9 +1741,14 @@ setup_hfcpci(struct IsdnCard *card)
 		cs->cardmsg = &hfcpci_card_msg;
 		cs->auxcmd = &hfcpci_auxcmd;
 		spin_unlock_irqrestore(&cs->lock, flags);
+		pci_dev_put(tmp_hfcpci);
 		return (1);
 	} else
 		return (0);	/* no valid card type */
+
+tmp_hfcpci_cleanup:
+	pci_dev_put(tmp_hfcpci);
+	return (0);
 #else
 	printk(KERN_WARNING "HFC-PCI: NO_PCI_BIOS\n");
 	return (0);

-- 
S.Çağlar Onur <caglar@pardus.org.tr>
http://cekirdek.pardus.org.tr/~caglar/

Linux is like living in a teepee. No Windows, no Gates and an Apache in house!
