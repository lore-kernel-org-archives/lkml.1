Return-Path: <linux-kernel-owner+w=401wt.eu-S1752119AbZHOUKW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752119AbZHOUKW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 16:10:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752005AbZHOUKV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 16:10:21 -0400
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:60277 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709AbZHOUKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 16:10:20 -0400
Date: Sat, 15 Aug 2009 22:10:19 +0200
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       jbarnes@virtuousgeek.org, akpm@linux-foundation.org,
       bjorn.helgaas@hp.com, randy.dunlap@oracle.com,
       dmitry.torokhov@gmail.com
Subject: Re: [patch 0/2] Winbond IR Driver - v2
Message-ID: <20090815201019.GB27484@hardeman.nu>
Mail-Followup-To: Maxim Levitsky <maximlevitsky@gmail.com>,
	linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
	jbarnes@virtuousgeek.org, akpm@linux-foundation.org,
	bjorn.helgaas@hp.com, randy.dunlap@oracle.com,
	dmitry.torokhov@gmail.com
References: <20090809095645.198777507@hardeman.nu> <1250305347.18122.4.camel@maxim-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1250305347.18122.4.camel@maxim-laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 15, 2009 at 06:02:27AM +0300, Maxim Levitsky wrote:
>On Sun, 2009-08-09 at 11:56 +0200, david@hardeman.nu wrote:
>> Here's a new patch set which should replace all the patches currently in the
>> -mm tree for the winbond cir driver. The new series incorporate feedback from
>> Bjorn Helgaas (convert the driver from ACPI to PNP) and Randy Dunlap (Kconfig
>> fixes).
>> 
>> The IR decoding can still be improved but the driver works for in daily use
>> decoding RC6 commands, so I believe it is ready to go upstream.
>> 
>
>Hi.

Hi,

>As I understand, this hardware returns sampled IR signal, so it can be
>used with any remote, right?

Yes.

>Then why not to implement lirc driver?

That's a fair question, but I'm afraid you're putting the cart before 
the horse.

The question is not why anyone would want to write an in-kernel driver 
but rather why anyone would want to write an out-of-kernel driver.

There have been repeated attempts to get LIRC merged with the kernel, 
and the feedback has been pretty consistent - make it part of the input 
subsystem.

I have written the driver for the input system and it limits the driver 
somewhat. I am working on extending the input system to accomodate IR 
drivers (see the discussion of EV_IR on the linux-input list).

As an example, the input system already has a quite extensive set of 
additional functions to deal with force-feedback hardware (mostly 
additional ioctl's, see include/linux/input.h). I want the input system 
to grow similar extensions for IR hardware which would then allow IR 
drivers to be written as input drivers with their full functionality 
exposed to user-space.

Feel free to help me out in implementing that API, and porting LIRC 
drivers, and all the benefits of in-kernel drivers will flow from that 
work.

To be more specific, the things that are on my radar right now are:

o IR TX - I believe an IOCTL which will take an array of signed integers 
           symbolizing IR on/off timings together with parameters for IR 
           carrier modulation is the way to go and to let userspace deal 
           with the generation of those integers (for a number of 
           reasons).

o IR RX - We need to expose the full functionality of hardware with 
           multiple receivers to userspace. Microsoft's current CIR specs 
           mandate that IR hardware that includes transmitters must 
           include both a long-distance, narrow-band receiver for common 
           use and a short-distance, wide-band receiver for learning 
           purposes. Expect future hardware to meet those demands...

o Hardware differences -
           The lircd daemon currently has a "-H" parameter to specify the 
           driver to use. To me, that is a dead giveaway for an 
           inconsistent kernel <-> userspace API. We can do better, given 
           the proper HW flags from the input layer, userspace should 
           adapt automatically. Some hardware, say 
           drivers/media/dvb/ttpci/budget-ci.c (where you'll find my name 
           in the git logs) only support passing decoded RC5 events. Some 
           hardware (like the lirc mceusb(2) driver) passes the timing 
           for the IR signals and supports any remotely sane IR protocol. 
           The WPCD376I has even a bit more capabilities like 
           wake-from-poweroff, two receivers and up to four transmitters
           with the capability to detect which transmitters are connected 
           and which ones are not.

           The challenge at this point is not in writing drivers for the 
           hardware, it is designing an extension to the input layer that 
           can sanely deal with the diversity.

Anyhow, do check the linux-input list for my EV_IR patches, they are the 
first step in that direction (and they're based on the API proposal by 
Jon Smirl posted at the end of last year). Raw signalling information 
for wonky remotes is part of that proposal (though the patches are not 
fully fleshed out yet).

>This driver as I understand is a driver for single remote shipped with
>the notebook.

It's a driver for a winbond chipset shipped with many Intel desktop 
"media" motherboards (DP35DP, DG33TL, DX388T, DX488T2, DP455G, DG45ID 
and DG45FC are the ones I'm aware of).

>I have recently wrote a lirc driver for  my receiver, a lirc driver. Now
>I can use all my remotes.

So can I. But for a easy-to-use and consistent user interface, some 
changes are needed to the input layer.

>And no, I don't need any software support for that. LIRC happily
>forwards all events via uinput to kernel, so I use it a an ordinary
>keyboard.

I know LIRC and what it can do, look in the CVS logs and the LIRC 
mailing list archives and I think you'll find my name there.

Regards,
David Härdeman
