Return-Path: <linux-kernel-owner+w=401wt.eu-S1756738AbYE2Ryx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756738AbYE2Ryx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 13:54:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751970AbYE2Ryq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 13:54:46 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:60577 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203AbYE2Ryp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 13:54:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=m305YdGcuxrt8sR82bBwq0iraGy0q7suapueC3dkylDTg0Ot5JqCDQSrSQ+/KJJxy6DmJvBdUO8o9ajHcxrxO1JS+UBoh67GopPuMU3WUiP4S0m3yUHPMPnQBGxyKbBTMIebXGZLr3ytKMFo8jun0nKXs/xHFM3smULkvHZKpYA=
Subject: [PATCH] byteorder: add put/get_{endian} helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: stern <stern@rowland.harvard.edu>, Greg KH <greg@kroah.com>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 29 May 2008 10:54:32 -0700
Message-Id: <1212083672.20781.19.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a set of endian helpers for the pattern:
*(__le16 *)ptr = cpu_to_le16(val);

put_le16(val, (__le16 *)ptr);

The argument order follows that of the get/put_unaligned_{endian}
helpers.

The get_ helpers are exactly equivalent to the existing {endian}_to_cpup
functions, but have been added anyway for symmetry in the apis.

Myrinet had a put_be32 helper that has been changed to myri_put_be32 to
avoid namespace collisions.

Private helpers in the usb-gadget drivers have been removed and switched
over to the common ones.  Note that the put helpers here had the args in
the opposite order from the common version.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Andrew, whether or not my patches reworking the byteorder headers goes in,
could we get this in -mm for testing to expose the new api?  At least then
the patches I have using the new api could go in.  Let me know if you
want that patchset that adds users of get/put_{endian}

 drivers/net/myri10ge/myri10ge.c   |   16 ++++----
 drivers/usb/gadget/file_storage.c |   78 +++++++++++-------------------------
 include/linux/byteorder/generic.h |   72 +++++++++++++++++++++++++++++++---
 3 files changed, 98 insertions(+), 68 deletions(-)

diff --git a/drivers/net/myri10ge/myri10ge.c b/drivers/net/myri10ge/myri10ge.c
index 36be6ef..5d035d0 100644
--- a/drivers/net/myri10ge/myri10ge.c
+++ b/drivers/net/myri10ge/myri10ge.c
@@ -331,7 +331,7 @@ MODULE_PARM_DESC(myri10ge_wcfifo, "Enable WC Fifo when WC is enabled");
 static void myri10ge_set_multicast_list(struct net_device *dev);
 static int myri10ge_sw_tso(struct sk_buff *skb, struct net_device *dev);
 
-static inline void put_be32(__be32 val, __be32 __iomem * p)
+static inline void myri_put_be32(__be32 val, __be32 __iomem * p)
 {
 	__raw_writel((__force __u32) val, (__force void __iomem *)p);
 }
@@ -897,7 +897,7 @@ static int myri10ge_reset(struct myri10ge_priv *mgp)
 		dev_err(&mgp->pdev->dev, "failed set interrupt parameters\n");
 		return status;
 	}
-	put_be32(htonl(mgp->intr_coal_delay), mgp->intr_coal_delay_ptr);
+	myri_put_be32(htonl(mgp->intr_coal_delay), mgp->intr_coal_delay_ptr);
 
 	memset(mgp->ss.rx_done.entry, 0, bytes);
 
@@ -930,7 +930,7 @@ myri10ge_submit_8rx(struct mcp_kreq_ether_recv __iomem * dst,
 	myri10ge_pio_copy(dst + 4, src + 4, 4 * sizeof(*src));
 	mb();
 	src->addr_low = low;
-	put_be32(low, &dst->addr_low);
+	myri_put_be32(low, &dst->addr_low);
 	mb();
 }
 
@@ -1288,7 +1288,7 @@ static int myri10ge_poll(struct napi_struct *napi, int budget)
 
 	if (work_done < budget) {
 		netif_rx_complete(netdev, napi);
-		put_be32(htonl(3), ss->irq_claim);
+		myri_put_be32(htonl(3), ss->irq_claim);
 	}
 	return work_done;
 }
