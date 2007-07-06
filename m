Return-Path: <linux-kernel-owner+w=401wt.eu-S1763338AbXGFTaY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763338AbXGFTaY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 15:30:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757739AbXGFTaM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 15:30:12 -0400
Received: from an-out-0708.google.com ([209.85.132.251]:17878 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760493AbXGFTaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 15:30:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=qPuCUA63SfK+9y1sQulRYOZfzHubLkpSiX80jLXHcajrERJkUOg8xTWRvhCbDv0YSL7fS7ZSRxJdq41ycITah1qhlGshtTfGs/S4tvCVfxdVHYF9DbV9nlXoXerl0RAXyoXLBj2Kfd6PKmWixTl4loxmfLKzpVLvse7UwHa361I=
Message-ID: <ca35ce500707061230t66eae039p845fa25cbeaf271b@mail.gmail.com>
Date: Fri, 6 Jul 2007 21:30:10 +0200
From: mikie <mikie.pl@gmail.com>
To: "Duncan Sands" <duncan.sands@math.u-psud.fr>
Subject: Re: understanding firmware loader for speedtouch (kernel 2.6.21.5)
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200707061924.57099.duncan.sands@math.u-psud.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <ca35ce500707060554v71ebdca3k8ef18e4c0a44c9cb@mail.gmail.com>
	 <200707061620.44348.duncan.sands@math.u-psud.fr>
	 <ca35ce500707061006k74754bd6m8a9d2f1cb2910823@mail.gmail.com>
	 <200707061924.57099.duncan.sands@math.u-psud.fr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/7/6, Duncan Sands <duncan.sands@math.u-psud.fr>:
> Hi, you should keep this discussion on the lkml so it will be archived -
> that way it may help others too.

I was sure I copied lkml, but obviously something went wrong.

> On Friday 6 July 2007 19:06:14 mikie wrote:
> > 2007/7/6, Duncan Sands <duncan.sands@math.u-psud.fr>:
> > > On Friday 6 July 2007 14:54:18 mikie wrote:
> > > > Hi,
> > > >
> > > > I experience some problems with the speedtch.c module, especially in
> > > > regards to its firmware loader.
> > > > I am not quite sure if this module is going to load the firmware
> > > > itself or does it use some external software to do that ?
> > >
> > > It loads it itself, using some external software!
> >
> > OK, so probably I don't have anything external. Could you please point
> > me to the specific helper-program takes care of this process? As I
> > understand it is not done entirely by kernel itself?
>
> The external helper is the firmware.agent script!  The modem driver calls
> the kernel's firmware subsystem, the firmware subsystem creates a user
> space thread and calls whatever program is specified in /proc/sys/kernel/hotplug
> At the same time the firmware subsystem creates the "data" and "loading" files.
> The hotplug program is supposed to write the firmware into "data".

Thanks for the explanation. Now I get the overall picture of what
whould be done to load the firmware. I will try playing around with
the firmware.agent script, although I do not havfe the entire hotplug
package on my system, but probably this should work with a bit of
manual bash scripting.

> See
> Documentation/firmware_class in the kernel source for details.  More recent
> systems fire off a "uevent" and have udev take care of loading the firmware.

What do you mean by "recent systems" ? Is it distro dependent or
kernel dependent ?

> In any case, the external helper is not specific to this modem - it is part
> of the general hotplug infrastructure.  If you have hotplug or udev installed,
> probably they are looking for the firmware in the wrong place.

Actually I don't have hotplug/udev. That is why I am thinking of some
basic manual firmware loading. I switched from 2.4.33.3 kernel, where
such toold were not needed (I guess).


> > > > All I get is :
> > > >
> > > > Jul  6 13:41:37 srv kernel: speedtch 1-2:1.0: speedtch_find_firmware:
> > > > looking for speedtch-1.bin.2.00
> > > > [...]
> > > > Jul  6 13:42:19 srv kernel: speedtch 1-2:1.0: speedtch_find_firmware:
> > > > looking for speedtch-1.bin.2
> > > > [...]
> > > > Jul  6 13:43:19 srv kernel: speedtch 1-2:1.0: speedtch_find_firmware:
> > > > looking for speedtch-1.bin
> > > >
> > > > And nothing more happens. The firmware does not get loaded to the
> > > > modem. There is also no information in the logs that the firmware
> > > > loading failed...
> > >
> > > It should either print:
> > >         no stage 1 firmware found!
> > > or
> > >         found stage 1 firmware <name>
> > > Does it really print neither?  If so, that must mean that the
> > > firmware loader got stuck.
> >
> > I don't have anything about stage 1. This probably is done by some
> > helper program, as I understood.
>
> No, the modem prints one of these two messages when the user space
> helper returns, or a timeout occurs.  The fact it isn't printed
> suggests that the timeout is infinite.  The timeout is in
> /sys/class/firmware/timeout

I will take a closer look at the timeout value. It is quite
uncomfortable for me right now to switch to the new kernel, because I
loose internet connectivity at that time :)

> > But I don't know which one is that.
> > Perhaps I could do it manually ? Like copying the firmware to the
> > "data" ?
>
> Actually you could.  All the firmware.agent does (or did, maybe it got more
> sophisticated) is use "cat" to write the firmware file to "data".

I tried some basic copy, but received permission denied even though I
was root. Perhaps I was trying at the wrong location. I'll get back
with more info on Monday.

Thanks for your help.

Regards,
MK
