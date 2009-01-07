Return-Path: <linux-kernel-owner+w=401wt.eu-S1755923AbZAGM0B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755923AbZAGM0B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 07:26:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755154AbZAGMZi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 07:25:38 -0500
Received: from styx.suse.cz ([82.119.242.94]:51523 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754911AbZAGMZh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 07:25:37 -0500
Date: Wed, 7 Jan 2009 13:25:36 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Oliver Neukum <oliver@neukum.org>
cc: Gabriel C <nix.or.die@googlemail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT] HID updates for 2.6.29
In-Reply-To: <200901071230.45993.oliver@neukum.org>
Message-ID: <alpine.LNX.1.10.0901071242160.5377@jikos.suse.cz>
References: <alpine.LNX.1.10.0901040115060.5377@jikos.suse.cz> <4963EE3C.3070106@googlemail.com> <alpine.LNX.1.10.0901071049400.5377@jikos.suse.cz> <200901071230.45993.oliver@neukum.org>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Jan 2009, Oliver Neukum wrote:

> > --- a/drivers/hid/usbhid/hiddev.c
> > +++ b/drivers/hid/usbhid/hiddev.c
> > @@ -885,6 +885,7 @@ int hiddev_connect(struct hid_device *hid, unsigned int force)
> >  	} else {
> >  		hid->minor = usbhid->intf->minor;
> >  		hiddev_table[usbhid->intf->minor - HIDDEV_MINOR_BASE] = hiddev;
> > +		hid->hiddev = hiddev;
> 
> It seems to me that this is still a race condition. What prevents open()
> from being called before this is set?

Right, there indeed is a tiny race window. Gabriel, could you please 
verify with the patch below instead? Thanks.


From: Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH] HID: fix hid->hiddev initialization in hiddev_connect()

Commit 079034073fa ("HID: hiddev cleanup -- handle all error conditions
properly") by mistake removed proper initialization of hid->hiddev pointer
in hiddev_connect() in case usb_register_dev() succeeds for the hiddev node.
Put it properly back in place.

Reported-by: Gabriel C <nix.or.die@googlemail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---
 drivers/hid/usbhid/hiddev.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/hid/usbhid/hiddev.c b/drivers/hid/usbhid/hiddev.c
index 6a98f9f..d73eea3 100644
--- a/drivers/hid/usbhid/hiddev.c
+++ b/drivers/hid/usbhid/hiddev.c
@@ -874,12 +874,14 @@ int hiddev_connect(struct hid_device *hid, unsigned int force)
 	INIT_LIST_HEAD(&hiddev->list);
 	spin_lock_init(&hiddev->list_lock);
 	mutex_init(&hiddev->existancelock);
+	hid->hiddev = hiddev;
 	hiddev->hid = hid;
 	hiddev->exist = 1;
 
 	retval = usb_register_dev(usbhid->intf, &hiddev_class);
 	if (retval) {
 		err_hid("Not able to get a minor for this device.");
+		hid->hiddev = NULL;
 		kfree(hiddev);
 		return -1;
 	} else {
-- 
1.5.6

