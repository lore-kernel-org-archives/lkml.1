Return-Path: <linux-kernel-owner+w=401wt.eu-S1758440AbYEMQFO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758440AbYEMQFO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 12:05:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755802AbYEMQFA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 12:05:00 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56033 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755085AbYEMQE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 12:04:58 -0400
Date: Tue, 13 May 2008 09:04:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hirofumi Nakagawa <hnakagawa@miraclelinux.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 1/1] MAZE: Mazed processes monitor
Message-Id: <20080513090427.7de762dc.akpm@linux-foundation.org>
In-Reply-To: <48297FD4.1060508@miraclelinux.com>
References: <48297FD4.1060508@miraclelinux.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 May 2008 20:47:32 +0900 Hirofumi Nakagawa <hnakagawa@miraclelinux.com> wrote:

> This patch for linux-2.6.25-mm1 that is tested on x86_64 hardware.
> 
> ...
>
> +static struct proc_dir_entry *maze_proc_dir;
> +
> +static int maze_initialized;
> +
> +static struct list_head maze_list;
> +static spinlock_t maze_list_lock;
> +
> +static int maze_timer_interval = 10;
> +
> +DEFINE_PER_CPU(struct list_head, maze_queue);
> +DEFINE_PER_CPU(spinlock_t, maze_queue_lock);
> +
> +DEFINE_PER_CPU(struct timer_list, maze_timer);

These three can be static?

Please document the data structures here at their definition sites with
code comments: what they are used for, what their locking rules are. 
Also, a per-cpu spinlock is somewhat unusual and a few words describing
why it is needed would be useful.

> +static inline void reset_maze_count(struct maze_context *context)
> +{
> +	context->reset_utime = context->task->utime;
> +	context->reset_stime = context->task->stime;
> +	context->flags = 0;
> +}
> +
> +static inline cputime_t get_maze_count(struct maze_context *context)
> +{
> +	return (context->task->utime - context->reset_utime) +
> +		(context->task->stime - context->reset_stime);
> +}
> +
> +/*
> + * This function is called start_kernel()
> + */
> +void maze_init_early(void)
> +{
> +	init_task.maze_context = NULL;
> +}
> +
> +/*
> + * This function is called do_exit()
> + */
> +void maze_exit(struct task_struct *task)
> +{
> +	unsigned long flags;
> +
> +	task_lock(task);
> +	if (task->maze_context) {
> +		spin_lock_irqsave(&per_cpu(maze_queue_lock,
> +								   task->maze_context->enqueue_cpu), flags);

There's a moderate amount of whitespace brokenness in here. 
scripts/checkpatch.pl detects some of it.

> +		if (task->maze_context->enqueue)
> +			list_del(&task->maze_context->queue);
> +		spin_unlock_irqrestore(&per_cpu(maze_queue_lock,
> +										task->maze_context->enqueue_cpu), flags);
> +
> +		spin_lock(&maze_list_lock);
> +		list_del(&task->maze_context->list);
> +		spin_unlock(&maze_list_lock);
> +
> +		kfree(task->maze_context);
> +		task->maze_context = NULL;
> +	}
> +	task_unlock(task);
> +}
>
> ...
>
> +/*
> + * Must be called under task_lock().
> + */
> +static inline void enqueue(struct maze_context *context)
> +{
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&__get_cpu_var(maze_queue_lock), flags);
> +	if (!context->enqueue) {
> +		list_add(&context->queue, &__get_cpu_var(maze_queue));
> +		context->enqueue_cpu = smp_processor_id();
> +		context->enqueue = 1;
> +	}
> +	spin_unlock_irqrestore(&__get_cpu_var(maze_queue_lock), flags);
> +}

