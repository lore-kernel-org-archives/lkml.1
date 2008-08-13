Return-Path: <linux-kernel-owner+w=401wt.eu-S1756529AbYHMRwd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756529AbYHMRwd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 13:52:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752462AbYHMRwY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 13:52:24 -0400
Received: from tomts16.bellnexxia.net ([209.226.175.4]:61342 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752461AbYHMRwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 13:52:22 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjIFACW4okhMRKxB/2dsb2JhbACBYLUCgVU
Date: Wed, 13 Aug 2008 13:52:13 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Andi Kleen <andi@firstfloor.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Roland McGrath <roland@redhat.com>,
       Ulrich Drepper <drepper@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Clark Williams <williams@redhat.com>
Subject: Efficient x86 and x86_64 NOP microbenchmarks
Message-ID: <20080813175213.GA8679@Krystal>
References: <alpine.DEB.1.10.0808081410380.6116@gandalf.stny.rr.com> <20080808182104.GA11376@Krystal> <alpine.DEB.1.10.0808081432400.8922@gandalf.stny.rr.com> <20080808190506.GD11376@Krystal> <alpine.DEB.1.10.0808081750590.16691@gandalf.stny.rr.com> <87tzdv2g05.fsf@basil.nowhere.org> <alpine.DEB.1.10.0808082030500.1396@gandalf.stny.rr.com> <489CE90D.1040902@goop.org> <alpine.LFD.1.10.0808081750060.3462@nehalem.linux-foundation.org> <alpine.DEB.1.10.0808082113090.3707@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0808082113090.3707@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 11:50:23 up 69 days, 20:31,  7 users,  load average: 1.22, 0.76,
	0.59
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> 
> On Fri, 8 Aug 2008, Linus Torvalds wrote:
> > 
> > 
> > On Fri, 8 Aug 2008, Jeremy Fitzhardinge wrote:
> > >
> > > Steven Rostedt wrote:
> > > > I wish we had a true 5 byte nop. 
> > > 
> > > 0x66 0x66 0x66 0x66 0x90
> > 
> > I don't think so. Multiple redundant prefixes can be really expensive on 
> > some uarchs.
> > 
> > A no-op that isn't cheap isn't a no-op at all, it's a slow-op.
> 
> 
> A quick meaningless benchmark showed a slight perfomance hit.
> 

Hi Steven,

I also did some microbenchmarks on my Intel Xeon 64 bits, AMD64 and
Intel Pentium 4 boxes to compare a baseline (function doing a bit of
memory read and arithmetic operations) to cases where nops are used.
Here are the results. The kernel module used for the benchmarks is
below, feel free to run it on your own architectures.

Xeon :

NR_TESTS                                    10000000
test empty cycles :                        165472020
test 2-bytes jump cycles :                 166666806
test 5-bytes jump cycles :                 166978164
test 3/2 nops cycles :                     169259406
test 5-bytes nop with long prefix cycles : 160000140
test 5-bytes P6 nop cycles :               163333458


AMD64 :

NR_TESTS                                    10000000
test empty cycles :                        145142367
test 2-bytes jump cycles :                 150000178
test 5-bytes jump cycles :                 150000171
test 3/2 nops cycles :                     159999994
test 5-bytes nop with long prefix cycles : 150000156
test 5-bytes P6 nop cycles :               150000148


Intel Pentium 4 :

NR_TESTS                                    10000000
test empty cycles :                        290001045
test 2-bytes jump cycles :                 310000568
test 5-bytes jump cycles :                 310000478
test 3/2 nops cycles :                     290000565
test 5-bytes nop with long prefix cycles : 311085510
test 5-bytes P6 nop cycles :               300000517
test Generic 1/4 5-bytes nops cycles :     310000553
test K7 1/4 5-bytes nops cycles :          300000533


These numbers show that both on Xeon and AMD64, the 

   .byte 0x66,0x66,0x66,0x66,0x90

(osp osp osp osp nop, which is not currently used in nops.h)

is the fastest nop on both architectures.

The currently used 3/2 nops looks like a _very_ bad choice for AMD64
cycle-wise.

The currently used 5-bytes P6 nop used on Xeon seems to be a bit slower
than the 0x66,0x66,0x66,0x66,0x90 nop too.

For the Intel Pentium 4, the best atomic choice seems to be the current
one (5-bytes P6 nop : .byte 0x0f,0x1f,0x44,0x00,0), although we can see
that the 3/2 nop used for K8 would be a bit faster. It is probably due
to the fact that P4 handles long instruction prefixes slowly.

Is there any reason why not to use these atomic nops and kill our
instruction atomicity problems altogether ?

(various cpuinfo can be found below)

Mathieu


/* test-nop-speed.c
 *
 */

#include <linux/module.h>
#include <linux/proc_fs.h>
#include <linux/sched.h>
#include <linux/timex.h>
#include <linux/marker.h>
#include <asm/ptrace.h>

#define NR_TESTS 10000000

int var, var2;

struct proc_dir_entry *pentry = NULL;

void empty(void)
{
	asm volatile ("");
	var += 50;
	var /= 10;
	var *= var2;
}

void twobytesjump(void)
{
	asm volatile ("jmp 1f\n\t"
		".byte 0x00, 0x00, 0x00\n\t"
		"1:\n\t");
	var += 50;
	var /= 10;
	var *= var2;
}

void fivebytesjump(void)
{
	asm volatile (".byte 0xe9, 0x00, 0x00, 0x00, 0x00\n\t");
	var += 50;
	var /= 10;
	var *= var2;
}

void threetwonops(void)
{
	asm volatile (".byte 0x66,0x66,0x90,0x66,0x90\n\t");
	var += 50;
	var /= 10;
	var *= var2;
}

void fivebytesnop(void)
{
	asm volatile (".byte 0x66,0x66,0x66,0x66,0x90\n\t");
	var += 50;
	var /= 10;
	var *= var2;
}

void fivebytespsixnop(void)
{
	asm volatile (".byte 0x0f,0x1f,0x44,0x00,0\n\t");
	var += 50;
	var /= 10;
	var *= var2;
}

/*
 * GENERIC_NOP1 GENERIC_NOP4,
 * 1: nop
 * _not_ nops in 64-bit mode.
 * 4: leal 0x00(,%esi,1),%esi
 */
void genericfivebytesonefournops(void)
{
	asm volatile (".byte 0x90,0x8d,0x74,0x26,0x00\n\t");
	var += 50;
	var /= 10;
	var *= var2;
}

/*
 * K7_NOP4 ASM_NOP1
 * 1: nop
 * assumed _not_ to be nops in 64-bit mode.
 * leal 0x00(,%eax,1),%eax
 */
void k7fivebytesonefournops(void)
{
	asm volatile (".byte 0x90,0x8d,0x44,0x20,0x00\n\t");
	var += 50;
	var /= 10;
	var *= var2;
}

void perform_test(const char *name, void (*callback)(void))
{
	unsigned int i;
	cycles_t cycles1, cycles2;
	unsigned long flags;

	local_irq_save(flags);
	rdtsc_barrier();
	cycles1 = get_cycles();
	rdtsc_barrier();
	for(i=0; i<NR_TESTS; i++) {
		callback();
	}
	rdtsc_barrier();
	cycles2 = get_cycles();
	rdtsc_barrier();
	local_irq_restore(flags);
	printk("test %s cycles : %llu\n", name, cycles2-cycles1);
}

static int my_open(struct inode *inode, struct file *file)
{
	printk("NR_TESTS %d\n", NR_TESTS);

	perform_test("empty", empty);
	perform_test("2-bytes jump", twobytesjump);
	perform_test("5-bytes jump", fivebytesjump);
	perform_test("3/2 nops", threetwonops);
	perform_test("5-bytes nop with long prefix", fivebytesnop);
	perform_test("5-bytes P6 nop", fivebytespsixnop);
#ifdef CONFIG_X86_32
	perform_test("Generic 1/4 5-bytes nops", genericfivebytesonefournops);
	perform_test("K7 1/4 5-bytes nops", k7fivebytesonefournops);
#endif

	return -EPERM;
}


static struct file_operations my_operations = {
	.open = my_open,
};

int init_module(void)
{
	pentry = create_proc_entry("testnops", 0444, NULL);
	if (pentry)
		pentry->proc_fops = &my_operations;

	return 0;
}

void cleanup_module(void)
{
	remove_proc_entry("testnops", NULL);
}

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Mathieu Desnoyers");
MODULE_DESCRIPTION("NOP Test");


Xeon cpuinfo :

processor	: 0
vendor_id	: GenuineIntel
cpu family	: 6
model		: 23
model name	: Intel(R) Xeon(R) CPU           E5405  @ 2.00GHz
stepping	: 6
cpu MHz		: 2000.126
cache size	: 6144 KB
physical id	: 0
siblings	: 4
core id		: 0
cpu cores	: 4
apicid		: 0
initial apicid	: 0
fpu		: yes
fpu_exception	: yes
cpuid level	: 10
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm constant_tsc arch_perfmon pebs bts rep_good pni monitor ds_cpl vmx tm2 ssse3 cx16 xtpr dca sse4_1 lahf_lm
bogomips	: 4000.25
clflush size	: 64
cache_alignment	: 64
address sizes	: 38 bits physical, 48 bits virtual
power management:

AMD64 cpuinfo :

processor	: 0
vendor_id	: AuthenticAMD
cpu family	: 15
model		: 35
model name	: AMD Athlon(tm)64 X2 Dual Core Processor  3800+
stepping	: 2
cpu MHz		: 2009.139
cache size	: 512 KB
physical id	: 0
siblings	: 2
core id		: 0
cpu cores	: 2
apicid		: 0
initial apicid	: 0
fpu		: yes
fpu_exception	: yes
cpuid level	: 1
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt lm 3dnowext 3dnow rep_good pni lahf_lm cmp_legacy
bogomips	: 4022.42
TLB size	: 1024 4K pages
clflush size	: 64
cache_alignment	: 64
address sizes	: 40 bits physical, 48 bits virtual
power management: ts fid vid ttp

Pentium 4 :


processor	: 0
vendor_id	: GenuineIntel
cpu family	: 15
model		: 4
model name	: Intel(R) Pentium(R) 4 CPU 3.00GHz
stepping	: 1
cpu MHz		: 3000.138
cache size	: 1024 KB
physical id	: 0
siblings	: 1
core id		: 0
cpu cores	: 1
apicid		: 0
initial apicid	: 0
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 5
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx constant_tsc up pebs bts pni monitor ds_cpl cid xtpr
bogomips	: 6005.70
clflush size	: 64
power management:



> Here's 10 runs of "hackbench 50" using the two part 5 byte nop:
> 
> run 1
> Time: 4.501
> run 2
> Time: 4.855
> run 3
> Time: 4.198
> run 4
> Time: 4.587
> run 5
> Time: 5.016
> run 6
> Time: 4.757
> run 7
> Time: 4.477
> run 8
> Time: 4.693
> run 9
> Time: 4.710
> run 10
> Time: 4.715
> avg = 4.6509
> 
> 
> And 10 runs using the above 5 byte nop:
> 
> run 1
> Time: 4.832
> run 2
> Time: 5.319
> run 3
> Time: 5.213
> run 4
> Time: 4.830
> run 5
> Time: 4.363
> run 6
> Time: 4.391
> run 7
> Time: 4.772
> run 8
> Time: 4.992
> run 9
> Time: 4.727
> run 10
> Time: 4.825
> avg = 4.8264
> 
> # cat /proc/cpuinfo
> processor	: 0
> vendor_id	: AuthenticAMD
> cpu family	: 15
> model		: 65
> model name	: Dual-Core AMD Opteron(tm) Processor 2220
> stepping	: 3
> cpu MHz		: 2799.992
> cache size	: 1024 KB
> physical id	: 0
> siblings	: 2
> core id		: 0
> cpu cores	: 2
> apicid		: 0
> initial apicid	: 0
> fdiv_bug	: no
> hlt_bug		: no
> f00f_bug	: no
> coma_bug	: no
> fpu		: yes
> fpu_exception	: yes
> cpuid level	: 1
> wp		: yes
> flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca 
> cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt 
> rdtscp lm 3dnowext 3dnow pni cx16 lahf_lm cmp_legacy svm extapic 
> cr8_legacy
> bogomips	: 5599.98
> clflush size	: 64
> power management: ts fid vid ttp tm stc
> 
> There's 4 of these.
> 
> Just to make sure, I ran the above nop test again:
> 
> [ this is reverse from the above runs ]
> 
> run 1
> Time: 4.723
> run 2
> Time: 5.080
> run 3
> Time: 4.521
> run 4
> Time: 4.841
> run 5
> Time: 4.696
> run 6
> Time: 4.946
> run 7
> Time: 4.754
> run 8
> Time: 4.717
> run 9
> Time: 4.905
> run 10
> Time: 4.814
> avg = 4.7997
> 
> And again the two part nop:
> 
> run 1
> Time: 4.434
> run 2
> Time: 4.496
> run 3
> Time: 4.801
> run 4
> Time: 4.714
> run 5
> Time: 4.631
> run 6
> Time: 5.178
> run 7
> Time: 4.728
> run 8
> Time: 4.920
> run 9
> Time: 4.898
> run 10
> Time: 4.770
> avg = 4.757
> 
> 
> This time it was close, but still seems to have some difference.
> 
> heh, perhaps it's just noise.
> 
> -- Steve
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
