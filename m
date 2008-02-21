Return-Path: <linux-kernel-owner+w=401wt.eu-S933122AbYBUR1A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933122AbYBUR1A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 12:27:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756380AbYBUR0u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 12:26:50 -0500
Received: from victor.provo.novell.com ([137.65.250.26]:38412 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752487AbYBUR0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 12:26:49 -0500
X-Greylist: delayed 1216 seconds by postgrey-1.27 at vger.kernel.org; Thu, 21 Feb 2008 12:26:48 EST
Subject: Re: [PATCH [RT] 08/14] add a loop counter based timeout mechanism
From: Sven-Thorsten Dietrich <sdietrich@novell.com>
To: Andi Kleen <ak@suse.de>
Cc: Gregory Haskins <ghaskins@novell.com>, mingo@elte.hu,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, rostedt@goodmis.org,
       linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
       bill.huey@gmail.com, kevin@hilman.org, cminyard@mvista.com,
       dsingleton@mvista.com, dwalker@mvista.com, npiggin@suse.de,
       dsaxena@plexity.net, gregkh@suse.de, pmorreale@novell.com,
       mkohari@novell.com
In-Reply-To: <200802211741.10299.ak@suse.de>
References: <20080221152504.4804.8724.stgit@novell1.haskins.net>
	 <20080221152707.4804.59177.stgit@novell1.haskins.net>
	 <200802211741.10299.ak@suse.de>
Content-Type: text/plain
Date: Thu, 21 Feb 2008 09:06:15 -0800
Message-Id: <1203613575.4133.133.camel@sx.thebigcorporation.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-02-21 at 17:41 +0100, Andi Kleen wrote:
> > +config RTLOCK_DELAY
> > +	int "Default delay (in loops) for adaptive rtlocks"
> > +	range 0 1000000000
> > +	depends on ADAPTIVE_RTLOCK
> 
> I must say I'm not a big fan of putting such subtle configurable numbers
> into Kconfig. Compilation is usually the wrong place to configure
> such a thing. Just having it as a sysctl only should be good enough.
> 
> > +	default "10000"
> 
> Perhaps you can expand how you came up with that default number? 

We did not want to create a hotspot around time sources for HRT and the
scheduler clock, and there really hasn't been enough analyis.

The loop should be calibrated using something similar to
loops_per_jiffy, and it should be in nanoseconds.

It needs to be tunable, because it depends a lot on the workload.

High frequency periodic tasks would need a lower setting - but it also
relates to the number of waiting tasks and the number of CPUs, so there
may be heuristics that tie into lockstat.

For big-SMP systems, it may actually be worth the overhead to track
these stats per-lock (for the hot locks), if we can correlate it all to
performance.

> It looks suspiciously round and worse the actual spin time depends a lot on the 
> CPU frequency (so e.g. a 3Ghz CPU will likely behave quite 
> differently from a 2Ghz CPU) Did you experiment with other spin times? 
> Should it be scaled with number of CPUs? And at what point is real
> time behaviour visibly impacted? 
> 

The code actually runs preemptibly, so even before the timeout expires,
the task can pop off the CPU (at which point another state chance
cancels the loop)

> Most likely it would be better to switch to something that is more
> absolute time, like checking RDTSC every few iteration similar to what
> udelay does. That would be at least constant time.
> 

True - I looked at something generic, similar to what RT's latency
tracing uses, allowing for other architectures.

Sven

> -Andi
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

