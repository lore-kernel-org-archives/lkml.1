Return-Path: <linux-kernel-owner+w=401wt.eu-S1754436AbYL3AXx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754436AbYL3AXx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 19:23:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754106AbYL3AXj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 19:23:39 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49570 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754090AbYL3AXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 19:23:38 -0500
Date: Mon, 29 Dec 2008 16:23:14 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/14] kmemleak: Add the base support
Message-Id: <20081229162314.1cc7a549.akpm@linux-foundation.org>
In-Reply-To: <20081219181302.7778.15966.stgit@pc1117.cambridge.arm.com>
References: <20081219181255.7778.52219.stgit@pc1117.cambridge.arm.com>
	<20081219181302.7778.15966.stgit@pc1117.cambridge.arm.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Dec 2008 18:13:02 +0000
Catalin Marinas <catalin.marinas@arm.com> wrote:

> This patch adds the base support for the kernel memory leak
> detector. It traces the memory allocation/freeing in a way similar to
> the Boehm's conservative garbage collector, the difference being that
> the unreferenced objects are not freed but only shown in
> /sys/kernel/debug/kmemleak. Enabling this feature introduces an
> overhead to memory allocations.
> 
>
> ...
>
> --- a/init/main.c
> +++ b/init/main.c
> @@ -56,6 +56,7 @@
>  #include <linux/debug_locks.h>
>  #include <linux/debugobjects.h>
>  #include <linux/lockdep.h>
> +#include <linux/kmemleak.h>
>  #include <linux/pid_namespace.h>
>  #include <linux/device.h>
>  #include <linux/kthread.h>
> @@ -653,6 +654,8 @@ asmlinkage void __init start_kernel(void)
>  	enable_debug_pagealloc();
>  	cpu_hotplug_init();
>  	kmem_cache_init();
> +	prio_tree_init();
> +	kmemleak_init();

prio_tree_init() can be moved waaaay early, so we might as well do that
now, rather than just moving it a little bit.

>  	debug_objects_mem_init();
>  	idr_init_cache();
>  	setup_per_cpu_pageset();
> @@ -662,7 +665,6 @@ asmlinkage void __init start_kernel(void)
>  	calibrate_delay();
>  	pidmap_init();
>  	pgtable_cache_init();
> -	prio_tree_init();
>  	anon_vma_init();
>  #ifdef CONFIG_X86
>  	if (efi_enabled)
>
> ...
>
> +#define print_helper(seq, x...)	do {	\
> +	if (seq)			\
> +		seq_printf(seq, x);	\
> +	else				\
> +		pr_info(x);		\
> +} while (0)

grumblemutter.  Evaluates `seq' more than once.

> +static void print_unreferenced(struct seq_file *seq,
> +			       struct kmemleak_object *object)
> +{
> +	char namebuf[KSYM_NAME_LEN + 1] = "";
> +	char *modname;
> +	unsigned long symsize;
> +	int i;
> +
> +	print_helper(seq, "unreferenced object 0x%08lx (size %zu):\n",
> +		     object->pointer, object->size);
> +	print_helper(seq, "  comm \"%s\", pid %d, jiffies %lu\n",
> +		     object->comm, object->pid, object->jiffies);
> +	print_helper(seq, "  backtrace:\n");
> +
> +	for (i = 0; i < object->trace_len; i++) {
> +		unsigned long trace = object->trace[i];
> +		unsigned long offset = 0;
> +
> +		kallsyms_lookup(trace, &symsize, &offset, &modname, namebuf);
> +		print_helper(seq, "    [<%08lx>] %s\n", trace, namebuf);

Can this use the %p magic?

> +	}
> +}
> +
>
> ...
>
> +static void scan_yield(void)
> +{
> +	might_sleep();
> +
> +	if (time_is_before_eq_jiffies(next_scan_yield)) {
> +		schedule();
> +		next_scan_yield = jiffies + jiffies_scan_yield;
> +	}

I bet you could use __ratelimit() here.  Although that probably won't
clarify anything, and it's slower ;)

> +}
> +
> +/*
> + * Memory scanning is a long process and it needs to be interruptable. This
> + * function checks whether such interrupt condition occured.
> + */
> +static int scan_should_stop(void)
> +{
> +	if (!atomic_read(&kmemleak_enabled))
> +		return 1;
> +	/*
> +	 * This function may be called from either process or kthread context,
> +	 * hence the need to check for both stop conditions.
> +	 */
> +	if ((current->mm && signal_pending(current)) ||
> +	    (!current->mm && kthread_should_stop()))
> +		return 1;
> +	return 0;
> +}

	if (current->mm)
		return signal_pending(current);
	else
		return kthread_should_stop();

nicer, no?

>
> ...
>
> +/*
> + * Stop the automatic memory scanning thread. This function must be called
> + * with the kmemleak_mutex held.
> + */
> +void stop_scan_thread(void)
> +{
> +	if (scan_thread) {
> +		kthread_stop(scan_thread);
> +		scan_thread = NULL;
> +	}
> +}

so... why do we need a kernel thread?

We could have (for the sake of argument) a sys_kmemleak_scan() which
does a single scan then returns.  Or something like that.  That way,
userspace directly gets to set the scanning frequency, thread priority,
etc.

>
> ...
>
> +static ssize_t kmemleak_write(struct file *file, const char __user *user_buf,
> +			      size_t size, loff_t *ppos)
> +{
> +	char buf[64];
> +	int buf_size;
> +
> +	if (!atomic_read(&kmemleak_enabled))
> +		return -EBUSY;
> +
> +	buf_size = min(size, (sizeof(buf) - 1));
> +	if (copy_from_user(buf, user_buf, buf_size))
> +		return -EFAULT;
> +	buf[buf_size] = 0;

maybe strncpy_from_user()?

> +	if (strncmp(buf, "off", 3) == 0)
> +		kmemleak_disable();
> +	else if (strncmp(buf, "stack=on", 8) == 0)
> +		kmemleak_stack_scan = 1;
> +	else if (strncmp(buf, "stack=off", 9) == 0)
> +		kmemleak_stack_scan = 0;
> +	else if (strncmp(buf, "scan=on", 7) == 0)
> +		start_scan_thread();
> +	else if (strncmp(buf, "scan=off", 8) == 0)
> +		stop_scan_thread();
> +	else if (strncmp(buf, "scan=", 5) == 0) {
> +		unsigned long secs;
> +		int err;
> +
> +		err = strict_strtoul(buf + 5, 0, &secs);
> +		if (err < 0)
> +			return err;
> +		stop_scan_thread();
> +		if (secs) {
> +			jiffies_scan_wait = msecs_to_jiffies(secs * 1000);
> +			start_scan_thread();
> +		}
> +	} else
> +		return -EINVAL;
> +
> +	/* ignore the rest of the buffer, only one command at a time */
> +	*ppos += size;
> +	return size;
> +}
> +
>
> ...
>
> +static void kmemleak_cleanup(void)
> +{
> +	struct task_struct *cleanup_thread;
> +
> +	cleanup_thread = kthread_run(kmemleak_cleanup_thread, NULL,
> +				     "kmemleak-cleanup");

#define TASK_COMM_LEN 16

So the above kernel thread will appear in `ps' output as "kmemleak-cleanu",
won't it?

> +	if (IS_ERR(cleanup_thread))
> +		pr_warning("kmemleak: Failed to create the clean-up thread\n");
> +}
> +
>
> ...
>


