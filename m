Return-Path: <linux-kernel-owner+w=401wt.eu-S1755775AbZHLDA7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755775AbZHLDA7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 23:00:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753598AbZHLDA6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 23:00:58 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:36893 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753521AbZHLDA5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 23:00:57 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Lothar Wassmann <LW@karo-electronics.de>,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH] USB: isp1362: fix build warnings on 64-bit systems
Date: Tue, 11 Aug 2009 23:00:53 -0400
Message-Id: <1250046053-3097-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A bunch of places assumed pointers were 32-bits in size (bit checking and
debug output), but none of these affected runtime functionality.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 drivers/usb/host/isp1362-hcd.c |   22 +++++++++++-----------
 drivers/usb/host/isp1362.h     |   12 ++++++------
 2 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/usb/host/isp1362-hcd.c b/drivers/usb/host/isp1362-hcd.c
index 16ba1ea..b7acb3c 100644
--- a/drivers/usb/host/isp1362-hcd.c
+++ b/drivers/usb/host/isp1362-hcd.c
@@ -1076,7 +1076,7 @@ static irqreturn_t isp1362_irq(struct usb_hcd *hcd)
 		DBG(1, "%s: ISTL0\n", __func__);
 		WARN_ON((int)!!isp1362_hcd->istl_flip);
 		WARN_ON(isp1362_read_reg16(isp1362_hcd, HCBUFSTAT) & HCBUFSTAT_ISTL0_ACTIVE);
-		WARN_ON(!isp1362_read_reg16(isp1362_hcd, HCBUFSTAT) & HCBUFSTAT_ISTL0_DONE);
+		WARN_ON(!(isp1362_read_reg16(isp1362_hcd, HCBUFSTAT) & HCBUFSTAT_ISTL0_DONE));
 		isp1362_hcd->irqenb &= ~HCuPINT_ISTL0;
 	}
 
@@ -1088,7 +1088,7 @@ static irqreturn_t isp1362_irq(struct usb_hcd *hcd)
 		DBG(1, "%s: ISTL1\n", __func__);
 		WARN_ON(!(int)isp1362_hcd->istl_flip);
 		WARN_ON(isp1362_read_reg16(isp1362_hcd, HCBUFSTAT) & HCBUFSTAT_ISTL1_ACTIVE);
-		WARN_ON(!isp1362_read_reg16(isp1362_hcd, HCBUFSTAT) & HCBUFSTAT_ISTL1_DONE);
+		WARN_ON(!(isp1362_read_reg16(isp1362_hcd, HCBUFSTAT) & HCBUFSTAT_ISTL1_DONE));
 		isp1362_hcd->irqenb &= ~HCuPINT_ISTL1;
 	}
 
@@ -2280,10 +2280,10 @@ static int isp1362_mem_config(struct usb_hcd *hcd)
 	dev_info(hcd->self.controller, "ISP1362 Memory usage:\n");
 	dev_info(hcd->self.controller, "  ISTL:    2 * %4d:     %4d @ $%04x:$%04x\n",
 		 istl_size / 2, istl_size, 0, istl_size / 2);
