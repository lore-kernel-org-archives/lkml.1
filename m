Return-Path: <linux-kernel-owner+w=401wt.eu-S932886AbZHZMcl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932886AbZHZMcl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 08:32:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932579AbZHZMck
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 08:32:40 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:37644 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932305AbZHZMcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 08:32:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ojf3v6xgsL54rFGnzwczAi4aXUuPefWE1BXHPGIpjQpbw3iqnUJrIkHr0XvLq09NP8
         dWMUxQfDge71wIR0HyKC+9m4uOv/8Y4ou9/NwXQMum30CfTMxQete8brov5sAnNW8kBe
         /yYBqH3q4Yz8RsNnssRdkUReL1ApDqJXq9pNs=
Date: Wed, 26 Aug 2009 14:32:32 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
       Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, laijs@cn.fujitsu.com, rostedt@goodmis.org,
       peterz@infradead.org, jiayingz@google.com, mbligh@google.com,
       lizf@cn.fujitsu.com
Subject: Re: [PATCH 08/12] add trace events for each syscall entry/exit
Message-ID: <20090826123229.GC6009@nowhere>
References: <20090825141547.GE6114@nowhere> <20090825160237.GG4639@cetus.boeblingen.de.ibm.com> <20090825162004.GA25058@Krystal> <20090825165912.GI6114@nowhere> <20090825173107.GJ6114@nowhere> <20090825183119.GC2448@Krystal> <20090826000426.0332cbf4@skybase> <20090826073819.GA4749@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090826073819.GA4749@osiris.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 26, 2009 at 09:38:20AM +0200, Heiko Carstens wrote:
> On Wed, Aug 26, 2009 at 12:04:26AM +0200, Martin Schwidefsky wrote:
> > On Tue, 25 Aug 2009 14:31:19 -0400
> > Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> > > The design proposal for this kthread behavior wrt syscalls is based on a
> > > very specific and current kernel behavior, that may happen to change and
> > > that I have actually seen proven incorrect. For instance, some
> > > proprietary Linux driver does very odd things with system calls within
> > > kernel threads, like invoking them with int 0x80.
> 
> That's broken.. some proprietary drivers even change the system call table.
> Do you want to be able to deal with that as well?
> 
> > > Yes, this is odd, but do we really want to tie the tracer that much to
> > > the actual OS implementation specificities ?
> > > 
> > > That sounds like a recipe for endless breakages and missing bits of
> > > instrumentation.
> > > 
> > > So my advice would be: if we want to trace the syscall entry/exit paths,
> > > let's trace them for the _whole_ system, and find ways to make it work
> > > for corner-cases rather than finding clever ways to diminish
> > > instrumentation coverage.
> > 
> > I guess that the real reason for the crash is hidden in the initialization
> > of the pt_regs structure of the kernel thread.
> 
> On s390 the reason is that the scvnr in the pt_regs structure of the initial
> kernel thread is initialized to 0. svcnr contains the system call number
> and system call number 0 does not exist.
> That's why we have
> 
> static inline long syscall_get_nr(struct task_struct *task,
> 				  struct pt_regs *regs)
> {
> 	return regs->svcnr ? regs->svcnr : -1;
> }
> 
> Now, if you fork a kernel thread from the initial task the pt_regs structure
> gets copied. Upon ret_from_fork the trace exit path will get -1 for
> syscall_get_nr().
>  
> > > Given the ret from fork example happens to be the first event fired
> > > after the thread is created, we should be able to deal with this problem
> > > by initializing the thread structure used by syscall exit tracing to an
> > > initial "ret from fork" value.
> > 
> > That is my best guess as well.
> 
> What would that value be? __NR_fork?
> 
> Syscall tracing of kernel threads seems to be wrong. If somebody would do
> a "modprobe" and the init function of the module would create a kernel thread
> then syscall_get_nr() at the ret_from_fork path of the kernel thread would
> return __NR_init_module. That is of course only true if the old kernel_thread()
> API would be used. For kthread_create() it would return the syscall of the
> thread from which the kthread daemon was forked (the initial process I would
> guess, which was initialized to 0).
> 
> So skipping kernel threads at the exit path seems so be the best fix, IMHO ;)


Yeah, we can decide to trace syscalls from kernel, but doing so through
the current syscalls tracepoints is broken.


 
> ---
>  kernel/trace/trace_syscalls.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> Index: linux-next/kernel/trace/trace_syscalls.c
> ===================================================================
> --- linux-next.orig/kernel/trace/trace_syscalls.c
> +++ linux-next/kernel/trace/trace_syscalls.c
> @@ -253,6 +253,8 @@ void ftrace_syscall_exit(struct pt_regs 
>  	struct ring_buffer_event *event;
>  	int syscall_nr;
>  
> +	if (!current->mm)
> +		return;


Hendrik Brueckner already beat you at it and sent
a patch that ignores the TIF_SYSCALL_TRACEPOINT setting for
the kernel threads.

I'll add your acked by on it, thanks!


>  	syscall_nr = syscall_get_nr(current, regs);
>  	if (!test_bit(syscall_nr, enabled_exit_syscalls))
>  		return;

