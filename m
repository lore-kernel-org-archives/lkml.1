Return-Path: <linux-kernel-owner+w=401wt.eu-S1759215AbXLaBEW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759215AbXLaBEW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 20:04:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759018AbXLaBEG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 20:04:06 -0500
Received: from mho-02-bos.mailhop.org ([63.208.196.179]:58647 "EHLO
	mho-02-bos.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758902AbXLaBED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 20:04:03 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 216.15.117.105
X-Report-Abuse-To: abuse@dyndns.com (see http://www.mailhop.org/outbound/abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/ESNjDOo0U9KgA/gefkfhr
Message-ID: <47783FFD.3070302@reed.com>
Date: Sun, 30 Dec 2007 20:03:57 -0500
From: "David P. Reed" <dpreed@reed.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.9) Gecko/20071115 Fedora/2.0.0.9-1.fc8 Thunderbird/2.0.0.9 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Juergen Beisert <juergen127@kreuzholzen.de>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Rene Herman <rene.herman@keyaccess.nl>, Islam Amer <pharon@gmail.com>,
       Pavel Machek <pavel@ucw.cz>, Ingo Molnar <mingo@redhat.com>,
       Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override
References: <477711DC.5030800@keyaccess.nl> <20071230152835.GX16946@elte.hu> <20071230153818.1a554a7e@the-village.bc.nu> <200712301810.59790.juergen127@kreuzholzen.de> <47780480.7060701@zytor.com>
In-Reply-To: <47780480.7060701@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



H. Peter Anvin wrote:
> Now, I think there is a specific reason to believe that EGA/VGA (but 
> perhaps not CGA/MDA) didn't need these kinds of hacks: the video cards 
> of the day was touched, directly, by an interminable number of DOS 
> applications.  CGA/MDA generally *were not*, due to the unsynchronized 
> memory of the original versions (writing could cause snow), so most 
> applications tended to fall back to using the BIOS access methods for 
> CGA and MDA.
>
A little history... not that it really matters, but some might be 
interested in a 55-year-old hacker's sentimental recollections...As 
someone who actually wrote drivers for CGA and MDA on the original IBM 
PC, I can tell you that back to back I/O *port* writes and reads were 
perfectly fine.  The "snow" problem had nothing to do with I/O ports.  
It had to do with the memory on the CGA adapter card not being dual 
ported, and in high-res (80x25) character mode (only!) a CPU read or 
write access caused a read of the adapter memory by the 
character-generator to fail, causing one character-position of the 
current scanline being output to get all random bits, which was then put 
through the character-generator and generated whatever the character 
generator did with 8 random bits of character or attributes as an index 
into the character generator's font table.

In particular, the solution in both the BIOS and in Visicalc, 1-2-3, and 
other products that did NOT use the BIOS or DOS for I/O to the CGA or 
MDA because they were Dog Slow, was to detect the CGA, and do a *very* 
tight loop doing "inb" instructions from one of the CGA status 
registers, looking for a 0-1 transition on the horizontal retrace flag.  
It would then do a write to display memory with all interrupts locked 
out, because that was all it could do during the horizontal retrace, 
given the speed of the processor.  One of the hacks I did in those days 
(I wrote the CGA driver for Visicalc Advanced Version and several other 
Software Arts programs, some of which were sold to Lotus when they 
bought our assets, and hired me, in 1985) was to measure the "horizontal 
retrace time" and the "vertical blanking interval" when the program 
started, and compile screen-writing code that squeezed as many writes as 
possible into both horizontal retraces and vertical retraces.   That was 
actually a "selling point" for spreadsheets - the reviewers actually 
measured whether you could use the down-arrow key in auto-repeat mode 
and keep the screen scrolling at the relevant rate!  That was hard on an 
8088 or 80286 processor, with a CGA card.

It was great when EGA and VGA came out, but we still had to support the 
CGA long after.  Which is why I fully understand the need not to break 
old machines.  We had to run on every machine that was claimed to be "PC 
compatible" - many of which were hardly so compatible  (the PS/2 model 
50 had a completely erroneous serial chip that claimed to emulate the 
original 8250, but had an immense pile of bugs, for example, that IBM 
begged ISVs to call a software problem and fix so they didn't get sued).

The IBM PC bus (predecessor of the current ISA bus, which came from the 
PC-AT's 16-bit bus), did just fine electrically - any I/O port-specific 
timing problems had to do with the timing of the chips attached to the 
bus.  For example, if a bus write to a port was routed into a particular 
chip, the timing of that chip's subsequent processing might be such that 
it was not ready to respond to another read or write.)  That's not a 
"signalling" problem - it has nothing to do with capacitance on the bus, 
e.g., but a functional speed problem in the chip (if on the motherboard) 
or the adapter card.

Rant off.  This has nothing, of course, to do with present issues.
