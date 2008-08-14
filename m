Return-Path: <linux-kernel-owner+w=401wt.eu-S1757628AbYHNBNv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757628AbYHNBNv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 21:13:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753703AbYHNBNn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 21:13:43 -0400
Received: from tomts22-srv.bellnexxia.net ([209.226.175.184]:61675 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753666AbYHNBNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 21:13:42 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjIFAD8jo0hMRKxB/2dsb2JhbACBYLU+gVU
Date: Wed, 13 Aug 2008 21:13:40 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Steven Rostedt <srostedt@redhat.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Roland McGrath <roland@redhat.com>,
       Ulrich Drepper <drepper@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Clark Williams <williams@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [RFC PATCH] x86 alternatives : fix LOCK_PREFIX race with
	preemptible kernel and CPU hotplug
Message-ID: <20080814011340.GA30038@Krystal>
References: <alpine.LFD.1.10.0808081750060.3462@nehalem.linux-foundation.org> <alpine.DEB.1.10.0808082113090.3707@gandalf.stny.rr.com> <20080813175213.GA8679@Krystal> <alpine.LFD.1.10.0808131119290.3462@nehalem.linux-foundation.org> <20080813184142.GM1366@one.firstfloor.org> <20080813193011.GC15547@Krystal> <20080813193715.GQ1366@one.firstfloor.org> <20080813200119.GA18966@Krystal> <20080813234156.GA25775@Krystal> <48A375E3.9090609@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <48A375E3.9090609@zytor.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 20:54:22 up 70 days,  5:34,  6 users,  load average: 0.73, 0.52,
	0.40
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* H. Peter Anvin (hpa@zytor.com) wrote:
> Mathieu Desnoyers wrote:
>> If a kernel thread is preempted in single-cpu mode right after the NOP 
>> (nop
>> about to be turned into a lock prefix), then we CPU hotplug a CPU, and 
>> then the
>> thread is scheduled back again, a SMP-unsafe atomic operation will be used 
>> on
>> shared SMP variables, leading to corruption. No corruption would happen in 
>> the
>> reverse case : going from SMP to UP is ok because we split a bit 
>> instruction
>> into tiny pieces, which does not present this condition.
>> Changing the 0x90 (single-byte nop) currently used into a 0x3E DS segment
>> override prefix should fix this issue. Since the default of the atomic
>> instructions is to use the DS segment anyway, it should not affect the
>> behavior.
>
> I believe this should be okay.  In 32-bit mode some of the security and 
> hypervisor frameworks want to set segment limits, but I don't believe they 
> ever would set DS and SS inconsistently, or that we'd handle a #GP versus 
> an #SS differently (segment violations on the stack segment are #SS, not 
> #GP.)  To be 100% sure we'd have to pick apart the modr/m byte to figure 
> out what the base register is but I think that's total overkill.
>

I guess some testing of this patch under an virtualized Linux would not
hurt. Anyone have a setup ready ? The test case is simple : Run a kernel
on a multi-CPU virtual guest.

export NR_CPUS=...
for a in `seq 1 $NR_CPUS`; do echo 0 > ./devices/system/cpu/cpu$a/online;done

> I have a vague notion that DS: prefixes came with a penalty on older CPUs, 
> so we may want to do this only when CPU hotplug is enabled, to avoid 
> penalizing older embedded systems.
>
> 	-hpa

Reading the "Intel Architecture Optimizations Manual" for older Intels :

http://developer.intel.com/design/pentium/manuals/242816.htm
Chapter 3.7 Prefixed Opcodes

The penality for instructions prefixed with other prefixes than 0x0f,
0x66 or 0x67 seems to be 1 added clock cycle to detect the prefix when
it cannot be paired.

Since we are choosing between the existing 0x90 nop followed by the
atomic instruction and this prefix applied to the atomic instruction,
we have to consider the penality cost of this nop. From the same manual,
the NOP is decoded into 1 micro-op.

Unless these architectures (386SX/DX, 486, Pentium Pro, Pentium MMX,
Pentium II) can execute more than 1 micro-op per cycle, I doubt the DS
prefix would cause any degradation compared to the 0x90 nop. And this
would free the lower stages of the pipeline from executing this NOP
micro-op.

I guess some quick performance tests with the modules I provide on my
website (URL in the patch header) could confirm or infirm this.
Actually, I just removed the dust from an old Pentium II, here are the
results. There is no performance overhead nor degradation.

NR_TESTS                                    10000000
test empty cycles :                        200833494
test test 1-byte nop xadd cycles :         340000130
test test DS override prefix xadd cycles : 340000126 *
test test LOCK xadd cycles :               530000078

processor : 0
vendor_id : GenuineIntel
cpu family  : 6
model   : 5
model name  : Pentium II (Deschutes)
stepping  : 2
cpu MHz   : 350.867
cache size  : 512 KB
fdiv_bug  : no
hlt_bug   : no
f00f_bug  : no
coma_bug  : no
fpu   : yes
fpu_exception : yes
cpuid level : 2
wp    : yes
flags   : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 mmx fxsr
bogomips  : 690.17

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
