Return-Path: <linux-kernel-owner+w=401wt.eu-S934425AbYEUMKA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934425AbYEUMKA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 08:10:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933858AbYEUMJq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 08:09:46 -0400
Received: from styx.suse.cz ([82.119.242.94]:37663 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760920AbYEUMJp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 08:09:45 -0400
Date: Wed, 21 May 2008 14:09:43 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Greg KH <greg@kroah.com>, linux-usb@vger.kernel.org
cc: Oliver Neukum <oneukum@suse.de>, Alan Stern <stern@rowland.harvard.edu>,
       lchiquitto@novell.com, linux-kernel@vger.kernel.org
Subject: [PATCH] USB: fix deadlock in HCD code
Message-ID: <Pine.LNX.4.64.0805211405520.6718@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hcd_urb_list_lock is used for synchronization between IRQ and non-IRQ 
contexts, so the non-IRQ context has to disable IRQs in order to prevent 
deadlocking with IRQ context.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>

 drivers/usb/core/hcd.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
index bf10e9c..19279ed 100644
--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -1000,8 +1000,9 @@ EXPORT_SYMBOL_GPL(usb_calc_bus_time);
 int usb_hcd_link_urb_to_ep(struct usb_hcd *hcd, struct urb *urb)
 {
 	int		rc = 0;
+	unsigned long flags;
 
-	spin_lock(&hcd_urb_list_lock);
+	spin_lock_irqsave(&hcd_urb_list_lock, flags);
 
 	/* Check that the URB isn't being killed */
 	if (unlikely(urb->reject)) {
@@ -1034,7 +1035,7 @@ int usb_hcd_link_urb_to_ep(struct usb_hcd *hcd, struct urb *urb)
 		goto done;
 	}
  done:
-	spin_unlock(&hcd_urb_list_lock);
+	spin_unlock_irqrestore(&hcd_urb_list_lock, flags);
 	return rc;
 }
 EXPORT_SYMBOL_GPL(usb_hcd_link_urb_to_ep);
@@ -1106,10 +1107,11 @@ EXPORT_SYMBOL_GPL(usb_hcd_check_unlink_urb);
  */
 void usb_hcd_unlink_urb_from_ep(struct usb_hcd *hcd, struct urb *urb)
 {
+	unsigned long flags;
 	/* clear all state linking urb to this dev (and hcd) */
-	spin_lock(&hcd_urb_list_lock);
+	spin_lock_irqsave(&hcd_urb_list_lock, flags);
 	list_del_init(&urb->urb_list);
-	spin_unlock(&hcd_urb_list_lock);
+	spin_unlock_irqrestore(&hcd_urb_list_lock, flags);
 }
 EXPORT_SYMBOL_GPL(usb_hcd_unlink_urb_from_ep);

