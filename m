Return-Path: <linux-kernel-owner+w=401wt.eu-S1756857Ab0A2Jbm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756857Ab0A2Jbm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 04:31:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756853Ab0A2Jbh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 04:31:37 -0500
Received: from hera.kernel.org ([140.211.167.34]:57592 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756817Ab0A2Jbf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 04:31:35 -0500
Date: Fri, 29 Jan 2010 09:30:56 GMT
From: tip-bot for Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       peterz@infradead.org, fweisbec@gmail.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       peterz@infradead.org, efault@gmx.de, fweisbec@gmail.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1264752266.4283.2121.camel@laptop>
References: <1264752266.4283.2121.camel@laptop>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf_events: Fix sample_period transfer on inherit
Message-ID: <tip-75c9f3284a7ff957829f44baace82406a6354ceb@git.kernel.org>
Git-Commit-ID: 75c9f3284a7ff957829f44baace82406a6354ceb
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 29 Jan 2010 09:30:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  75c9f3284a7ff957829f44baace82406a6354ceb
Gitweb:     http://git.kernel.org/tip/75c9f3284a7ff957829f44baace82406a6354ceb
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Fri, 29 Jan 2010 09:04:26 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 29 Jan 2010 09:15:26 +0100

perf_events: Fix sample_period transfer on inherit

One problem with frequency driven counters is that we cannot
predict the rate at which they trigger, therefore we have to
start them at period=1, this causes a ramp up effect. However,
if we fail to propagate the stable state on fork each new child
will have to ramp up again. This can lead to significant
artifacts in sample data.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: eranian@google.com
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <1264752266.4283.2121.camel@laptop>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/perf_event.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 251fb95..53dc2a3 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -5002,8 +5002,15 @@ inherit_event(struct perf_event *parent_event,
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
 
