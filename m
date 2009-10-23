Return-Path: <linux-kernel-owner+w=401wt.eu-S1752162AbZJWRu4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752162AbZJWRu4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 13:50:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751120AbZJWRu4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 13:50:56 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58187 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339AbZJWRuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 13:50:55 -0400
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>
Subject: [PATCH] perf timechart: Use pr_debug to report unknown header types
Date: Fri, 23 Oct 2009 15:50:45 -0200
Message-Id: <1256320245-8439-1-git-send-email-acme@redhat.com>
X-Mailer: git-send-email 1.6.2.5
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It was using eprintf that checked if verbose was !zero, when I converted
to pr_*() I made the mistake of changing it to pr_warning which caused
'perf timechart' output to be way too verbose.

Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Mike Galbraith <efault@gmx.de>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-timechart.c         |    8 ++++----
 tools/perf/util/debug.h                |    2 --
 tools/perf/util/include/linux/kernel.h |    3 +++
 3 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index 0a2f222..1a616e8 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -1162,10 +1162,10 @@ more:
 	size = event->header.size;
 
 	if (!size || process_event(event) < 0) {
-		pr_warning("%p [%p]: skipping unknown header type: %d\n",
-			   (void *)(offset + head),
-			   (void *)(long)(event->header.size),
-			   event->header.type);
+		pr_debug("%p [%p]: skipping unknown header type: %d\n",
+			 (void *)(offset + head),
+			 (void *)(long)(event->header.size),
+			 event->header.type);
 		/*
 		 * assume we lost track of the stream, check alignment, and
 		 * increment a single u64 in the hope to catch on again 'soon'.
diff --git a/tools/perf/util/debug.h b/tools/perf/util/debug.h
index e8b18a1..5864073 100644
--- a/tools/perf/util/debug.h
+++ b/tools/perf/util/debug.h
@@ -5,8 +5,6 @@
 extern int verbose;
 extern int dump_trace;
 
-int eprintf(int level,
-	    const char *fmt, ...) __attribute__((format(printf, 2, 3)));
 int dump_printf(const char *fmt, ...) __attribute__((format(printf, 1, 2)));
 void trace_event(event_t *event);
 
diff --git a/tools/perf/util/include/linux/kernel.h b/tools/perf/util/include/linux/kernel.h
index 21c0274..9bc107f 100644
--- a/tools/perf/util/include/linux/kernel.h
+++ b/tools/perf/util/include/linux/kernel.h
@@ -85,6 +85,9 @@ simple_strtoul(const char *nptr, char **endptr, int base)
 	return strtoul(nptr, endptr, base);
 }
 
+int eprintf(int level,
+	    const char *fmt, ...) __attribute__((format(printf, 2, 3)));
+
 #ifndef pr_fmt
 #define pr_fmt(fmt) fmt
 #endif
-- 
1.6.2.5

