Return-Path: <linux-kernel-owner+w=401wt.eu-S1755930AbZEUTMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755930AbZEUTMU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 15:12:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753662AbZEUTMI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 15:12:08 -0400
Received: from tomts13-srv.bellnexxia.net ([209.226.175.34]:37545 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753352AbZEUTMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 15:12:05 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AisFABdBFUpMQW1W/2dsb2JhbACBT9EOhAkF
Date: Thu, 21 May 2009 15:11:57 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: David Miller <davem@davemloft.net>, paulmck@linux.vnet.ibm.com,
       mingo@elte.hu, jwboyer@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       ltt-dev@lists.casi.polymtl.ca, Subrata Modak <tosubrata@gmail.com>,
       "Alan D. Brunelle" <Alan.Brunelle@hp.com>,
       Andika Triwidada <andika@startrek.or.id>
Subject: Test module : benchmarking read-side locking speed
Message-ID: <20090521191157.GA4982@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 14:43:15 up 82 days, 15:09,  5 users,  load average: 0.87, 0.48,
	0.34
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am trying to complete my numbers for performance impact of read-side
locking primitives (on the fast path) for various architectures.

I current have numbers for Intel P4, AMD Athlon64 X2, Intel Core2 and
Intel Xeon 5405, but, as you see, I am pretty much limited to the
architectures I have.

This module is not meant for inclusion, maybe except for the LTP project
which may find some value in it. The interface is, again, terrible
(modprobe the module will fail, this is ok, output is exported through
printk() to the console).

Help with testing on a larger set of architectures would be more than
welcome. Note that this module requires the kernel to be configured with
CONFIG_PREEMPT=y. Some config option sanity checking is done at
compile-time. Other requirement : disable invasive lockdep-style
instrumentation.

Thanks !

Mathieu


/*
 * test-read-lock-speed.c
 *
 * Compare speed of :
 * - spin lock / spin unlock
 * - rwlock read lock
 * - using a sequence read lock (uncontended)
 * - preempt disable/enable (RCU)
 *
 * Copyright 2009 - Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
 * Distributed under GPLv2
 */

#include <linux/jiffies.h>
#include <linux/compiler.h>
#include <linux/init.h>
#include <linux/module.h>
#include <linux/math64.h>
#include <linux/spinlock.h>
#include <linux/seqlock.h>
#include <linux/cpumask.h>
#include <asm/timex.h>
#include <asm/system.h>

#define NR_LOOPS 20000

#ifndef CONFIG_PREEMPT
#error "Your kernel should be built with preemption enabled"
#endif

#ifdef CONFIG_DEBUG_PREEMPT
#error "Please disable CONFIG_DEBUG_PREEMPT"
#endif

#ifdef CONFIG_DEBUG_SPINLOCK
#error "Please disable CONFIG_DEBUG_SPINLOCK"
#endif

#ifdef CONFIG_LOCKDEP
#error "Please disable CONFIG_LOCKDEP"
#endif

int test_val;

static void do_testbaseline(void)
{
	unsigned long flags;
	unsigned int i;
	cycles_t time1, time2, time;
	u32 rem;

	local_irq_save(flags);
	preempt_disable();
	time1 = get_cycles();
	for (i = 0; i < NR_LOOPS; i++) {
		asm volatile ("");
	}
	time2 = get_cycles();
	local_irq_restore(flags);
	preempt_enable();
	time = time2 - time1;

	printk(KERN_ALERT "test results: time for baseline\n");
	printk(KERN_ALERT "number of loops: %d\n", NR_LOOPS);
	printk(KERN_ALERT "total time: %llu\n", time);
	time = div_u64_rem(time, NR_LOOPS, &rem);
	printk(KERN_ALERT "-> baseline takes %llu cycles\n", time);
	printk(KERN_ALERT "test end\n");
}

static void do_test_spinlock(void)
{
	static DEFINE_SPINLOCK(mylock);
	unsigned long flags;
	unsigned int i;
	cycles_t time1, time2, time;
	u32 rem;

	preempt_disable();
	spin_lock_irqsave(&mylock, flags);
	time1 = get_cycles();
	for (i = 0; i < NR_LOOPS; i++) {
		spin_unlock(&mylock);
		spin_lock(&mylock);
	}
	time2 = get_cycles();
	spin_unlock_irqrestore(&mylock, flags);
	preempt_enable();
	time = time2 - time1;

	printk(KERN_ALERT "test results: time for spinlock\n");
	printk(KERN_ALERT "number of loops: %d\n", NR_LOOPS);
	printk(KERN_ALERT "total time: %llu\n", time);
	time = div_u64_rem(time, NR_LOOPS, &rem);
	printk(KERN_ALERT "-> spinlock takes %llu cycles\n", time);
	printk(KERN_ALERT "test end\n");
}

static void do_test_read_rwlock(void)
{
	static DEFINE_RWLOCK(mylock);
	unsigned long flags;
	unsigned int i;
	cycles_t time1, time2, time;
	u32 rem;

	preempt_disable();
	local_irq_save(flags);
	read_lock(&mylock);
	time1 = get_cycles();
	for (i = 0; i < NR_LOOPS; i++) {
		read_unlock(&mylock);
		read_lock(&mylock);
	}
	time2 = get_cycles();
	read_unlock(&mylock);
	local_irq_restore(flags);
	preempt_enable();
	time = time2 - time1;

	printk(KERN_ALERT "test results: time for read rwlock\n");
	printk(KERN_ALERT "number of loops: %d\n", NR_LOOPS);
	printk(KERN_ALERT "total time: %llu\n", time);
	time = div_u64_rem(time, NR_LOOPS, &rem);
	printk(KERN_ALERT "-> read rwlock takes %llu cycles\n", time);
	printk(KERN_ALERT "test end\n");
}

static void do_test_seqlock(void)
{
	static seqlock_t test_lock;
	unsigned long seq;
	unsigned long flags;
	unsigned int i;
	cycles_t time1, time2, time;
	u32 rem;

	local_irq_save(flags);
	time1 = get_cycles();
	for (i = 0; i < NR_LOOPS; i++) {
		do {
			seq = read_seqbegin(&test_lock);
		} while (read_seqretry(&test_lock, seq));
	}
	time2 = get_cycles();
	time = time2 - time1;
	local_irq_restore(flags);

	printk(KERN_ALERT "test results: time for seqlock\n");
	printk(KERN_ALERT "number of loops: %d\n", NR_LOOPS);
	printk(KERN_ALERT "total time: %llu\n", time);
	time = div_u64_rem(time, NR_LOOPS, &rem);
	printk(KERN_ALERT "-> seqlock takes %llu cycles\n", time);
	printk(KERN_ALERT "test end\n");
}

/*
 * Note : This test _should_ trigger lockdep errors due to preemption
 * disabling/enabling within irq off section. Given we are only interested in
 * having the most precise measurement for preemption disable/enable, we don't
 * care about this.
 */
static void do_test_preempt(void)
{
	unsigned long flags;
	unsigned int i;
	cycles_t time1, time2, time;
	u32 rem;

	local_irq_save(flags);
	preempt_disable();
	time1 = get_cycles();
	for (i = 0; i < NR_LOOPS; i++) {
		preempt_disable();
		preempt_enable();
	}
	time2 = get_cycles();
	preempt_enable();
	time = time2 - time1;
	local_irq_restore(flags);

	printk(KERN_ALERT
		"test results: time for preempt disable/enable pairs\n");
	printk(KERN_ALERT "number of loops: %d\n", NR_LOOPS);
	printk(KERN_ALERT "total time: %llu\n", time);
	time = div_u64_rem(time, NR_LOOPS, &rem);
	printk(KERN_ALERT "-> preempt disable/enable pair takes %llu cycles\n",
					time);
	printk(KERN_ALERT "test end\n");
}

static int ltt_test_init(void)
{
	printk(KERN_ALERT "test init\n");
	
	printk(KERN_ALERT "Number of active CPUs : %d\n", num_online_cpus());
	do_testbaseline();
	do_test_spinlock();
	do_test_read_rwlock();
	do_test_seqlock();
	do_test_preempt();
	return -EAGAIN; /* Fail will directly unload the module */
}

static void ltt_test_exit(void)
{
	printk(KERN_ALERT "test exit\n");
}

module_init(ltt_test_init)
module_exit(ltt_test_exit)

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Mathieu Desnoyers");
MODULE_DESCRIPTION("Test read lock speed");

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
