Return-Path: <linux-kernel-owner+w=401wt.eu-S1754058Ab0A0AuY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058Ab0A0AuY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 19:50:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753341Ab0A0AuX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 19:50:23 -0500
Received: from smtp12.ono.com ([62.42.230.20]:19612 "EHLO resmaa12.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751995Ab0A0AuV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 19:50:21 -0500
Date: Wed, 27 Jan 2010 01:50:18 +0100
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Hyperthreading on Core i7s: To use or not to use?
Message-ID: <20100127015018.42793269@werewolf.home>
In-Reply-To: <6278d2221001260256q5f35457fye8baabcc333d40@mail.gmail.com>
References: <6278d2221001260256q5f35457fye8baabcc333d40@mail.gmail.com>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.19.3; x86_64-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Jan 2010 10:56:57 +0000, Daniel J Blueman <daniel.blueman@gmail.com> wrote:

> On Jan 26, 10:10 am, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
> > Hello,
> >
> > Should the 'correct' kernel [CPU] configuration for a core i7 860/870..?
> >
> > - Multi-core support
> > - Cores: 8
> > - SMT: Enabled/ON
> >
> > From CONFIG_SCHED_SMT:
> >
> >    . SMT scheduler support improves the CPU scheduler's decision making      .
> >    . when dealing with Intel Pentium 4 chips with HyperThreading at a        .
> >    . cost of slightly increased overhead in some places. If unsure say       .
> >    . N here.                                                                 .
> >
> > Does this also 'help' and/or 'apply' as much when dealing with Core i7s?
> >
> > --
> >
> > Quick little benchmark (pbzip2 -9 linux kernel source), the benchmark is
> > really within the noise (8 on/off)
> > - Multicore(8)/HT(Off) = 73.72user 0.33system 0:09.50elapsed 779%CPU (0avgtext+0avgdata 458528maxresident
> > - Multicore(8)/HT(On) = 74.28user 0.40system 0:09.67elapsed 772%CPU (0avgtext+0avgdata 428304maxresident
> > - Multicore(4)/HT(On) = 68.76user 0.30system 0:17.44elapsed 396%CPU (0avgtext+0avgdata 213616maxresident)k

What does 'multicore(n)' mean ? And HT ?
Are they BIOS, kernel or pbzip2 options ?

Well, with that i7 you have:
- 1 processor
- 4 cores
- 8 threads (4x2)

(BTW, i think the 'CPUs' nomenclature in kernel is misleading...
 with nowadays processor, what does 'CPU' mean ? processor, core, thread...)

With that processor, you should:
- Configure the kernel for 8 'kernel CPUs', what means you can support
  8 threads
- Configure SCHED_MC on, as you have several cores inside the same CPU that
  share L3 cache
- Configure SCHED_SMT on, as you have several threads per core

Don't know if SCHED_SMT is very useful for not-hand-crafted apps, but it can't
hurt too much for some extra scheduling calculations...

What does 'within the noise' mean for you ?
With the 4-on mode, it just takes 2x the time to do the work...(look at elapsed!)
So, assuming the kernel is 'intelligent':
- Using 4 threads, it takes 17.44, and scheduler is using 4 threads located
  on different cores.
- Using 8 threads, it takes  9.50. So effciency is 17.44/(2*9.50) = 91%
  Very good! So this HyperThreading is not like that old in P4s, works much
  better. Even with each couple threads competing for registers and L1 (or L2?)
  cache.

So hyper threading is good, why should you disable it ?

> > --
> >
> > Has anyone done any in-depth benchmarking for the core i7s that have multiple
> > cores and HT disabled/enabled?
> 
> With my Dell Studio 15 (model 1557) laptop, there is no option to
> disable HT in the current BIOS, so booting with maxcpus=4 (since the
> kernel enumerates non-sibling cores first) gave me a 5-15% speedup on
> some large image processing (convolution, FFTs, conversion) on all
> available cores, presumably due to better cache efficiency.
> 

Sure you don't have a full extra processor, but it can do some work.

An example. This is a ray tracing engine. If you don't know ray-tracing,
lets say in short it implies traversing a tree structure and doing some
floating point calculations on each node. This repeated millions of times.
With an old P4@2.8 GHz, with HT, this are some simple benchmarks:

- One thread can do about 540 kilo-rays per second
- Both threads do about 800 kR/s. Efficiency: 75%
  In other words, the 'second' thread counts as about 'half' more CPU,
  like if you had 1.5 cpus instead of 2.0. Anyways, its more than 1.0.

And this is not seriously hand-crafted, just POSIX threads code.

If your application is any more complex than the pathological case of
summing two vectors, you can use the HT-sibling for something useful.
And even in that case you can code your program in a cache-aware fashion,
perhaps doing an interleaved sum instead of one chunk on each thread (?)...

-- 
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2010.1 (Cooker) for x86_64
Linux 2.6.32.3-desktop-0.rc2.1mnb (gcc 4.4.2 ) SMP
