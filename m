Return-Path: <linux-kernel-owner+w=401wt.eu-S1755708AbZGMMYt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755708AbZGMMYt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 08:24:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755471AbZGMMYt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 08:24:49 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:42346 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755461AbZGMMYs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 08:24:48 -0400
Date: Mon, 13 Jul 2009 14:22:30 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: mmcclell@bigfoot.com, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] drivers/media/video: remove null dereference and unnecessary
 test
Message-ID: <Pine.LNX.4.64.0907131422000.6808@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

In the first part of the patch, if ov is NULL, the previous call to
mutex_lock would have failed.

In the second part of the patch, a non-NULL test is removed, since if the
value is NULL, the line before would have failed.

Near the end of this function there is an initialization of ov to NULL
after a kfree, even though no further reference to this variable is
possible.  Perhaps this is considered good style, and thus I have left it
as is.

The first problem was detected using the following semantic match
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
expression E, E1;
identifier f;
statement S1,S2,S3;
@@

* if (E == NULL)
{
  ... when != if (E == NULL) S1 else S2
      when != E = E1
* E->f
  ... when any
  return ...;
}
else S3
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/media/video/ov511.c         |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/media/video/ov511.c b/drivers/media/video/ov511.c
index 0bc2cf5..7c1f186 100644
--- a/drivers/media/video/ov511.c
+++ b/drivers/media/video/ov511.c
@@ -5914,14 +5914,12 @@ ov51x_disconnect(struct usb_interface *intf)
 
 	PDEBUG(3, "");
 
+	if (!ov)
+		return;
+
 	mutex_lock(&ov->lock);
 	usb_set_intfdata (intf, NULL);
 
-	if (!ov) {
-		mutex_unlock(&ov->lock);
-		return;
-	}
-
 	/* Free device number */
 	ov511_devused &= ~(1 << ov->nr);
 
@@ -5946,7 +5944,7 @@ ov51x_disconnect(struct usb_interface *intf)
 	ov->dev = NULL;
 
 	/* Free the memory */
-	if (ov && !ov->user) {
+	if (!ov->user) {
 		mutex_lock(&ov->cbuf_lock);
 		kfree(ov->cbuf);
 		ov->cbuf = NULL;
