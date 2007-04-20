Return-Path: <linux-kernel-owner+w=401wt.eu-S2992956AbXDTPz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992956AbXDTPz2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 11:55:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993265AbXDTPz2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 11:55:28 -0400
Received: from nz-out-0506.google.com ([64.233.162.237]:60995 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992956AbXDTPz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 11:55:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=s9e9phpqMa61MH+FDd60YbKvSYiXRu1tkeh3pQ7JvRgHTgemozQFNZdDk7ZUbjn/QDzokufIJoEI+XsxZ9wBtNpu2/SJvE08X8zRmR+nRonRGX+RZ3EUglIunyx3kd2cVyKA5OMoCUEzGJHmqRJyhofQQOW6jEvgAdtJxveOZNc=
Message-ID: <cb7bb73a0704200855xe841ecdoc9a0f67fc6f7009e@mail.gmail.com>
Date: Fri, 20 Apr 2007 17:55:26 +0200
From: "Giuseppe Bilotta" <giuseppe.bilotta@gmail.com>
To: "Jiri Kosina" <jkosina@suse.cz>
Subject: Re: Acecad USB Tablet: usbmouse takeover and odd motion
Cc: linux-kernel@vger.kernel.org, dmitry.torokhov@gmail.com,
       edouard.tisserant@wanadoo.fr, vojtech@ucw.cz
In-Reply-To: <Pine.LNX.4.64.0704201533300.5138@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <cb7bb73a0704191940s1fd6487j9a4412aebd4342c0@mail.gmail.com>
	 <Pine.LNX.4.64.0704200903370.29846@jikos.suse.cz>
	 <cb7bb73a0704200126x1e7893fem5902fe79eefb70b7@mail.gmail.com>
	 <Pine.LNX.4.64.0704201533300.5138@jikos.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/20/07, Jiri Kosina <jkosina@suse.cz> wrote:
> On Fri, 20 Apr 2007, Giuseppe Bilotta wrote:
>
> > lsusb claims:
> > Bus 002 Device 003: ID 0460:0004 Ace Cad Enterprise Co., Ltd
> > and according to hid-core.c this *is* a blacklisted ID ...
>
> Yes, so it definitely should be ignored and not claimed by the usbhid
> subsystem.

> Could you please verify in /sys/bus/usb/drivers/usbhid whether this device
> is really claimed by the usbhid driver? Do you have other HID devices in
> the system?

Sorry, it seems I was wrong, it's not usbhid but usbmouse taking over.
After a fresh plug (e.g. at bootup) I get the following:

dmesg:

usb 1-1: new low speed USB device using uhci_hcd and address 2
usb 1-1: configuration #1 chosen from 1 choice
input: ACECAD USB Graphics Tablet  as /class/input/input4
usbcore: registered new interface driver usbmouse
drivers/usb/input/usbmouse.c: v1.6:USB HID Boot Protocol mouse driver
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
drivers/usb/input/hid-core.c: v2.6:USB HID core driver
usbcore: registered new interface driver usb_acecad
drivers/usb/input/acecad.c: v3.2:USB Acecad Flair tablet driver

/proc/bus/input/devices

I: Bus=0003 Vendor=0460 Product=0004 Version=0130
N: Name="ACECAD USB Graphics Tablet "
P: Phys=usb-0000:00:1d.0-1/input0
S: Sysfs=/class/input/input4
H: Handlers=mouse2 event4
B: EV=7
B: KEY=1f0000 0 0 0 0 0 0 0 0
B: REL=103

ls /sys/bus/usb/drivers/usbmouse

total 0
lrwxrwxrwx 1 root root    0 2007-04-20 17:30 1-1:1.0 ->
../../../../devices/pci0000:00/0000:00:1d.0/usb1/1-1/1-1:1.0
--w------- 1 root root 4096 2007-04-20 17:30 bind
lrwxrwxrwx 1 root root    0 2007-04-20 17:30 module ->
../../../../module/usbmouse
--w------- 1 root root 4096 2007-04-20 17:30 new_id
--w------- 1 root root 4096 2007-04-20 17:30 unbind

So it seems that the greedy driver is usbmouse. I'm adding Vojtech to
the CC: list, since he's listed as the usbmouse author.

Notice that if I rmmod usbmouse and rmmod acecad and then modprobe
acecad again (or maybe I should learn to use the bind/unbind features)
without unplugging the tablet, I get more 'correct'
/proc/bus/input/devices

I: Bus=0003 Vendor=0460 Product=0004 Version=0130
N: Name="ACECAD USB Graphics Tablet "
P: Phys=usb-0000:00:1d.0-1/input0
S: Sysfs=/class/input/input8
H: Handlers=mouse2 event4
B: EV=b
B: KEY=1c01 0 70000 0 0 0 0 0 0 0 0
B: ABS=1000003

and ls /sys/bus/usb/drivers/*

/sys/bus/usb/drivers/hiddev:
bind
module
new_id
unbind

/sys/bus/usb/drivers/hub:
1-0:1.0
2-0:1.0
bind
module
new_id
unbind

/sys/bus/usb/drivers/usb:
1-1
bind
module
unbind
usb1
usb2

/sys/bus/usb/drivers/usb_acecad:
1-1:1.0
bind
module
new_id
unbind

/sys/bus/usb/drivers/usbfs:
bind
module
new_id
unbind

/sys/bus/usb/drivers/usbhid:
bind
module
new_id
unbind

so just letting usbmouse ignore the device (or maybe have acecad claim
it from usbmouse automagically, if this kind of thing is possible)
should fix the kernel side of the issue (xinput/evdev on X is still
confused by the tablet, even if do the driver gimmick before starting
X, but I'll take that over to the xorg mailing list as soon as I've
fixed the thing kernel side).

Any suggestions or patches welcome.

-- 
Giuseppe "Oblomov" Bilotta
