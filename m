Return-Path: <linux-kernel-owner+w=401wt.eu-S1757590AbYKWIVy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757590AbYKWIVy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 03:21:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752411AbYKWIVp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 03:21:45 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:48457 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752284AbYKWIVo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 03:21:44 -0500
Date: Sun, 23 Nov 2008 09:21:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] tracing/function-return-tracer: clean up task start/exit
	callbacks
Message-ID: <20081123082132.GB30453@elte.hu>
References: <4928E8B0.1090103@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4928E8B0.1090103@gmail.com>
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


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Impact: use deeper tracing depth safely
> 
> Some tests showed that function return tracing needed a more deeper depth
> of function calls. But it could be unsafe to store these return addresses
> to the stack.
> So these arrays will now be allocated dynamically into task_struct of current
> only when the tracer is activated.
> 
> Typical scheme when tracer is activated:
> _ allocate a return stack for each task in global list.
> _ fork: allocate the return stack for the newly created task
> _ exit: free return stack of current
> _ idle init: same as fork
> 
> I chose a default depth of 50. I don't have anymore overruns (didn't tested for
> a long time).
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> ---
>  arch/x86/include/asm/ftrace.h      |    1 -
>  arch/x86/include/asm/thread_info.h |   29 -----------
>  arch/x86/kernel/ftrace.c           |   29 ++++++-----
>  include/linux/ftrace.h             |    5 ++
>  include/linux/sched.h              |   23 ++++-----
>  kernel/exit.c                      |    5 ++-
>  kernel/fork.c                      |    4 ++
>  kernel/sched.c                     |    3 +
>  kernel/trace/ftrace.c              |   96 +++++++++++++++++++++++++++++++++++-
>  9 files changed, 137 insertions(+), 58 deletions(-)

nice! Applied to tip/tracing/function-return-tracer and i started 
testing it as well.

I've done the small cleanup below on top of your patch - we try to 
avoid #ifdefs in core kernel code as much as possible, by hiding 
.config details into include files.

	Ingo

-------------->
>From 82f60f0bc854aada696f27d863c03bef91f1509d Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Sun, 23 Nov 2008 09:18:56 +0100
Subject: [PATCH] tracing/function-return-tracer: clean up task start/exit callbacks

Impact: cleanup

Eliminate #ifdefs in core code by using empty inline functions.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/ftrace.h |    3 +++
 kernel/exit.c          |    2 --
 kernel/fork.c          |    2 --
 kernel/sched.c         |    2 --
 4 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 2ba259b..938ca19 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -335,6 +335,9 @@ extern void unregister_ftrace_return(void);
 
 extern void ftrace_retfunc_init_task(struct task_struct *t);
 extern void ftrace_retfunc_exit_task(struct task_struct *t);
+#else
+static inline void ftrace_retfunc_init_task(struct task_struct *t) { }
+static inline void ftrace_retfunc_exit_task(struct task_struct *t) { }
 #endif
 
 #endif /* _LINUX_FTRACE_H */
diff --git a/kernel/exit.c b/kernel/exit.c
index b9d4463..ef04d03 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -1128,9 +1128,7 @@ NORET_TYPE void do_exit(long code)
 	preempt_disable();
 	/* causes final put_task_struct in finish_task_switch(). */
 	tsk->state = TASK_DEAD;
-#ifdef CONFIG_FUNCTION_RET_TRACER
 	ftrace_retfunc_exit_task(tsk);
-#endif
 	schedule();
 	BUG();
 	/* Avoid "noreturn function does return".  */
diff --git a/kernel/fork.c b/kernel/fork.c
index d1eb30e..fbf4a4c 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1270,9 +1270,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	total_forks++;
 	spin_unlock(&current->sighand->siglock);
 	write_unlock_irq(&tasklist_lock);
-#ifdef CONFIG_FUNCTION_RET_TRACER
 	ftrace_retfunc_init_task(p);
-#endif
 	proc_fork_connector(p);
 	cgroup_post_fork(p);
 	return p;
diff --git a/kernel/sched.c b/kernel/sched.c
index fb17205..388d9db 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -5901,9 +5901,7 @@ void __cpuinit init_idle(struct task_struct *idle, int cpu)
 	 * The idle tasks have their own, simple scheduling class:
 	 */
 	idle->sched_class = &idle_sched_class;
-#ifdef CONFIG_FUNCTION_RET_TRACER
 	ftrace_retfunc_init_task(idle);
-#endif
 }
 
 /*
