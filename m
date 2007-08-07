Return-Path: <linux-kernel-owner+w=401wt.eu-S935265AbXHGUzj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935265AbXHGUzj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 16:55:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935458AbXHGUtK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 16:49:10 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56158 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935356AbXHGUtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 16:49:08 -0400
Date: Tue, 7 Aug 2007 13:44:42 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       linux-usb-devel@lists.sourceforge.net
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alan Stern <stern@rowland.harvard.edu>
Subject: [2.6.22.2 review 21/84] USB: fix warning caused by autosuspend
	counter going negative
Message-ID: <20070807204442.GV23028@kroah.com>
References: <20070807204034.882009319@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="usb-fix-warning-caused-by-autosuspend-counter-going-negative.patch"
In-Reply-To: <20070807204157.GA23028@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Alan Stern <stern@rowland.harvard.edu>

This patch (as937) fixes a minor bug in the autosuspend usage-counting
code.  Each hub's usage counter keeps track of the number of
unsuspended children.  However the current driver increments the
counter after registering a new child, by which time the child may
already have been suspended and caused the counter to go negative.
The obvious solution is to increment the counter before registering
the child.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/core/hub.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -1388,6 +1388,10 @@ int usb_new_device(struct usb_device *ud
 	udev->dev.devt = MKDEV(USB_DEVICE_MAJOR,
 			(((udev->bus->busnum-1) * 128) + (udev->devnum-1)));
 
+	/* Increment the parent's count of unsuspended children */
+	if (udev->parent)
+		usb_autoresume_device(udev->parent);
+
 	/* Register the device.  The device driver is responsible
 	 * for adding the device files to sysfs and for configuring
 	 * the device.
@@ -1395,13 +1399,11 @@ int usb_new_device(struct usb_device *ud
 	err = device_add(&udev->dev);
 	if (err) {
 		dev_err(&udev->dev, "can't device_add, error %d\n", err);
+		if (udev->parent)
+			usb_autosuspend_device(udev->parent);
 		goto fail;
 	}
 
-	/* Increment the parent's count of unsuspended children */
-	if (udev->parent)
-		usb_autoresume_device(udev->parent);
-
 exit:
 	return err;
 

-- 
