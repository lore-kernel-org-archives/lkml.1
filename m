Return-Path: <linux-kernel-owner+w=401wt.eu-S1755872AbZA2JnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755872AbZA2JnU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 04:43:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753246AbZA2JnE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 04:43:04 -0500
Received: from styx.suse.cz ([82.119.242.94]:52275 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751120AbZA2JnB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 04:43:01 -0500
Date: Thu, 29 Jan 2009 10:43:00 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Greg KH <greg@kroah.com>
cc: Michael Tokarev <mjt@tls.msk.ru>, Sam Liddicott <sam@liddicott.com>,
       Ming Lei <tom.leiming@gmail.com>,
       Linux-kernel <linux-kernel@vger.kernel.org>,
       Linux USB list <linux-usb@vger.kernel.org>
Subject: Re: "permanently" unbind a device from a driver?
In-Reply-To: <20090128061940.GA14275@kroah.com>
Message-ID: <alpine.LNX.1.10.0901291038100.5377@jikos.suse.cz>
References: <497638FF.8050805@msgid.tls.msk.ru> <20090120210254.GA5609@kroah.com> <d82e647a0901210744t1655bacesf23bcd54e30002e9@mail.gmail.com> <20090121162345.GB22615@kroah.com> <4977596D.409@liddicott.com> <20090121181124.GA17410@kroah.com>
 <49779284.50603@msgid.tls.msk.ru> <20090128061940.GA14275@kroah.com>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Jan 2009, Greg KH wrote:

> > Oh, I didn't know.  In fact, that's exactly what I was asking in my 
> > first email in this thread - to have some module parameter or a sysfs 
> > file which can be touched to stop the module from claiming the device. 
> > This also helps to debug it, to know the right bits to use.. which I 
> > don't know...  ;)
> There is some way to do this, but I can't recall how at the moment.  
> Try asking the HID maintainer about this.

There is a 'quirks=' parameter that can be passed to the usbhid driver. 
Unfortunately the need for IGNORE_QUIRK went away when the whole hid stuff 
got converted to proper bus with proper drivers.

But for backward userspace compatibility we want to have the 
HID_IGNORE_QUIRK in place, solely for the purpose of users being able to 
specify it during the module load, I agree. I currently have this queued 
in my tree.

diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
index f0a0f72..eed05a3 100644
--- a/drivers/hid/usbhid/hid-core.c
+++ b/drivers/hid/usbhid/hid-core.c
@@ -711,6 +711,9 @@ static int usbhid_parse(struct hid_device *hid)
 	quirks = usbhid_lookup_quirk(le16_to_cpu(dev->descriptor.idVendor),
 			le16_to_cpu(dev->descriptor.idProduct));
 
+	if (quirks & HID_QUIRK_IGNORE)
+		return -ENODEV;
+
 	/* Many keyboards and mice don't like to be polled for reports,
 	 * so we will always set the HID_QUIRK_NOGET flag for them. */
 	if (interface->desc.bInterfaceSubClass == USB_INTERFACE_SUBCLASS_BOOT) {
diff --git a/include/linux/hid.h b/include/linux/hid.h
index 81aa84d..da481b3 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -270,6 +270,7 @@ struct hid_item {
 
 #define HID_QUIRK_INVERT			0x00000001
 #define HID_QUIRK_NOTOUCH			0x00000002
+#define HID_QUIRK_IGNORE			0x00000004
 #define HID_QUIRK_NOGET				0x00000008
 #define HID_QUIRK_BADPAD			0x00000020
 #define HID_QUIRK_MULTI_INPUT			0x00000040

-- 
Jiri Kosina
SUSE Labs
