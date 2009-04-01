Return-Path: <linux-kernel-owner+w=401wt.eu-S1759181AbZDAKQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759181AbZDAKQT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 06:16:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756928AbZDAKOb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 06:14:31 -0400
Received: from hera.kernel.org ([140.211.167.34]:40019 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754145AbZDAKO2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 06:14:28 -0400
Date: Wed, 1 Apr 2009 10:13:46 GMT
From: Paul Mackerras <paulus@samba.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090330171023.682428180@chello.nl>
References: <20090330171023.682428180@chello.nl>
Subject: [tip:perfcounters/core] perf_counter: make it possible for hw_perf_counter_init to return error codes
Message-ID: <tip-a9ac421ff0a0893671eb4fe2f6a6a1d7dc847dd3@git.kernel.org>
Git-Commit-ID: a9ac421ff0a0893671eb4fe2f6a6a1d7dc847dd3
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 01 Apr 2009 10:13:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a9ac421ff0a0893671eb4fe2f6a6a1d7dc847dd3
Gitweb:     http://git.kernel.org/tip/a9ac421ff0a0893671eb4fe2f6a6a1d7dc847dd3
Author:     Paul Mackerras <paulus@samba.org>
AuthorDate: Mon, 30 Mar 2009 19:07:08 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 1 Apr 2009 11:33:35 +0200

perf_counter: make it possible for hw_perf_counter_init to return error codes

Impact: better error reporting

At present, if hw_perf_counter_init encounters an error, all it can do
is return NULL, which causes sys_perf_counter_open to return an EINVAL
error to userspace.  This isn't very informative for userspace; it means
that userspace can't tell the difference between "sorry, oprofile is
already using the PMU" and "we don't support this CPU" and "this CPU
doesn't support the requested generic hardware event".

This commit uses the PTR_ERR/ERR_PTR/IS_ERR set of macros to let
hw_perf_counter_init return an error code on error rather than just NULL
if it wishes.  If it does so, that error code will be returned from
sys_perf_counter_open to userspace.  If it returns NULL, an EINVAL
error will be returned to userspace, as before.

This also adapts the powerpc hw_perf_counter_init to make use of this
to return ENXIO, EINVAL, EBUSY, or EOPNOTSUPP as appropriate.  It would
be good to add extra error numbers in future to allow userspace to
distinguish the various errors that are currently reported as EINVAL,
i.e. irq_period < 0, too many events in a group, conflict between
exclude_* settings in a group, and PMU resource conflict in a group.

[ v2: fix a bug pointed out by Corey Ashford where error returns from
      hw_perf_counter_init were not handled correctly in the case of
      raw hardware events.]

Signed-off-by: Paul Mackerras <paulus@samba.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20090330171023.682428180@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/powerpc/kernel/perf_counter.c |   14 +++++++-------
 kernel/perf_counter.c              |   35 ++++++++++++++++++++++-------------
 2 files changed, 29 insertions(+), 20 deletions(-)

diff --git a/arch/powerpc/kernel/perf_counter.c b/arch/powerpc/kernel/perf_counter.c
index 560dd1e..0a4d14f 100644
--- a/arch/powerpc/kernel/perf_counter.c
+++ b/arch/powerpc/kernel/perf_counter.c
@@ -624,13 +624,13 @@ hw_perf_counter_init(struct perf_counter *counter)
 	int err;
 
 	if (!ppmu)
-		return NULL;
+		return ERR_PTR(-ENXIO);
 	if ((s64)counter->hw_event.irq_period < 0)
-		return NULL;
+		return ERR_PTR(-EINVAL);
 	if (!perf_event_raw(&counter->hw_event)) {
 		ev = perf_event_id(&counter->hw_event);
 		if (ev >= ppmu->n_generic || ppmu->generic_events[ev] == 0)
-			return NULL;
+			return ERR_PTR(-EOPNOTSUPP);
 		ev = ppmu->generic_events[ev];
 	} else {
 		ev = perf_event_config(&counter->hw_event);
@@ -656,14 +656,14 @@ hw_perf_counter_init(struct perf_counter *counter)
 		n = collect_events(counter->group_leader, ppmu->n_counter - 1,
 				   ctrs, events);
 		if (n < 0)
-			return NULL;
+			return ERR_PTR(-EINVAL);
 	}
 	events[n] = ev;
 	ctrs[n] = counter;
 	if (check_excludes(ctrs, n, 1))
-		return NULL;
+		return ERR_PTR(-EINVAL);
 	if (power_check_constraints(events, n + 1))
-		return NULL;
+		return ERR_PTR(-EINVAL);
 
 	counter->hw.config = events[n];
 	atomic64_set(&counter->hw.period_left, counter->hw_event.irq_period);
@@ -687,7 +687,7 @@ hw_perf_counter_init(struct perf_counter *counter)
 	counter->destroy = hw_perf_counter_destroy;
 
 	if (err)
-		return NULL;
+		return ERR_PTR(err);
 	return &power_perf_ops;
 }
 
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index f35e89e..d07b452 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -2453,10 +2453,11 @@ perf_counter_alloc(struct perf_counter_hw_event *hw_event,
 {
 	const struct hw_perf_counter_ops *hw_ops;
 	struct perf_counter *counter;
+	long err;
 
 	counter = kzalloc(sizeof(*counter), gfpflags);
 	if (!counter)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	/*
 	 * Single counters are their own group leaders, with an
@@ -2505,12 +2506,18 @@ perf_counter_alloc(struct perf_counter_hw_event *hw_event,
 		hw_ops = tp_perf_counter_init(counter);
 		break;
 	}
+done:
+	err = 0;
+	if (!hw_ops)
+		err = -EINVAL;
+	else if (IS_ERR(hw_ops))
+		err = PTR_ERR(hw_ops);
 
-	if (!hw_ops) {
+	if (err) {
 		kfree(counter);
-		return NULL;
+		return ERR_PTR(err);
 	}
-done:
+
 	counter->hw_ops = hw_ops;
 
 	return counter;
@@ -2583,10 +2590,10 @@ SYSCALL_DEFINE5(perf_counter_open,
 			goto err_put_context;
 	}
 
-	ret = -EINVAL;
 	counter = perf_counter_alloc(&hw_event, cpu, ctx, group_leader,
 				     GFP_KERNEL);
-	if (!counter)
+	ret = PTR_ERR(counter);
+	if (IS_ERR(counter))
 		goto err_put_context;
 
 	ret = anon_inode_getfd("[perf_counter]", &perf_fops, counter, 0);
@@ -2658,8 +2665,8 @@ inherit_counter(struct perf_counter *parent_counter,
 	child_counter = perf_counter_alloc(&parent_counter->hw_event,
 					   parent_counter->cpu, child_ctx,
 					   group_leader, GFP_KERNEL);
-	if (!child_counter)
-		return NULL;
+	if (IS_ERR(child_counter))
+		return child_counter;
 
 	/*
 	 * Link it up in the child's context:
@@ -2710,15 +2717,17 @@ static int inherit_group(struct perf_counter *parent_counter,
 {
 	struct perf_counter *leader;
 	struct perf_counter *sub;
+	struct perf_counter *child_ctr;
 
 	leader = inherit_counter(parent_counter, parent, parent_ctx,
 				 child, NULL, child_ctx);
-	if (!leader)
-		return -ENOMEM;
+	if (IS_ERR(leader))
+		return PTR_ERR(leader);
 	list_for_each_entry(sub, &parent_counter->sibling_list, list_entry) {
-		if (!inherit_counter(sub, parent, parent_ctx,
-				     child, leader, child_ctx))
-			return -ENOMEM;
+		child_ctr = inherit_counter(sub, parent, parent_ctx,
+					    child, leader, child_ctx);
+		if (IS_ERR(child_ctr))
+			return PTR_ERR(child_ctr);
 	}
 	return 0;
 }
