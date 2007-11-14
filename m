Return-Path: <linux-kernel-owner+w=401wt.eu-S1764135AbXKNBPa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764135AbXKNBPa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 20:15:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759024AbXKNBPT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 20:15:19 -0500
Received: from mx1.redhat.com ([66.187.233.31]:59025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761652AbXKNBPS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 20:15:18 -0500
Message-ID: <473A4C0F.6070504@redhat.com>
Date: Tue, 13 Nov 2007 20:14:55 -0500
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Divide-by-zero in the 2.6.23 scheduler code
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

https://bugzilla.redhat.com/show_bug.cgi?id=340161

The problem code has been removed in 2.6.24. The below patch disables
SCHED_FEAT_PRECISE_CPU_LOAD which causes the offending code to be skipped
but does not prevent the user from enabling it.

The divide-by-zero is here in kernel/sched.c:

static void update_cpu_load(struct rq *this_rq)
{
	u64 fair_delta64, exec_delta64, idle_delta64, sample_interval64, tmp64;
	unsigned long total_load = this_rq->ls.load.weight;
	unsigned long this_load =  total_load;
	struct load_stat *ls = &this_rq->ls;
	int i, scale;

	this_rq->nr_load_updates++;
	if (unlikely(!(sysctl_sched_features & SCHED_FEAT_PRECISE_CPU_LOAD)))
		goto do_avg;

	/* Update delta_fair/delta_exec fields first */
	update_curr_load(this_rq);

	fair_delta64 = ls->delta_fair + 1;
	ls->delta_fair = 0;

	exec_delta64 = ls->delta_exec + 1;
	ls->delta_exec = 0;

	sample_interval64 = this_rq->clock - ls->load_update_last;
	ls->load_update_last = this_rq->clock;

	if ((s64)sample_interval64 < (s64)TICK_NSEC)
		sample_interval64 = TICK_NSEC;

	if (exec_delta64 > sample_interval64)
		exec_delta64 = sample_interval64;

	idle_delta64 = sample_interval64 - exec_delta64;

======>	tmp64 = div64_64(SCHED_LOAD_SCALE * exec_delta64, fair_delta64);
	tmp64 = div64_64(tmp64 * exec_delta64, sample_interval64);

	this_load = (unsigned long)tmp64;

do_avg:

	/* Update our load: */
	for (i = 0, scale = 1; i < CPU_LOAD_IDX_MAX; i++, scale += scale) {
		unsigned long old_load, new_load;

		/* scale is effectively 1 << i now, and >> i divides by scale */

		old_load = this_rq->cpu_load[i];
		new_load = this_load;

		this_rq->cpu_load[i] = (old_load*(scale-1) + new_load) >> i;
	}
}


---
 kernel/sched_fair.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.23.noarch.orig/kernel/sched_fair.c
+++ linux-2.6.23.noarch/kernel/sched_fair.c
@@ -93,7 +93,7 @@ unsigned int sysctl_sched_features __rea
 		SCHED_FEAT_FAIR_SLEEPERS	*1 |
 		SCHED_FEAT_SLEEPER_AVG		*0 |
 		SCHED_FEAT_SLEEPER_LOAD_AVG	*1 |
-		SCHED_FEAT_PRECISE_CPU_LOAD	*1 |
+		SCHED_FEAT_PRECISE_CPU_LOAD	*0 |
 		SCHED_FEAT_START_DEBIT		*1 |
 		SCHED_FEAT_SKIP_INITIAL		*0;
 
