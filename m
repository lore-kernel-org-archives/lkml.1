Return-Path: <linux-kernel-owner+w=401wt.eu-S1754082AbZHNKFH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082AbZHNKFH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 06:05:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753670AbZHNKFG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 06:05:06 -0400
Received: from mail-ew0-f214.google.com ([209.85.219.214]:37981 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069AbZHNKFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 06:05:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=tQB4MZa7ZKa30nCJZYKlavBtjCd114SSj1nXSav3JNw94pgHflNKGZySFkLfOAprDZ
         5qUBn+VSJwiwbcACXo5esh2KuTV/FeoMGGu8sMZIZ2bAGnY3Ed1DZYKv6fdKzrLXWoby
         allqKzN0/+f+uHM3HHAyPrIaNxdJKq5wuDfyI=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>
Subject: [PATCH 1/2] perf tools: Add a per tracepoint counter attribute to get raw sample
Date: Fri, 14 Aug 2009 12:04:58 +0200
Message-Id: <1250244300-6343-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new flag field while opening a tracepoint perf counter:

	-e tracepoint_subsystem:tracepoint_name:flags

This is intended to be generic although for now it only supports the
r[e[c[o[r[d]]]]] flag:

	./perf record -e workqueue:workqueue_insertion:record
	./perf record -e workqueue:workqueue_insertion:r

will have the same effect: enabling the raw samples record for the
given tracepoint counter.

In the future, we may want to support further flags, separated by
commas.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
---
 tools/perf/builtin-record.c    |    2 +-
 tools/perf/util/parse-events.c |   10 ++++++++++
 2 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 5aeb632..3be0301 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -380,7 +380,7 @@ static void create_counter(int counter, int cpu, pid_t pid)
 				  PERF_FORMAT_TOTAL_TIME_RUNNING |
 				  PERF_FORMAT_ID;
 
-	attr->sample_type	= PERF_SAMPLE_IP | PERF_SAMPLE_TID;
+	attr->sample_type	|= PERF_SAMPLE_IP | PERF_SAMPLE_TID;
 
 	if (freq) {
 		attr->sample_type	|= PERF_SAMPLE_PERIOD;
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index a5d661b..4bab278 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -379,6 +379,7 @@ static int parse_tracepoint_event(const char **strp,
 				    struct perf_counter_attr *attr)
 {
 	const char *evt_name;
+	char *flags;
 	char sys_name[MAX_EVENT_LENGTH];
 	char id_buf[4];
 	int fd;
@@ -400,6 +401,15 @@ static int parse_tracepoint_event(const char **strp,
 	strncpy(sys_name, *strp, sys_length);
 	sys_name[sys_length] = '\0';
 	evt_name = evt_name + 1;
+
+	flags = strchr(evt_name, ':');
+	if (flags) {
+		*flags = '\0';
+		flags++;
+		if (!strncmp(flags, "record", strlen(flags)))
+			attr->sample_type |= PERF_SAMPLE_RAW;
+	}
+
 	evt_length = strlen(evt_name);
 	if (evt_length >= MAX_EVENT_LENGTH)
 		return 0;
-- 
1.6.2.3

