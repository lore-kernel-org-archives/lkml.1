Return-Path: <linux-kernel-owner+w=401wt.eu-S1754182Ab0AaVLJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182Ab0AaVLJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 16:11:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752703Ab0AaVLI
	(ORCPT <rfc822;linux-kernel-outgoing-6734>);
	Sun, 31 Jan 2010 16:11:08 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:56581 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751977Ab0AaVLG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 16:11:06 -0500
Date: Sun, 31 Jan 2010 22:11:05 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Tom Zanussi <tzanussi@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 00/12] perf lock: New subcommand "perf lock", for
	analyzing  lock statistics
Message-ID: <20100131211104.GD13771@kernel.dk>
References: <1264167553-6510-1-git-send-email-mitake@dcl.info.waseda.ac.jp> <20100129143403.GJ13771@kernel.dk> <4B641F4D.6090704@dcl.info.waseda.ac.jp> <20100131204408.GC13771@kernel.dk> <20100131210707.GF5224@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100131210707.GF5224@nowhere>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 31 2010, Frederic Weisbecker wrote:
> On Sun, Jan 31, 2010 at 09:44:08PM +0100, Jens Axboe wrote:
> > On Sat, Jan 30 2010, Hitoshi Mitake wrote:
> > > (2010???01???29??? 23:34), Jens Axboe wrote:
> > >> On Fri, Jan 22 2010, Hitoshi Mitake wrote:
> > >>    
> > >>> Adding new subcommand "perf lock" to perf.
> > >>>
> > >>> I made this patch series on
> > >>> latest perf/core of tip (ef12a141306c90336a3a10d40213ecd98624d274),
> > >>> so please apply this series to perf/core.
> > >>>      
> > >> [snip]
> > >>
> > >> I wanted to give this a go today, since I think it's pretty nifty and a
> > >> lot better than using /proc/lock_stat. But it basically spirals the
> > >> system into death [1]. How big a system did you test this on?
> > >>
> > >> [1] Got this: [  117.097918] hrtimer: interrupt took 35093901 ns
> > >>
> > >>    
> > >
> > > I tested this on Core i7 965 + 3GB DRAM machine.
> > > Test program is mainly "perf bench sched messaging".
> > >
> > > Could you tell me the detail of your test situation?
> > 
> > I tried to run it on a 64 thread box, on a fio job that was driving 80
> > disks. It was just a quick test, but after ~20 seconds it had not even
> > gotten started yet, it was still stuck in setting up the jobs and
> > traversing sysfs for finding disk stats, etc. I can try something
> > lighter to see if it's the cpu count or the tough job that was making it
> > spiral into (near) death.
> 
> 
> So you're experiencing a severe slowdown but it's not a lockup, right?

Right, I was eventually able to ctrl-z out of the test and kill the app.
So it wasn't hung, just completely live locked. Any attempt to login via
ssh didn't make any progress and even key presses took seconds.

> I think there are various reasons for that.
> 
> - The first is that lock events are high freq events, probably the highest
>   frequency of all events we have, and this amount of course is going to
>   scale with the number of cpus.
> 
> - They are suboptimally implemented. We are copying various strings
>   in every lock events (acquire(d), release, contended) that could be
>   sent once in a lock_init event. Among these strings are the name of
>   the lock and the __FILE__ __LINE__ of its declaration.
>   Ingo has applied Hitoshi's patches in tip:/perf/core few hours ago
>   without the __FILE__ __LINE__ infos. We are thinking about other
>   ways to get these infos.
>   The name is going to move in a new lock_init event, I'm currently
>   working at it.
> 
> - We are using the -M option from perf tools which multiplexes every
>   event buffers, which means every cpu commit their lock events in
>   the same buffer. Couple that with the two above reasons, it's supposed
>   to scale at worst.
> 
> Given that and the fact you have a 64 threads box, I'm not very
> surprised of such global slowdown.
> 
> But we are working toward this and will try to make it better in this
> regard.

OK, I'll stay tuned and watch for developments in this area. Thanks!

-- 
Jens Axboe

