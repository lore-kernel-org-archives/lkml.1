Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370Ab0BSRFe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 12:05:34 -0500
Received: from kroah.org ([198.145.64.141]:57794 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755035Ab0BSRBJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 12:01:09 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Feb 19 08:32:52 2010
Message-Id: <20100219163252.635581600@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 19 Feb 2010 08:30:12 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alan Stern <stern@rowland.harvard.edu>
Subject: [79/93] USB: usbfs: only copy the actual data received
In-Reply-To: <20100219165717.GA15002@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Greg KH <greg@kroah.com>

commit d4a4683ca054ed9917dfc9e3ff0f7ecf74ad90d6 upstream.

We need to only copy the data received by the device to userspace, not
the whole kernel buffer, which can contain "stale" data.

Thanks to Marcus Meissner for pointing this out and testing the fix.

Reported-by: Marcus Meissner <meissner@suse.de>
Tested-by: Marcus Meissner <meissner@suse.de>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/core/devio.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -1312,9 +1312,9 @@ static int processcompl(struct async *as
 	void __user *addr = as->userurb;
 	unsigned int i;
 
-	if (as->userbuffer)
+	if (as->userbuffer && urb->actual_length)
 		if (copy_to_user(as->userbuffer, urb->transfer_buffer,
-				 urb->transfer_buffer_length))
+				 urb->actual_length))
 			goto err_out;
 	if (put_user(as->status, &userurb->status))
 		goto err_out;
@@ -1435,9 +1435,9 @@ static int processcompl_compat(struct as
 	void __user *addr = as->userurb;
 	unsigned int i;
 
-	if (as->userbuffer)
+	if (as->userbuffer && urb->actual_length)
 		if (copy_to_user(as->userbuffer, urb->transfer_buffer,
-				 urb->transfer_buffer_length))
+				 urb->actual_length))
 			return -EFAULT;
 	if (put_user(as->status, &userurb->status))
 		return -EFAULT;


