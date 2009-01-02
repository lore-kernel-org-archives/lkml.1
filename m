Return-Path: <linux-kernel-owner+w=401wt.eu-S1759578AbZABV2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759578AbZABV2T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 16:28:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758374AbZABV2J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 16:28:09 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:47731 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758272AbZABV2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 16:28:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Ohl0MDdNC9v8CsnnIIDQXhdvww89RKmQ9RPq4b64b7Cpz6zFbIgAhY4HalS/laTZjG
         TXQvLcVVdlrUIrfzHsFATWtl5ULYTddeSNnkUhOtjDi9sQpAmzr7rm/lFmXGSQXC0PmL
         f4DBy1zd/fRhPtDVRFSfli1RVOckyyyAqJeYA=
Date: Fri, 2 Jan 2009 22:28:02 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] tracing/function-graph-tracer: tracing only syscalls
	mode
Message-ID: <20090102212801.GB5770@nowhere>
References: <495abce9.0baa660a.04de.60ae@mx.google.com> <20090102194014.GI14249@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090102194014.GI14249@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 02, 2009 at 08:40:14PM +0100, Ingo Molnar wrote:
> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > Impact: make more easy the syscalls tracing
> > 
> > This patch extends to syscalls the features which let one to trace
> > only one ore more function (and those they call).
> > This way we can get rid of the workqueues, kernel threads, softirqs from
> > ksoftirqd and only have the syscall path on the trace.
> > 
> > Note that hardirq that interrupt the syscalls are still traced. But we could
> > add an option to disable the interrupt tracing as well in the future.
> > 
> > To use this new feature:
> > 
> > echo function_graph > /debugfs/tracing/current_tracer
> > echo syscalls > /debugfs/tracing/set_graph_function
> 
> nice. I think a key item is missing though:
> 
> > @@ -1397,6 +1398,9 @@ asmregparm long syscall_trace_enter(struct pt_regs *regs)
> >  {
> >  	long ret = 0;
> >  
> > +	/* Tell the function graph tracer we are entering a system call */
> > +	ftrace_graph_syscall_enter();
> 
> We could actually trace the _syscalls_ themselves, a'la strace:


"a la" ? Oh pretty, those two words have been picked from french to english
language :-)
I didn't know.

Yes, these parameters displaying a la strace are in my projects, as well as
the return value of the syscalls (and other functions later).

 
>     munmap(0xb7ff3000, 4096)                = 0
> 
> So instead of the current ftrace output:
> 
>   0)   cc1-30212    |               |  sys32_mmap2() {
>   0)   cc1-30212    |               |    down_write() {
>   0)   cc1-30212    |   0.272 us    |      _spin_lock_irq();
>   0)   cc1-30212    |   0.969 us    |    }
>   0)   cc1-30212    |               |    do_mmap_pgoff() {
> 
> We could get something like:
> 
>   0)   cc1-30212    |               |  sys32_mmap2(0xb7ff3000, 4096) {
>   0)   cc1-30212    |               |    down_write() {
>   0)   cc1-30212    |   0.272 us    |      _spin_lock_irq();
>   0)   cc1-30212    |   0.969 us    |    }
>   0)   cc1-30212    |               |    do_mmap_pgoff() {
>   [...]
>   0)   cc1-30212    | + 22.537 us   |  } = 0
> 
> 
> Or maybe as separate trace entries:
> 
>   0)   cc1-30212    |               |> sys32_mmap2 [0xb7ff3000, 4096]
>   0)   cc1-30212    |               |  sys32_mmap2 {
>   0)   cc1-30212    |               |    down_write() {
>   0)   cc1-30212    |   0.272 us    |      _spin_lock_irq();
>   0)   cc1-30212    |   0.969 us    |    }
>   0)   cc1-30212    |               |    do_mmap_pgoff() {
>   [...]
>   0)   cc1-30212    | + 22.537 us   |  }
>   0)   cc1-30212    |               |< sys32_mmap2 => 0
> 
> For that we'd have to pass in something like the syscall function address 
> (sys_call_table[regs->ax]), and the up to 6 parameters 
> [regs->bx,cx,dx,si,di,bp].
> 
> (and initially we could just print all of them i guess, instead of a 
> variable-width thing)
> 
> We wouldnt do smart decoding of syscall arguments normally - just print 
> the raw arguments with no decoding. (like  strace -e raw=all)
> 
> How does this sound?


That sounds good. I just need a new entry type for this. I can pass all these
registers on insertion and filter them by syscall number on output stage.



