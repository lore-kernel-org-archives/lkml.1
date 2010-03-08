Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755234Ab0CHSgI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 13:36:08 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:50598 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754729Ab0CHSf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 13:35:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=NzjELsTa5ClIO87P7rjsc4gx3rG2jak+ouGuxegAOI0Dsz7weD64VOVMMxqbrOHsbr
         9/EA8j3/Ui2HaSG6J0VIM+f8yrmYxbzcjhTOoTkZJ1pF2VJzs6bueDbiB3ajItWTPIzM
         tB++hMlHsopRt8bXy3rCxhb93m62oX9/pxhz4=
Date: Mon, 8 Mar 2010 19:35:50 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Paul Mackerras <paulus@samba.org>, Steven Rostedt <rostedt@goodmis.org>,
       Masami Hiramatsu <mhiramat@redhat.com>, Jason Baron <jbaron@redhat.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [RFC PATCH] perf: Store relevant events in a hlist
Message-ID: <20100308183545.GA5038@nowhere>
References: <1267772426-5944-1-git-send-regression-fweisbec@gmail.com> <1267772426-5944-2-git-send-regression-fweisbec@gmail.com> <1267781969.16716.55.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267781969.16716.55.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 05, 2010 at 10:39:29AM +0100, Peter Zijlstra wrote:
> On Fri, 2010-03-05 at 08:00 +0100, Frederic Weisbecker wrote:
> > Each time a trace event triggers, we walk through the entire
> > list of events from the active contexts to find the perf events
> > that match the current one.
> > 
> > This is wasteful. To solve this, we maintain a per cpu list of
> > the active perf events for each running trace events and we
> > directly commit to these.
> 
> Right, so this seems a little trace specific. I once thought about using
> a hash table to do this for all software events. It also keeps it all
> nicely inside perf_event.[ch].


What do you think about this version?
It builds but crashes on runtime and doesn't handle
cpu hotplug yet. Before spending more time in debugging/fixing,
I'd like to know your opinion about the general architecture.

Thanks.

---
>From c389b296a87bd38cfd28da3124508eb1e5a5d553 Mon Sep 17 00:00:00 2001
From: Frederic Weisbecker <fweisbec@gmail.com>
Date: Mon, 8 Mar 2010 19:04:02 +0100
Subject: [PATCH] perf: Store relevant events in a hlist

When a software/tracepoint event triggers, we walk through the
entire current cpu and task context's events lists to retrieve
those that are concerned.

This is wasteful. This patch proposes a hashlist to walk through
the relevant events only. The hash is calculated using the id of
the event (could be further optimized using the type of the event
too). Each hash map a list of distinct type:id that match the hash.
To these type:id nodes, we affect a list of the active events
matching the type:id.

-----------------------
Hash 1 | Hash 2 | ....
----------------------
  |
 swevent type:id node
  |       |
  |       ------- event 1 ---- event 2 ---- ....
  |
 swevent type:id node
          |
          --------[...]

