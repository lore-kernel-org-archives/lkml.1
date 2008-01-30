Return-Path: <linux-kernel-owner+w=401wt.eu-S1764074AbYA3VJk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764074AbYA3VJk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 16:09:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755908AbYA3VFu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 16:05:50 -0500
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:49546 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758001AbYA3VFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 16:05:37 -0500
Message-Id: <20080130210526.364099265@goodmis.org>
References: <20080130210357.927754294@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 30 Jan 2008 16:04:07 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>, Tim Bird <tim.bird@am.sony.com>,
       Sam Ravnborg <sam@ravnborg.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       Jan Kiszka <jan.kiszka@siemens.com>, John Stultz <johnstul@us.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 10/23 -v8] mcount tracer add preempt_enable/disable notrace macros
Content-Disposition: inline; filename=mcount-preempt-notrace.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The tracer may need to call preempt_enable and disable functions
for time keeping and such. The trace gets ugly when we see these
functions show up for all traces. To make the output cleaner
this patch adds preempt_enable_notrace and preempt_disable_notrace
to be used by tracer (and debugging) functions.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 include/linux/clocksource.h |    5 +++--
 include/linux/preempt.h     |   32 ++++++++++++++++++++++++++++++++
 2 files changed, 35 insertions(+), 2 deletions(-)

Index: linux-mcount.git/include/linux/clocksource.h
===================================================================
--- linux-mcount.git.orig/include/linux/clocksource.h	2008-01-30 15:09:16.000000000 -0500
+++ linux-mcount.git/include/linux/clocksource.h	2008-01-30 15:11:07.000000000 -0500
@@ -197,7 +197,8 @@ clocksource_get_basecycles(struct clocks
 	int num;
 	cycle_t now, offset;
 
-	preempt_disable();
+	/* This code is used for tracing. */
+	preempt_disable_notrace();
 	num = cs->base_num;
 	/* base_num is shared, and some archs are wacky */
 	smp_read_barrier_depends();
@@ -205,7 +206,7 @@ clocksource_get_basecycles(struct clocks
 	offset = (now - cs->base[num].cycle_base_last);
 	offset &= cs->mask;
 	offset += cs->base[num].cycle_base;
-	preempt_enable();
+	preempt_enable_notrace();
 
 	return offset;
 }
Index: linux-mcount.git/include/linux/preempt.h
===================================================================
--- linux-mcount.git.orig/include/linux/preempt.h	2008-01-30 14:35:50.000000000 -0500
+++ linux-mcount.git/include/linux/preempt.h	2008-01-30 15:11:07.000000000 -0500
@@ -52,6 +52,34 @@ do { \
 	preempt_check_resched(); \
 } while (0)
 
+/* For debugging and tracer internals only! */
+#define add_preempt_count_notrace(val)			\
+	do { preempt_count() += (val); } while (0)
+#define sub_preempt_count_notrace(val)			\
+	do { preempt_count() -= (val); } while (0)
+#define inc_preempt_count_notrace() add_preempt_count_notrace(1)
+#define dec_preempt_count_notrace() sub_preempt_count_notrace(1)
+
+#define preempt_disable_notrace() \
+do { \
+	inc_preempt_count_notrace(); \
+	barrier(); \
+} while (0)
+
+#define preempt_enable_no_resched_notrace() \
+do { \
+	barrier(); \
+	dec_preempt_count_notrace(); \
+} while (0)
+
+/* preempt_check_resched is OK to trace */
+#define preempt_enable_notrace() \
+do { \
+	preempt_enable_no_resched_notrace(); \
+	barrier(); \
+	preempt_check_resched(); \
+} while (0)
+
 #else
 
 #define preempt_disable()		do { } while (0)
@@ -59,6 +87,10 @@ do { \
 #define preempt_enable()		do { } while (0)
 #define preempt_check_resched()		do { } while (0)
 
+#define preempt_disable_notrace()		do { } while (0)
+#define preempt_enable_no_resched_notrace()	do { } while (0)
+#define preempt_enable_notrace()		do { } while (0)
+
 #endif
 
 #ifdef CONFIG_PREEMPT_NOTIFIERS

-- 
