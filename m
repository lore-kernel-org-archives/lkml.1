Return-Path: <linux-kernel-owner+w=401wt.eu-S1754274AbZG2ABa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754274AbZG2ABa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 20:01:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753808AbZG1Xtr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 19:49:47 -0400
Received: from kroah.org ([198.145.64.141]:35680 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753768AbZG1Xtp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 19:49:45 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jul 28 16:41:53 2009
Message-Id: <20090728234153.513464957@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 28 Jul 2009 16:40:44 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Oliver Neukum <oliver@neukum.org>
Subject: [patch 15/71] USB: fix memleak in usbfs
References: <20090728234029.868717854@mini.kroah.org>
Content-Disposition: inline; filename=usb-fix-memleak-in-usbfs.patch
In-Reply-To: <20090728234756.GA11917@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Oliver Neukum <oliver@neukum.org>

commit d794a02111cd3393da69bc7d6dd2b6074bd037cc upstream.

This patch fixes a memory leak in devio.c::processcompl

If writing to user space fails the packet must be discarded, as it
already has been removed from the queue of completed packets.

Signed-off-by: Oliver Neukum <oliver@neukum.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/core/devio.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -1230,22 +1230,22 @@ static int processcompl(struct async *as
 	if (as->userbuffer)
 		if (copy_to_user(as->userbuffer, urb->transfer_buffer,
 				 urb->transfer_buffer_length))
-			return -EFAULT;
+			goto err_out;
 	if (put_user(as->status, &userurb->status))
-		return -EFAULT;
+		goto err_out;
 	if (put_user(urb->actual_length, &userurb->actual_length))
-		return -EFAULT;
+		goto err_out;
 	if (put_user(urb->error_count, &userurb->error_count))
-		return -EFAULT;
+		goto err_out;
 
 	if (usb_endpoint_xfer_isoc(&urb->ep->desc)) {
 		for (i = 0; i < urb->number_of_packets; i++) {
 			if (put_user(urb->iso_frame_desc[i].actual_length,
 				     &userurb->iso_frame_desc[i].actual_length))
-				return -EFAULT;
+				goto err_out;
 			if (put_user(urb->iso_frame_desc[i].status,
 				     &userurb->iso_frame_desc[i].status))
-				return -EFAULT;
+				goto err_out;
 		}
 	}
 
@@ -1254,6 +1254,10 @@ static int processcompl(struct async *as
 	if (put_user(addr, (void __user * __user *)arg))
 		return -EFAULT;
 	return 0;
+
+err_out:
+	free_async(as);
+	return -EFAULT;
 }
 
 static struct async *reap_as(struct dev_state *ps)


