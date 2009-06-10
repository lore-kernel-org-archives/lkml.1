Return-Path: <linux-kernel-owner+w=401wt.eu-S1758731AbZFJFpn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758731AbZFJFpn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 01:45:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753520AbZFJFnA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 01:43:00 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:45689 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755144AbZFJFmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 01:42:53 -0400
Message-Id: <20090610054254.856179852@goodmis.org>
References: <20090610054206.510574695@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 10 Jun 2009 01:42:16 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>, Mel Gorman <mel@csn.ul.ie>,
       Christoph Hellwig <hch@infradead.org>, Rik van Riel <riel@redhat.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jason Baron <jbaron@redhat.com>, Jiaying Zhang <jiayingz@google.com>,
       Tom Zanussi <tzanussi@gmail.com>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Subject: [PATCH 10/11] tracing: update sample code with new tag format
Content-Disposition: inline; filename=0010-tracing-update-sample-code-with-new-tag-format.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

This patch adds examples of all the new tags in the
samples/trace_events/ example code.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 samples/trace_events/trace-events-sample.c |   21 ++++++++-
 samples/trace_events/trace-events-sample.h |   66 ++++++++++++++++++++++++++++
 2 files changed, 85 insertions(+), 2 deletions(-)

diff --git a/samples/trace_events/trace-events-sample.c b/samples/trace_events/trace-events-sample.c
index aabc4e9..dea8eb3 100644
--- a/samples/trace_events/trace-events-sample.c
+++ b/samples/trace_events/trace-events-sample.c
@@ -10,12 +10,31 @@
 #define CREATE_TRACE_POINTS
 #include "trace-events-sample.h"
 
+static struct task_struct *simple_tsk;
 
 static void simple_thread_func(int cnt)
 {
+	static int mask;
+	static int myif;
+
 	set_current_state(TASK_INTERRUPTIBLE);
 	schedule_timeout(HZ);
 	trace_foo_bar("hello", cnt);
+	trace_format_examples(jiffies,
+			      jiffies * 2,
+			      "a string here",
+			      &simple_tsk,
+			      mask, mask, simple_thread_func,
+			      myif, myif, cpu_clock(raw_smp_processor_id()),
+			      123456);
+	if (!myif)
+		myif = 3;
+
+	if (!mask)
+		mask = 5;
+
+	mask <<= mask;
+	myif <<= myif;
 }
 
 static int simple_thread(void *arg)
@@ -28,8 +47,6 @@ static int simple_thread(void *arg)
 	return 0;
 }
 
-static struct task_struct *simple_tsk;
-
 static int __init trace_event_init(void)
 {
 	simple_tsk = kthread_run(simple_thread, NULL, "event-sample");
diff --git a/samples/trace_events/trace-events-sample.h b/samples/trace_events/trace-events-sample.h
index 128a897..08b4768 100644
--- a/samples/trace_events/trace-events-sample.h
+++ b/samples/trace_events/trace-events-sample.h
@@ -65,6 +65,11 @@
  * Note, that for both the assign and the printk, __entry is the handler
  * to the data structure in the ring buffer, and is defined by the
  * TP_STRUCT__entry.
+ *
+ * Note it is better to now use the tag format. Examples are in the event
+ * below, and the explanation of the tag format language is in:
+ *
+ *  kernel/trace/trace_read_binary.h
  */
 TRACE_EVENT(foo_bar,
 
@@ -84,6 +89,67 @@ TRACE_EVENT(foo_bar,
 
 	TP_printk("foo %s %d", __entry->foo, __entry->bar)
 );
+
+/*
+ * These are a few examples of the tag format to do the output.
+ */
+TRACE_EVENT(format_examples,
+
+	TP_PROTO(int myint, long mylong, char *mystr, void *myptr,
+		 unsigned long mask, unsigned sym, void *func,
+		 int myif, int myifmask, unsigned long long nsec,
+		 int dev),
+
+	TP_ARGS(myint, mylong, mystr, myptr, mask, sym, func,
+		myif, myifmask, nsec, dev),
+
+	TP_STRUCT__entry(
+		__field(	int,		myint		)
+		__field(	long,		mylong		)
+		__string(str, mystr)
+		__array(	char,		str_arr,	20	)
+		__field(	void *,		func		)
+		__field(	int,		myif		)
+		__field(	unsigned long,	mask		)
+		__field(	unsigned long,	sym		)
+		__field(	int,		myifmask	)
+		__field(	int,		dev		)
+		__field(	unsigned long long, nsec	)
+	),
+
+	TP_fast_assign(
+		__entry->myint = myint;
+		__entry->mylong = mylong;
+		__assign_str(str, mystr);
+		strncpy(__entry->str_arr, mystr, 19);
+		__entry->str_arr[19] = 0;
+		__entry->mask	= mask;
+		__entry->sym	= sym;
+		__entry->func	= func;
+		__entry->myif	= myif;
+		__entry->myifmask = myifmask;
+		__entry->dev	= dev;
+		__entry->nsec	= nsec;
+	),
+
+	TP_FORMAT("to see a normal int <int:myint> \n"
+		  "or perhaps make it unsigned <uint:myint>\n"
+		  "no difference for the size <int:mylong>\n"
+		  "lets make it into a hex <hex:myint>\n"
+		  "dynamic strings are simple <string:str>\n"
+		  "and so are static ones <strarray:str_arr>\n"
+		  "see a func and offset <symfunc:func>\n"
+		  "or just the func name <func:func>\n"
+		  "should we print <if:myif:this:that>\n"
+		  "or base it on a bit mask <ifmask:myif:0xc:foo:bar>\n"
+		  "we want to see that device <major:dev>,<minor:dev>\n"
+		  "we can see masks <mask:mask:,:0=nothing,0xa=a,1=one,2=two>\n"
+		  "or values of symbols <sym:sym:1=this,2=that,3=nevermind>\n"
+		  "and know what time it is in seconds <nsec2sec:6:nsec> \n"
+		  "millisecs <nsec2msec:6:nsec>\n"
+		  "or microsecs <nsec2usec:3:nsec>")
+);
+
 #endif
 
 /***** NOTICE! The #if protection ends here. *****/
-- 
1.6.3.1

-- 
