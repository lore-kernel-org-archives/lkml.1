Return-Path: <linux-kernel-owner+w=401wt.eu-S1752225AbYKLFCp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752225AbYKLFCp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 00:02:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750980AbYKLFCW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 00:02:22 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:45136 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830AbYKLFCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 00:02:21 -0500
Message-Id: <20081112050219.202854960@goodmis.org>
References: <20081112050125.654925304@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 12 Nov 2008 00:01:27 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 2/2] ring-buffer: no preempt for sched_clock
Content-Disposition: inline; filename=0002-ring-buffer-no-preempt-for-sched_clock.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: disable preemption no calling sched_clock

The ring_buffer_time_stamp still uses sched_clock as its counter.
But it is a bug to call it with preemption enabled. This requirement
should not be pushed to the ring_buffer_time_stamp callers, so
the ring_buffer_time_stamp needs to disable preemption when calling
sched_clock.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/ring_buffer.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 86dc353..2d6c2cf 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -53,8 +53,14 @@ void tracing_off(void)
 /* FIXME!!! */
 u64 ring_buffer_time_stamp(int cpu)
 {
+	u64 time;
+
+	preempt_disable_notrace();
 	/* shift to debug/test normalization and TIME_EXTENTS */
-	return sched_clock() << DEBUG_SHIFT;
+	time = sched_clock() << DEBUG_SHIFT;
+	preempt_enable_notrace();
+
+	return time;
 }
 
 void ring_buffer_normalize_time_stamp(int cpu, u64 *ts)
-- 
1.5.6.5

-- 
