Return-Path: <linux-kernel-owner+w=401wt.eu-S1756253AbZG2ACK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756253AbZG2ACK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 20:02:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753684AbZG1Xtm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 19:49:42 -0400
Received: from kroah.org ([198.145.64.141]:35661 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753476AbZG1Xtk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 19:49:40 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jul 28 16:41:52 2009
Message-Id: <20090728234152.727079680@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 28 Jul 2009 16:40:39 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alan Stern <stern@rowland.harvard.edu>
Subject: [patch 10/71] USB: handle zero-length usbfs submissions correctly
References: <20090728234029.868717854@mini.kroah.org>
Content-Disposition: inline; filename=usb-handle-zero-length-usbfs-submissions-correctly.patch
In-Reply-To: <20090728234756.GA11917@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit 9180135bc80ab11199d482b6111e23f74d65af4a upstream.

This patch (as1262) fixes a bug in usbfs: It refuses to accept
zero-length transfers, and it insists that the buffer pointer be valid
even if there is no data being transferred.

The patch also consolidates a bunch of repetitive access_ok() checks
into a single check, which incidentally fixes the lack of such a check
for Isochronous URBs.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/core/devio.c |   41 ++++++++++++++++++++---------------------
 1 file changed, 20 insertions(+), 21 deletions(-)

--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -982,7 +982,7 @@ static int proc_do_submiturb(struct dev_
 				USBDEVFS_URB_ZERO_PACKET |
 				USBDEVFS_URB_NO_INTERRUPT))
 		return -EINVAL;
-	if (!uurb->buffer)
+	if (uurb->buffer_length > 0 && !uurb->buffer)
 		return -EINVAL;
 	if (!(uurb->type == USBDEVFS_URB_TYPE_CONTROL &&
 	    (uurb->endpoint & ~USB_ENDPOINT_DIR_MASK) == 0)) {
@@ -1038,11 +1038,6 @@ static int proc_do_submiturb(struct dev_
 			is_in = 0;
 			uurb->endpoint &= ~USB_DIR_IN;
 		}
-		if (!access_ok(is_in ? VERIFY_WRITE : VERIFY_READ,
-				uurb->buffer, uurb->buffer_length)) {
-			kfree(dr);
-			return -EFAULT;
-		}
 		snoop(&ps->dev->dev, "control urb: bRequest=%02x "
 			"bRrequestType=%02x wValue=%04x "
 			"wIndex=%04x wLength=%04x\n",
@@ -1062,9 +1057,6 @@ static int proc_do_submiturb(struct dev_
 		uurb->number_of_packets = 0;
 		if (uurb->buffer_length > MAX_USBFS_BUFFER_SIZE)
 			return -EINVAL;
-		if (!access_ok(is_in ? VERIFY_WRITE : VERIFY_READ,
-				uurb->buffer, uurb->buffer_length))
-			return -EFAULT;
 		snoop(&ps->dev->dev, "bulk urb\n");
 		break;
 
@@ -1106,28 +1098,35 @@ static int proc_do_submiturb(struct dev_
 			return -EINVAL;
 		if (uurb->buffer_length > MAX_USBFS_BUFFER_SIZE)
 			return -EINVAL;
-		if (!access_ok(is_in ? VERIFY_WRITE : VERIFY_READ,
-				uurb->buffer, uurb->buffer_length))
-			return -EFAULT;
 		snoop(&ps->dev->dev, "interrupt urb\n");
 		break;
 
 	default:
 		return -EINVAL;
 	}
-	as = alloc_async(uurb->number_of_packets);
-	if (!as) {
+	if (uurb->buffer_length > 0 &&
+			!access_ok(is_in ? VERIFY_WRITE : VERIFY_READ,
+				uurb->buffer, uurb->buffer_length)) {
 		kfree(isopkt);
 		kfree(dr);
-		return -ENOMEM;
+		return -EFAULT;
 	}
-	as->urb->transfer_buffer = kmalloc(uurb->buffer_length, GFP_KERNEL);
-	if (!as->urb->transfer_buffer) {
+	as = alloc_async(uurb->number_of_packets);
+	if (!as) {
 		kfree(isopkt);
 		kfree(dr);
-		free_async(as);
 		return -ENOMEM;
 	}
+	if (uurb->buffer_length > 0) {
+		as->urb->transfer_buffer = kmalloc(uurb->buffer_length,
+				GFP_KERNEL);
+		if (!as->urb->transfer_buffer) {
+			kfree(isopkt);
+			kfree(dr);
+			free_async(as);
+			return -ENOMEM;
+		}
+	}
 	as->urb->dev = ps->dev;
 	as->urb->pipe = (uurb->type << 30) |
 			__create_pipe(ps->dev, uurb->endpoint & 0xf) |
@@ -1169,7 +1168,7 @@ static int proc_do_submiturb(struct dev_
 	kfree(isopkt);
 	as->ps = ps;
 	as->userurb = arg;
-	if (uurb->endpoint & USB_DIR_IN)
+	if (is_in && uurb->buffer_length > 0)
 		as->userbuffer = uurb->buffer;
 	else
 		as->userbuffer = NULL;
@@ -1179,9 +1178,9 @@ static int proc_do_submiturb(struct dev_
 	as->uid = cred->uid;
 	as->euid = cred->euid;
 	security_task_getsecid(current, &as->secid);
-	if (!is_in) {
+	if (!is_in && uurb->buffer_length > 0) {
 		if (copy_from_user(as->urb->transfer_buffer, uurb->buffer,
-				as->urb->transfer_buffer_length)) {
+				uurb->buffer_length)) {
 			free_async(as);
 			return -EFAULT;
 		}


