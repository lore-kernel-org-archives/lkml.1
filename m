Return-Path: <linux-kernel-owner+w=401wt.eu-S1754928AbZKCTLl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754928AbZKCTLl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 14:11:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754847AbZKCTL0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 14:11:26 -0500
Received: from mail-ew0-f207.google.com ([209.85.219.207]:35814 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754669AbZKCTLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 14:11:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=FNJvDKkT3nhEiiZPS+drMuI8C7S0rr29cxLPSetMRvBRO+U02zrbKE7hN1WvS2/G9B
         1bhWwSA4/at8bAi5NJkUhsIN6CCyX9Vc93fbPDTUpzq2aDQUuunR05QySwgYgsVF0rcR
         K3YkYVOuwogQ7YHvkDT8KCbC7w/RALaSAZgbY=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>,
       Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH 3/6] perf/core: Add a callback to perf events
Date: Tue,  3 Nov 2009 20:11:11 +0100
Message-Id: <1257275474-5285-4-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1257275474-5285-1-git-send-email-fweisbec@gmail.com>
References: <1257275474-5285-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A simple callback in a perf event can be used for multiple purposes.
For example it is useful for triggered based events like hardware
breakpoints that need a callback to dispatch a triggered breakpoint
event.

v2: Simplify a bit the callback attribution as suggested by Paul
    Mackerras

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: "K.Prasad" <prasad@linux.vnet.ibm.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mundt <lethal@linux-sh.org>
---
 include/linux/perf_event.h |    7 ++++++-
 kernel/perf_event.c        |   14 ++++++++++----
 2 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index fa151d4..8d54e6d 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -544,6 +544,8 @@ struct perf_pending_entry {
 	void (*func)(struct perf_pending_entry *);
 };
 
+typedef void (*perf_callback_t)(struct perf_event *, void *);
+
 /**
  * struct perf_event - performance event kernel representation:
  */
@@ -639,6 +641,8 @@ struct perf_event {
 	struct event_filter		*filter;
 #endif
 
+	perf_callback_t			callback;
+
 #endif /* CONFIG_PERF_EVENTS */
 };
 
@@ -748,7 +752,8 @@ extern int perf_event_release_kernel(struct perf_event *event);
 extern struct perf_event *
 perf_event_create_kernel_counter(struct perf_event_attr *attr,
 				int cpu,
-				pid_t pid);
+				pid_t pid,
+				perf_callback_t callback);
 extern u64 perf_event_read_value(struct perf_event *event);
 
 struct perf_sample_data {
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 02d4ff0..5087125 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -4293,6 +4293,7 @@ perf_event_alloc(struct perf_event_attr *attr,
 		   struct perf_event_context *ctx,
 		   struct perf_event *group_leader,
 		   struct perf_event *parent_event,
+		   perf_callback_t callback,
 		   gfp_t gfpflags)
 {
 	const struct pmu *pmu;
@@ -4335,6 +4336,11 @@ perf_event_alloc(struct perf_event_attr *attr,
 
 	event->state		= PERF_EVENT_STATE_INACTIVE;
 
+	if (!callback && parent_event)
+		callback = parent_event->callback;
+	
+	event->callback	= callback;
+
 	if (attr->disabled)
 		event->state = PERF_EVENT_STATE_OFF;
 
@@ -4611,7 +4617,7 @@ SYSCALL_DEFINE5(perf_event_open,
 	}
 
 	event = perf_event_alloc(&attr, cpu, ctx, group_leader,
-				     NULL, GFP_KERNEL);
+				     NULL, NULL, GFP_KERNEL);
 	err = PTR_ERR(event);
 	if (IS_ERR(event))
 		goto err_put_context;
@@ -4668,7 +4674,7 @@ err_put_context:
  */
 struct perf_event *
 perf_event_create_kernel_counter(struct perf_event_attr *attr, int cpu,
-				 pid_t pid)
+				 pid_t pid, perf_callback_t callback)
 {
 	struct perf_event *event;
 	struct perf_event_context *ctx;
@@ -4683,7 +4689,7 @@ perf_event_create_kernel_counter(struct perf_event_attr *attr, int cpu,
 		return NULL ;
 
 	event = perf_event_alloc(attr, cpu, ctx, NULL,
-				     NULL, GFP_KERNEL);
+				     NULL, callback, GFP_KERNEL);
 	err = PTR_ERR(event);
 	if (IS_ERR(event))
 		goto err_put_context;
@@ -4736,7 +4742,7 @@ inherit_event(struct perf_event *parent_event,
 	child_event = perf_event_alloc(&parent_event->attr,
 					   parent_event->cpu, child_ctx,
 					   group_leader, parent_event,
-					   GFP_KERNEL);
+					   NULL, GFP_KERNEL);
 	if (IS_ERR(child_event))
 		return child_event;
 	get_ctx(child_ctx);
-- 
1.6.2.3

