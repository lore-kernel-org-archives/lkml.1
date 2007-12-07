Return-Path: <linux-kernel-owner+w=401wt.eu-S1751883AbXLGFKc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751883AbXLGFKc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 00:10:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750820AbXLGFKY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 00:10:24 -0500
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:49385 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735AbXLGFKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 00:10:23 -0500
Message-ID: <4758D584.90105@keyaccess.nl>
Date: Fri, 07 Dec 2007 06:09:24 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: "David P. Reed" <dpreed@reed.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: RFC: outb 0x80 in inb_p, outb_p harmful on some modern AMD64
 with MCP51 laptops
References: <fa./27SNSh+L5T3iqFNPdHClEu+yT0@ifi.uio.no> <4758927F.50500@shaw.ca>
In-Reply-To: <4758927F.50500@shaw.ca>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07-12-07 01:23, Robert Hancock wrote:

> David P. Reed wrote:
>> After much, much testing (months, off and on, pursuing hypotheses), 
>> I've discovered that the use of "outb al,0x80" instructions to "delay" 
>> after inb and outb instructions causes solid freezes on my HP dv9000z 
>> laptop, when ACPI is enabled.
>>
>> It takes a fair number of out's to 0x80, but the hard freeze is 
>> reliably reproducible by writing a driver that solely does a loop of 
>> 50 outb's to 0x80 and calling it in a loop 1000 times from user 
>> space.  !!!
>>
>> The serious impact is that the /dev/rtc and /dev/nvram devices are 
>> very unreliable - thus "hwclock" freezes very reliably while looping 
>> waiting for a new second value and calling "cat /dev/nvram" in a loop 
>> freezes the machine if done a few times in a row.
>>
>> This is reproducible, but requires a fair number of outb's to the 0x80 
>> diagnostic port, and seems to require ACPI to be on.
>>
>> io_64.h is the source of these particular instructions, via the 
>> CMOS_READ and CMOS_WRITE macros, which are defined in mc146818_64.h.  
>> (I wonder if the same problem occurs in 32-bit mode).
>>
>> I'm happy to complete and test a patch, but I'm curious what the right 
>> approach ought to be.  I have to say I have no clue as to what ACPI is 
>> doing on this chipset  (nvidia MCP51) that would make port 80 do 
>> this.  A raw random guess is that something is logging POST codes, but 
>> if so, not clear what is problematic in ACPI mode.
>>
>> ANy help/suggestions?
>>
>> Changing the delay instruction sequence from the outb to short jumps 
>> might be the safe thing.  But Linus, et al. may have experience with 
>> that on other architectures like older Pentiums etc.
> 
> The fact that these "pausing" calls are needed in the first place seems 
> rather cheesy. If there's hardware that's unable to respond to IO port 
> writes as fast as possible, then surely there's a better solution than 
> trying to stall the IOs by an arbitrary and hardware-dependent amount of 
> time, like udelay calls, etc. Does any remotely recent hardware even 
> need this?

The idea is that the delay is not in fact hardware dependent. With in the 
the absense of a POST board port 0x80 being sort of guaranteeed to not be 
decoded on PCI but forwarded to and left to die on ISA/LPC one should get 
the effect that the _next_ write will have survived an ISA/LPC bus address 
cycle acknowledgement timeout.

I believe.

And no, I don't believe any remotely recent hardware needs it and have in 
fact wondered about it since actual 386 days, having since that time never 
found a device that wouldn't in fact take back to back I/O even. Even back 
then (ie, legacy only systems, no forwarding from PCI or anything) BIOSes 
provided ISA bus wait-state settings which should be involved in getting 
insanely stupid and old hardware to behave...

Port 0xed has been suggested as an alternate port. Probably not a great 
"fix" but if replacing the out with a simple udelay() isn't that simple 
(during early boot I gather) then it might at least be something for you to 
try. I'd hope that the 0x80 in include/asm/io.h:native_io_delay() would be 
the only one you are running into, so you could change that to 0xed and see 
what catches fire.

If there are no sensible fixes, an 0x80/0xed choice could I assume be hung 
of DMI or something (if that _is_ parsed soon enough).

Rene.
