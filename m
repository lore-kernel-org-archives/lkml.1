Return-Path: <linux-kernel-owner+w=401wt.eu-S1757606AbZF3XaE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757606AbZF3XaE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 19:30:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760884AbZF3X3K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 19:29:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:60531 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760771AbZF3X3F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 19:29:05 -0400
Date: Tue, 30 Jun 2009 23:28:36 GMT
From: tip-bot for Anton Blanchard <anton@samba.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, anton@samba.org, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, anton@samba.org,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090630230141.088394681@samba.org>
References: <20090630230141.088394681@samba.org>
Subject: [tip:perfcounters/urgent] perf report: Fix reporting of hypervisor
Message-ID: <tip-d8db1b57d31a6b30ea2f0df318eab50fc92b38d6@git.kernel.org>
Git-Commit-ID: d8db1b57d31a6b30ea2f0df318eab50fc92b38d6
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 30 Jun 2009 23:28:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d8db1b57d31a6b30ea2f0df318eab50fc92b38d6
Gitweb:     http://git.kernel.org/tip/d8db1b57d31a6b30ea2f0df318eab50fc92b38d6
Author:     Anton Blanchard <anton@samba.org>
AuthorDate: Wed, 1 Jul 2009 09:00:48 +1000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 1 Jul 2009 01:25:20 +0200

perf report: Fix reporting of hypervisor

PERF_EVENT_MISC_* is not a bitmask, so we have to mask and compare.

Signed-off-by: Anton Blanchard <anton@samba.org>
Cc: a.p.zijlstra@chello.nl
Cc: paulus@samba.org
LKML-Reference: <20090630230141.088394681@samba.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/builtin-report.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 135b783..88e88c5 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -1213,6 +1213,7 @@ process_sample_event(event_t *event, unsigned long offset, unsigned long head)
 	struct map *map = NULL;
 	void *more_data = event->ip.__more_data;
 	struct ip_callchain *chain = NULL;
+	int cpumode;
 
 	if (sample_type & PERF_SAMPLE_PERIOD) {
 		period = *(u64 *)more_data;
@@ -1256,7 +1257,9 @@ process_sample_event(event_t *event, unsigned long offset, unsigned long head)
 	if (comm_list && !strlist__has_entry(comm_list, thread->comm))
 		return 0;
 
-	if (event->header.misc & PERF_EVENT_MISC_KERNEL) {
+	cpumode = event->header.misc & PERF_EVENT_MISC_CPUMODE_MASK;
+
+	if (cpumode == PERF_EVENT_MISC_KERNEL) {
 		show = SHOW_KERNEL;
 		level = 'k';
 
@@ -1264,7 +1267,7 @@ process_sample_event(event_t *event, unsigned long offset, unsigned long head)
 
 		dprintf(" ...... dso: %s\n", dso->name);
 
-	} else if (event->header.misc & PERF_EVENT_MISC_USER) {
+	} else if (cpumode == PERF_EVENT_MISC_USER) {
 
 		show = SHOW_USER;
 		level = '.';
