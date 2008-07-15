Return-Path: <linux-kernel-owner+w=401wt.eu-S1759182AbYGOVAc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759182AbYGOVAc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 17:00:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753320AbYGOVAY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 17:00:24 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58850 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751290AbYGOVAX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 17:00:23 -0400
Date: Tue, 15 Jul 2008 23:00:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, Mike Travis <travis@sgi.com>
Subject: Re: [git pull] core/percpu for v2.6.27
Message-ID: <20080715210002.GA7072@elte.hu>
References: <20080714143413.GA19134@elte.hu> <alpine.LFD.1.10.0807141525000.2944@woody.linux-foundation.org> <487CC671.3000501@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <487CC671.3000501@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Linus Torvalds wrote:
>> Can you explain what this does and who needs it? The percpu_xchg() 
>> looks particularly pointless, since it's always a locked SMP-safe 
>> instruction on x86, so a nonpreemptible load+store will likely be much 
>> faster.
>
> The essence of those changes is to work towards unifying the i386 and 
> x86-64 percpu mechanisms.  But I wasn't terribly convinced by some of 
> the frills around the edges, like the xchg operation.  The work is 
> being driven by Mike Travis and the huge numa people, so perhaps they 
> have a use for it.

yeah. It all centers around the '4096 CPUs' topic which has so wide 
impact that it had to be scattered out a bit.

x86_percpu_xchg():

seems like a sensible extension of the API family to me. Linus is right 
about the LOCK overhead but i'm not all that sure that LOCKed 
instructions will always be slower. Combined with single-pointer per-cpu 
(not the PDA-based redirection we do now) it can be done safely without 
disabling preemption - and that would make the basic percpu ops usable 
in preemptible code.

But indeed there are no very strong reasons.

These are the currently pending related topics:

 # tip/cpus4096 - ready for upstream, i'll send the pull request once
 #                core/rcu is upstream

 earth4:~/tip> git-log-line linus..cpus4096
 9982fbf: Revert "cpumask: introduce new APIs"
 68083e0: Merge commit 'v2.6.26-rc9' into cpus4096
 7baac8b: cpumask: make for_each_cpu_mask a bit smaller
 3f9b48a: net: Pass reference to cpumask variable in net/sunrpc/svc.c
 cad0e45: clocksource/events: use performance variant for_each_cpu_mask_nr
 5d7bfd0: infiniband: use performance variant for_each_cpu_mask_nr
 334ef7a: x86: use performance variant for_each_cpu_mask_nr
 0e12f84: net: use performance variant for_each_cpu_mask_nr
 6d6a436: mm: use performance variant for_each_cpu_mask_nr
 363ab6f: core: use performance variant for_each_cpu_mask_nr
 068b127: cpufreq: use performance variant for_each_cpu_mask_nr
 141ad06: acpi: use performance variant for_each_cpu_mask_nr
 41df0d61: x86: Add performance variants of cpumask operators
 143aa5c: cpu: change some globals to statics in drivers/base/cpu.c v2
 a953e45: sched: replace MAX_NUMNODES with nr_node_ids in kernel/sched.c

 # tip/core/percpu-zerobased: stalled - current approach is
 #                            fragile to binutils bugs

 earth4:~/tip> git-log-line linus..core/percpu-zerobased
 a6d5d88: x86, 64-bit: replace xxx_pda() operations with x86_xxx_percpu().
 6b17441: x86, 64-bit: replace cpu_pda ops with percpu ops
 6aa952c: x86, 64-bit: reference zero-based percpu variables offset from gs
 8c76b15: x86, 64-bit: fold pda into per cpu area
 673698e: x86, 64-bit: fix early references to cpumask_of_cpu

in hindsight core/percpu indeed looks unfinished and direction-less 
without core/percpu-zerobased - but the latter is not stable yet.

	Ingo
