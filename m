Return-Path: <linux-kernel-owner+w=401wt.eu-S1754593AbXHVAip@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593AbXHVAip (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 20:38:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751759AbXHVAih
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 20:38:37 -0400
Received: from tomts36-srv.bellnexxia.net ([209.226.175.93]:33308 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751055AbXHVAig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 20:38:36 -0400
Date: Tue, 21 Aug 2007 20:38:34 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andi Kleen <andi@firstfloor.org>
Cc: Christoph Lameter <clameter@sgi.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, mingo@redhat.com
Subject: Re: [PATCH] SLUB use cmpxchg_local
Message-ID: <20070822003834.GB1400@Krystal>
References: <20070821173849.GA8360@Krystal> <Pine.LNX.4.64.0708211404290.3082@schroedinger.engr.sgi.com> <20070821231216.GA29691@Krystal> <Pine.LNX.4.64.0708211614370.6062@schroedinger.engr.sgi.com> <20070821233938.GD29691@Krystal> <Pine.LNX.4.64.0708211640430.6225@schroedinger.engr.sgi.com> <20070821234702.GE29691@Krystal> <Pine.LNX.4.64.0708211649260.6886@schroedinger.engr.sgi.com> <20070822000323.GG29691@Krystal> <p73fy2cz7bs.fsf@bingen.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <p73fy2cz7bs.fsf@bingen.suse.de>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 20:36:11 up 23 days, 55 min,  2 users,  load average: 0.32, 0.56, 0.46
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Andi Kleen (andi@firstfloor.org) wrote:
> Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> writes:
> > 
> > The measurements I get (in cycles):
> >              enable interrupts (STI)   disable interrupts (CLI)   local CMPXCHG
> > IA32 (P4)    112                        82                         26
> > x86_64 AMD64 125                       102                         19
> 
> What exactly did you benchmark here? On K8 CLI/STI are only supposed
> to be a few cycles. pushf/popf might me more expensive, but not that much.
> 

Hi Andi,

I benchmarked cmpxchg_local vs local_irq_save/local_irq_restore.
Details, and code, follow.

* cpuinfo:

processor	: 0
vendor_id	: AuthenticAMD
cpu family	: 15
model		: 35
model name	: AMD Athlon(tm)64 X2 Dual Core Processor  3800+
stepping	: 2
cpu MHz		: 2009.204
cache size	: 512 KB
physical id	: 0
siblings	: 2
core id		: 0
cpu cores	: 2
fpu		: yes
fpu_exception	: yes
cpuid level	: 1
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt lm 3dnowext 3dnow pni lahf_lm cmp_legacy
bogomips	: 4023.38
TLB size	: 1024 4K pages
clflush size	: 64
cache_alignment	: 64
address sizes	: 40 bits physical, 48 bits virtual
power management: ts fid vid ttp

processor	: 1
vendor_id	: AuthenticAMD
cpu family	: 15
model		: 35
model name	: AMD Athlon(tm)64 X2 Dual Core Processor  3800+
stepping	: 2
cpu MHz		: 2009.204
cache size	: 512 KB
physical id	: 0
siblings	: 2
core id		: 1
cpu cores	: 2
fpu		: yes
fpu_exception	: yes
cpuid level	: 1
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt lm 3dnowext 3dnow pni lahf_lm cmp_legacy
bogomips	: 4018.49
TLB size	: 1024 4K pages
clflush size	: 64
cache_alignment	: 64
address sizes	: 40 bits physical, 48 bits virtual
power management: ts fid vid ttp


* Test ran:


/* test-cmpxchg-nolock.c
 *
 * Compare local cmpxchg with irq disable / enable.
 */


#include <linux/jiffies.h>
#include <linux/compiler.h>
#include <linux/init.h>
#include <linux/module.h>
#include <linux/calc64.h>
#include <asm/timex.h>
#include <asm/system.h>

#define NR_LOOPS 20000

int test_val;

static void do_test_cmpxchg(void)
{
	int ret;
	long flags;
	unsigned int i;
	cycles_t time1, time2, time;
	long rem;

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
	time = div_long_long_rem(time, NR_LOOPS, &rem);
	printk(KERN_ALERT "-> non locked cmpxchg takes %llu cycles\n", time);
	printk(KERN_ALERT "test end\n");
}

/*
 * This test will have a higher standard deviation due to incoming interrupts.
 */
static void do_test_enable_int(void)
{
	long flags;
	unsigned int i;
	cycles_t time1, time2, time;
	long rem;

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
	time = div_long_long_rem(time, NR_LOOPS, &rem);
	printk(KERN_ALERT "-> enabling interrupts (STI) takes %llu cycles\n",
					time);
	printk(KERN_ALERT "test end\n");
}

static void do_test_disable_int(void)
{
	unsigned long flags, flags2;
	unsigned int i;
	cycles_t time1, time2, time;
	long rem;

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
	time = div_long_long_rem(time, NR_LOOPS, &rem);
	printk(KERN_ALERT "-> disabling interrupts (CLI) takes %llu cycles\n",
				time);
	printk(KERN_ALERT "test end\n");
}



static int ltt_test_init(void)
{
	printk(KERN_ALERT "test init\n");
	
	do_test_cmpxchg();
	do_test_enable_int();
	do_test_disable_int();
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



-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
