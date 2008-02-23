Return-Path: <linux-kernel-owner+w=401wt.eu-S937368AbYBWI2X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937368AbYBWI2X (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 03:28:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932987AbYBWIMy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 03:12:54 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:48212 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934983AbYBWIMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 03:12:52 -0500
Date: Sat, 23 Feb 2008 00:11:30 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, sandmann@redhat.com,
       tglx@tglx.de, hpa@zytor.com
Subject: Re: [PATCH] x86: add the debugfs interface for the sysprof tool
Message-Id: <20080223001130.d8922136.akpm@linux-foundation.org>
In-Reply-To: <20080219123756.6261c13c@laptopd505.fenrus.org>
References: <20080219123756.6261c13c@laptopd505.fenrus.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Feb 2008 12:37:56 -0800 Arjan van de Ven <arjan@infradead.org> wrote:

> From: Soren Sandmann <sandmann@redhat.com>
> Subject: [PATCH] x86: add the debugfs interface for the sysprof tool
> 
> The sysprof tool is a very easy to use GUI tool to find out where
> userspace is spending CPU time. See
> http://www.daimi.au.dk/~sandmann/sysprof/
> for more information and screenshots on this tool.
> 
> Sysprof needs a 200 line kernel module to do it's work, this
> module puts some simple profiling data into debugfs.
> 
> ...
>

Seems a poor idea to me.  Sure, oprofile is "hard to set up", but not if
your distributor already did it for you.

Sidebar: the code uses the utterly crappy register_timer_hook() which 

a) is woefully misnamed and

b) is racy and 

c) will disrupt oprofile if it is being used.  And vice versa.



This code adds a new kernel->userspace interface which is not even
documented in code comments.  It appears to use a pollable debugfs file in
/proc somewhere, carrying an unspecified payload.


What happens when multiple processes are consuming data from the same
debugfs file?


>  arch/x86/Kconfig.debug    |   10 ++
>  arch/x86/kernel/Makefile  |    2 +
>  arch/x86/kernel/sysprof.c |  200 +++++++++++++++++++++++++++++++++++++++++++++
>  arch/x86/kernel/sysprof.h |   34 ++++++++
>  4 files changed, 246 insertions(+), 0 deletions(-)
>  create mode 100644 arch/x86/kernel/sysprof.c
>  create mode 100644 arch/x86/kernel/sysprof.h
> 
> diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
> index 12c98ea..8eb06c0 100644
> --- a/arch/x86/Kconfig.debug
> +++ b/arch/x86/Kconfig.debug
> @@ -206,6 +206,16 @@ config MMIOTRACE_TEST
>  
>  	  Say N, unless you absolutely know what you are doing.
>  
> +config SYSPROF
> +	tristate "Enable sysprof userland performance sampler"
> +	depends on PROFILING

Missing dependency on DEBUG_FS

> +	help
> +	  This option enables the sysprof debugfs file that is used by the
> +	  sysprof tool. sysprof is a tool to show where in userspace CPU
> +	  time is spent.
> +
> +	  When in doubt, say N
> +

And it's x86-specific.

