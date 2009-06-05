Return-Path: <linux-kernel-owner+w=401wt.eu-S1754895AbZFERNV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895AbZFERNV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 13:13:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752768AbZFERNN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 13:13:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:51952 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752743AbZFERNL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 13:13:11 -0400
Date: Fri, 5 Jun 2009 17:12:33 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf_counter tools: Sample and display frequency adjustment changes
Message-ID: <tip-b2fef0762fdb65cf8702eea93f4e58abeb0ecefc@git.kernel.org>
Git-Commit-ID: b2fef0762fdb65cf8702eea93f4e58abeb0ecefc
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 05 Jun 2009 17:12:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b2fef0762fdb65cf8702eea93f4e58abeb0ecefc
Gitweb:     http://git.kernel.org/tip/b2fef0762fdb65cf8702eea93f4e58abeb0ecefc
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Fri, 5 Jun 2009 18:07:51 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 5 Jun 2009 18:07:51 +0200

perf_counter tools: Sample and display frequency adjustment changes

To allow the debugging of frequency-adjusting counters, sample
those adjustments and display them in perf report -D.

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/perf_counter/builtin-record.c |    2 +-
 Documentation/perf_counter/builtin-report.c |   39 ++++++++++++++++++++++----
 2 files changed, 34 insertions(+), 7 deletions(-)

diff --git a/Documentation/perf_counter/builtin-record.c b/Documentation/perf_counter/builtin-record.c
index d4ad305..43ddab3 100644
--- a/Documentation/perf_counter/builtin-record.c
+++ b/Documentation/perf_counter/builtin-record.c
@@ -347,7 +347,7 @@ static void create_counter(int counter, int cpu, pid_t pid)
 	memset(&attr, 0, sizeof(attr));
 	attr.config		= event_id[counter];
 	attr.sample_period	= event_count[counter];
-	attr.sample_type	= PERF_SAMPLE_IP | PERF_SAMPLE_TID;
+	attr.sample_type	= PERF_SAMPLE_IP | PERF_SAMPLE_TID | PERF_SAMPLE_PERIOD;
 	attr.freq		= freq;
 	attr.mmap		= track;
 	attr.comm		= track;
diff --git a/Documentation/perf_counter/builtin-report.c b/Documentation/perf_counter/builtin-report.c
index 5af105c..242e09f 100644
--- a/Documentation/perf_counter/builtin-report.c
+++ b/Documentation/perf_counter/builtin-report.c
@@ -69,12 +69,20 @@ struct fork_event {
 	__u32 pid, ppid;
 };
 
-typedef union event_union {
+struct period_event {
 	struct perf_event_header header;
-	struct ip_event ip;
-	struct mmap_event mmap;
-	struct comm_event comm;
-	struct fork_event fork;
+	__u64 time;
+	__u64 id;
+	__u64 sample_period;
+};
+
+typedef union event_union {
+	struct perf_event_header	header;
+	struct ip_event			ip;
+	struct mmap_event		mmap;
+	struct comm_event		comm;
+	struct fork_event		fork;
+	struct period_event		period;
 } event_t;
 
 static LIST_HEAD(dsos);
@@ -1053,6 +1061,19 @@ process_fork_event(event_t *event, unsigned long offset, unsigned long head)
 }
 
 static int
+process_period_event(event_t *event, unsigned long offset, unsigned long head)
+{
+	dprintf("%p [%p]: PERF_EVENT_PERIOD: time:%Ld, id:%Ld: period:%Ld\n",
+		(void *)(offset + head),
+		(void *)(long)(event->header.size),
+		event->period.time,
+		event->period.id,
+		event->period.sample_period);
+
+	return 0;
+}
+
+static int
 process_event(event_t *event, unsigned long offset, unsigned long head)
 {
 	if (event->header.misc & PERF_EVENT_MISC_OVERFLOW)
@@ -1068,11 +1089,12 @@ process_event(event_t *event, unsigned long offset, unsigned long head)
 	case PERF_EVENT_FORK:
 		return process_fork_event(event, offset, head);
 
+	case PERF_EVENT_PERIOD:
+		return process_period_event(event, offset, head);
 	/*
 	 * We dont process them right now but they are fine:
 	 */
 
-	case PERF_EVENT_PERIOD:
 	case PERF_EVENT_THROTTLE:
 	case PERF_EVENT_UNTHROTTLE:
 		return 0;
@@ -1157,6 +1179,11 @@ more:
 
 	size = event->header.size;
 
+	dprintf("%p [%p]: event: %d\n",
+			(void *)(offset + head),
+			(void *)(long)event->header.size,
+			event->header.type);
+
 	if (!size || process_event(event, offset, head) < 0) {
 
 		dprintf("%p [%p]: skipping unknown header type: %d\n",
