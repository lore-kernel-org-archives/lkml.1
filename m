Return-Path: <linux-kernel-owner+w=401wt.eu-S1758843AbZBFPcQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758843AbZBFPcQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 10:32:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752376AbZBFPb4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 10:31:56 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:38548 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750699AbZBFPbz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 10:31:55 -0500
Date: Fri, 6 Feb 2009 16:31:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mackerras <paulus@samba.org>
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf_counter: Prevent oopses from per-cpu software
	counters
Message-ID: <20090206153138.GM18368@elte.hu>
References: <18826.28805.120988.303819@drongo.ozlabs.ibm.com> <20090205142229.GB28443@elte.hu> <18827.48582.613391.869829@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18827.48582.613391.869829@cargo.ozlabs.ibm.com>
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


* Paul Mackerras <paulus@samba.org> wrote:

> Ingo Molnar writes:
> 
> > So how about fixing these sw counts to properly work as percpu counters too? 
> 
> OK, so for page faults it looks like I want to look at
> 
> 	get_cpu_var(vm_event_states).event[PGFAULT]
> 
> to get the per-cpu page fault count, as long as
> CONFIG_VM_EVENT_COUNTERS is set.

Yeah - i'd suggest that. Note hat VM_EVENT_COUNTERS is default enabled on 
99.99% of kernels:

 config VM_EVENT_COUNTERS
        default y
        bool "Enable VM event counters for /proc/vmstat" if EMBEDDED

> It looks like the scheduler doesn't keep per-cpu counts of context 
> switches or task migrations, or if it does I couldn't find them.  We could 
> do stuff in perf_counter_task_sched_in/out to implement per-cpu context 
> switch and migration counters by adding up the delta values for each task 
> that gets scheduled onto the cpu.  Or we could add explicit per-cpu 
> counters for these things in the scheduler.
> 
> What do you think?

For per-cpu counts of context switches we already have rq->nr_switches. 

We dont have per-cpu counts of migrations - but could add them.

We should do it this way becaue it would be nice to make per-cpu counters 
work just fine even if they are never switched in and out during context 
switches. That turns per-cpu counters into even lower-overhead ways of 
monitoring those values.

	Ingo