-	dev_info(hcd->self.controller, "  INTL: %4d * (%3u+8):  %4d @ $%04x\n",
+	dev_info(hcd->self.controller, "  INTL: %4d * (%3lu+8):  %4d @ $%04x\n",
 		 ISP1362_INTL_BUFFERS, intl_blksize - PTD_HEADER_SIZE,
 		 intl_size, istl_size);
-	dev_info(hcd->self.controller, "  ATL : %4d * (%3u+8):  %4d @ $%04x\n",
+	dev_info(hcd->self.controller, "  ATL : %4d * (%3lu+8):  %4d @ $%04x\n",
 		 atl_buffers, atl_blksize - PTD_HEADER_SIZE,
 		 atl_size, istl_size + intl_size);
 	dev_info(hcd->self.controller, "  USED/FREE:   %4d      %4d\n", total,
@@ -2673,12 +2673,12 @@ static int __devexit isp1362_remove(struct platform_device *pdev)
 	DBG(0, "%s: Removing HCD\n", __func__);
 	usb_remove_hcd(hcd);
 
-	DBG(0, "%s: Unmapping data_reg @ %08x\n", __func__,
-	    (u32)isp1362_hcd->data_reg);
+	DBG(0, "%s: Unmapping data_reg @ %p\n", __func__,
+	    isp1362_hcd->data_reg);
 	iounmap(isp1362_hcd->data_reg);
 
-	DBG(0, "%s: Unmapping addr_reg @ %08x\n", __func__,
-	    (u32)isp1362_hcd->addr_reg);
+	DBG(0, "%s: Unmapping addr_reg @ %p\n", __func__,
+	    isp1362_hcd->addr_reg);
 	iounmap(isp1362_hcd->addr_reg);
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
@@ -2806,16 +2806,16 @@ static int __init isp1362_probe(struct platform_device *pdev)
 	return 0;
 
  err6:
-	DBG(0, "%s: Freeing dev %08x\n", __func__, (u32)isp1362_hcd);
+	DBG(0, "%s: Freeing dev %p\n", __func__, isp1362_hcd);
 	usb_put_hcd(hcd);
  err5:
-	DBG(0, "%s: Unmapping data_reg @ %08x\n", __func__, (u32)data_reg);
+	DBG(0, "%s: Unmapping data_reg @ %p\n", __func__, data_reg);
 	iounmap(data_reg);
  err4:
 	DBG(0, "%s: Releasing mem region %08lx\n", __func__, (long unsigned int)data->start);
 	release_mem_region(data->start, resource_len(data));
  err3:
-	DBG(0, "%s: Unmapping addr_reg @ %08x\n", __func__, (u32)addr_reg);
+	DBG(0, "%s: Unmapping addr_reg @ %p\n", __func__, addr_reg);
 	iounmap(addr_reg);
  err2:
 	DBG(0, "%s: Releasing mem region %08lx\n", __func__, (long unsigned int)addr->start);
diff --git a/drivers/usb/host/isp1362.h b/drivers/usb/host/isp1362.h
index fe60f62..1a253eb 100644
--- a/drivers/usb/host/isp1362.h
+++ b/drivers/usb/host/isp1362.h
@@ -580,7 +580,7 @@ static inline const char *ISP1362_INT_NAME(int n)
 
 static inline void ALIGNSTAT(struct isp1362_hcd *isp1362_hcd, void *ptr)
 {
-	unsigned p = (unsigned)ptr;
+	unsigned long p = (unsigned long)ptr;
 	if (!(p & 0xf))
 		isp1362_hcd->stat16++;
 	else if (!(p & 0x7))
@@ -770,7 +770,7 @@ static void isp1362_write_fifo(struct isp1362_hcd *isp1362_hcd, void *buf, u16 l
 	if (!len)
 		return;
 
-	if ((unsigned)dp & 0x1) {
+	if ((unsigned long)dp & 0x1) {
 		/* not aligned */
 		for (; len > 1; len -= 2) {
 			data = *dp++;
@@ -962,8 +962,8 @@ static void isp1362_read_buffer(struct isp1362_hcd *isp1362_hcd, void *buf, u16
 
 	isp1362_write_diraddr(isp1362_hcd, offset, len);
 
-	DBG(3, "%s: Reading %d byte from buffer @%04x to memory @ %08x\n", __func__,
-	    len, offset, (u32)buf);
+	DBG(3, "%s: Reading %d byte from buffer @%04x to memory @ %p\n",
+	    __func__, len, offset, buf);
 
 	isp1362_write_reg16(isp1362_hcd, HCuPINT, HCuPINT_EOT);
 	_WARN_ON((isp1362_read_reg16(isp1362_hcd, HCuPINT) & HCuPINT_EOT));
@@ -982,8 +982,8 @@ static void isp1362_write_buffer(struct isp1362_hcd *isp1362_hcd, void *buf, u16
 
 	isp1362_write_diraddr(isp1362_hcd, offset, len);
 
-	DBG(3, "%s: Writing %d byte to buffer @%04x from memory @ %08x\n", __func__,
-	    len, offset, (u32)buf);
+	DBG(3, "%s: Writing %d byte to buffer @%04x from memory @ %p\n",
+	    __func__, len, offset, buf);
 
 	isp1362_write_reg16(isp1362_hcd, HCuPINT, HCuPINT_EOT);
 	_WARN_ON((isp1362_read_reg16(isp1362_hcd, HCuPINT) & HCuPINT_EOT));
-- 
1.6.3.3

