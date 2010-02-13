Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757658Ab0BMSgm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 13:36:42 -0500
Received: from ppp-157-177.adsl.restena.lu ([158.64.157.177]:48439 "EHLO
	bonbons.gotdns.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754175Ab0BMSgk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 13:36:40 -0500
Date: Sat, 13 Feb 2010 19:36:09 +0100
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Jiri Kosina <jkosina@suse.cz>, Oliver Neukum <oliver@neukum.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Marcel Holtmann <marcel@holtmann.org>,
       H Hartley Sweeten <hsweeten@visionengravers.com>,
       <linux-usb@vger.kernel.org>, <linux-input@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>
Subject: Re: S2R resume crash in 2.6.33-rc7 - NULL pointer dereference in
 dev_get_drvdata() for usbhid
Message-ID: <20100213193609.3337b3f0@neptune.home>
In-Reply-To: <Pine.LNX.4.44L0.1002131238580.23844-100000@netrider.rowland.org>
References: <20100213135720.603e5f64@neptune.home>
	<Pine.LNX.4.44L0.1002131238580.23844-100000@netrider.rowland.org>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.16.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 13 February 2010 Alan Stern <stern@rowland.harvard.edu> wrote:
>
> On Sat, 13 Feb 2010, Bruno [UTF-8] Prémont wrote:
> 
> > On Mon, 08 February 2010 Alan Stern <stern@rowland.harvard.edu>
> > wrote:
> > > Clearly something is setting usbhid->intf to NULL.  But I don't
> > > see any code that would do it.  You may have to resort to putting
> > > printk() statements at various strategic places to find out where
> > > it happens. You could start with the beginnings and ends of
> > > hid_suspend, hid_resume, and hid_reset_resume.  Maybe also
> > > usbhid_disconnect(), just in case.
> > 
> > I did add a few printk()s and WARN_ON()s to get a better idea of
> > why/when usbhid->intf is NULL and it is already since probe time of
> > the second interface anounced by the USB keyboard (hid.debug=1):
> 
> ...
> 
> > This lets me guess that hid_add_device() is doing something wrong
> > here when report parsing fails... (as that one is the only one which
> > could be doing the initialization of usbhid which does work for the
> > first interface announced by my keyboard)
> 
> I don't know about doing anything wrong...  However it does appear
> that in this case the interface is registered on the HID bus but
> doesn't get bound to a driver.  Jiri will know whether or not that's
> the desired outcome.
> 
> On the other hand, I don't think there would be anything wrong with 
> moving the
> 
> 	usbhid->intf = intf;
> 	usbhid->ifnum = interface->desc.bInterfaceNumber;
> 
> lines from usbhid_start() to usbhid_probe(), just before the call to
> hid_add_device().  It should fix the bug, and those lines do belong in
> the probe routine.  Jiri, any problems with doing this?

With the below patch (which is only half of the move work) I don't
get crashes anymore. Though I wonder if other initialization steps
(like the spin_lock_init() right before setting usbhid->intf) would
need to be moved as well.

Bruno

diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
index e2997a8..690ca75 100644
--- a/drivers/hid/usbhid/hid-core.c
+++ b/drivers/hid/usbhid/hid-core.c
@@ -1154,6 +1154,8 @@ static int usbhid_probe(struct usb_interface *intf, const struct usb_device_id *
 
 	hid->driver_data = usbhid;
 	usbhid->hid = hid;
+	usbhid->intf = intf;
+	usbhid->ifnum = interface->desc.bInterfaceNumber;
 
 	ret = hid_add_device(hid);
 	if (ret) {
