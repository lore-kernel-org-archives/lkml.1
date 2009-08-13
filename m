Return-Path: <linux-kernel-owner+w=401wt.eu-S1753538AbZHMIkk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753538AbZHMIkk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 04:40:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752637AbZHMIkj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 04:40:39 -0400
Received: from hera.kernel.org ([140.211.167.34]:33424 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752323AbZHMIki (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 04:40:38 -0400
Date: Thu, 13 Aug 2009 08:40:06 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
       mingo@redhat.com, efault@gmx.de, peterz@infradead.org,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, peterz@infradead.org,
       efault@gmx.de, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1250152039-7284-1-git-send-email-fweisbec@gmail.com>
References: <1250152039-7284-1-git-send-email-fweisbec@gmail.com>
Subject: [tip:perfcounters/urgent] perf tools: Add a per tracepoint counter attribute to get raw sample
Message-ID: <tip-3a9f131fb00b8ac5950a11ad1599e45edfb5ae44@git.kernel.org>
Git-Commit-ID: 3a9f131fb00b8ac5950a11ad1599e45edfb5ae44
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 13 Aug 2009 08:40:06 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3a9f131fb00b8ac5950a11ad1599e45edfb5ae44
Gitweb:     http://git.kernel.org/tip/3a9f131fb00b8ac5950a11ad1599e45edfb5ae44
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Thu, 13 Aug 2009 10:27:18 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 13 Aug 2009 10:37:25 +0200

perf tools: Add a per tracepoint counter attribute to get raw sample

Add a new flag field while opening a tracepoint perf counter:

	-e tracepoint_subsystem:tracepoint_name:flags

This is intended to be generic although for now it only supports the
r[e[c[o[r[d]]]]] flag:

	./perf record -e workqueue:workqueue_insertion:record
	./perf record -e workqueue:workqueue_insertion:r

will have the same effect: enabling the raw samples record for
the given tracepoint counter.

In the future, we may want to support further flags, separated
by commas.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
LKML-Reference: <1250152039-7284-1-git-send-email-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/builtin-record.c    |    2 +-
 tools/perf/util/parse-events.c |   10 ++++++++++
 2 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index de76008..78adc47 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -398,7 +398,7 @@ static void create_counter(int counter, int cpu, pid_t pid)
 				  PERF_FORMAT_TOTAL_TIME_RUNNING |
 				  PERF_FORMAT_ID;
 
-	attr->sample_type	= PERF_SAMPLE_IP | PERF_SAMPLE_TID;
+	attr->sample_type	|= PERF_SAMPLE_IP | PERF_SAMPLE_TID;
 
 	if (freq) {
 		attr->sample_type	|= PERF_SAMPLE_PERIOD;
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 4858d83..0441784 100644
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
