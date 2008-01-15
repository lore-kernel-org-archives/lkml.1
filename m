Return-Path: <linux-kernel-owner+w=401wt.eu-S1757516AbYAOUvr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757516AbYAOUvr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 15:51:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755143AbYAOUuf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 15:50:35 -0500
Received: from ms-smtp-01.nyroc.rr.com ([24.24.2.55]:44073 "EHLO
	ms-smtp-01.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752988AbYAOUua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 15:50:30 -0500
Message-Id: <20080115205024.650312976@goodmis.org>
References: <20080115204907.838227723@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 15 Jan 2008 15:49:24 -0500
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
       Jan Kiszka <jan.kiszka@siemens.com>, John Stultz <johnstul@us.ibm.com>
Subject: [RFC PATCH 17/30 v3] initialize the clock source to jiffies clock.
Content-Disposition: inline; filename=initialize-clocksource-to-jiffies.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The latency tracer can call clocksource_read very early in bootup and
before the clock source variable has been initialized. This results in a
crash at boot up (even before earlyprintk is initialized). Since the
clock->read variable points to NULL.

This patch simply initializes the clock to use clocksource_jiffies, so
that any early user of clocksource_read will not crash.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Acked-by: John Stultz <johnstul@us.ibm.com>
---
 include/linux/clocksource.h |    3 +++
 kernel/time/timekeeping.c   |    9 +++++++--
 2 files changed, 10 insertions(+), 2 deletions(-)

Index: linux-compile.git/include/linux/clocksource.h
===================================================================
--- linux-compile.git.orig/include/linux/clocksource.h	2008-01-14 13:14:14.000000000 -0500
+++ linux-compile.git/include/linux/clocksource.h	2008-01-14 14:57:46.000000000 -0500
@@ -274,6 +274,9 @@ extern struct clocksource* clocksource_g
 extern void clocksource_change_rating(struct clocksource *cs, int rating);
 extern void clocksource_resume(void);
 
+/* used to initialize clock */
+extern struct clocksource clocksource_jiffies;
+
 #ifdef CONFIG_GENERIC_TIME_VSYSCALL
 extern void update_vsyscall(struct timespec *ts, struct clocksource *c);
 extern void update_vsyscall_tz(void);
Index: linux-compile.git/kernel/time/timekeeping.c
===================================================================
--- linux-compile.git.orig/kernel/time/timekeeping.c	2008-01-14 13:14:14.000000000 -0500
+++ linux-compile.git/kernel/time/timekeeping.c	2008-01-14 14:57:46.000000000 -0500
@@ -53,8 +53,13 @@ static inline void update_xtime_cache(u6
 	timespec_add_ns(&xtime_cache, nsec);
 }
 
-static struct clocksource *clock; /* pointer to current clocksource */
-
+/*
+ * pointer to current clocksource
+ *  Just in case we use clocksource_read before we initialize
+ *  the actual clock source. Instead of calling a NULL read pointer
+ *  we return jiffies.
+ */
+static struct clocksource *clock = &clocksource_jiffies;
 
 #ifdef CONFIG_GENERIC_TIME
 /**

-- 
