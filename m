Return-Path: <linux-kernel-owner+w=401wt.eu-S1752625AbYKQNgs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752625AbYKQNgs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 08:36:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752294AbYKQNgf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 08:36:35 -0500
Received: from mx2.redhat.com ([66.187.237.31]:46052 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752169AbYKQNge (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 08:36:34 -0500
Date: Mon, 17 Nov 2008 15:36:23 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Frank Mayhar <fmayhar@google.com>, Peter Zijlstra <peterz@infradead.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Doug Chapman <doug.chapman@hp.com>, mingo@elte.hu, adobriyan@gmail.com,
       akpm@linux-foundation.org, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: regression introduced by - timers: fix itimer/many thread hang
Message-ID: <20081117143623.GA4658@redhat.com>
References: <1225984098.7803.4642.camel@twins> <1226015568.2186.20.camel@bobble.smo.corp.google.com> <1226053744.7803.5851.camel@twins> <1226081448.28191.64.camel@bobble.smo.corp.google.com> <1226089574.31966.85.camel@lappy.programming.kicks-ass.net> <Pine.LNX.4.64.0811100834500.21257@quilx.com> <1226328152.7685.192.camel@twins> <1226340009.19109.17.camel@bobble.smo.corp.google.com> <20081114024239.07CC91541E8@magilla.localdomain> <20081114164155.GA7738@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081114164155.GA7738@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/14, Oleg Nesterov wrote:
>
> Currently I am trying to find the ugly, but simple fixes for 2.6.28.
>
> account_group_user_time(), run_posix_cpu_timers() are simpler to
> fix. Again, I need to actually read the code, but afaics we can
> rely on the fact that the task is current, so we can change the
> code
>
> 	-	if (!->signal)
> 	+	if (->exit_state)
> 			return;

Yes, unless I missed something again, this should work. I'll send
the (simple) patches soon, but I have no idea how to test them.


However, I'm afraid there is another problem. On 32 bit cpus we can't
read "u64 sum_exec_runtime" atomically, and so thread_group_cputime()
can "overestimate" ->sum_exec_runtime by (up to) UINT_MAX if it races
with the thread which updates its per_cpu_ptr(.totals). This for example
means that check_process_timers() can fire the CPUCLOCK_SCHED timers
before time.

No?

Oleg.

