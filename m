Return-Path: <linux-kernel-owner+w=401wt.eu-S1762741AbXKMTG0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762741AbXKMTG0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 14:06:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756214AbXKMTGQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 14:06:16 -0500
Received: from smtp112.sbc.mail.mud.yahoo.com ([68.142.198.211]:26845 "HELO
	smtp112.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753678AbXKMTGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 14:06:15 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=UL7ZeaUgBCqpT3Rb3FwSnz5Pz1r706GK6aNzJEXakcokw2An8hWIsYpU6Hfdcs7ud1wIE2K02/IByfg1gWxBE4B4sXAbgOzkxj8DzvmBFBjXiNJGBbTS7SiL8Cc/CSssP2Tj8OSlxugyyqB99AFBWPsNsTPIGriYTd717MXtmlg=  ;
X-YMail-OSG: v19LP2sVM1mfZyg2l2Ioq6TRJlxDd_8QKhQB9Hh6PfIBhInKiZAQpldXuiC6UaQRWpdL040VsA--
From: David Brownell <david-b@pacbell.net>
To: "eric miao" <eric.y.miao@gmail.com>
Subject: Re: [patch/rfc 1/4] GPIO implementation framework
Date: Tue, 13 Nov 2007 11:06:10 -0800
User-Agent: KMail/1.9.6
Cc: "Linux Kernel list" <linux-kernel@vger.kernel.org>,
       "Felipe Balbi" <felipebalbi@users.sourceforge.net>,
       "Bill Gatliff" <bgat@billgatliff.com>,
       "Haavard Skinnemoen" <hskinnemoen@atmel.com>,
       "Andrew Victor" <andrew@sanpeople.com>,
       "Tony Lindgren" <tony@atomide.com>, "Jean Delvare" <khali@linux-fr.org>,
       "Kevin Hilman" <khilman@mvista.com>, "Paul Mundt" <lethal@linux-sh.org>,
       "Ben Dooks" <ben@trinity.fluff.org>
References: <200710291809.29936.david-b@pacbell.net> <200711051305.13980.david-b@pacbell.net> <f17812d70711121828k49fe25b4ycf538061d0fb33b4@mail.gmail.com>
In-Reply-To: <f17812d70711121828k49fe25b4ycf538061d0fb33b4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711131106.11277.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 November 2007, eric miao wrote:
> Hi David,
> 
> I hope I was not late giving my humble feedback on this framework :-)
> 
> Can we use "per gpio based" structure instead of "per gpio_chip" based one,
> just like what the generic IRQ layer is doing nowadays?

We "can" do most anything.  What would that improve though?

Each irq_chip handles multiple IRQs ... just like this patch
has each gpio_chip handling multiple GPIOs.  (Not that I think
GPIO code should closely model IRQ code; they need to address
very different problems.)

I can't tell what you intend to suggest as a "per-GPIO" data
structure; since I can think of at least three different ways
to do such a thing, you should be more concrete.  I'd think it
should be in *addition* to a gpio_chip structure though.


> So that 
> 
> a. you don't have to declare per gpio_chip "can_sleep", "is_out" and
> "requested".
> Those will be just bits of properties of a single GPIO.

The can_sleep value is a per-controller thing.  The other bits are
indeed per-GPIO.

So do you mean a structure with two bits, plus a pointer to a
gpio_chip, plus likely other stuff (what?) to make it work?
What would the hot-path costs be (for getting/setting values of
an on-chip GPIO)?


> b. and furthur more, one can avoid the use of ARCH_GPIOS_PER_CHIP, which
> leads to many holes

Why should holes (in the GPIO number sequence) be a problem?  In
this code, they don't cost much space at all.  They'd cost more
if there were a per-GPIO structure though...

The only downside of GPIOS_PER_CHIP that I know of right now
is that it complicates mixing gpio bank sizes; it's a ceiling,
some controllers would allocate more than they need.  The
upside of that is efficiency, and a closer match to how
underlying hardware works.

Of course, GPIOS_PER_CHIP *could* be decoupled from how the
table of gpio_chip pointers is managed.  If the table were to
group GPIOs in units of 8, a gpio_chip with 32 GPIOs could
take four adjacent entries while an 8-bit GPIO expander could
take just one.  That'd be a very easy patch, supporting a more
dense allocation of GPIO numbers... although it would increase
static memory consumption by typically NR_GPIOS/4 pointers.


> c. gpio_to_chip() will be made easy and straight forward

I'd say "return chips[gpio / ARCH_GPIOS_PER_CHIP]" already meets
both criteria!

There's also "efficient" to consider; this way doesn't cost much
memory or add levels of indirection (compared to most platforms,
which already use a similar array).


> d. granularity of spin_lock()/_unlock() can be made small
> (per GPIO instead of per gpio_chip)

Why would per-GPIO locking be needed though?  Look again...

The locking is there fundamentally because gpio_chip structures
may need to be unregistered; that's not a per-gpio issue.
Even when a gpio is marked in chip->requested under that lock,
that's part of ensuring that the unregistration is prevented so
long as the GPIO is in active use.

Plus, fine grained locking is rarely a good idea; it normally
increases locking overhead by involving multiple locks.  Only
add extra locks if a single lock sees too much contention; and
even then, only if that contention can't be removed by using a
smarter design.

- Dave



> What do you think?
> 
> - eric
> 
> On Nov 6, 2007 5:05 AM, David Brownell <david-b@pacbell.net> wrote:
> > On Monday 29 October 2007, David Brownell wrote:
> > >
> > > Provides new implementation infrastructure that platforms may choose to use
> > > when implementing the GPIO programming interface. Platforms can update their
> > > GPIO support to use this. The downside is slower access to non-inlined GPIOs;
> > > rarely a problem except when bitbanging some protocol.
> >
> > I was asked just what that overhead *is* ... and it surprised me.
> > A summary of the results is appended to this note.
> >
> > Fortuntely it turns out those problems all go away if the gpiolib
> > code uses a *raw* spinlock to guard its table lookups.  With a raw
> > spinlock, any performance impact of gpiolib seems to be well under
> > a microsecond in this bitbang context (and not objectionable).
> > Preempt became free; enabling debug options had only a minor cost.
> >
> > That's as it should be, since the only substantive changes were to
> > grab and release a lock, do one table lookup a bit differently, and
> > add one indirection function call ... changes which should not have
> > any visible performance impact on per-bit codepaths, and one might
> > expect to cost on the order of one dozen instructions.
> >
> >
> > So the next version of this code will include a few minor bugfixes,
> > and will also use a raw spinlock to protect that table.  A raw lock
> > seems appropriate there in any case, since non-sleeping GPIOs should
> > be accessible from hardirq contexts even on RT kernels.
> >
> > If anyone has any strong arguments against using a raw spinlock
> > to protect that table, it'd be nice to know them sooner rather
> > than later.
> >
> > - Dave
> >
> 
