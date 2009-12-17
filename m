Return-Path: <linux-kernel-owner+w=401wt.eu-S1763598AbZLQBUG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763598AbZLQBUG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 20:20:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763513AbZLQBTr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 20:19:47 -0500
Received: from kroah.org ([198.145.64.141]:47734 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763537AbZLQBTp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 20:19:45 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 17:15:58 2009
Message-Id: <20091217011558.080872855@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 17:14:13 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alan Stern <stern@rowland.harvard.edu>
Subject: [02/90] USB: usb-storage: fix bug in fill_inquiry
In-Reply-To: <20091217011835.GA20434@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit f3f6faa9edf67c1018270793e0547b0f81abb47e upstream.

This patch (as1312) fixes a minor bug in usb-storage.  The
fill_inquiry() routine neglects to pre-load the inquiry data buffer
with spaces.  As a result, if the vendor name is shorter than 8
characters or the product name is shorter than 16, the remainder will
be filled with garbage.

The patch also removes some unnecessary calls to strlen().

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/storage/usb.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

--- a/drivers/usb/storage/usb.c
+++ b/drivers/usb/storage/usb.c
@@ -228,6 +228,7 @@ void fill_inquiry_response(struct us_dat
 	if (data_len<36) // You lose.
 		return;
 
+	memset(data+8, ' ', 28);
 	if(data[0]&0x20) { /* USB device currently not connected. Return
 			      peripheral qualifier 001b ("...however, the
 			      physical device is not currently connected
@@ -237,15 +238,15 @@ void fill_inquiry_response(struct us_dat
 			      device, it may return zeros or ASCII spaces 
 			      (20h) in those fields until the data is
 			      available from the device."). */
-		memset(data+8,0,28);
 	} else {
 		u16 bcdDevice = le16_to_cpu(us->pusb_dev->descriptor.bcdDevice);
-		memcpy(data+8, us->unusual_dev->vendorName, 
-			strlen(us->unusual_dev->vendorName) > 8 ? 8 :
-			strlen(us->unusual_dev->vendorName));
-		memcpy(data+16, us->unusual_dev->productName, 
-			strlen(us->unusual_dev->productName) > 16 ? 16 :
-			strlen(us->unusual_dev->productName));
+		int n;
+
+		n = strlen(us->unusual_dev->vendorName);
+		memcpy(data+8, us->unusual_dev->vendorName, min(8, n));
+		n = strlen(us->unusual_dev->productName);
+		memcpy(data+16, us->unusual_dev->productName, min(16, n));
+
 		data[32] = 0x30 + ((bcdDevice>>12) & 0x0F);
 		data[33] = 0x30 + ((bcdDevice>>8) & 0x0F);
 		data[34] = 0x30 + ((bcdDevice>>4) & 0x0F);


