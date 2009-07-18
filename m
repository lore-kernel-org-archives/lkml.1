Return-Path: <linux-kernel-owner+w=401wt.eu-S1753701AbZGRJcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753701AbZGRJcR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 05:32:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751445AbZGRJcO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 05:32:14 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40373 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751346AbZGRJcN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 05:32:13 -0400
Date: Sat, 18 Jul 2009 11:31:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: Dominik Brodowski <linux@brodo.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][RFC] Adding transition of CPU frequency counting
	support to perfcounters
Message-ID: <20090718093115.GB9142@elte.hu>
References: <20090716.110834.886429911292889318.mitake@dcl.info.waseda.ac.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090716.110834.886429911292889318.mitake@dcl.info.waseda.ac.jp>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0005]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp> wrote:

> Hi,
> 
> I'm trying to add transition of CPU frequency counting support to perfcounters.
> If perf can count freq transition, this will be more useful
> because frequencies of CPUs are dynamic things today.
> And there's no way to count freq transitions per process level.
> 
> But I have a question.
> I copied the way of sw-events already exist such as migration or page-fault.
> But like this,
> 
> % perf stat emacs
> 
>  Performance counter stats for 'emacs':
> 
>     1324.294227  task-clock-msecs         #      0.704 CPUs
>            1980  context-switches         #      0.001 M/sec
>              30  CPU-migrations           #      0.000 M/sec
>           42986  page-faults              #      0.032 M/sec
>               0  cpufreq-up               #      0.000 M/sec
>                  ^^^^^^^^^^
>               0  cpufreq-down             #      0.000 M/sec
>                  ^^^^^^^^^^^^      
>      4057387374  cycles                   #   3063.811 M/sec
>      4767004447  instructions             #      1.175 IPC
>        20687483  cache-references         #     15.622 M/sec
>         5103528  cache-misses             #      3.854 M/sec
> 
>     1.880587959  seconds time elapsed
> 
> perf said there's no freq transition.
> But I checked there are some transitions with cpufreq-info.
> 
> Can you find something bad in this patch?
> I'll continue to try implementing.
> If you find some bad points, I'd like to hear..

> +		if (freqs->new > freqs->old)
> +			perf_swcounter_event(PERF_COUNT_SW_CPUFREQ_UP,
> +					     1, 0, NULL, 0);
> +		else
> +			perf_swcounter_event(PERF_COUNT_SW_CPUFREQ_DOWN,
> +					     1, 0, NULL, 0);

Could you try:

	perf stat -a sleep 60

while you do your emacs run that toggles cpufreq events? This makes 
sure all transitions are counted, regardless of which context 
triggers it. Do you still get zero counts this way?

	Ingo
