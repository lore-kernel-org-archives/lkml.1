Return-Path: <linux-kernel-owner+w=401wt.eu-S1752051AbYLWRYs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752051AbYLWRYs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 12:24:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751214AbYLWRYj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 12:24:39 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:57216 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193AbYLWRYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 12:24:38 -0500
Date: Tue, 23 Dec 2008 18:26:10 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Ken Chen <kenchen@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       sparclinux <sparclinux@vger.kernel.org>, mingo@elte.hu,
       sfr@canb.auug.org.au, linux-kernel@vger.kernel.org, paulus@samba.org,
       tglx@linutronix.de, hpa@zytor.com, linux-next@vger.kernel.org
Subject: Re: [PATCH] sparc64: use unsigned long long for u64
Message-ID: <20081223172610.GA5957@uranus.ravnborg.org>
References: <20081222152247.b934ed5b.sfr@canb.auug.org.au> <b040c32a0812212249p45aba306tbb68a960b79cd0ee@mail.gmail.com> <20081222070426.GD29160@elte.hu> <20081222181932.5dd9514e.sfr@canb.auug.org.au> <20081222080341.GA18897@elte.hu> <20081222144319.1bfc0061.akpm@linux-foundation.org> <20081222230035.GB4074@uranus.ravnborg.org> <20081222151338.3b6ef997.akpm@linux-foundation.org> <20081223131746.GA7456@uranus.ravnborg.org> <b040c32a0812230905q3a257163r35373b0cb50df35c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b040c32a0812230905q3a257163r35373b0cb50df35c@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 23, 2008 at 09:05:44AM -0800, Ken Chen wrote:
> On Tue, Dec 23, 2008 at 5:17 AM, Sam Ravnborg <sam@ravnborg.org> wrote:
> > Andrew Morton wrote:
> >
> >    People keep on doing
> >
> >            printk("%llu", some_u64);
> >
> >    testing it only on x86_64 and this generates a warning storm on
> >    powerpc, sparc64, etc.  Because they use `long', not `long long'.
> >
> >    Quite a few 64-bit architectures are using `long' for their
> >    s64/u64 types.  We should convert them all to `long long'.
> >
> > Update types.h so we use unsigned long long for u64 and
> > fix all warnings in sparc64 code.
> > Tested with an allnoconfig, defconfig and allmodconfig builds.
> >
> > This patch introduces additional warnings in several drivers.
> > These will be dealt with in separate patches.
> >
> > Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > ---
> >
> > It may take a few days before the drivers gets fixed.
> > Christmas is approaching fast by now.
> >
> >        Sam
> >
> > diff --git a/arch/sparc/include/asm/timer_64.h b/arch/sparc/include/asm/timer_64.h
> > index 5b779fd..ef3c368 100644
> > --- a/arch/sparc/include/asm/timer_64.h
> > +++ b/arch/sparc/include/asm/timer_64.h
> > @@ -10,7 +10,7 @@
> >  #include <linux/init.h>
> >
> >  struct sparc64_tick_ops {
> > -       unsigned long (*get_tick)(void);
> > +       unsigned long long (*get_tick)(void);
> 
> wait, why does this need to be changed?

We have:
        clocksource_tick.read = tick_ops->get_tick;

And clocksource_tick is of type clocksource:

struct clocksource {
	...
        cycle_t (*read)(void);

And cycle_t is:
/* clocksource cycle base type */
typedef u64 cycle_t;

And u64 is now:
unsigned long long - thus we need to fix prototype
of get_tick to fix the warnings.

A cast could do it - but fixing the real problem
is better here.

	Sam