@@ -1312,7 +1312,7 @@ static irqreturn_t myri10ge_intr(int irq, void *arg)
 		netif_rx_schedule(ss->dev, &ss->napi);
 
 	if (!mgp->msi_enabled) {
-		put_be32(0, mgp->irq_deassert);
+		myri_put_be32(0, mgp->irq_deassert);
 		if (!myri10ge_deassert_wait)
 			stats->valid = 0;
 		mb();
@@ -1341,7 +1341,7 @@ static irqreturn_t myri10ge_intr(int irq, void *arg)
 
 	myri10ge_check_statblock(mgp);
 
-	put_be32(htonl(3), ss->irq_claim + 1);
+	myri_put_be32(htonl(3), ss->irq_claim + 1);
 	return (IRQ_HANDLED);
 }
 
@@ -1410,7 +1410,7 @@ myri10ge_set_coalesce(struct net_device *netdev, struct ethtool_coalesce *coal)
 	struct myri10ge_priv *mgp = netdev_priv(netdev);
 
 	mgp->intr_coal_delay = coal->rx_coalesce_usecs;
-	put_be32(htonl(mgp->intr_coal_delay), mgp->intr_coal_delay_ptr);
+	myri_put_be32(htonl(mgp->intr_coal_delay), mgp->intr_coal_delay_ptr);
 	return 0;
 }
 
@@ -2201,7 +2201,7 @@ myri10ge_submit_req(struct myri10ge_tx_buf *tx, struct mcp_kreq_ether_send *src,
 
 	/* re-write the last 32-bits with the valid flags */
 	src->flags = last_flags;
-	put_be32(*((__be32 *) src + 3), (__be32 __iomem *) dst + 3);
+	myri_put_be32(*((__be32 *) src + 3), (__be32 __iomem *) dst + 3);
 	tx->req += cnt;
 	mb();
 }
diff --git a/drivers/usb/gadget/file_storage.c b/drivers/usb/gadget/file_storage.c
index 47bb9f0..99dad81 100644
--- a/drivers/usb/gadget/file_storage.c
+++ b/drivers/usb/gadget/file_storage.c
@@ -241,6 +241,7 @@
 
 #include <linux/usb/ch9.h>
 #include <linux/usb/gadget.h>
+#include <asm/byteorder.h>
 
 #include "gadget_chips.h"
 
@@ -763,37 +764,6 @@ static int fsg_set_halt(struct fsg_dev *fsg, struct usb_ep *ep)
 	return usb_ep_set_halt(ep);
 }
 
-
-/*-------------------------------------------------------------------------*/
-
-/* Routines for unaligned data access */
-
-static u16 get_be16(u8 *buf)
-{
-	return ((u16) buf[0] << 8) | ((u16) buf[1]);
-}
-
-static u32 get_be32(u8 *buf)
-{
-	return ((u32) buf[0] << 24) | ((u32) buf[1] << 16) |
-			((u32) buf[2] << 8) | ((u32) buf[3]);
-}
-
-static void put_be16(u8 *buf, u16 val)
-{
-	buf[0] = val >> 8;
-	buf[1] = val;
-}
-
-static void put_be32(u8 *buf, u32 val)
-{
-	buf[0] = val >> 24;
-	buf[1] = val >> 16;
-	buf[2] = val >> 8;
-	buf[3] = val & 0xff;
-}
-
-
 /*-------------------------------------------------------------------------*/
 
 /*
@@ -1551,9 +1521,9 @@ static int do_read(struct fsg_dev *fsg)
 	/* Get the starting Logical Block Address and check that it's
 	 * not too big */
 	if (fsg->cmnd[0] == SC_READ_6)
