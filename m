Return-Path: <linux-kernel-owner+w=401wt.eu-S932299AbZHLJ0Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932299AbZHLJ0Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 05:26:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755208AbZHLJ0O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 05:26:14 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:9440 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754998AbZHLJ0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 05:26:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=hHev8jFUV/yg2pnNQT0Z5oU02cFY2FL5gAC7SzZKDlonCWAfCNtUd2LQ5ZtLB78rIB
         K10VeBZcacroAAA/ishxykqVfRWI/3rGj4DyWn8B1mgh5GL5dIRKhhm3wuyHWBHRMMuU
         k10YSZNqyzesMMv+gMMS8buVrchrWM/vnewn0=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
       Brice Goglin <Brice.Goglin@inria.fr>
Subject: [PATCH 2/3] perf tools: Factorize the event structure definitions in a single file
Date: Wed, 12 Aug 2009 11:26:01 +0200
Message-Id: <1250069162-13099-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1250069162-13099-1-git-send-email-fweisbec@gmail.com>
References: <1250069162-13099-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Factorize the multiple definition of the events structures into a
single util/event.h file.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Brice Goglin <Brice.Goglin@inria.fr>
---
 tools/perf/builtin-annotate.c |   34 -------------------------
 tools/perf/builtin-record.c   |   18 -------------
 tools/perf/builtin-report.c   |   53 ----------------------------------------
 tools/perf/builtin-top.c      |   20 ---------------
 tools/perf/util/event.h       |   54 +++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/util.h        |    2 +
 6 files changed, 56 insertions(+), 125 deletions(-)
 create mode 100644 tools/perf/util/event.h

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 1a79299..fee663a 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -44,40 +44,6 @@ static int		print_line;
 static unsigned long	page_size;
 static unsigned long	mmap_window = 32;
 
-struct ip_event {
-	struct perf_event_header header;
-	u64 ip;
-	u32 pid, tid;
-};
-
-struct mmap_event {
-	struct perf_event_header header;
-	u32 pid, tid;
-	u64 start;
-	u64 len;
-	u64 pgoff;
-	char filename[PATH_MAX];
-};
-
-struct comm_event {
-	struct perf_event_header header;
-	u32 pid, tid;
-	char comm[16];
-};
-
-struct fork_event {
-	struct perf_event_header header;
-	u32 pid, ppid;
-};
-
-typedef union event_union {
-	struct perf_event_header	header;
-	struct ip_event			ip;
-	struct mmap_event		mmap;
-	struct comm_event		comm;
-	struct fork_event		fork;
-} event_t;
-
 
 struct sym_ext {
 	struct rb_node	node;
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index afae387..718b8f7 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -59,24 +59,6 @@ static int			file_new = 1;
 
 struct perf_header		*header;
 
-struct mmap_event {
-	struct perf_event_header	header;
-	u32				pid;
-	u32				tid;
-	u64				start;
-	u64				len;
-	u64				pgoff;
-	char				filename[PATH_MAX];
-};
-
-struct comm_event {
-	struct perf_event_header	header;
-	u32				pid;
-	u32				tid;
-	char				comm[16];
-};
-
-
 struct mmap_data {
 	int			counter;
 	void			*base;
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 827eab2..1efefcc 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -75,59 +75,6 @@ struct callchain_param	callchain_param = {
 
 static u64		sample_type;
 
-struct ip_event {
-	struct perf_event_header header;
-	u64 ip;
-	u32 pid, tid;
-	unsigned char __more_data[];
-};
-
-struct mmap_event {
-	struct perf_event_header header;
-	u32 pid, tid;
-	u64 start;
-	u64 len;
-	u64 pgoff;
-	char filename[PATH_MAX];
-};
-
-struct comm_event {
-	struct perf_event_header header;
-	u32 pid, tid;
-	char comm[16];
-};
-
-struct fork_event {
-	struct perf_event_header header;
-	u32 pid, ppid;
-	u32 tid, ptid;
-};
-
-struct lost_event {
-	struct perf_event_header header;
-	u64 id;
-	u64 lost;
-};
-
-struct read_event {
-	struct perf_event_header header;
-	u32 pid,tid;
-	u64 value;
-	u64 time_enabled;
-	u64 time_running;
-	u64 id;
-};
-
-typedef union event_union {
-	struct perf_event_header	header;
-	struct ip_event			ip;
-	struct mmap_event		mmap;
-	struct comm_event		comm;
-	struct fork_event		fork;
-	struct lost_event		lost;
-	struct read_event		read;
-} event_t;
-
 static int repsep_fprintf(FILE *fp, const char *fmt, ...)
 {
 	int n;
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 0aa5673..9a6dbbf 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -933,26 +933,6 @@ static void mmap_read_counter(struct mmap_data *md)
 	last_read = this_read;
 
 	for (; old != head;) {
-		struct ip_event {
-			struct perf_event_header header;
-			u64 ip;
-			u32 pid, target_pid;
-		};
-		struct mmap_event {
-			struct perf_event_header header;
-			u32 pid, target_pid;
-			u64 start;
-			u64 len;
-			u64 pgoff;
-			char filename[PATH_MAX];
-		};
-
-		typedef union event_union {
-			struct perf_event_header header;
-			struct ip_event ip;
-			struct mmap_event mmap;
-		} event_t;
-
 		event_t *event = (event_t *)&data[old & md->mask];
 
 		event_t event_copy;
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
new file mode 100644
index 0000000..91e2fe5
--- /dev/null
+++ b/tools/perf/util/event.h
@@ -0,0 +1,54 @@
+#include "../perf.h"
+
+struct ip_event {
+	struct perf_event_header header;
+	u64 ip;
+	u32 pid, tid;
+	unsigned char __more_data[];
+};
+
+struct mmap_event {
+	struct perf_event_header header;
+	u32 pid, tid;
+	u64 start;
+	u64 len;
+	u64 pgoff;
+	char filename[PATH_MAX];
+};
+
+struct comm_event {
+	struct perf_event_header header;
+	u32 pid, tid;
+	char comm[16];
+};
+
+struct fork_event {
+	struct perf_event_header header;
+	u32 pid, ppid;
+	u32 tid, ptid;
+};
+
+struct lost_event {
+	struct perf_event_header header;
+	u64 id;
+	u64 lost;
+};
+
+struct read_event {
+	struct perf_event_header header;
+	u32 pid,tid;
+	u64 value;
+	u64 time_enabled;
+	u64 time_running;
+	u64 id;
+};
+
+typedef union event_union {
+	struct perf_event_header	header;
+	struct ip_event			ip;
+	struct mmap_event		mmap;
+	struct comm_event		comm;
+	struct fork_event		fork;
+	struct lost_event		lost;
+	struct read_event		read;
+} event_t;
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index 68fe157..be4b52c 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -83,6 +83,8 @@
 #include <inttypes.h>
 #include "../../../include/linux/magic.h"
 
+#include "event.h"
+
 #ifndef NO_ICONV
 #include <iconv.h>
 #endif
-- 
1.6.2.3

