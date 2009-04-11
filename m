Return-Path: <linux-kernel-owner+w=401wt.eu-S1757858AbZDKQzQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757858AbZDKQzQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 12:55:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756358AbZDKQzA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 12:55:00 -0400
Received: from www.tglx.de ([62.245.132.106]:38744 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755766AbZDKQy7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 12:54:59 -0400
Date: Sat, 11 Apr 2009 18:53:45 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Dimitri Sivanich <sivanich@sgi.com>
cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       john stultz <johnstul@us.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v2] Move calc_load call out from xtime_lock protection
In-Reply-To: <20090411162416.GC3496@sgi.com>
Message-ID: <alpine.LFD.2.00.0904111849450.21577@localhost.localdomain>
References: <20090410173437.GA23415@sgi.com> <alpine.LFD.2.00.0904110931240.21577@localhost.localdomain> <20090411162416.GC3496@sgi.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 11 Apr 2009, Dimitri Sivanich wrote:

> On Sat, Apr 11, 2009 at 11:51:36AM +0200, Thomas Gleixner wrote:
> > On Fri, 10 Apr 2009, Dimitri Sivanich wrote:
> > 
> > > The xtime_lock is being held for long periods on larger systems due
> > > to an extensive amount of time being spent in calc_load(),
> > > specifically here:
> > >   do_timer->update_times->calc_load->count_active_tasks->nr_active()
> > > 
> > > On a 64 cpu system I've seen this take approximately 55 usec.
> > > Presumably it would be worse on larger systems.  This causes other
> > > cpus to be held off in places such as
> > > scheduler_tick->sched_clock_tick waiting for the xtime_lock to be
> > > released.
> > 
> > I thought more about that. Why don't we move the calc_load() call into
> > the timer softirq context and avoid fiddling with all the call sites ?
> > Also moving calc_load out of the timer interrupt context reduces the
> > interrupts off section as well.
> > 
> Sounds reasonable to me.

Ok. I looked once more and I wonder if it's possible to avoid the
whole for_each_online_cpu() business by moving the accounting into the
scheduler and be a bit more clever than just blindly running over all
cpus everytime. 

/me goes back to stare a bit more at the avenrun stuff

Thanks,

	tglx



