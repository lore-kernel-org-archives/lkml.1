Return-Path: <linux-kernel-owner+w=401wt.eu-S1759115AbZFSDYu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759115AbZFSDYu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 23:24:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751533AbZFSDYm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 23:24:42 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:62040 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912AbZFSDYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 23:24:42 -0400
Date: Thu, 18 Jun 2009 23:24:42 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Jason Baron <jbaron@redhat.com>
cc: linux-kernel@vger.kernel.org, fweisbec@gmail.com, mingo@elte.hu,
       laijs@cn.fujitsu.com, peterz@infradead.org,
       mathieu.desnoyers@polymtl.ca, jiayingz@google.com, bligh@google.com,
       roland@redhat.com, fche@redhat.com
Subject: Re: [PATCH 2/7] add syscall tracepoints
In-Reply-To: <60b91c42482cf69f925b43dc3e2c322da0f36130.1244837725.git.jbaron@redhat.com>
Message-ID: <alpine.DEB.2.00.0906182324020.6890@gandalf.stny.rr.com>
References: <cover.1244837725.git.jbaron@redhat.com> <60b91c42482cf69f925b43dc3e2c322da0f36130.1244837725.git.jbaron@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 12 Jun 2009, Jason Baron wrote:

> 
> Call arch_init_ftrace_syscalls at boot, so we can determine the set of syscalls
> for the syscall trace events.
> 
> 
> Signed-off-by: Jason Baron <jbaron@redhat.com>
> 
> ---
>  arch/x86/kernel/ftrace.c |    8 +++++---
>  1 files changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
> index 30baa5b..9f2aa83 100644
> --- a/arch/x86/kernel/ftrace.c
> +++ b/arch/x86/kernel/ftrace.c
> @@ -518,7 +518,7 @@ int syscall_name_to_nr(char *name)
>  	return -1;
>  }
>  
> -void arch_init_ftrace_syscalls(void)
> +int arch_init_ftrace_syscalls(void)
>  {
>  	int i;
>  	struct syscall_metadata *meta;
> @@ -532,17 +532,19 @@ void arch_init_ftrace_syscalls(void)
>  					FTRACE_SYSCALL_MAX, GFP_KERNEL);
>  	if (!syscalls_metadata) {
>  		WARN_ON(1);
> -		return;
> +		return -ENOMEM;
>  	}
>  
>  	for (i = 0; i < FTRACE_SYSCALL_MAX; i++) {
>  		meta = find_syscall_meta(psys_syscall_table[i]);
>  		syscalls_metadata[i] = meta;
>  	}
> -	return;
> +	return 0;
>  
>  	/* Paranoid: avoid overflow */
>  end:
>  	atomic_dec(&refs);
> +	return 0;
>  }
> +arch_initcall(arch_init_ftrace_syscalls);

If we add this, can't we make it static and remove the call to it from 
kernel/trace/trace_syscalls.c ?

-- Steve

>  #endif
> -- 
> 1.6.0.6
> 
> 
