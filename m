Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756009Ab0CJNPg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 08:15:36 -0500
Received: from hera.kernel.org ([140.211.167.34]:43178 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751276Ab0CJNPe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 08:15:34 -0500
Date: Wed, 10 Mar 2010 13:14:51 GMT
From: tip-bot for Eric B Munson <ebmunson@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
       ebmunson@us.ibm.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, ebmunson@us.ibm.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1267804269-22660-4-git-send-email-acme@infradead.org>
References: <1267804269-22660-4-git-send-email-acme@infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf session: Add storage for seperating event types in report
Message-ID: <tip-cb8f09393646c5058056db771583c86e0ed1d92f@git.kernel.org>
Git-Commit-ID: cb8f09393646c5058056db771583c86e0ed1d92f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 10 Mar 2010 13:14:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cb8f09393646c5058056db771583c86e0ed1d92f
Gitweb:     http://git.kernel.org/tip/cb8f09393646c5058056db771583c86e0ed1d92f
Author:     Eric B Munson <ebmunson@us.ibm.com>
AuthorDate: Fri, 5 Mar 2010 12:51:07 -0300
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 10 Mar 2010 13:53:48 +0100

perf session: Add storage for seperating event types in report

This patch adds the structures necessary to count each event
type independently in perf report.

Signed-off-by: Eric B Munson <ebmunson@us.ibm.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <1267804269-22660-4-git-send-email-acme@infradead.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/util/event.h   |    9 +++++++++
 tools/perf/util/session.c |    1 +
 tools/perf/util/session.h |    1 +
 3 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 50a7132..a33b949 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -99,6 +99,15 @@ struct events_stats {
 	u64 lost;
 };
 
+struct event_stat_id {
+	struct rb_node		rb_node;
+	struct rb_root		hists;
+	struct events_stats	stats;
+	u64			config;
+	u64			event_stream;
+	u32			type;
+};
+
 void event__print_totals(void);
 
 struct perf_session;
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 0de7258..eed1cb8 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -70,6 +70,7 @@ struct perf_session *perf_session__new(const char *filename, int mode, bool forc
 
 	memcpy(self->filename, filename, len);
 	self->threads = RB_ROOT;
+	self->stats_by_id = RB_ROOT;
 	self->last_match = NULL;
 	self->mmap_window = 32;
 	self->cwd = NULL;
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 31950fc..5c33417 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -20,6 +20,7 @@ struct perf_session {
 	struct thread		*last_match;
 	struct map		*vmlinux_maps[MAP__NR_TYPES];
 	struct events_stats	events_stats;
+	struct rb_root		stats_by_id;
 	unsigned long		event_total[PERF_RECORD_MAX];
 	unsigned long		unknown_events;
 	struct rb_root		hists;
