Return-Path: <linux-kernel-owner+w=401wt.eu-S1751496AbZH1PKv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751496AbZH1PKv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 11:10:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751618AbZH1PKu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 11:10:50 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:54016 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489AbZH1PKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 11:10:50 -0400
Subject: [PATCH] perf_counter: fix possible /0 bug in swcounters
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 28 Aug 2009 17:10:47 +0200
Message-Id: <1251472247.17617.74.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have a race in the swcounter stuff where we can start counting a
counter that has never been enabled, this leads to a /0 situation.

The below avoids the /0 but doesn't close the race, this would need a
new counter state.

The race is due to perf_swcounter_is_counting() which cannot discern
between disabled due to scheduled out, and disabled for any other
reason.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/perf_counter.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 53abcbe..2b90d26 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -4103,6 +4103,7 @@ perf_counter_alloc(struct perf_counter_attr *attr,
 	hwc->sample_period = attr->sample_period;
 	if (attr->freq && attr->sample_freq)
 		hwc->sample_period = 1;
+	hwc->last_period = hwc->sample_period;
 
 	atomic64_set(&hwc->period_left, hwc->sample_period);
 


