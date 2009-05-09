Return-Path: <linux-kernel-owner+w=401wt.eu-S1755098AbZEIRVh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755098AbZEIRVh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 13:21:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751386AbZEIRV3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 13:21:29 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:47765 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbZEIRV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 13:21:28 -0400
Date: Sun, 10 May 2009 02:15:51 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, "Frank Ch. Eigler" <fche@redhat.com>,
       Jason Baron <jbaron@redhat.com>, Tom Zanussi <tzanussi@gmail.com>,
       fweisbec@gmail.com, laijs@cn.fujitsu.com, rostedt@goodmis.org,
       peterz@infradead.org, jiayingz@google.com, roland@redhat.com,
       mbligh@google.com
Subject: Re: [RFC patch 15/20] LTTng Kernel Trace Thread Flag SH
Message-ID: <20090509171551.GA24725@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
	akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
	linux-kernel@vger.kernel.org, "Frank Ch. Eigler" <fche@redhat.com>,
	Jason Baron <jbaron@redhat.com>, Tom Zanussi <tzanussi@gmail.com>,
	fweisbec@gmail.com, laijs@cn.fujitsu.com, rostedt@goodmis.org,
	peterz@infradead.org, jiayingz@google.com, roland@redhat.com,
	mbligh@google.com
References: <20090509162209.217414024@polymtl.ca> <20090509162350.632906649@polymtl.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090509162350.632906649@polymtl.ca>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 09, 2009 at 12:22:24PM -0400, Mathieu Desnoyers wrote:
> Index: linux-2.6-lttng/arch/sh/include/asm/thread_info.h
> ===================================================================
> --- linux-2.6-lttng.orig/arch/sh/include/asm/thread_info.h	2009-03-15 15:57:04.000000000 -0400
> +++ linux-2.6-lttng/arch/sh/include/asm/thread_info.h	2009-03-15 15:57:17.000000000 -0400
> @@ -116,6 +116,7 @@ extern void free_thread_info(struct thre
>  #define TIF_SYSCALL_AUDIT	5	/* syscall auditing active */
>  #define TIF_SECCOMP		6	/* secure computing */
>  #define TIF_NOTIFY_RESUME	7	/* callback before returning to user */
> +#define TIF_KERNEL_TRACE	8	/* kernel trace active */
>  #define TIF_USEDFPU		16	/* FPU was used by this task this quantum (SMP) */
>  #define TIF_POLLING_NRFLAG	17	/* true if poll_idle() is polling TIF_NEED_RESCHED */
>  #define TIF_MEMDIE		18
> @@ -129,6 +130,7 @@ extern void free_thread_info(struct thre
>  #define _TIF_SYSCALL_AUDIT	(1 << TIF_SYSCALL_AUDIT)
>  #define _TIF_SECCOMP		(1 << TIF_SECCOMP)
>  #define _TIF_NOTIFY_RESUME	(1 << TIF_NOTIFY_RESUME)
> +#define _TIF_KERNEL_TRACE	(1 << TIF_KERNEL_TRACE)
>  #define _TIF_USEDFPU		(1 << TIF_USEDFPU)
>  #define _TIF_POLLING_NRFLAG	(1 << TIF_POLLING_NRFLAG)
>  #define _TIF_FREEZE		(1 << TIF_FREEZE)
> @@ -141,17 +143,19 @@ extern void free_thread_info(struct thre
>  
>  /* work to do in syscall trace */
>  #define _TIF_WORK_SYSCALL_MASK	(_TIF_SYSCALL_TRACE | _TIF_SINGLESTEP | \
> -				 _TIF_SYSCALL_AUDIT | _TIF_SECCOMP)
> +				 _TIF_SYSCALL_AUDIT | _TIF_SECCOMP | \
> +				 _TIF_KERNEL_TRACE)
>  
>  /* work to do on any return to u-space */
>  #define _TIF_ALLWORK_MASK	(_TIF_SYSCALL_TRACE | _TIF_SIGPENDING      | \
>  				 _TIF_NEED_RESCHED  | _TIF_SYSCALL_AUDIT   | \
>  				 _TIF_SINGLESTEP    | _TIF_RESTORE_SIGMASK | \
> -				 _TIF_NOTIFY_RESUME)
> +				 _TIF_NOTIFY_RESUME | _TIF_KERNEL_TRACE)
>  
>  /* work to do on interrupt/exception return */
>  #define _TIF_WORK_MASK		(_TIF_ALLWORK_MASK & ~(_TIF_SYSCALL_TRACE | \
> -				 _TIF_SYSCALL_AUDIT | _TIF_SINGLESTEP))
> +				 _TIF_SYSCALL_AUDIT | _TIF_SINGLESTEP | \
> +				 _TIF_KERNEL_TRACE))
>  
>  #endif /* __KERNEL__ */
>  
I think you missed the comment above this hunk in the code..

This will blow up immediately, _TIF_ALLWORK_MASK must presently fit
within a byte, as it just happens to right now. If this can take the
place of _TIF_SYSCALL_TRACE in the future, then that bit position can be
used instead, otherwise the assembly code will have to be rewritten to
load a larger value, which means we lose the ability to load the mask as
an immediate without resorting to shifting and masking :-(

Other platforms have similar constraints, have you verified that this is
not a problem on any of the other platforms?

I'll of course rewrite the assembly if we can't avoid it.
