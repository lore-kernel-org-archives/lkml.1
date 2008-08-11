Return-Path: <linux-kernel-owner+w=401wt.eu-S1755190AbYHKAXw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755190AbYHKAXw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 20:23:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752703AbYHKAXo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 20:23:44 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:57557 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918AbYHKAXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 20:23:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=rPyQ9u1xz7ho9xZXQM0InHryv4BssrBPII5E7oJYYaZNqvVmtBA3xSv6KP5pAS6Qhd
         eEf7o5syruspQZcv0KWKe+lqyrXgZL9TnRGmThXBawjSt85jGH5oFmurpPx+0MwDYbbj
         f2oI8NRNPM9RB0tM+QMJ8SrcSw9TNlivGalYc=
Subject: [PATCH 1/2] mISDN: endian annotations for struct zt
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Karsten Keil <kkeil@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 10 Aug 2008 17:23:47 -0700
Message-Id: <1218414227.24441.28.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Found two possible bugs where the z1 value was used directly without
byteswapping.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/isdn/hardware/mISDN/hfc_pci.h |    4 ++--
 drivers/isdn/hardware/mISDN/hfcpci.c  |    9 ++++-----
 2 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/isdn/hardware/mISDN/hfc_pci.h b/drivers/isdn/hardware/mISDN/hfc_pci.h
index fd2c9be..5783d22 100644
--- a/drivers/isdn/hardware/mISDN/hfc_pci.h
+++ b/drivers/isdn/hardware/mISDN/hfc_pci.h
@@ -183,8 +183,8 @@
 #define D_FREG_MASK  0xF
 
 struct zt {
-	unsigned short z1;  /* Z1 pointer 16 Bit */
-	unsigned short z2;  /* Z2 pointer 16 Bit */
+	__le16 z1;  /* Z1 pointer 16 Bit */
+	__le16 z2;  /* Z2 pointer 16 Bit */
 };
 
 struct dfifo {
diff --git a/drivers/isdn/hardware/mISDN/hfcpci.c b/drivers/isdn/hardware/mISDN/hfcpci.c
index 9cf5edb..9f808ec 100644
--- a/drivers/isdn/hardware/mISDN/hfcpci.c
+++ b/drivers/isdn/hardware/mISDN/hfcpci.c
@@ -366,8 +366,7 @@ static void hfcpci_clear_fifo_tx(struct hfc_pci *hc, int fifo)
 	bzt->f2 = MAX_B_FRAMES;
 	bzt->f1 = bzt->f2;	/* init F pointers to remain constant */
 	bzt->za[MAX_B_FRAMES].z1 = cpu_to_le16(B_FIFO_SIZE + B_SUB_VAL - 1);
-	bzt->za[MAX_B_FRAMES].z2 = cpu_to_le16(
-	    le16_to_cpu(bzt->za[MAX_B_FRAMES].z1 - 1));
+	bzt->za[MAX_B_FRAMES].z2 = cpu_to_le16(B_FIFO_SIZE + B_SUB_VAL - 2);
 	if (fifo_state)
 		hc->hw.fifo_en |= fifo_state;
 	Write_hfc(hc, HFCPCI_FIFO_EN, hc->hw.fifo_en);
@@ -482,7 +481,7 @@ receive_dmsg(struct hfc_pci *hc)
 			df->f2 = ((df->f2 + 1) & MAX_D_FRAMES) |
 			    (MAX_D_FRAMES + 1);	/* next buffer */
 			df->za[df->f2 & D_FREG_MASK].z2 =
-			    cpu_to_le16((zp->z2 + rcnt) & (D_FIFO_SIZE - 1));
+			    cpu_to_le16((le16_to_cpu(zp->z2) + rcnt) & (D_FIFO_SIZE - 1));
 		} else {
 			dch->rx_skb = mI_alloc_skb(rcnt - 3, GFP_ATOMIC);
 			if (!dch->rx_skb) {
@@ -526,7 +525,7 @@ receive_dmsg(struct hfc_pci *hc)
 int
 hfcpci_empty_fifo_trans(struct bchannel *bch, struct bzfifo *bz, u_char *bdata)
 {
-	unsigned short	*z1r, *z2r;
+	 __le16 *z1r, *z2r;
 	int		new_z2, fcnt, maxlen;
 	u_char		*ptr, *ptr1;
 
@@ -724,7 +723,7 @@ hfcpci_fill_fifo(struct bchannel *bch)
 	struct bzfifo	*bz;
 	u_char		*bdata;
 	u_char		new_f1, *src, *dst;
-	unsigned short	*z1t, *z2t;
+	__le16 *z1t, *z2t;
 
 	if ((bch->debug & DEBUG_HW_BCHANNEL) && !(bch->debug & DEBUG_HW_BFIFO))
 		printk(KERN_DEBUG "%s\n", __func__);
-- 
1.6.0.rc1.278.g9c632


