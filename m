Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933422Ab0BPWDK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 17:03:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7440 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933316Ab0BPWDG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 17:03:06 -0500
From: Don Zickus <dzickus@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Don Zickus <dzickus@redhat.com>, mingo@elte.hu, peterz@infradead.org,
       gorcunov@gmail.com, aris@redhat.com, paulus@samba.org
Subject: [PATCH 2/2] nmi_watchdog: properly configure for software events
Date: Tue, 16 Feb 2010 17:02:25 -0500
Message-Id: <1266357745-26671-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Mackerras brought up a good point that when fallbacking to
software events, I may have been lucky in my configuration.

Modified the code to explicit provide a new configuration for
software events.

Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 kernel/nmi_watchdog.c |   23 ++++++++++++++++++-----
 1 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/kernel/nmi_watchdog.c b/kernel/nmi_watchdog.c
index 633b230..3c75cbf 100644
--- a/kernel/nmi_watchdog.c
+++ b/kernel/nmi_watchdog.c
@@ -61,7 +61,7 @@ static int __init setup_nmi_watchdog(char *str)
 }
 __setup("nmi_watchdog=", setup_nmi_watchdog);
 
-struct perf_event_attr wd_attr = {
+struct perf_event_attr wd_hw_attr = {
 	.type = PERF_TYPE_HARDWARE,
 	.config = PERF_COUNT_HW_CPU_CYCLES,
 	.size = sizeof(struct perf_event_attr),
@@ -69,6 +69,14 @@ struct perf_event_attr wd_attr = {
 	.disabled = 1,
 };
 
+struct perf_event_attr wd_sw_attr = {
+	.type = PERF_TYPE_SOFTWARE,
+	.config = PERF_COUNT_SW_CPU_CLOCK,
+	.size = sizeof(struct perf_event_attr),
+	.pinned = 1,
+	.disabled = 1,
+};
+
 void wd_overflow(struct perf_event *event, int nmi,
 		 struct perf_sample_data *data,
 		 struct pt_regs *regs)
@@ -105,6 +113,7 @@ void wd_overflow(struct perf_event *event, int nmi,
 static int enable_nmi_watchdog(int cpu)
 {
 	struct perf_event *event;
+	struct perf_event_attr *wd_attr;
 
 	event = per_cpu(nmi_watchdog_ev, cpu);
 	if (event && event->state > PERF_EVENT_STATE_OFF)
@@ -112,11 +121,15 @@ static int enable_nmi_watchdog(int cpu)
 
 	if (event == NULL) {
 		/* Try to register using hardware perf events first */
-		wd_attr.sample_period = hw_nmi_get_sample_period();
-		event = perf_event_create_kernel_counter(&wd_attr, cpu, -1, wd_overflow);
+		wd_attr = &wd_hw_attr;
+		wd_attr->sample_period = hw_nmi_get_sample_period();
+		event = perf_event_create_kernel_counter(wd_attr, cpu, -1, wd_overflow);
 		if (IS_ERR(event)) {
-			wd_attr.type = PERF_TYPE_SOFTWARE;
-			event = perf_event_create_kernel_counter(&wd_attr, cpu, -1, wd_overflow);
+			/* hardware doesn't exist or not supported, fallback to software events */
+			printk("nmi_watchdog: hardware not available, trying software events\n");
+			wd_attr = &wd_sw_attr;
+			wd_attr->sample_period = NSEC_PER_SEC;
+			event = perf_event_create_kernel_counter(wd_attr, cpu, -1, wd_overflow);
 			if (IS_ERR(event)) {
 				printk(KERN_ERR "nmi watchdog failed to create perf event on %i: %p\n", cpu, event);
 				return -1;
-- 
1.6.6.83.gc9a2

