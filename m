Return-Path: <linux-kernel-owner+w=401wt.eu-S1754746AbYKQSRu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746AbYKQSRu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 13:17:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752927AbYKQSRl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 13:17:41 -0500
Received: from mx1.redhat.com ([66.187.233.31]:60412 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751589AbYKQSRk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 13:17:40 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Frank Mayhar <fmayhar@google.com>, Peter Zijlstra <peterz@infradead.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Doug Chapman <doug.chapman@hp.com>, mingo@elte.hu, adobriyan@gmail.com,
       akpm@linux-foundation.org, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: regression introduced by - timers: fix itimer/many thread hang
In-Reply-To: Oleg Nesterov's message of  Monday, 17 November 2008 15:36:23 +0100 <20081117143623.GA4658@redhat.com>
References: <1225984098.7803.4642.camel@twins>
	<1226015568.2186.20.camel@bobble.smo.corp.google.com>
	<1226053744.7803.5851.camel@twins>
	<1226081448.28191.64.camel@bobble.smo.corp.google.com>
	<1226089574.31966.85.camel@lappy.programming.kicks-ass.net>
	<Pine.LNX.4.64.0811100834500.21257@quilx.com>
	<1226328152.7685.192.camel@twins>
	<1226340009.19109.17.camel@bobble.smo.corp.google.com>
	<20081114024239.07CC91541E8@magilla.localdomain>
	<20081114164155.GA7738@redhat.com>
	<20081117143623.GA4658@redhat.com>
X-Shopping-List: (1) Televised protrusion mountains
   (2) Maternity deep-fried snore confessions
   (3) Pleasant odious helmet circumcisions
Message-Id: <20081117181655.8BDE9154221@magilla.localdomain>
Date: Mon, 17 Nov 2008 10:16:55 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > 	-	if (!->signal)
> > 	+	if (->exit_state)
> > 			return;
> 
> Yes, unless I missed something again, this should work. I'll send
> the (simple) patches soon, but I have no idea how to test them.

That certainly will exclude the problem of crashing in the tick interrupt
after exit_notify.  Unfortunately, it's moving in an undesireable direction
for the long run.  That is, it loses from the accounting even more of the
CPU time spent on the exit path.

> However, I'm afraid there is another problem. On 32 bit cpus we can't
> read "u64 sum_exec_runtime" atomically, and so thread_group_cputime()
> can "overestimate" ->sum_exec_runtime by (up to) UINT_MAX if it races
> with the thread which updates its per_cpu_ptr(.totals). This for example
> means that check_process_timers() can fire the CPUCLOCK_SCHED timers
> before time.
> 
> No?

Yes, I think you're right.  The best solution that comes to mind off hand
is to protect the update/read of that u64 with a seqcount_t on 32-bit.


Thanks,
Roland
