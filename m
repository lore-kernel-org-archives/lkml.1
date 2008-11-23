Return-Path: <linux-kernel-owner+w=401wt.eu-S1756970AbYKWRnz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756970AbYKWRnz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 12:43:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751724AbYKWRnp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 12:43:45 -0500
Received: from mu-out-0910.google.com ([209.85.134.188]:37007 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130AbYKWRno convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 12:43:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=s/WKSJrFytyE750oyhhHfQYesWvEw2Syu/nj/F05Ql6MdDyqI+9aS7LbuLXvKr9v4O
         btYJjQ5l46VWdZgpXSDxXXrkhnIrkusG7mg5OLaVCl7TK41vwHfXUbYyoI0gBScYvr7Y
         edVhuc0cnxv9p7LpfOO5Q2w00s8iWpM1280Jg=
Message-ID: <4929964B.2000200@gmail.com>
Date: Sun, 23 Nov 2008 18:43:39 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing/function-return-tracer: don't trace kfree while
 it frees the return stack
References: <492985C8.7070205@gmail.com> <20081123164013.GC6206@elte.hu> <20081123164422.GA10029@elte.hu>
In-Reply-To: <20081123164422.GA10029@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar a écrit :
> note that we also need to keep gcc from reordering things here (no 
> matter how unlikely in this particular case).
> 
> (also, small detail: we prefer a newline after variable definitions.)
> 
> Full commit attached below.
> 

I guessed that since tsk->ret_stack is referenced for the last time before the call to kfree,
the registers to memory flushing would be done before the call.

But you're right, I should prevent from possible compiler strange behaviours, thanks!




Ingo Molnar a écrit :
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
>>  void ftrace_retfunc_exit_task(struct task_struct *t)
>>  {
>> -	kfree(t->ret_stack);
>> +	struct ftrace_ret_stack	*ret_stack = t->ret_stack;
>> +
>>  	t->ret_stack = NULL;
>> +	/* NULL must become visible to IRQs before we free it: */
>> +	barrier();
>> +
>> +	kfree(ret_stack);
>>  }
> 
> hm, this reminds me - this is the wrong place for the callback - the 
> call stack is freed too early.
> 
> instead of freeing it in do_exit() (like it's done right now), it 
> should be freed when the task struct and thread info is freed: in 
> kernel/fork.c:free_task() - okay?
> 
> The difference is minor but could allow more complete tracing: as 
> right now we'll skip the entries that get generated when we schedule 
> away from a dead task.
> 
> 	Ingo


That's right. Even if the noret code path will not be traced, we are loosing some traces.
That should be fixed with the patch below (didn't tested widely but seems good).
--
>From a7e143e42808f66a7128c7de322ebd6733b7cd17 Mon Sep 17 00:00:00 2001
From: Frederic Weisbecker <fweisbec@gmail.com>
Date: Sun, 23 Nov 2008 18:30:01 +0100
Subject: [PATCH] tracing/function-return-tracer: Free the return stack on free_task()

Impact: avoid loosing some traces when a task is freed

do_exit() is not the last function called when a task finishes.
There are still some functions which are to be called such as free_task().
So we delay the freeing of the return stack to the last moment.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>

diff --git a/kernel/exit.c b/kernel/exit.c
index c8334ed..cb24037 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -47,7 +47,6 @@
 #include <linux/task_io_accounting_ops.h>
 #include <linux/tracehook.h>
 #include <trace/sched.h>
-#include <linux/ftrace.h>
 
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
@@ -1125,7 +1124,6 @@ NORET_TYPE void do_exit(long code)
 	preempt_disable();
 	/* causes final put_task_struct in finish_task_switch(). */
 	tsk->state = TASK_DEAD;
-	ftrace_retfunc_exit_task(tsk);
 	schedule();
 	BUG();
 	/* Avoid "noreturn function does return".  */
diff --git a/kernel/fork.c b/kernel/fork.c
index 354d3f0..d183739 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -141,6 +141,7 @@ void free_task(struct task_struct *tsk)
 	prop_local_destroy_single(&tsk->dirties);
 	free_thread_info(tsk->stack);
 	rt_mutex_debug_task_free(tsk);
+	ftrace_retfunc_exit_task(tsk);
 	free_task_struct(tsk);
 }
 EXPORT_SYMBOL(free_task);
-- 
1.5.2.5

