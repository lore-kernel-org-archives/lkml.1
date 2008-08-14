Return-Path: <linux-kernel-owner+w=401wt.eu-S1756394AbYHNPXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756394AbYHNPXT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 11:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752491AbYHNPXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 11:23:09 -0400
Received: from tomts25.bellnexxia.net ([209.226.175.188]:61230 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752237AbYHNPXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 11:23:08 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AswEAFzoo0hMRKxB/2dsb2JhbACBYrRQgVU
Date: Thu, 14 Aug 2008 11:18:05 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
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
Message-ID: <20080814151805.GA29507@Krystal>
References: <alpine.LFD.1.10.0808131119290.3462@nehalem.linux-foundation.org> <20080813184142.GM1366@one.firstfloor.org> <20080813193011.GC15547@Krystal> <20080813193715.GQ1366@one.firstfloor.org> <20080813200119.GA18966@Krystal> <20080813234156.GA25775@Krystal> <48A375E3.9090609@zytor.com> <48A388CE.2020404@goop.org> <20080814014944.GA31883@Krystal> <48A3A806.8060509@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <48A3A806.8060509@goop.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 11:14:30 up 70 days, 19:54,  6 users,  load average: 0.98, 0.74,
	0.60
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jeremy Fitzhardinge (jeremy@goop.org) wrote:
> Mathieu Desnoyers wrote:
>> A virtualized guest kernel could use that to limit its use of the
>> overall machine CPU resources in different time periods. Policies can
>> determine how many physical CPU a virtual machine can be tied to, and
>> that may change depending on e.g. the workload or time of day. Having
>> the ability to efficiently switch to UP for a long period of time seems
>> important in this use-case.
>
> Not very convinced.  Unplugging cpus is a pretty coarse way to control 
> resource use.  There are lots of other mechanisms.  And it's not like an 
> uncontended lock is all that expensive these days...
>
>    J
>

I can't argue about the benefit of using VM CPU pinning to manage
resources because I don't use it myself, but I ran some tests out of
curiosity to find if uncontended locks were that cheap, and it turns out
they aren't. Here are the results :

Xeon 2.0GHz


Summary

                  no lock prefix (s)   with lock prefix (s)    Speedup
make -j1 kernel/      33.94 +/- 0.07         34.91 +/- 0.27      2.8 %
hackbench 50           2.99 +/- 0.01          3.74 +/- 0.01     25.1 %

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

Mathieu


-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
