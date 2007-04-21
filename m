Return-Path: <linux-kernel-owner+w=401wt.eu-S1752674AbXDUQT1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752674AbXDUQT1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 12:19:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752702AbXDUQT1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 12:19:27 -0400
Received: from 1wt.eu ([62.212.114.60]:2115 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752674AbXDUQT0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 12:19:26 -0400
Date: Sat, 21 Apr 2007 18:18:18 +0200
From: Willy Tarreau <w@1wt.eu>
To: Ingo Molnar <mingo@elte.hu>
Cc: Con Kolivas <kernel@kolivas.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Gene Heskett <gene.heskett@gmail.com>
Subject: Re: [REPORT] cfs-v4 vs sd-0.44
Message-ID: <20070421161818.GC7840@1wt.eu>
References: <20070420140457.GA14017@elte.hu> <20070421121235.GA2044@1wt.eu> <20070421154614.GA26169@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070421154614.GA26169@elte.hu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 21, 2007 at 05:46:14PM +0200, Ingo Molnar wrote:
> 
> * Willy Tarreau <w@1wt.eu> wrote:
> 
> > I promised to perform some tests on your code. I'm short in time right 
> > now, but I observed behaviours that should be commented on.
> 
> thanks for the feedback!
> 
> > 3) CFS-v4
> > 
> >   Feels even better, mouse movements are very smooth even under high 
> >   load. I noticed that X gets reniced to -19 with this scheduler. I've 
> >   not looked at the code yet but this looked suspicious to me. I've 
> >   reniced it to 0 and it did not change any behaviour. Still very 
> >   good. The 64 ocbench share equal CPU time and show exact same 
> >   progress after 2000 iterations. The CPU load is more smoothly spread 
> >   according to vmstat, and there's no idle (see below). BUT I now 
> >   think it was wrong to let new processes start with no timeslice at 
> >   all, because it can take tens of seconds to start a new process when 
> >   only 64 ocbench are there. [...]
> 
> ok, i'll modify that portion and add back the 50%/50% parent/child CPU 
> time sharing approach again. (which CFS had in -v1) That should not 
> change the rest of your test and should improve the task startup 
> characteristics.

If you remember, with 50/50, I noticed some difficulties to fork many
processes. I think that during a fork(), the parent has a higher probability
of forking other processes than the child. So at least, we should use
something like 67/33 or 75/25 for parent/child.

There are many shell-scripts out there doing a lot of fork(), and it should
be reasonable to let them keep some CPU to continue to work.

Also, I believe that (in shells), most forked processes do not even consume
a full timeslice (eg: $(uname -n) is very fast). This means that assigning
them with a shorter one will not hurt them while preserving the shell's
performance against CPU hogs.

Willy

