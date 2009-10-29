Return-Path: <linux-kernel-owner+w=401wt.eu-S1753319AbZJ2ITj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753319AbZJ2ITj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 04:19:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752391AbZJ2ITi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 04:19:38 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57877 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753204AbZJ2ITd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 04:19:33 -0400
Date: Thu, 29 Oct 2009 09:19:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [RFC Patch 0/4] Enhance perf-events to profile memory accesses
	using hw-breakpoints - ver II
Message-ID: <20091029081917.GC26970@elte.hu>
References: <20091028155827.GA8604@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091028155827.GA8604@in.ibm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* K.Prasad <prasad@linux.vnet.ibm.com> wrote:

> Hi All,
> 	Please find version II of the patchset that enables perf-events to
> place hw-breakpoints over kernel symbols (along with requisite enhancements to
> the hw-breakpoint layer).
> 
> Changelog version II
> ---------------------
> Version I: http://lkml.org/lkml/2009/10/26/461
> 
> - Fixed parsing issues that disallowed other perf events to be invoked
> - Fixed user-space breakpoint usage which was broken due to patch 2/4
> - Introduced an instance of perf_sample_data for use by do_perf_sw_event()
> 
> An edited log of 'perf stat' and 'perf record' output is shown below for your
> reference.
> 
> Kindly let me know your suggestions/feedback about the same.
> 
> Thanks,
> K.Prasad
> 
> Screen logs
> ------------
> # perf stat -v -i -e breakpoint-readwrite:pid_max -e breakpoint-write:jiffies make kernel/futex.o
>   CHK     include/linux/version.h
>   CHK     include/linux/utsrelease.h
>   SYMLINK include/asm -> include/asm-x86
>   CALL    scripts/checksyscalls.sh
>   CC      kernel/futex.o
> breakpoint-readwrite: 68 298512531 298512531
> breakpoint-write: 235 298512531 298512531
> 
>  Performance counter stats for 'make kernel/futex.o':
> 
>              68  breakpoint-readwrite     #      0.000 M/sec
>             235  breakpoint-write         #      0.000 M/sec
> 
>    14.571235288  seconds time elapsed
> 
> #
> #
> # perf record -v -i -e breakpoint-readwrite:jiffies top
> 
> [Ran 'top' for about 10 seconds]

btw., you probably want to add the -a/--all option as well when you test 
via top, to do system-wide profiling. With this command you profile top 
itself (and its child tasks).

> 
> # perf report -i perf.data
> # Samples: 2022950155
> #
> # Overhead  Command  Shared Object  Symbol
> # ........  .......  .............  ......
> #
>     99.99%      top  [kernel]       [k] scheduler_tick
>      0.01%     perf  [kernel]       [k] scheduler_tick
>      0.00%      top  [kernel]       [k] set_track
>      0.00%      top  [kernel]       [k] run_timer_softirq
>      0.00%     perf  [kernel]       [k] set_track
>      0.00%      top  [kernel]       [k] __call_rcu
>      0.00%      top  [kernel]       [k] calc_global_load
>      0.00%      top  [kernel]       [k] do_timer
>      0.00%      top  [kernel]       [k] __rcu_process_callbacks
> #
> # (For a higher level overview, try: perf report --sort comm,dso)
> #

That output looks pretty awesome! This way we can map out how frequently 
global variables are used in the kernel - in stock distro kernels too. 
Previously we could only measure it indirectly (by looking at 
high-overhead functions and assembly level annotations), or by running 
very costly instrumentation like Valgrind.

I like it how you extended --event with the breakpoint-readwrite:jiffies 
method as well.

A few additional shortcuts/aliases would be nice, such as:

   perf record -v -i -e readwrite:jiffies top

as breakpoint-readwrite is pretty log users arent really interested in 
the mechanism (hardware-breakpoints), they are more interested that it's 
memory read-write profiling done at a given address.

Maybe even 'rw' would be a useful alias as well. There are alias tables 
for events which you can use for this. You can define them via:

  { CHBP(WRITE),               "memory-write",     "write",     "w"  },
  { CHBP(RW),                  "memory-readwrite", "readwrite", "rw" },

Anyway, this looks very good already - Frederic, if you like these 
patches too feel free to send it to me in your next hw-breakpoints pull 
request.

Thanks,

	Ingo
