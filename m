Return-Path: <linux-kernel-owner+w=401wt.eu-S1753569AbXEFQ6j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753569AbXEFQ6j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 12:58:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753566AbXEFQ6j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 12:58:39 -0400
Received: from vms040pub.verizon.net ([206.46.252.40]:56043 "EHLO
	vms040pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753508AbXEFQ6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 12:58:37 -0400
Date: Sun, 06 May 2007 12:58:25 -0400
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: [PATCH] Serial 8250: Handle saving the clear-on-read bits from the
 LSR and MSR
In-reply-to: <463B7FBC.3090907@acm.org>
To: Corey Minyard <minyard@acm.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Russell King <rmk+lkml@arm.linux.org.uk>
Message-id: <200705061258.25351.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <20070504131532.GA12265@localdomain>
 <200705041304.02618.gene.heskett@gmail.com> <463B7FBC.3090907@acm.org>
User-Agent: KMail/1.9.6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 04 May 2007, Corey Minyard wrote:
>Gene Heskett wrote:
>> On Friday 04 May 2007, Corey Minyard wrote:
>>> I did think of one other thing: if you clear the MSR delta flags while
>>> polling the serial console, you need to call the routine to check the
>>> modem status since the interrupt will not happen.  So here's the
>>> patch...
>>>
>>> Subject: Serial 8250: Handle saving the clear-on-read bits from the LSR
>>> and MSR
>>
>> I applied this patch because I was curious to see what effect if any it
>> had on some serial based acessories I use here, like a cm11 x10 controller
>> with heyu, and a belkin ups with its supplied software.
>>
>> But at first boot, its not 100% operationally safe, but please read on.
>>
>> 1) heyu (the x10 control program) is now stuck in a loop, repeating the
>> last command issued, at about 40 second repeat intervals.  AND it is using
>> 90%+ of the cpu while it executes each loop, which takes about 7 to 10
>> seconds each time.  heyu is interfacing to the world via /dev/ttyUSB0,
>> through an FTDI adapter so I'm not able to make a mental connection here
>> between this patch and that effect.
>>
>> 2) HOWEVER!  The belkin upsd daemon, which started being a cpu hog, using
>> 40% of the cpu continuously since something in the 2.6.20 to 2.6.21 time
>> frame, and this was regardless of whether it was talking through a
>> /dev/ttyUSB# port and either a pl2303, or an FTDI adaptor, or direct
>> through /dev/ttyS0, is at least for /dev/ttyS0, now operating normally and
>> apparently 100% stable.  So I pulled out another FTDI adaptor, and
>> reconfigured the daemon to use /dev/ttyUSB1, and that is also operating
>> 100% normally now.
>>
>> Can someone explain 1) above?  Even odder still, I'd killed and restarted
>> heyu several times to no avail before I tried putting upsd on
>> /dev/ttyUSB1, but after moving the upsd access from /dev/ttyS0 to
>> /dev/ttyUSB1, then heyu, running through /dev/ttyUSB0, is now operating
>> 100% normally.  ???
>>
>> Does anyone have any idea what kind of bait I should put out to kill this
>> nilmerg?  I'm happy, its all working again for a change, but I'll be
>> damned if I ain't totally bumfuzzled.  And I wonder if it will survive a
>> reboot...
>
>I really doubt that this patch had anything to do with these issues,
>especially
>the ones over USB.  However, if you can reliably remove the patch, test, and
>reapply the patch, and test, and the issues remain the same, then it's
>perhaps
>something significant, though I would be at a loss to know what it was.
>
>-corey

Well, I believe it is.  Or did, see below.

I've been testing the two competing schedulers, and just now got around to 
testing Con's last 0.48 version, which at first feel isn't that bad.

And I also have to bitch because everytime I change schedulers, all my USB 
stuff jumps around and I have to reconfigure everything to use whatever the 
hell random ttyUSB# it gets with this particular scheduler at boot time.

For instance, with Con's scheduler, the FTDI device feeding a cm11a from heyu 
consistently gets /dev/ttyUSB1, and the FTDI device connecting my ups always 
gets /dev/ttyUSB0.

Now, I built this kernel without that patch.  Heyu, once reconfigured for the 
new address, works, but its a very low traffic connection.

upsd OTOH is attempting to talk to the ups, I can see the leds on the FTDI 
trying to establish the usual once per second sort of a gallumph, and failing, 
and upsd is now using 40 to 50% of the cpu.  I can't feel it though, so thats 
to the sd-0.48 patches credit, its working quite well so far.

So now, I'm going to apply that patch in the subject line to this 
2.6.21.1-sd-0.48 kernel and reboot.

Ok, done.  And everything usb serial is running normally except upsd, its 
working, but using 45% of the cpu.  So your patch DOES fix SOME of the serial 
usb problems here, in that upsd can now talk to the ups.

Now, I'm going to revert this same patch that I had applied to 2.6.21.1-CFS-v9 
and see if my problems come back.

Rebooted to that, and I'm bumfuzzled, everything is working, and I didn't have 
to reconfigure everything because the ports were swapped.  Jelly side up?  
Damnedifiknow...  heyu is spending quite a bit of time at the top of the list 
in htop at about 2% cpu, so I tail the log, the motion sensor is going 
banannas, but when I check for the cause, I found the missus is sitting in 
the porch swing yakking on the phone, which is tripping it. :-)

And, just to come full circle, I re-applied that patch to 2.6.21.1-CFS-v9 and 
rebooted yet again, so I'm back to where I started.  The thing I note most is 
that while heyu is still logging the missus on the porch swing, it never even 
gets to the top page of the htop display, without the patch, it was using 
about 2% of the cpu and was often the top item in he display.

Hopefully you can sort something meaningfull out of the above.  I'm too close 
to the forest to see the trees I think.

Now, there has been an even longer thread discussing the throwing away of data 
over usb serial in particular going on here, and I've NDI if this patch would 
correct the problems they are seeing, which in that case appear to be a 
situation where the data is being fed in a constant stream, but only read 
intermittently, resulting in the need to cleanly throw away data, vs this 
situation where in both cases here, any data input is read immediately by one 
or the other of the monitoring clients.

Previously I was having all sorts of problems & miss-comm with this kernel 
until I appled this patch, now I've reversed it and things are still working.

I'll continue to run this CFS kernel, with this patch until the next scheduler 
test patch comes by I guess, or we have a 22-rc1 to beat on.

Con's sd-0.48 feels great, but leaves upsd swinging in the breeze totally 
without this patch, and with it, upsd works but still uses 45% of the cpu, so 
this is the only viable combination of the 2 schedulers and with or without 
this patch.  Whatever it does, with Ingo's scheduler, its a fix, with Con's 
its still a day late & a dollar short.

Thanks for your patience Corey.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Death is nature's way of saying `Howdy'.
