Return-Path: <linux-kernel-owner+w=401wt.eu-S1752234AbZFSO4V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752234AbZFSO4V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 10:56:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751437AbZFSO4N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 10:56:13 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:51071 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378AbZFSO4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 10:56:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ue8EEjXgjgnPqo5wSRQW8cQ2QKryCebLO1rJDdcKUMq7vHqaIZcuwh3HmrGvcHD7DE
         HTnLRt2QCrajaaMOqHmJtvgYToNGnuInLsQKYZeKas8F1spvytHufPWQH6sk+XaTGibf
         v/38Eshx5PFBmFRBKb0qI7jfX0MifCpNe3o60=
Date: Fri, 19 Jun 2009 16:56:10 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, laijs@cn.fujitsu.com, rostedt@goodmis.org,
       peterz@infradead.org, jiayingz@google.com, bligh@google.com,
       roland@redhat.com, fche@redhat.com
Subject: Re: [PATCH 4/7] add syscall tracepoints
Message-ID: <20090619145609.GA6173@nowhere>
References: <cover.1244837725.git.jbaron@redhat.com> <46da2de326aa9ea1a9764cd421dd2ded70218c47.1244837725.git.jbaron@redhat.com> <20090619021237.GB7903@nowhere> <20090619123504.GB18428@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090619123504.GB18428@Krystal>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 19, 2009 at 08:35:04AM -0400, Mathieu Desnoyers wrote:
> * Frederic Weisbecker (fweisbec@gmail.com) wrote:
> > On Fri, Jun 12, 2009 at 05:24:54PM -0400, Jason Baron wrote:
> > > 
> > > add two tracepoints in syscall exit and entry path, conditioned on
> > > TIF_SYSCALL_FTRACE. Supports the syscall trace event code.
> > > 
> > > 
> > > Signed-off-by: Jason Baron <jbaron@redhat.com>
> > > 
> > > ---
> > >  arch/x86/kernel/ptrace.c |    6 ++++--
> > >  include/trace/syscall.h  |   18 ++++++++++++++++++
> > >  kernel/tracepoint.c      |   38 ++++++++++++++++++++++++++++++++++++++
> > >  3 files changed, 60 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
> > > index 09ecbde..1c7301a 100644
> > > --- a/arch/x86/kernel/ptrace.c
> > > +++ b/arch/x86/kernel/ptrace.c
> > > @@ -36,6 +36,8 @@
> > >  #include <asm/ds.h>
> > >  
> > >  #include <trace/syscall.h>
> > > +DEFINE_TRACE(syscall_enter);
> > > +DEFINE_TRACE(syscall_exit);
> > >  
> > >  #include "tls.h"
> > >  
> > > @@ -1498,7 +1500,7 @@ asmregparm long syscall_trace_enter(struct pt_regs *regs)
> > >  		ret = -1L;
> > >  
> > >  	if (unlikely(test_thread_flag(TIF_SYSCALL_FTRACE)))
> > > -		ftrace_syscall_enter(regs);
> > > +		trace_syscall_enter(regs, regs->orig_ax);
> > >  
> > >  	if (unlikely(current->audit_context)) {
> > >  		if (IS_IA32)
> > > @@ -1524,7 +1526,7 @@ asmregparm void syscall_trace_leave(struct pt_regs *regs)
> > >  		audit_syscall_exit(AUDITSC_RESULT(regs->ax), regs->ax);
> > >  
> > >  	if (unlikely(test_thread_flag(TIF_SYSCALL_FTRACE)))
> > > -		ftrace_syscall_exit(regs);
> > > +		trace_syscall_exit(regs, regs->ax);
> > >  
> > >  	if (test_thread_flag(TIF_SYSCALL_TRACE))
> > >  		tracehook_report_syscall_exit(regs, 0);
> > > diff --git a/include/trace/syscall.h b/include/trace/syscall.h
> > > index 8cfe515..d5d8310 100644
> > > --- a/include/trace/syscall.h
> > > +++ b/include/trace/syscall.h
> > > @@ -2,6 +2,24 @@
> > >  #define _TRACE_SYSCALL_H
> > >  
> > >  #include <asm/ptrace.h>
> > > +#include <linux/tracepoint.h>
> > > +
> > > +extern void syscall_regfunc(void);
> > > +extern void syscall_unregfunc(void);
> > > +
> > > +DECLARE_TRACE_REG(syscall_enter,
> > > +	TP_PROTO(struct pt_regs *regs, long id),
> > > +	TP_ARGS(regs, id),
> > > +	syscall_regfunc,
> > > +	syscall_unregfunc
> > > +);
> > > +
> > > +DECLARE_TRACE_REG(syscall_exit,
> > > +	TP_PROTO(struct pt_regs *regs, long ret),
> > > +	TP_ARGS(regs, ret),
> > > +	syscall_regfunc,
> > > +	syscall_unregfunc
> > > +);
> > >  
> > >  /*
> > >   * A syscall entry in the ftrace syscalls array.
> > > diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
> > > index 1ef5d3a..5b34ff9 100644
> > > --- a/kernel/tracepoint.c
> > > +++ b/kernel/tracepoint.c
> > 
> > 
> > 
> > At a first glance I wasn't sure tracepoint.c is the right
> > place for these.
> > But indeed putting those two callbacks here avoids any
> > dependency to the syscall tracer when someone else needs
> > the syscall tracepoints.
> > 
> > Well, I guess we can keep them there.
> > 
> > 
> > 
> > > @@ -24,6 +24,7 @@
> > >  #include <linux/tracepoint.h>
> > >  #include <linux/err.h>
> > >  #include <linux/slab.h>
> > > +#include <linux/sched.h>
> > >  
> > >  extern struct tracepoint __start___tracepoints[];
> > >  extern struct tracepoint __stop___tracepoints[];
> > > @@ -577,3 +578,40 @@ static int init_tracepoints(void)
> > >  __initcall(init_tracepoints);
> > >  
> > >  #endif /* CONFIG_MODULES */
> > > +
> > > +DEFINE_MUTEX(regfunc_mutex);
> > > +int sys_tracepoint_refcount;
> > 
> > 
> > Looks like regfunc_mutex is only there to protect
> > sys_tracepoint_refcount. May be you can just make it atomic_t?
> > 
> 
> Nope, regfunc_mutex makes sure there is no disable/enable occuring
> concurrently. They only take a tasklist read lock, so they can happen
> concurrently if it wasn't for the regfunc_mutex.
> 
> Unless I'm missing something totally obvious about the refcount, the
> mutex is needed, and there is no need to go for an atomic type in this
> case.
> 
> Thanks,
> 
> Mathieu



Ah...
Eh, you're right :)

Although concurrent enable/disable of the TIF flags would reveal a bug
in the tracepoint user (enable and disable not serialized).

But yeah let's keep it as a mutex.

Thanks.

 
> > Thanks,
> > Frederic.
> > 
> > 
> > > +
> > > +void syscall_regfunc(void)
> > > +{
> > > +	unsigned long flags;
> > > +	struct task_struct *g, *t;
> > > +
> > > +	mutex_lock(&regfunc_mutex);
> > > +	if (!sys_tracepoint_refcount) {
> > > +		read_lock_irqsave(&tasklist_lock, flags);
> > > +		do_each_thread(g, t) {
> > > +			set_tsk_thread_flag(t, TIF_SYSCALL_FTRACE);
> > > +		} while_each_thread(g, t);
> > > +		read_unlock_irqrestore(&tasklist_lock, flags);
> > > +	}
> > > +	sys_tracepoint_refcount++;
> > > +	mutex_unlock(&regfunc_mutex);
> > > +}
> > > +
> > > +void syscall_unregfunc(void)
> > > +{
> > > +	unsigned long flags;
> > > +	struct task_struct *g, *t;
> > > +
> > > +	mutex_lock(&regfunc_mutex);
> > > +	sys_tracepoint_refcount--;
> > > +	if (!sys_tracepoint_refcount) {
> > > +		read_lock_irqsave(&tasklist_lock, flags);
> > > +		do_each_thread(g, t) {
> > > +			clear_tsk_thread_flag(t, TIF_SYSCALL_FTRACE);
> > > +		} while_each_thread(g, t);
> > > +		read_unlock_irqrestore(&tasklist_lock, flags);
> > > +	}
> > > +	mutex_unlock(&regfunc_mutex);
> > > +}
> > > -- 
> > > 1.6.0.6
> > > 
> > 
> 
> -- 
> Mathieu Desnoyers
> OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

