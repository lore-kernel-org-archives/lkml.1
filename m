Return-Path: <linux-kernel-owner+w=401wt.eu-S1761698AbZCTXiO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761698AbZCTXiO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 19:38:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762316AbZCTXYx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 19:24:53 -0400
Received: from kroah.org ([198.145.64.141]:48781 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1763018AbZCTXYv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 19:24:51 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 20 15:29:28 2009
Message-Id: <20090320222928.261453123@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 20 Mar 2009 15:28:44 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Alan Stern <stern@rowland.harvard.edu>
Subject: [patch 34/43] USB: usbfs: keep async URBs until the device file is closed
References: <20090320222810.386844059@mini.kroah.org>
Content-Disposition: inline; filename=usb-usbfs-keep-async-urbs-until-the-device-file-is-closed.patch
In-Reply-To: <20090320232116.GA3375@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit 6ff10464096540e14d7575a72c50d0316d003714 upstream.

The usbfs driver manages a list of completed asynchronous URBs.  But
it is too eager to free the entries on this list: destroy_async() gets
called whenever an interface is unbound or a device is removed, and it
deallocates the outstanding struct async entries for all URBs on that
interface or device.  This is wrong; the user program should be able
to reap an URB any time after it has completed, regardless of whether
or not the interface is still bound or the device is still present.

This patch (as1222) moves the code for deallocating the completed list
entries from destroy_async() to usbdev_release().  The outstanding
entries won't be freed until the user program has closed the device
file, thereby eliminating any possibility that the remaining URBs
might still be reaped.

This fixes a bug in which a program can hang in the USBDEVFS_REAPURB
ioctl when the device is unplugged.

Reported-and-tested-by: Martin Poupe <martin.poupe@upek.com>
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/core/devio.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -359,11 +359,6 @@ static void destroy_async(struct dev_sta
 		spin_lock_irqsave(&ps->lock, flags);
 	}
 	spin_unlock_irqrestore(&ps->lock, flags);
-	as = async_getcompleted(ps);
-	while (as) {
-		free_async(as);
-		as = async_getcompleted(ps);
-	}
 }
 
 static void destroy_async_on_interface(struct dev_state *ps,
@@ -642,6 +637,7 @@ static int usbdev_release(struct inode *
 	struct dev_state *ps = file->private_data;
 	struct usb_device *dev = ps->dev;
 	unsigned int ifnum;
+	struct async *as;
 
 	usb_lock_device(dev);
 
@@ -660,6 +656,12 @@ static int usbdev_release(struct inode *
 	usb_unlock_device(dev);
 	usb_put_dev(dev);
 	put_pid(ps->disc_pid);
+
+	as = async_getcompleted(ps);
+	while (as) {
+		free_async(as);
+		as = async_getcompleted(ps);
+	}
 	kfree(ps);
 	return 0;
 }


