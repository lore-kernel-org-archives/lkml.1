Return-Path: <linux-kernel-owner+w=401wt.eu-S1757622AbZEVPBz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757622AbZEVPBz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 11:01:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756273AbZEVPBs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 11:01:48 -0400
Received: from tomts16-srv.bellnexxia.net ([209.226.175.4]:53895 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755942AbZEVPBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 11:01:47 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq0EAJNaFkpMQW1W/2dsb2JhbACBT9FYhAsF
Date: Fri, 22 May 2009 11:01:38 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Steve Langstaff <steve.langstaff@pebblebay.com>
Cc: "'David Miller'" <davem@davemloft.net>, paulmck@linux.vnet.ibm.com,
       mingo@elte.hu, jwboyer@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       ltt-dev@lists.casi.polymtl.ca, "'Subrata Modak'" <tosubrata@gmail.com>,
       "'Alan D. Brunelle'" <Alan.Brunelle@hp.com>,
       "'Andika Triwidada'" <andika@startrek.or.id>
Subject: Re: [ltt-dev] Test module : benchmarking read-side locking speed
Message-ID: <20090522150138.GB3784@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 10:59:50 up 83 days, 11:26,  5 users,  load average: 0.04, 0.17,
	0.11
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steve Langstaff (steve.langstaff@pebblebay.com) wrote:
> > From: Mathieu Desnoyers [mailto:compudj@krystal.dyndns.org]
> > Sent: 21 May 2009 20:12
> 
> 
> > I am trying to complete my numbers for performance impact of read-side
> > locking primitives (on the fast path) for various architectures.
> 
> > Help with testing on a larger set of architectures would be more than
> > welcome. Note that this module requires the kernel to be configured
> > with
> > CONFIG_PREEMPT=y. Some config option sanity checking is done at
> > compile-time. Other requirement : disable invasive lockdep-style
> > instrumentation.
> 
> Another requirement is that get_cycles() needs to return something
> meaningful :)
> 

For ARMv7 Omap3, I have the following version (I've been able to get
benchmarks with it yesterday). It requires LTTng to be started for the 
trace clock infrastructure to be in place and running to provide a full
64-bits emulated TSC.

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

#ifdef CONFIG_ARM
#include <linux/trace-clock.h>
#define get_timestamp	trace_clock_read64
#else
#define get_timestamp	get_cycles
#endif

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
	time1 = get_timestamp();
	for (i = 0; i < NR_LOOPS; i++) {
		asm volatile ("");
	}
	time2 = get_timestamp();
	local_irq_restore(flags);
	preempt_enable();
	time = time2 - time1;

	printk(KERN_ALERT "test results: time for baseline\n");
	printk(KERN_ALERT "number of loops: %d\n", NR_LOOPS);
	printk(KERN_ALERT "total time: %llu\n", (unsigned long long)time);
	time = div_u64_rem(time, NR_LOOPS, &rem);
	printk(KERN_ALERT "-> baseline takes %llu cycles\n", (unsigned long long)time);
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
	time1 = get_timestamp();
	for (i = 0; i < NR_LOOPS; i++) {
		spin_unlock(&mylock);
		spin_lock(&mylock);
	}
	time2 = get_timestamp();
	spin_unlock_irqrestore(&mylock, flags);
	preempt_enable();
	time = time2 - time1;

	printk(KERN_ALERT "test results: time for spinlock\n");
	printk(KERN_ALERT "number of loops: %d\n", NR_LOOPS);
	printk(KERN_ALERT "total time: %llu\n", (unsigned long long)time);
	time = div_u64_rem(time, NR_LOOPS, &rem);
	printk(KERN_ALERT "-> spinlock takes %llu cycles\n", (unsigned long long)time);
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
	time1 = get_timestamp();
	for (i = 0; i < NR_LOOPS; i++) {
		read_unlock(&mylock);
		read_lock(&mylock);
	}
	time2 = get_timestamp();
	read_unlock(&mylock);
	local_irq_restore(flags);
	preempt_enable();
	time = time2 - time1;

	printk(KERN_ALERT "test results: time for read rwlock\n");
	printk(KERN_ALERT "number of loops: %d\n", NR_LOOPS);
	printk(KERN_ALERT "total time: %llu\n", (unsigned long long)time);
	time = div_u64_rem(time, NR_LOOPS, &rem);
	printk(KERN_ALERT "-> read rwlock takes %llu cycles\n", (unsigned long long)time);
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
	time1 = get_timestamp();
	for (i = 0; i < NR_LOOPS; i++) {
		do {
			seq = read_seqbegin(&test_lock);
		} while (read_seqretry(&test_lock, seq));
	}
	time2 = get_timestamp();
	time = time2 - time1;
	local_irq_restore(flags);

	printk(KERN_ALERT "test results: time for seqlock\n");
	printk(KERN_ALERT "number of loops: %d\n", NR_LOOPS);
	printk(KERN_ALERT "total time: %llu\n", (unsigned long long)time);
	time = div_u64_rem(time, NR_LOOPS, &rem);
	printk(KERN_ALERT "-> seqlock takes %llu cycles\n", (unsigned long long)time);
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
	time1 = get_timestamp();
	for (i = 0; i < NR_LOOPS; i++) {
		preempt_disable();
		preempt_enable();
	}
	time2 = get_timestamp();
	preempt_enable();
	time = time2 - time1;
	local_irq_restore(flags);

	printk(KERN_ALERT
		"test results: time for preempt disable/enable pairs\n");
	printk(KERN_ALERT "number of loops: %d\n", NR_LOOPS);
	printk(KERN_ALERT "total time: %llu\n", (unsigned long long)time);
	time = div_u64_rem(time, NR_LOOPS, &rem);
	printk(KERN_ALERT "-> preempt disable/enable pair takes %llu cycles\n",
					(unsigned long long)time);
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


> This on a PXA255:
> 
> /lib/modules/2.6.29.2 # insmod ./ltt_test.ko
> [   61.121372] test init
> [   61.123690] Number of active CPUs : 1
> [   61.127506] test results: time for baseline
> [   61.131818] number of loops: 20000
> [   61.135220] total time: 0
> [   61.137842] -> baseline takes 0 cycles
> [   61.141629] test end
> [   61.144719] test results: time for spinlock
> [   61.148909] number of loops: 20000
> [   61.152325] total time: 0
> [   61.154943] -> spinlock takes 0 cycles
> [   61.158690] test end
> [   61.161799] test results: time for read rwlock
> [   61.166244] number of loops: 20000
> [   61.169645] total time: 0
> [   61.172284] -> read rwlock takes 0 cycles
> [   61.176294] test end
> [   61.179137] test results: time for seqlock
> [   61.183255] number of loops: 20000
> [   61.186660] total time: 0
> [   61.189283] -> seqlock takes 0 cycles
> [   61.192958] test end
> [   61.195998] test results: time for preempt disable/enable pairs
> [   61.201944] number of loops: 20000
> [   61.205349] total time: 0
> [   61.207973] -> preempt disable/enable pair takes 0 cycles
> [   61.213508] test end
> insmod: cannot insert './ltt_test.ko': Resource temporarily unavailable
> (-1): Resource temporarily unavailable
> 
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
