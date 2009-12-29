Return-Path: <linux-kernel-owner+w=401wt.eu-S1752590AbZL2TQb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752590AbZL2TQb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 14:16:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752565AbZL2TQ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 14:16:28 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:59614 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752481AbZL2TQY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 14:16:24 -0500
Date: Tue, 29 Dec 2009 20:16:22 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: gregkh@suse.de, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 4/5] drivers/usb : Correct the size argument to kzalloc
Message-ID: <Pine.LNX.4.64.0912292016040.4001@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

urb_priv->tds has type struct td **, not struct td *, so the
elements of the array should have pointer type, not structure type.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@disable sizeof_type_expr@
type T;
T **x;
@@

  x =
  <+...sizeof(
- T
+ *x
  )...+>
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/usb/host/fhci-hcd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -u -p a/drivers/usb/host/fhci-hcd.c b/drivers/usb/host/fhci-hcd.c
--- a/drivers/usb/host/fhci-hcd.c
+++ b/drivers/usb/host/fhci-hcd.c
@@ -432,7 +432,7 @@ static int fhci_urb_enqueue(struct usb_h
 		return -ENOMEM;
 
 	/* allocate the private part of the URB */
-	urb_priv->tds = kzalloc(size * sizeof(struct td), mem_flags);
+	urb_priv->tds = kzalloc(size * sizeof(*urb_priv->tds), mem_flags);
 	if (!urb_priv->tds) {
 		kfree(urb_priv);
 		return -ENOMEM;
