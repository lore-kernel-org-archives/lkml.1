Return-Path: <linux-kernel-owner+w=401wt.eu-S1754930AbZKUNlw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754930AbZKUNlw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 08:41:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755165AbZKUNlt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 08:41:49 -0500
Received: from hera.kernel.org ([140.211.167.34]:60835 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755044AbZKUNlr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 08:41:47 -0500
Date: Sat, 21 Nov 2009 13:41:15 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20091120212508.299508332@chello.nl>
References: <20091120212508.299508332@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Optimize some swcounter attr.sample_period==1 paths
Message-ID: <tip-0cff784ae41cc125368ae77f1c01328ae2fdc6b3@git.kernel.org>
Git-Commit-ID: 0cff784ae41cc125368ae77f1c01328ae2fdc6b3
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0cff784ae41cc125368ae77f1c01328ae2fdc6b3
Gitweb:     http://git.kernel.org/tip/0cff784ae41cc125368ae77f1c01328ae2fdc6b3
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 20 Nov 2009 22:19:44 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 21 Nov 2009 14:11:35 +0100

perf: Optimize some swcounter attr.sample_period==1 paths

Avoid the rather expensive perf_swevent_set_period() if we know
we have to sample every single event anyway.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <20091120212508.299508332@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/perf_event.c |   17 +++++++++++------
 1 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 1dfb6cc..8e55b44 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
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
@@ -3801,14 +3801,19 @@ static void perf_swevent_add(struct perf_event *event, u64 nr,
 
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
