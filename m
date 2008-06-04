Return-Path: <linux-kernel-owner+w=401wt.eu-S1762613AbYFDTko@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762613AbYFDTko (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 15:40:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761242AbYFDTkg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 15:40:36 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:53237 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760909AbYFDTkf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 15:40:35 -0400
Date: Wed, 4 Jun 2008 22:40:02 +0300
From: Adrian Bunk <adrian.bunk@movial.fi>
To: Tim Bird <tim.bird@am.sony.com>
Cc: linux-tiny <Linux-tiny@selenic.com>,
       linux-embedded <linux-embedded@vger.kernel.org>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] console - Add configurable support for console charset
	translation
Message-ID: <20080604194002.GF4189@cs181133002.pp.htv.fi>
References: <48447615.5050806@am.sony.com> <20080604103353.GC27335@cs181133002.pp.htv.fi> <4846E44A.1010601@am.sony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4846E44A.1010601@am.sony.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 04, 2008 at 11:51:54AM -0700, Tim Bird wrote:
> Adrian Bunk wrote:
> > It seems to be always me who asks the controversial questions...:
> > 
> > Does the linux-tiny approach of adding a kconfig variable for each 5kB 
> > of code actually make sense? I'm asking since an exploding amount of 
> > kconfig variables and their interdependencies have a not so small 
> > maintainance impact in the long term.
> 
> Others have expressed similar concerns.  Andi Kleen has brought this
> up in the past, and highlighted another aspect of this that I think
> is important - fragmenting the configuration space for testing.
> 
> That is, if different combinations of options are used, then the
> testing results from different users may not be directly comparable.
> This makes it harder to track down bugs.
> 
> In practice, I think these types of switches tend to get turned
> on/off together.  This tends to ameliorate the testing and maintenance
> issues. It might be worthwhile to coalesce these into fewer
> options.  I'd be fine with overloading this particular
> onto CONFIG_BASE_FULL, but I don't know what other people think.
> Keeping the option separate means you have more flexibility - so
> that you can, for example, turn off all but one feature that's
> important to you.  (This seems like a pretty common

I'm coming more from the point that drivers/media/ might be the area    
in the kernel that currently offers the biggest flexibility - and this 
stuff breaks multiple times for each kernel release, and sorting this 
out is often nontrivial.

I'm not claiming it was impossible to maintain, but it is a maintainance 
burden if too much is configurable.

> > And I'm wondering whether it's the best approach for reaching 
> > measurable results. E.g. my small patch that removed 
> > -maccumulate-outgoing-args on 32-bit x86 reduced the kernel size
> > there for the CONFIG_CC_OPTIMIZE_FOR_SIZE=y case by at about 2.5% (sic)
> > without adding any kconfig variables or #ifdef's.
> 
> These are certainly nice, but there's a limited number of whole-kernel
> reduction options.  Kernel size accumulates by both wasteful
> compiler output, and by the introduction or preservation of individual
> features that are useless for embedded devices.  I think it's worthwhile
> to attack both problems.

There are still several (although not that trivial) global reductions 
each worth 2% or more in code size possible, and I would say they should 
be attacked before starting a config options jungle.

As a bonus, such stuff brings benefit to everyone, not only to people 
creating hand-optimized kernels for devices with very limited features.

And it also addresses the point that someone trying to get a very small 
kernel might hit completely untested codepaths.

> > Can you take a reasonable (best-case) .config for an existing device and 
> > get the following numbers:
> > - Ignoring patches that came from linux-tiny, by how many percent did 
> >   the size of the kernel increase or decrease between 2.6.16 and 2.6.26?
> 
> Well, an initial comparison is at:
> http://www.selenic.com/bloatwatch/?cmd=compare&part=%2F&v1=2.6.16&v2=2.6.25-rc2
> 
> This shows a size difference of 1.8 meg, but I'm pretty sure this
> is with a default config (not optimized) and is not controlled very well
> for changes in the config.

It seems to be comparing i386 defconfigs.

E.g. the increase of CONFIG_LOG_BUF_SHIFT in the i386 defconfig in 
2.6.19 does alone increase the size of a defconfig kernel by a
quarter Megabyte - but that's both expected and not relevant for 
embedded systems.

> I can do a more controlled comparison if you're interested.

I think the only serious numbers would come from taking some hardware 
and feature set (file systems, network options, etc.), and then 
optimizing by hand the smallest .config possible for both cases.

Do you have anything in this direction?

> > - By how many percent did the kernel size decrease due to patches from
> >   the linux-tiny project that added such kconfig options for a few kB 
> >   of code in the same timeframe?
> 
> I'm not sure that's a good comparison, since Linux-tiny hasn't been
> very active in that time period.  I would guess only about 3 or 4
> Linux-tiny patches have made it into the kernel since 2.6.16.
> The big wins for Linux-tiny were in the 2.6.10/11 kernels, where
> most of the low-hanging fruit (size-wise) was gleaned.
> 
> But to address your point, you're right that no existing Linux-tiny
> patch gets 2.5% reduction for the kernel.
> In my own testing at Sony, the 30 or so Linux-tiny patches that
> I use get me about 110k of reductions.  For me, this is about 5% of
> my kernel size.   Note that my choice of options to achieve
> reductions is pretty conservative.

OK, that's a visible difference.

Are these 30 patches each gaining 4kB or are there a few patches that 
bring most gain?

And are you only measuring the kernel image size or also theruntime 
memory usage?

> There are diminishing returns here, and at some point it doesn't make
> sense to continue.  I have a nagging feeling, though, that there
> are a few more things where the bloat is pronounced (glances at
> procfs and sysfs).
> 
> > My gut feeling is that the influence of this kind of linux-tiny patches 
> > is hardly noticably compared to the overall code size development, but 
> > if you have numbers that prove me wrong just point me to them and I'll 
> > stand corrected.
> 
> It *does* feel a bit like fighting the tide with a teaspoon.

Besides reducing the kernel size it might also make sense if you'd 
regularly monitored -rc and -next kernels for size increases
(AFAIK noone currently does this) and bring them up early.

If you'd do this with kernels for real devices you might also test the 
kernels on the devices, en passant improving the problem that embedded 
architectures currently have nearly zero coverage at the times when 
functional regressions have a reasonable chance of being fixed before 
they reach stable kernels.  ;-)

>  -- Tim

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

