Return-Path: <linux-kernel-owner+w=401wt.eu-S1761220AbZDHQJr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761220AbZDHQJr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 12:09:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752705AbZDHQJh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 12:09:37 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57377 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752732AbZDHQJg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 12:09:36 -0400
Date: Wed, 8 Apr 2009 18:09:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux kernel <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tim Bird <tim.bird@am.sony.com>, Ingo Molnar <mingo@redhat.com>,
       Abhishek Sagar <sagar.abhishek@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH][GIT PULL] x86, function-graph: only save return values
	on x86_64
Message-ID: <20090408160915.GD16759@elte.hu>
References: <49C936CA.8070800@am.sony.com> <20090324213618.GC5975@nowhere> <20090324214846.GB29509@elte.hu> <20090324215738.GD5975@nowhere> <alpine.DEB.2.00.0903251153500.5675@gandalf.stny.rr.com> <alpine.DEB.2.00.0903251625490.5675@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0903251625490.5675@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(replying to old mail - working down my awful email backlog)

do we still need this for -tip?

	Ingo

* Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> Ingo,
> 
> Please pull the latest tip/tracing/function-graph tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/tracing/function-graph
> 
> 
> Steven Rostedt (1):
>       x86, function-graph: only save return values on x86_64
> 
> ----
>  arch/x86/kernel/entry_64.S |   19 +++----------------
>  1 files changed, 3 insertions(+), 16 deletions(-)
> ---------------------------
> commit d5b754b2208b1c22691a7cd5d1a65398b5973d74
> Author: Steven Rostedt <srostedt@redhat.com>
> Date:   Wed Mar 25 14:30:04 2009 -0400
> 
>     x86, function-graph: only save return values on x86_64
>     
>     Impact: speed up
>     
>     The return to handler portion of the function graph tracer should only
>     need to save the return values. The caller already saved off the
>     registers that the callee can modify. The returning function already
>     saved the registers it modified. When we call our own trace function
>     it too will save the registers that the callee must restore.
>     
>     There's no reason to save off anything more that the registers used
>     to return the values.
>     
>     Note, I did a complete kernel build with this modification and the
>     function graph tracer running on x86_64.
>     
>     Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> 
> diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
> index a331ec3..1ac9986 100644
> --- a/arch/x86/kernel/entry_64.S
> +++ b/arch/x86/kernel/entry_64.S
> @@ -147,27 +147,14 @@ END(ftrace_graph_caller)
>  GLOBAL(return_to_handler)
>  	subq  $80, %rsp
>  
> +	/* Save the return values */
>  	movq %rax, (%rsp)
> -	movq %rcx, 8(%rsp)
> -	movq %rdx, 16(%rsp)
> -	movq %rsi, 24(%rsp)
> -	movq %rdi, 32(%rsp)
> -	movq %r8, 40(%rsp)
> -	movq %r9, 48(%rsp)
> -	movq %r10, 56(%rsp)
> -	movq %r11, 64(%rsp)
> +	movq %rdx, 8(%rsp)
>  
>  	call ftrace_return_to_handler
>  
>  	movq %rax, 72(%rsp)
> -	movq 64(%rsp), %r11
> -	movq 56(%rsp), %r10
> -	movq 48(%rsp), %r9
> -	movq 40(%rsp), %r8
> -	movq 32(%rsp), %rdi
> -	movq 24(%rsp), %rsi
> -	movq 16(%rsp), %rdx
> -	movq 8(%rsp), %rcx
> +	movq 8(%rsp), %rdx
>  	movq (%rsp), %rax
>  	addq $72, %rsp
>  	retq
