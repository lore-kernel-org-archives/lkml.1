Return-Path: <linux-kernel-owner+w=401wt.eu-S1756129AbZGHQiy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756129AbZGHQiy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 12:38:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754169AbZGHQiq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 12:38:46 -0400
Received: from mx-out.daemonmail.net ([216.104.160.38]:48864 "EHLO
	mx-out.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752712AbZGHQip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 12:38:45 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Null Pointer BUG in uhci_hcd
Date: Wed, 8 Jul 2009 11:38:36 -0500
User-Agent: KMail/1.9.9
Cc: Oliver Neukum <oliver@neukum.org>, Jiri Kosina <jkosina@suse.cz>,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
References: <Pine.LNX.4.44L0.0907071513380.8221-100000@iolanthe.rowland.org> <200907080943.47248.lkml@morethan.org> <200907081130.07370.lkml@morethan.org>
In-Reply-To: <200907081130.07370.lkml@morethan.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907081138.39211.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed July 8 2009, Michael S. Zick wrote:
> On Wed July 8 2009, Michael S. Zick wrote:
> > On Tue July 7 2009, Alan Stern wrote:
> > > On Tue, 7 Jul 2009, Michael S. Zick wrote:
> > > 
> > > > On Tue July 7 2009, Alan Stern wrote:
> > > > > On Tue, 7 Jul 2009, Michael S. Zick wrote:
> > > > > 
> > > > > > > It looks like there's a serious problem in your UHCI hardware.  
> > > > > > > According to the log you posted, it's not working at all.
> > > > > > > 
> > > > > > 
> > > > > > I am using the x86-generic drivers - -
> > > > > 
> > > > > Not a problem with the drivers, a problem in the hardware.
> > > > > 
> > > > 
> > > > Or hardware that works as the manufacturer intended, but differently
> > > > than expected.  Same difference as "broken" when compared to "standard".
> > > 
> > > No, hardware that doesn't work at all.  As in "all reads return
> > > 0xffffffff" -- that's just a guess but something like it would account
> > > for what you saw.
> > > 

I tried to combine the addition of the diagnostic print (BUG())
statements and the potential fix - -
This is what I put into the code for today's testing:

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index be86ae3..d686f1d 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -160,8 +160,10 @@ static inline char *portspeed(int portstatus)
 }

 /* Note that hdev or one of its children must be locked! */
-static inline struct usb_hub *hdev_to_hub(struct usb_device *hdev)
+static struct usb_hub *hdev_to_hub(struct usb_device *hdev)
 {
+       if (!hdev || !hdev->actconfig)
+               return NULL;
        return usb_get_intfdata(hdev->actconfig->interface[0]);
 }

@@ -369,11 +371,16 @@ static void kick_khubd(struct usb_hub *hub)
 {
        unsigned long   flags;

-       /* Suppress autosuspend until khubd runs */
-       to_usb_interface(hub->intfdev)->pm_usage_cnt = 1;
+       if (!hub) {
+               BUG();
+               return;
+       }

        spin_lock_irqsave(&hub_event_lock, flags);
        if (!hub->disconnected && list_empty(&hub->event_list)) {
+               /* Suppress autosuspend until khubd runs */
+               to_usb_interface(hub->intfdev)->pm_usage_cnt = 1;
+
                list_add_tail(&hub->event_list, &hub_event_list);
                wake_up(&khubd_wait);
        }
@@ -382,8 +389,19 @@ static void kick_khubd(struct usb_hub *hub)

 void usb_kick_khubd(struct usb_device *hdev)
 {
-       /* FIXME: What if hdev isn't bound to the hub driver? */
-       kick_khubd(hdev_to_hub(hdev));
+       struct usb_hub *hub;
+
+       if (!hdev) {
+               BUG();
+               return;
+       }
+       hub = hdev_to_hub(hdev);
+       if (hub) {
+               kick_khubd(hub);
+       } else {
+               BUG();
+               return;
+       }
 }

Mike
