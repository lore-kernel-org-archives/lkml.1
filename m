Return-Path: <linux-kernel-owner+w=401wt.eu-S1756980AbYAZGbB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756980AbYAZGbB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 01:31:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752832AbYAZGau
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 01:30:50 -0500
Received: from wa-out-1112.google.com ([209.85.146.178]:38782 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752813AbYAZGat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 01:30:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:content-type:organization:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=igm2SStnkXZJ6A+6nCPQG1wLVhzbEFFLnWI46YfKqCnxXy8eY+y4k7WQ9AFCqz08RztUgyZ34sNAEkc3JIDNXttLXGCySqjDZTuZLUcBTVQmdcuoTWB2PjLc8o4u8Eff11l75MilT8MVab4SUv6G/cmLoXKsL8Xj/MRmhSQfhZ0=
Subject: [PATCH] Moving spinlock to struct usb_hcd
From: Romit Dasgupta <romlinux@gmail.com>
Reply-To: romlinux@gmail.com
To: greg@kroah.com, stern@rowland.harvard.edu, linux-usb@vger.kernel.org,
       dbrownell@users.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Organization: None
Date: Sat, 26 Jan 2008 12:00:41 +0530
Message-Id: <1201329041.5807.20.camel@maxwell>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
   This is an attempt to move the hcd_urb_list_lock to struct usb_hcd.
The lock is taken on functions that try to add/delete/use urb against a
given hcd. I have not seen any association of an urb with multiple hcds.
Hence I thought this can be moved within usb_hcd. This should help
reduce contention to usb during high load where i/o is happening  to
multiple hcds. I am also trying to see if hcd_root_hub_lock can also be
moved to usb_hcd. Any comments on this?  I have done some testing with
this patch and it seems to be holding fine. If this looks ok I will
submit the lock statistics before and after the change.

Thanks,
-Romit


---
 drivers/usb/core/hcd.c |   24 +++++++++++-------------
 drivers/usb/core/hcd.h |    1 +
 2 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
index d5ed3fa..6eb0f45 100644
--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -98,9 +98,6 @@ EXPORT_SYMBOL_GPL (usb_bus_list_lock);
 /* used for controlling access to virtual root hubs */
 static DEFINE_SPINLOCK(hcd_root_hub_lock);
 
-/* used when updating an endpoint's URB list */
-static DEFINE_SPINLOCK(hcd_urb_list_lock);
-
 /* wait queue for synchronous unlinks */
 DECLARE_WAIT_QUEUE_HEAD(usb_kill_urb_queue);
 
@@ -1000,7 +997,7 @@ int usb_hcd_link_urb_to_ep(struct usb_hcd *hcd,
struct urb *urb)
 {
 	int		rc = 0;
 
-	spin_lock(&hcd_urb_list_lock);
+	spin_lock(&hcd->hcd_urb_list_lock);
 
 	/* Check that the URB isn't being killed */
 	if (unlikely(urb->reject)) {
@@ -1033,7 +1030,7 @@ int usb_hcd_link_urb_to_ep(struct usb_hcd *hcd,
struct urb *urb)
 		goto done;
 	}
  done:
-	spin_unlock(&hcd_urb_list_lock);
+	spin_unlock(&hcd->hcd_urb_list_lock);
 	return rc;
 }
 EXPORT_SYMBOL_GPL(usb_hcd_link_urb_to_ep);
@@ -1106,9 +1103,9 @@ EXPORT_SYMBOL_GPL(usb_hcd_check_unlink_urb);
 void usb_hcd_unlink_urb_from_ep(struct usb_hcd *hcd, struct urb *urb)
 {
 	/* clear all state linking urb to this dev (and hcd) */
-	spin_lock(&hcd_urb_list_lock);
+	spin_lock(&hcd->hcd_urb_list_lock);
 	list_del_init(&urb->urb_list);
-	spin_unlock(&hcd_urb_list_lock);
+	spin_unlock(&hcd->hcd_urb_list_lock);
 }
 EXPORT_SYMBOL_GPL(usb_hcd_unlink_urb_from_ep);
 
@@ -1311,7 +1308,7 @@ void usb_hcd_flush_endpoint(struct usb_device
*udev,
 	hcd = bus_to_hcd(udev->bus);
 
 	/* No more submits can occur */
-	spin_lock_irq(&hcd_urb_list_lock);
+	spin_lock_irq(&hcd->hcd_urb_list_lock);
 rescan:
 	list_for_each_entry (urb, &ep->urb_list, urb_list) {
 		int	is_in;
@@ -1320,7 +1317,7 @@ rescan:
 			continue;
 		usb_get_urb (urb);
 		is_in = usb_urb_dir_in(urb);
-		spin_unlock(&hcd_urb_list_lock);
+		spin_unlock(&hcd->hcd_urb_list_lock);
 
 		/* kick hcd */
 		unlink1(hcd, urb, -ESHUTDOWN);
@@ -1345,14 +1342,14 @@ rescan:
 		usb_put_urb (urb);
 
 		/* list contents may have changed */
-		spin_lock(&hcd_urb_list_lock);
+		spin_lock(&hcd->hcd_urb_list_lock);
 		goto rescan;
 	}
-	spin_unlock_irq(&hcd_urb_list_lock);
+	spin_unlock_irq(&hcd->hcd_urb_list_lock);
 
 	/* Wait until the endpoint queue is completely empty */
 	while (!list_empty (&ep->urb_list)) {
-		spin_lock_irq(&hcd_urb_list_lock);
+		spin_lock_irq(&hcd->hcd_urb_list_lock);
 
 		/* The list may have changed while we acquired the spinlock */
 		urb = NULL;
@@ -1361,7 +1358,7 @@ rescan:
 					urb_list);
 			usb_get_urb (urb);
 		}
-		spin_unlock_irq(&hcd_urb_list_lock);
+		spin_unlock_irq(&hcd->hcd_urb_list_lock);
 
 		if (urb) {
 			usb_kill_urb (urb);
@@ -1618,6 +1615,7 @@ struct usb_hcd *usb_create_hcd (const struct
hc_driver *driver,
 		dev_dbg (dev, "hcd alloc failed\n");
 		return NULL;
 	}
+	spin_lock_init(&hcd->hcd_urb_list_lock);
 	dev_set_drvdata(dev, hcd);
 	kref_init(&hcd->kref);
 
diff --git a/drivers/usb/core/hcd.h b/drivers/usb/core/hcd.h
index 98e2419..e23ff45 100644
--- a/drivers/usb/core/hcd.h
+++ b/drivers/usb/core/hcd.h
@@ -128,6 +128,7 @@ struct usb_hcd {
 	 * input size of periodic table to an interrupt scheduler. 
 	 * (ohci 32, uhci 1024, ehci 256/512/1024).
 	 */
+	spinlock_t hcd_urb_list_lock;
 
 	/* The HC driver's private data is stored at the end of
 	 * this structure.
-- 
1.4.4.2


