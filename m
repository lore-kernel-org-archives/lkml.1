Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755685Ab0CIS6f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 13:58:35 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:39115 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755650Ab0CIS63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 13:58:29 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 1/1] perf report: Print the map table just after samples for which no map was found
Date: Tue,  9 Mar 2010 15:58:17 -0300
Message-Id: <1268161097-17761-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

If -vv is used just the map table will be printed, -vvv will print the symbol
table too, with it we can see that we have a bug where some samples are not
being resolved to a map when we get them in the perf.data stream, but after we
have it all processed, we can find the right map, some reordering probably is
happening.

Upcoming patches will provide ways to ask for most PERF_SAMPLE_ conditional
samples to be taken for !PERF_RECORD_SAMPLE events too, then we'll be able to
ask for PERF_SAMPLE_TIME and PERF_SAMPLE_CPU to help diagnose this.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/hist.c   |    5 +++++
 tools/perf/util/thread.c |    6 +++---
 tools/perf/util/thread.h |    3 +++
 3 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 73ebb6f..bdcfd61 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -655,6 +655,11 @@ print_entries:
 		}
 		ret += hist_entry__fprintf(h, pair, show_displacement,
 					   displacement, fp, session_total);
+		if (h->map == NULL && verbose > 1) {
+			__map_groups__fprintf_maps(&h->thread->mg,
+						   MAP__FUNCTION, fp);
+			fprintf(fp, "%.10s end\n", graph_dotted_line);
+		}
 	}
 
 	free(rem_sq_bracket);
diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index 9024fa1..fa96831 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -79,8 +79,8 @@ int thread__comm_len(struct thread *self)
 	return self->comm_len;
 }
 
-static size_t __map_groups__fprintf_maps(struct map_groups *self,
-					 enum map_type type, FILE *fp)
+size_t __map_groups__fprintf_maps(struct map_groups *self,
+				  enum map_type type, FILE *fp)
 {
 	size_t printed = fprintf(fp, "%s:\n", map_type__name[type]);
 	struct rb_node *nd;
@@ -89,7 +89,7 @@ static size_t __map_groups__fprintf_maps(struct map_groups *self,
 		struct map *pos = rb_entry(nd, struct map, rb_node);
 		printed += fprintf(fp, "Map:");
 		printed += map__fprintf(pos, fp);
-		if (verbose > 1) {
+		if (verbose > 2) {
 			printed += dso__fprintf(pos->dso, type, fp);
 			printed += fprintf(fp, "--\n");
 		}
diff --git a/tools/perf/util/thread.h b/tools/perf/util/thread.h
index 0a28f39..dcf7030 100644
--- a/tools/perf/util/thread.h
+++ b/tools/perf/util/thread.h
@@ -10,6 +10,9 @@ struct map_groups {
 	struct list_head	removed_maps[MAP__NR_TYPES];
 };
 
+size_t __map_groups__fprintf_maps(struct map_groups *self,
+				  enum map_type type, FILE *fp);
+
 struct thread {
 	struct rb_node		rb_node;
 	struct map_groups	mg;
-- 
1.5.5.1