-		lba = (fsg->cmnd[1] << 16) | get_be16(&fsg->cmnd[2]);
+		lba = (fsg->cmnd[1] << 16) | get_be16((__be16 *)&fsg->cmnd[2]);
 	else {
-		lba = get_be32(&fsg->cmnd[2]);
+		lba = get_be32((__be32 *)&fsg->cmnd[2]);
 
 		/* We allow DPO (Disable Page Out = don't save data in the
 		 * cache) and FUA (Force Unit Access = don't read from the
@@ -1684,9 +1654,9 @@ static int do_write(struct fsg_dev *fsg)
 	/* Get the starting Logical Block Address and check that it's
 	 * not too big */
 	if (fsg->cmnd[0] == SC_WRITE_6)
-		lba = (fsg->cmnd[1] << 16) | get_be16(&fsg->cmnd[2]);
+		lba = (fsg->cmnd[1] << 16) | get_be16((__be16 *)&fsg->cmnd[2]);
 	else {
-		lba = get_be32(&fsg->cmnd[2]);
+		lba = get_be32((__be32 *)&fsg->cmnd[2]);
 
 		/* We allow DPO (Disable Page Out = don't save data in the
 		 * cache) and FUA (Force Unit Access = write directly to the
@@ -1920,7 +1890,7 @@ static int do_verify(struct fsg_dev *fsg)
 
 	/* Get the starting Logical Block Address and check that it's
 	 * not too big */
-	lba = get_be32(&fsg->cmnd[2]);
+	lba = get_be32((__be32 *)&fsg->cmnd[2]);
 	if (lba >= curlun->num_sectors) {
 		curlun->sense_data = SS_LOGICAL_BLOCK_ADDRESS_OUT_OF_RANGE;
 		return -EINVAL;
@@ -1933,7 +1903,7 @@ static int do_verify(struct fsg_dev *fsg)
 		return -EINVAL;
 	}
 
-	verification_length = get_be16(&fsg->cmnd[7]);
+	verification_length = get_be16((__be16 *)&fsg->cmnd[7]);
 	if (unlikely(verification_length == 0))
 		return -EIO;		// No default reply
 
@@ -2078,7 +2048,7 @@ static int do_request_sense(struct fsg_dev *fsg, struct fsg_buffhd *bh)
 	memset(buf, 0, 18);
 	buf[0] = valid | 0x70;			// Valid, current error
 	buf[2] = SK(sd);
-	put_be32(&buf[3], sdinfo);		// Sense information
+	put_be32(sdinfo, (__be32 *)&buf[3]);	// Sense information
 	buf[7] = 18 - 8;			// Additional sense length
 	buf[12] = ASC(sd);
 	buf[13] = ASCQ(sd);
@@ -2089,7 +2059,7 @@ static int do_request_sense(struct fsg_dev *fsg, struct fsg_buffhd *bh)
 static int do_read_capacity(struct fsg_dev *fsg, struct fsg_buffhd *bh)
 {
 	struct lun	*curlun = fsg->curlun;
-	u32		lba = get_be32(&fsg->cmnd[2]);
+	u32		lba = get_be32((__be32 *)&fsg->cmnd[2]);
 	int		pmi = fsg->cmnd[8];
 	u8		*buf = (u8 *) bh->buf;
 
@@ -2099,8 +2069,8 @@ static int do_read_capacity(struct fsg_dev *fsg, struct fsg_buffhd *bh)
 		return -EINVAL;
 	}
 
-	put_be32(&buf[0], curlun->num_sectors - 1);	// Max logical block
-	put_be32(&buf[4], 512);				// Block length
+	put_be32(curlun->num_sectors - 1, (__be32 *)&buf[0]);	// Max logical block
+	put_be32(512, (__be32 *)&buf[4]);			// Block length
 	return 8;
 }
 
@@ -2158,10 +2128,10 @@ static int do_mode_sense(struct fsg_dev *fsg, struct fsg_buffhd *bh)
 			buf[2] = 0x04;	// Write cache enable,
 					// Read cache not disabled
 					// No cache retention priorities
-			put_be16(&buf[4], 0xffff);  // Don't disable prefetch
+			put_be16(0xffff, (__be16 *)&buf[4]);  // Don't disable prefetch
 					// Minimum prefetch = 0
-			put_be16(&buf[8], 0xffff);  // Maximum prefetch
-			put_be16(&buf[10], 0xffff); // Maximum prefetch ceiling
+			put_be16(0xffff, (__be16 *)&buf[8]);  // Maximum prefetch
+			put_be16(0xffff, (__be16 *)&buf[10]); // Maximum prefetch ceiling
 		}
 		buf += 12;
 	}
