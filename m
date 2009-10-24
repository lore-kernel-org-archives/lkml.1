Return-Path: <linux-kernel-owner+w=401wt.eu-S1753833AbZJXORY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753833AbZJXORY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Oct 2009 10:17:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753825AbZJXORX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Oct 2009 10:17:23 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:62185 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753806AbZJXORU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Oct 2009 10:17:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=GMs9ELHak5v6e/u6YQBl4CXF9SyfZsxe2hidrz0VbnoRb+fzYpFH9GHeD3ZY93CdmF
         xqe3CKKFv7lBQ7lALZOK4PiRW0k0F5RFnUoiG8SmKxetfucfLsZPcBT9Um+aJt++dev+
         MU+NoBg0674e0tYV/sldvV+a/0UqgsKZaVdI4=
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
Date: Sat, 24 Oct 2009 16:16:55 +0200
Message-Id: <1256393818-8921-4-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1256393818-8921-1-git-send-email-fweisbec@gmail.com>
References: <1256393818-8921-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A simple callback in a perf event can be used for multiple purposes.
For example it is useful for triggered based events like hardware
breakpoints that need a callback to dispatch a triggered breakpoint
event.

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
 kernel/perf_event.c        |   18 ++++++++++++++----
 2 files changed, 20 insertions(+), 5 deletions(-)

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
index 1fc69d8..34866d0 100644
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
@@ -4335,6 +4336,15 @@ perf_event_alloc(struct perf_event_attr *attr,
 
 	event->state		= PERF_EVENT_STATE_INACTIVE;
 
+	if (!callback) {
+		if (parent_event)
+			event->callback = parent_event->callback;
+		else
+			event->callback = NULL;
+	} else {
+		event->callback		= callback;
+	}
+
 	if (attr->disabled)
 		event->state = PERF_EVENT_STATE_OFF;
 
@@ -4611,7 +4621,7 @@ SYSCALL_DEFINE5(perf_event_open,
 	}
 
 	event = perf_event_alloc(&attr, cpu, ctx, group_leader,
-				     NULL, GFP_KERNEL);
+				     NULL, NULL, GFP_KERNEL);
 	err = PTR_ERR(event);
 	if (IS_ERR(event))
 		goto err_put_context;
@@ -4665,7 +4675,7 @@ err_put_context:
  */
 struct perf_event *
 perf_event_create_kernel_counter(struct perf_event_attr *attr, int cpu,
-				 pid_t pid)
+				 pid_t pid, perf_callback_t callback)
 {
 	struct perf_event *event;
 	struct perf_event_context *ctx;
@@ -4680,7 +4690,7 @@ perf_event_create_kernel_counter(struct perf_event_attr *attr, int cpu,
 		return NULL ;
 
 	event = perf_event_alloc(attr, cpu, ctx, NULL,
-				     NULL, GFP_KERNEL);
+				     NULL, callback, GFP_KERNEL);
 	err = PTR_ERR(event);
 	if (IS_ERR(event))
 		goto err_put_context;
@@ -4733,7 +4743,7 @@ inherit_event(struct perf_event *parent_event,
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

