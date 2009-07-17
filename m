Return-Path: <linux-kernel-owner+w=401wt.eu-S933960AbZGQGB6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933960AbZGQGB6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 02:01:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757856AbZGQGB5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 02:01:57 -0400
Received: from mail-yx0-f184.google.com ([209.85.210.184]:57451 "EHLO
	mail-yx0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757854AbZGQGB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 02:01:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:cc:content-disposition:from:date:mime-version
         :content-type:content-transfer-encoding:message-id;
        b=ePorO62So6v13u9JRC3zF1wICDBmMK/zIVSNuSJdzHX5LvNDiVYICIs59GS5dHIjnK
         uf6Xnh1cVaNPoxh8KPTUxuEOT8qbtQfIPsRhit+wxyau0liUaKfr3T3NsE8AUO3YLFzc
         fkroLxifoXQkxOWk+0+fLolymOLuCPhXLk4+Y=
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] Fix for Acer  Bluetooth Optical Rechargeable Mouse
Cc: linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Disposition: inline
From: Lamarque Vieira Souza <lamarque@gmail.com>
Date: Fri, 17 Jul 2009 03:01:43 -0300
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200907170301.43807.lamarque@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	This patch works around one problem with my Acer Bluetooth Optical 
Rechargeable Mouse where the cursor gets stuck at screen's upper-left corner. 
Even my notebook's touchpad is not able to move cursor when the bluetooth 
mouse is connected to my Acer Ferrari 4005 notebook. Using input session 
instead of hid session solves this problem although the cursor still moves a 
little sluggishly with the bluetooth mouse, cursor moves correctly using the 
touchpad. My bluetooth mouse used to work well (no sluggish) until kernel 
2.6.21, since then the problems are getting worse with each kernel release (it 
got sluggish in 2.6.22 and this this upper-left corner problem appeared in 
2.6.28 or 2.6.27).

Signed-off-by: Lamarque V. Souza <lamarque@gmail.com>
---

diff -Nru --show-c-function linux-2.6.30.1-orig/net/bluetooth/hidp/core.c 
linux-2.6.30.1-lvs/net/bluetooth/hidp/core.c
--- linux-2.6.30.1-orig/net/bluetooth/hidp/core.c	2009-07-16 
23:53:04.697925121 -0300
+++ linux-2.6.30.1-lvs/net/bluetooth/hidp/core.c	2009-07-17 02:35:03.969927384 
-0300
@@ -73,6 +73,43 @@ static unsigned char hidp_keycode[256] =
 
 static unsigned char hidp_mkeyspat[] = { 0x01, 0x01, 0x01, 0x01, 0x01, 0x01 
};
 
+/* HIDP device quirks */
+enum {
+	HIDP_QUIRK_USE_INPUT_SESSION
+};
+
+struct quirk_id {
+	__u16 vendor;
+	__u16 product;
+	unsigned long quirks;
+};
+
+static const struct quirk_id hidp_quirks[] = {
+	{
+		/* Lamarque: Acer Bluetooth Optical Rechargeable Mouse
+		 * does not work properly with hid session since 2.6.27. */
+		.vendor = 0x0458,
+		.product = 0x0058,
+		.quirks = 1 << HIDP_QUIRK_USE_INPUT_SESSION
+	},
+
+	{ /* end: all zeroes */ }
+};
+
+static int quirk_test_bit(__u16 vendor, __u16 product, int quirk)
+{
+	const struct quirk_id *q = &hidp_quirks[0];
+
+	while (q->vendor != vendor && q->product != product &&
+	       q->vendor && q->product)
+		q++;
+
+	if (q->vendor == vendor && q->product == product)
+		return test_bit(quirk, &q->quirks);
+
+	return 0;
+}
+
 static struct hidp_session *__hidp_get_session(bdaddr_t *bdaddr)
 {
 	struct hidp_session *session;
@@ -832,7 +869,9 @@ int hidp_add_connection(struct hidp_conn
 	session->flags   = req->flags & (1 << HIDP_BLUETOOTH_VENDOR_ID);
 	session->idle_to = req->idle_to;
 
-	if (req->rd_size > 0) {
+	if (req->rd_size > 0 &&
+	    !quirk_test_bit(req->vendor, req->product,
+			   HIDP_QUIRK_USE_INPUT_SESSION)) {
 		err = hidp_setup_hid(session, req);
 		if (err && err != -ENODEV)
 			goto err_skb;

