Return-Path: <linux-kernel-owner+w=401wt.eu-S1755652AbZKTV22@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755652AbZKTV22 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 16:28:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755480AbZKTV21
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 16:28:27 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:34624 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754404AbZKTV20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 16:28:26 -0500
Message-Id: <20091120212508.299508332@chello.nl>
References: <20091120211942.676891948@chello.nl>
User-Agent: quilt/0.46-1
Date: Fri, 20 Nov 2009 22:19:44 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 02/15] perf: optimize some swcounter attr.sample_period==1 paths
Content-Disposition: inline; filename=perf-opt-single.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid the rather expensive perf_swevent_set_period() if we know
we have to sample every single event anyway.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/perf_event.c |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

Index: linux-2.6/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/kernel/perf_event.c
+++ linux-2.6/kernel/perf_event.c
@@ -3759,16 +3759,16 @@ again:
 	return nr;
 }
 
-static void perf_swevent_overflow(struct perf_event *event,
+static void perf_swevent_overflow(struct perf_event *event, u64 overflow,
 				    int nmi, struct perf_sample_data *data,
 				    struct pt_regs *regs)
 {
 	struct hw_perf_event *hwc = &event->hw;
 	int throttle = 0;
-	u64 overflow;
 
 	data->period = event->hw.last_period;
-	overflow = perf_swevent_set_period(event);
+	if (!overflow)
+		overflow = perf_swevent_set_period(event);
 
 	if (hwc->interrupts == MAX_INTERRUPTS)
 		return;
@@ -3801,14 +3801,19 @@ static void perf_swevent_add(struct perf
 
 	atomic64_add(nr, &event->count);
 
+	if (!regs)
+		return;
+
 	if (!hwc->sample_period)
 		return;
 
-	if (!regs)
+	if (nr == 1 && hwc->sample_period == 1 && !event->attr.freq)
+		return perf_swevent_overflow(event, 1, nmi, data, regs);
+
+	if (atomic64_add_negative(nr, &hwc->period_left))
 		return;
 
-	if (!atomic64_add_negative(nr, &hwc->period_left))
-		perf_swevent_overflow(event, nmi, data, regs);
+	perf_swevent_overflow(event, 0, nmi, data, regs);
 }
 
 static int perf_swevent_is_counting(struct perf_event *event)

-- 

