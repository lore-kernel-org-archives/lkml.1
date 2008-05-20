Return-Path: <linux-kernel-owner+w=401wt.eu-S933143AbYETSI3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933143AbYETSI3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 14:08:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932459AbYETSG0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 14:06:26 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:3977 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932390AbYETSGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 14:06:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=DsOZT5CFONgtM8rW5QfxwuVeAEw/xY5CWvnGMGBUooVWwg0h4xR678Lz0bBtSi0v4tUgjqeoVd2sMwvY63HqI1L4voxshw3GtsehpljRABv9P72ZqWXdUTPMqdHVodFNu4Ht/Ex+vcQxhu4/UXGF/BWERZycU6q1urMfmfIva4k=
Subject: [PATCH 05/21] drivers/usb: use aligned-endian get/put helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 20 May 2008 11:06:12 -0700
Message-Id: <1211306772.5915.173.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/usb/c67x00/c67x00-hcd.c |    4 ++--
 drivers/usb/core/devio.c        |   12 ++++++------
 drivers/usb/gadget/net2280.c    |    2 +-
 drivers/usb/host/ehci.h         |    6 ++----
 drivers/usb/host/isp116x-hcd.c  |    4 ++--
 drivers/usb/host/ohci.h         |   16 ++++++----------
 drivers/usb/host/uhci-hub.c     |    6 +++---
 drivers/usb/misc/auerswald.c    |    2 +-
 drivers/usb/serial/garmin_gps.c |    9 ++++-----
 drivers/usb/storage/isd200.c    |    4 ++--
 10 files changed, 29 insertions(+), 36 deletions(-)

diff --git a/drivers/usb/c67x00/c67x00-hcd.c b/drivers/usb/c67x00/c67x00-hcd.c
index a22b887..909abd6 100644
--- a/drivers/usb/c67x00/c67x00-hcd.c
+++ b/drivers/usb/c67x00/c67x00-hcd.c
@@ -117,8 +117,8 @@ static int c67x00_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
 		if (usb_status & SOF_EOP_EN(port))
 			wPortStatus |= USB_PORT_STAT_ENABLE;
 
-		*(__le16 *) buf = cpu_to_le16(wPortStatus);
-		*(__le16 *) (buf + 2) = cpu_to_le16(wPortChange);
+		put_le16(wPortStatus, buf);
+		put_le16(wPortChange, buf + 2);
 		len = 4;
 		break;
 
diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
index de17738..b44a061 100644
--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -993,18 +993,18 @@ static int proc_do_submiturb(struct dev_state *ps, struct usbdevfs_urb *uurb,
 			kfree(dr);
 			return -EFAULT;
 		}
-		if (uurb->buffer_length < (le16_to_cpup(&dr->wLength) + 8)) {
+		if (uurb->buffer_length < get_le16(&dr->wLength) + 8)) {
 			kfree(dr);
 			return -EINVAL;
 		}
 		ret = check_ctrlrecip(ps, dr->bRequestType,
-				      le16_to_cpup(&dr->wIndex));
+				      get_le16(&dr->wIndex));
 		if (ret) {
 			kfree(dr);
 			return ret;
 		}
 		uurb->number_of_packets = 0;
-		uurb->buffer_length = le16_to_cpup(&dr->wLength);
+		uurb->buffer_length = get_le16(&dr->wLength);
 		uurb->buffer += 8;
 		if ((dr->bRequestType & USB_DIR_IN) && uurb->buffer_length) {
 			is_in = 1;
@@ -1022,9 +1022,9 @@ static int proc_do_submiturb(struct dev_state *ps, struct usbdevfs_urb *uurb,
 			"bRrequestType=%02x wValue=%04x "
 			"wIndex=%04x wLength=%04x\n",
 			dr->bRequest, dr->bRequestType,
-			__le16_to_cpup(&dr->wValue),
-			__le16_to_cpup(&dr->wIndex),
-			__le16_to_cpup(&dr->wLength));
+			get_le16(&dr->wValue),
+			get_le16(&dr->wIndex),
+			get_le16(&dr->wLength));
 		break;
 
 	case USBDEVFS_URB_TYPE_BULK:
diff --git a/drivers/usb/gadget/net2280.c b/drivers/usb/gadget/net2280.c
index e018623..cb8a3ab 100644
--- a/drivers/usb/gadget/net2280.c
+++ b/drivers/usb/gadget/net2280.c
@@ -982,7 +982,7 @@ static void scan_dma_completions (struct net2280_ep *ep)
 		if (!req->valid)
 			break;
 		rmb ();
-		tmp = le32_to_cpup (&req->td->dmacount);
+		tmp = get_le32(&req->td->dmacount);
 		if ((tmp & (1 << VALID_BIT)) != 0)
 			break;
 
