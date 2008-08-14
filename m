Return-Path: <linux-kernel-owner+w=401wt.eu-S1753850AbYHNQ6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850AbYHNQ6T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 12:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750738AbYHNQ6G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 12:58:06 -0400
Received: from tomts25.bellnexxia.net ([209.226.175.188]:36276 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751152AbYHNQ6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 12:58:05 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AswEAH39o0hMRKxB/2dsb2JhbACBYrRfgVU
Date: Thu, 14 Aug 2008 12:58:02 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Steven Rostedt <srostedt@redhat.com>,
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
Message-ID: <20080814165802.GC517@Krystal>
References: <20080813193011.GC15547@Krystal> <20080813193715.GQ1366@one.firstfloor.org> <20080813200119.GA18966@Krystal> <20080813234156.GA25775@Krystal> <48A375E3.9090609@zytor.com> <48A388CE.2020404@goop.org> <20080814014944.GA31883@Krystal> <48A3A806.8060509@goop.org> <20080814151805.GA29507@Krystal> <48A459B1.2070601@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <48A459B1.2070601@zytor.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 12:56:43 up 70 days, 21:37,  7 users,  load average: 0.14, 0.45,
	0.58
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* H. Peter Anvin (hpa@zytor.com) wrote:
> Mathieu Desnoyers wrote:
>> I can't argue about the benefit of using VM CPU pinning to manage
>> resources because I don't use it myself, but I ran some tests out of
>> curiosity to find if uncontended locks were that cheap, and it turns out
>> they aren't. Here are the results :
>> Xeon 2.0GHz
>> Summary
>> make -j1 kernel/      33.94 +/- 0.07         34.91 +/- 0.27      2.8 %
>> hackbench 50           2.99 +/- 0.01          3.74 +/- 0.01     25.1 %
>> 1 CPU, replace smp lock prefixes with DS segment selector prefixes
>> 1 CPU, noreplace-smp
>
> For reference, could you also compare replace smp lock with NOPs?
>
> 	-hpa

Sure, here are the updated tables. Basically, they show no significant
difference between the NOP and the DS segment selector prefix
approaches.


Xeon 2.0GHz


Summary


* replace smp lock prefixes with DS segment selector prefixes
                  no lock prefix (s)   with lock prefix (s)    Speedup
make -j1 kernel/      33.94 +/- 0.07         34.91 +/- 0.27      2.8 %
hackbench 50           2.99 +/- 0.01          3.74 +/- 0.01     25.1 %


* replace smp lock prefixes with 0x90 nops
                  no lock prefix (s)   with lock prefix (s)    Speedup
make -j1 kernel/      34.16 +/- 0.32         34.91 +/- 0.27      2.2 %
hackbench 50           3.00 +/- 0.01          3.74 +/- 0.01     24.7 %



Detail :


1 CPU, replace smp lock prefixes with DS segment selector prefixes

make -j1 kernel/

real	0m34.067s
user	0m30.630s
sys	0m2.980s

real	0m33.867s
user	0m30.582s
sys	0m3.024s

real	0m33.939s
user	0m30.738s
sys	0m2.876s

real	0m33.913s
user	0m30.806s
sys	0m2.808s

avg : 33.94s
std. dev. : 0.07s

hackbench 50

Time: 2.978
Time: 2.982
Time: 3.010
Time: 2.984
Time: 2.982

avg : 2.99
std. dev. : 0.01



1 CPU, noreplace-smp

make -j1 kernel/

real	0m35.326s
user	0m30.630s
sys	0m3.260s

real	0m34.325s
user	0m30.802s
sys	0m3.084s

real	0m35.568s
user	0m30.722s
sys	0m3.168s

real	0m34.435s
user	0m30.886s
sys	0m2.996s

avg.: 34.91s
std. dev. : 0.27s

hackbench 50

Time: 3.733
Time: 3.750
Time: 3.761
Time: 3.737
Time: 3.741

avg : 3.74
std. dev. : 0.01



1 CPU, replace smp lock prefixes with 0x90 nops

make -j1 kernel/

real	0m34.139s
user	0m30.782s
sys	0m2.820s

real	0m34.010s
user	0m30.630s
sys	0m2.976s

real	0m34.777s
user	0m30.658s
sys	0m2.916s

real	0m33.924s
user	0m30.634s
sys	0m2.924s

real	0m33.962s
user	0m30.774s
sys	0m2.800s

real	0m34.141s
user	0m30.770s
sys	0m2.828s


avg : 34.16
std. dev. : 0.32


hackbench 50

Time: 2.999
Time: 2.994
Time: 3.004
Time: 2.991
Time: 2.988

avg : 3.00
std. dev. : 0.01



-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
