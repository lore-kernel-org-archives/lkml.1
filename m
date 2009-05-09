Return-Path: <linux-kernel-owner+w=401wt.eu-S1751559AbZEIEGQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751559AbZEIEGQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 00:06:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750807AbZEIEF7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 00:05:59 -0400
Received: from ppp121-45-82-25.lns10.adl6.internode.on.net ([121.45.82.25]:39083
	"EHLO homer.shelbyville.oz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750760AbZEIEF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 00:05:59 -0400
Date: Sat, 9 May 2009 13:35:37 +0930
From: Ron <ron@debian.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mingo@elte.hu, a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix for sched_clock() when using jiffies
Message-ID: <20090509040537.GA5417@homer.shelbyville.oz>
References: <20081126150645.GA28153@homer.shelbyville.oz> <1227712598.4454.199.camel@twins> <20081126153152.GB28153@homer.shelbyville.oz> <20081128144039.GG28138@elte.hu> <20090508132449.GV5417@homer.shelbyville.oz> <20090508200444.GA22132@homer.shelbyville.oz> <20090508160142.ad89944f.akpm@linux-foundation.org> <20090509004009.GZ5417@homer.shelbyville.oz> <20090508181559.4750800e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090508181559.4750800e.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ron@debian.org
X-SA-Exim-Scanned: No (on homer.shelbyville.oz); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 08, 2009 at 06:15:59PM -0700, Andrew Morton wrote:
> On Sat, 9 May 2009 10:10:09 +0930 Ron <ron@debian.org> wrote:
> 
> >  I'm in the process of updating a port for an ARM based chip we've been
> >  working on, from 2.6.22-rc4'ish to the current HEAD of Linus' tree, and
> >  I started seeing the following:
> > 
> >  [    0.000000] PID hash table entries: 512 (order: 9, 2048 bytes)
> >  [42949372.970000] Dentry cache hash table entries: 16384 (order: 4, 65536 bytes)
> > 
> >  The reason appears to be that printk_clock() has been replaced with a
> >  call to cpu_clock, which in our case currently falls back to the default
> >  (weak) implementation of sched_clock() that uses jiffies -- but doesn't
> >  account for the initial offset of the jiffy count.  The following simple
> >  patch fixes it for me, in line with what printk_clock used to do.
> 
> Removing printk_clock() always seemed a mildly wrong idea to me.
> 
> I'm sure we fixed this printk-timestamping ages and ages ago.  Maybe it
> came back, or maybe it's somehow specific to your setup?

I presume it's just gone unnoticed because nobody actually uses this
default implementation, they all have one based on a real clocksource.

> It's trivial to test, but I don't have the time to build and boot a
> kernel right now :(

I can confirm for our ARM port that if I revert to using this default
sched_clock, then I still see the same result.  That's rebased against
Linus' tree as of yesterday.

> If the printk oddity is indeed being seen on all kernels then I'd
> suggest that it be fixed right there in vprintk().

Looking at the code again, it seems pretty straightforward that it
should be (for anything actually using this default sched_clock,
which is probably not much, except people fleshing out new ports).

vprintk() calls cpu_clock(), which calls sched_clock().  All 'real'
sched_clock implementations (empirically) count from 0, except this
default one.

> Because changing sched_clock() adds unneeded overhead and partially
> defeats the intent of INITIAL_JIFFIES, which is to catch code which
> is incorrectly handling jiffy wrapping.

I agree with the general spirit of that thinking, but in this particular
case, I'm not sure that it's entirely applicable:

The overhead of subtracting INITIAL_JIFFIES is only incurred for people
who actually use this default sched_clock -- which should be almost
nobody for a 'mature' port, they mostly all should implement their own
specialisation with a better clock source.  So at worst it's a tax on
'lazy people' right now.

Actually having a real hires timer for the printk output is nice, so
reverting to a printk_clock() that _only_ counts in jiffies seems
suboptimal -- except in this one case, that nobody should be using.

Which means trying to 'fix' vprintk for only this one anomalous case
where sched_clock does not start at zero, which nobody should be using
anyhow, starts to look a bit messy in its own right.

Unless there is some other reason for having this one implementation
of sched_clock start from something other than zero, making it behave
like the others seems like the 'simplest' correct thing to do here.
That doesn't totally invalidate the use of INITIAL_JIFFIES for other
things counting by jiffies, it just makes it explicit that sched_clock
should count from 0, regardless of the underlying clock values.

OTOH, having it start with a bogus value may also be a useful hint
to people that they need to provide their own sched_clock (which is
what I recommended the reporter yesterday do, rather than applying
this patch :)

I'm happy to defer to wiser minds on what the best thing to do here
really is, there are surely subtleties that I'm missing, but given
that nobody should be using this particular function implementation,
and it's the only one showing this symptom, it doesn't seem too
unreasonable to make it behave like the ones people are actually
using do...  unless that's an invalid constraint to place on all
sched_clock implementations for some other reason.  If it's not,
that seems preferable to having ports provide _both_ a sched_clock
and a hires 'zero based clock' for printk ...  but there might still
be a better existing clock that printk could use instead ...

Cheers,
Ron


