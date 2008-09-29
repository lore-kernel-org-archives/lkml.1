Return-Path: <linux-kernel-owner+w=401wt.eu-S1753552AbYI2PIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552AbYI2PIT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 11:08:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751483AbYI2PIJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 11:08:09 -0400
Received: from tomts5.bellnexxia.net ([209.226.175.25]:47824 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478AbYI2PIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 11:08:07 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgUFAL+L4EhMQWq+/2dsb2JhbACBYrowgWc
Date: Mon, 29 Sep 2008 11:08:03 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] Markers use rcu_read_lock_sched()
Message-ID: <20080929150803.GE11245@Krystal>
References: <48E08B05.7030802@cn.fujitsu.com> <20080929082722.GB18663@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080929082722.GB18663@elte.hu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 11:06:48 up 116 days, 19:47,  9 users,  load average: 1.84, 0.80,
	0.53
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new rcu_read_lock_sched/unlock_sched() in marker code around the call
site instead of preempt_disable/enable(). It helps reviewing the code more
easily.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Paul E McKenney <paulmck@linux.vnet.ibm.com>
CC: akpm@linux-foundation.org
---
 kernel/marker.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

Index: linux-2.6-lttng/kernel/marker.c
===================================================================
--- linux-2.6-lttng.orig/kernel/marker.c	2008-07-15 15:21:04.000000000 -0400
+++ linux-2.6-lttng/kernel/marker.c	2008-07-15 15:21:12.000000000 -0400
@@ -105,11 +105,11 @@ void marker_probe_cb(const struct marker
 	char ptype;
 
 	/*
-	 * preempt_disable does two things : disabling preemption to make sure
-	 * the teardown of the callbacks can be done correctly when they are in
-	 * modules and they insure RCU read coherency.
+	 * rcu_read_lock_sched does two things : disabling preemption to make
+	 * sure the teardown of the callbacks can be done correctly when they
+	 * are in modules and they insure RCU read coherency.
 	 */
-	preempt_disable();
+	rcu_read_lock_sched();
 	ptype = mdata->ptype;
 	if (likely(!ptype)) {
 		marker_probe_func *func;
@@ -146,7 +146,7 @@ void marker_probe_cb(const struct marker
 			va_end(args);
 		}
 	}
-	preempt_enable();
+	rcu_read_unlock_sched();
 }
 EXPORT_SYMBOL_GPL(marker_probe_cb);
 
@@ -165,7 +165,7 @@ void marker_probe_cb_noarg(const struct 
 	va_list args;	/* not initialized */
 	char ptype;
 
-	preempt_disable();
+	rcu_read_lock_sched();
 	ptype = mdata->ptype;
 	if (likely(!ptype)) {
 		marker_probe_func *func;
@@ -197,7 +197,7 @@ void marker_probe_cb_noarg(const struct 
 			multi[i].func(multi[i].probe_private, call_private, fmt,
 				&args);
 	}
-	preempt_enable();
+	rcu_read_unlock_sched();
 }
 EXPORT_SYMBOL_GPL(marker_probe_cb_noarg);
 
@@ -562,7 +562,7 @@ static int set_marker(struct marker_entr
  * Disable a marker and its probe callback.
  * Note: only waiting an RCU period after setting elem->call to the empty
  * function insures that the original callback is not used anymore. This insured
- * by preempt_disable around the call site.
+ * by rcu_read_lock_sched around the call site.
  */
 static void disable_marker(struct marker *elem)
 {
-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
