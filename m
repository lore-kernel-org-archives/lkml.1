Return-Path: <linux-kernel-owner+w=401wt.eu-S1031607AbXFIAEb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031607AbXFIAEb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 20:04:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S969431AbXFIAEK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 20:04:10 -0400
Received: from ns2.suse.de ([195.135.220.15]:47969 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968858AbXFIAEI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 20:04:08 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-usb-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, David Brownell <david-b@pacbell.net>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 3/9] USB: usb gadgets avoid le{16,32}_to_cpup()
Date: Fri,  8 Jun 2007 17:03:48 -0700
Message-Id: <11813474492376-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.2.1
In-Reply-To: <1181347441440-git-send-email-gregkh@suse.de>
References: <20070609000312.GA17574@kroah.com>
 <11813474343815-git-send-email-gregkh@suse.de>
 <1181347441440-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <david-b@pacbell.net>

It turns out that le16_to_cpup() and le32_to_cpup() aren't always safe
to call with pointers into packed structures, since those are inlined
functions and GCC may lose the "packed" attribute.  So those references
can become unaligned kernel accesses, which are evil on some hardware.

This patch updates uses of those routines in the gadget stack.  The
references into packed structures can just use leXX_to_cpu(*x), which
in most cases is more natural.  Some other uses in RNDIS, mostly in
debug code, were wrong in the first place; those use get_unaligned().

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/usb/gadget/epautoconf.c |    2 +-
 drivers/usb/gadget/inode.c      |    8 ++++----
 drivers/usb/gadget/net2280.c    |    6 +++---
 drivers/usb/gadget/omap_udc.c   |    6 +++---
 drivers/usb/gadget/rndis.c      |   35 ++++++++++++++++++++++-------------
 5 files changed, 33 insertions(+), 24 deletions(-)

