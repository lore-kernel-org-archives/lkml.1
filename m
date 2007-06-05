Return-Path: <linux-kernel-owner+w=401wt.eu-S1760171AbXFELlY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760171AbXFELlY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 07:41:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752786AbXFELlQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 07:41:16 -0400
Received: from madara.hpl.hp.com ([192.6.19.124]:61822 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750837AbXFELlP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 07:41:15 -0400
Date: Tue, 5 Jun 2007 04:41:02 -0700
From: Stephane Eranian <eranian@hpl.hp.com>
To: David Rientjes <rientjes@google.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 17/22] 2.6.22-rc3 perfmon2 : modified powerpc files
Message-ID: <20070605114102.GG10199@frankl.hpl.hp.com>
Reply-To: eranian@hpl.hp.com
References: <200705291348.l4TDmVGp019827@frankl.hpl.hp.com> <alpine.DEB.0.99.0706040738530.10505@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.0.99.0706040738530.10505@chino.kir.corp.google.com>
User-Agent: Mutt/1.4.1i
Organisation: HP Labs Palo Alto
Address: HP Labs, 1U-17, 1501 Page Mill road, Palo Alto, CA 94304, USA.
E-mail: eranian@hpl.hp.com
X-HPL-MailScanner: Found to be clean
X-HPL-MailScanner-From: eranian@hpl.hp.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David,

On Mon, Jun 04, 2007 at 07:40:53AM -0700, David Rientjes wrote:
> > include/asm-powerpc/thread_info.h:
> > 	- add TIF_PERFMON which is used for PMU context switching in __switch_to()
> > 
> 
> You mean TIF_PERFMON_CTXSW and TIF_PERFMON_WORK.
> 
Yes.

> > --- linux-2.6.22.base/include/asm-powerpc/thread_info.h	2007-05-29 03:20:21.000000000 -0700
> > +++ linux-2.6.22/include/asm-powerpc/thread_info.h	2007-05-29 03:24:14.000000000 -0700
> > @@ -112,16 +112,18 @@ static inline struct thread_info *curren
> >  #define TIF_POLLING_NRFLAG	3	/* true if poll_idle() is polling
> >  					   TIF_NEED_RESCHED */
> >  #define TIF_32BIT		4	/* 32 bit binary */
> > -#define TIF_RUNLATCH		5	/* Is the runlatch enabled? */
> > -#define TIF_ABI_PENDING		6	/* 32/64 bit switch needed */
> > +#define TIF_PERFMON_WORK	5	/* work for pfm_handle_work() */
> > +#define TIF_PERFMON_CTXSW	6	/* perfmon needs ctxsw calls */
> >  #define TIF_SYSCALL_AUDIT	7	/* syscall auditing active */
> >  #define TIF_SINGLESTEP		8	/* singlestepping active */
> >  #define TIF_MEMDIE		9
> >  #define TIF_SECCOMP		10	/* secure computing */
> >  #define TIF_RESTOREALL		11	/* Restore all regs (implies NOERROR) */
> > -#define TIF_NOERROR		14	/* Force successful syscall return */
> > -#define TIF_RESTORE_SIGMASK	15	/* Restore signal mask in do_signal */
> > -#define TIF_FREEZE		16	/* Freezing for suspend */
> > +#define TIF_NOERROR		12	/* Force successful syscall return */
> > +#define TIF_RESTORE_SIGMASK	13	/* Restore signal mask in do_signal */
> > +#define TIF_FREEZE		14	/* Freezing for suspend */
> > +#define TIF_RUNLATCH		15	/* Is the runlatch enabled? */
> > +#define TIF_ABI_PENDING		16	/* 32/64 bit switch needed */
> >  
> >  /* as above, but as bit values */
> >  #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
> > @@ -129,8 +131,8 @@ static inline struct thread_info *curren
> >  #define _TIF_NEED_RESCHED	(1<<TIF_NEED_RESCHED)
> >  #define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)
> >  #define _TIF_32BIT		(1<<TIF_32BIT)
> > -#define _TIF_RUNLATCH		(1<<TIF_RUNLATCH)
> > -#define _TIF_ABI_PENDING	(1<<TIF_ABI_PENDING)
> > +#define _TIF_PERFMON_WORK	(1<<TIF_PERFMON_WORK)
> > +#define _TIF_PERFMON_CTXSW	(1<<TIF_PERFMON_CTXSW)
> >  #define _TIF_SYSCALL_AUDIT	(1<<TIF_SYSCALL_AUDIT)
> >  #define _TIF_SINGLESTEP		(1<<TIF_SINGLESTEP)
> >  #define _TIF_SECCOMP		(1<<TIF_SECCOMP)
> > @@ -138,10 +140,14 @@ static inline struct thread_info *curren
> >  #define _TIF_NOERROR		(1<<TIF_NOERROR)
> >  #define _TIF_RESTORE_SIGMASK	(1<<TIF_RESTORE_SIGMASK)
> >  #define _TIF_FREEZE		(1<<TIF_FREEZE)
> > +#define _TIF_RUNLATCH		(1<<TIF_RUNLATCH)
> > +#define _TIF_ABI_PENDING	(1<<TIF_ABI_PENDING)
> >  #define _TIF_SYSCALL_T_OR_A	(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|_TIF_SECCOMP)
> > +#define _TIF_PERFMON_WORK	(1<<TIF_PERFMON_WORK)
> > +#define _TIF_PERFMON_CTXSW	(1<<TIF_PERFMON_CTXSW)
> >  
> > -#define _TIF_USER_WORK_MASK	( _TIF_SIGPENDING | \
> > -				 _TIF_NEED_RESCHED | _TIF_RESTORE_SIGMASK)
> > +#define _TIF_USER_WORK_MASK	(_TIF_SIGPENDING | \
> > +				 _TIF_NEED_RESCHED | _TIF_RESTORE_SIGMASK| _TIF_PERFMON_WORK)
> >  #define _TIF_PERSYSCALL_MASK	(_TIF_RESTOREALL|_TIF_NOERROR)
> 
> No need to move _TIF_RUNLATCH or _TIF_ABI_PENDING.
> 

