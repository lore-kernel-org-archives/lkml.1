Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757219Ab0BQMLw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 07:11:52 -0500
Received: from hera.kernel.org ([140.211.167.34]:56345 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756666Ab0BQMLu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 07:11:50 -0500
Date: Wed, 17 Feb 2010 12:11:05 GMT
From: tip-bot for Don Zickus <dzickus@redhat.com>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu,
       dzickus@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu,
       dzickus@redhat.com
In-Reply-To: <1266357745-26671-1-git-send-email-dzickus@redhat.com>
References: <1266357745-26671-1-git-send-email-dzickus@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/nmi] nmi_watchdog: Properly configure for software events
Message-ID: <tip-96ca4028aca0638d0e11dcbfabc4283054072933@git.kernel.org>
Git-Commit-ID: 96ca4028aca0638d0e11dcbfabc4283054072933
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 17 Feb 2010 12:11:09 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  96ca4028aca0638d0e11dcbfabc4283054072933
Gitweb:     http://git.kernel.org/tip/96ca4028aca0638d0e11dcbfabc4283054072933
Author:     Don Zickus <dzickus@redhat.com>
AuthorDate: Tue, 16 Feb 2010 17:02:25 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 17 Feb 2010 08:16:02 +0100

nmi_watchdog: Properly configure for software events

Paul Mackerras brought up a good point that when fallbacking to
software events, I may have been lucky in my configuration.

Modified the code to explicit provide a new configuration for
software events.

Suggested-by: Paul Mackerras <paulus@samba.org>
Signed-off-by: Don Zickus <dzickus@redhat.com>
Cc: gorcunov@gmail.com
Cc: aris@redhat.com
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <1266357745-26671-1-git-send-email-dzickus@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
