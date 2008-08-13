Return-Path: <linux-kernel-owner+w=401wt.eu-S1756210AbYHMPnW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756210AbYHMPnW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 11:43:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751852AbYHMPnH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 11:43:07 -0400
Received: from tomts20-srv.bellnexxia.net ([209.226.175.74]:38339 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751102AbYHMPnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 11:43:05 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjIFAOSdokhMRKxB/2dsb2JhbACBYLU2gVU
Date: Wed, 13 Aug 2008 11:38:00 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
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
Subject: Re: [PATCH 0/5] ftrace: to kill a daemon
Message-ID: <20080813153800.GF5853@Krystal>
References: <20080808182104.GA11376@Krystal> <alpine.DEB.1.10.0808081432400.8922@gandalf.stny.rr.com> <20080808190506.GD11376@Krystal> <alpine.DEB.1.10.0808081750590.16691@gandalf.stny.rr.com> <87tzdv2g05.fsf@basil.nowhere.org> <alpine.DEB.1.10.0808082030500.1396@gandalf.stny.rr.com> <489CE90D.1040902@goop.org> <alpine.LFD.1.10.0808081750060.3462@nehalem.linux-foundation.org> <alpine.DEB.1.10.0808082113090.3707@gandalf.stny.rr.com> <20080813063126.GA12335@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080813063126.GA12335@Krystal>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 11:35:39 up 69 days, 20:16,  7 users,  load average: 0.34, 0.61,
	0.54
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mathieu Desnoyers (mathieu.desnoyers@polymtl.ca) wrote:
> * Steven Rostedt (rostedt@goodmis.org) wrote:
> > 
> > On Fri, 8 Aug 2008, Linus Torvalds wrote:
> > > 
> > > 
> > > On Fri, 8 Aug 2008, Jeremy Fitzhardinge wrote:
> > > >
> > > > Steven Rostedt wrote:
> > > > > I wish we had a true 5 byte nop. 
> > > > 
> > > > 0x66 0x66 0x66 0x66 0x90
> > > 
> > > I don't think so. Multiple redundant prefixes can be really expensive on 
> > > some uarchs.
> > > 
> > > A no-op that isn't cheap isn't a no-op at all, it's a slow-op.
> > 
> > 
> > A quick meaningless benchmark showed a slight perfomance hit.
> > 
> 
> Hi Steven,
> 
> I tried to run my own tests to see if I could get to know if these
> numbers are actually meaningful at all. My results seems to show that
> there is not any significant difference between the various
> configurations, and actually that the only one tendency I see is that
> the 2-bytes jump offset 0x03 would be slightly faster than the 3/2 nop
> on Intel Xeon. But we would have to run these a bit more often to
> confirm that I guess.
> 
> I am just trying to get a sense of whether we are really trying hard to
> optimize something worthless in practice, and to me it looks like it.
> But it could be the architecture I am using that brings these results.
> 
> Mathieu
> 
> Intel Xeon dual quad-core
> Intel(R) Xeon(R) CPU           E5405  @ 2.00GHz
> 
> 3/2 nop used :
> K8_NOP3 K8_NOP2
> #define K8_NOP2 ".byte 0x66,0x90\n"
> #define K8_NOP3 ".byte 0x66,0x66,0x90\n"
> 

Small correction : my architecture uses the P6_NOP5, which is an atomic
5-bytes nop (just looked at the runtime output of find_nop_table()).

5: nopl 0x00(%eax,%eax,1)
#define P6_NOP5 ".byte 0x0f,0x1f,0x44,0x00,0\n"

But the results stands. Maybe I should try to force a test with a
K8_NOP3 K8_NOP2 nop.

Mathieu

> ** Summary **
> 
> Test A : make -j20 2.6.27-rc2 kernel (real time)
>                                           Avg.      std.dev
> Case 1 : ftrace not compiled-in.          1m9.76s   0.41s
> Case 2 : 3/2 nops                         1m9.95s   0.36s
> Case 3 : 2-bytes jump, offset 0x03        1m9.10s   0.40s
> Case 4 : 5-bytes jump, offset 0x00        1m9.25s   0.34s
> 
> Test B : hackbench 15
> 
> Case 1 : ftrace not compiled-in.          0.349s    0.007s
> Case 2 : 3/2 nops                         0.351s    0.014s
> Case 3 : 2-bytes jump, offset 0x03        0.350s    0.007s
> Case 4 : 5-bytes jump, offset 0x00        0.351s    0.010s
> 
> 
> 
> ** Detail **
> 
> * Test A
> 
> benchmark : make -j20 2.6.27-rc2 kernel
> make clean; make -j20; make clean done before the tests to prime caches.
> Same .config used.
> 
> 
> Case 1 : ftrace not compiled-in.
> 
> real	1m9.980s
> user	7m27.664s
> sys	0m48.771s
> 
> real	1m9.330s
> user	7m27.244s
> sys	0m50.567s
> 
> real	1m9.393s
> user	7m27.408s
> sys	0m50.511s
> 
> real	1m9.674s
> user	7m28.088s
> sys	0m50.327s
> 
> real	1m10.441s
> user	7m27.736s
> sys	0m49.687s
> 
> real time
> average : 1m9.76s
> std. dev. : 0.41s
> 
> after a reboot with the same kernel :
> 
> real	1m8.758s
> user	7m26.012s
> sys	0m48.835s
> 
> real	1m11.035s
> user	7m26.432s
> sys	0m49.171s
> 
> real	1m9.834s
> user	7m25.768s
> sys	0m49.167s
> 
> 
> Case 2 : 3/2 nops
> 
> real	1m9.713s
> user	7m27.524s
> sys	0m48.315s
> 
> real	1m9.481s
> user	7m27.144s
> sys	0m48.587s
> 
> real	1m10.565s
> user	7m27.048s
> sys	0m48.715s
> 
> real	1m10.008s
> user	7m26.436s
> sys	0m49.295s
> 
> real	1m9.982s
> user	7m27.160s
> sys	0m48.667s
> 
> real time
> avg : 1m9.95s
> std. dev. : 0.36s
> 
> 
> Case 3 : 2-bytes jump, offset 0x03
> 
> real	1m9.158s
> user	7m27.108s
> sys	0m48.775s
> 
> real	1m9.159s
> user	7m27.320s
> sys	0m48.659s
> 
> real	1m8.390s
> user	7m27.976s
> sys	0m48.359s
> 
> real	1m9.143s
> user	7m26.624s
> sys	0m48.719s
> 
> real	1m9.642s
> user	7m26.228s
> sys	0m49.483s
> 
> real time
> avg : 1m9.10s
> std. dev. : 0.40s
> 
> one extra after reboot with same kernel :
> 
> real	1m8.855s
> user	7m27.372s
> sys	0m48.543s
> 
> 
> Case 4 : 5-bytes jump, offset 0x00
> 
> real	1m9.173s
> user	7m27.228s
> sys	0m48.151s
> 
> real	1m9.735s
> user	7m26.852s
> sys	0m48.499s
> 
> real	1m9.502s
> user	7m27.148s
> sys	0m48.107s
> 
> real	1m8.727s
> user	7m27.416s
> sys	0m48.071s
> 
> real	1m9.115s
> user	7m26.932s
> sys	0m48.727s
> 
> real time
> avg : 1m9.25s
> std. dev. : 0.34s
> 
> 
> * Test B
> 
> Hackbench
> 
> Case 1 : ftrace not compiled-in.
> 
> ./hackbench 15
> Time: 0.358
> ./hackbench 15
> Time: 0.342
> ./hackbench 15
> Time: 0.354
> ./hackbench 15
> Time: 0.338
> ./hackbench 15
> Time: 0.347
> 
> Average : 0.349
> std. dev. : 0.007
> 
> Case 2 : 3/2 nops
> 
> ./hackbench 15
> Time: 0.328
> ./hackbench 15
> Time: 0.368
> ./hackbench 15
> Time: 0.351
> ./hackbench 15
> Time: 0.343
> ./hackbench 15
> Time: 0.366
> 
> Average : 0.351
> std. dev. : 0.014
> 
> Case 3 : jmp 2 bytes
> 
> ./hackbench 15
> Time: 0.346
> ./hackbench 15
> Time: 0.359
> ./hackbench 15
> Time: 0.356
> ./hackbench 15
> Time: 0.350
> ./hackbench 15
> Time: 0.340
> 
> Average : 0.350
> std. dev. : 0.007
> 
> Case 3 : jmp 5 bytes
> 
> ./hackbench 15
> Time: 0.346
> ./hackbench 15
> Time: 0.346
> ./hackbench 15
> Time: 0.364
> ./hackbench 15
> Time: 0.362
> ./hackbench 15
> Time: 0.338
> 
> Average : 0.351
> std. dev. : 0.010
> 
> 
> Hardware used :
> 
> processor	: 0
> vendor_id	: GenuineIntel
> cpu family	: 6
> model		: 23
> model name	: Intel(R) Xeon(R) CPU           E5405  @ 2.00GHz
> stepping	: 6
> cpu MHz		: 2000.114
> cache size	: 6144 KB
> physical id	: 0
> siblings	: 4
> core id		: 0
> cpu cores	: 4
> apicid		: 0
> initial apicid	: 0
> fpu		: yes
> fpu_exception	: yes
> cpuid level	: 10
> wp		: yes
> flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
> pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm
> constant_tsc arch_perfmon pebs bts rep_good pni monitor ds_cpl vmx tm2 ssse3
> cx16 xtpr dca sse4_1 lahf_lm
> bogomips	: 4000.22
> clflush size	: 64
> cache_alignment	: 64
> address sizes	: 38 bits physical, 48 bits virtual
> power management:
> 
> (7 other similar cpus)
> 
> 
> > Here's 10 runs of "hackbench 50" using the two part 5 byte nop:
> > 
> > run 1
> > Time: 4.501
> > run 2
> > Time: 4.855
> > run 3
> > Time: 4.198
> > run 4
> > Time: 4.587
> > run 5
> > Time: 5.016
> > run 6
> > Time: 4.757
> > run 7
> > Time: 4.477
> > run 8
> > Time: 4.693
> > run 9
> > Time: 4.710
> > run 10
> > Time: 4.715
> > avg = 4.6509
> > 
> > 
> > And 10 runs using the above 5 byte nop:
> > 
> > run 1
> > Time: 4.832
> > run 2
> > Time: 5.319
> > run 3
> > Time: 5.213
> > run 4
> > Time: 4.830
> > run 5
> > Time: 4.363
> > run 6
> > Time: 4.391
> > run 7
> > Time: 4.772
> > run 8
> > Time: 4.992
> > run 9
> > Time: 4.727
> > run 10
> > Time: 4.825
> > avg = 4.8264
> > 
> > # cat /proc/cpuinfo
> > processor	: 0
> > vendor_id	: AuthenticAMD
> > cpu family	: 15
> > model		: 65
> > model name	: Dual-Core AMD Opteron(tm) Processor 2220
> > stepping	: 3
> > cpu MHz		: 2799.992
> > cache size	: 1024 KB
> > physical id	: 0
> > siblings	: 2
> > core id		: 0
> > cpu cores	: 2
> > apicid		: 0
> > initial apicid	: 0
> > fdiv_bug	: no
> > hlt_bug		: no
> > f00f_bug	: no
> > coma_bug	: no
> > fpu		: yes
> > fpu_exception	: yes
> > cpuid level	: 1
> > wp		: yes
> > flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca 
> > cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt 
> > rdtscp lm 3dnowext 3dnow pni cx16 lahf_lm cmp_legacy svm extapic 
> > cr8_legacy
> > bogomips	: 5599.98
> > clflush size	: 64
> > power management: ts fid vid ttp tm stc
> > 
> > There's 4 of these.
> > 
> > Just to make sure, I ran the above nop test again:
> > 
> > [ this is reverse from the above runs ]
> > 
> > run 1
> > Time: 4.723
> > run 2
> > Time: 5.080
> > run 3
> > Time: 4.521
> > run 4
> > Time: 4.841
> > run 5
> > Time: 4.696
> > run 6
> > Time: 4.946
> > run 7
> > Time: 4.754
> > run 8
> > Time: 4.717
> > run 9
> > Time: 4.905
> > run 10
> > Time: 4.814
> > avg = 4.7997
> > 
> > And again the two part nop:
> > 
> > run 1
> > Time: 4.434
> > run 2
> > Time: 4.496
> > run 3
> > Time: 4.801
> > run 4
> > Time: 4.714
> > run 5
> > Time: 4.631
> > run 6
> > Time: 5.178
> > run 7
> > Time: 4.728
> > run 8
> > Time: 4.920
> > run 9
> > Time: 4.898
> > run 10
> > Time: 4.770
> > avg = 4.757
> > 
> > 
> > This time it was close, but still seems to have some difference.
> > 
> > heh, perhaps it's just noise.
> > 
> > -- Steve
> > 
> 
> -- 
> Mathieu Desnoyers
> OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
