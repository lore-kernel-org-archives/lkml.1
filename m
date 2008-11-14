Return-Path: <linux-kernel-owner+w=401wt.eu-S1756067AbYKNXE7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756067AbYKNXE7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 18:04:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753523AbYKNXAx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 18:00:53 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:57262 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756099AbYKNXAw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 18:00:52 -0500
Message-Id: <20081114224947.808266099@polymtl.ca>
References: <20081114224733.364965865@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Fri, 14 Nov 2008 17:47:37 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Linus Torvalds <torvalds@linux-foundation.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Hideo AOKI <haoki@redhat.com>,
       Takashi Nishiie <t-nishiie@np.css.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [patch 04/16] Markers use rcu_*_sched_notrace and notrace
Content-Disposition: inline; filename=markers-use-rcu-sched-notrace.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Fri, 14 Nov 2008 23:00:01 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make marker critical code use notrace (__attribute__((no_instrument_function))
to make sure they can be used as an ftrace callback.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Masami Hiramatsu <mhiramat@redhat.com>
CC: 'Peter Zijlstra' <peterz@infradead.org>
CC: "Frank Ch. Eigler" <fche@redhat.com>
CC: 'Ingo Molnar' <mingo@elte.hu>
CC: Lai Jiangshan <laijs@cn.fujitsu.com>
CC: 'Hideo AOKI' <haoki@redhat.com>
CC: Takashi Nishiie <t-nishiie@np.css.fujitsu.com>
CC: 'Steven Rostedt' <rostedt@goodmis.org>
---
 kernel/marker.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

Index: linux-2.6-lttng/kernel/marker.c
===================================================================
--- linux-2.6-lttng.orig/kernel/marker.c	2008-10-15 09:43:15.000000000 -0400
+++ linux-2.6-lttng/kernel/marker.c	2008-10-15 09:44:08.000000000 -0400
@@ -81,7 +81,7 @@ struct marker_entry {
  * though the function pointer change and the marker enabling are two distinct
  * operations that modifies the execution flow of preemptible code.
  */
-void __mark_empty_function(void *probe_private, void *call_private,
+notrace void __mark_empty_function(void *probe_private, void *call_private,
 	const char *fmt, va_list *args)
 {
 }
@@ -97,7 +97,8 @@ EXPORT_SYMBOL_GPL(__mark_empty_function)
  * need to put a full smp_rmb() in this branch. This is why we do not use
  * rcu_dereference() for the pointer read.
  */
-void marker_probe_cb(const struct marker *mdata, void *call_private, ...)
+notrace void marker_probe_cb(const struct marker *mdata,
+		void *call_private, ...)
 {
 	va_list args;
 	char ptype;
@@ -107,7 +108,7 @@ void marker_probe_cb(const struct marker
 	 * sure the teardown of the callbacks can be done correctly when they
 	 * are in modules and they insure RCU read coherency.
 	 */
-	rcu_read_lock_sched();
+	rcu_read_lock_sched_notrace();
 	ptype = mdata->ptype;
 	if (likely(!ptype)) {
 		marker_probe_func *func;
@@ -145,7 +146,7 @@ void marker_probe_cb(const struct marker
 			va_end(args);
 		}
 	}
-	rcu_read_unlock_sched();
+	rcu_read_unlock_sched_notrace();
 }
 EXPORT_SYMBOL_GPL(marker_probe_cb);
 
@@ -157,12 +158,13 @@ EXPORT_SYMBOL_GPL(marker_probe_cb);
  *
  * Should be connected to markers "MARK_NOARGS".
  */
-static void marker_probe_cb_noarg(const struct marker *mdata, void *call_private, ...)
+static notrace void marker_probe_cb_noarg(const struct marker *mdata,
+		void *call_private, ...)
 {
 	va_list args;	/* not initialized */
 	char ptype;
 
-	rcu_read_lock_sched();
+	rcu_read_lock_sched_notrace();
 	ptype = mdata->ptype;
 	if (likely(!ptype)) {
 		marker_probe_func *func;
@@ -195,7 +197,7 @@ static void marker_probe_cb_noarg(const 
 			multi[i].func(multi[i].probe_private, call_private,
 				mdata->format, &args);
 	}
-	rcu_read_unlock_sched();
+	rcu_read_unlock_sched_notrace();
 }
 
 static void free_old_closure(struct rcu_head *head)

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
