Return-Path: <linux-kernel-owner+w=401wt.eu-S1761352AbXHAItg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761352AbXHAItg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 04:49:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754476AbXHAIt2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 04:49:28 -0400
Received: from mail.gmx.net ([213.165.64.20]:42291 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754447AbXHAIt0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 04:49:26 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+Uqh0puD+URiXaJV9H5qmjsuZ4a2bczgGByMDBp0
	Add88tc61ErJvj
Subject: Re: CFS review
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Roman Zippel <zippel@linux-m68k.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <1185953762.6388.26.camel@Homer.simpson.net>
References: <20070711211638.GE18767@one.firstfloor.org>
	 <20070711214649.GK14435@v2.random>
	 <alpine.LFD.0.999.0707111500210.20061@woody.linux-foundation.org>
	 <Pine.LNX.4.64.0707130415520.1818@scrub.home>
	 <1184302024.6709.11.camel@Homer.simpson.net>
	 <Pine.LNX.4.64.0707131728070.1817@scrub.home>
	 <1184389456.6632.13.camel@Homer.simpson.net>
	 <Pine.LNX.4.64.0708010439050.1817@scrub.home>
	 <20070801071230.GA16375@elte.hu>
	 <1185953195.6388.21.camel@Homer.simpson.net>
	 <20070801073042.GB21551@elte.hu>
	 <1185953762.6388.26.camel@Homer.simpson.net>
Content-Type: text/plain
Date: Wed, 01 Aug 2007 10:49:21 +0200
Message-Id: <1185958161.6375.14.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-08-01 at 09:36 +0200, Mike Galbraith wrote:
> On Wed, 2007-08-01 at 09:30 +0200, Ingo Molnar wrote:
>  
> > yeah, the posted numbers look most weird, but there's a complete lack of 
> > any identification of test environment - so we'll need some more word 
> > >from Roman. Perhaps this was run on some really old box that does not 
> > have a high-accuracy sched_clock()? The patch below should simulate that 
> > scenario on 32-bit x86.
> > 
> > 	Ingo
> > 
> > Index: linux/arch/i386/kernel/tsc.c
> > ===================================================================
> > --- linux.orig/arch/i386/kernel/tsc.c
> > +++ linux/arch/i386/kernel/tsc.c
> > @@ -110,7 +110,7 @@ unsigned long long native_sched_clock(vo
> >  	 *   very important for it to be as fast as the platform
> >  	 *   can achive it. )
> >  	 */
> > -	if (unlikely(!tsc_enabled && !tsc_unstable))
> > +//	if (unlikely(!tsc_enabled && !tsc_unstable))
> >  		/* No locking but a rare wrong value is not a big deal: */
> >  		return (jiffies_64 - INITIAL_JIFFIES) * (1000000000 / HZ);
> >  
> 
> Ah, thanks.  I noticed that clocksource= went away.  I'll test with
> stats, with and without jiffies resolution.

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  P COMMAND
6465 root      20   0  1432  356  296 R   30  0.0   1:02.55 1 chew
6462 root      20   0  1576  216  140 R   23  0.0   0:50.29 1 massive_intr_x
6463 root      20   0  1576  216  140 R   23  0.0   0:50.23 1 massive_intr_x
6464 root      20   0  1576  216  140 R   23  0.0   0:50.28 1 massive_intr_x

Well, jiffies resolution clock did upset fairness a bit with a right at
jiffies resolution burn time, but not nearly as bad as on Roman's box,
and not in favor of the sleepers.  With the longer burn time of stock
massive_intr.c (8ms burn, 1ms sleep), lower resolution clock didn't
upset it.

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  P COMMAND
6511 root      20   0  1572  220  140 R   25  0.0   1:00.11 1 massive_intr
6512 root      20   0  1572  220  140 R   25  0.0   1:00.14 1 massive_intr
6514 root      20   0  1432  356  296 R   25  0.0   1:00.31 1 chew
6513 root      20   0  1572  220  140 R   24  0.0   1:00.14 1 massive_intr

	-Mike

