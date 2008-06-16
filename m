Return-Path: <linux-kernel-owner+w=401wt.eu-S1755334AbYFPSoj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755334AbYFPSoj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 14:44:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752380AbYFPSob
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 14:44:31 -0400
Received: from sinclair.provo.novell.com ([137.65.248.137]:39794 "EHLO
	sinclair.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752037AbYFPSoa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 14:44:30 -0400
Message-Id: <48567C55.BA47.005A.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Mon, 16 Jun 2008 12:44:37 -0600
From: "Gregory Haskins" <ghaskins@novell.com>
To: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
Cc: "Peter Zijlstra" <a.p.zijlstra@chello.nl>, "Ingo Molnar" <mingo@elte.hu>,
       "Steven Rostedt" <rostedt@goodmis.org>,
       "Thomas Gleixner" <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>
Subject: Re: [sched-devel, patch-rfc] rework of "prioritize
	non-migratable tasks over migratable ones"
References: <1213138710.26530.51.camel@earth>
 <1213174382.31518.69.camel@twins>
 <b647ffbd0806110305p2be38608iadc1d2e91e3be57a@mail.gmail.com>
 <48563FDB.BA47.005A.0@novell.com>
 <b647ffbd0806161059q7048ea40id0f4235ab19d6ca0@mail.gmail.com>
In-Reply-To: <b647ffbd0806161059q7048ea40id0f4235ab19d6ca0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On Mon, Jun 16, 2008 at  1:59 PM, in message
<b647ffbd0806161059q7048ea40id0f4235ab19d6ca0@mail.gmail.com>, "Dmitry
Adamushko" <dmitry.adamushko@gmail.com> wrote: 

[snip]

> that's why I called the current (mine is similar)
> definition/implementation of "bound" (or "non-migratable" in my terms
> above) sub-optimal.
> 
> hope it's clear now (and none of the important details are escaping me) :-)

Indeed.  I understand your point now.  To summarize: nr_cpus_allowed is not sufficient to determine if this "load-balancing" operation should be attempted.  Rather, we need to consider whether task_4->cpus_allowed results in no preemption when looking at [1,3], but task_3->cpus_allowed shows the cpu_4 could be preempted.

This problem is easily and efficiently solvable,  and I think your "HEAD" approach is better than my xqueue/squeue idea.  Now the question remains: "Is the whole concept worth it, or should we drop it?"

If we wanted to fix this, we could run both current and the wakee into cpupri for the case where wakee->prio == rq->highest_prio (*).  If wakee comes back with 0 targets but rq->HEAD (*) comes back with potential targets, then wakee should insert to the HEAD and preempt.  Otherwise, tail-insert as always.  (We will still race against the potential targets becoming unavailable to accept current, but as I indicated in the last message, this is unavoidable).

(*) Note that its important to use rq->highest_prio/HEAD and not rq->current so that we don't look at the state of the queue while in the process of rescheduling

Thanks for clarifying, Dmitry.  I think you are right.

Regards,
-Greg

