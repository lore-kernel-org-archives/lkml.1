Return-Path: <linux-kernel-owner+w=401wt.eu-S1752580AbZL2FXQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752580AbZL2FXQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 00:23:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752548AbZL2FXM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 00:23:12 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:49158 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751601AbZL2FXJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 00:23:09 -0500
Message-ID: <4B3991CD.6070504@cn.fujitsu.com>
Date: Tue, 29 Dec 2009 13:21:17 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, Paul Mackerras <paulus@samba.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 2/5] trace_event: record task' real_timer in itimer_state
 tracepoint
References: <4B27702F.1080507@cn.fujitsu.com> <20091215142325.GC5833@nowhere> <4B30C2D1.4030006@cn.fujitsu.com> <4B30C3A0.909@cn.fujitsu.com> <20091228075417.GB20039@elte.hu>
In-Reply-To: <20091228075417.GB20039@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When itimer is ITIMER_REAL, we should cooperate with hrtimer's
tracepoit to get it's latency, this patch can let us get itimer's
hrtimer easy

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 include/trace/events/timer.h |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/include/trace/events/timer.h b/include/trace/events/timer.h
index 9496b96..13ec15a 100644
--- a/include/trace/events/timer.h
+++ b/include/trace/events/timer.h
@@ -285,6 +285,7 @@ TRACE_EVENT(itimer_state,
 
 	TP_STRUCT__entry(
 		__field(	int,		which		)
+		__field(	void *,		timer		)
 		__field(	cputime_t,	expires		)
 		__field(	long,		value_sec	)
 		__field(	long,		value_usec	)
@@ -294,6 +295,8 @@ TRACE_EVENT(itimer_state,
 
 	TP_fast_assign(
 		__entry->which		= which;
+		__entry->timer          = which == ITIMER_REAL ?
+					  &current->signal->real_timer : NULL;
 		__entry->expires	= expires;
 		__entry->value_sec	= value->it_value.tv_sec;
 		__entry->value_usec	= value->it_value.tv_usec;
@@ -301,8 +304,9 @@ TRACE_EVENT(itimer_state,
 		__entry->interval_usec	= value->it_interval.tv_usec;
 	),
 
-	TP_printk("which=%d expires=%llu it_value=%ld.%ld it_interval=%ld.%ld",
-		  __entry->which, (unsigned long long)__entry->expires,
+	TP_printk("which=%d timer=%p expires=%llu it_value=%ld.%ld it_interval="
+		  "%ld.%ld", __entry->which, __entry->timer,
+		  (unsigned long long)__entry->expires,
 		  __entry->value_sec, __entry->value_usec,
 		  __entry->interval_sec, __entry->interval_usec)
 );
-- 
1.6.1.2


