Return-Path: <linux-kernel-owner+w=401wt.eu-S2992550AbXCIU7K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992550AbXCIU7K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 15:59:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993126AbXCIU7K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 15:59:10 -0500
Received: from waste.org ([66.93.16.53]:51509 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992550AbXCIU7I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 15:59:08 -0500
Date: Fri, 9 Mar 2007 14:46:24 -0600
From: Matt Mackall <mpm@selenic.com>
To: Con Kolivas <kernel@kolivas.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org
Subject: Re: 2.6.21-rc3-mm1 RSDL results
Message-ID: <20070309204623.GE10394@waste.org>
References: <20070309053931.GA10459@waste.org> <20070309075358.GA10394@waste.org> <20070309082057.GB10394@waste.org> <200703091939.05535.kernel@kolivas.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703091939.05535.kernel@kolivas.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 09, 2007 at 07:39:05PM +1100, Con Kolivas wrote:
> On Friday 09 March 2007 19:20, Matt Mackall wrote:
> > And I've just rebooted with NO_HZ and things are greatly improved. At
> > idle, Beryl effects are silky smooth (possibly better than stock) and
> > shows less load. Under 'make', Beryl is still responsive as is Galeon.
> > No sign of lagging mouse or typing.
> >
> > Under make -j 5, things are intermittent. Galeon scrolling is
> > sometimes still responsive, but Beryl, terminals and mouse still drag
> > quite a bit.
> 
> I just replied before you sent this one out I think our messages passed each 
> other across the ocean somewhere. I don't quite get what combination of 
> factors you're saying here caused great improvement. Was it enabling NO_HZ on 
> mainline cpu scheduler or disabling NO_HZ or on RSDL?

Ok, I've now disabled sched_yield (I'm using xorg radeon drivers).

So far:

          rc2-mm2   RSDL  RSDL+NO_HZ  RSDL+NO_HZ+no_yield  estimated CPU
no load
 beryl    good      good  great       great                ~30% at 600MHz
 galeon   good      good  good        good                 100% at 600MHz
 mp3      good      good  good        good                 < 5% at 600MHz
 terminal good      good  good        good                 ~0
 mouse    good      good  good        good                 ~0
make
 beryl              awful ok          good
 galeon             bad   ok          good
 mp3                good  good        good
 terminal           bad   good        good
 mouse              bad   good        good
make -j2
 beryl              awful             bad/ok
 metacity                             bad/ok  <- it's not beryl-specifc
 galeon             bad               bad/ok
 mp3                good              good
 terminal           bad               bad/ok
 mouse              bad               bad/ok
make -j5
 beryl    ok        awful awful       awful/bad
 galeon   ok        bad   bad         bad
 mp3      good      good  good        a couple skips
 terminal ok        bad   bad         bad
 mouse    good      bad   bad         bad
memload x5
 beryl                                ok/good
 galeon                               ok/good
 mp3                                  good
 terminal                             ok/good
 mouse                                ok/good 


good = no problems
ok = noticeable latency
bad = hard to use
awful = completely unusable

By the way, make -j5 is my usual kernel compile because it gives me
the best wall time on this box. 

A priori, this load should be manageable by RSDL as the interactive
loads are all pretty small. So I wrote a little Python script that
basically continuously memcpys some 16MB chunks of memory:

#!/usr/bin/python
a = "a" * 16 * 1024 * 1024
while 1:
    b = a[1:] + "b"
    a = b[1:] + "c"

I've got 1.5G of RAM, so I can run quite a few of these without
killing my pagecache. This should test whether a) Beryl's actually
running up against memory bandwidth issues and b) whether "simple"
static loads work. As you can see, running 5 instances of this script
leaves me in good shape still. 10 is still in "ok" territory, with top
showing each getting 9.7-10% of the CPU. 15 starts to feel sluggish.
20 the mouse jumps a bit and I got an MP3 skip. 30 is getting pretty
bad, but still not as bad as the make -j 5 load.

My suspicion is the problem lies in giving too much quanta to
newly-started processes.

-- 
Mathematics is the supreme nostalgia of our time.
