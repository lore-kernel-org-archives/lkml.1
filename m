Return-Path: <linux-kernel-owner+w=401wt.eu-S1759079AbZCQBck@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759079AbZCQBck (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 21:32:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752331AbZCQBca
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 21:32:30 -0400
Received: from tomts43.bellnexxia.net ([209.226.175.110]:36463 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752087AbZCQBc3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 21:32:29 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApQFADOavklMQW1W/2dsb2JhbACBTtMbg38G
Date: Mon, 16 Mar 2009 21:32:20 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Josh Boyer <jwboyer@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, ltt-dev@lists.casi.polymtl.ca
Subject: cli/sti vs local_cmpxchg and local_add_return
Message-ID: <20090317013220.GA22474@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 21:01:44 up 16 days, 21:27,  1 user,  load average: 0.18, 0.25,
	0.36
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am trying to get access to some non-x86 hardware to run some atomic
primitive benchmarks for a paper on LTTng I am preparing. That should be
useful to argue about performance benefit of per-cpu atomic operations
vs interrupt disabling. I would like to run the following benchmark
module on CONFIG_SMP :

- PowerPC
- MIPS
- ia64
- alpha

usage :
make
insmod test-cmpxchg-nolock.ko
insmod: error inserting 'test-cmpxchg-nolock.ko': -1 Resource temporarily unavailable
dmesg (see dmesg output)

If some of you would be kind enough to run my test module provided below
and provide the results of these tests on a recent kernel (2.6.26~2.6.29
should be good) along with their cpuinfo, I would greatly appreciate.

Here are the CAS results for various Intel-based architectures :

Architecture         | Speedup                      |      CAS     |         Interrupts         |
                     | (cli + sti) / local cmpxchg  | local | sync | Enable (sti) | Disable (cli)
-------------------------------------------------------------------------------------------------
Intel Pentium 4      | 5.24                         |  25   | 81   | 70           | 61          |
AMD Athlon(tm)64 X2  | 4.57                         |  7    | 17   | 17           | 15          |
Intel Core2          | 6.33                         |  6    | 30   | 20           | 18          |
Intel Xeon E5405     | 5.25                         |  8    | 24   | 20           | 22          |

The benefit expected on PowerPC, ia64 and alpha should principally come
from removed memory barriers in the local primitives.

Thanks,

Mathieu

P.S. please forgive the coding style and hackish interface. :)


/* test-cmpxchg-nolock.c
 *
 * Compare local cmpxchg with irq disable / enable.
 */


#include <linux/jiffies.h>
#include <linux/compiler.h>
#include <linux/init.h>
#include <linux/module.h>
#include <linux/math64.h>
#include <asm/timex.h>
#include <asm/system.h>

#define NR_LOOPS 20000

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

static void do_test_sync_cmpxchg(void)
{
	int ret;
	unsigned long flags;
	unsigned int i;
	cycles_t time1, time2, time;
	u32 rem;

	local_irq_save(flags);
	preempt_disable();
	time1 = get_cycles();
	for (i = 0; i < NR_LOOPS; i++) {
#ifdef CONFIG_X86_32
		ret = sync_cmpxchg(&test_val, 0, 0);
#else
		ret = cmpxchg(&test_val, 0, 0);
#endif
	}
	time2 = get_cycles();
	local_irq_restore(flags);
	preempt_enable();
	time = time2 - time1;

	printk(KERN_ALERT "test results: time for locked cmpxchg\n");
	printk(KERN_ALERT "number of loops: %d\n", NR_LOOPS);
	printk(KERN_ALERT "total time: %llu\n", time);
	time = div_u64_rem(time, NR_LOOPS, &rem);
	printk(KERN_ALERT "-> locked cmpxchg takes %llu cycles\n", time);
	printk(KERN_ALERT "test end\n");
}

static void do_test_cmpxchg(void)
{
	int ret;
	unsigned long flags;
	unsigned int i;
	cycles_t time1, time2, time;
	u32 rem;

	local_irq_save(flags);
	preempt_disable();
	time1 = get_cycles();
	for (i = 0; i < NR_LOOPS; i++) {
		ret = cmpxchg_local(&test_val, 0, 0);
	}
	time2 = get_cycles();
	local_irq_restore(flags);
	preempt_enable();
	time = time2 - time1;

	printk(KERN_ALERT "test results: time for non locked cmpxchg\n");
	printk(KERN_ALERT "number of loops: %d\n", NR_LOOPS);
	printk(KERN_ALERT "total time: %llu\n", time);
	time = div_u64_rem(time, NR_LOOPS, &rem);
	printk(KERN_ALERT "-> non locked cmpxchg takes %llu cycles\n", time);
	printk(KERN_ALERT "test end\n");
}
static void do_test_sync_inc(void)
{
	int ret;
	unsigned long flags;
	unsigned int i;
	cycles_t time1, time2, time;
	u32 rem;
	atomic_t val;

	local_irq_save(flags);
	preempt_disable();
	time1 = get_cycles();
	for (i = 0; i < NR_LOOPS; i++) {
		ret = atomic_add_return(10, &val);
	}
	time2 = get_cycles();
	local_irq_restore(flags);
	preempt_enable();
	time = time2 - time1;

	printk(KERN_ALERT "test results: time for locked add return\n");
	printk(KERN_ALERT "number of loops: %d\n", NR_LOOPS);
	printk(KERN_ALERT "total time: %llu\n", time);
	time = div_u64_rem(time, NR_LOOPS, &rem);
	printk(KERN_ALERT "-> locked add return takes %llu cycles\n", time);
	printk(KERN_ALERT "test end\n");
}


static void do_test_inc(void)
{
	int ret;
	unsigned long flags;
	unsigned int i;
	cycles_t time1, time2, time;
	u32 rem;
	local_t loc_val;

	local_irq_save(flags);
	preempt_disable();
	time1 = get_cycles();
	for (i = 0; i < NR_LOOPS; i++) {
		ret = local_add_return(10, &loc_val);
	}
	time2 = get_cycles();
	local_irq_restore(flags);
	preempt_enable();
	time = time2 - time1;

	printk(KERN_ALERT "test results: time for non locked add return\n");
	printk(KERN_ALERT "number of loops: %d\n", NR_LOOPS);
	printk(KERN_ALERT "total time: %llu\n", time);
	time = div_u64_rem(time, NR_LOOPS, &rem);
	printk(KERN_ALERT "-> non locked add return takes %llu cycles\n", time);
	printk(KERN_ALERT "test end\n");
}



/*
 * This test will have a higher standard deviation due to incoming interrupts.
 */
static void do_test_enable_int(void)
{
	unsigned long flags;
	unsigned int i;
	cycles_t time1, time2, time;
	u32 rem;

	local_irq_save(flags);
	preempt_disable();
	time1 = get_cycles();
	for (i = 0; i < NR_LOOPS; i++) {
		local_irq_restore(flags);
	}
	time2 = get_cycles();
	local_irq_restore(flags);
	preempt_enable();
	time = time2 - time1;

	printk(KERN_ALERT "test results: time for enabling interrupts (STI)\n");
	printk(KERN_ALERT "number of loops: %d\n", NR_LOOPS);
	printk(KERN_ALERT "total time: %llu\n", time);
	time = div_u64_rem(time, NR_LOOPS, &rem);
	printk(KERN_ALERT "-> enabling interrupts (STI) takes %llu cycles\n",
					time);
	printk(KERN_ALERT "test end\n");
}

static void do_test_disable_int(void)
{
	unsigned long flags, flags2;
	unsigned int i;
	cycles_t time1, time2, time;
	u32 rem;

	local_irq_save(flags);
	preempt_disable();
	time1 = get_cycles();
	for ( i = 0; i < NR_LOOPS; i++) {
		local_irq_save(flags2);
	}
	time2 = get_cycles();
	local_irq_restore(flags);
	preempt_enable();
	time = time2 - time1;

	printk(KERN_ALERT "test results: time for disabling interrupts (CLI)\n");
	printk(KERN_ALERT "number of loops: %d\n", NR_LOOPS);
	printk(KERN_ALERT "total time: %llu\n", time);
	time = div_u64_rem(time, NR_LOOPS, &rem);
	printk(KERN_ALERT "-> disabling interrupts (CLI) takes %llu cycles\n",
				time);
	printk(KERN_ALERT "test end\n");
}

static void do_test_int(void)
{
	unsigned long flags;
	unsigned int i;
	cycles_t time1, time2, time;
	u32 rem;

	local_irq_save(flags);
	preempt_disable();
	time1 = get_cycles();
	for (i = 0; i < NR_LOOPS; i++) {
		local_irq_restore(flags);
		local_irq_save(flags);
	}
	time2 = get_cycles();
	local_irq_restore(flags);
	preempt_enable();
	time = time2 - time1;

	printk(KERN_ALERT "test results: time for disabling/enabling interrupts (STI/CLI)\n");
	printk(KERN_ALERT "number of loops: %d\n", NR_LOOPS);
	printk(KERN_ALERT "total time: %llu\n", time);
	time = div_u64_rem(time, NR_LOOPS, &rem);
	printk(KERN_ALERT "-> enabling/disabling interrupts (STI/CLI) takes %llu cycles\n",
					time);
	printk(KERN_ALERT "test end\n");
}



static int ltt_test_init(void)
{
	printk(KERN_ALERT "test init\n");
	
	do_testbaseline();
	do_test_sync_cmpxchg();
	do_test_cmpxchg();
	do_test_sync_inc();
	do_test_inc();
	do_test_enable_int();
	do_test_disable_int();
	do_test_int();
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
MODULE_DESCRIPTION("Cmpxchg vs int Test");



* Makefile

ifneq ($(KERNELRELEASE),)
	obj-m += test-cmpxchg-nolock.o
else
	KERNELDIR ?= /lib/modules/$(shell uname -r)/build
	PWD := $(shell pwd)
	KERNELRELEASE = $(shell cat $(KERNELDIR)/$(KBUILD_OUTPUT)/include/linux/version.h | sed -n 's/.*UTS_RELEASE.*\"\(.*\)\".*/\1/p')
ifneq ($(INSTALL_MOD_PATH),)
	DEPMOD_OPT := -b $(INSTALL_MOD_PATH)
endif

default:
	$(MAKE) -C $(KERNELDIR) M=$(PWD) modules

modules_install:
	$(MAKE) -C $(KERNELDIR) M=$(PWD) modules_install
	if [ -f $(KERNELDIR)/$(KBUILD_OUTPUT)/System.map ] ; then /sbin/depmod -ae -F $(KERNELDIR)/$(KBUILD_OUTPUT)/System.map $(DEPMOD_OPT) $(KERNELRELEASE) ; fi


clean:
	$(MAKE) -C $(KERNELDIR) M=$(PWD) clean
endif


-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
