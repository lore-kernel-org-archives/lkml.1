Return-Path: <linux-kernel-owner+w=401wt.eu-S1761083AbYF3RV0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761083AbYF3RV0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 13:21:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762336AbYF3RVD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 13:21:03 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:44630 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1762213AbYF3RVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 13:21:00 -0400
Date: Mon, 30 Jun 2008 13:21:00 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
cc: Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: 2.6.26-rc1 regression since 2.6.25 - problem in 2.6.26-rc8 again
In-Reply-To: <20080630122626.GB4413@ics.muni.cz>
Message-ID: <Pine.LNX.4.44L0.0806301318570.2138-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jun 2008, Lukas Hejtmanek wrote:

> On Fri, Jun 27, 2008 at 04:35:59PM -0400, Alan Stern wrote:
> > Do exactly the same thing under both operating system versions, and 
> > then we should have suitably comparable logs.
> 
> all you wanted is attached including dmesgs.

Ah, good.  I see the problem now.

To tell the truth, this has been fixed in the development tree for so 
long that I had forgotten about it.  Unfortunately those fixes won't 
get into the regular kernel until 2.6.27.  Until then we need another 
fix.

The patch below should take care of the problem.  Let me know how it 
works.

Alan Stern



Index: 2.6.26-rc8/drivers/usb/core/hub.c
===================================================================
--- 2.6.26-rc8.orig/drivers/usb/core/hub.c
+++ 2.6.26-rc8/drivers/usb/core/hub.c
@@ -713,18 +713,11 @@ static void hub_restart(struct usb_hub *
 		}
 
 		/* Was the power session lost while we were suspended? */
-		switch (type) {
-		case HUB_RESET_RESUME:
-			portstatus = 0;
-			portchange = USB_PORT_STAT_C_CONNECTION;
-			break;
+		status = hub_port_status(hub, port1, &portstatus, &portchange);
 
-		case HUB_RESET:
-		case HUB_RESUME:
-			status = hub_port_status(hub, port1,
-					&portstatus, &portchange);
-			break;
-		}
+		/* If the device is gone, khubd will handle it later */
+		if (status == 0 && !(portstatus & USB_PORT_STAT_CONNECTION))
+			continue;
 
 		/* For "USB_PERSIST"-enabled children we must
 		 * mark the child device for reset-resume and