>  #
>  # IO delay types:
>  #
> diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
> index 4a4260c..1e8fb66 100644
> --- a/arch/x86/kernel/Makefile
> +++ b/arch/x86/kernel/Makefile
> @@ -80,6 +80,8 @@ obj-$(CONFIG_DEBUG_NX_TEST)	+= test_nx.o
>  obj-$(CONFIG_VMI)		+= vmi_32.o vmiclock_32.o
>  obj-$(CONFIG_PARAVIRT)		+= paravirt.o paravirt_patch_$(BITS).o
>  
> +obj-$(CONFIG_SYSPROF)		+= sysprof.o
> +
>  ifdef CONFIG_INPUT_PCSPKR
>  obj-y				+= pcspeaker.o
>  endif
> diff --git a/arch/x86/kernel/sysprof.c b/arch/x86/kernel/sysprof.c
> new file mode 100644
> index 0000000..6220b9f
> --- /dev/null
> +++ b/arch/x86/kernel/sysprof.c
> @@ -0,0 +1,200 @@
> +/* -*- c-basic-offset: 8 -*- */
> +
> +/* Sysprof -- Sampling, systemwide CPU profiler
> + * Copyright 2004, Red Hat, Inc.
> + * Copyright 2004, 2005, Soeren Sandmann
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/proc_fs.h>
> +#include <linux/poll.h>
> +#include <linux/highmem.h>
> +#include <linux/pagemap.h>
> +#include <linux/profile.h>
> +#include <linux/debugfs.h>
> +#include <asm/uaccess.h>

checkpatch used to warn that linux/uaccess.h is preferred over asm/uaccess.h
but this is another of those checkpatch features which seems to have
mysteriously disappeared, or it broke?

> +#include <asm/atomic.h>
> +
> +#include "sysprof.h"
> +
> +#define SAMPLES_PER_SECOND (200)
> +#define INTERVAL ((HZ <= SAMPLES_PER_SECOND)? 1 : (HZ / SAMPLES_PER_SECOND))
> +#define N_TRACES 256
> +
> +static struct sysprof_stacktrace stack_traces[N_TRACES];
> +static struct sysprof_stacktrace *head = &stack_traces[0];
> +static struct sysprof_stacktrace *tail = &stack_traces[0];

Access to head and tail appear to be racy.  See below.

> +static DECLARE_WAIT_QUEUE_HEAD(wait_for_trace);
> +static DECLARE_WAIT_QUEUE_HEAD(wait_for_exit);
> +
> +struct userspace_reader {
> +	struct task_struct *task;
> +	unsigned long cache_address;
> +	unsigned long *cache;
> +};
> +
> +struct stack_frame;
> +
> +struct stack_frame {
> +	struct stack_frame __user *next;
> +	unsigned long return_address;
> +};
> +
> +static int read_frame(struct stack_frame __user *frame_pointer,
> +					struct stack_frame *frame)
> +{
> +	if (__copy_from_user_inatomic(frame, frame_pointer,
> +					sizeof(struct stack_frame)))
> +		return 1;
> +	return 0;
> +}
> +
> +static DEFINE_PER_CPU(int, n_samples);
> +
> +static int timer_notify(struct pt_regs *regs)
> +{
> +	struct sysprof_stacktrace *trace = head;

We read `head' before taking the "lock".  Another CPU could modify it after
we took a local copy.

> +	int i;
> +	int is_user;
> +	static atomic_t in_timer_notify = ATOMIC_INIT(1);
> +	int n;
> +
> +	n = ++get_cpu_var(n_samples);
> +	put_cpu_var(n_samples);

Needlessly disables preemption.  Use __get_cpu_var().

> +	if (n % INTERVAL != 0)
> +		return 0;

It'd be nice to make INTERVAL a power of 2.

> +	/* 0: locked, 1: unlocked */
> +
> +	if (!atomic_dec_and_test(&in_timer_notify))
> +		goto out;

Why not use spin_trylock()?  Then you get lockdep support too.

And why not use spin_lock()?  At least a comment should be added explaining
and justifying this peculiar home-made-not-really-locking design.

> +	is_user = user_mode(regs);
> +
> +	if (!current || current->pid == 0)
> +		goto out;

And the changelog should explain and justify why we cannot profile root's
code.  I cannot begin to imagine why it was done and I cannot fathom why it
passed uncommented in documentation, code, changelog and "review" comments. 
It greatly reduces the usefulness of an already dubious feature.

If this limitation _was_ documented then I'd be in a position to ask what is
special about root, as opposed to some non-root user who has <unspecified>
capabilities.  And why we penalise a root who has dropped <unspecified>
capabilities.  etcetera.

Is this open-coded test of ->pid correct in a containerised environment?

> +	if (is_user && current->state != TASK_RUNNING)
> +		goto out;

Needs a comment (although this one is fairly obvious)

> +	if (!is_user) {
> +		/* kernel */
> +		trace->pid = current->pid;
> +		trace->truncated = 0;
> +		trace->n_addresses = 1;
> +
> +		/* 0x1 is taken by sysprof to mean "in kernel" */
> +		trace->addresses[0] = 0x1;
> +	} else {
> +		struct stack_frame __user *frame_pointer;
> +		struct stack_frame frame;
> +		memset(trace, 0, sizeof(struct sysprof_stacktrace));
> +
> +		trace->pid = current->pid;

This is ambiguous in a containerised environment.

Ingo, please be alert for anything which exposes raw pids to userspace.

I don't know what a correct and suitable interface might be - perhaps Pavel
or Eric can suggest something.

> +		trace->truncated = 0;
> +
> +		i = 0;
> +
> +		trace->addresses[i++] = regs->ip;
> +
> +		frame_pointer = (struct stack_frame __user *)regs->bp;
> +
> +		while (read_frame(frame_pointer, &frame) == 0 &&
> +		       i < SYSPROF_MAX_ADDRESSES &&
> +		       (unsigned long)frame_pointer >= regs->sp) {
> +			trace->addresses[i++] = frame.return_address;
> +			frame_pointer = frame.next;
> +		}

The (absent) interface documentation should explain what happens when a
fault causes this information to be truncated.

> +		trace->n_addresses = i;
> +
> +		if (i == SYSPROF_MAX_ADDRESSES)
> +			trace->truncated = 1;
> +		else
> +			trace->truncated = 0;
> +	}
> +
> +	if (head++ == &stack_traces[N_TRACES - 1])
> +		head = &stack_traces[0];

