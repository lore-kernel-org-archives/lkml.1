Return-Path: <linux-kernel-owner+w=401wt.eu-S1755017AbZKMJ0l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755017AbZKMJ0l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 04:26:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755490AbZKMJ0d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 04:26:33 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:47921 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755483AbZKMJ0c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 04:26:32 -0500
Date: Fri, 13 Nov 2009 10:26:12 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Steven Rostedt <rostedt@goodmis.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Subject: Re: [PATCH] tracing: Rename lockdep event subsystem into lock
Message-ID: <20091113092612.GA26185@elte.hu>
References: <20091113085123.GA1318@elte.hu>
 <1258103194-843-1-git-send-email-fweisbec@gmail.com>
 <1258103409.4039.1079.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1258103409.4039.1079.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Fri, 2009-11-13 at 10:06 +0100, Frederic Weisbecker wrote:
> > Lockdep events subsystem gathers various locking related events such
> > as a request, release, contention or acquisition of a lock.
> > 
> > The name of this event subsystem is a bit of a misnomer since these 
> > events are not quite related to lockdep but more generally to 
> > locking, ie: these events are not reporting lock dependencies or 
> > possible deadlock scenario but pure locking events.
> 
> But in order to get them you need pretty much all of lockdep, except 
> PROVE_LOCKING. You get all the lock debugging, the lock tracking, the 
> struct dep_map bloat etc.
> 
> But sure, I don't mind renaming the category.

Yeah, i'd prefer it this way. You are right that most of lockdep.o is 
still there, but most of the lockdep _overhead_ shouldnt be there - no 
hashing, no tracking, etc.

it's still nonzero - see 'perf top' of a hackbench session, with 
LOCK_STAT enabled and PROVE_LOCKING disabled:

------------------------------------------------------------------------------
   PerfTop:   14059 irqs/sec  kernel:99.8% [1000Hz cycles],  (all, 16 CPUs)
------------------------------------------------------------------------------

             samples  pcnt function                                 DSO
             _______ _____ ________________________________ ________________

             7320.00  7.9% sched_clock_local                [kernel]
             7217.00  7.8% lock_acquired                    [kernel]
             5768.00  6.2% trace_hardirqs_off               [kernel]
             4562.00  4.9% __lock_acquire                   [kernel]
             4304.00  4.6% lock_release                     [kernel]
             3838.00  4.1% lock_acquire                     [kernel]
             3833.00  4.1% look_up_lock_class               [kernel]
             3561.00  3.8% cpu_clock                        [kernel]
             3283.00  3.5% start_critical_timing            [kernel]
             2992.00  3.2% __alloc_skb                      [kernel]
             2680.00  2.9% acpi_pm_read                     [kernel]
             2498.00  2.7% sched_clock                      [kernel]
             2409.00  2.6% copy_user_generic_string         [kernel]
             2016.00  2.2% lock_release_holdtime            [kernel]
             1899.00  2.0% sched_clock_cpu                  [kernel]

but i think those should be gradually eliminated and improved, as lock 
statistics could become a quite popular thing.

If the tracepoints are named 'lock', people will expect less overhead, 
and might end up fixing/improving it. If it's named 'lockdep' on the 
other hand, the expectation is higher overhead.

	Ingo
