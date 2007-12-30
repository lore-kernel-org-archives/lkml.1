Return-Path: <linux-kernel-owner+w=401wt.eu-S1758534AbXL3VVd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758534AbXL3VVd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 16:21:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758272AbXL3VVY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 16:21:24 -0500
Received: from mho-01-bos.mailhop.org ([63.208.196.178]:64652 "EHLO
	mho-01-bos.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758261AbXL3VVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 16:21:22 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 216.15.117.105
X-Report-Abuse-To: abuse@dyndns.com (see http://www.mailhop.org/outbound/abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18XHedYvteqLcBJiM5COzv3
Message-ID: <47780B93.4050606@reed.com>
Date: Sun, 30 Dec 2007 16:20:19 -0500
From: "David P. Reed" <dpreed@reed.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.9) Gecko/20071115 Fedora/2.0.0.9-1.fc8 Thunderbird/2.0.0.9 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Rene Herman <rene.herman@keyaccess.nl>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       Islam Amer <pharon@gmail.com>, hpa@zytor.com,
       Pavel Machek <pavel@ucw.cz>, Ingo Molnar <mingo@redhat.com>,
       Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override
References: <477711DC.5030800@keyaccess.nl> <alpine.LFD.1.00.0712300124440.32517@woody.linux-foundation.org> <20071230144700.78f4605c@the-village.bc.nu> <20071230152835.GX16946@elte.hu> <20071230153818.1a554a7e@the-village.bc.nu> <20071230160132.GA14311@elte.hu> <20071230164828.039916c8@the-village.bc.nu> <4777E010.7030703@keyaccess.nl> <20071230183927.5a5a3c42@the-village.bc.nu> <4777F297.9070207@keyaccess.nl> <alpine.LFD.1.00.0712301158410.32517@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0712301158410.32517@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am so happy that there will be a way for people who don't build their 
own kernels to run Linux on their HP and Compaq laptops that have 
problems with gazillions of writes to port 80, and I'm also happy that 
some of the strange driver code will be cleaned up over time.  Thank you 
all.  Some thoughts you all might consider, take or leave, in this 
process, from an old engineering manager who once had to worry about QA 
for software on nearly every personal computer model in the 1980-1992 
period:

You know, there is a class of devices that are defined to use port 
0x80...  it's that historically useful class of devices that show/record 
the POST diagnostics.   It certainly was not designed for "delay" 
purposes.   In fact, some of those same silly devices are still used in 
industry during manufacturing test.   I wonder what would happen if 
Windows were not part of manufacturing test, and instead Linux were the 
"standard" for some category of machines...

When I was still working at Lotus in the late '80's, when we still 
supported machines like 286's, there were lots of problems with timing 
loops in drivers in applications (even Win 3.0 had some in hard disk 
drivers, as did some of our printer drivers, ...), as clock speeds 
continued to ramp.  There were major news stories of machines that 
"crashed when xyz application or zyx peripheral were added".  It was 
Intel, as I recall, that started "publicly" berating companies in the PC 
industry for using the "two short jumps" solutions, and suggesting that 
they measure the processor speed at bootup, using the BIOS standard for 
doing that with the int 15 BIOS elapsed time calls, and always use 
"calibrated" timing loops.   Which all of us who supported device 
drivers started to do  (remember, apps had device drivers in those days 
for many devices that talked directly with the registers).

I was impressed when I dug into Linux eventually, that this operating 
system "got it right" by measuring the timing during boot and creating a 
udelay function that really worked!

So I have to say, that when I was tracing down the problem that 
originally kicked off this thread, which was that just accessing the RTC 
using the standard CMOS_READ macros in a loop caused a hang, that these 
"outb al,80h" things were there.   And I noticed your skeptical comment 
in the code, Linus.  Knowing that there was never in any of the 
documented RTC chipsets a need for a pause between accesses (going back 
to my days at Software Arts working on just about every old machine 
there was...) I changed it on a lark to do no pause at all.   And my 
machine never hung...

Now what's interesting is that the outb to port 80 is *faster* than an 
outb to an unused port, on my machine.  So there's something there - 
actually accepting the bus transaction.   In the ancient 5150 PC, 80 was 
unused because it was the DMA controller port that drove memory refresh, 
and had no meaning.

Now my current hypothesis (not having access to quanta's design specs 
for a board they designed and have shipped in quantity, or having taken 
the laptop apart recently) is that there is logic there on port 80, 
doing something.  Perhaps even "POST diagnostic recording" as every PC 
since the XT has supported... perhaps supporting post-crash 
dignostics...   And that that something has a buffer, perhaps even in 
the "Embedded Controller" that may need emptying periodically.   It 
takes several tens of thousands of "outb" to port 80 to hang the 
hardware solid - so something is either rare or overflowing.  In any 
case, if this hypothesis is correct - the hardware may have an erratum, 
but the hardware is doing a very desirable thing - standardizing on an 
error mechanism that was already in the "standard" as an option...  It's 
Linux that is using a "standard" in a wrong way (a diagnostic port as a 
delay).

So I say all this, mainly to point out that Linux has done timing loops 
right (udelay and ndelay) - except one place where there was some 
skepticism expressed, right there in the code.   Linus may have some 
idea why it was thought important to do an essential delay with a bus 
transaction that had uncertain timing.   My hypothesis is that 
"community" projects have the danger of "magical theories" and 
"coolness" overriding careful engineering design practices.

Cleaning up that "clever hack" that seemed so good at the time is hugely 
difficult, especially when the driver writer didn't write down why he 
used it.  

Thus I would suggest that the _p functions be deprecated, and if there 
needs to be a timing-delay after in/out instructions, define 
in_pause(port, nsec_delay) with an explicit delay.   And if the delay is 
dependent on bus speeds, define a bus-speed ratio calibration.

Thus in future driver writing, people will be forced to think clearly 
about what the timing characteristics of their device on its bus must 
be.   That presupposes that driver writers understand the timing 
issues.   If they do not, they should not be writing drivers.