diff --git a/drivers/usb/host/ehci.h b/drivers/usb/host/ehci.h
index bf92d20..3db5d7f 100644
--- a/drivers/usb/host/ehci.h
+++ b/drivers/usb/host/ehci.h
@@ -804,9 +804,7 @@ static inline u32 hc32_to_cpu (const struct ehci_hcd *ehci, const __hc32 x)
 
 static inline u32 hc32_to_cpup (const struct ehci_hcd *ehci, const __hc32 *x)
 {
-	return ehci_big_endian_desc(ehci)
-		? be32_to_cpup((__force __be32 *)x)
-		: le32_to_cpup((__force __le32 *)x);
+	return ehci_big_endian_desc(ehci) ? get_be32(x) : get_le32(x);
 }
 
 #else
@@ -825,7 +823,7 @@ static inline u32 hc32_to_cpu (const struct ehci_hcd *ehci, const __hc32 x)
 
 static inline u32 hc32_to_cpup (const struct ehci_hcd *ehci, const __hc32 *x)
 {
-	return le32_to_cpup(x);
+	return get_le32(x);
 }
 
 #endif
diff --git a/drivers/usb/host/isp116x-hcd.c b/drivers/usb/host/isp116x-hcd.c
index 20b9a0d..e454c0e 100644
--- a/drivers/usb/host/isp116x-hcd.c
+++ b/drivers/usb/host/isp116x-hcd.c
@@ -1024,7 +1024,7 @@ static int isp116x_hub_control(struct usb_hcd *hcd,
 		break;
 	case GetHubStatus:
 		DBG("GetHubStatus\n");
-		*(__le32 *) buf = 0;
+		put_le32(0, buf);
 		break;
 	case GetPortStatus:
 		DBG("GetPortStatus\n");
@@ -1033,7 +1033,7 @@ static int isp116x_hub_control(struct usb_hcd *hcd,
 		spin_lock_irqsave(&isp116x->lock, flags);
 		tmp = isp116x_read_reg32(isp116x, (--wIndex) ? HCRHPORT2 : HCRHPORT1);
 		spin_unlock_irqrestore(&isp116x->lock, flags);
-		*(__le32 *) buf = cpu_to_le32(tmp);
+		put_le32(tmp, buf);
 		DBG("GetPortStatus: port[%d]  %08x\n", wIndex + 1, tmp);
 		break;
 	case ClearPortFeature:
diff --git a/drivers/usb/host/ohci.h b/drivers/usb/host/ohci.h
index dc544dd..a1b55dc 100644
--- a/drivers/usb/host/ohci.h
+++ b/drivers/usb/host/ohci.h
@@ -615,11 +615,9 @@ static inline u16 hc16_to_cpu (const struct ohci_hcd *ohci, const __hc16 x)
 		le16_to_cpu((__force __le16)x);
 }
 
-static inline u16 hc16_to_cpup (const struct ohci_hcd *ohci, const __hc16 *x)
+static inline u16 hc16_to_cpup(const struct ohci_hcd *ohci, const __hc16 *x)
 {
-	return big_endian_desc(ohci) ?
-		be16_to_cpup((__force __be16 *)x) :
-		le16_to_cpup((__force __le16 *)x);
+	return big_endian_desc(ohci) ? get_be16(x) : get_le16(x);
 }
 
 static inline u32 hc32_to_cpu (const struct ohci_hcd *ohci, const __hc32 x)
@@ -629,11 +627,9 @@ static inline u32 hc32_to_cpu (const struct ohci_hcd *ohci, const __hc32 x)
 		le32_to_cpu((__force __le32)x);
 }
 
-static inline u32 hc32_to_cpup (const struct ohci_hcd *ohci, const __hc32 *x)
+static inline u32 hc32_to_cpup(const struct ohci_hcd *ohci, const __hc32 *x)
 {
-	return big_endian_desc(ohci) ?
-		be32_to_cpup((__force __be32 *)x) :
-		le32_to_cpup((__force __le32 *)x);
+	return big_endian_desc(ohci) ? get_be32(x) : get_le32(x);
 }
 
 /*-------------------------------------------------------------------------*/
@@ -653,11 +649,11 @@ static inline u16 ohci_frame_no(const struct ohci_hcd *ohci)
 {
 	u32 tmp;
 	if (big_endian_desc(ohci)) {
-		tmp = be32_to_cpup((__force __be32 *)&ohci->hcca->frame_no);
+		tmp = get_be32(&ohci->hcca->frame_no);
 		if (!big_endian_frame_no_quirk(ohci))
 			tmp >>= 16;
 	} else
-		tmp = le32_to_cpup((__force __le32 *)&ohci->hcca->frame_no);
+		tmp = get_le32(&ohci->hcca->frame_no);
 
 	return (u16)tmp;
 }
