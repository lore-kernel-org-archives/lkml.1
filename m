Return-Path: <linux-kernel-owner+w=401wt.eu-S1754866AbYHMTQm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866AbYHMTQm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 15:16:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751705AbYHMTQd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 15:16:33 -0400
Received: from tomts22-srv.bellnexxia.net ([209.226.175.184]:65413 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751487AbYHMTQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 15:16:32 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjIFACzOokhMRKxB/2dsb2JhbACBYLUagVU
Date: Wed, 13 Aug 2008 15:16:14 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Steven Rostedt <srostedt@redhat.com>,
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
Subject: Re: Efficient x86 and x86_64 NOP microbenchmarks
Message-ID: <20080813191614.GA15547@Krystal>
References: <alpine.DEB.1.10.0808081432400.8922@gandalf.stny.rr.com> <20080808190506.GD11376@Krystal> <alpine.DEB.1.10.0808081750590.16691@gandalf.stny.rr.com> <87tzdv2g05.fsf@basil.nowhere.org> <alpine.DEB.1.10.0808082030500.1396@gandalf.stny.rr.com> <489CE90D.1040902@goop.org> <alpine.LFD.1.10.0808081750060.3462@nehalem.linux-foundation.org> <alpine.DEB.1.10.0808082113090.3707@gandalf.stny.rr.com> <20080813175213.GA8679@Krystal> <alpine.LFD.1.10.0808131119290.3462@nehalem.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0808131119290.3462@nehalem.linux-foundation.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 14:36:39 up 69 days, 23:17,  8 users,  load average: 0.84, 0.73,
	0.68
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Torvalds (torvalds@linux-foundation.org) wrote:
> 
> 
> On Wed, 13 Aug 2008, Mathieu Desnoyers wrote:
> > 
> > I also did some microbenchmarks on my Intel Xeon 64 bits, AMD64 and
> > Intel Pentium 4 boxes to compare a baseline
> 
> Note that the biggest problems of a jump-based nop are likely to happen 
> when there are I$ misses and/or when there are other jumps involved. Ie a 
> some microarchitectures tend to have issues with jumps to jumps, or when 
> there are multiple control changes in the same (possibly partial) 
> cacheline because the instruction stream prediction may be predecoded in 
> the L1 I$, and multiple branches in the same cacheline - or in the same 
> execution cycle - can pollute that kind of thing.
> 

Yup, I agree. Actually, the tests I ran shows that using jumps as nops
does not seems to be the best solution, even cycle-wise.

> So microbenchmarking this way will probably make some things look 
> unrealistically good. 
> 

Yes, I am aware of these "high locality" effects. I use these tests as a
starting point to find out which nops are good candidates, and then it
can be later validated with more thorough testing on real workloads,
which will suffer from higher standard deviation.

Interestingly enough, the P6_NOPS seems to be a poor choice both at the
macro and micro levels for the Intel Xeon (referring to
http://lkml.org/lkml/2008/8/13/253 for the macro-benchmarks).

> On the P4, the trace cache makes things even more interesting, since it's 
> another level of I$ entirely, with very different behavior for the hit 
> case vs the miss case.

As long as the whole kernel agrees on which instructions should be used
for frequently used nops, the instruction trace cache should behave
properly.

> 
> And I$ misses for the kernel are actually fairly high. Not in 
> microbenchmarks that tend to have very repetive behavior and a small I$ 
> footprint, but in a lot of real-life loads the *bulk* of all action is in 
> user space, and then the kernel side is often invoced with few loops (the 
> kernel has very few loops indeed) and a cold I$.

I assume the effect of I$ miss to be the same for all the tested
scenarios (except on P4, and maybe except for the jump cases), given
that in each case we load 5-bytes worth of instructions. Even
considering this, the results I get show that the choices made in the
current kernel does might not be the best ones.

> 
> So your numbers are interesting, but it would be really good to also get 
> some info from Intel/AMD who may know about microarchitectural issues for 
> the cases that don't show up in the hot-I$-cache environment.
> 

Yep. I think it may make a difference if we use jumps, but I doubt it
will change anything to the other various nops. Still, having that
information would be good.

Some more numbers follow for older architectures.

Intel Pentium 3, 550MHz

NR_TESTS                                    10000000
test empty cycles :                        510000254
test 2-bytes jump cycles :                 510000077
test 5-bytes jump cycles :                 510000101
test 3/2 nops cycles :                     500000072
test 5-bytes nop with long prefix cycles : 500000107
test 5-bytes P6 nop cycles :               500000069 (current choice ok)
test Generic 1/4 5-bytes nops cycles :     514687590
test K7 1/4 5-bytes nops cycles :          530000012

Intel Pentium 3, 933MHz

NR_TESTS                                    10000000
test empty cycles :                        510000565
test 2-bytes jump cycles :                 510000133
test 5-bytes jump cycles :                 510000363
test 3/2 nops cycles :                     500000358
test 5-bytes nop with long prefix cycles : 500000331
test 5-bytes P6 nop cycles :               500000625 (current choice ok)
test Generic 1/4 5-bytes nops cycles :     514687797
test K7 1/4 5-bytes nops cycles :          530000273


Intel Pentium M, 2GHz

NR_TESTS                                    10000000
test empty cycles :                        180000515
test 2-bytes jump cycles :                 180000386 (would be the best)
test 5-bytes jump cycles :                 205000435
test 3/2 nops cycles :                     193333517
test 5-bytes nop with long prefix cycles : 205000167
test 5-bytes P6 nop cycles :               205937652
test Generic 1/4 5-bytes nops cycles :     187500174
test K7 1/4 5-bytes nops cycles :          193750161


Intel Pentium 3, 550MHz

processor	: 0
vendor_id	: GenuineIntel
cpu family	: 6
model		: 7
model name	: Pentium III (Katmai)
stepping	: 3
cpu MHz		: 551.295
cache size	: 512 KB
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 2
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 sep mtrr pge mca cmov pat pse36 mmx fxsr sse
bogomips	: 1103.44
clflush size	: 32

Intel Pentium 3, 933MHz

processor	: 0
vendor_id	: GenuineIntel
cpu family	: 6
model		: 8
model name	: Pentium III (Coppermine)
stepping	: 6
cpu MHz		: 933.134
cache size	: 256 KB
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 2
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 sep mtrr pge mca cmov pat pse36 mmx fxsr sse
bogomips	: 1868.22
clflush size	: 32

Intel Pentium M, 2GHz

processor	: 0
vendor_id	: GenuineIntel
cpu family	: 6
model		: 13
model name	: Intel(R) Pentium(R) M processor 2.00GHz
stepping	: 8
cpu MHz		: 2000.000
cache size	: 2048 KB
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 2
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat clflush dts acpi mmx fxsr sse sse2 ss tm pbe nx bts est tm2
bogomips	: 3994.64
clflush size	: 64

Mathieu

> 			Linus




-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
