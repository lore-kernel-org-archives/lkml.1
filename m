Return-Path: <linux-kernel-owner+w=401wt.eu-S1758278AbZCOUJE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758278AbZCOUJE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 16:09:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753292AbZCOUIw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 16:08:52 -0400
Received: from tomts20.bellnexxia.net ([209.226.175.74]:55464 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752452AbZCOUIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 16:08:52 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: As0FAC73vElMQW1W/2dsb2JhbACBTpRzuUWDfwZh
Date: Sun, 15 Mar 2009 16:08:46 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@muc.de>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC patch 19/21] LTTng Linux Kernel Trace Thread Flag x86
Message-ID: <20090315200846.GB11749@Krystal>
References: <20090315190340.229569867@polymtl.ca> <20090315191105.269978012@polymtl.ca> <20090315195649.GA5212@nowhere>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090315195649.GA5212@nowhere>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 16:07:13 up 15 days, 16:33,  2 users,  load average: 0.42, 0.36,
	0.31
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Frederic Weisbecker (fweisbec@gmail.com) wrote:
> On Sun, Mar 15, 2009 at 03:03:59PM -0400, Mathieu Desnoyers wrote:
> > Add a thread flag to activate system-wide syscall tracing.
> > 
> > Make x86_64 support TIF_SYSCALL_TRACE async flag set in entry.S
> 
> 
> x86-32 :-)
> 
>  
> > When the flag is inactive upon syscall entry and concurrently activated before
> > exit, we seem to reach a state where the top of stack is incorrect upon return
> > to user space.
> > 
> > Fix this by fixing the top of stack and jumping to int_ret_from_sys_call if we
> > detect that thread flags has been modified.
> 
> 
> I don't see where you do that. May be you forgot some parts that match your changelog?
> 

Oh, I see. I moved the *.S modifications to the LTTng instrumentation
patches. Maybe those belong more to the kernel trace thread flags
patches. I'll move them and repost.

Thanks,

Mathieu

> > 
> > We make sure that the thread flag read is coherent between our new test and the ALLWORK_MASK test by first saving it in a register used for both comparisons.
> 
> Ditto.
> 
> Thanks,
> Frederic.
> 
> > 
> > Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> > CC: Andi Kleen <ak@muc.de>
> > CC: Thomas Gleixner <tglx@linutronix.de>
> > CC: Ingo Molnar <mingo@redhat.com>
> > CC: H. Peter Anvin <hpa@zytor.com>
> > ---
> >  arch/x86/include/asm/thread_info.h |    9 ++++++---
> >  arch/x86/kernel/entry_32.S         |    3 ++-
> >  2 files changed, 8 insertions(+), 4 deletions(-)
> > 
> > Index: linux-2.6-lttng/arch/x86/include/asm/thread_info.h
> > ===================================================================
> > --- linux-2.6-lttng.orig/arch/x86/include/asm/thread_info.h	2009-01-14 22:10:38.000000000 -0500
> > +++ linux-2.6-lttng/arch/x86/include/asm/thread_info.h	2009-01-14 22:25:08.000000000 -0500
> > @@ -79,6 +79,7 @@ struct thread_info {
> >  #define TIF_SYSCALL_EMU		6	/* syscall emulation active */
> >  #define TIF_SYSCALL_AUDIT	7	/* syscall auditing active */
> >  #define TIF_SECCOMP		8	/* secure computing */
> > +#define TIF_KERNEL_TRACE	9	/* kernel trace active */
> >  #define TIF_MCE_NOTIFY		10	/* notify userspace of an MCE */
> >  #define TIF_NOTSC		16	/* TSC is not accessible in userland */
> >  #define TIF_IA32		17	/* 32bit process */
> > @@ -102,6 +103,7 @@ struct thread_info {
> >  #define _TIF_SYSCALL_EMU	(1 << TIF_SYSCALL_EMU)
> >  #define _TIF_SYSCALL_AUDIT	(1 << TIF_SYSCALL_AUDIT)
> >  #define _TIF_SECCOMP		(1 << TIF_SECCOMP)
> > +#define _TIF_KERNEL_TRACE	(1 << TIF_KERNEL_TRACE)
> >  #define _TIF_MCE_NOTIFY		(1 << TIF_MCE_NOTIFY)
> >  #define _TIF_NOTSC		(1 << TIF_NOTSC)
> >  #define _TIF_IA32		(1 << TIF_IA32)
> > @@ -117,17 +119,18 @@ struct thread_info {
> >  
> >  /* work to do in syscall_trace_enter() */
> >  #define _TIF_WORK_SYSCALL_ENTRY	\
> > -	(_TIF_SYSCALL_TRACE | _TIF_SYSCALL_EMU | \
> > +	(_TIF_SYSCALL_TRACE | _TIF_KERNEL_TRACE | _TIF_SYSCALL_EMU | \
> >  	 _TIF_SYSCALL_AUDIT | _TIF_SECCOMP | _TIF_SINGLESTEP)
> >  
> >  /* work to do in syscall_trace_leave() */
> >  #define _TIF_WORK_SYSCALL_EXIT	\
> > -	(_TIF_SYSCALL_TRACE | _TIF_SYSCALL_AUDIT | _TIF_SINGLESTEP)
> > +	(_TIF_SYSCALL_TRACE | _TIF_KERNEL_TRACE | _TIF_SYSCALL_AUDIT | \
> > +	 _TIF_SINGLESTEP)
> >  
> >  /* work to do on interrupt/exception return */
> >  #define _TIF_WORK_MASK							\
> >  	(0x0000FFFF &							\
> > -	 ~(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|			\
> > +	 ~(_TIF_SYSCALL_TRACE|_TIF_KERNEL_TRACE|_TIF_SYSCALL_AUDIT|	\
> >  	   _TIF_SINGLESTEP|_TIF_SECCOMP|_TIF_SYSCALL_EMU))
> >  
> >  /* work to do on any return to user space */
> > Index: linux-2.6-lttng/arch/x86/kernel/entry_32.S
> > ===================================================================
> > --- linux-2.6-lttng.orig/arch/x86/kernel/entry_32.S	2009-01-14 22:22:40.000000000 -0500
> > +++ linux-2.6-lttng/arch/x86/kernel/entry_32.S	2009-01-14 22:25:44.000000000 -0500
> > @@ -571,7 +571,8 @@ END(syscall_trace_entry)
> >  	# perform syscall exit tracing
> >  	ALIGN
> >  syscall_exit_work:
> > -	testb $_TIF_WORK_SYSCALL_EXIT, %cl
> > +	/* Note, _TIF_KERNEL_TRACE is bit number 9, and so it needs testw and not testb */
> > +	testw $_TIF_WORK_SYSCALL_EXIT, %cx
> >  	jz work_pending
> >  	TRACE_IRQS_ON
> >  	ENABLE_INTERRUPTS(CLBR_ANY)	# could let syscall_trace_leave() call
> > 
> > -- 
> > Mathieu Desnoyers
> > OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
