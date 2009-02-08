Return-Path: <linux-kernel-owner+w=401wt.eu-S1753853AbZBHPyg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753853AbZBHPyg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 10:54:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753359AbZBHPyU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 10:54:20 -0500
Received: from viefep16-int.chello.at ([62.179.121.36]:16728 "EHLO
	viefep16-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752061AbZBHPyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 10:54:18 -0500
X-SourceIP: 77.56.78.26
From: Daniel Ritz <daniel.ritz-ml@swissonline.ch>
To: Max Weninger <max.weninger@gmail.com>
Subject: Re: SOLVED support of touchscreen reported as eGalax but is not working
Date: Sun, 8 Feb 2009 17:01:57 +0100
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Niels de Vos <niels.devos@wincor-nixdorf.com>,
       linux-usb@vger.kernel.org
References: <20090125234902.7605fd16@zork.foo.com> <200902040044.13071.daniel.ritz-ml@swissonline.ch> <20090204225942.3590b9c1@zork.foo.com>
In-Reply-To: <20090204225942.3590b9c1@zork.foo.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902081701.58602.daniel.ritz-ml@swissonline.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 February 2009 22:59:42 Max Weninger wrote:
> Hi
> 
> On Wed, 4 Feb 2009 00:44:11 +0100
> Daniel Ritz <daniel.ritz-ml@swissonline.ch> wrote:
> 
> > On Tuesday 03 February 2009 07:59:29 Andrew Morton wrote:
> > > On Sat, 31 Jan 2009 23:09:01 +0100 Max Weninger
> > > <max.weninger@gmail.com> wrote:
> > [snip]
> > > > > > After comparing the usbtouchscreen.c sources between the
> > > > > > different versions I got it working by commenting the
> > > > > > follwoing lines
> > > > > > 
> > > > > > ...
> > > > > > #ifdef CONFIG_TOUCHSCREEN_USB_EGALAX
> > > > > >         /* ignore the HID capable devices, handled by usbhid
> > > > > > */ {USB_DEVICE_HID_CLASS(0x0eef, 0x0001), .driver_info =
> > > > > > DEVTYPE_IGNORE}, {USB_DEVICE_HID_CLASS(0x0eef,
> > > > > > 0x0002), .driver_info = DEVTYPE_IGNORE}, ...
> > > > > > 
> > > > > > Now the entry in /proc/bus/input/devices is created as in the
> > > > > > older versions.
> > > > > > 
> > > > > > So it seems that usbhid is not correctly handling my type
> > > > > > of touchscreen if I understand the comment there correctly
> > > > > > 
> > > > > 
> > > > > So... how do we fix this for real?
> > > > 
> > > > Well I am really not an expert in kernel programming :-)
> > > > I found out that these lines where added based on this thread
> > > > from 2008
> > > > 
> > > > http://kerneltrap.org/mailarchive/linux-kernel/2008/6/28/2286264/thread
> > > > 
> > > > So all I can do is to provide any help in testing if needed
> > > > 
> > > 
> > > (optimistically cc'ing Daniel).
> > 
> > looks like it worked :)
> > 
> > ermm, that ignoring code...seems like i was just a little bit stupid
> > when i wrote it...
> > 
> > Max, please try the attached patch...
> 
> I patched usbtouchscreen.c in my 2.6.28.2 kernel
> 
> But if I look in /proc/bus/usb/devices
> the touchscreen is now managed from the usbhid driver
> so usbtouchscreen is again ignoring my device
> 
[...]
> So sorry no success here
> 
[...]

errm, forget the patch i sent you...it just couldn't work:
instead of the flag USB_DEVICE_ID_MATCH_INT_PROTOCOL i took
USB_DEVICE_ID_MATCH_DEV_PROTOCOL which is just wrong wrong wrong :)

fixed patch attached.

rgds
-daniel, looking for that brown paper bag

----------
[PATCH] usbtouchscreen: fix eGalax HID ignoring

Fix the eGalax/EETI HID device ignoring by adding a match for the protocol too.
This is what the marco USB_DEVICE_HID_CLASS() was supposed to do anyways.

Devices confirmed to be real HID have the class set to HID and the protocol
set to 'mouse'.  Some have HID class but protocol set to 'none'. Those are
not HID and should be driven by usbtouchscreen.

Signed-off-by: Daniel Ritz <daniel.ritz@gmx.ch>

diff --git a/drivers/input/touchscreen/usbtouchscreen.c b/drivers/input/touchscreen/usbtouchscreen.c
index 5080b26..b383625 100644
--- a/drivers/input/touchscreen/usbtouchscreen.c
+++ b/drivers/input/touchscreen/usbtouchscreen.c
@@ -118,6 +118,7 @@ enum {
 
 #define USB_DEVICE_HID_CLASS(vend, prod) \
 	.match_flags = USB_DEVICE_ID_MATCH_INT_CLASS \
+		| USB_DEVICE_ID_MATCH_INT_PROTOCOL \
 		| USB_DEVICE_ID_MATCH_DEVICE, \
 	.idVendor = (vend), \
 	.idProduct = (prod), \



