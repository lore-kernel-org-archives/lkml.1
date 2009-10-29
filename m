Return-Path: <linux-kernel-owner+w=401wt.eu-S1756806AbZJ2WYF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756806AbZJ2WYF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 18:24:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756743AbZJ2WYF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 18:24:05 -0400
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:34063 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756744AbZJ2WYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 18:24:03 -0400
Date: Fri, 30 Oct 2009 03:54:01 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [RFC Patch 0/4] Enhance perf-events to profile memory accesses
	using hw-breakpoints - ver II
Message-ID: <20091029222401.GB4596@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20091028155827.GA8604@in.ibm.com> <20091029081917.GC26970@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091029081917.GC26970@elte.hu>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 29, 2009 at 09:19:17AM +0100, Ingo Molnar wrote:
> 
> * K.Prasad <prasad@linux.vnet.ibm.com> wrote:
> 
[snipped]
> > 
> > #
> > #
> > # perf record -v -i -e breakpoint-readwrite:jiffies top
> > 
> > [Ran 'top' for about 10 seconds]
> 
> btw., you probably want to add the -a/--all option as well when you test 
> via top, to do system-wide profiling. With this command you profile top 
> itself (and its child tasks).
> 

Okay. Attached output to that effect in ver III of my patchset sent
here: http://lkml.org/lkml/2009/10/29/300

> > 
> > # perf report -i perf.data
> > # Samples: 2022950155
> > #
> > # Overhead  Command  Shared Object  Symbol
> > # ........  .......  .............  ......
> > #
> >     99.99%      top  [kernel]       [k] scheduler_tick
> >      0.01%     perf  [kernel]       [k] scheduler_tick
> >      0.00%      top  [kernel]       [k] set_track
> >      0.00%      top  [kernel]       [k] run_timer_softirq
> >      0.00%     perf  [kernel]       [k] set_track
> >      0.00%      top  [kernel]       [k] __call_rcu
> >      0.00%      top  [kernel]       [k] calc_global_load
> >      0.00%      top  [kernel]       [k] do_timer
> >      0.00%      top  [kernel]       [k] __rcu_process_callbacks
> > #
> > # (For a higher level overview, try: perf report --sort comm,dso)
> > #
> 
> That output looks pretty awesome! This way we can map out how frequently 
> global variables are used in the kernel - in stock distro kernels too. 
> Previously we could only measure it indirectly (by looking at 
> high-overhead functions and assembly level annotations), or by running 
> very costly instrumentation like Valgrind.
> 
> I like it how you extended --event with the breakpoint-readwrite:jiffies 
> method as well.
> 
> A few additional shortcuts/aliases would be nice, such as:
> 
>    perf record -v -i -e readwrite:jiffies top
> 
> as breakpoint-readwrite is pretty log users arent really interested in 
> the mechanism (hardware-breakpoints), they are more interested that it's 
> memory read-write profiling done at a given address.
> 
> Maybe even 'rw' would be a useful alias as well. There are alias tables 
> for events which you can use for this. You can define them via:
> 
>   { CHBP(WRITE),               "memory-write",     "write",     "w"  },
>   { CHBP(RW),                  "memory-readwrite", "readwrite", "rw" },
> 

I've added "memory-write" and "w" as the aliases (similarly
"memory-readwrite" and "rw" as shown under). "read" and "write" are
used as hw_cache_op[] aliases; moreover defining more than one alias
would require a separate structure (as done by hw_cache[] and
hw_cache_op[] and further changes in print_events()), and hence the
single alias. I'm open to any further suggestions on the renaming front.


+  { CHBP(WRITE),		"memory-write",		"w"		},
+  { CHBP(RW),			"memory-readwrite",	"rw"		},


> Anyway, this looks very good already - Frederic, if you like these 
> patches too feel free to send it to me in your next hw-breakpoints pull 
> request.
> 
> Thanks,
> 
> 	Ingo

I'm glad that you found value in the patchset and hope that this would
entail the feature's journey further into the mainline. Frederic's
previous mail suggests that I owe him more reasoning about the patches'
approach, before being sent out for a git pull!

Thanks,
K.Prasad


