Return-Path: <linux-kernel-owner+w=401wt.eu-S1752585AbZHOWK3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585AbZHOWK3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 18:10:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751121AbZHOWK2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 18:10:28 -0400
Received: from mail-fx0-f215.google.com ([209.85.220.215]:41274 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709AbZHOWK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 18:10:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=RmnskTuLCe3y/mckYdw/GBpEd69wnPBp2SZFrjbrhGJ2zKPQUA+dbrO2f2BnjKvd+9
         Xl+Vug3VFbOu4CEi1PHUPZ00VrLESNKNjhbjhPDf97geQ0StBI672MjR4z9OhisJaHNT
         SThm6hnlIo3o5rjt4mMFAPEl5oiKo84mWw+oE=
Subject: Re: [patch 0/2] Winbond IR Driver - v2
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: David =?ISO-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       jbarnes@virtuousgeek.org, akpm@linux-foundation.org,
       bjorn.helgaas@hp.com, randy.dunlap@oracle.com,
       dmitry.torokhov@gmail.com
In-Reply-To: <20090815201019.GB27484@hardeman.nu>
References: <20090809095645.198777507@hardeman.nu>
	 <1250305347.18122.4.camel@maxim-laptop>
	 <20090815201019.GB27484@hardeman.nu>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 16 Aug 2009 01:10:11 +0300
Message-Id: <1250374211.1928.27.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-08-15 at 22:10 +0200, David Härdeman wrote:
> On Sat, Aug 15, 2009 at 06:02:27AM +0300, Maxim Levitsky wrote:
> >On Sun, 2009-08-09 at 11:56 +0200, david@hardeman.nu wrote:
> >> Here's a new patch set which should replace all the patches currently in the
> >> -mm tree for the winbond cir driver. The new series incorporate feedback from
> >> Bjorn Helgaas (convert the driver from ACPI to PNP) and Randy Dunlap (Kconfig
> >> fixes).
> >> 
> >> The IR decoding can still be improved but the driver works for in daily use
> >> decoding RC6 commands, so I believe it is ready to go upstream.
> >> 
> >
> >Hi.
> 
> Hi,
> 
> >As I understand, this hardware returns sampled IR signal, so it can be
> >used with any remote, right?
> 
> Yes.
> 
> >Then why not to implement lirc driver?
> 
> That's a fair question, but I'm afraid you're putting the cart before 
> the horse.
No, I just want to write the driver that fully exposes the hardware. I
don't care if it has to be outside or not.

> 
> The question is not why anyone would want to write an in-kernel driver 
> but rather why anyone would want to write an out-of-kernel driver.
> 
> There have been repeated attempts to get LIRC merged with the kernel, 
> and the feedback has been pretty consistent - make it part of the input 
> subsystem.
> 
> I have written the driver for theo input system and it limits the driver 
> somewhat. I am working on extending the input system to accomodate IR 
> drivers (see the discussion of EV_IR on the linux-input list).
The EV_IR thing is that he attempts to put all IR decoding in kernel,
and on top of that create a configfs config system.
I first thought it would be nice, but then realized that this is really
bad idea.
Currently LIRC has very oiled system for decoding pretty much every
remote that exist. It can cope with all kind of troubles, including not
very accurate receivers.
On top of that there are pure userspace devices, like a IR diode
connected to soundcard. It would be nice to do all the raw signal
decoding in one place. Once signal is decoded, lirc forwards the input
signal to the kernel via uinput, so it is a part of input system.

The way kernel hands in the raw IR data to lirc doesn't matter much. It
is really just a queue of numbers. It can be forced into input system,
but there is really no need for that.





> 
> As an example, the input system already has a quite extensive set of 
> additional functions to deal with force-feedback hardware (mostly 
> additional ioctl's, see include/linux/input.h). I want the input system 
> to grow similar extensions for IR hardware which would then allow IR 
> drivers to be written as input drivers with their full functionality 
> exposed to user-space.
This is straight forward to implement as an ioctl for that lirc device.

> 
> Feel free to help me out in implementing that API, and porting LIRC 
> drivers, and all the benefits of in-kernel drivers will flow from that 
> work.
This isn't a bad idea.


> 
> To be more specific, the things that are on my radar right now are:
> 
> o IR TX - I believe an IOCTL which will take an array of signed integers 
>            symbolizing IR on/off timings together with parameters for IR 
>            carrier modulation is the way to go and to let userspace deal 
>            with the generation of those integers (for a number of 
>            reasons).
This is done in lirc already via ioctls.

> 
> o IR RX - We need to expose the full functionality of hardware with 
>            multiple receivers to userspace. Microsoft's current CIR specs 
>            mandate that IR hardware that includes transmitters must 
>            include both a long-distance, narrow-band receiver for common 
>            use and a short-distance, wide-band receiver for learning 
>            purposes. Expect future hardware to meet those demands...
> 
> o Hardware differences -
>            The lircd daemon currently has a "-H" parameter to specify the 
>            driver to use. To me, that is a dead giveaway for an 
>            inconsistent kernel <-> userspace API. We can do better, given 
>            the proper HW flags from the input layer, userspace should 
>            adapt automatically. Some hardware, say 
>            drivers/media/dvb/ttpci/budget-ci.c (where you'll find my name 
>            in the git logs) only support passing decoded RC5 events. Some 
>            hardware (like the lirc mceusb(2) driver) passes the timing 
>            for the IR signals and supports any remotely sane IR protocol. 
>            The WPCD376I has even a bit more capabilities like 
>            wake-from-poweroff, two receivers and up to four transmitters
>            with the capability to detect which transmitters are connected 
>            and which ones are not.
This isn't a problem. LIRC has a 'generic' driver "default" its name I
think, that deals with kernel drivers. It has the -H for all kinds of
wierd and old devices that work via userspace.

> 
>            The challenge at this point is not in writing drivers for the 
>            hardware, it is designing an extension to the input layer that 
>            can sanely deal with the diversity.
> 
> Anyhow, do check the linux-input list for my EV_IR patches, they are the 
> first step in that direction (and they're based on the API proposal by 
> Jon Smirl posted at the end of last year). Raw signalling information 
> for wonky remotes is part of that proposal (though the patches are not 
> fully fleshed out yet).
> 
> >This driver as I understand is a driver for single remote shipped with
> >the notebook.
> 
> It's a driver for a winbond chipset shipped with many Intel desktop 
> "media" motherboards (DP35DP, DG33TL, DX388T, DX488T2, DP455G, DG45ID 
> and DG45FC are the ones I'm aware of).
But it won't work with my JVC remote?....

> 
> >I have recently wrote a lirc driver for  my receiver, a lirc driver. Now
> >I can use all my remotes.
> 
> So can I. But for a easy-to-use and consistent user interface, some 
> changes are needed to the input layer.


Best regards,
	Maxim Levitsky

> 
> >And no, I don't need any software support for that. LIRC happily
> >forwards all events via uinput to kernel, so I use it a an ordinary
> >keyboard.
> 
> I know LIRC and what it can do, look in the CVS logs and the LIRC 
> mailing list archives and I think you'll find my name there.
> 
> Regards,
> David Härdeman