@@ -2178,7 +2148,7 @@ static int do_mode_sense(struct fsg_dev *fsg, struct fsg_buffhd *bh)
 	if (mscmnd == SC_MODE_SENSE_6)
 		buf0[0] = len - 1;
 	else
-		put_be16(buf0, len - 2);
+		put_be16(len - 2, (__be16 *)buf0);
 	return len;
 }
 
@@ -2266,8 +2236,8 @@ static int do_read_format_capacities(struct fsg_dev *fsg,
 	buf[3] = 8;		// Only the Current/Maximum Capacity Descriptor
 	buf += 4;
 
-	put_be32(&buf[0], curlun->num_sectors);		// Number of blocks
-	put_be32(&buf[4], 512);				// Block length
+	put_be32(curlun->num_sectors, (__be32 *)&buf[0]);	// Number of blocks
+	put_be32(512, (__be32 *)&buf[4]);			// Block length
 	buf[4] = 0x02;					// Current capacity
 	return 12;
 }
@@ -2775,7 +2745,7 @@ static int do_scsi_command(struct fsg_dev *fsg)
 		break;
 
 	case SC_MODE_SELECT_10:
-		fsg->data_size_from_cmnd = get_be16(&fsg->cmnd[7]);
+		fsg->data_size_from_cmnd = get_be16((__be16 *)&fsg->cmnd[7]);
 		if ((reply = check_command(fsg, 10, DATA_DIR_FROM_HOST,
 				(1<<1) | (3<<7), 0,
 				"MODE SELECT(10)")) == 0)
@@ -2791,7 +2761,7 @@ static int do_scsi_command(struct fsg_dev *fsg)
 		break;
 
 	case SC_MODE_SENSE_10:
-		fsg->data_size_from_cmnd = get_be16(&fsg->cmnd[7]);
+		fsg->data_size_from_cmnd = get_be16((__be16 *)&fsg->cmnd[7]);
 		if ((reply = check_command(fsg, 10, DATA_DIR_TO_HOST,
 				(1<<1) | (1<<2) | (3<<7), 0,
 				"MODE SENSE(10)")) == 0)
@@ -2816,7 +2786,7 @@ static int do_scsi_command(struct fsg_dev *fsg)
 		break;
 
 	case SC_READ_10:
-		fsg->data_size_from_cmnd = get_be16(&fsg->cmnd[7]) << 9;
+		fsg->data_size_from_cmnd = get_be16((__be16 *)&fsg->cmnd[7]) << 9;
 		if ((reply = check_command(fsg, 10, DATA_DIR_TO_HOST,
 				(1<<1) | (0xf<<2) | (3<<7), 1,
 				"READ(10)")) == 0)
@@ -2824,7 +2794,7 @@ static int do_scsi_command(struct fsg_dev *fsg)
 		break;
 
 	case SC_READ_12:
-		fsg->data_size_from_cmnd = get_be32(&fsg->cmnd[6]) << 9;
+		fsg->data_size_from_cmnd = get_be32((__be32 *)&fsg->cmnd[6]) << 9;
 		if ((reply = check_command(fsg, 12, DATA_DIR_TO_HOST,
 				(1<<1) | (0xf<<2) | (0xf<<6), 1,
 				"READ(12)")) == 0)
@@ -2840,7 +2810,7 @@ static int do_scsi_command(struct fsg_dev *fsg)
 		break;
 
 	case SC_READ_FORMAT_CAPACITIES:
-		fsg->data_size_from_cmnd = get_be16(&fsg->cmnd[7]);
+		fsg->data_size_from_cmnd = get_be16((__be16 *)&fsg->cmnd[7]);
 		if ((reply = check_command(fsg, 10, DATA_DIR_TO_HOST,
 				(3<<7), 1,
 				"READ FORMAT CAPACITIES")) == 0)
@@ -2898,7 +2868,7 @@ static int do_scsi_command(struct fsg_dev *fsg)
 		break;
 
 	case SC_WRITE_10:
