Return-Path: <linux-kernel-owner+w=401wt.eu-S1760859AbZC0DZz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760859AbZC0DZz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 23:25:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760001AbZC0DZa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 23:25:30 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:53377 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759886AbZC0DZ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 23:25:28 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18892.18156.806827.727965@drongo.ozlabs.ibm.com>
Date: Fri, 27 Mar 2009 14:24:28 +1100
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] perf_counter: make it possible for hw_perf_counter_init to return error codes
X-Mailer: VM 8.0.12 under 22.2.1 (powerpc-unknown-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
This commit, along with the "perf_counter: powerpc: only reserve PMU
hardware when we need it" patch that I posted yesterday, and the
following patch, are in the master branch of my perfcounters.git
repository at:

 git://git.kernel.org/pub/scm/linux/kernel/git/paulus/perfcounters.git master

 arch/powerpc/kernel/perf_counter.c |   14 +++++++-------
 kernel/perf_counter.c              |   33 +++++++++++++++++++++------------
 2 files changed, 28 insertions(+), 19 deletions(-)

diff --git a/arch/powerpc/kernel/perf_counter.c b/arch/powerpc/kernel/perf_counter.c
index 1efd252..3ac2a2d 100644
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
index 3b862a7..f416a4d 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -2187,10 +2187,11 @@ perf_counter_alloc(struct perf_counter_hw_event *hw_event,
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
@@ -2241,9 +2242,15 @@ perf_counter_alloc(struct perf_counter_hw_event *hw_event,
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
@@ -2318,10 +2325,10 @@ SYSCALL_DEFINE5(perf_counter_open,
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
@@ -2393,8 +2400,8 @@ inherit_counter(struct perf_counter *parent_counter,
 	child_counter = perf_counter_alloc(&parent_counter->hw_event,
 					   parent_counter->cpu, child_ctx,
 					   group_leader, GFP_KERNEL);
-	if (!child_counter)
-		return NULL;
+	if (IS_ERR(child_counter))
+		return child_counter;
 
 	/*
 	 * Link it up in the child's context:
@@ -2445,15 +2452,17 @@ static int inherit_group(struct perf_counter *parent_counter,
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
1.5.5.rc3.7.gba13