`head' can just merrily advance over `tail' and there is no notification to
userspace of the lost data.

> +	wake_up(&wait_for_trace);
> +
> +out:
> +	atomic_inc(&in_timer_notify);
> +	return 0;
> +}
> +
> +static ssize_t procfile_read(struct file *filp, char __user *buffer,
> +			size_t count, loff_t *ppos)
> +{
> +	ssize_t bcount;
> +	if (head == tail)
> +		return -EWOULDBLOCK;

Please put a blank line between end-of-variables and start-of-code.

This seems to be a wrong return value?  Shouldn't it just return zero if
there was nothing there?  As can happen if some other process is reading the
same debugfs file?

> +	BUG_ON(tail->pid == 0);

whee.  There was no locking above to prevent the tasks's pid from
transitioning from non-zero to zero after it was tested.  Which means this
is triggerable.  Perhaps the implicit locking due to cpu-pinnedness and
interruption will prevent that race.  If so, such a subtlety should be
commented, no?

> +	*ppos = 0;
> +	bcount = simple_read_from_buffer(buffer, count, ppos,
> +			tail, sizeof(struct sysprof_stacktrace));
> +
> +	if (tail++ == &stack_traces[N_TRACES - 1])
> +		tail = &stack_traces[0];

There is no locking for `tail', and afaict we support multiple simultaneous
readers.

> +	return bcount;
> +}

This reads a single item even if there were 100 queued, which is quite 
inefficient.

We already have infrastructure for bulk kernel->user transfer in
kernel/relay.c?

> +static unsigned int procfile_poll(struct file *filp, poll_table * poll_table)

checkpatch missed this coding-style error.

> +{
> +	if (head != tail)
> +		return POLLIN | POLLRDNORM;
> +
> +	poll_wait(filp, &wait_for_trace, poll_table);
> +
> +	if (head != tail)
> +		return POLLIN | POLLRDNORM;
> +
> +	return 0;
> +}
> +
> +static const struct file_operations sysprof_fops = {
> +	.owner = THIS_MODULE,
> +	.read = procfile_read,
> +	.poll = procfile_poll,
> +};
> +
> +static struct dentry *debugfs_pe;
> +int init_module(void)
> +{
> +	debugfs_pe = debugfs_create_file("sysprof-trace", 0600, NULL, NULL,
> +				&sysprof_fops);
> +	if (!debugfs_pe)
> +		return -ENODEV;
> +	register_timer_hook(timer_notify);
> +	return 0;
> +}

This function will enable sysprof-trace even if prof_on==0,
prof_on==SLEEP_PROFILING, etc which is pointless.

> +void cleanup_module(void)
> +{
> +	unregister_timer_hook(timer_notify);
> +	debugfs_remove(debugfs_pe);
> +}
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Soeren Sandmann (sandmann@daimi.au.dk)");
> +MODULE_DESCRIPTION("Kernel driver for the sysprof performance analysis tool");
> diff --git a/arch/x86/kernel/sysprof.h b/arch/x86/kernel/sysprof.h
> new file mode 100644
> index 0000000..6e16d6f
> --- /dev/null
> +++ b/arch/x86/kernel/sysprof.h
> @@ -0,0 +1,34 @@
> +/* Sysprof -- Sampling, systemwide CPU profiler
> + * Copyright 2004, Red Hat, Inc.
> + * Copyright 2004, 2005, Soeren Sandmann
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
> + */
> +
> +#ifndef SYSPROF_MODULE_H
> +#define SYSPROF_MODULE_H
> +
> +#define SYSPROF_MAX_ADDRESSES 512
> +
> +struct sysprof_stacktrace {
> +    int	pid;		/* -1 if in kernel */
> +    int truncated;
> +    int n_addresses;	/* note: this can be 1 if the process was compiled
> +			 * with -fomit-frame-pointer or is otherwise weird
> +			 */
> +    unsigned long addresses[SYSPROF_MAX_ADDRESSES];
> +};

This is broken for 32-bit userspace running on a 64-bit kernel.  Unless
said userspace jumps through hoops and works out that it's running under a
64-bit kernel.

There might be alignment issues for addresses[], being at offset 12.


On Wed, 20 Feb 2008 10:10:22 +0100 Ingo Molnar <mingo@elte.hu> wrote:
>
> thanks, looks good to me - applied.

This is pretty distressing, frankly.  The threshold for getting code into
Linux should be much higher than this.

I do not have the time to review everything which goes into all the git
trees.  Better review, please.

