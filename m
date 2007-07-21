Return-Path: <linux-kernel-owner+w=401wt.eu-S1758134AbXGUWXb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758134AbXGUWXb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 18:23:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761504AbXGUWXG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 18:23:06 -0400
Received: from hu-out-0506.google.com ([72.14.214.225]:5527 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760671AbXGUWXB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 18:23:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=tfhgH2ung03uq1zEzWq1eGAefOSObE97e5L2X8B2hsVwf+JSmXRaxcR7iqoPyhdqv1J+9DH6+K49R+cegwZpYUfIvoicYUr8SmkUoqtSK+ppQvf4ZMCO7JMC6Lkdziqh8xf2cgET/RylsnH77ykSYTYFXZN1D/EYPYst5kimmLA=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH][hid] Fix a NULL pointer dereference when we fail to allocate memory
Date: Sun, 22 Jul 2007 00:06:20 +0200
User-Agent: KMail/1.9.7
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Michael Haboustak <mike-@cinci.rr.com>, Andreas Gal <gal@uci.edu>,
       Vojtech Pavlik <vojtech@suse.cz>, Greg Kroah-Hartman <greg@kroah.com>,
       linux-input@atrey.karlin.mff.cuni.cz,
       Jesper Juhl <jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707220006.20359.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

If, in usb_hid_configure(), we fail to allocate storage for 'usbhid', 
 "if (!(usbhid = kzalloc(sizeof(struct usbhid_device), GFP_KERNEL)))", 
then we'll jump to the 'fail:' label where we have this code:
        usb_free_urb(usbhid->urbin);
        usb_free_urb(usbhid->urbout);
        usb_free_urb(usbhid->urbctrl);
Since we got here because we couldn't allocate storage for 'usbhid', 
what we have here is a NULL pointer dereference - ouch...

This patch solves that little problem by adding a new 
'fail_no_usbhid:' label after the problematic calls to 
usb_free_urb() and jumps to that one instead, in the problem case.


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

 drivers/hid/usbhid/hid-core.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
index b2baeae..3ff7468 100644
--- a/drivers/hid/usbhid/hid-core.c
+++ b/drivers/hid/usbhid/hid-core.c
@@ -743,7 +743,7 @@ static struct hid_device *usb_hid_configure(struct usb_interface *intf)
 	hid->quirks = quirks;
 
 	if (!(usbhid = kzalloc(sizeof(struct usbhid_device), GFP_KERNEL)))
-		goto fail;
+		goto fail_no_usbhid;
 
 	hid->driver_data = usbhid;
 	usbhid->hid = hid;
@@ -877,6 +877,7 @@ fail:
 	usb_free_urb(usbhid->urbin);
 	usb_free_urb(usbhid->urbout);
 	usb_free_urb(usbhid->urbctrl);
+fail_no_usbhid:
 	hid_free_buffers(dev, hid);
 	hid_free_device(hid);
 
