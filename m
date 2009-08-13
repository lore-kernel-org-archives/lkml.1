Return-Path: <linux-kernel-owner+w=401wt.eu-S1753139AbZHMI1Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753139AbZHMI1Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 04:27:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752793AbZHMI1X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 04:27:23 -0400
Received: from mail-ew0-f214.google.com ([209.85.219.214]:35448 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005AbZHMI1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 04:27:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=VRKvY9hT5W5x20YYmfBcjdzeQuWrc7Q/idXK6OFHwEPqocl5lSn7UMuMVS14IF00Yg
         gyXdGTMB9FVqMu9Kju7xfZHKbI6wf+ZvfZ/9l19OdnriqT91PlQu+SQLf5JnBWocT54/
         eIQyNQU1VeyP/alOGmsNxJCCLrkeEDBY6iulQ=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>
Subject: [PATCH 1/2] perf tools: Add a per tracepoint counter attribute to get raw sample
Date: Thu, 13 Aug 2009 10:27:18 +0200
Message-Id: <1250152039-7284-1-git-send-email-fweisbec@gmail.com>
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

