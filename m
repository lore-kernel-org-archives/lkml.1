Return-Path: <linux-kernel-owner+w=401wt.eu-S1752894AbZL3Oem@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752894AbZL3Oem (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 09:34:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752832AbZL3Oel
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 09:34:41 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:44634 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751575AbZL3Oek (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 09:34:40 -0500
Date: Wed, 30 Dec 2009 15:34:37 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: gregkh@suse.de, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 4/5] drivers/usb : Correct the size argument to kzalloc
In-Reply-To: <Pine.LNX.4.64.0912292016040.4001@ask.diku.dk>
Message-ID: <Pine.LNX.4.64.0912301534070.23134@ask.diku.dk>
References: <Pine.LNX.4.64.0912292016040.4001@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

urb_priv->tds has type struct td **, not struct td *, so the
elements of the array should have pointer type, not structure type.

Convert kzalloc to kcalloc as well.

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
+	urb_priv->tds = kcalloc(size, sizeof(*urb_priv->tds), mem_flags);
 	if (!urb_priv->tds) {
 		kfree(urb_priv);
 		return -ENOMEM;
