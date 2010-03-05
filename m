Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754446Ab0CEPwX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 10:52:23 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:43756 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753896Ab0CEPvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 10:51:25 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Eric B Munson <ebmunson@us.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 4/6] perf session: Add storage for seperating event types in report
Date: Fri,  5 Mar 2010 12:51:07 -0300
Message-Id: <1267804269-22660-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1267804269-22660-1-git-send-email-acme@infradead.org>
References: <1267804269-22660-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric B Munson <ebmunson@us.ibm.com>

This patch adds the structures necessary to count each event type
independently in perf report.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Eric B Munson <ebmunson@us.ibm.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
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
-- 
1.5.5.6

