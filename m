Return-Path: <linux-kernel-owner+w=401wt.eu-S1756505AbZDPCUW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756505AbZDPCUW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 22:20:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753271AbZDPCTb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 22:19:31 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:63276 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433AbZDPCT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 22:19:29 -0400
Message-Id: <20090416021928.467656424@goodmis.org>
References: <20090416021830.556671772@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 15 Apr 2009 22:18:33 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 3/5] tracing/events: add rcu locking around trace event prints
Content-Disposition: inline; filename=0003-tracing-events-add-rcu-locking-around-trace-event-p.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Some trace events need to have a way to print out data that his
allocated, but will be freed later. Using a function that can allocate
memory, and free it with call_rcu, can be useful.

This patch adds rcu locking around the print part of the TRACE_EVENT
macro to facilitate this.

Reported-by: Theodore Tso <tytso@mit.edu>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/trace/ftrace.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 60c5323..6fb06bd 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -62,7 +62,9 @@
  *
  *	field = (typeof(field))entry;
  *
+ *	rcu_read_lock();
  *	ret = trace_seq_printf(s, <TP_printk> "\n");
+ *	rcu_read_unlock();
  *	if (!ret)
  *		return TRACE_TYPE_PARTIAL_LINE;
  *
@@ -99,7 +101,9 @@ ftrace_raw_output_##call(struct trace_iterator *iter, int flags)	\
 									\
 	field = (typeof(field))entry;					\
 									\
+	rcu_read_lock();						\
 	ret = trace_seq_printf(s, #call ": " print);			\
+	rcu_read_unlock();						\
 	if (!ret)							\
 		return TRACE_TYPE_PARTIAL_LINE;				\
 									\
-- 
1.6.2.1

-- 
