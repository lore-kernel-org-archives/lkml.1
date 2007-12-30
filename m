Return-Path: <linux-kernel-owner+w=401wt.eu-S1754965AbXL3Sjr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754965AbXL3Sjr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 13:39:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752107AbXL3Sjh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 13:39:37 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:34149 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751868AbXL3Sjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 13:39:36 -0500
Date: Sun, 30 Dec 2007 18:29:37 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Rene Herman <rene.herman@keyaccess.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>, dpreed@reed.com,
       Islam Amer <pharon@gmail.com>, hpa@zytor.com,
       Pavel Machek <pavel@ucw.cz>, Ingo Molnar <mingo@redhat.com>,
       Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override
Message-ID: <20071230182937.40f2adcf@the-village.bc.nu>
In-Reply-To: <20071230170612.GA16502@elte.hu>
References: <477711DC.5030800@keyaccess.nl>
	<alpine.LFD.1.00.0712300124440.32517@woody.linux-foundation.org>
	<20071230144700.78f4605c@the-village.bc.nu>
	<20071230152835.GX16946@elte.hu>
	<4777BDA5.4050203@keyaccess.nl>
	<20071230160751.GB26221@elte.hu>
	<4777C6E8.7060202@keyaccess.nl>
	<20071230170612.GA16502@elte.hu>
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So the current plan is to go with an io_delay=udelay default in v2.6.25, 
> to give this a migration window, and io_delay=none in v2.6.26 [and a 
> complete removal of arch/x86/kernel/io_delay.c], once the _p() uses are 
> fixed up. This is gradual enough to notice any regressions we care about 
> and also makes it nicely bisectable and gradual.

You will break systems if you blindly go around disabling _p delays for
ISA and LPC bus devices. The DEC Hinote laptops for example are well
known for requiring the correct ISA and other keyboard controller delays.
I don't expect anyone to test with a hinote or see it until it hits
Debian or similar 'low resource' friendly devices.

A 2.6.26 plan for io_delay=none is very very foolish indeed. We don't burn
the processor manuals, overclock the CPU and use undefined behaviour
hacks, we shouldn't do the same for I/O devices. Your claim of
bisectability is also completely confused and wrong. If, for example, you
write to an SCC without delays then the chances are it will work most
times. Bisecting doesn't work for random timing dependant failures.

We have four categories of _p users

- Devices that don't need it -> Eliminate use
- Old Devices that do need it -> Codify use and fix locking
- Legacy Devices that we don't need to use on modern systems -> Avoid use
- Devices that sometimes need it -> Evaluate options

There is absolutely no point in breaking, overclocking and introducing
random unreliabilities (that may be stepping or even device instance
specific) into device drivers. Quite the reverse in fact - the way to
drive out _p misuse for debugging is to make it *very* visible. An
io_delay=debug which beeps the keyboard buzzer each _p access will be
most informative and lead to far better and correct debugging.

The components in question for the typical user of a modern system are:
	ISA DMA controller (doesn't get used)
	Keyboard interface (notoriously sensitive to timing, going USB)
	PIC (use the APIC instead)
	Legacy Timers (use the newer timers instead)
	CMOS (slow as **** anyway so udelay 2 doesn't matter)
	Floppy (dying out and slow anyway)

So there is nothing to gain from going with "No delay" and everything to
lose. What we actually want to do is to make it as visible as possible so
we can avoid it whenever possible.

Alan
