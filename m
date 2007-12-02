Return-Path: <linux-kernel-owner+w=401wt.eu-S1756837AbXLBUIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756837AbXLBUIR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 15:08:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755342AbXLBUIF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 15:08:05 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:44369 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755161AbXLBUID (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 15:08:03 -0500
Date: Sun, 2 Dec 2007 21:07:22 +0100
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: Mark Lord <lkml@rtr.ca>, Pavel Machek <pavel@ucw.cz>,
       Mark Lord <liml@rtr.ca>, Thomas Gleixner <tglx@linutronix.de>,
       len.brown@intel.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       rjw@sisk.pl
Subject: Re: [BUG] Strange 1-second pauses during Resume-from-RAM
Message-ID: <20071202200722.GA12101@elte.hu>
References: <20071201183256.GA14052@elte.hu> <20071201204747.GA6458@lazybastard.org> <20071201205456.GA8231@elte.hu> <20071201234112.GA7209@lazybastard.org> <20071202085607.GA28966@elte.hu> <20071202113143.GA9378@lazybastard.org> <20071202135711.GA20434@elte.hu> <20071202141117.GB9516@lazybastard.org> <20071202154746.GA27069@elte.hu> <20071202195501.GB10657@lazybastard.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20071202195501.GB10657@lazybastard.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jörn Engel <joern@logfs.org> wrote:

> On Sun, 2 December 2007 16:47:46 +0100, Ingo Molnar wrote:
> > 
> > well what does the trace say, where do the delays come from? To get a 
> > quick overview you can make tracing lighter weight by doing:
> > 
> >  echo 0 > /proc/sys/kernel/mcount_enabled
> >  echo 1 > /proc/sys/kernel/trace_syscalls
> 
> I mistyped and did 
>  echo 1 > /proc/sys/kernel/mcount_enabled
> 
> Result looked like a livelock and finally convinced me to abandon the 
> latency tracer.  Sorry, but it appears to be the right tool for the 
> wrong job.

hm, we routinely use it in -rt to capture "what on earth is happening" 
incidents. The snippet below is a random snipped from a trace that i've 
just captured, with mcount enabled. It seems to work fine here, with and 
without mcount. (pit clocksource is almost never used, that's why you 
had those early problems.)

oprofile helps if you can reliably reproduce the slowdown in a loop or 
for a long amount of time, with lots of CPU utilization - and then it's 
also lower overhead. The tracer can be used to capture rare or complex 
events, and gives the full flow control and what is happening within the 
kernel.

	Ingo

------------>
  <idle> 0     1D...  811us : sched_clock_idle_sleep_event (acpi_processor_idle)
  <idle> 0     1D...  813us : _spin_lock (sched_clock_idle_sleep_event)
trace-cm 2463  0....  814us : native_flush_tlb_others (flush_tlb_mm)
  <idle> 0     1D...  815us : __update_rq_clock (sched_clock_idle_sleep_event)
trace-cm 2463  0....  817us : _spin_lock (native_flush_tlb_others)
  <idle> 0     1D...  817us+: acpi_cstate_enter (acpi_processor_idle)
trace-cm 2463  0....  820us+: send_IPI_mask_bitmask (native_flush_tlb_others)
trace-cm 2463  0D...  823us+: apic_wait_icr_idle (send_IPI_mask_bitmask)
trace-cm 2463  0....  856us+: up_write (copy_process)
trace-cm 2463  0....  859us+: copy_keys (copy_process)
trace-cm 2463  0....  862us+: copy_namespaces (copy_process)
trace-cm 2463  0....  865us+: copy_thread (copy_process)
trace-cm 2463  0....  868us+: memcpy (copy_thread)
trace-cm 2463  0....  871us+: alloc_pid (copy_process)
trace-cm 2463  0....  874us+: kmem_cache_alloc (alloc_pid)
trace-cm 2463  0....  877us+: _spin_lock_irq (alloc_pid)
trace-cm 2463  0....  880us+: _write_lock_irq (copy_process)
trace-cm 2463  0D...  883us+: _spin_lock (copy_process)
trace-cm 2463  0D...  887us+: recalc_sigpending (copy_process)
trace-cm 2463  0D...  890us+: recalc_sigpending_tsk (recalc_sigpending)
trace-cm 2463  0D...  893us+: attach_pid (copy_process)
trace-cm 2463  0D...  896us+: attach_pid (copy_process)
trace-cm 2463  0D...  899us+: attach_pid (copy_process)
trace-cm 2463  0....  902us+: proc_fork_connector (copy_process)
trace-cm 2463  0....  905us+: wake_up_new_task (do_fork)
trace-cm 2463  0....  908us+: task_rq_lock (wake_up_new_task)
trace-cm 2463  0D...  911us+: _spin_lock (task_rq_lock)
trace-cm 2463  0D...  914us+: update_rq_clock (wake_up_new_task)
trace-cm 2463  0D...  918us+: __update_rq_clock (update_rq_clock)
trace-cm 2463  0D...  921us+: effective_prio (wake_up_new_task)
trace-cm 2463  0D...  924us+: wake_up_new_task <hwclock 2474> (0 0)
