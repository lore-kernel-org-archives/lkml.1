Return-Path: <linux-kernel-owner+w=401wt.eu-S1759216AbZHRO6c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759216AbZHRO6c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 10:58:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759207AbZHRO6b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 10:58:31 -0400
Received: from mx2.redhat.com ([66.187.237.31]:36979 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759173AbZHRO6a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 10:58:30 -0400
Date: Tue, 18 Aug 2009 10:56:44 -0400
From: Jason Baron <jbaron@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mundt <lethal@linux-sh.org>, Stephen Rothwell <sfr@canb.auug.org.au>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Jiaying Zhang <jiayingz@google.com>, Martin Bligh <mbligh@google.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Masami Hiramatsu <mhiramat@redhat.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Wu Zhangjin <wuzj@lemote.com>, linux-next@vger.kernel.org,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [S390] ftrace: update system call tracer support
Message-ID: <20090818145644.GB2669@redhat.com>
References: <1250016545-6601-1-git-send-email-fweisbec@gmail.com> <20090812091133.GA21655@elte.hu> <20090818004654.GA4402@linux-sh.org> <20090818073211.GA26670@elte.hu> <20090818085110.GA2074@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090818085110.GA2074@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 18, 2009 at 10:51:10AM +0200, Ingo Molnar wrote:
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > * Paul Mundt <lethal@linux-sh.org> wrote:
> > 
> > > [ Adding to Cc everyone that now has a broken tree thanks to this .. ]
> > > 
> > > On Wed, Aug 12, 2009 at 11:11:33AM +0200, Ingo Molnar wrote:
> > > > * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > > > > This pull request integrate one cleanup/fix for ftrace and an 
> > > > > update for syscall tracing: the migration from old-style tracer to 
> > > > > individual tracepoints/trace_events and the support for perf 
> > > > > counter.
> > > > > 
> > > > > I've tested it with success either with ftrace (every syscall 
> > > > > tracepoints enabled at the same time without problems) and with 
> > > > > perfcounter.
> > > > > 
> > > > > May be one drawback: it creates so much trace events that the 
> > > > > ftrace selftests can take some time :-)
> > > > 
> > > > Pulled, thanks a lot!
> > > 
> > > And this has now subsequently broken every single SH and S390 
> > > configuration, [...]
> > 
> > I test SH cross-builds regularly. I just checked the SH defconfig 
> > and it builds just fine here:
> > 
> > $ make -j32 CROSS_COMPILE=sh3-linux- ARCH=sh vmlinux
> 
> The s390 build indeed broke. (This got masked by the s390 toolchain 
> i'm using not having been able to build Linus's tree - i fixed 
> that.)
> 
> Could you try the fix below? It does the trick here.
> 
> Martin, Heiko - does the fix look good to you? regs->gprs[2] seems 
> to be the register used for both the syscall number (enter 
> callback) and for the return code (exit callback).
> 
> Regarding SH, the fixup should be similarly trivial. Since SH's 
> FTRACE_SYSCALLS code is not upstream yet it can (and should) be 
> carried in the tree that integrates the SH tree and the tracing 
> tree - linux-next in this case.
> 
> Thanks,
> 
> 	Ingo
> 
> ------------------------------>
> From a9008fd42b1c3c89f684d90bdfb9c2d05c7af119 Mon Sep 17 00:00:00 2001
> From: Ingo Molnar <mingo@elte.hu>
> Date: Tue, 18 Aug 2009 10:41:57 +0200
> Subject: [PATCH] [S390] ftrace: update system call tracer support
> 
> Commit fb34a08c3 ("tracing: Add trace events for each syscall
> entry/exit") changed the lowlevel API to ftrace syscall tracing
> but did not update s390 which started making use of it recently.
> 
> This broke the s390 build, as reported by Paul Mundt.
> 
> Update the callbacks with the syscall number and the syscall
> return code values. This allows per syscall tracepoints,
> syscall argument enumeration /debug/tracing/events/syscalls/
> and perfcounters support and integration on s390 too.
> 
> Reported-by: Paul Mundt <lethal@linux-sh.org>
> Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
> Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
> Cc: Jason Baron <jbaron@redhat.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> LKML-Reference: <tip-fb34a08c3469b2be9eae626ccb96476b4687b810@git.kernel.org>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  arch/s390/kernel/ptrace.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/s390/kernel/ptrace.c b/arch/s390/kernel/ptrace.c
> index 43acd73..05f57cd 100644
> --- a/arch/s390/kernel/ptrace.c
> +++ b/arch/s390/kernel/ptrace.c
> @@ -662,7 +662,7 @@ asmlinkage long do_syscall_trace_enter(struct pt_regs *regs)
>  	}
>  
>  	if (unlikely(test_thread_flag(TIF_SYSCALL_FTRACE)))
> -		ftrace_syscall_enter(regs);
> +		trace_syscall_enter(regs, regs->gprs[2]);
>  
>  	if (unlikely(current->audit_context))
>  		audit_syscall_entry(is_compat_task() ?
> @@ -680,7 +680,7 @@ asmlinkage void do_syscall_trace_exit(struct pt_regs *regs)
>  				   regs->gprs[2]);
>  
>  	if (unlikely(test_thread_flag(TIF_SYSCALL_FTRACE)))
> -		ftrace_syscall_exit(regs);
> +		trace_syscall_exit(regs, regs->gprs[2]);
>  
>  	if (test_thread_flag(TIF_SYSCALL_TRACE))
>  		tracehook_report_syscall_exit(regs, 0);

thanks for fixing this up Ingo! Sorry for all the trouble.

perhaps, we should just reduce the entry/exit routines to just pass
'regs' since we already have the following abstractions for callbacks:

syscall_get_nr(current, regs);
syscall_get_return_value(current, regs);

Thus, we really only need to be passing 'regs'. I was passing more information
here, to make it easier for other users of the tracepoints...

thanks,

-Jason



