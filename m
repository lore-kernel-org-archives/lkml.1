Return-Path: <linux-kernel-owner+w=401wt.eu-S1755128AbZGGPKn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755128AbZGGPKn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 11:10:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754162AbZGGPKf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 11:10:35 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:37641 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753811AbZGGPKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 11:10:34 -0400
Date: Tue, 7 Jul 2009 11:10:33 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Oliver Neukum <oliver@neukum.org>
cc: Jiri Kosina <jkosina@suse.cz>, "Michael S. Zick" <lkml@morethan.org>,
       <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: Re: Null Pointer BUG in uhci_hcd
In-Reply-To: <200907071608.11050.oliver@neukum.org>
Message-ID: <Pine.LNX.4.44L0.0907071105561.4175-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Jul 2009, Oliver Neukum wrote:

> Am Dienstag, 7. Juli 2009 11:13:01 schrieb Jiri Kosina:
> > [ adding linux-usb to CC ]
> >
> > On Sun, 5 Jul 2009, Michael S. Zick wrote:
> > > Anyone with suggestions about this one?
> 
> Looks like we should test for presence before we switch off
> autosuspend for khubd. Please test this diagnostic patch if this is
> repeatable.

That patch won't fix the problem.  This issue is not that hdev is NULL; 
the problem is that the hub driver isn't bound to hdev and as a result, 
the hdev_to_hub routine fails.

This patch may work better.

Alan Stern


Index: usb-2.6/drivers/usb/core/hub.c
===================================================================
--- usb-2.6.orig/drivers/usb/core/hub.c
+++ usb-2.6/drivers/usb/core/hub.c
@@ -163,8 +163,10 @@ static inline char *portspeed(int portst
 }
 
 /* Note that hdev or one of its children must be locked! */
-static inline struct usb_hub *hdev_to_hub(struct usb_device *hdev)
+static struct usb_hub *hdev_to_hub(struct usb_device *hdev)
 {
+	if (!hdev || !hdev->actconfig)
+		return NULL;
 	return usb_get_intfdata(hdev->actconfig->interface[0]);
 }
 
@@ -385,8 +387,10 @@ static void kick_khubd(struct usb_hub *h
 
 void usb_kick_khubd(struct usb_device *hdev)
 {
-	/* FIXME: What if hdev isn't bound to the hub driver? */
-	kick_khubd(hdev_to_hub(hdev));
+	struct usb_hub *hub = hdev_to_hub(hdev);
+
+	if (hub)
+		kick_khubd(hub);
 }
 
 

