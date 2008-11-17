Return-Path: <linux-kernel-owner+w=401wt.eu-S1758221AbYKQHfQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758221AbYKQHfQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 02:35:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756021AbYKQHVn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 02:21:43 -0500
Received: from kroah.org ([198.145.64.141]:38725 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752546AbYKQHVk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 02:21:40 -0500
Date: Sun, 16 Nov 2008 23:17:02 -0800
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
       alan@lxorguk.ukuu.org.uk, Alan Stern <stern@rowland.harvard.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 41/46] USB: dont register endpoints for interfaces that are
	going away
Message-ID: <20081117071702.GP29522@kroah.com>
References: <20081117070621.430169021@blue.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="usb-don-t-register-endpoints-for-interfaces-that-are-going-away.patch"
In-Reply-To: <20081117071333.GA29522@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit 352d026338378b1f13f044e33c1047da6e470056 upstream.

This patch (as1155) fixes a bug in usbcore.  When interfaces are
deleted, either because the device was disconnected or because of a
configuration change, the extra attribute files and child endpoint
devices may get left behind.  This is because the core removes them
before calling device_del().  But during device_del(), after the
driver is unbound the core will reinstall altsetting 0 and recreate
those extra attributes and children.

The patch prevents this by adding a flag to record when the interface
is in the midst of being unregistered.  When the flag is set, the
attribute files and child devices will not be created.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/core/message.c |    1 +
 drivers/usb/core/sysfs.c   |    2 +-
 include/linux/usb.h        |    2 ++
 3 files changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/usb/core/message.c
+++ b/drivers/usb/core/message.c
@@ -1091,6 +1091,7 @@ void usb_disable_device(struct usb_devic
 				continue;
 			dev_dbg(&dev->dev, "unregistering interface %s\n",
 				dev_name(&interface->dev));
+			interface->unregistering = 1;
 			usb_remove_sysfs_intf_files(interface);
 			device_del(&interface->dev);
 		}
--- a/drivers/usb/core/sysfs.c
+++ b/drivers/usb/core/sysfs.c
@@ -816,7 +816,7 @@ int usb_create_sysfs_intf_files(struct u
 	struct usb_host_interface *alt = intf->cur_altsetting;
 	int retval;
 
-	if (intf->sysfs_files_created)
+	if (intf->sysfs_files_created || intf->unregistering)
 		return 0;
 
 	/* The interface string may be present in some altsettings
--- a/include/linux/usb.h
+++ b/include/linux/usb.h
@@ -108,6 +108,7 @@ enum usb_interface_condition {
  *	(in probe()), bound to a driver, or unbinding (in disconnect())
  * @is_active: flag set when the interface is bound and not suspended.
  * @sysfs_files_created: sysfs attributes exist
+ * @unregistering: flag set when the interface is being unregistered
  * @needs_remote_wakeup: flag set when the driver requires remote-wakeup
  *	capability during autosuspend.
  * @needs_altsetting0: flag set when a set-interface request for altsetting 0
@@ -163,6 +164,7 @@ struct usb_interface {
 	enum usb_interface_condition condition;		/* state of binding */
 	unsigned is_active:1;		/* the interface is not suspended */
 	unsigned sysfs_files_created:1;	/* the sysfs attributes exist */
+	unsigned unregistering:1;	/* unregistration is in progress */
 	unsigned needs_remote_wakeup:1;	/* driver requires remote wakeup */
 	unsigned needs_altsetting0:1;	/* switch to altsetting 0 is pending */
 	unsigned needs_binding:1;	/* needs delayed unbind/rebind */

-- 
