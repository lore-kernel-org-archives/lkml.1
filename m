Return-Path: <linux-kernel-owner+w=401wt.eu-S1750816AbXA2Jz6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750816AbXA2Jz6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 04:55:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752486AbXA2Jz6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 04:55:58 -0500
Received: from twin.jikos.cz ([213.151.79.26]:46063 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750816AbXA2Jz6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 04:55:58 -0500
Date: Mon, 29 Jan 2007 10:55:48 +0100 (CET)
From: Jiri Kosina <jikos@jikos.cz>
To: Soeren Sonnenburg <kernel@nn7.de>
cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-usb-devel <linux-usb-devel@lists.sourceforge.net>
Subject: Re: 2.6.20-rc6 pb_fnmode regression
In-Reply-To: <1169904555.2462.10.camel@localhost>
Message-ID: <Pine.LNX.4.64.0701291049190.9448@twin.jikos.cz>
References: <1169904555.2462.10.camel@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 27 Jan 2007, Soeren Sonnenburg wrote:

> I realized that any setting to /sys/module/usbhid/parameters/pb_fnmode 
> is just ignored until the machine does a suspend-resume cycle.

Hi Soeren,

I would probably not call this a regression, as this has been always 
there, as far as I can see.

> I've added a printk in drivers/usb/input/hid-core.c (which is the only 
> place where hid->pb_fnmode is set) and indeed only on module load ( in 
> my case usbhid is compiled into the kernel - so on kernel boot) any 
> change to hid>pb_fnmode is done. Adding a printk to hidinput_pb_event() 
> in drivers/hid/hid-input.c says the same: hid->pb_fnmode cannot be 
> changed on the fly anymore... HOWEVER: If I s2ram the machine 
> hid->pb_fnmode is initialized with the value I put into 
> /sys/module/usbhid/parameters/pb_fnmode . As I have no idea how/whether 
> sysfs works/is possible I now hope someone more knowledgable than me can 
> resolve this issue!

Changing module parameter values through sysfs is not a very nice idea, 
because the change of the value is indeed silent - the driver is not 
notified in any way, that the value has changed. So the driver should take 
care of it by itself, which is not a nice thing.

The fact that during suspend/resume cycle it works is caused by the fact 
that all the hid devices are reinitialized, and therefore the 
hid->pb_fnmode is reassigned a new value, which has eventually been 
changed through sysfs.

I would rather be inclined to just make the 
/sys/module/usbhid/parameters/pb_fnmode read-only (which is what most of 
the drivers do anyway), to avoid this kind of confusion.

Do you have really any strong use-case, when setting the parameter during 
runtime would be much more useful than just do it during modprobe or 
rmmod/modprobe cycle?

Thanks,

-- 
Jiri Kosina
