Return-Path: <linux-kernel-owner+w=401wt.eu-S1759667AbXGTDsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759667AbXGTDsS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 23:48:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756493AbXGTDsC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 23:48:02 -0400
Received: from tomts5.bellnexxia.net ([209.226.175.25]:46131 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756378AbXGTDsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 23:48:00 -0400
Date: Thu, 19 Jul 2007 23:47:57 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Andi Kleen <ak@suse.de>
Cc: patches@x86-64.org, linux-kernel@vger.kernel.org,
       Daniel Walker <dwalker@mvista.com>
Subject: Re: [PATCH] [15/58] i386: Rewrite sched_clock
Message-ID: <20070720034757.GA9093@Krystal>
References: <200707191154.642492000@suse.de> <20070719095459.E60AD14E11@wotan.suse.de> <1184863904.6458.17.camel@dhcp193.mvista.com> <20070720031105.GA8237@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070720031105.GA8237@Krystal>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 23:24:14 up 2 days, 21:58,  1 user,  load average: 0.28, 0.28, 0.20
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Mathieu Desnoyers (mathieu.desnoyers@polymtl.ca) wrote:
 ....
> > > +/*
> > > + * Scheduler clock - returns current time in nanosec units.
> > > + * All data is local to the CPU.
> > > + * The values are approximately[1] monotonic local to a CPU, but not
> > > + * between CPUs.   There might be also an occasionally random error,
> > > + * but not too bad. Between CPUs the values can be non monotonic.
> > > + *
> > > + * [1] no attempt to stop CPU instruction reordering, which can hit
> > > + * in a 100 instruction window or so.
> > > + *
> > > + * The clock can be in two states: stable and unstable.
> > > + * When it is stable we use the TSC per CPU.
> > > + * When it is unstable we use jiffies as fallback.
> > > + * stable->unstable->stable transitions can happen regularly
> > > + * during CPU frequency changes.
> > > + * There is special code to avoid having the clock jump backwards
> > > + * when we switch from TSC to jiffies, which needs to keep some state
> > > + * per CPU. This state is protected against parallel state changes
> > > + * with interrupts off.
> > The comment still says something about interrupts off, but that was
> > removed it looks like.
> > 
> 
> I noticed the same thing about interrupts off when going through the
> code. Andi, since you are already playing with per cpu variables, you
> could leverage asm/local.h there by declaring last_val as local_t and
> use either local_cmpxchg or local_add_return (depending on your needs)
> to get both better performances than cli/sti _and_ be really atomic.
> 
> See this thread for performance tests:
> http://www.ussg.iu.edu/hypermail/linux/kernel/0707.1/0832.html
> 
> Mathieu
> 

I just want to rectify a detail: local_t uses type "long", which is 32
bits on x86_32 and 64 bits on x86_64.

Using a cmpxchg8b on i386 seems to require the LOCK prefix to be taken,
so it may degrate performances too much. Therefore, you may prefer to
stay with cli/sti on i386, but using a local cmpxchg would make sense on
x86_64.

A side-note: I really dislike the new cmpxchg behavior when a too
large value is passed to it. If we pass a uint64_t * as first argument
to cmpxchg or cmpxchg_local on i386, it just fails silently. Before, a
linker error was produced, which required the kernel to be compiled with
-O2 as side-effect, but at least there wasn't any silent failure...

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
