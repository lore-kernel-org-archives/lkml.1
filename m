Return-Path: <linux-kernel-owner+w=401wt.eu-S1756637AbYE2NFr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756637AbYE2NFr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 09:05:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756903AbYE2NFX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 09:05:23 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:47640 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755732AbYE2NFV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 09:05:21 -0400
Date: Thu, 29 May 2008 15:05:07 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: dmitry.torokhov@gmail.com, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 2/2] Eliminate double kfree
Message-ID: <Pine.LNX.4.64.0805291504400.26229@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The variable report is only non-NULL and non-freed in a small region of
code, so it should only be freed in error handling code that comes from
that region.

This was found using the following semantic match.
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@r1@
expression E;
position p1,p2;
@@

kfree@p1(E);
...
kfree@p2(E);

@subexps@
expression E1;
position r1.p1,p;
@@

kfree@p1(<+... E1@p ...+>);

@recollect@
position subexps.p;
expression E1;
@@

E1@p

@doublekfree@
position r1.p1,r1.p2;
expression recollect.E1,E2,E;
position p;
statement S;
@@

kfree@p1(E);
<+... E1@p=E2 ...+> // the actual semantic match contains other assignments
kfree@p2(E);

@notdoublekfree@
position r1.p1,r1.p2;
position any doublekfree.p;
expression E,E1,E2;
@@

* kfree@p1(E);
... when != E1@p
    when != E1@p = E2 // needed to match a variable decl
* kfree@p2(E);
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
---

diff -u -p a/drivers/input/tablet/gtco.c b/drivers/input/tablet/gtco.c
--- a/drivers/input/tablet/gtco.c	2008-05-09 16:46:57.000000000 +0200
+++ b/drivers/input/tablet/gtco.c	2008-05-29 14:12:31.000000000 +0200
@@ -926,7 +926,7 @@ static int gtco_probe(struct usb_interfa
 		err("Failed to get HID Report Descriptor of size: %d",
 		    hid_desc->wDescriptorLength);
 		error = -EIO;
-		goto err_free_urb;
+		goto err_free_report;
 	}
 
 	/* Now we parse the report */
@@ -982,13 +982,14 @@ static int gtco_probe(struct usb_interfa
 
 	return 0;
 
+ err_free_report:
+	kfree(report);
  err_free_urb:
 	usb_free_urb(gtco->urbinfo);
  err_free_buf:
 	usb_buffer_free(gtco->usbdev, REPORT_MAX_SIZE,
 			gtco->buffer, gtco->buf_dma);
  err_free_devs:
-	kfree(report);
 	input_free_device(input_dev);
 	kfree(gtco);
 	return error;
