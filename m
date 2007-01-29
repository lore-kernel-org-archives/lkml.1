Return-Path: <linux-kernel-owner+w=401wt.eu-S933039AbXA2BWs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933039AbXA2BWs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 20:22:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933040AbXA2BWs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 20:22:48 -0500
Received: from main.gmane.org ([80.91.229.2]:57753 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933039AbXA2BWr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 20:22:47 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Oleg Verych <olecom@flower.upol.cz>
Subject: Re: unfixed regression in 2.6.20-rc6 (since 2.6.19)
Date: Mon, 29 Jan 2007 01:22:22 +0000 (UTC)
Organization: Palacky University in Olomouc, experimental physics department.
Message-ID: <slrnerqjit.f71.olecom@flower.upol.cz>
References: <877ivb2kvc.fsf@semtex.sncag.com> <20070125185101.GA26279@kroah.com> <87y7nq131x.fsf@semtex.sncag.com> <20070126174828.GA28890@kroah.com> <87d54z1dhb.fsf@semtex.sncag.com>
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: flower.upol.cz
Mail-Followup-To: LKML <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>, Rainer Weikusat <rainer.weikusat@sncag.com>, Oleg Verych <olecom@flower.upol.cz>, Linus Torvalds <torvalds@linux-foundation.org>, Adrian Bunk <bunk@stusta.de>
User-Agent: slrn/0.9.8.1pl1 (Debian)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Rainer Weikusat
> Newsgroups: gmane.linux.kernel
> Subject: Re: unfixed regression in 2.6.20-rc6 (since 2.6.19)
> Date: Sun, 28 Jan 2007 14:34:56 +0100

Hallo.

> Greg KH <greg@kroah.com> writes:
[]
>> Please work to see what is wrong with the existing patch.  Is there
>> anything that I can do to help you out?
>
> This thing has consumed something like sixteen hours of my life in
> total, with a gain-to-be-expected of exactly zero (I don't need to run
> 'current' kernels on my work machine, I have just grown into the habit
> of doing so) and those sixteen hours cannot come back (and I even have
> had these type of discussions around 'should it rather look like math
> or rather like text' in sufficent quantities :->), so, except that I
> would be very much obliged to you if a fix for this issue could go
> into the 'official' tree rather sooner than later, no.

It's hot here.

I'm in similar situation (even *usb-serial* driver [TI USB] led me there;)

In short, it turned, that usb drivers aren't drivers at all, they are
just "USB interface drivers", i.e. managers of the particular USB
interface *in* the device.

Problem is: after changing ti-usb-serial's firmware, it is being reset
and apears with new device ID. It's OK so far, but even this may be
better (from USB hardware implementation point of view). Then this
device, after being caught with new ID by the same "driver" requires
seting USB configuration #2, in order to be usb-serial converter. Day was
lost to make this happen _inside_ driver (kernel 2.6.18). It turned, that
only way to do so is SYSFS, that set up by udev, and
"usb_set_configuration()" function is being used for that.

1. Why it's not called "sysfs_usb_set_configuration()"?

2. Why

   [USB device view]: vID:dID -- bNumConfigurations -- bNumInterfaces

is being only device IDs tables in usb drivers?

3. Where's configuration and/or interfaces choosing? Yes, this may be not
so wide used, but hey, it's design issue! There's a big cave in device
setup and configuration chain!

Look at 2.6.19 with "usb_driver_set_configuration()" to see it.

And don't say, USB device requires userspace to setup (external
firmware is another question). I can be young and stupid, and this is
very wired only for my understanding. Simple NULL by default or set
table of {num_usb_conf, num_interface} for "drivers" will be enough.

> Apart from that, I make a (fairly miserable) living by adapting open
> source code to be usable in specific situations (ie adding or
> modifying features, fixing bugs, writing drivers etc)

So and i. I wanted to adopt request_firmware() for TI USB serial, but
i became very confused and upset.

--
-o--=O`C
 #oo'L O
<___=E M

