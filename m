Return-Path: <linux-kernel-owner+w=401wt.eu-S1759589AbZABTko@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759589AbZABTko (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 14:40:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758652AbZABTkW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 14:40:22 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:56610 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758606AbZABTkU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 14:40:20 -0500
Date: Fri, 2 Jan 2009 20:40:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] tracing/function-graph-tracer: tracing only syscalls
	mode
Message-ID: <20090102194014.GI14249@elte.hu>
References: <495abce9.0baa660a.04de.60ae@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <495abce9.0baa660a.04de.60ae@mx.google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Impact: make more easy the syscalls tracing
> 
> This patch extends to syscalls the features which let one to trace
> only one ore more function (and those they call).
> This way we can get rid of the workqueues, kernel threads, softirqs from
> ksoftirqd and only have the syscall path on the trace.
> 
> Note that hardirq that interrupt the syscalls are still traced. But we could
> add an option to disable the interrupt tracing as well in the future.
> 
> To use this new feature:
> 
> echo function_graph > /debugfs/tracing/current_tracer
> echo syscalls > /debugfs/tracing/set_graph_function

nice. I think a key item is missing though:

> @@ -1397,6 +1398,9 @@ asmregparm long syscall_trace_enter(struct pt_regs *regs)
>  {
>  	long ret = 0;
>  
> +	/* Tell the function graph tracer we are entering a system call */
> +	ftrace_graph_syscall_enter();

We could actually trace the _syscalls_ themselves, a'la strace:

    munmap(0xb7ff3000, 4096)                = 0

So instead of the current ftrace output:

  0)   cc1-30212    |               |  sys32_mmap2() {
  0)   cc1-30212    |               |    down_write() {
  0)   cc1-30212    |   0.272 us    |      _spin_lock_irq();
  0)   cc1-30212    |   0.969 us    |    }
  0)   cc1-30212    |               |    do_mmap_pgoff() {

We could get something like:

  0)   cc1-30212    |               |  sys32_mmap2(0xb7ff3000, 4096) {
  0)   cc1-30212    |               |    down_write() {
  0)   cc1-30212    |   0.272 us    |      _spin_lock_irq();
  0)   cc1-30212    |   0.969 us    |    }
  0)   cc1-30212    |               |    do_mmap_pgoff() {
  [...]
  0)   cc1-30212    | + 22.537 us   |  } = 0


Or maybe as separate trace entries:

  0)   cc1-30212    |               |> sys32_mmap2 [0xb7ff3000, 4096]
  0)   cc1-30212    |               |  sys32_mmap2 {
  0)   cc1-30212    |               |    down_write() {
  0)   cc1-30212    |   0.272 us    |      _spin_lock_irq();
  0)   cc1-30212    |   0.969 us    |    }
  0)   cc1-30212    |               |    do_mmap_pgoff() {
  [...]
  0)   cc1-30212    | + 22.537 us   |  }
  0)   cc1-30212    |               |< sys32_mmap2 => 0

For that we'd have to pass in something like the syscall function address 
(sys_call_table[regs->ax]), and the up to 6 parameters 
[regs->bx,cx,dx,si,di,bp].

(and initially we could just print all of them i guess, instead of a 
variable-width thing)

We wouldnt do smart decoding of syscall arguments normally - just print 
the raw arguments with no decoding. (like  strace -e raw=all)

How does this sound?

	Ingo
