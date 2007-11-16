Return-Path: <linux-kernel-owner+w=401wt.eu-S934063AbXKPSyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934063AbXKPSyS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 13:54:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758037AbXKPSx7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 13:53:59 -0500
Received: from rv-out-0910.google.com ([209.85.198.189]:44683 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619AbXKPSx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 13:53:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Kx0ne41D54k4zIDP65uP6LP+yz/S7Sk1KvFsZWNQqkuXkiBVT1i2B84ZRZlUPcNObq9ipfcVoXFkoH7xZRBceo9otTtoVfAoNM0vYn6kjyXbeUmR1H2ToRS5WsCJBYVgJjpxE7MMyRAOjpFEPJfJ009LV5n6mODDeVzkAzr4nk8=
Message-ID: <863e9df20711161053q7f6ae3d5vb19b23d2ce6b20f7@mail.gmail.com>
Date: Sat, 17 Nov 2007 00:23:57 +0530
From: "Abhishek Sagar" <sagar.abhishek@gmail.com>
To: "Jim Keniston" <jkenisto@us.ibm.com>
Subject: Re: [PATCH][RFC] kprobes: Add user entry-handler in kretprobes
Cc: "Srinivasa Ds" <srinivasa@in.ibm.com>, linux-kernel@vger.kernel.org,
       prasanna@in.ibm.com, davem@davemloft.net,
       anil.s.keshavamurthy@intel.com,
       "Ananth N Mavinakayanahalli" <ananth@in.ibm.com>
In-Reply-To: <1195171644.3804.124.camel@dyn9047018096.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47389BEB.1000901@gmail.com>
	 <863e9df20711121039t5352a993xc9eeb6bfea123805@mail.gmail.com>
	 <863e9df20711130247g45d3d541j10c76434e9c65b00@mail.gmail.com>
	 <473AAA75.2050900@in.ibm.com>
	 <863e9df20711140049q3ad486ben7ace2edab0a2ca41@mail.gmail.com>
	 <473ACCBE.9010308@in.ibm.com>
	 <863e9df20711140530h69df9107g38e293aab278686a@mail.gmail.com>
	 <1195080664.5781.78.camel@dyn9047018096.beaverton.ibm.com>
	 <863e9df20711150700i3c84374ava108f5b585e8498b@mail.gmail.com>
	 <1195171644.3804.124.camel@dyn9047018096.beaverton.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 16, 2007 5:37 AM, Jim Keniston <jkenisto@us.ibm.com> wrote:
> On Thu, 2007-11-15 at 20:30 +0530, Abhishek Sagar wrote:
> > On Nov 15, 2007 4:21 AM, Jim Keniston <jkenisto@us.ibm.com> wrote:
> > > 2. Simplify the task of correlating data (e.g., timestamps) between
> > > function entry and function return.
> >
> > Would adding of data and len fields in ri help? Instead of "pouching"
> > data in one go at registration time, this would let user handlers do
> > the allocation
>
> Yes and no.  Adding just a data field -- void*, or maybe unsigned long
> long so it's big enought to accommodate big timestamps -- would be a big
> improvement on your current proposal.  That would save the user the
> drudgery of mapping the ri pointer to his/her per-instance data.
> There's plenty of precedent for passing "private_data" values to
> callbacks.
>
> I don't think a len field would help much.  If such info were needed, it
> could be stored in the data structure pointed to by the data field.
>
> I still don't think "letting [i.e., requiring that] user handlers do the
> allocation" is a win.  I'm still interested to see how this plays out in
> real examples.
>
> > and allow them to use different kinds of data
> > structures per-instance.
>
> I haven't been able to think of any scenarios where this would be
> useful.  A "data pouch" could always contain a union, FWIW.

I'm inlining a sample module which uses a data pointer in ri. I didn't
go for a timestamp because it's not reliable. Some platforms might
simply not have any h/w timestamp counters. For the same reason a lot
of platforms (on ARM, say) have their sched_clock() mapped on jiffies.
This may prevent timestamps from being distinct across function entry
and exit. Plus a data pointer looks pretty harmless.

--- test module ---

#include <linux/kernel.h>
#include <linux/version.h>
#include <linux/module.h>
#include <linux/kprobes.h>
#include <linux/ktime.h>

#define PRINT_DELAY (10 * HZ)

/* This module calculates the total time and instances of func being called
 * across all cpu's. An average is calculated every 10 seconds and displayed.
 * Only one function instance per-task is monitored. This cuts out the
 * possibility of measuring time for recursive and nested function
 * invocations.
 *
 * Note: If compiling as a standalone module, make sure sched_clock() is
 * exported in the kernel. */

/* per-task data */
struct prof_data {
	struct task_struct *task;
	struct list_head list;
	unsigned long long entry_stamp;
};

static const char *func = "sys_open";
static spinlock_t time_lock;
static ktime_t total_time;
static unsigned long hits;
static LIST_HEAD(data_nodes); /* list of per-task data */
static struct delayed_work work_print;

static struct prof_data *get_per_task_data(struct task_struct *tsk)
{
	struct prof_data *p;

	/* lookup prof_data corresponding to tsk */
	list_for_each_entry(p, &data_nodes, list) {
		if (p->task == tsk)
			return p;
	}
	return NULL;
}

/* called with kretprobe_lock held */
static int entry_handler(struct kretprobe_instance *ri, struct pt_regs *regs)
{
	struct prof_data *stats;

	stats = get_per_task_data(current);
	if (stats)
		return 1; /* recursive/nested call */

	stats = kmalloc(sizeof(struct prof_data), GFP_ATOMIC);
	if (!stats)
		return 1;

	stats->entry_stamp = sched_clock();
	stats->task = current;
	INIT_LIST_HEAD(&stats->list);
	list_add(&stats->list, &data_nodes);
	ri->data = stats;
	return 0;
}

/* called with kretprobe_lock held */
static int return_handler(struct kretprobe_instance *ri, struct pt_regs *regs)
{
	unsigned long flags;
	struct prof_data *stats = (struct prof_data *)ri->data;
	u64 elapsed;

	BUG_ON(ri->data == NULL);
	elapsed = (long long)sched_clock() - (long long)stats->entry_stamp;

	/* update stats */
	spin_lock_irqsave(&time_lock, flags);
	++hits;
	total_time = ktime_add_ns(total_time, elapsed);
	spin_unlock_irqrestore(&time_lock, flags);

	list_del(&stats->list);
	kfree(stats);
	return 0;
}

static struct kretprobe my_kretprobe = {
	.handler = return_handler,
	.entry_handler = entry_handler,
};

/* called after every PRINT_DELAY seconds */
static void print_time(struct work_struct *work)
{
	unsigned long flags;
	s64 time_ns;
	struct timespec ts;

	BUG_ON(work != &work_print.work);
	spin_lock_irqsave(&time_lock, flags);
	time_ns = ktime_to_ns(total_time);
	do_div(time_ns, hits);
	spin_unlock_irqrestore(&time_lock, flags);

	ts = ns_to_timespec(time_ns);
	printk(KERN_DEBUG "Avg. running time of %s = %ld sec, %ld nsec\n",
	       func, ts.tv_sec, ts.tv_nsec);
	schedule_delayed_work(&work_print, PRINT_DELAY);
}

static int __init test_module_init(void)
{
	int ret;
	my_kretprobe.kp.symbol_name = (char *)func;

	spin_lock_init(&time_lock);
	if ((ret = register_kretprobe(&my_kretprobe)) < 0) {
		printk("Failed to register test kretprobe!\n");
		return -1;
	}
	printk("Kretprobe active on %s\n", my_kretprobe.kp.symbol_name);
	INIT_DELAYED_WORK(&work_print, print_time);
	schedule_delayed_work(&work_print, PRINT_DELAY);
	return 0;
}

static void __exit test_module_exit(void)
{
	unregister_kretprobe(&my_kretprobe);
	printk("kretprobe unregistered\n");
	printk("Missed probing %d instances of %s\n",
		my_kretprobe.nmissed, func);
}

module_init(test_module_init)
module_exit(test_module_exit)
MODULE_LICENSE("GPL");

--
Abhishek Sagar
