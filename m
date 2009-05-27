Return-Path: <linux-kernel-owner+w=401wt.eu-S1758839AbZE0JKO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758839AbZE0JKO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 05:10:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751553AbZE0JKD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 05:10:03 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63659 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750826AbZE0JKC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 05:10:02 -0400
Message-ID: <4A1D038D.40704@cn.fujitsu.com>
Date: Wed, 27 May 2009 17:10:37 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: mingo@elte.hu
CC: LKML <linux-kernel@vger.kernel.org>, kosaki.motohiro@jp.fujitsu.com,
       Zhaolei <zhaolei@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>, fweisbec@gmail.com,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH] ftrace: add tracepoint for xtime
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch can trace current xtime and wall_to_monotonic. Then user can
use ctime() to convert them to wall time which is easier to be understood, 
especially for flight-recorder which need to get trace event from a kernel
dump file. 

Example of ftrace output:
          <idle>-0     [000] 20118.489849: gtod_update_xtime: xtime=1243265589.999999824 wall_to_monotonic=3051713268.744158739
           <...>-4020  [001] 20118.489855: sys_open(filename: bf9e66e0, flags: 98800, mode: bf9e66e0)
           <...>-4020  [001] 20118.489873: sys_open -> 0xffffffec

ctime(1243265590) = date:Mon May 25 11:33:10 2009
So we can realize the task with pid 4020 open a file at
Mon May 25 11:33:10 2009

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 include/trace/events/xtime.h |   38 ++++++++++++++++++++++++++++++++++++++
 kernel/time/ntp.c            |    2 ++
 kernel/time/timekeeping.c    |    5 +++++
 3 files changed, 45 insertions(+), 0 deletions(-)
 create mode 100644 include/trace/events/xtime.h

diff --git a/include/trace/events/xtime.h b/include/trace/events/xtime.h
new file mode 100644
index 0000000..f07bb64
--- /dev/null
+++ b/include/trace/events/xtime.h
@@ -0,0 +1,38 @@
+#if !defined(_TRACE_XTIME_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_XTIME_H
+
+#include <linux/time.h>
+#include <linux/tracepoint.h>
+
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM xtime
+
+TRACE_EVENT(gtod_update_xtime,
+
+	TP_PROTO(struct timespec *xtime, struct timespec *wall_to_monotonic),
+
+	TP_ARGS(xtime, wall_to_monotonic),
+
+	TP_STRUCT__entry(
+		__field(	long,	xtime_sec		)
+		__field(	long,	xtime_nsec		)
+		__field(	long,	wall_to_monotonic_sec	)
+		__field(	long,	wall_to_monotonic_nsec	)
+	),
+
+	TP_fast_assign(
+		__entry->xtime_sec		= xtime->tv_sec;
+		__entry->xtime_nsec		= xtime->tv_nsec;
+		__entry->wall_to_monotonic_sec	= wall_to_monotonic->tv_sec;
+		__entry->wall_to_monotonic_nsec	= wall_to_monotonic->tv_nsec;
+	),
+
+	TP_printk("xtime=%ld.%09ld wall_to_monotonic=%ld.%09ld",
+		  __entry->xtime_sec, __entry->xtime_nsec,
+		  __entry->wall_to_monotonic_sec, __entry->wall_to_monotonic_nsec)
+);
+
+#endif /* _TRACE_XTIME_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
index 7fc6437..33db762 100644
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -14,6 +14,7 @@
 #include <linux/timex.h>
 #include <linux/time.h>
 #include <linux/mm.h>
+#include <trace/events/xtime.h>
 
 /*
  * NTP timekeeping variables:
@@ -220,6 +221,7 @@ static enum hrtimer_restart ntp_leap_second(struct hrtimer *timer)
 		break;
 	}
 	update_vsyscall(&xtime, clock);
+	trace_gtod_update_xtime(&xtime, &wall_to_monotonic);
 
 	write_sequnlock(&xtime_lock);
 
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index e8c77d9..798f93e 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -19,6 +19,9 @@
 #include <linux/time.h>
 #include <linux/tick.h>
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/xtime.h>
+
 
 /*
  * This read-write spinlock protects us from races in SMP while
@@ -171,6 +174,7 @@ int do_settimeofday(struct timespec *tv)
 	ntp_clear();
 
 	update_vsyscall(&xtime, clock);
+	trace_gtod_update_xtime(&xtime, &wall_to_monotonic);
 
 	write_sequnlock_irqrestore(&xtime_lock, flags);
 
@@ -568,6 +572,7 @@ void update_wall_time(void)
 	/* check to see if there is a new clocksource to use */
 	change_clocksource();
 	update_vsyscall(&xtime, clock);
+	trace_gtod_update_xtime(&xtime, &wall_to_monotonic);
 }
 
 /**
-- 
1.6.1.2

