Return-Path: <linux-kernel-owner+w=401wt.eu-S1756814AbXL3Smw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756814AbXL3Smw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 13:42:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753530AbXL3Smq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 13:42:46 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56777 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753119AbXL3Smp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 13:42:45 -0500
Date: Sun, 30 Dec 2007 10:40:58 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Rene Herman <rene.herman@keyaccess.nl>
cc: Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       dpreed@reed.com, Islam Amer <pharon@gmail.com>, hpa@zytor.com,
       Pavel Machek <pavel@ucw.cz>, Ingo Molnar <mingo@redhat.com>,
       Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override
In-Reply-To: <4777BDA5.4050203@keyaccess.nl>
Message-ID: <alpine.LFD.1.00.0712301009220.32517@woody.linux-foundation.org>
References: <477711DC.5030800@keyaccess.nl> <alpine.LFD.1.00.0712300124440.32517@woody.linux-foundation.org> <20071230144700.78f4605c@the-village.bc.nu> <20071230152835.GX16946@elte.hu> <4777BDA5.4050203@keyaccess.nl>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 30 Dec 2007, Rene Herman wrote:
> 
> rene@7ixe4:~/src/port80$ su -c ./port80
> cycles: out 2400, in 2401
> rene@7ixe4:~/src/port80$ su -c ./port3cc
> cycles: out 459, in 394
> 
> As stated a few dozen times by now already, port 0x80 is _decidedly_ _non_
> _random_

Oh, I agree 100% that port 80 is not random. It's very much selected on 
purpose.

The reason we use port 80 is because it's commonly used as the BIOS POST 
debug port, which means that it's been a reasonable "safe" port to use, 
since nobody would be so crazy as to actually hook up a real device behind 
that port (and since it is below 0x100, it's also part of the "motherboard 
range", so you won't have any crazy plug-in devices either).

Pretty much all other ports in the low 256 bytes of IO have been used at 
some point or other, because people put special motherboard devices in and 
pick from the very limited list of open ports at random. So there are 
ports that are not commonly used (notably 0xB0-0xBF and 0xE0-0xEF), but 
they are quite often used for stuff like the magic Sony VAIO rocker-button 
devices etc.

So 0x80 _is_ special. We've been able to use it for 15+ years with 
basically nobody being so insane as to put an anything there.

However, I'd like to point out that the *timings* aren't special per se. 
The only reason you see such slow accesses to port 80 is not because port 
80 is special from a timing standpoint, but because it falls under the 
heading of "no device wanted to accept the access", and it wasn't decoded 
by any bridge or device. So it hits the "access timed out" case, which is 
just about the slowest access you can have.

But that does't mean that other ports won't have the same timings. Also, 
it doesn't mean that we really need to have exactly *those* timings.

But yes, the timeout timing is pretty convenient, because it's basically 
almost universally always going to take one microsecond to time out, 
regardless of speed of CPU. It's been impressively stable over the years. 

But do we *need* it that stable? It probably would be perfectly fine to 
pick something that gets faster with CPU's getting faster, because it's 
generally only really old devices that need that delay in the first place. 

In other words, the really *traditional* delay is not to do an IO port 
access at all, but to just do two short unconditional jumps. That was 
enough of a slowdown on the old machines, and the old machines are likely 
the only machines that really care about or want the slowdown in the first 
place!

In other words, what I'm trying to say is:

 - yes, "port 80" is very much special

 - yes, the timings on any port that is unconnected (or connected to some 
   interal ISA bus like the LPC often is) have been impressively stable 
   over the years at about 1us.

 - but no, I don't think we really need those special timings. The fact 
   is, hardware manufacturers have been *so* careful about backwards 
   compatibility, that they generally made sure that the "two short jumps" 
   delay (which is no delay at all these days!) _also_ continued working.

I also think that the worries about PCI write posting are unnecessary. IO 
port accesses (ie a regular "inb()" and "outb()" even _without_ the "_p()" 
format slowdown) are already synchronous not only by the CPU but by all 
chipsets. That's why that "outb" to port 0x80 takes a microsecond: because 
unlike a MMIO write, it's not only synchronous all the way to the chipset, 
it's even synchronous as far as the CPU core is concerned too (which is 
also why all high-performance devices avoid PIO like the plague).

So even if that "port 80" access will also cause PCI postings to be 
flushed, so would the actual IO access that accompanies it, so I don't 
think that is a very strong argument. 

With all that said: it is certainly possible that the 1us timing makes a 
difference on some machine, and it is certainly *also* theoretically 
possible that there is a buggy chipset that posts too much, and the port 
80 access might make a difference, but it's not all that likely, and I 
suspect we'd be better off handling those devices/drivers on a one-by-one 
basis as we find them.

			Linus
