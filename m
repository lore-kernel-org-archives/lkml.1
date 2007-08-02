Return-Path: <linux-kernel-owner+w=401wt.eu-S1754910AbXHBLk3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754910AbXHBLk3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 07:40:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753610AbXHBLkS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 07:40:18 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48887 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753502AbXHBLkQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 07:40:16 -0400
Date: Thu, 2 Aug 2007 13:40:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Martin Roehricht <ml@felicis.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Scheduling the highest priority task
Message-ID: <20070802114012.GA4067@elte.hu>
References: <8KLFD-G9-5@gated-at.bofh.it> <46B19CA1.7050204@felicis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46B19CA1.7050204@felicis.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Martin Roehricht <ml@felicis.org> wrote:

> perhaps someone can give me a hint what I should consider to look for in 
> order to change the ("old" 2.6.21) scheduler such that it schedules the 
> highest priority task of a given runqueue.
> Given a multiprocessor system I currently observe that whenever there 
> are two tasks on one CPU, the lower priority one is migrated to another 
> CPU. But I don't realize why this happens. From looking at the source 
> code I thought it should be the highest priority one (lowest bit set in 
> the runqueue's bitmap) according to
> 	idx = sched_find_first_bit(array->bitmap);
> within move_tasks(). The idx value is then used as an index (surprise) 
> to the linked list of tasks of this particular priority and one task is 
> picked:
> 	head = array->queue + idx;
>         curr = head->prev;
>         tmp = list_entry(curr, struct task_struct, run_list);
> 
> Can anybody confirm that my observations are correct that the 
> scheduler picks the lowest priority job of a runqueue for migration? 
> What needs to be changed in order to pick the highest priority one?

in the SMP migration code, the 'old scheduler' indeed picks the lowest 
priority one, _except_ if that task is running on another CPU or is too 
'cache hot':

        if (skip_for_load ||
            !can_migrate_task(tmp, busiest, this_cpu, sd, idle, &pinned)) {

also, from the priority-queue at 'idx', we pick head->prev, i.e. we 
process the list in the opposite order as schedule(). (This got changed 
in CFS to process in the same direction - which is more logical and also 
yield the most cache-cold tasks for migration.)

i hope this helps.

> Is my assumption wrong? Using printk()s within this code section makes 
> the system just hang completely quite soon. The schedstats do not 
> notify me immediately. So I am a bit lost on how to track down or 
> trace the problem.

yep, printk locks up. You can use my static tracer:

   http://people.redhat.com/mingo/latency-tracing-patches/

add explicit static tracepoints to the scheduler code you want to 
instrument via trace_special(x,y,z) calls [with parameters that interest 
you most], and you can read out the trace via:

   http://people.redhat.com/mingo/latency-tracing-patches/trace-it.c

	Ingo
