Return-Path: <linux-kernel-owner+w=401wt.eu-S1758985AbZC1TwG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758985AbZC1TwG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 15:52:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756586AbZC1TuS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 15:50:18 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:38366 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755129AbZC1TuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 15:50:08 -0400
Message-Id: <20090328194930.068036716@chello.nl>
References: <20090328194359.426029037@chello.nl>
User-Agent: quilt/0.46-1
Date: Sat, 28 Mar 2009 20:44:06 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Cc: Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 7/9] perf_counter: make it possible for hw_perf_counter_init to return error codes
Content-Disposition: inline; filename=paulus-perf_counter-make_it_possible_for_hw_perf_counter_init_to_return_error_codes.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Mackerras <paulus@samba.org>

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

Signed-off-by: Paul Mackerras <paulus@samba.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---

 arch/powerpc/kernel/perf_counter.c |   14 +++++++-------
 kernel/perf_counter.c              |   33 +++++++++++++++++++++------------
 2 files changed, 28 insertions(+), 19 deletions(-)

Index: linux-2.6/arch/powerpc/kernel/perf_counter.c
===================================================================
--- linux-2.6.orig/arch/powerpc/kernel/perf_counter.c
+++ linux-2.6/arch/powerpc/kernel/perf_counter.c
@@ -624,13 +624,13 @@ hw_perf_counter_init(struct perf_counter
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
@@ -656,14 +656,14 @@ hw_perf_counter_init(struct perf_counter
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
@@ -687,7 +687,7 @@ hw_perf_counter_init(struct perf_counter
 	counter->destroy = hw_perf_counter_destroy;
 
 	if (err)
-		return NULL;
+		return ERR_PTR(err);
 	return &power_perf_ops;
 }
 
Index: linux-2.6/kernel/perf_counter.c
===================================================================
--- linux-2.6.orig/kernel/perf_counter.c
+++ linux-2.6/kernel/perf_counter.c
@@ -2451,10 +2451,11 @@ perf_counter_alloc(struct perf_counter_h
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
@@ -2504,9 +2505,15 @@ perf_counter_alloc(struct perf_counter_h
 		break;
 	}
 
-	if (!hw_ops) {
+	err = 0;
+	if (!hw_ops)
+		err = -EINVAL;
+	else if (IS_ERR(hw_ops))
+		err = PTR_ERR(hw_ops);
+
+	if (err) {
 		kfree(counter);
-		return NULL;
+		return ERR_PTR(err);
 	}
 done:
 	counter->hw_ops = hw_ops;
@@ -2581,10 +2588,10 @@ SYSCALL_DEFINE5(perf_counter_open,
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
@@ -2656,8 +2663,8 @@ inherit_counter(struct perf_counter *par
 	child_counter = perf_counter_alloc(&parent_counter->hw_event,
 					   parent_counter->cpu, child_ctx,
 					   group_leader, GFP_KERNEL);
-	if (!child_counter)
-		return NULL;
+	if (IS_ERR(child_counter))
+		return child_counter;
 
 	/*
 	 * Link it up in the child's context:
@@ -2708,15 +2715,17 @@ static int inherit_group(struct perf_cou
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

-- 

