Return-Path: <linux-kernel-owner+w=401wt.eu-S1762588AbXEVXxc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762588AbXEVXxc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 19:53:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757073AbXEVXxZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 19:53:25 -0400
Received: from mail.suse.de ([195.135.220.2]:34351 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756903AbXEVXxZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 19:53:25 -0400
Subject: patch usb-hub.c-loops-forever-on-resume-from-ram-due-to-bluetooth.patch added to gregkh-2.6 tree
To: lkml@rtr.ca, akpm@osdl.org, gregkh@suse.de, linux-kernel@vger.kernel.org,
       mlord@pobox.com
From: <gregkh@suse.de>
Date: Tue, 22 May 2007 16:53:14 -0700
In-Reply-To: <4648F532.4030809@rtr.ca>
Message-Id: <20070522235315.9D981E17202@imap.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

     Subject: USB: hub.c loops forever on resume from ram due to bluetooth

to my gregkh-2.6 tree.  Its filename is

     usb-hub.c-loops-forever-on-resume-from-ram-due-to-bluetooth.patch

This tree can be found at 
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/


>From lkml@rtr.ca Mon May 14 16:48:14 2007
From: Mark Lord <lkml@rtr.ca>
Date: Mon, 14 May 2007 19:48:02 -0400
Subject: USB: hub.c loops forever on resume from ram due to bluetooth
To: Greg KH <gregkh@suse.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>, marcel@holtmann.org
Message-ID: <4648F532.4030809@rtr.ca>


Okay, found it.  The root cause here was a missing CONFIG_USB_SUSPEND=y,
which means the hci_usb device never got marked as USB_STATE_SUSPENDED,
which then caused the loop to go on forever.

The system works fine now with CONFIG_USB_SUSPEND=y in the .config.

Here's the patch to prevent future lockups for this or other causes.
I no longer need it, but it does still seem a good idea.

Signed-off-by: Mark Lord <mlord@pobox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/core/hub.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -403,9 +403,10 @@ static void hub_tt_kevent (struct work_s
 	struct usb_hub		*hub =
 		container_of(work, struct usb_hub, tt.kevent);
 	unsigned long		flags;
+	int			limit = 100;
 
 	spin_lock_irqsave (&hub->tt.lock, flags);
-	while (!list_empty (&hub->tt.clear_list)) {
+	while (--limit && !list_empty (&hub->tt.clear_list)) {
 		struct list_head	*temp;
 		struct usb_tt_clear	*clear;
 		struct usb_device	*hdev = hub->hdev;


Patches currently in gregkh-2.6 which might be from lkml@rtr.ca are

usb/usb-hub.c-loops-forever-on-resume-from-ram-due-to-bluetooth.patch
