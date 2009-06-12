Return-Path: <linux-kernel-owner+w=401wt.eu-S1760470AbZFLOaj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760470AbZFLOaj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 10:30:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755976AbZFLOac
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 10:30:32 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41507 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753685AbZFLOab (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 10:30:31 -0400
Date: Fri, 12 Jun 2009 16:25:46 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC PATCH] posix-cpu-timers: optimize calling
	thread_group_cputime()
Message-ID: <20090612142546.GC3784@redhat.com>
References: <20090612123903.37cfd868@dhcp-lab-109.englab.brq.redhat.com> <1244804986.6691.1224.camel@laptop> <20090612132008.0c6f3e93@dhcp-lab-109.englab.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090612132008.0c6f3e93@dhcp-lab-109.englab.brq.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To clarify, I am not arguing against this patch, just a queston.

On 06/12, Stanislaw Gruszka wrote:
>
> On Fri, 12 Jun 2009 13:09:46 +0200
> Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>
> > On Fri, 2009-06-12 at 12:39 +0200, Stanislaw Gruszka wrote:
> > > -               times->utime = cputime_add(times->utime, t->utime);
> > > -               times->stime = cputime_add(times->stime, t->stime);
> > > -               times->sum_exec_runtime += t->se.sum_exec_runtime;
> > > +               if (mask & TG_CPUCLOCK_UTIME)
> > > +                       times->utime = cputime_add(times->utime, t->utime);
> > > +               if (mask & TG_CPUCLOCK_STIME)
> > > +                       times->stime = cputime_add(times->stime, t->stime);
> > > +               if (mask & TG_CPUCLOCK_SCHED)
> > > +                       times->sum_exec_runtime += t->se.sum_exec_runtime;
> >
> > Does adding 3 branches really make it faster?
> Actually I did not any benchmarking yet, so I don't know what is the real
> impact of the patch. I hope it make things taster but the result can be
> opposite from my expectations.

I agree with Peter, if we complicate the code it would be nice to know
this really makes it faster. Besides, thread_group_cputime() should not
be called that often.

Perhaps it makes sense to turn ->running into bitmask though, this should
"obviously" speed up account_group_xxx() helpers.

But in that case, perhaps stop_process_timers() should accept bitmask too?
otherwise this doesn't look "complete".

Oleg.

