Return-Path: <linux-kernel-owner+w=401wt.eu-S1757471AbYAGOUx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757471AbYAGOUx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 09:20:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753789AbYAGOUp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 09:20:45 -0500
Received: from nf-out-0910.google.com ([64.233.182.186]:52398 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752954AbYAGOUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 09:20:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Yn4g2lIbac2tYgkQ7O3bf4FghPxCbxsPuDY1EnW7zhUQBvTwHp2Uzk1hY4MNabOthPNz953uIRaE7P2SKnQsfQaSPnzmUzigItxrXOb1ycqG/9Xt3fj+6lTboTe1JQqS7lL7v5qU6jqinDngAJosvVHUe4Bvf/bV66Ru3LJxbl4=
Message-ID: <d120d5000801070620i1505e697jf73fa001a9c884db@mail.gmail.com>
Date: Mon, 7 Jan 2008 09:20:40 -0500
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Andrey Borzenkov" <arvidjaar@mail.ru>
Subject: Re: acpi/apm events as inputs: how to handle?
Cc: "Michael Tokarev" <mjt@tls.msk.ru>, linux-kernel@vger.kernel.org
In-Reply-To: <20080107130332.5973A2D6BF@smtp02.mtu.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <477B5FD8.5070503@msgid.tls.msk.ru>
	 <200801052105.03068.dtor@insightbb.com>
	 <47820224.2020902@msgid.tls.msk.ru>
	 <20080107130332.5973A2D6BF@smtp02.mtu.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Jan 7, 2008 8:03 AM, Andrey Borzenkov <arvidjaar@mail.ru> wrote:
> Michael Tokarev wrote:
>
> > Dmitry Torokhov wrote:
> >> Hi Michael,
> >
> > Hello!
> >
> > []
> >> There are keyboards (USB, PS2) with Sleep and Suspend buttons
> >> that are not related to ACPI nor APM. We had 2 options - add
> >> an input handler that would translate input events into ACPI
> >> events and feed /proc/acpi/event[*] or go other way around and
> >> use input layer for delivering suspend and sleep requests for
> >> all types of keyboards/buttons, including ACPI buttons. The
> >> secons option is better because userspace solution using input
> >> layer will not be tied to a particular technology (ACPI) and
> >> can be used on other platforms as well.
> >
> > Aha, this makes sense.
> > And it brings a few questions, too.
> >
> > As far as I can see, there's little information about how to
> > actually use the input interface.  Let's suppose I'm about to
> > write an application (a daemon) that should replace acpid --
> > it's handling of the said buttons (power and sleep).  How to
> > find the right devices?  Should it use /dev/input/event* or
> > something else?  How about handling hot-plugged devices like
> > new (and removed) keyboards? (And yes, my keyboard has a sleep
> > button.)

I think the best ways is to listen to hotplug events in some fashion.
Raw netlink, D-Bus, etc.

> >
>
> Well, you use event device in any case; as for finding right one - I guess
> you look at device capabilities and filter what you need ...
>
> {pts/0}%
> cat /sys/devices/LNXSYSTM:00/LNXPWRBN:00/input/input1/capabilities/key
> 100000 0 0 0
>

Exactly. Any driver working through evdev interface should examine
device's capabilities and decide whether it is interested in the
device or not.

> you could also check name but I guess it is unreliable
>
> {pts/0}% cat /sys/devices/LNXSYSTM:00/LNXPWRBN:00/input/input1/name
> Power Button (FF)
>
> Then you have your event device:
>
> {pts/0}% ll -d /sys/devices/LNXSYSTM:00/LNXPWRBN:00/input/input1/event1
> drwxr-xr-x 3 root root 0 2008-01-07
> 15:32 /sys/devices/LNXSYSTM:00/LNXPWRBN:00/input/input1/event1/
>
> the problem that you *really* have - nobody prevents user from using udev to
> renaming /dev/input/event1 away into anything (s)he likes. Of course you
> could do
>
> {pts/0}%
> udevinfo --query=name --path /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1/event1
> input/event1
>
> .. but at some point we have to commit to support this interface forever.
>

/sys/class/input/event0/device pointe to corrseponding input device
and you can get capabilities from there.
/sys/class/input/event0/dev contains dev_t so if you don't see proper/
/dev/input/eevent* you can create your own.

> > And by the way, what INPUT can one expect from a PC speaker?
> > input: PC Speaker as /devices/platform/pcspkr/input/input0
> >

Speaker is tied very closely to keyboard beeps and that's why it is
part of input system.

>
> I ask myself about LNXVIDEO as well.
>
> /devices/LNXSYSTM:00/device:00/PNP0A03:00/device:13/LNXVIDEO:00/input/input3/event3/

There are keys that are tied in firmware to the video device that
switch between CRT and LCD on laptops. They emit events like
KEY_SWITCHVIDEOMODE and so input device was needed.

-- 
Dmitry
