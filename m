Return-Path: <linux-kernel-owner+w=401wt.eu-S1756028AbZKTV2e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756028AbZKTV2e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 16:28:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755067AbZKTV2b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 16:28:31 -0500
Received: from casper.infradead.org ([85.118.1.10]:48330 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755258AbZKTV21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 16:28:27 -0500
Message-Id: <20091120212508.222339539@chello.nl>
References: <20091120211942.676891948@chello.nl>
User-Agent: quilt/0.46-1
Date: Fri, 20 Nov 2009 22:19:43 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 01/15] perf: allow for custom overflow handlers
Content-Disposition: inline; filename=perf-overflow.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

in-kernel perf users might wish to have custom actions on the sample
interrupt.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/perf_event.h |    6 ++++++
 kernel/perf_event.c        |    8 +++++++-
 2 files changed, 13 insertions(+), 1 deletion(-)

Index: linux-2.6/include/linux/perf_event.h
===================================================================
--- linux-2.6.orig/include/linux/perf_event.h
+++ linux-2.6/include/linux/perf_event.h
@@ -567,6 +567,8 @@ struct perf_pending_entry {
 
 typedef void (*perf_callback_t)(struct perf_event *, void *);
 
+struct perf_sample_data;
+
 /**
  * struct perf_event - performance event kernel representation:
  */
@@ -658,6 +660,10 @@ struct perf_event {
 	struct pid_namespace		*ns;
 	u64				id;
 
+	void (*overflow_handler)(struct perf_event *event,
+			int nmi, struct perf_sample_data *data,
+			struct pt_regs *regs);
+
 #ifdef CONFIG_EVENT_PROFILE
 	struct event_filter		*filter;
 #endif
Index: linux-2.6/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/kernel/perf_event.c
+++ linux-2.6/kernel/perf_event.c
@@ -3710,7 +3710,11 @@ static int __perf_event_overflow(struct 
 			perf_event_disable(event);
 	}
 
-	perf_event_output(event, nmi, data, regs);
+	if (event->overflow_handler)
+		event->overflow_handler(event, nmi, data, regs);
+	else
+		perf_event_output(event, nmi, data, regs);
+
 	return ret;
 }
 
@@ -4836,6 +4840,8 @@ inherit_event(struct perf_event *parent_
 	if (parent_event->attr.freq)
 		child_event->hw.sample_period = parent_event->hw.sample_period;
 
+	child_event->overflow_handler = parent_event->overflow_handler;
+
 	/*
 	 * Link it up in the child's context:
 	 */

-- 

