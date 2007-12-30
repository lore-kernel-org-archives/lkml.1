Return-Path: <linux-kernel-owner+w=401wt.eu-S1757632AbXL3QCW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757632AbXL3QCW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 11:02:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756109AbXL3QCM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 11:02:12 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:48978 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752885AbXL3QCL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 11:02:11 -0500
Date: Sun, 30 Dec 2007 17:01:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Rene Herman <rene.herman@keyaccess.nl>, dpreed@reed.com,
       Islam Amer <pharon@gmail.com>, hpa@zytor.com,
       Pavel Machek <pavel@ucw.cz>, Ingo Molnar <mingo@redhat.com>,
       Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override
Message-ID: <20071230160132.GA14311@elte.hu>
References: <477711DC.5030800@keyaccess.nl> <alpine.LFD.1.00.0712300124440.32517@woody.linux-foundation.org> <20071230144700.78f4605c@the-village.bc.nu> <20071230152835.GX16946@elte.hu> <20071230153818.1a554a7e@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071230153818.1a554a7e@the-village.bc.nu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > i dont get your last point. Firstly, we do an "outb $0x80" not an 
> > inb.
> 
> outb not inb sorry yes
> 
> > Secondly, outb $0x80 has no PCI posting side-effects AFAICS. 
> > Thirdly,
> 
> It does. The last mmio write cycle to the bridge gets pushed out 
> before the 0x80 cycle goes to the PCI bridge, times out and goes to 
> the LPC bus.

ok. Is it more of a "gets flushed due to timing out", or a 
specified-for-sure POST flushing property of all out 0x80 cycles going 
to the PCI bridge? I thought PCI posting policy is up to the CPU, it can 
delay PCI space writes arbitrarily (within reasonable timeouts) as long 
as no read is done from the _same_ IO space address. Note that the port 
0x80 cycle is neither a read, nor for the same address.

> I still don't believe any of our _p users in PCI space are actually 
> real - but someone needs to look at the scsi ones.

i'm wondering, how safe would it be to just dumbly replace outb_p() 
with:

	out(port);
	in(port);

in these drivers. Side-effects of inb() would not be unheard of for the 
ancient IO ports, but for even relatively old SCSI hardware, would that 
really be a problem?

this would give us explicit PCI posting.

> > even assuming that it has PCI posting side-effects, how can any locking 
> > error be covered up by an outb 0x80 sticking together with the inb it 
> > does before it? The sequence we emit is:
> > 
> >   inbb $some_port
> >   outb $0x80
> > 
> > and i see that the likelyhood of getting such sequences from two CPUs 
> > 'mixed up' are low, but how can this have any smp locking side-effects? 
> > How can this provide any workaround/coverup?
> 
> We issue inb port
> We issue outb 0x80
> 
> The CPU core stalls and the LPC bus stalls
> 
> On the other CPU we issue another access to the LPC bus because our 
> locking is wrong. With the 0x80 outb use this stalls so the delay is 
> applied unless the two inb's occur perfectly in time. With a udelay() 
> the udelay can be split and we get a second access which breaks the 
> needed device delay. We end up relying on the bus locking non 
> splitting properties of the 0x80 port access to paper over bugs - see 
> the watchdog fix example I sent you about a week ago.

ah, i understand. So i guess a stupid udelay_serialized() which takes a 
global spinlock would solve these sort of races? But i guess making them 
more likely to trigger would lead to a better kernel in the end ...

> > do you have any memories about the outb_p() use of misc_32.c:
> > 
> >         pos = (x + cols * y) * 2;       /* Update cursor position */
> >         outb_p(14, vidport);
> >         outb_p(0xff & (pos >> 9), vidport+1);
> >         outb_p(15, vidport);
> >         outb_p(0xff & (pos >> 1), vidport+1);
> > 
> > was this ever needed? This is so early in the bootup that can we cannot 
> 
> None - but we don't care. The problems with 0x80 and the wacko HP 
> systems occur once ACPI is enabled so we are fine using 0x80. I don't 
> myself know why the _p versions ended up being used. A rummage through 
> archives found me nothing useful on this but notes that outb not outw 
> is required for some devices.
> 
> For that matter does anyone actually have video cards old enough for 
> us to care actually still in use with Linux today ?

we had port 0x80 removal patches floating in the past decade, and i'm 
sure if it broke anything for sure we'd know about it. It was always 
this "general scope impact" property of it that scared us away from 
doing it - but we'll do the plunge in v2.6.25 and make io_delay=udelay 
the default, hm? Thomas has a real 386DX system, if that doesnt break 
then nothing would i guess ;-) We wont forget about needed PCI posting 
driver fixups either because the _p() API use would still be in place. 
By 2.6.26 we could remove all of them.

	Ingo
