Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895Ab0CBOne (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 09:43:34 -0500
Received: from mail-ew0-f220.google.com ([209.85.219.220]:45183 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753075Ab0CBOmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 09:42:38 -0500
From: Eric B Munson <ebmunson@us.ibm.com>
To: a.p.zijlstra@chello.nl
Cc: paulus@samba.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       Eric B Munson <ebmunson@us.ibm.com>
Subject: [PATCH 3/5] Add storage for seperating event types in report
Date: Tue,  2 Mar 2010 14:42:29 +0000
Message-Id: <f9bd31c50697a6bbe0f989e6dda20232074410a1.1267537676.git.ebmunson@us.ibm.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <e7af758a4e846f0cb6aac996f0ab36261a92b325.1267537676.git.ebmunson@us.ibm.com>
References: <cover.1267537676.git.ebmunson@us.ibm.com>
 <71583fc64cb167adcdb0039b53b8bc76fed21f80.1267537676.git.ebmunson@us.ibm.com>
 <e7af758a4e846f0cb6aac996f0ab36261a92b325.1267537676.git.ebmunson@us.ibm.com>
In-Reply-To: <cover.1267537676.git.ebmunson@us.ibm.com>
References: <cover.1267537676.git.ebmunson@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the structures necessary to count each event type
independently in perf report.

Signed-off-by: Eric B Munson <ebmunson@us.ibm.com>
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
1.6.3.3