The hashlist is per cpu (attached to perf_cpu_context) and the
events in the lists gather those that are active in the cpu and
task context. No more per events checks are needed to guess if
the events are "counting" or "matching".

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 include/linux/perf_event.h |   12 ++
 kernel/perf_event.c        |  294 ++++++++++++++++++++++++++++++++++---------
 2 files changed, 244 insertions(+), 62 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index c859bee..bdd9794 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -578,6 +578,7 @@ struct perf_event {
 	struct list_head		group_entry;
 	struct list_head		event_entry;
 	struct list_head		sibling_list;
+	struct list_head		swevent_list;
 	int				nr_siblings;
 	int				group_flags;
 	struct perf_event		*group_leader;
@@ -716,6 +717,14 @@ struct perf_event_context {
 	struct rcu_head			rcu_head;
 };
 
+#define PERF_SW_HLIST_BITS	10		/* 1024 entries */
+#define PERF_SW_HLIST_SIZE	1 << PERF_SW_HLIST_BITS
+
+struct swevents_hlist {
+	struct rcu_head			rcu_head;
+	struct hlist_head		hlist[PERF_SW_HLIST_SIZE];
+};
+
 /**
  * struct perf_event_cpu_context - per cpu event context structure
  */
@@ -732,6 +741,9 @@ struct perf_cpu_context {
 	 * task, softirq, irq, nmi context
 	 */
 	int				recursion[4];
+	struct swevents_hlist		*swevents_hlist;
+	struct mutex			hlist_mutex;
+	struct kref			hlist_refcount;
 };
 
 struct perf_output_handle {
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index a97c1b1..50dabea 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -15,6 +15,7 @@
 #include <linux/smp.h>
 #include <linux/file.h>
 #include <linux/poll.h>
+#include <linux/hash.h>
 #include <linux/sysfs.h>
 #include <linux/dcache.h>
 #include <linux/percpu.h>
@@ -3972,34 +3973,210 @@ static void perf_swevent_add(struct perf_event *event, u64 nr,
 	perf_swevent_overflow(event, 0, nmi, data, regs);
 }
 
-static int perf_swevent_is_counting(struct perf_event *event)
+struct swevent_node {
+	enum perf_type_id	type;
+	__u64			id;
+	struct hlist_node	node;
+	struct list_head	events;
+	struct kref		refcount;
+	struct rcu_head		rcu_head;
+};
+
+static __u64 sw_event_hash(enum perf_type_id type, __u64 id)
 {
-	/*
-	 * The event is active, we're good!
-	 */
-	if (event->state == PERF_EVENT_STATE_ACTIVE)
-		return 1;
+	return hash_64(id, PERF_SW_HLIST_BITS);
+}
 
-	/*
-	 * The event is off/error, not counting.
-	 */
-	if (event->state != PERF_EVENT_STATE_INACTIVE)
-		return 0;
+static struct swevent_node *
+__search_swevent_node(__u64 hash, enum perf_type_id type, __u64 id,
+		      struct perf_cpu_context *cpuctx)
+{
+	struct swevent_node *sw_node;
+	struct hlist_node *node;
+	struct hlist_head *head;
 
-	/*
-	 * The event is inactive, if the context is active
-	 * we're part of a group that didn't make it on the 'pmu',
-	 * not counting.
-	 */
-	if (event->ctx->is_active)
-		return 0;
+	head = &cpuctx->swevents_hlist->hlist[hash];
 
-	/*
-	 * We're inactive and the context is too, this means the
-	 * task is scheduled out, we're counting events that happen
-	 * to us, like migration events.
-	 */
-	return 1;
+	hlist_for_each_entry_rcu(sw_node, node, head, node) {
+		if (type == sw_node->type && id == sw_node->id)
+			return sw_node;
+	}
+
+	return NULL;
+}
+
+static struct swevent_node *
+search_swevent_node(enum perf_type_id type, __u64 id,
+		    struct perf_cpu_context *cpuctx)
+{
+	__u64 hash = sw_event_hash(type, id);
+
+	return __search_swevent_node(hash, type, id, cpuctx);
+}
+
+static int search_add_swevent_node(enum perf_type_id type, __u64 id,
+				   struct perf_cpu_context *cpuctx)
+{
+	__u64 hash = sw_event_hash(type, id);
+	struct swevent_node *sw_node;
+
+	sw_node = __search_swevent_node(hash, type, id, cpuctx);
+	if (sw_node)
+		goto done;
+
+	sw_node = kmalloc(sizeof(*sw_node), GFP_KERNEL);
+	if (!sw_node)
+		return -ENOMEM;
+
+	sw_node->type = type;
+	sw_node->id = id;
+	kref_init(&sw_node->refcount);
+	hlist_add_head_rcu(&sw_node->node, &cpuctx->swevents_hlist->hlist[hash]);
+
+ done:
+	kref_get(&sw_node->refcount);
+
+	return 0;
+}
+
+static void release_swevent_hlist_rcu(struct rcu_head *rcu_head)
+{
+	struct swevents_hlist *hlist;
+
+	hlist = container_of(rcu_head, struct swevents_hlist, rcu_head);
+	kfree(hlist);
+}
+
+static void release_swevent_hlist(struct kref *kref)
+{
+	struct perf_cpu_context *cpuctx;
+	struct swevents_hlist *hlist;
+
+	cpuctx = container_of(kref, struct perf_cpu_context, hlist_refcount);
+	hlist = cpuctx->swevents_hlist;
+	rcu_assign_pointer(cpuctx->swevents_hlist, NULL);
+	call_rcu(&hlist->rcu_head, release_swevent_hlist_rcu);
+}
+
+static int add_swevent_hlist_cpu(struct perf_event *event,
+				 struct perf_cpu_context *cpuctx)
+{
+	int err = 0;
+	struct swevents_hlist *hlist;
+
+	mutex_lock(&cpuctx->hlist_mutex);
+
+	if (!cpuctx->swevents_hlist) {
+		hlist = kzalloc(sizeof(cpuctx->swevents_hlist), GFP_KERNEL);
+		if (!hlist) {
+			err = -ENOMEM;
+			goto end;
+		}
+		rcu_assign_pointer(cpuctx->swevents_hlist, hlist);
+	}
+
+	kref_get(&cpuctx->hlist_refcount);
+
+	err = search_add_swevent_node(event->attr.type, event->attr.config,
+				      cpuctx);
+	if (err)
+		kref_put(&cpuctx->hlist_refcount, release_swevent_hlist);
+end:
+	mutex_unlock(&cpuctx->hlist_mutex);
+
+	return err;
+}
+
+static void release_swevent_node_rcu(struct rcu_head *rcu_head)
+{
+	struct swevent_node *sw_node;
+
+	sw_node = container_of(rcu_head, struct swevent_node, rcu_head);
+	kfree(sw_node);
+}
+
+static void release_swevent_node(struct kref *kref)
+{
+	struct swevent_node *sw_node;
+
+	sw_node = container_of(kref, struct swevent_node, refcount);
+	hlist_del_rcu(&sw_node->node);
+	call_rcu(&sw_node->rcu_head, release_swevent_node_rcu);
+}
+
+static void remove_swevent_hlist_cpu(struct perf_event *event,
+				    struct perf_cpu_context *cpuctx)
+{
+	struct swevent_node *sw_node;
+
+	mutex_lock(&cpuctx->hlist_mutex);
+
+	if (WARN_ON_ONCE(!cpuctx->swevents_hlist))
+		goto end;
+
+	sw_node = search_swevent_node(event->attr.type, event->attr.config,
+				      cpuctx);
+	if (WARN_ON_ONCE(!sw_node))
+		goto end;
+
+	kref_put(&sw_node->refcount, release_swevent_node);
+	kref_put(&cpuctx->hlist_refcount, release_swevent_hlist);
+end:
+	mutex_unlock(&cpuctx->hlist_mutex);
+}
+
+static int add_swevent_hlist(struct perf_event *event)
+{
+	int cpu, fail_cpu;
+	int err;
+	struct perf_cpu_context *cpuctx;
+
+	get_online_cpus();
+
+	if (event->cpu == -1) {
+		for_each_online_cpu(cpu) {
+			cpuctx = &per_cpu(perf_cpu_context, cpu);
+			err = add_swevent_hlist_cpu(event, cpuctx);
+			if (err) {
+				fail_cpu = cpu;
+				goto fail;
+			}
+		}
+	} else {
+		cpu = event->cpu;
+		cpuctx = &per_cpu(perf_cpu_context, cpu);
+		err = add_swevent_hlist_cpu(event, cpuctx);
+		goto end;
+	}
+
+fail:
+	for_each_online_cpu(cpu) {
+		if (cpu == fail_cpu)
+			break;
+		cpuctx = &per_cpu(perf_cpu_context, cpu);
+		remove_swevent_hlist_cpu(event, cpuctx);
+	}
+end:
+	put_online_cpus();
+
+	return err;
+}
+
+static void remove_swevent_hlist(struct perf_event *event)
+{
+	int cpu;
+	struct perf_cpu_context *cpuctx;
+
+	if (event->cpu == -1) {
+		for_each_online_cpu(cpu) {
+			cpuctx = &per_cpu(perf_cpu_context, cpu);
+			remove_swevent_hlist_cpu(event, cpuctx);
+		}
+	} else {
+		cpu = event->cpu;
+		cpuctx = &per_cpu(perf_cpu_context, cpu);
+		remove_swevent_hlist_cpu(event, cpuctx);
+	}
 }
 
 static int perf_tp_event_match(struct perf_event *event,
@@ -4020,23 +4197,9 @@ static int perf_exclude_event(struct perf_event *event,
 }
 
 static int perf_swevent_match(struct perf_event *event,
-				enum perf_type_id type,
-				u32 event_id,
 				struct perf_sample_data *data,
 				struct pt_regs *regs)
 {
-	if (event->cpu != -1 && event->cpu != smp_processor_id())
-		return 0;
-
-	if (!perf_swevent_is_counting(event))
-		return 0;
-
-	if (event->attr.type != type)
-		return 0;
-
-	if (event->attr.config != event_id)
-		return 0;
-
 	if (perf_exclude_event(event, regs))
 		return 0;
 
@@ -4047,20 +4210,6 @@ static int perf_swevent_match(struct perf_event *event,
 	return 1;
 }
 
-static void perf_swevent_ctx_event(struct perf_event_context *ctx,
-				     enum perf_type_id type,
-				     u32 event_id, u64 nr, int nmi,
-				     struct perf_sample_data *data,
-				     struct pt_regs *regs)
-{
-	struct perf_event *event;
-
-	list_for_each_entry_rcu(event, &ctx->event_list, event_entry) {
-		if (perf_swevent_match(event, type, event_id, data, regs))
-			perf_swevent_add(event, nr, nmi, data, regs);
-	}
-}
-
 int perf_swevent_get_recursion_context(void)
 {
 	struct perf_cpu_context *cpuctx = &get_cpu_var(perf_cpu_context);
@@ -4102,19 +4251,20 @@ static void do_perf_sw_event(enum perf_type_id type, u32 event_id,
 				    struct pt_regs *regs)
 {
 	struct perf_cpu_context *cpuctx;
-	struct perf_event_context *ctx;
+	struct swevent_node *node;
+	struct perf_event *event;
 
 	cpuctx = &__get_cpu_var(perf_cpu_context);
+
 	rcu_read_lock();
-	perf_swevent_ctx_event(&cpuctx->ctx, type, event_id,
-				 nr, nmi, data, regs);
-	/*
-	 * doesn't really matter which of the child contexts the
-	 * events ends up in.
-	 */
-	ctx = rcu_dereference(current->perf_event_ctxp);
-	if (ctx)
-		perf_swevent_ctx_event(ctx, type, event_id, nr, nmi, data, regs);
+	node = search_swevent_node(type, event_id, cpuctx);
+	if (!node)
+		goto end;
+	list_for_each_entry(event, &node->events, swevent_list) {
+		if (perf_swevent_match(event, data, regs))
+			perf_swevent_add(event, nr, nmi, data, regs);
+	}
+end:
 	rcu_read_unlock();
 }
 
@@ -4143,16 +4293,28 @@ static void perf_swevent_read(struct perf_event *event)
 static int perf_swevent_enable(struct perf_event *event)
 {
 	struct hw_perf_event *hwc = &event->hw;
+	struct perf_cpu_context *cpuctx;
+	struct swevent_node *node;
 
 	if (hwc->sample_period) {
 		hwc->last_period = hwc->sample_period;
 		perf_swevent_set_period(event);
 	}
+
+	cpuctx = &__get_cpu_var(perf_cpu_context);
+
+	node = search_swevent_node(event->attr.type, event->attr.config, cpuctx);
+	if (WARN_ON_ONCE(!node))
+		return -EINVAL;
+
+	list_add_tail(&event->swevent_list, &node->events);
+
 	return 0;
 }
 
 static void perf_swevent_disable(struct perf_event *event)
 {
+	list_del(&event->swevent_list);
 }
 
 static const struct pmu perf_ops_generic = {
@@ -4489,10 +4651,13 @@ static void sw_perf_event_destroy(struct perf_event *event)
 	WARN_ON(event->parent);
 
 	atomic_dec(&perf_swevent_enabled[event_id]);
+
+	remove_swevent_hlist(event);
 }
 
 static const struct pmu *sw_perf_event_init(struct perf_event *event)
 {
+	int err;
 	const struct pmu *pmu = NULL;
 	u64 event_id = event->attr.config;
 
@@ -4531,6 +4696,9 @@ static const struct pmu *sw_perf_event_init(struct perf_event *event)
 			event->destroy = sw_perf_event_destroy;
 		}
 		pmu = &perf_ops_generic;
+		err = add_swevent_hlist(event);
+		if (err)
+			return ERR_PTR(err);
 		break;
 	}
 
@@ -5397,6 +5565,8 @@ static void __cpuinit perf_event_init_cpu(int cpu)
 	struct perf_cpu_context *cpuctx;
 
 	cpuctx = &per_cpu(perf_cpu_context, cpu);
+	mutex_init(&cpuctx->hlist_mutex);
+	kref_init(&cpuctx->hlist_refcount);
 	__perf_event_init_context(&cpuctx->ctx, NULL);
 
 	spin_lock(&perf_resource_lock);
-- 
1.6.2.3