The code uses `inline' too much, and is probably slower as a result. 
Most of all of them should be removed, please.

> +static void sched_in_event(struct preempt_notifier *notifier, int cpu)
> +{
> +	task_lock(current);
> +	if (current->maze_context) {
> +		if (current->state != TASK_RUNNING)
> +			reset_maze_count(current->maze_context);
> +		enqueue(current->maze_context);
> +	}
> +	task_unlock(current);
> +}

Please update the description of task_lock() in sched.h when adding new
rules to it.  I assume that it protects task_struct.maze_context.

I'm a little surprised to see a global lock being taken under
task_lock(): generally I think of task_lock() as a low-level thing
which protects only task internals.  I assume this code was runtime
tested with lockdep enabled?

But that doesn't mean that the chosen lock ranking is desirable.  From
a quick look the locking does seem logical.

> +static void sched_out_event(struct preempt_notifier *notifier,
> +							struct task_struct *next)
> +{
> +	task_lock(next);
> +	if (next->maze_context)
> +		enqueue(next->maze_context);
> +	task_unlock(next);
> +}
> +
> +static struct preempt_ops preempt_ops = {
> +	.sched_in = sched_in_event,
> +	.sched_out = sched_out_event,
> +};
> +
> +/*
> + * This function is called copy_process()
> + */

Some additional description here would be useful.  What does the function do?

> +void maze_fork(struct task_struct *task)
> +{
> +	task->maze_context = NULL;
> +
> +	if (!current->maze_context)
> +		return;
> +
> +	task_lock(task);
> +
> +	task->maze_context = kzalloc(sizeof(struct maze_context), GFP_ATOMIC);

GFP_ATOMIC is weak, and can fail.  With some reorganisation this could
be moved outside the lock and switched to GFP_KERNEL.

> +	if (unlikely(!task->maze_context)) {
> +		ERRPRINT("fail to alloc maze_context.\n");
> +		goto task_unlock;
> +	}
> +	task->maze_context->task = task;
> +	task->maze_context->pid = task->pid;
> +
> +	copy_limit_and_signal(task->maze_context, current->maze_context);
> +	preempt_notifier_init(&task->maze_context->notifier, &preempt_ops);
> +
> +	spin_lock(&maze_list_lock);
> +	list_add(&task->maze_context->list, &maze_list);
> +	spin_unlock(&maze_list_lock);
> +
> +task_unlock:
> +	task_unlock(task);
> +}
>
> ...
>
> +static inline void set_preempt_notifir(struct maze_context *context)

"notifier"

> +{
> +	if (!atomic_xchg(&context->registered_notifier, 1))
> +		preempt_notifier_register(&context->notifier);
> +}
> +
> +static int add_maze_context(struct maze_context *context)
> +{
> +	struct task_struct *task;
> +	int ret = 0;
> +
> +	rcu_read_lock();
> +
> +	task = find_task_by_pid(context->pid);
> +	if (unlikely(!task))
> +		goto read_unlock;
> +
> +	task_lock(task);
> +
> +	if (!task->maze_context) {
> +		task->maze_context = context;
> +		context->task = task;
> +
> +		spin_lock(&maze_list_lock);
> +		list_add(&context->list, &maze_list);
> +		spin_unlock(&maze_list_lock);
> +
> +		reset_maze_count(context);
> +
> +		preempt_notifier_init(&context->notifier, &preempt_ops);
> +		if (current == task)
> +		   set_preempt_notifir(context);

Please use only hard tabs for code indenting.

> +	} else {
> +		copy_limit_and_signal(task->maze_context, context);
> +		ret = 1;
> +	}
> +
> +	task_unlock(task);
> +read_unlock:
> +	rcu_read_unlock();
> +	return ret;
> +}
> +
> +static int build_maze_context(const char *read_line, struct maze_context *context)
> +{
> +	unsigned long soft_limit, hard_limit;
> +	int soft_signal, hard_signal;
> +	int pid, res;
> +
> +	res = sscanf(read_line, "%d %ld %ld %d %d", &pid, &soft_limit,
> +				 &hard_limit, &soft_signal, &hard_signal);
> +
> +	if (res != 5 || pid < 0 ||
> +		soft_limit < 0 || hard_limit < 0 ||
> +		soft_signal < 0 || hard_signal < 0)
> +		return -EINVAL;
> +
> +	context->pid = pid;
> +	context->soft_limit = soft_limit;
> +	context->hard_limit = hard_limit;
> +	context->soft_signal = soft_signal;
> +	context->hard_signal = hard_signal;
> +
> +	return 0;
> +}

pids are not unique in a containerised system.  What are the
implications of this?

> +static void timer_handler(unsigned long data);
> +
> +/*
> + * Setup softirq timer
> + */
> +static void continue_timer(int cpu)
> +{
> +	struct timer_list *t;
> +
> +	t = &per_cpu(maze_timer, cpu);
> +	t->function = timer_handler;
> +	t->expires = jiffies + maze_timer_interval;
> +	init_timer(t);

setup_timer()

> +	add_timer_on(t, cpu);
> +}
>
> ...
>
> +static void timer_handler(unsigned long data)
> +{
> +	struct maze_context *context, *next;
> +
> +	spin_lock(&__get_cpu_var(maze_queue_lock));
> +
> +	if (current->maze_context) {
> +		set_preempt_notifir(current->maze_context);
> +		if (!current->maze_context->enqueue)
> +			check_limit(current->maze_context);
> +	}
> +
> +	if (!list_empty(&__get_cpu_var(maze_queue))) {
> +		list_for_each_entry_safe (context, next,
> +								  &__get_cpu_var(maze_queue), queue) {
> +			check_limit(context);
> +			list_del(&context->queue);
> +			context->enqueue = 0;
> +		}
> +	}
> +
> +	spin_unlock(&__get_cpu_var(maze_queue_lock));
> +
> +	continue_timer(smp_processor_id());
> +}

It is odd that the timer runs every ten jiffies.  Because jiffies can
alter by a factor of ten, depending upon Kconfig settings and
architecture, etc.

Having numerous timers expire once per ten jiffies will be a power
consumption problem for some people.  Can this be fixed?

There's not really enough information in either code comments or the
changelog to permit me to understand what this timer is here for.

> +
> +static int maze_entries_file_show(struct seq_file *seq, void *nouse)
> +{
> +	struct maze_context *context;
> +
> +	spin_lock(&maze_list_lock);
> +
> +	list_for_each_entry(context, &maze_list, list) {
> +		seq_printf(seq, "pid:%5d   ", context->pid);
> +		seq_printf(seq, "count:%6ld  ", get_maze_count(context));
> +		seq_printf(seq, "soft limit:%6ld  ", context->soft_limit);
> +		seq_printf(seq, "hard limit:%6ld  ", context->hard_limit);
> +		seq_printf(seq, "soft signal:%2d  ", context->soft_signal);
> +		seq_printf(seq, "hard signal:%2d  ", context->hard_signal);
> +		seq_printf(seq, "\n");
> +	}
> +
> +	spin_unlock(&maze_list_lock);
> +
> +	return 0;
> +}
>
> ...
>
> +/*
> + * Write operation of /proc/maze/entries
> + */
> +static ssize_t maze_entries_file_write(struct file *file,
> +					const char __user *buffer,
> +					size_t count, loff_t *ppos)
> +{
> +	struct maze_context *context;
> +	char read_line[32];
> +	int ret;
> +
> +	if (!capable(CAP_SYS_ADMIN))
> +		return -EPERM;
> +
> +	if (count > sizeof(read_line) - 1)
> +		return -EINVAL;
> +
> +	if (copy_from_user(read_line, buffer, count))
> +		return -EFAULT;
> +
> +	read_line[count] = '\0';
> +
> +	context = kzalloc(sizeof(struct maze_context), GFP_ATOMIC);

Use GFP_KERNEL.

> +	if (unlikely(!context)) {
> +		ERRPRINT("fail to alloc maze_context.\n");
> +		return -ENOMEM;
> +	}
> +
> +	ret = build_maze_context(read_line, context);
> +	if (ret) {
> +		kfree(context);
> +		return ret;
> +	}
> +
> +	if (add_maze_context(context))
> +		kfree(context);
> +
> +	return count;
> +}

It looks like this can leak the memory at *context?

> +static struct file_operations maze_entries_file_ops = {
> +	.owner	 = THIS_MODULE,
> +	.open	 = maze_entries_file_open,
> +	.read	 = seq_read,
> +	.write   = maze_entries_file_write,
> +	.llseek	 = seq_lseek,
> +	.release = maze_entries_file_release,
> +};

Please document newly-added /proc files in Documentation/filesystems/proc.txt

> +/*
> + * Creating /proc/maze/
> + */
> +static inline int init_dir(void)
> +{
> +	maze_proc_dir =
> +		create_proc_entry("maze",
> +						  S_IFDIR | S_IRUGO | S_IXUGO,
> +						  NULL);
> +
> +	if (!maze_proc_dir)
> +		panic("fail to create /proc/maze\n");
> +
> +	return 0;
> +}

uninline, fix whitespace...

> +
> +/*
> + * Creating /proc/maze/entries
> + */
> +static inline int init_entries(void)
> +{
> +	struct proc_dir_entry *p;
> +
> +	p = create_proc_entry("entries", S_IRUGO, maze_proc_dir);
> +	if (p == NULL)
> +		panic("fail to create /proc/maze/entries\n");
> +
> +	p->proc_fops = &maze_entries_file_ops;
> +
> +	return 0;
> +}
>
> ...
>
> +static int __init maze_init(void)
> +{
> +	int cpu;
> +
> +	printk(KERN_INFO "Maze: Initializing\n");
> +	maze_initialized = 1;
> +	init_proc();
> +
> +	spin_lock_init(&maze_list_lock);

Remove this, use DEFINE_SPINLOCK().

> +	INIT_LIST_HEAD(&maze_list);

Remove this, use LIST_HEAD().

> +	for_each_online_cpu(cpu)
> +		init_cpu(cpu);
> +
> +	return 0;
> +}
> +late_initcall(maze_init);

I am unable to tell from the implementation why late_initcall() was
chosen instead of plain old __initcall() (or module_innit()).  Please
add a comment.

> --- linux-2.6.25-mm1-maze.orig/kernel/sched.c	2008-05-13 17:40:43.000000000 +0900
> +++ linux-2.6.25-mm1-maze/kernel/sched.c	2008-05-13 17:52:23.000000000 +0900
> @@ -68,6 +68,7 @@
>  #include <linux/hrtimer.h>
>  #include <linux/tick.h>
>  #include <linux/ftrace.h>
> +#include <linux/maze.h>
> 
>  #include <asm/tlb.h>
>  #include <asm/irq_regs.h>
> @@ -5157,6 +5158,8 @@ asmlinkage long sys_sched_yield(void)
>  	_raw_spin_unlock(&rq->lock);
>  	preempt_enable_no_resched();
> 
> +	maze_sched_yield(current);
> +
>  	schedule();
> 
>  	return 0;
> 
> 
