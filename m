Return-Path: <linux-kernel-owner+w=401wt.eu-S1751268AbZL0XhX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751268AbZL0XhX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 18:37:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751182AbZL0XhV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 18:37:21 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:56321 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049AbZL0XhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 18:37:20 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 07/10] perf session: Move total_unknown to perf_session->unknown events
Date: Sun, 27 Dec 2009 21:37:03 -0200
Message-Id: <1261957026-15580-7-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1261957026-15580-1-git-send-email-acme@infradead.org>
References: <1261957026-15580-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

As this is a session property, not belonging to perf_event_ops, that can
be shared by many perf_session instances.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/session.c |    3 ++-
 tools/perf/util/session.h |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index bc84a52..4ca427f 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -66,6 +66,7 @@ struct perf_session *perf_session__new(const char *filename, int mode, bool forc
 	self->mmap_window = 32;
 	self->cwd = NULL;
 	self->cwdlen = 0;
+	self->unknown_events = 0;
 	map_groups__init(&self->kmaps);
 
 	if (perf_session__create_kernel_maps(self) < 0)
@@ -239,7 +240,7 @@ static int perf_session__process_event(struct perf_session *self,
 	case PERF_RECORD_UNTHROTTLE:
 		return ops->process_unthrottle_event(event, self);
 	default:
-		ops->total_unknown++;
+		self->unknown_events++;
 		return -1;
 	}
 }
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 5771ccb..585937b 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -20,6 +20,7 @@ struct perf_session {
 	struct thread		*last_match;
 	struct events_stats	events_stats;
 	unsigned long		event_total[PERF_RECORD_MAX];
+	unsigned long		unknown_events;
 	struct rb_root		hists;
 	u64			sample_type;
 	int			fd;
@@ -40,7 +41,6 @@ struct perf_event_ops {
 	event_op	process_read_event;
 	event_op	process_throttle_event;
 	event_op	process_unthrottle_event;
-	unsigned long	total_unknown;
 	bool		full_paths;
 };
 
-- 
1.6.2.5

