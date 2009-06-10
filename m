Return-Path: <linux-kernel-owner+w=401wt.eu-S1761048AbZFJRCv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761048AbZFJRCv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 13:02:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760225AbZFJRAN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 13:00:13 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:52910 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755127AbZFJQ77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 12:59:59 -0400
Message-Id: <20090610170000.766033125@goodmis.org>
References: <20090610165306.794813861@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 10 Jun 2009 12:53:16 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Theodore Tso <tytso@mit.edu>, Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mel@csn.ul.ie>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Subject: [PATCH 10/11] tracing/events: modify lockdep print to new format
Content-Disposition: inline; filename=0010-tracing-events-modify-lockdep-print-to-new-format.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Use new format for better parsing of lockdep events.

The current conversion of the nsec value in the lockstat lock event
is performed in the fast path. Now that there is a tag to do the conversion
we can move this into the slow path and increase performance while tracing.

[ Impact: increase performance in lockstat tracing ]

Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/trace/events/lockdep.h |   18 +++++++-----------
 1 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/include/trace/events/lockdep.h b/include/trace/events/lockdep.h
index 0e956c9..4251f17 100644
--- a/include/trace/events/lockdep.h
+++ b/include/trace/events/lockdep.h
@@ -27,9 +27,8 @@ TRACE_EVENT(lock_acquire,
 		__assign_str(name, lock->name);
 	),
 
-	TP_printk("%s%s%s", (__entry->flags & 1) ? "try " : "",
-		  (__entry->flags & 2) ? "read " : "",
-		  __get_str(name))
+	TP_FORMAT("<ifmask:flags:1:try :><ifmask:flags:2:read :>"
+		  "<string:name>")
 );
 
 TRACE_EVENT(lock_release,
@@ -46,7 +45,7 @@ TRACE_EVENT(lock_release,
 		__assign_str(name, lock->name);
 	),
 
-	TP_printk("%s", __get_str(name))
+	TP_FORMAT("<string:name>")
 );
 
 #ifdef CONFIG_LOCK_STAT
@@ -65,7 +64,7 @@ TRACE_EVENT(lock_contended,
 		__assign_str(name, lock->name);
 	),
 
-	TP_printk("%s", __get_str(name))
+	TP_FORMAT("<string:name>")
 );
 
 TRACE_EVENT(lock_acquired,
@@ -75,16 +74,13 @@ TRACE_EVENT(lock_acquired,
 
 	TP_STRUCT__entry(
 		__string(name, lock->name)
-		__field(unsigned long, wait_usec)
-		__field(unsigned long, wait_nsec_rem)
+		__field(long long, wait_nsec)
 	),
 	TP_fast_assign(
 		__assign_str(name, lock->name);
-		__entry->wait_nsec_rem = do_div(waittime, NSEC_PER_USEC);
-		__entry->wait_usec = (unsigned long) waittime;
+		__entry->wait_nsec = waittime;
 	),
-	TP_printk("%s (%lu.%03lu us)", __get_str(name), __entry->wait_usec,
-				       __entry->wait_nsec_rem)
+	TP_FORMAT("<string:name> (<nsec2usec:3:wait_nsec> us)")
 );
 
 #endif
-- 
1.6.3.1

-- 
