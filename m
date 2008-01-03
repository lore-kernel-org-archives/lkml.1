Return-Path: <linux-kernel-owner+w=401wt.eu-S1754663AbYACR5F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754663AbYACR5F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 12:57:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751632AbYACR4z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 12:56:55 -0500
Received: from tomts40.bellnexxia.net ([209.226.175.97]:62805 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751343AbYACR4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 12:56:53 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FABWwfEdMROHU/2dsb2JhbACBV6hl
Date: Thu, 3 Jan 2008 12:56:50 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       "William L. Irwin" <sparclinux@vger.kernel.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [RFC PATCH 10/11] mcount tracer show task comm and pid
Message-ID: <20080103175650.GE30582@Krystal>
References: <20080103071609.478486470@goodmis.org> <20080103072228.212967487@goodmis.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080103072228.212967487@goodmis.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 12:55:40 up 60 days, 23:01,  6 users,  load average: 0.40, 0.46,
	0.50
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> This adds the task comm and pid to the trace output. This gives the
> output like:
> 
> CPU 0: sshd:2605 [<ffffffff80251858>] remove_wait_queue+0xc/0x4a <-- [<ffffffff802ad7be>] free_poll_entry+0x1e/0x2a
> CPU 2: bash:2610 [<ffffffff8038c3aa>] tty_check_change+0x9/0xb6 <-- [<ffffffff8038d295>] tty_ioctl+0x59f/0xcdd
> CPU 0: sshd:2605 [<ffffffff80491ec6>] _spin_lock_irqsave+0xe/0x81 <-- [<ffffffff80251863>] remove_wait_queue+0x17/0x4a
> CPU 2: bash:2610 [<ffffffff8024e2f7>] find_vpid+0x9/0x24 <-- [<ffffffff8038d325>] tty_ioctl+0x62f/0xcdd
> CPU 0: sshd:2605 [<ffffffff804923ec>] _spin_unlock_irqrestore+0x9/0x3a <-- [<ffffffff80251891>] remove_wait_queue+0x45/0x4a
> CPU 0: sshd:2605 [<ffffffff802a18b3>] fput+0x9/0x1b <-- [<ffffffff802ad7c6>] free_poll_entry+0x26/0x2a
> 
> 
> Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> ---
>  lib/mcount/tracer.c |    6 +++++-
>  lib/mcount/tracer.h |    3 +++
>  2 files changed, 8 insertions(+), 1 deletion(-)
> 
> Index: linux-compile.git/lib/mcount/tracer.c
> ===================================================================
> --- linux-compile.git.orig/lib/mcount/tracer.c	2008-01-02 23:17:21.000000000 -0500
> +++ linux-compile.git/lib/mcount/tracer.c	2008-01-02 23:17:44.000000000 -0500
> @@ -34,6 +34,7 @@ mctracer_add_trace_entry(struct mctracer
>  {
>  	unsigned long idx, idx_next;
>  	struct mctracer_entry *entry;
> +	struct task_struct *tsk = current;

Aren't there situations, like in the middle of a context switch, where
current is not valid ? Is also poses a problem for early boot, and NMI
tracing.

>  
>  	idx = tr->trace_idx[cpu];
>  	idx_next = idx + 1;
> @@ -52,6 +53,8 @@ mctracer_add_trace_entry(struct mctracer
>  	entry->idx	 = atomic_inc_return(&tr->cnt);
>  	entry->ip	 = ip;
>  	entry->parent_ip = parent_ip;
> +	entry->pid	 = tsk->pid;
> +	memcpy(entry->comm, tsk->comm, TASK_COMM_LEN);
>  }
>  
>  static inline notrace void trace_function(const unsigned long ip,
> @@ -223,7 +226,8 @@ static int s_show(struct seq_file *m, vo
>  			return -1;
>  		}
>  
> -		seq_printf(m, "  CPU %d:  ", iter->cpu);
> +		seq_printf(m, "CPU %d: ", iter->cpu);
> +		seq_printf(m, "%s:%d ", iter->ent->comm, iter->ent->pid);
>  		seq_print_ip_sym(m, iter->ent->ip);
>  		if (iter->ent->parent_ip) {
>  			seq_printf(m, " <-- ");
> Index: linux-compile.git/lib/mcount/tracer.h
> ===================================================================
> --- linux-compile.git.orig/lib/mcount/tracer.h	2008-01-02 23:16:15.000000000 -0500
> +++ linux-compile.git/lib/mcount/tracer.h	2008-01-02 23:17:44.000000000 -0500
> @@ -2,11 +2,14 @@
>  #define _LINUX_MCOUNT_TRACER_H
>  
>  #include <asm/atomic.h>
> +#include <linux/sched.h>
>  
>  struct mctracer_entry {
>  	unsigned long idx;
>  	unsigned long ip;
>  	unsigned long parent_ip;
> +	char comm[TASK_COMM_LEN];
> +	pid_t pid;
>  };
>  
>  struct mctracer_trace {
> 
> -- 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
