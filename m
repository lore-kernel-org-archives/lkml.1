Return-Path: <linux-kernel-owner+w=401wt.eu-S1753708AbZFSIZO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753708AbZFSIZO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 04:25:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751362AbZFSIY7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 04:24:59 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49767 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751314AbZFSIY6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 04:24:58 -0400
Message-ID: <4A3B4BBC.6050303@cn.fujitsu.com>
Date: Fri, 19 Jun 2009 16:26:36 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Jason Baron <jbaron@redhat.com>
CC: linux-kernel@vger.kernel.org, fweisbec@gmail.com, mingo@elte.hu,
       laijs@cn.fujitsu.com, rostedt@goodmis.org, peterz@infradead.org,
       mathieu.desnoyers@polymtl.ca, jiayingz@google.com, bligh@google.com,
       roland@redhat.com, fche@redhat.com
Subject: Re: [PATCH 2/7] add syscall tracepoints
References: <cover.1244837725.git.jbaron@redhat.com> <60b91c42482cf69f925b43dc3e2c322da0f36130.1244837725.git.jbaron@redhat.com>
In-Reply-To: <60b91c42482cf69f925b43dc3e2c322da0f36130.1244837725.git.jbaron@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jason Baron wrote:
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

1. It's called at boot, so can be __init.

2. This patch breaks bisectability, now the declaration and definition
   of this function don't match.

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
>  #endif
