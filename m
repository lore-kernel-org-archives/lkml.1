Return-Path: <linux-kernel-owner+w=401wt.eu-S1761265AbZJMUrw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761265AbZJMUrw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 16:47:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756983AbZJMUrv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 16:47:51 -0400
Received: from tomts16-srv.bellnexxia.net ([209.226.175.4]:46602 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752697AbZJMUru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 16:47:50 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AicFABiB1EpMRK1g/2dsb2JhbACBUdhehC0E
Date: Tue, 13 Oct 2009 16:47:02 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 1/5] [PATCH 1/5] function-graph/x86: replace unbalanced
	ret with jmp
Message-ID: <20091013204702.GA4533@Krystal>
References: <20091013203349.814936710@goodmis.org> <20091013203425.042034383@goodmis.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20091013203425.042034383@goodmis.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 16:39:04 up 56 days,  7:28,  2 users,  load average: 0.14, 0.17,
	0.17
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> From: Steven Rostedt <srostedt@redhat.com>
> 
> The function graph tracer replaces the return address with a hook to
> trace the exit of the function call. This hook will finish by returning
> to the real location the function should return to.
> 
> But the current implementation uses a ret to jump to the real return
> location. This causes a imbalance between calls and ret. That is
> the original function does a call, the ret goes to the handler
> and then the handler does a ret without a matching call.
> 
> Although the function graph tracer itself still breaks the branch
> predictor by replacing the original ret, by using a second ret and
> causing an imbalance, it breaks the predictor even more.
> 
> This patch replaces the ret with a jmp to keep the calls and ret
> balanced. I tested this on one box and it showed a 1.7% increase in
> performance. Another box only showed a small 0.3% increase. But no
> box that I tested this on showed a decrease in performance by making this
> change.

This sounds exactly like what I proposed at LPC. I'm glad it shows
actual improvements.

Just to make sure I understand, the old sequence was:

call fct
  call ftrace_entry
  ret to fct
ret to ftrace_exit
ret to caller

and you now have:

call fct
  call ftrace_entry
  ret to fct
ret to ftrace_exit
jmp to caller

Am I correct ?

Mathieu

> 
> Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  arch/x86/kernel/entry_32.S |    7 ++-----
>  arch/x86/kernel/entry_64.S |    6 +++---
>  2 files changed, 5 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
> index c097e7d..7d52e9d 100644
> --- a/arch/x86/kernel/entry_32.S
> +++ b/arch/x86/kernel/entry_32.S
> @@ -1185,17 +1185,14 @@ END(ftrace_graph_caller)
>  
>  .globl return_to_handler
>  return_to_handler:
> -	pushl $0
>  	pushl %eax
> -	pushl %ecx
>  	pushl %edx
>  	movl %ebp, %eax
>  	call ftrace_return_to_handler
> -	movl %eax, 0xc(%esp)
> +	movl %eax, %ecx
>  	popl %edx
> -	popl %ecx
>  	popl %eax
> -	ret
> +	jmp *%ecx
>  #endif
>  
>  .section .rodata,"a"
> diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
> index b5c061f..bd5bbdd 100644
> --- a/arch/x86/kernel/entry_64.S
> +++ b/arch/x86/kernel/entry_64.S
> @@ -155,11 +155,11 @@ GLOBAL(return_to_handler)
>  
>  	call ftrace_return_to_handler
>  
> -	movq %rax, 16(%rsp)
> +	movq %rax, %rdi
>  	movq 8(%rsp), %rdx
>  	movq (%rsp), %rax
> -	addq $16, %rsp
> -	retq
> +	addq $24, %rsp
> +	jmp *%rdi
>  #endif
>  
>  
> -- 
> 1.6.3.3
> 
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
