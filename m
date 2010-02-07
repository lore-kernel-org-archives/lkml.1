Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755291Ab0BGLbf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 06:31:35 -0500
Received: from mail-ww0-f46.google.com ([74.125.82.46]:44352 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933689Ab0BGLbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 06:31:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=D5r9hKgdi2kf7lAYEpqAg55on3jeLByvHwQ4lL57ki58YQJAjBJT5gZs9GWNqgPyNh
         qNDkLxlMXrTx5zX0SaSYy5nbmjnNKY98X7uom0EXrL5U+5kb5sXdECIdbrqna2GLQf4/
         F6hjrY/CMOuZrIxgU67++fWE2l1D5P8QklupI=
From: highguy@gmail.com
To: mingo@elte.hu, linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, efault@gmx.de, a.p.zijlstra@chello.nl,
       andrea@suse.de, tglx@linutronix.de, akpm@linux-foundation.org,
       peterz@infradead.org, Stijn Devriendt <HIGHGuY@gmail.com>
Subject: [PATCH 5/6] Allow decrementing counters
Date: Sun,  7 Feb 2010 12:30:58 +0100
Message-Id: <1265542259-5596-6-git-send-email-HIGHGuY@gmail.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1265542259-5596-5-git-send-email-HIGHGuY@gmail.com>
References: <1265542259-5596-1-git-send-email-HIGHGuY@gmail.com>
 <1265542259-5596-2-git-send-email-HIGHGuY@gmail.com>
 <1265542259-5596-3-git-send-email-HIGHGuY@gmail.com>
 <1265542259-5596-4-git-send-email-HIGHGuY@gmail.com>
 <1265542259-5596-5-git-send-email-HIGHGuY@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stijn Devriendt <HIGHGuY@gmail.com>

---
 include/linux/perf_event.h |    6 +++---
 kernel/perf_event.c        |   16 ++++++++--------
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 4f7d318..084f322 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -515,7 +515,7 @@ struct pmu {
 	void (*disable)			(struct perf_event *event);
 	void (*update)			(struct perf_event *event);
 	void (*unthrottle)		(struct perf_event *event);
-	u64 (*add)                      (struct perf_event *event, u64 count);
+	u64 (*add)                      (struct perf_event *event, s64 count);
 	int (*reset)                    (struct perf_event *event);
 	void (*wakeup)                  (struct perf_event *event);
 	u64 (*read)                     (struct perf_event *event);
@@ -826,10 +826,10 @@ static inline int is_software_event(struct perf_event *event)
 
 extern atomic_t perf_swevent_enabled[PERF_COUNT_SW_MAX];
 
-extern void __perf_sw_event(u32, u64, int, struct pt_regs *, u64);
+extern void __perf_sw_event(u32, s64, int, struct pt_regs *, u64);
 
 static inline void
-perf_sw_event(u32 event_id, u64 nr, int nmi, struct pt_regs *regs, u64 addr)
+perf_sw_event(u32 event_id, s64 nr, int nmi, struct pt_regs *regs, u64 addr)
 {
 	if (atomic_read(&perf_swevent_enabled[event_id]))
 		__perf_sw_event(event_id, nr, nmi, regs, addr);
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 724aafd..08885d0 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -3770,12 +3770,12 @@ static void perf_event_wakeup_one(struct perf_event *event)
 	wake_up(&event->waitq);
 }
 
-static u64 __perf_event_add(struct perf_event *event, u64 count)
+static u64 __perf_event_add(struct perf_event *event, s64 count)
 {
 	return atomic64_add_return(count, &event->count);
 }
 
-static u64 perf_event_add(struct perf_event *event, u64 count)
+static u64 perf_event_add(struct perf_event *event, s64 count)
 {
 	if (event->pmu->add)
 		return event->pmu->add(event, count);
@@ -3856,7 +3856,7 @@ static void perf_swevent_unthrottle(struct perf_event *event)
 	 */
 }
 
-static void perf_swevent_add(struct perf_event *event, u64 nr,
+static void perf_swevent_add(struct perf_event *event, s64 nr,
 			       int nmi, struct perf_sample_data *data,
 			       struct pt_regs *regs)
 {
@@ -3870,10 +3870,10 @@ static void perf_swevent_add(struct perf_event *event, u64 nr,
 	if (!hwc->sample_period)
 		return;
 
-	if (nr == 1 && hwc->sample_period == 1 && !event->attr.freq)
+	if (abs(nr) == 1 && hwc->sample_period == 1 && !event->attr.freq)
 		return perf_swevent_overflow(event, 1, nmi, data, regs);
 
-	if (atomic64_add_negative(nr, &hwc->period_left))
+	if (atomic64_add_negative(abs(nr), &hwc->period_left))
 		return;
 
 	perf_swevent_overflow(event, 0, nmi, data, regs);
@@ -3956,7 +3956,7 @@ static int perf_swevent_match(struct perf_event *event,
 
 static void perf_swevent_ctx_event(struct perf_event_context *ctx,
 				     enum perf_type_id type,
-				     u32 event_id, u64 nr, int nmi,
+				     u32 event_id, s64 nr, int nmi,
 				     struct perf_sample_data *data,
 				     struct pt_regs *regs)
 {
@@ -4004,7 +4004,7 @@ void perf_swevent_put_recursion_context(int rctx)
 EXPORT_SYMBOL_GPL(perf_swevent_put_recursion_context);
 
 static void do_perf_sw_event(enum perf_type_id type, u32 event_id,
-				    u64 nr, int nmi,
+				    s64 nr, int nmi,
 				    struct perf_sample_data *data,
 				    struct pt_regs *regs)
 {
@@ -4025,7 +4025,7 @@ static void do_perf_sw_event(enum perf_type_id type, u32 event_id,
 	rcu_read_unlock();
 }
 
-void __perf_sw_event(u32 event_id, u64 nr, int nmi,
+void __perf_sw_event(u32 event_id, s64 nr, int nmi,
 			    struct pt_regs *regs, u64 addr)
 {
 	struct perf_sample_data data;
-- 
1.6.6

