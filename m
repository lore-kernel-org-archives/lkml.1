Return-Path: <linux-kernel-owner+w=401wt.eu-S1757682AbXL3PsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757682AbXL3PsS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 10:48:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753071AbXL3PsJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 10:48:09 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:33717 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751588AbXL3PsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 10:48:08 -0500
Date: Sun, 30 Dec 2007 15:38:18 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Rene Herman <rene.herman@keyaccess.nl>, dpreed@reed.com,
       Islam Amer <pharon@gmail.com>, hpa@zytor.com,
       Pavel Machek <pavel@ucw.cz>, Ingo Molnar <mingo@redhat.com>,
       Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override
Message-ID: <20071230153818.1a554a7e@the-village.bc.nu>
In-Reply-To: <20071230152835.GX16946@elte.hu>
References: <477711DC.5030800@keyaccess.nl>
	<alpine.LFD.1.00.0712300124440.32517@woody.linux-foundation.org>
	<20071230144700.78f4605c@the-village.bc.nu>
	<20071230152835.GX16946@elte.hu>
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

> i dont get your last point. Firstly, we do an "outb $0x80" not an inb. 

outb not inb sorry yes

> Secondly, outb $0x80 has no PCI posting side-effects AFAICS. Thirdly, 

It does. The last mmio write cycle to the bridge gets pushed out before
the 0x80 cycle goes to the PCI bridge, times out and goes to the LPC bus.

I still don't believe any of our _p users in PCI space are actually real
- but someone needs to look at the scsi ones.

> even assuming that it has PCI posting side-effects, how can any locking 
> error be covered up by an outb 0x80 sticking together with the inb it 
> does before it? The sequence we emit is:
> 
>   inbb $some_port
>   outb $0x80
> 
> and i see that the likelyhood of getting such sequences from two CPUs 
> 'mixed up' are low, but how can this have any smp locking side-effects? 
> How can this provide any workaround/coverup?

We issue inb port
We issue outb 0x80

The CPU core stalls and the LPC bus stalls

On the other CPU we issue another access to the LPC bus because our
locking is wrong. With the 0x80 outb use this stalls so the delay is
applied unless the two inb's occur perfectly in time. With a udelay() the
udelay can be split and we get a second access which breaks the needed
device delay. We end up relying on the bus locking non splitting
properties of the 0x80 port access to paper over bugs - see the watchdog
fix example I sent you about a week ago.

That btw is another argument for removing 0x80 usage as much as possible
- its bad for real time.

> do you have any memories about the outb_p() use of misc_32.c:
> 
>         pos = (x + cols * y) * 2;       /* Update cursor position */
>         outb_p(14, vidport);
>         outb_p(0xff & (pos >> 9), vidport+1);
>         outb_p(15, vidport);
>         outb_p(0xff & (pos >> 1), vidport+1);
> 
> was this ever needed? This is so early in the bootup that can we cannot 

None - but we don't care. The problems with 0x80 and the wacko HP systems
occur once ACPI is enabled so we are fine using 0x80. I don't myself know
why the _p versions ended up being used. A rummage through archives found
me nothing useful on this but notes that outb not outw is required for
some devices.

For that matter does anyone actually have video cards old enough for us
to care actually still in use with Linux today ? 

Alan
