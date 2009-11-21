Return-Path: <linux-kernel-owner+w=401wt.eu-S1755723AbZKUPJ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755723AbZKUPJ2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 10:09:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755651AbZKUPJZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 10:09:25 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:53591 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755665AbZKUPJW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 10:09:22 -0500
Date: Sat, 21 Nov 2009 16:09:26 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: David Vrabel <david.vrabel@csr.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH] drivers/usb/wusbcore: introduce missing usb_free_urb
Message-ID: <Pine.LNX.4.64.0911211608590.26930@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Error handling code following a usb_alloc_urb should free the allocated data.

The semantic match that finds this problem is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@r exists@
local idexpression x;
statement S;
expression E;
identifier f,f1,l;
position p1,p2;
expression *ptr != NULL;
@@

x@p1 = usb_alloc_urb(...);
...
if (x == NULL) S
<... when != x
     when != if (...) { <+...x...+> }
(
x->f1 = E
|
 (x->f1 == NULL || ...)
|
 f(...,x->f1,...)
)
...>
(
 return \(0\|<+...x...+>\|ptr\);
|
 return@p2 ...;
)

@script:python@
p1 << r.p1;
p2 << r.p2;
@@

print "* file: %s alloc %s return %s" % (p1[0].file,p1[0].line,p2[0].line)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
---
 drivers/usb/wusbcore/devconnect.c   |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/wusbcore/devconnect.c b/drivers/usb/wusbcore/devconnect.c
index 4ac4300..828310c 100644
--- a/drivers/usb/wusbcore/devconnect.c
+++ b/drivers/usb/wusbcore/devconnect.c
@@ -122,7 +122,7 @@ static struct wusb_dev *wusb_dev_alloc(struct wusbhc *wusbhc)
 
 	req = kmalloc(sizeof(struct usb_ctrlrequest), GFP_KERNEL);
 	if (req == NULL)
-		goto err;
+		goto err2;
 
 	req->bRequestType = USB_DIR_OUT | USB_TYPE_STANDARD | USB_RECIP_DEVICE;
 	req->bRequest = USB_REQ_SET_DESCRIPTOR;
@@ -134,6 +134,8 @@ static struct wusb_dev *wusb_dev_alloc(struct wusbhc *wusbhc)
 	wusb_dev->set_gtk_req = req;
 
 	return wusb_dev;
+err2:
+	usb_free_urb(urb);
 err:
 	wusb_dev_free(wusb_dev);
 	return NULL;