diff --git a/drivers/usb/gadget/epautoconf.c b/drivers/usb/gadget/epautoconf.c
index f28af06..6042364 100644
--- a/drivers/usb/gadget/epautoconf.c
+++ b/drivers/usb/gadget/epautoconf.c
@@ -132,7 +132,7 @@ ep_matches (
 	 * where it's an output parameter representing the full speed limit.
 	 * the usb spec fixes high speed bulk maxpacket at 512 bytes.
 	 */
-	max = 0x7ff & le16_to_cpup (&desc->wMaxPacketSize);
+	max = 0x7ff & le16_to_cpu(desc->wMaxPacketSize);
 	switch (type) {
 	case USB_ENDPOINT_XFER_INT:
 		/* INT:  limit 64 bytes full speed, 1024 high speed */
diff --git a/drivers/usb/gadget/inode.c b/drivers/usb/gadget/inode.c
index 188c74a..46d0e52 100644
--- a/drivers/usb/gadget/inode.c
+++ b/drivers/usb/gadget/inode.c
@@ -1369,12 +1369,12 @@ config_buf (struct dev_data *dev, u8 type, unsigned index)
 		hs = !hs;
 	if (hs) {
 		dev->req->buf = dev->hs_config;
-		len = le16_to_cpup (&dev->hs_config->wTotalLength);
+		len = le16_to_cpu(dev->hs_config->wTotalLength);
 	} else
 #endif
 	{
 		dev->req->buf = dev->config;
-		len = le16_to_cpup (&dev->config->wTotalLength);
+		len = le16_to_cpu(dev->config->wTotalLength);
 	}
 	((u8 *)dev->req->buf) [1] = type;
 	return len;
@@ -1885,7 +1885,7 @@ dev_config (struct file *fd, const char __user *buf, size_t len, loff_t *ptr)
 
 	/* full or low speed config */
 	dev->config = (void *) kbuf;
-	total = le16_to_cpup (&dev->config->wTotalLength);
+	total = le16_to_cpu(dev->config->wTotalLength);
 	if (!is_valid_config (dev->config) || total >= length)
 		goto fail;
 	kbuf += total;
@@ -1894,7 +1894,7 @@ dev_config (struct file *fd, const char __user *buf, size_t len, loff_t *ptr)
 	/* optional high speed config */
 	if (kbuf [1] == USB_DT_CONFIG) {
 		dev->hs_config = (void *) kbuf;
-		total = le16_to_cpup (&dev->hs_config->wTotalLength);
+		total = le16_to_cpu(dev->hs_config->wTotalLength);
 		if (!is_valid_config (dev->hs_config) || total >= length)
 			goto fail;
 		kbuf += total;
diff --git a/drivers/usb/gadget/net2280.c b/drivers/usb/gadget/net2280.c
index 52779c5..d975ecf 100644
--- a/drivers/usb/gadget/net2280.c
+++ b/drivers/usb/gadget/net2280.c
@@ -2440,9 +2440,9 @@ static void handle_stat0_irqs (struct net2280 *dev, u32 stat)
 
 		tmp = 0;
 
-#define	w_value		le16_to_cpup (&u.r.wValue)
-#define	w_index		le16_to_cpup (&u.r.wIndex)
-#define	w_length	le16_to_cpup (&u.r.wLength)
+#define	w_value		le16_to_cpu(u.r.wValue)
+#define	w_index		le16_to_cpu(u.r.wIndex)
+#define	w_length	le16_to_cpu(u.r.wLength)
 
 		/* ack the irq */
 		writel (1 << SETUP_PACKET_INTERRUPT, &dev->regs->irqstat0);
diff --git a/drivers/usb/gadget/omap_udc.c b/drivers/usb/gadget/omap_udc.c
index b394e63..c4975a6 100644
--- a/drivers/usb/gadget/omap_udc.c
+++ b/drivers/usb/gadget/omap_udc.c
@@ -1651,9 +1651,9 @@ static void ep0_irq(struct omap_udc *udc, u16 irq_src)
 			UDC_EP_NUM_REG = 0;
 		} while (UDC_IRQ_SRC_REG & UDC_SETUP);
 
-#define	w_value		le16_to_cpup (&u.r.wValue)
-#define	w_index		le16_to_cpup (&u.r.wIndex)
-#define	w_length	le16_to_cpup (&u.r.wLength)
+#define	w_value		le16_to_cpu(u.r.wValue)
+#define	w_index		le16_to_cpu(u.r.wIndex)
+#define	w_length	le16_to_cpu(u.r.wLength)
 
 		/* Delegate almost all control requests to the gadget driver,
 		 * except for a handful of ch9 status/feature requests that
diff --git a/drivers/usb/gadget/rndis.c b/drivers/usb/gadget/rndis.c
index 6ec8cf1..708657c 100644
--- a/drivers/usb/gadget/rndis.c
+++ b/drivers/usb/gadget/rndis.c
@@ -186,10 +186,14 @@ gen_ndis_query_resp (int configNr, u32 OID, u8 *buf, unsigned buf_len,
 		DEBUG("query OID %08x value, len %d:\n", OID, buf_len);
 		for (i = 0; i < buf_len; i += 16) {
 			DEBUG ("%03d: %08x %08x %08x %08x\n", i,
-				le32_to_cpup((__le32 *)&buf[i]),
-				le32_to_cpup((__le32 *)&buf[i + 4]),
-				le32_to_cpup((__le32 *)&buf[i + 8]),
-				le32_to_cpup((__le32 *)&buf[i + 12]));
+				le32_to_cpu(get_unaligned((__le32 *)
+					&buf[i])),
+				le32_to_cpu(get_unaligned((__le32 *)
+					&buf[i + 4])),
+				le32_to_cpu(get_unaligned((__le32 *)
+					&buf[i + 8])),
+				le32_to_cpu(get_unaligned((__le32 *)
+					&buf[i + 12])));
 		}
 	}
 
@@ -665,7 +669,7 @@ gen_ndis_query_resp (int configNr, u32 OID, u8 *buf, unsigned buf_len,
 		break;
 	case OID_PNP_QUERY_POWER:
 		DEBUG("%s: OID_PNP_QUERY_POWER D%d\n", __FUNCTION__,
-				le32_to_cpup((__le32 *) buf) - 1);
+				le32_to_cpu(get_unaligned((__le32 *)buf)) - 1);
 		/* only suspend is a real power state, and
 		 * it can't be entered by OID_PNP_SET_POWER...
 		 */
@@ -704,10 +708,14 @@ static int gen_ndis_set_resp (u8 configNr, u32 OID, u8 *buf, u32 buf_len,
 		DEBUG("set OID %08x value, len %d:\n", OID, buf_len);
 		for (i = 0; i < buf_len; i += 16) {
 			DEBUG ("%03d: %08x %08x %08x %08x\n", i,
-				le32_to_cpup((__le32 *)&buf[i]),
-				le32_to_cpup((__le32 *)&buf[i + 4]),
-				le32_to_cpup((__le32 *)&buf[i + 8]),
-				le32_to_cpup((__le32 *)&buf[i + 12]));
+				le32_to_cpu(get_unaligned((__le32 *)
+					&buf[i])),
+				le32_to_cpu(get_unaligned((__le32 *)
+					&buf[i + 4])),
+				le32_to_cpu(get_unaligned((__le32 *)
+					&buf[i + 8])),
+				le32_to_cpu(get_unaligned((__le32 *)
+					&buf[i + 12])));
 		}
 	}
 
@@ -721,7 +729,8 @@ static int gen_ndis_set_resp (u8 configNr, u32 OID, u8 *buf, u32 buf_len,
 		 *	PROMISCUOUS, DIRECTED,
 		 *	MULTICAST, ALL_MULTICAST, BROADCAST
 		 */
-		*params->filter = (u16) le32_to_cpup((__le32 *)buf);
+		*params->filter = (u16) le32_to_cpu(get_unaligned(
+				(__le32 *)buf));
 		DEBUG("%s: OID_GEN_CURRENT_PACKET_FILTER %08x\n",
 			__FUNCTION__, *params->filter);
 
@@ -771,7 +780,7 @@ update_linkstate:
 		 * resuming, Windows forces a reset, and then SET_POWER D0.
 		 * FIXME ... then things go batty; Windows wedges itself.
 		 */
-		i = le32_to_cpup((__force __le32 *)buf);
+		i = le32_to_cpu(get_unaligned((__le32 *)buf));
 		DEBUG("%s: OID_PNP_SET_POWER D%d\n", __FUNCTION__, i - 1);
 		switch (i) {
 		case NdisDeviceStateD0:
@@ -1058,8 +1067,8 @@ int rndis_msg_parser (u8 configNr, u8 *buf)
 		return -ENOMEM;
 
 	tmp = (__le32 *) buf;
-	MsgType   = le32_to_cpup(tmp++);
-	MsgLength = le32_to_cpup(tmp++);
+	MsgType   = le32_to_cpu(get_unaligned(tmp++));
+	MsgLength = le32_to_cpu(get_unaligned(tmp++));
 
 	if (configNr >= RNDIS_MAX_CONFIGS)
 		return -ENOTSUPP;
-- 
1.5.2.1

