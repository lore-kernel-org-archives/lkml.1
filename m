Return-Path: <linux-kernel-owner+w=401wt.eu-S1754284AbXKNIiP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754284AbXKNIiP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 03:38:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751787AbXKNIiB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 03:38:01 -0500
Received: from smtp115.sbc.mail.sp1.yahoo.com ([69.147.64.88]:46952 "HELO
	smtp115.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751501AbXKNIiA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 03:38:00 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=mpKRFIlycmGuANE2TjSZdbuuDndNsok2wQkTe6Ad9RB4OBZYO30EAmUCqCOobcJRlAc3gLTXlLRIduHmqA7qjMIKjJfVaok0iUvHEE/xdPrACf0aNCkUhdoBsB+ng5E0v45kJ/x70nF0yhYNP3OhQJenAtfO7+Hp2Colfi01LEg=  ;
X-YMail-OSG: sZ24jR0VM1lI2Rw.Ikx3YK2B5T__6LcZripXu10Q8FXyO6qIMQyw_clchLzefisvla6Bit38dA--
From: David Brownell <david-b@pacbell.net>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [patch 2.6.24-rc2 1/3] generic gpio -- gpio_chip support
Date: Wed, 14 Nov 2007 00:20:46 -0800
User-Agent: KMail/1.9.6
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Florian Fainelli <florian.fainelli@telecomint.eu>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
References: <200711091136.20051.david-b@pacbell.net> <200711131122.45950.david-b@pacbell.net> <200711132325.53846.nickpiggin@yahoo.com.au>
In-Reply-To: <200711132325.53846.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711140020.46764.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 November 2007, Nick Piggin wrote:
> > > > I'd be happy if, as originally presented, it were possible to just
> > > > pass a raw_spinlock_t to spin_lock_irqsave() and friends.
> > >
> > > that's a spinlock type abstraction of PREEMPT_RT, not of mainline.
> 
> Even when you're talking about the -rt tree, I suspect you really
> shouldn't be using raw spinlocks, right?

That's one subject of discussion here.  I got the expected
knee-jerk responses (saying just that) -- right, ignore those
and aim for ones that look at the actual issues.


> I mean, if you have a 
> timing critical operation, then you should ensure you have priorities
> set correctly so that you simply don't get preempted.

Which is why bitops like <asm-generic/bitops/atomic.h> use
normal spinlocks.  Oh, wait, no they don't ...


Today, platform GPIO logic has no preemption points.

There are a few dozen implementations in the tree, not all
using the generic calls (yet!), none radically different.

Certainly when gpio_set_value() is inlined, it works very
much like set_bit()/clear_bit() on hardware with atomic ops.
Not a preemption point

But it often turns into a function call that needs to map
from GPIO number to GPIO bank, and then to a bitslice through
that bank's registers.  I know of only one platform which
even has any locking on those code paths(*) ... so again
those calls aren't preemption points.


> By using a raw_spinlock_t, you're saying that you're more important
> than anyone else (for the period of the critical section) including
> processes which the user has explicitly set to a higher priority.

Nope.  Just saying that the relevant instructions (three, in the
hot path I looked at, and not a case where priority inversion
scenarios should be a concern) shouldn't be forcibly morphed into
preemption points.  Any more than other bitops were (not).

If a higher priority task needs that CPU, nothing prevents it
from being immediately descheduled.  Ditto handling a hardirq.

All this does is prevent constant and needless checking for
"do you want to preempt me now?" "now?" "now?" in "now?" the
middle "now?" of "now?" i/o "now?" loops.


> > Any reason that stuff shouldn't move into mainline?
> 
> This sort of raw_spinlock_t arms race throughout drivers/ would be
> a huge reason not to move it into mainline.

This isn't driver code...

I think you've just presented an argument why that stuff
shouldn't really exist in -rt either... :)

- Dave

(*)  Exception, arch/arm/plat-omap/gpio.c uses spinlocks.
     Maybe I should say "misuses"; ISTR getting various
     lockdep complaints about the same spinlock being used
     both from IRQ and non-IRQ contexts.  In some common
     cases that lock could probably be eliminated, but
     if you look at the code you'll know why nobody's much
     wanted to clean it up.