diff --git a/drivers/usb/host/uhci-hub.c b/drivers/usb/host/uhci-hub.c
index 8e4427a..3041c8c 100644
--- a/drivers/usb/host/uhci-hub.c
+++ b/drivers/usb/host/uhci-hub.c
@@ -253,7 +253,7 @@ static int uhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
 	switch (typeReq) {
 
 	case GetHubStatus:
-		*(__le32 *)buf = cpu_to_le32(0);
+		put_le32(0, buf);
 		OK(4);		/* hub power */
 	case GetPortStatus:
 		if (port >= uhci->rh_numports)
@@ -306,8 +306,8 @@ static int uhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
 			dev_dbg(uhci_dev(uhci), "port %d portsc %04x,%02x\n",
 					wIndex, status, lstatus);
 
-		*(__le16 *)buf = cpu_to_le16(wPortStatus);
-		*(__le16 *)(buf + 2) = cpu_to_le16(wPortChange);
+		put_le16(wPortStatus, buf);
+		put_le16(wPortChange, buf + 2);
 		OK(4);
 	case SetHubFeature:		/* We don't implement these */
 	case ClearHubFeature:
diff --git a/drivers/usb/misc/auerswald.c b/drivers/usb/misc/auerswald.c
index 0939386..2572cd4 100644
--- a/drivers/usb/misc/auerswald.c
+++ b/drivers/usb/misc/auerswald.c
@@ -1982,7 +1982,7 @@ static int auerswald_probe (struct usb_interface *intf,
                 2,                                  /* length of the buffer */
                 2000);                            /* time to wait for the message to complete before timing out */
         if (ret == 2) {
-	        cp->maxControlLength = le16_to_cpup(pbuf);
+		cp->maxControlLength = get_le16(pbuf);
                 kfree(pbuf);
                 dbg("setup: max. allowed control transfersize is %d bytes", cp->maxControlLength);
         } else {
diff --git a/drivers/usb/serial/garmin_gps.c b/drivers/usb/serial/garmin_gps.c
index 8ce5a56..869f701 100644
--- a/drivers/usb/serial/garmin_gps.c
+++ b/drivers/usb/serial/garmin_gps.c
@@ -241,17 +241,17 @@ static inline int noResponseFromAppLayer(struct garmin_data * garmin_data_p)
 
 static inline int getLayerId(const __u8 *usbPacket)
 {
-	return __le32_to_cpup((__le32 *)(usbPacket));
+	return get_le32(usbPacket);
 }
 
 static inline int getPacketId(const __u8 *usbPacket)
 {
-	return __le32_to_cpup((__le32 *)(usbPacket+4));
+	return get_le32(usbPacket + 4);
 }
 
 static inline int getDataLength(const __u8 *usbPacket)
 {
-	return __le32_to_cpup((__le32 *)(usbPacket+8));
+	return get_le32(usbPacket + 8);
 }
 

@@ -1413,8 +1413,7 @@ static void garmin_read_int_callback (struct urb *urb)
 		spin_unlock_irqrestore(&garmin_data_p->lock, flags);
 
 		/* save the serial number */
-		garmin_data_p->serial_num 
-			= __le32_to_cpup((__le32*)(data+GARMIN_PKTHDR_LENGTH));
+		garmin_data_p->serial_num = get_le32(data + GARMIN_PKTHDR_LENGTH);
 
 		dbg("%s - start-of-session reply seen - serial %u.",
 			__func__, garmin_data_p->serial_num);
diff --git a/drivers/usb/storage/isd200.c b/drivers/usb/storage/isd200.c
index 3addcd8..71eda8a 100644
--- a/drivers/usb/storage/isd200.c
+++ b/drivers/usb/storage/isd200.c
@@ -1344,7 +1344,7 @@ static int isd200_scsi_to_ata(struct scsi_cmnd *srb, struct us_data *us,
 	case READ_10:
 		US_DEBUGP("   ATA OUT - SCSIOP_READ\n");
 
-		lba = be32_to_cpu(*(__be32 *)&srb->cmnd[2]);
+		lba = get_be32(&srb->cmnd[2]);
 		blockCount = (unsigned long)srb->cmnd[7]<<8 | (unsigned long)srb->cmnd[8];
 
 		if (id->capability & CAPABILITY_LBA) {
@@ -1376,7 +1376,7 @@ static int isd200_scsi_to_ata(struct scsi_cmnd *srb, struct us_data *us,
 	case WRITE_10:
 		US_DEBUGP("   ATA OUT - SCSIOP_WRITE\n");
 
-		lba = be32_to_cpu(*(__be32 *)&srb->cmnd[2]);
+		lba = get_be32(&srb->cmnd[2]);
 		blockCount = (unsigned long)srb->cmnd[7]<<8 | (unsigned long)srb->cmnd[8];
 
 		if (id->capability & CAPABILITY_LBA) {
-- 
1.5.5.1.570.g26b5e


