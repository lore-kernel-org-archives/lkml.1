Return-Path: <linux-kernel-owner+w=401wt.eu-S1760388AbZFYTpp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760388AbZFYTpp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 15:45:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760105AbZFYTok
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 15:44:40 -0400
Received: from hera.kernel.org ([140.211.167.34]:45369 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760066AbZFYToh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 15:44:37 -0400
Date: Thu, 25 Jun 2009 19:44:10 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/urgent] perf-report: Add bare minimum PERF_EVENT_READ parsing
Message-ID: <tip-e9ea2fde7a07ae60a119171a2946ed2ae778271e@git.kernel.org>
Git-Commit-ID: e9ea2fde7a07ae60a119171a2946ed2ae778271e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 25 Jun 2009 19:44:11 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e9ea2fde7a07ae60a119171a2946ed2ae778271e
Gitweb:     http://git.kernel.org/tip/e9ea2fde7a07ae60a119171a2946ed2ae778271e
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 24 Jun 2009 22:46:04 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 25 Jun 2009 21:39:09 +0200

perf-report: Add bare minimum PERF_EVENT_READ parsing

Provide the basic infrastructure to provide per task stats.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/builtin-report.c |   24 ++++++++++++++++++++++++
 1 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index ec5361c..681c223 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -100,6 +100,13 @@ struct lost_event {
 	u64 lost;
 };
 
+struct read_event {
+	struct perf_event_header header;
+	u32 pid,tid;
+	u64 value;
+	u64 format[3];
+};
+
 typedef union event_union {
 	struct perf_event_header	header;
 	struct ip_event			ip;
@@ -108,6 +115,7 @@ typedef union event_union {
 	struct fork_event		fork;
 	struct period_event		period;
 	struct lost_event		lost;
+	struct read_event		read;
 } event_t;
 
 static LIST_HEAD(dsos);
@@ -1350,6 +1358,19 @@ static void trace_event(event_t *event)
 }
 
 static int
+process_read_event(event_t *event, unsigned long offset, unsigned long head)
+{
+	dprintf("%p [%p]: PERF_EVENT_READ: %d %d %Lu\n",
+			(void *)(offset + head),
+			(void *)(long)(event->header.size),
+			event->read.pid,
+			event->read.tid,
+			event->read.value);
+
+	return 0;
+}
+
+static int
 process_event(event_t *event, unsigned long offset, unsigned long head)
 {
 	trace_event(event);
@@ -1373,6 +1394,9 @@ process_event(event_t *event, unsigned long offset, unsigned long head)
 	case PERF_EVENT_LOST:
 		return process_lost_event(event, offset, head);
 
+	case PERF_EVENT_READ:
+		return process_read_event(event, offset, head);
+
 	/*
 	 * We dont process them right now but they are fine:
 	 */
