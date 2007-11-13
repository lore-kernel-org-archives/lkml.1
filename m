Return-Path: <linux-kernel-owner+w=401wt.eu-S1760031AbXKMC2d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760031AbXKMC2d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 21:28:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755184AbXKMC2Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 21:28:25 -0500
Received: from nz-out-0506.google.com ([64.233.162.225]:36236 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754493AbXKMC2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 21:28:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=BeqI/fnWMJGq96x7t7r10Jry04D9Oj/4e3CitmVj0/C4c76pzGVlDCtbLOTbHEf9pRsqoXtvTFA7v/o1y1bRhYgTQOqCAlrmQAuYzg/ECHBLaN8huq7/4I8TJiB125aRxj8BvWUrsaw5nKYo3Sbp0uC1KL/MDjaYxtro2tiuEHs=
Message-ID: <f17812d70711121828k49fe25b4ycf538061d0fb33b4@mail.gmail.com>
Date: Tue, 13 Nov 2007 10:28:21 +0800
From: "eric miao" <eric.y.miao@gmail.com>
To: "David Brownell" <david-b@pacbell.net>
Subject: Re: [patch/rfc 1/4] GPIO implementation framework
Cc: "Linux Kernel list" <linux-kernel@vger.kernel.org>,
       "Felipe Balbi" <felipebalbi@users.sourceforge.net>,
       "Bill Gatliff" <bgat@billgatliff.com>,
       "Haavard Skinnemoen" <hskinnemoen@atmel.com>,
       "Andrew Victor" <andrew@sanpeople.com>,
       "Tony Lindgren" <tony@atomide.com>, "Jean Delvare" <khali@linux-fr.org>,
       "Kevin Hilman" <khilman@mvista.com>, "Paul Mundt" <lethal@linux-sh.org>,
       "Ben Dooks" <ben@trinity.fluff.org>
In-Reply-To: <200711051305.13980.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200710291809.29936.david-b@pacbell.net>
	 <200710291851.23821.david-b@pacbell.net>
	 <200711051305.13980.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

I hope I was not late giving my humble feedback on this framework :-)

Can we use "per gpio based" structure instead of "per gpio_chip" based one,
just like what the generic IRQ layer is doing nowadays? So that

a. you don't have to declare per gpio_chip "can_sleep", "is_out" and
"requested".
Those will be just bits of properties of a single GPIO.

b. and furthur more, one can avoid the use of ARCH_GPIOS_PER_CHIP, which
leads to many holes

c. gpio_to_chip() will be made easy and straight forward

d. granularity of spin_lock()/_unlock() can be made small (per GPIO instead of
per gpio_chip)

What do you think?

- eric

On Nov 6, 2007 5:05 AM, David Brownell <david-b@pacbell.net> wrote:
> On Monday 29 October 2007, David Brownell wrote:
> >
> > Provides new implementation infrastructure that platforms may choose to use
> > when implementing the GPIO programming interface. Platforms can update their
> > GPIO support to use this. The downside is slower access to non-inlined GPIOs;
> > rarely a problem except when bitbanging some protocol.
>
> I was asked just what that overhead *is* ... and it surprised me.
> A summary of the results is appended to this note.
>
> Fortuntely it turns out those problems all go away if the gpiolib
> code uses a *raw* spinlock to guard its table lookups.  With a raw
> spinlock, any performance impact of gpiolib seems to be well under
> a microsecond in this bitbang context (and not objectionable).
> Preempt became free; enabling debug options had only a minor cost.
>
> That's as it should be, since the only substantive changes were to
> grab and release a lock, do one table lookup a bit differently, and
> add one indirection function call ... changes which should not have
> any visible performance impact on per-bit codepaths, and one might
> expect to cost on the order of one dozen instructions.
>
>
> So the next version of this code will include a few minor bugfixes,
> and will also use a raw spinlock to protect that table.  A raw lock
> seems appropriate there in any case, since non-sleeping GPIOs should
> be accessible from hardirq contexts even on RT kernels.
>
> If anyone has any strong arguments against using a raw spinlock
> to protect that table, it'd be nice to know them sooner rather
> than later.
>
> - Dave
>
>
> SUMMARY:
>
> Using the i2c-gpio driver on a preempt kernel with all the usual
> kernel debug options enabled, the per-bit times (*) went up in a
> bad way:  from about 6.4 usec/bit (original GPIO code on this board)
> up to about 11.2 usec/bit (just switching to gpiolib), which is
> well into "objectionable overhead" territory for bit access.
>
> Just enabling preempt shot the time up to 7.4 usec/bit ... which is
> also objectionable (it's all-the-time overhead that is clearly
> needless), but much less so.
>
> Converting the table lock to be a raw spinlock essentially removed
> all non-debug overheads.  It took enabling all those debug options
> plus internal gpiolib debugging overhead to get those times up to
> the 7.4 usec/bit that previously applied even with just preempt.
>
> (*) Those times being eyeballed medians; I didn't make time to find
>     a way to export a few thousand measurements from the tool and
>     do the math.  The typical range was +/- one usec.
>
>     The numbers include udelay() calls, so the relevant point is
>     the time *delta* attributable only to increased gpiolib costs,
>     not the base time (with udelays).  The delta probably reflects
>     on the order of four GPIO calls:  set two different bits, clear
>     one of them, and read it to make sure it cleared.
>
>
>
> > The upside is:
> >
> > * Providing two features which were "want to have (but OK to defer)" when
> > GPIO interfaces were first discussed in November 2006:
> >
> > -A "struct gpio_chip" to plug in GPIOs that aren't directly supported
> > by SOC platforms, but come from FPGAs or other multifunction devices
> > (like UCB-1x00 GPIOs).
> >
> > -Full support for message-based GPIO expanders, needing a gpio_chip
> > hookup; previous support for this part of the programming interface
> > was just stubs. (One example: the widely used pcf8574 I2C chips,
> > with 8 GPIOs each.)
> >
> > * Including a non-stub implementation of the gpio_{request,free}() calls,
> > which makes those calls much more useful. The diagnostic labels are
> > also recorded given DEBUG_FS, so /sys/kernel/debug/gpio can show a
> > snapshot of all GPIOs known to this infrastructure.
> >
> > The driver programming interfaces introduced in 2.6.21 do not change at all;
> > this new infrastructure is entirely below the covers.
>
>
>



-- 
Cheers
- eric
