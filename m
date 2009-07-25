Return-Path: <linux-kernel-owner+w=401wt.eu-S1755060AbZGYHWM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755060AbZGYHWM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jul 2009 03:22:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752560AbZGYHWL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Jul 2009 03:22:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52904 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752380AbZGYHWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jul 2009 03:22:10 -0400
Date: Sat, 25 Jul 2009 00:21:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       "Kok, Auke-jan H" <auke-jan.h.kok@intel.com>
Subject: Re: [PATCH] sched: Provide iowait counters
Message-Id: <20090725002148.5524c846.akpm@linux-foundation.org>
In-Reply-To: <1248501946.6987.146.camel@twins>
References: <4A64B813.1080506@linux.intel.com>
	<20090724212220.afa278ee.akpm@linux-foundation.org>
	<4A6A8AFE.1010608@linux.intel.com>
	<20090724214006.7380c3b4.akpm@linux-foundation.org>
	<4A6A8E96.7050509@linux.intel.com>
	<20090724220423.11828b85.akpm@linux-foundation.org>
	<1248501946.6987.146.camel@twins>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 25 Jul 2009 08:05:46 +0200 Peter Zijlstra <peterz@infradead.org> wrote:

> On Fri, 2009-07-24 at 22:04 -0700, Andrew Morton wrote:
> > 
> > > > See include/linux/sched.h's definition of task_delay_info - u64
> > > > blkio_delay is in nanoseconds.  It uses
> > > > do_posix_clock_monotonic_gettime() internally.
> > > 
> > > looks like it does.. to bad we don't expose that data in
> > a /proc/<pid>/delay or something field
> > > like we do with the scheduler info...
> > > 
> > 
> > I thought we did deliver a few of the taskstats counters via procfs,
> > but maybe I dreamed it.  It would have been a rather bad thing to do.
> > 
> > taskstats has a large advantage over /proc-based things: it delivers a
> > packet to the monitoring process(es) when the monitored task exits.
> > So
> > with no polling at all it is possible to gather all that information
> > about the just-completed task.  This isn't possible with /proc.
> > 
> > There's a patch on the list now to teach taskstats to emit a packet at
> > fork- and exit-time too.
> > 
> > The monitored task can be polled at any time during its execution
> > also,
> > like /proc files.
> > 
> > Please consider switching whatever-you're-working-on over to use
> > taskstats rather than adding (duplicative) things to /proc (which
> > require CONFIG_SCHED_DEBUG, btw).
> > 
> > If there's stuff missing from taskstats then we can add it - it's
> > versioned and upgradeable and is a better interface.  It's better
> > to make taskstats stronger than it is to add /proc/pid fields,
> > methinks.
> 
> The below exposes the information to ftrace and perf counters, it uses
> the scheduler accounting (which is often much cheaper than
> do_posix_clock_monotonic_gettime, and more 'accurate' in the sense that
> its what the scheduler itself uses).

Well.  The do_posix_clock_monotonic_gettime() call is already there,
and this change adds more code on top of Arjan's code which wasn't
needed if he can use taskstats.

> This allows profiling tasks based on iowait time, for example, something
> not possible with taskstats afaik.
> 
> Maybe there's a use for taskstats still, maybe not.
>
> ---
> Subject: sched: wait, sleep and iowait accounting tracepoints
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date: Thu Jul 23 20:13:26 CEST 2009
> 
> Add 3 schedstat tracepoints to help account for wait-time, sleep-time
> and iowait-time.
> 
> They can also be used as a perf-counter source to profile tasks on
> these clocks.

This may be a useful feature, dunno.  But it seems to be unrelated to
Arjan's requirement, apart from building on top of it.

What _is_ Arjan's requirement, anyway?  I don't think it's really been
spelled out.

