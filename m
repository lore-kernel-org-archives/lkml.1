Return-Path: <linux-kernel-owner+w=401wt.eu-S1756334AbYAIE2Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756334AbYAIE2Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 23:28:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752567AbYAIE2P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 23:28:15 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:54295 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752248AbYAIE2O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 23:28:14 -0500
Subject: Re: [PATCH 1/4] add task handling notifier: base definitions
From: Matthew Helsley <matthltc@us.ibm.com>
To: Jan Beulich <jbeulich@novell.com>
Cc: linux-kernel@vger.kernel.org, Paul Jackson <pj@sgi.com>
In-Reply-To: <476A7832.76E4.0078.0@novell.com>
References: <476A7832.76E4.0078.0@novell.com>
Content-Type: text/plain
Date: Tue, 08 Jan 2008 20:28:09 -0800
Message-Id: <1199852889.17010.243.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-12-20 at 13:12 +0000, Jan Beulich wrote:
> This is the base patch, adding notification for task creation and
> deletion.
> 
> Signed-off-by: Jan Beulich <jbeulich@novell.com>
> ---
>  include/linux/sched.h |    8 +++++++-
>  kernel/fork.c         |   11 +++++++++++
>  2 files changed, 18 insertions(+), 1 deletion(-)
> 
> --- 2.6.24-rc5-notify-task.orig/include/linux/sched.h
> +++ 2.6.24-rc5-notify-task/include/linux/sched.h
> @@ -80,7 +80,7 @@ struct sched_param {
>  #include <linux/rcupdate.h>
>  #include <linux/futex.h>
>  #include <linux/rtmutex.h>
> -
> +#include <linux/notifier.h>
>  #include <linux/time.h>
>  #include <linux/param.h>
>  #include <linux/resource.h>
> @@ -1700,6 +1700,12 @@ extern int do_execve(char *, char __user
>  extern long do_fork(unsigned long, unsigned long, struct pt_regs *, unsigned long, int __user *, int __user *);
>  struct task_struct *fork_idle(int);
> 
> +#define TASK_NEW 1
> +#define TASK_DELETE 2
> +
> +extern struct blocking_notifier_head task_notifier_list;
> +extern struct atomic_notifier_head atomic_task_notifier_list;
> +
>  extern void set_task_comm(struct task_struct *tsk, char *from);
>  extern void get_task_comm(char *to, struct task_struct *tsk);
> 
> --- 2.6.24-rc5-notify-task.orig/kernel/fork.c
> +++ 2.6.24-rc5-notify-task/kernel/fork.c
> @@ -46,6 +46,7 @@
>  #include <linux/tsacct_kern.h>
>  #include <linux/cn_proc.h>
>  #include <linux/freezer.h>
> +#include <linux/notifier.h>
>  #include <linux/delayacct.h>
>  #include <linux/taskstats_kern.h>
>  #include <linux/random.h>
> @@ -71,6 +72,11 @@ DEFINE_PER_CPU(unsigned long, process_co
> 
>  __cacheline_aligned DEFINE_RWLOCK(tasklist_lock);  /* outer */
> 
> +BLOCKING_NOTIFIER_HEAD(task_notifier_list);
> +EXPORT_SYMBOL_GPL(task_notifier_list);
> +ATOMIC_NOTIFIER_HEAD(atomic_task_notifier_list);
> +EXPORT_SYMBOL_GPL(atomic_task_notifier_list);
> +

When these global notifier lists were proposed years ago folks at SGI
loudly objected with concerns over anticipated cache line bouncing on
512+ cpu machines. Is that no longer a concern?

>  int nr_processes(void)
>  {
>  	int cpu;
> @@ -121,6 +127,9 @@ void __put_task_struct(struct task_struc
>  	WARN_ON(atomic_read(&tsk->usage));
>  	WARN_ON(tsk == current);
> 
> +	atomic_notifier_call_chain(&atomic_task_notifier_list,
> +				   TASK_DELETE, tsk);
> +
>  	security_task_free(tsk);
>  	free_uid(tsk->user);
>  	put_group_info(tsk->group_info);

Would the atomic notifier call chain be necessary if you hooked into an
earlier section of do_exit() instead?

Cheers,
	-Matt Helsley

