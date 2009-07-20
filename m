Return-Path: <linux-kernel-owner+w=401wt.eu-S1753585AbZGTTQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753585AbZGTTQR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 15:16:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751629AbZGTTQQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 15:16:16 -0400
Received: from casper.infradead.org ([85.118.1.10]:43887 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219AbZGTTQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 15:16:16 -0400
Subject: Re: [PATCH] sched: Provide iowait counters
From: Peter Zijlstra <peterz@infradead.org>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       "Kok, Auke-jan H" <auke-jan.h.kok@intel.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
In-Reply-To: <4A64B813.1080506@linux.intel.com>
References: <4A64B813.1080506@linux.intel.com>
Content-Type: text/plain
Date: Mon, 20 Jul 2009 21:16:09 +0200
Message-Id: <1248117369.23509.33.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-07-20 at 11:31 -0700, Arjan van de Ven wrote:
> From cb80fe74bab69449c828d7433fbbea807816eee8 Mon Sep 17 00:00:00 2001
> From: Arjan van de Ven <arjan@linux.intel.com>
> Date: Mon, 20 Jul 2009 11:26:58 -0700
> Subject: [PATCH] sched: Provide iowait counters
> 
> For counting how long an application has been waiting for (disk) IO,
> there currently is only the HZ sample driven information available, while
> for all other counters in this class, a high resolution version is
> available via CONFIG_SCHEDSTATS.
> 
> In order to make an improved bootchart tool possible, we also need
> a higher resolution version of the iowait time.
> 
> This patch below adds this scheduler statistic to the kernel.
> 
> Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>

Seems sane enough, I'll pick her up. Thanks!

> +++ b/kernel/sched_fair.c
> @@ -633,6 +633,11 @@ static void enqueue_sleeper(struct cfs_rq *cfs_rq, struct sched_entity *se)
>   		se->block_start = 0;
>   		se->sum_sleep_runtime += delta;
> 
> +		if (tsk->in_iowait) {
> +			se->iowait_sum += delta;
> +			se->iowait_count++;
> +		}
> +
>   		/*
>   		 * Blocking time is in units of nanosecs, so shift by 20 to
>   		 * get a milliseconds-range estimation of the amount of

It might be nice to put a tracepoint there as well, now if there was a
way to specify perf counter attributes in the TRACE_EVENT() magic so
that we can feed stuff into perf_tpcounter_event().

TP_perf_addr()  -- defaults to 0 when not specified
TP_perf_count() -- defaults to 1 when not specified.

Steve, Frederic, is there any way to make that happen?

Failing that we could put an actual swcounter in there I suppose.

That way we could profile applications based on IO-wait, which would be
cool.


