Return-Path: <linux-kernel-owner+w=401wt.eu-S1758341AbYHBPQz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758341AbYHBPQz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 11:16:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757637AbYHBPPk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 11:15:40 -0400
Received: from mail.suse.de ([195.135.220.2]:47577 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757455AbYHBPPe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 11:15:34 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, isdn4linux@listserv.isdn4linux.de
From: Karsten Keil <kkeil@suse.de>
Date: Sat, 2 Aug 2008 16:35:53 +0200
Subject: [PATCH 3/4] Fix remaining big endian issue of hfcmulti
Message-Id: <20080802151532.DE017A3C09@pingi.kke.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver was not so bad at big endian at all, only the optimised fifo
read/write functions need a fix, with this fix the driver works on
a pegasus PPC machine.

Signed-off-by: Karsten Keil <kkeil@suse.de>
---
 drivers/isdn/hardware/mISDN/hfcmulti.c |   27 +++++++++++++--------------
 1 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/drivers/isdn/hardware/mISDN/hfcmulti.c b/drivers/isdn/hardware/mISDN/hfcmulti.c
index 10144e8..e36360a 100644
--- a/drivers/isdn/hardware/mISDN/hfcmulti.c
+++ b/drivers/isdn/hardware/mISDN/hfcmulti.c
@@ -140,7 +140,7 @@
  * #define HFC_REGISTER_DEBUG
  */
 
-static const char *hfcmulti_revision = "2.00";
+static const char *hfcmulti_revision = "2.01";
 
 #include <linux/module.h>
 #include <linux/pci.h>
@@ -427,12 +427,12 @@ write_fifo_regio(struct hfc_multi *hc, u_char *data, int len)
 {
 	outb(A_FIFO_DATA0, (hc->pci_iobase)+4);
 	while (len>>2) {
-		outl(*(u32 *)data, hc->pci_iobase);
+		outl(cpu_to_le32(*(u32 *)data), hc->pci_iobase);
 		data += 4;
 		len -= 4;
 	}
 	while (len>>1) {
-		outw(*(u16 *)data, hc->pci_iobase);
+		outw(cpu_to_le16(*(u16 *)data), hc->pci_iobase);
 		data += 2;
 		len -= 2;
 	}
@@ -447,17 +447,19 @@ void
 write_fifo_pcimem(struct hfc_multi *hc, u_char *data, int len)
 {
 	while (len>>2) {
-		writel(*(u32 *)data, (hc->pci_membase)+A_FIFO_DATA0);
+		writel(cpu_to_le32(*(u32 *)data),
+			hc->pci_membase + A_FIFO_DATA0);
 		data += 4;
 		len -= 4;
 	}
 	while (len>>1) {
-		writew(*(u16 *)data, (hc->pci_membase)+A_FIFO_DATA0);
+		writew(cpu_to_le16(*(u16 *)data),
+			hc->pci_membase + A_FIFO_DATA0);
 		data += 2;
 		len -= 2;
 	}
 	while (len) {
-		writeb(*data, (hc->pci_membase)+A_FIFO_DATA0);
+		writeb(*data, hc->pci_membase + A_FIFO_DATA0);
 		data++;
 		len--;
 	}
@@ -468,12 +470,12 @@ read_fifo_regio(struct hfc_multi *hc, u_char *data, int len)
 {
 	outb(A_FIFO_DATA0, (hc->pci_iobase)+4);
 	while (len>>2) {
-		*(u32 *)data = inl(hc->pci_iobase);
+		*(u32 *)data = le32_to_cpu(inl(hc->pci_iobase));
 		data += 4;
 		len -= 4;
 	}
 	while (len>>1) {
-		*(u16 *)data = inw(hc->pci_iobase);
+		*(u16 *)data = le16_to_cpu(inw(hc->pci_iobase));
 		data += 2;
 		len -= 2;
 	}
@@ -490,18 +492,18 @@ read_fifo_pcimem(struct hfc_multi *hc, u_char *data, int len)
 {
 	while (len>>2) {
 		*(u32 *)data =
-			readl((hc->pci_membase)+A_FIFO_DATA0);
+			le32_to_cpu(readl(hc->pci_membase + A_FIFO_DATA0));
 		data += 4;
 		len -= 4;
 	}
 	while (len>>1) {
 		*(u16 *)data =
-			readw((hc->pci_membase)+A_FIFO_DATA0);
+			le16_to_cpu(readw(hc->pci_membase + A_FIFO_DATA0));
 		data += 2;
 		len -= 2;
 	}
 	while (len) {
-		*data = readb((hc->pci_membase)+A_FIFO_DATA0);
+		*data = readb(hc->pci_membase + A_FIFO_DATA0);
 		data++;
 		len--;
 	}
@@ -5251,9 +5253,6 @@ HFCmulti_init(void)
 	if (debug & DEBUG_HFCMULTI_INIT)
 		printk(KERN_DEBUG "%s: init entered\n", __func__);
 
-#ifdef __BIG_ENDIAN
-#error "not running on big endian machines now"
-#endif
 	hfc_interrupt = symbol_get(ztdummy_extern_interrupt);
 	register_interrupt = symbol_get(ztdummy_register_interrupt);
 	unregister_interrupt = symbol_get(ztdummy_unregister_interrupt);
-- 
1.5.6.4

