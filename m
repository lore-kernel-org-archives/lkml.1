Return-Path: <linux-kernel-owner+w=401wt.eu-S1762983AbXKTSbw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762983AbXKTSbw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 13:31:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760364AbXKTS0v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 13:26:51 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:51878 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757497AbXKTS0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 13:26:48 -0500
Date: Tue, 20 Nov 2007 10:24:25 -0800
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Ingo Molnar <mingo@elte.hu>
Subject: [patch 15/29] Fix divide-by-zero in the 2.6.23 scheduler code
Message-ID: <20071120182425.GQ28611@kroah.com>
References: <20071120181733.702234406@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fix-divide-by-zero-in-the-2.6.23-scheduler-code.patch"
In-Reply-To: <20071120182248.GA28611@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.23-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Chuck Ebbert <cebbert@redhat.com>

No patch in mainline as this logic has been removed from 2.6.24 so it is
not necessary.


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

For stable only; the code has been removed in 2.6.24.

Signed-off-by: Chuck Ebbert <cebbert@redhat.com>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/sched_fair.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -93,7 +93,7 @@ unsigned int sysctl_sched_features __rea
 		SCHED_FEAT_FAIR_SLEEPERS	*1 |
 		SCHED_FEAT_SLEEPER_AVG		*0 |
 		SCHED_FEAT_SLEEPER_LOAD_AVG	*1 |
-		SCHED_FEAT_PRECISE_CPU_LOAD	*1 |
+		SCHED_FEAT_PRECISE_CPU_LOAD	*0 |
 		SCHED_FEAT_START_DEBIT		*1 |
 		SCHED_FEAT_SKIP_INITIAL		*0;
 

-- 
