Return-Path: <linux-kernel-owner+w=401wt.eu-S1755360AbYKWQop@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755360AbYKWQop (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 11:44:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750871AbYKWQog
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 11:44:36 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:54837 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750837AbYKWQog (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 11:44:36 -0500
Date: Sun, 23 Nov 2008 17:44:22 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing/function-return-tracer: don't trace kfree
	while it frees the return stack
Message-ID: <20081123164422.GA10029@elte.hu>
References: <492985C8.7070205@gmail.com> <20081123164013.GC6206@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081123164013.GC6206@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

>  void ftrace_retfunc_exit_task(struct task_struct *t)
>  {
> -	kfree(t->ret_stack);
> +	struct ftrace_ret_stack	*ret_stack = t->ret_stack;
> +
>  	t->ret_stack = NULL;
> +	/* NULL must become visible to IRQs before we free it: */
> +	barrier();
> +
> +	kfree(ret_stack);
>  }

hm, this reminds me - this is the wrong place for the callback - the 
call stack is freed too early.

instead of freeing it in do_exit() (like it's done right now), it 
should be freed when the task struct and thread info is freed: in 
kernel/fork.c:free_task() - okay?

The difference is minor but could allow more complete tracing: as 
right now we'll skip the entries that get generated when we schedule 
away from a dead task.

	Ingo