Well, that was done by IBM to simplify the code in entry_64.S dealing with _TIF_USER_WORK_MASK
would not have to add extra instructions to load the constant, i.e., it had to fit within the 16
low order  bits.

> >  
> >  /* Bits in local_flags */
> > diff --exclude=.git -urp linux-2.6.22.base/include/asm-powerpc/unistd.h linux-2.6.22/include/asm-powerpc/unistd.h
> > --- linux-2.6.22.base/include/asm-powerpc/unistd.h	2007-05-29 03:17:57.000000000 -0700
> > +++ linux-2.6.22/include/asm-powerpc/unistd.h	2007-05-29 03:24:14.000000000 -0700
> > @@ -330,10 +330,22 @@
> >  #define __NR_signalfd		305
> >  #define __NR_timerfd		306
> >  #define __NR_eventfd		307
> > +#define __NR_pfm_create_context	308
> > +#define __NR_pfm_write_pmcs	(__NR_pfm_create_context+1)
> > +#define __NR_pfm_write_pmds	(__NR_pfm_create_context+2)
> > +#define __NR_pfm_read_pmds	(__NR_pfm_create_context+3)
> > +#define __NR_pfm_load_context	(__NR_pfm_create_context+4)
> > +#define __NR_pfm_start		(__NR_pfm_create_context+5)
> > +#define __NR_pfm_stop		(__NR_pfm_create_context+6)
> > +#define __NR_pfm_restart	(__NR_pfm_create_context+7)
> > +#define __NR_pfm_create_evtsets	(__NR_pfm_create_context+8)
> > +#define __NR_pfm_getinfo_evtsets (__NR_pfm_create_context+9)
> > +#define __NR_pfm_delete_evtsets (__NR_pfm_create_context+10)
> > +#define __NR_pfm_unload_context	(__NR_pfm_create_context+11)
> >  
> >  #ifdef __KERNEL__
> >  
> > -#define __NR_syscalls		308
> > +#define __NR_syscalls		319
> >  
> 
> The highest numbered syscall, __NR_pfm_create_context+11, is 319 and 
> __NR_syscalls is set to the same, which is wrong.
> 
You mean, it is off by one, right? Should be 320, then.

Thanks for your feedback.


-- 

-Stephane
