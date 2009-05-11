Return-Path: <linux-kernel-owner+w=401wt.eu-S1755094AbZEKIZ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755094AbZEKIZ7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 04:25:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752936AbZEKIZu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 04:25:50 -0400
Received: from mtagate2.de.ibm.com ([195.212.17.162]:43893 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752315AbZEKIZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 04:25:49 -0400
Date: Mon, 11 May 2009 10:25:45 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, "Frank Ch. Eigler" <fche@redhat.com>,
       Jason Baron <jbaron@redhat.com>, Tom Zanussi <tzanussi@gmail.com>,
       fweisbec@gmail.com, laijs@cn.fujitsu.com, rostedt@goodmis.org,
       peterz@infradead.org, jiayingz@google.com, roland@redhat.com,
       mbligh@google.com, Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [RFC patch 14/20] LTTng Kernel Trace Thread Flag s390
Message-ID: <20090511102545.3a6ae7cb@osiris.boeblingen.de.ibm.com>
In-Reply-To: <20090509162350.477343212@polymtl.ca>
References: <20090509162209.217414024@polymtl.ca>
	<20090509162350.477343212@polymtl.ca>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 09 May 2009 12:22:23 -0400
Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> Add a thread flag to activate system-wide syscall tracing.
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> ---
>  arch/s390/include/asm/thread_info.h |    2 ++
>  arch/s390/kernel/entry.S            |   10 ++++++++--
>  arch/s390/kernel/entry64.S          |   10 ++++++++--
>  3 files changed, 18 insertions(+), 4 deletions(-)
> 
> Index: linux-2.6-lttng/arch/s390/include/asm/thread_info.h
> ===================================================================
> --- linux-2.6-lttng.orig/arch/s390/include/asm/thread_info.h	2009-03-15 15:57:04.000000000 -0400
> +++ linux-2.6-lttng/arch/s390/include/asm/thread_info.h	2009-03-15 15:57:17.000000000 -0400
> @@ -90,6 +90,7 @@ static inline struct thread_info *curren
>  #define TIF_SYSCALL_AUDIT	5	/* syscall auditing active */
>  #define TIF_SINGLE_STEP		6	/* deliver sigtrap on return to user */
>  #define TIF_MCCK_PENDING	7	/* machine check handling is pending */
> +#define TIF_KERNEL_TRACE	8	/* kernel trace active */
>  #define TIF_USEDFPU		16	/* FPU was used by this task this quantum (SMP) */
>  #define TIF_POLLING_NRFLAG	17	/* true if poll_idle() is polling 
>  					   TIF_NEED_RESCHED */
> @@ -107,6 +108,7 @@ static inline struct thread_info *curren
>  #define _TIF_SYSCALL_AUDIT	(1<<TIF_SYSCALL_AUDIT)
>  #define _TIF_SINGLE_STEP	(1<<TIF_SINGLE_STEP)
>  #define _TIF_MCCK_PENDING	(1<<TIF_MCCK_PENDING)
> +#define _TIF_KERNEL_TRACE	(1<<TIF_KERNEL_TRACE)
>  #define _TIF_USEDFPU		(1<<TIF_USEDFPU)
>  #define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)
>  #define _TIF_31BIT		(1<<TIF_31BIT)
> Index: linux-2.6-lttng/arch/s390/kernel/entry.S
> ===================================================================
> --- linux-2.6-lttng.orig/arch/s390/kernel/entry.S	2009-03-15 15:51:10.000000000 -0400
> +++ linux-2.6-lttng/arch/s390/kernel/entry.S	2009-03-15 15:57:17.000000000 -0400
> @@ -265,7 +265,9 @@ sysc_do_restart:
>  	sth	%r7,SP_SVCNR(%r15)
>  	sll	%r7,2		  # svc number *4
>  	l	%r8,BASED(.Lsysc_table)
> -	tm	__TI_flags+3(%r9),(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT)
> +	l	%r8,__TI_flags+3(%r9)
> +	n	%r8,BASED(.Lc_tif_syscall_trace_or_audit_or_kernel_trace)
> +	ltr	%r8,%r8
>  	l	%r8,0(%r7,%r8)	  # get system call addr.
>  	bnz	BASED(sysc_tracesys)

That would be two more instructions (ltr is not needed) and an
additional memory access instead of just one for the fast path just
for debugging purposes.
All this can be avoided if the TIF flags would be rearranged. And
that's exactly what I already did because I needed it for something
else.
Please have a look at linux-next.