-		fsg->data_size_from_cmnd = get_be16(&fsg->cmnd[7]) << 9;
+		fsg->data_size_from_cmnd = get_be16((__be16 *)&fsg->cmnd[7]) << 9;
 		if ((reply = check_command(fsg, 10, DATA_DIR_FROM_HOST,
 				(1<<1) | (0xf<<2) | (3<<7), 1,
 				"WRITE(10)")) == 0)
@@ -2906,7 +2876,7 @@ static int do_scsi_command(struct fsg_dev *fsg)
 		break;
 
 	case SC_WRITE_12:
-		fsg->data_size_from_cmnd = get_be32(&fsg->cmnd[6]) << 9;
+		fsg->data_size_from_cmnd = get_be32((__be32 *)&fsg->cmnd[6]) << 9;
 		if ((reply = check_command(fsg, 12, DATA_DIR_FROM_HOST,
 				(1<<1) | (0xf<<2) | (0xf<<6), 1,
 				"WRITE(12)")) == 0)
diff --git a/include/linux/byteorder/generic.h b/include/linux/byteorder/generic.h
index 0846e6b..fdfe321 100644
--- a/include/linux/byteorder/generic.h
+++ b/include/linux/byteorder/generic.h
@@ -140,34 +140,94 @@
 #define htons(x) ___htons(x)
 #define ntohs(x) ___ntohs(x)
 
+static inline u16 get_le16(const __le16 *p)
+{
+	return le16_to_cpup(p);
+}
+
+static inline u32 get_le32(const __le32 *p)
+{
+	return le32_to_cpup(p);
+}
+
+static inline u64 get_le64(const __le64 *p)
+{
+	return le64_to_cpup(p);
+}
+
+static inline u16 get_be16(const __be16 *p)
+{
+	return be16_to_cpup(p);
+}
+
+static inline u32 get_be32(const __be32 *p)
+{
+	return be32_to_cpup(p);
+}
+
+static inline u64 get_be64(const __be64 *p)
+{
+	return be64_to_cpup(p);
+}
+
+static inline void put_le16(u16 val, __le16 *p)
+{
+	*p = cpu_to_le16(val);
+}
+
+static inline void put_le32(u32 val, __le32 *p)
+{
+	*p = cpu_to_le32(val);
+}
+
+static inline void put_le64(u64 val, __le64 *p)
+{
+	*p = cpu_to_le64(val);
+}
+
+static inline void put_be16(u16 val, __be16 *p)
+{
+	*p = cpu_to_be16(val);
+}
+
+static inline void put_be32(u32 val, __be32 *p)
+{
+	*p = cpu_to_be32(val);
+}
+
+static inline void put_be64(u64 val, __be64 *p)
+{
+	*p = cpu_to_be64(val);
+}
+
 static inline void le16_add_cpu(__le16 *var, u16 val)
 {
-	*var = cpu_to_le16(le16_to_cpu(*var) + val);
+	put_le16(get_le16(var) + val, var);
 }
 
 static inline void le32_add_cpu(__le32 *var, u32 val)
 {
-	*var = cpu_to_le32(le32_to_cpu(*var) + val);
+	put_le32(get_le32(var) + val, var);
 }
 
 static inline void le64_add_cpu(__le64 *var, u64 val)
 {
-	*var = cpu_to_le64(le64_to_cpu(*var) + val);
+	put_le64(get_le64(var) + val, var);
 }
 
 static inline void be16_add_cpu(__be16 *var, u16 val)
 {
-	*var = cpu_to_be16(be16_to_cpu(*var) + val);
+	put_be16(get_be16(var) + val, var);
 }
 
 static inline void be32_add_cpu(__be32 *var, u32 val)
 {
-	*var = cpu_to_be32(be32_to_cpu(*var) + val);
+	put_be32(get_be32(var) + val, var);
 }
 
 static inline void be64_add_cpu(__be64 *var, u64 val)
 {
-	*var = cpu_to_be64(be64_to_cpu(*var) + val);
+	put_be64(get_be64(var) + val, var);
 }
 
 #endif /* _LINUX_BYTEORDER_GENERIC_H */
-- 
1.5.6.rc0.277.g804cf



