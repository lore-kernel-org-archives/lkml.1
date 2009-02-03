Return-Path: <linux-kernel-owner+w=401wt.eu-S1753080AbZBCXzo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753080AbZBCXzo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 18:55:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751274AbZBCXze
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 18:55:34 -0500
Received: from viefep21-int.chello.at ([62.179.121.41]:60276 "EHLO
	viefep21-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025AbZBCXze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 18:55:34 -0500
X-Greylist: delayed 1137 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Feb 2009 18:55:32 EST
X-SourceIP: 77.56.78.26
From: Daniel Ritz <daniel.ritz-ml@swissonline.ch>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: SOLVED support of touchscreen reported as eGalax but is not working
Date: Wed, 4 Feb 2009 00:44:11 +0100
User-Agent: KMail/1.9.6
Cc: Max Weninger <max.weninger@gmail.com>, linux-kernel@vger.kernel.org,
       Niels de Vos <niels.devos@wincor-nixdorf.com>,
       linux-usb@vger.kernel.org
References: <20090125234902.7605fd16@zork.foo.com> <20090131230901.13e2058e@vostro.foo.com> <20090202225929.e10dc57b.akpm@linux-foundation.org>
In-Reply-To: <20090202225929.e10dc57b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902040044.13071.daniel.ritz-ml@swissonline.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 03 February 2009 07:59:29 Andrew Morton wrote:
> On Sat, 31 Jan 2009 23:09:01 +0100 Max Weninger <max.weninger@gmail.com> wrote:
[snip]
> > > > After comparing the usbtouchscreen.c sources between the different
> > > > versions I got it working by commenting the follwoing lines
> > > > 
> > > > ...
> > > > #ifdef CONFIG_TOUCHSCREEN_USB_EGALAX
> > > >         /* ignore the HID capable devices, handled by usbhid */
> > > >         {USB_DEVICE_HID_CLASS(0x0eef, 0x0001), .driver_info =
> > > > DEVTYPE_IGNORE}, {USB_DEVICE_HID_CLASS(0x0eef,
> > > > 0x0002), .driver_info = DEVTYPE_IGNORE}, ...
> > > > 
> > > > Now the entry in /proc/bus/input/devices is created as in the
> > > > older versions.
> > > > 
> > > > So it seems that usbhid is not correctly handling my type
> > > > of touchscreen if I understand the comment there correctly
> > > > 
> > > 
> > > So... how do we fix this for real?
> > 
> > Well I am really not an expert in kernel programming :-)
> > I found out that these lines where added based on this thread from 2008
> > 
> > http://kerneltrap.org/mailarchive/linux-kernel/2008/6/28/2286264/thread
> > 
> > So all I can do is to provide any help in testing if needed
> > 
> 
> (optimistically cc'ing Daniel).

looks like it worked :)

ermm, that ignoring code...seems like i was just a little bit stupid when
i wrote it...

Max, please try the attached patch...

rgds
-daniel

--------

[PATCH] usbtouchscreen: fix eGalax/ETTI HID device ignoring

Fix the eGalax/ETTI HID device ignoring by adding a match for the protocol too.
This is what the marco USB_DEVICE_HID_CLASS() was supposed to do anyways.

Devices confirmed to be real HID have the class set to HID and the protocol
set to 'mouse'.  Some have HID class but protocol set to 'none'. Those are
not HID and should be driven by usbtouchscreen.

Signed-off-by: Daniel Ritz <daniel.ritz@gmx.ch>

diff --git a/drivers/input/touchscreen/usbtouchscreen.c b/drivers/input/touchscreen/usbtouchscreen.c
index 5080b26..ba6237a 100644
--- a/drivers/input/touchscreen/usbtouchscreen.c
+++ b/drivers/input/touchscreen/usbtouchscreen.c
@@ -118,7 +118,8 @@ enum {
 
 #define USB_DEVICE_HID_CLASS(vend, prod) \
 	.match_flags = USB_DEVICE_ID_MATCH_INT_CLASS \
-		| USB_DEVICE_ID_MATCH_DEVICE, \
+		| USB_DEVICE_ID_MATCH_DEVICE \
+		| USB_DEVICE_ID_MATCH_DEV_PROTOCOL, \
 	.idVendor = (vend), \
 	.idProduct = (prod), \
 	.bInterfaceClass = USB_INTERFACE_CLASS_HID, \


