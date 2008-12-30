Return-Path: <linux-kernel-owner+w=401wt.eu-S1752910AbYL3Ksf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752910AbYL3Ksf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 05:48:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751548AbYL3Ks0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 05:48:26 -0500
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:64329 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751510AbYL3KsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 05:48:25 -0500
Subject: Re: [PATCH 01/14] kmemleak: Add the base support
From: Catalin Marinas <catalin.marinas@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20081229162314.1cc7a549.akpm@linux-foundation.org>
References: <20081219181255.7778.52219.stgit@pc1117.cambridge.arm.com>
	 <20081219181302.7778.15966.stgit@pc1117.cambridge.arm.com>
	 <20081229162314.1cc7a549.akpm@linux-foundation.org>
Content-Type: text/plain
Organization: ARM Ltd
Date: Tue, 30 Dec 2008 10:48:15 +0000
Message-Id: <1230634095.1693.22.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 Dec 2008 10:48:18.0312 (UTC) FILETIME=[20072080:01C96A6C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

On Mon, 2008-12-29 at 16:23 -0800, Andrew Morton wrote:
> On Fri, 19 Dec 2008 18:13:02 +0000
> Catalin Marinas <catalin.marinas@arm.com> wrote:
> > --- a/init/main.c
> > +++ b/init/main.c
> > @@ -56,6 +56,7 @@
> >  #include <linux/debug_locks.h>
> >  #include <linux/debugobjects.h>
> >  #include <linux/lockdep.h>
> > +#include <linux/kmemleak.h>
> >  #include <linux/pid_namespace.h>
> >  #include <linux/device.h>
> >  #include <linux/kthread.h>
> > @@ -653,6 +654,8 @@ asmlinkage void __init start_kernel(void)
> >  	enable_debug_pagealloc();
> >  	cpu_hotplug_init();
> >  	kmem_cache_init();
> > +	prio_tree_init();
> > +	kmemleak_init();
> 
> prio_tree_init() can be moved waaaay early, so we might as well do that
> now, rather than just moving it a little bit.

OK.

> > +#define print_helper(seq, x...)	do {	\
> > +	if (seq)			\
> > +		seq_printf(seq, x);	\
> > +	else				\
> > +		pr_info(x);		\
> > +} while (0)
> 
> grumblemutter.  Evaluates `seq' more than once.

OK. Anyway, in this particular case "seq" is just a pointer variable, so
I don't think there is much to evaluate.

> > +static void print_unreferenced(struct seq_file *seq,
> > +			       struct kmemleak_object *object)
> > +{
> > +	char namebuf[KSYM_NAME_LEN + 1] = "";
> > +	char *modname;
> > +	unsigned long symsize;
> > +	int i;
> > +
> > +	print_helper(seq, "unreferenced object 0x%08lx (size %zu):\n",
> > +		     object->pointer, object->size);
> > +	print_helper(seq, "  comm \"%s\", pid %d, jiffies %lu\n",
> > +		     object->comm, object->pid, object->jiffies);
> > +	print_helper(seq, "  backtrace:\n");
> > +
> > +	for (i = 0; i < object->trace_len; i++) {
> > +		unsigned long trace = object->trace[i];
> > +		unsigned long offset = 0;
> > +
> > +		kallsyms_lookup(trace, &symsize, &offset, &modname, namebuf);
> > +		print_helper(seq, "    [<%08lx>] %s\n", trace, namebuf);
> 
> Can this use the %p magic?

It can if I cast "trace" to (void *).

> > +static void scan_yield(void)
> > +{
> > +	might_sleep();
> > +
> > +	if (time_is_before_eq_jiffies(next_scan_yield)) {
> > +		schedule();
> > +		next_scan_yield = jiffies + jiffies_scan_yield;
> > +	}
> 
> I bet you could use __ratelimit() here.  Although that probably won't
> clarify anything, and it's slower ;)

The __ratelimit() seems slower indeed and it also takes a spinlock
(which I think would be better per ratelimit_state structure rather than
global).

> > +static int scan_should_stop(void)
> > +{
> > +	if (!atomic_read(&kmemleak_enabled))
> > +		return 1;
> > +	/*
> > +	 * This function may be called from either process or kthread context,
> > +	 * hence the need to check for both stop conditions.
> > +	 */
> > +	if ((current->mm && signal_pending(current)) ||
> > +	    (!current->mm && kthread_should_stop()))
> > +		return 1;
> > +	return 0;
> > +}
> 
> 	if (current->mm)
> 		return signal_pending(current);
> 	else
> 		return kthread_should_stop();
> 
> nicer, no?

Yes.

> > +/*
> > + * Stop the automatic memory scanning thread. This function must be called
> > + * with the kmemleak_mutex held.
> > + */
> > +void stop_scan_thread(void)
> > +{
> > +	if (scan_thread) {
> > +		kthread_stop(scan_thread);
> > +		scan_thread = NULL;
> > +	}
> > +}
> 
> so... why do we need a kernel thread?

This was requested by Ingo (and he already replied). I personally don't
mind either.

> We could have (for the sake of argument) a sys_kmemleak_scan() which
> does a single scan then returns.  Or something like that.  That way,
> userspace directly gets to set the scanning frequency, thread priority,
> etc.

You can also trigger a memory scanning from user space by reading
the /sys/kernel/debug/kmemleak file (this was the only way in previous
versions of kmemleak). My initial thoughts were for a user space daemon
(or just "cat") reading this file periodically.

> > +static ssize_t kmemleak_write(struct file *file, const char __user *user_buf,
> > +			      size_t size, loff_t *ppos)
> > +{
> > +	char buf[64];
> > +	int buf_size;
> > +
> > +	if (!atomic_read(&kmemleak_enabled))
> > +		return -EBUSY;
> > +
> > +	buf_size = min(size, (sizeof(buf) - 1));
> > +	if (copy_from_user(buf, user_buf, buf_size))
> > +		return -EFAULT;
> > +	buf[buf_size] = 0;
> 
> maybe strncpy_from_user()?

OK.

> > +static void kmemleak_cleanup(void)
> > +{
> > +	struct task_struct *cleanup_thread;
> > +
> > +	cleanup_thread = kthread_run(kmemleak_cleanup_thread, NULL,
> > +				     "kmemleak-cleanup");
> 
> #define TASK_COMM_LEN 16
> 
> So the above kernel thread will appear in `ps' output as "kmemleak-cleanu",
> won't it?

OK (it used to be called "memleak-cleanup").

Thanks for your comments.

-- 
Catalin

