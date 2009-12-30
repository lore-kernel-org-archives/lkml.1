Return-Path: <linux-kernel-owner+w=401wt.eu-S1753057AbZL3PFo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753057AbZL3PFo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 10:05:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753037AbZL3PFn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 10:05:43 -0500
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:38776 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752981AbZL3PFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 10:05:43 -0500
Date: Wed, 30 Dec 2009 20:35:30 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] ksym_tracer: Fix to make the tracer work
Message-ID: <20091230150530.GA3401@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <4B3AF19E.1010201@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B3AF19E.1010201@cn.fujitsu.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 30, 2009 at 02:22:22PM +0800, Li Zefan wrote:
> ksym tracer doesn't work:
> 
>  # echo tasklist_lock:rw- > ksym_trace_filter
>  -bash: echo: write error: No such device
> 
> It's because we pass to perf_event_create_kernel_counter()
> a cpu number which is not present.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  kernel/hw_breakpoint.c    |   10 +++++++---
>  kernel/trace/trace_ksym.c |    1 -
>  2 files changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/hw_breakpoint.c b/kernel/hw_breakpoint.c
> index dbcbf6a..50dbd59 100644
> --- a/kernel/hw_breakpoint.c
> +++ b/kernel/hw_breakpoint.c
> @@ -40,6 +40,7 @@
>  #include <linux/percpu.h>
>  #include <linux/sched.h>
>  #include <linux/init.h>
> +#include <linux/cpu.h>
>  #include <linux/smp.h>
> 
>  #include <linux/hw_breakpoint.h>
> @@ -388,7 +389,8 @@ register_wide_hw_breakpoint(struct perf_event_attr *attr,
>  	if (!cpu_events)
>  		return ERR_PTR(-ENOMEM);
> 
> -	for_each_possible_cpu(cpu) {
> +	get_online_cpus();
> +	for_each_online_cpu(cpu) {
>  		pevent = per_cpu_ptr(cpu_events, cpu);
>  		bp = perf_event_create_kernel_counter(attr, cpu, -1, triggered);
>

Frederic must have used for_each_possible_cpu() to account for CPUs that
are offline at the time of registration, but may eventually turn online.
Since register_wide_hw_breakpoint() interface is designed to deliver
system-wide breakpoints, the debug registers of a new online CPU will
should have the breakpoints populated to comprehensively notify all
memory accesses over target address.

I'd rather wait to hear from Frederic to know why
perf_event_create_kernel_counter() returns an error when run for an
offline cpu and how it can be solved.

Thanks,
K.Prasad

