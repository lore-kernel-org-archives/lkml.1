Return-Path: <linux-kernel-owner+w=401wt.eu-S1756017Ab0A2IEj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756017Ab0A2IEj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 03:04:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751406Ab0A2IEi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 03:04:38 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:34883 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194Ab0A2IEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 03:04:38 -0500
Subject: [PATCH 5/4] perf_events: Fix sample_period transfer on inherit
From: Peter Zijlstra <peterz@infradead.org>
To: mingo@elte.hu
Cc: eranian@google.com, linux-kernel@vger.kernel.org
In-Reply-To: <20100127220745.027096123@chello.nl>
References: <20100127220745.027096123@chello.nl>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 29 Jan 2010 09:04:26 +0100
Message-ID: <1264752266.4283.2121.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: perf_events: Fix sample_period transfer on inherit
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Thu Jan 28 12:34:07 CET 2010

One problem with frequency driven counters is that we cannot predict
the rate at which they trigger, therefore we have to start them at
period=1, this causes a ramp up effect. However, if we fail to
propagate the stable state on fork each new child will have to ramp up
again. This can lead to significant artifacts in sample data.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/perf_event.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

Index: linux-2.6/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/kernel/perf_event.c
+++ linux-2.6/kernel/perf_event.c
@@ -5011,8 +5011,15 @@ inherit_event(struct perf_event *parent_
 	else
 		child_event->state = PERF_EVENT_STATE_OFF;
 
-	if (parent_event->attr.freq)
-		child_event->hw.sample_period = parent_event->hw.sample_period;
+	if (parent_event->attr.freq) {
+		u64 sample_period = parent_event->hw.sample_period;
+		struct hw_perf_event *hwc = &child_event->hw;
+
+		hwc->sample_period = sample_period;
+		hwc->last_period   = sample_period;
+
+		atomic64_set(&hwc->period_left, sample_period);
+	}
 
 	child_event->overflow_handler = parent_event->overflow_handler;


