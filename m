Return-Path: <linux-kernel-owner+w=401wt.eu-S1755959AbZHWVO1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755959AbZHWVO1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 17:14:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755934AbZHWVO1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 17:14:27 -0400
Received: from mail-ew0-f207.google.com ([209.85.219.207]:63033 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755933AbZHWVO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 17:14:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=FurQ4HIHpAwelByzQYbTiU2nJhmABV6DYu0aHiHazBDEAwxm+exS/PA8cKNaxVQXCB
         USKFIrugghYLSBHsasMkPdlcjXN7x3Ydg1yOjrhqAuLDB3leVTPaWsAG8GHTOGaLexEG
         KmvokcMVzKKhRYGKiXNy16TjMu+SN+JReu/44=
Date: Sun, 23 Aug 2009 23:14:24 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Josh Stone <jistone@redhat.com>
Cc: linux-kernel@vger.kernel.org, Jason Baron <jbaron@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Li Zefan <lizf@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Jiaying Zhang <jiayingz@google.com>, Martin Bligh <mbligh@google.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH v3 2/4] tracing: Make syscall_(un)regfunc arch-specific
Message-ID: <20090823211422.GG6256@nowhere>
References: <1250795373-32363-1-git-send-email-jistone@redhat.com> <1250917125-6174-1-git-send-email-jistone@redhat.com> <1250917125-6174-2-git-send-email-jistone@redhat.com> <1250917125-6174-3-git-send-email-jistone@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1250917125-6174-3-git-send-email-jistone@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 21, 2009 at 09:58:43PM -0700, Josh Stone wrote:
> The bodies of syscall_regfunc and syscall_unregfunc need the
> arch-specific flag TIF_SYSCALL_TRACEPOINT, which only exists
> on x86 and s390, so they should live in arch-specific files.


Sh also does, but currently in a seperate development branch.
(Adding Paul Mundt in Cc to prevent from further linux-next breakage).


 
> +
> +#ifdef CONFIG_TRACEPOINTS
> +
> +static DEFINE_MUTEX(regfunc_mutex);
> +static int sys_tracepoint_refcount;
> +
> +void syscall_regfunc(void)
> +{
> +	unsigned long flags;
> +	struct task_struct *g, *t;
> +
> +	mutex_lock(&regfunc_mutex);
> +	if (!sys_tracepoint_refcount) {
> +		read_lock_irqsave(&tasklist_lock, flags);
> +		do_each_thread(g, t) {
> +			set_tsk_thread_flag(t, TIF_SYSCALL_TRACEPOINT);
> +		} while_each_thread(g, t);
> +		read_unlock_irqrestore(&tasklist_lock, flags);
> +	}
> +	sys_tracepoint_refcount++;
> +	mutex_unlock(&regfunc_mutex);
> +}
> +
> +void syscall_unregfunc(void)
> +{
> +	unsigned long flags;
> +	struct task_struct *g, *t;
> +
> +	mutex_lock(&regfunc_mutex);
> +	sys_tracepoint_refcount--;
> +	if (!sys_tracepoint_refcount) {
> +		read_lock_irqsave(&tasklist_lock, flags);
> +		do_each_thread(g, t) {
> +			clear_tsk_thread_flag(t, TIF_SYSCALL_TRACEPOINT);
> +		} while_each_thread(g, t);
> +		read_unlock_irqrestore(&tasklist_lock, flags);
> +	}
> +	mutex_unlock(&regfunc_mutex);
> +}
> +#endif
> diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
> index a909afe..c2adbed 100644
> --- a/arch/x86/kernel/ptrace.c
> +++ b/arch/x86/kernel/ptrace.c
> @@ -1549,3 +1549,43 @@ asmregparm void syscall_trace_leave(struct pt_regs *regs)
>  	    tracehook_consider_fatal_signal(current, SIGTRAP))
>  		send_sigtrap(current, regs, 0, TRAP_BRKPT);
>  }
> +
> +#ifdef CONFIG_TRACEPOINTS
> +
> +static DEFINE_MUTEX(regfunc_mutex);
> +static int sys_tracepoint_refcount;
> +
> +void syscall_regfunc(void)
> +{
> +	unsigned long flags;
> +	struct task_struct *g, *t;
> +
> +	mutex_lock(&regfunc_mutex);
> +	if (!sys_tracepoint_refcount) {
> +		read_lock_irqsave(&tasklist_lock, flags);
> +		do_each_thread(g, t) {
> +			set_tsk_thread_flag(t, TIF_SYSCALL_TRACEPOINT);
> +		} while_each_thread(g, t);
> +		read_unlock_irqrestore(&tasklist_lock, flags);
> +	}
> +	sys_tracepoint_refcount++;
> +	mutex_unlock(&regfunc_mutex);
> +}
> +
> +void syscall_unregfunc(void)
> +{
> +	unsigned long flags;
> +	struct task_struct *g, *t;
> +
> +	mutex_lock(&regfunc_mutex);
> +	sys_tracepoint_refcount--;
> +	if (!sys_tracepoint_refcount) {
> +		read_lock_irqsave(&tasklist_lock, flags);
> +		do_each_thread(g, t) {
> +			clear_tsk_thread_flag(t, TIF_SYSCALL_TRACEPOINT);
> +		} while_each_thread(g, t);
> +		read_unlock_irqrestore(&tasklist_lock, flags);
> +	}
> +	mutex_unlock(&regfunc_mutex);
> +}
> +#endif



I really don't like that.
See how the s390 and x86 version of the above code are completely
identical?

Please put this in kernel/ptrace.c

Thanks.

