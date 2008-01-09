Return-Path: <linux-kernel-owner+w=401wt.eu-S1753381AbYAIFbJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381AbYAIFbJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 00:31:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750798AbYAIFa4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 00:30:56 -0500
Received: from 2-1-3-15a.ens.sth.bostream.se ([82.182.31.214]:54252 "EHLO
	zoo.weinigel.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718AbYAIFaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 00:30:55 -0500
Date: Wed, 9 Jan 2008 06:30:52 +0100
From: Christer Weinigel <christer@weinigel.se>
To: Zachary Amsden <zach@vmware.com>
Cc: "David P. Reed" <dpreed@reed.com>, Avi Kivity <avi@quramnet.com>,
       Ondrej Zary <linux@rainbow-software.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Rene Herman <rene.herman@keyaccess.nl>, Bodo Eggert <7eggert@gmx.de>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Paul Rolland <rol@as2917.net>, Pavel Machek <pavel@ucw.cz>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>, rol <rol@witbe.net>
Subject: Re: [linux-kernel] Re: [PATCH] x86: provide a DMI based port 0x80
 I/O delay override.
Message-ID: <20080109063052.48a5709c@weinigel.se>
In-Reply-To: <1199847162.7369.323.camel@bodhitayantram.eng.vmware.com>
References: <9BdU5-1YW-9@gated-at.bofh.it>
	<200801081810.58904.linux@rainbow-software.org>
	<4783B1B2.6070005@reed.com>
	<200801081838.16241.linux@rainbow-software.org>
	<4783C4A6.9060402@reed.com>
	<20080108185120.3ff7ed18@lxorguk.ukuu.org.uk>
	<4783CBD9.7020709@reed.com>
	<1199847162.7369.323.camel@bodhitayantram.eng.vmware.com>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 08 Jan 2008 18:52:42 -0800
Zachary Amsden <zach@vmware.com> wrote:

> On Tue, 2008-01-08 at 14:15 -0500, David P. Reed wrote:
> > Alan Cox wrote:
> > > The natsemi docs here say otherwise. I trust them not you.
> > >   
> > As well you should. I am honestly curious (for my own satisfaction)
> > as to what the natsemi docs say the delay code should do  (can't
> > imagine they say "use io port 80 because it is unused").  I don't
> > have any 
> 
> What is the outcome of this thread?  Are we going to use timing based
> port delays, or can we finally drop these things entirely on 64-bit
> architectures?
> 
> I a have a doubly vested interest in this, both as the owner of an
> affected HP dv9210us laptop and as a maintainer of paravirt code - and
> would like 64-bit Linux code to stop using I/O to port 0x80 in both
> cases (as I suspect would every other person involved with
> virtualization).
> 
> I've tried to follow this thread, but with all the jabs, 1-ups, and
> obscure legacy hardware pageantry going on, it isn't clear what we're
> really doing.

I belive Alan Cox is doing a review of some drivers, to see if they
actually need the I/O port delay.  A lot of drivers probably use outb_p
just because it was copy-pasted from some other driver and it can be
removed.  Alan's review has also brought to light a lack of locking in
some drivers, so I think Alan has been adding proper locking to some of
the watchdog drivers.

Most old ISA only device drivers can keep using OUT 80h.  They are not
used on modern machines and it's better to keep them unchanged to avoid
unneccesary incompatibilities.

As far as I know, the 8253 PIT timer code needs outb_p on some older
platform, and this is one of the most troublesome since the same PIT
controller (or a register compatible one) has been used since the
original IBM PC, and it is frequently executed code.  Ingo Molnar has
done an alternate implementation of the PIT clock source which uses
udelay instead of OUT 80h to delay accesses to the ports. The kernel
could make a choice of which variant to use based on the DMI year, if
compiling for x86_64, or something similar.  Maybe have a command line
option too.

The keyboard controller on some platform needs the delay, and the same
driver is used on both ancient and modern systems, I think it can be
changed to udelay since it's not so time critical code.

The 8259 interrupt controller on some platform needs the delay, I think
it can be changed to udelay since it's only some setup code that uses
outb_p.  I guess there are time critical accesses to the interrupt
controller from assembly code somewhere to acknowledge interrupts, and
that code needs a review.

The floppy controller code uses outb_p.  Even though there might be
floppy controllers on modern systems, I'd rather leave the floppy code
alone since it's supposed to be very fragile.  If you still use
floppies you deserve what you get.

Some specific drivers, such as drivers for 8390 or 8390 clone based
network cards are also a bit troublesome, they do need outb_p (and
the delay for the original 8390 chip is specified in bus cycles), and
there can be a big performance loss if pessimistic udelays are used for
the delay.  There are still a bunch of PCMCIA cards based on that chip
which means that those cards can be used with modern machines.  There
are also PCI and memory mapped variants of the 8390, some of them new
designs which are only register compatible, some other designs are
using a real 8390 with a FPGA used as glue logic. I think Alan
suggested compiling two versions of that driver, one with OUT 80h, and
one with udelay.  Old machines can choose the old driver, and new
machines can use the new one.  Other drivers can probably do the same
thing, or if not time critical, always use a pessimistic udelay.

As for the implementation, I like the suggestion to split outb_b into
two calls, one to outb and one to isa_slow_down_io.  It makes it very
obvious that it is really two function calls, and that it needs
locking.  For those uses that are not ISA port accesses,
isa_slow_down_io should be changed to an appropriate udelay instead.

The goal is anyway that a modern machine should not do OUT 80h, and old
machines keep doing it since it has been working well for some 15-odd
years, both in DOS device drivers and on Linux.  Using an alternate
port may be a workaround, but it's probaby not a good idea since
alternate ports have received less testing and there's bound to be some
platform out there that has problems with any alternate port we
might choose.  Allowing an alternate port will also add code bloat
(OUT 80h, AL becomes MOV DX, alternate_port; OUT DX, AL) for a
dubious gain.

Did I miss anyting?

  /Christer
