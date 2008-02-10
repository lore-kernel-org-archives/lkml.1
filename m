Return-Path: <linux-kernel-owner+w=401wt.eu-S1758666AbYBJHWW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758666AbYBJHWW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 02:22:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757903AbYBJHUb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 02:20:31 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35401 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757867AbYBJHU2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 02:20:28 -0500
Date: Sun, 10 Feb 2008 08:20:09 +0100
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@zip.com.au>, Steven Rostedt <rostedt@goodmis.org>
Subject: [04/19] ftrace: add preempt_enable/disable notrace macros
Message-ID: <20080210072009.GE4100@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The tracer may need to call preempt_enable and disable functions
for time keeping and such. The trace gets ugly when we see these
functions show up for all traces. To make the output cleaner
this patch adds preempt_enable_notrace and preempt_disable_notrace
to be used by tracer (and debugging) functions.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/preempt.h |   32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

Index: linux/include/linux/preempt.h
===================================================================
--- linux.orig/include/linux/preempt.h
+++ linux/include/linux/preempt.h
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
