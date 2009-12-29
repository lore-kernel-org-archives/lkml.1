Return-Path: <linux-kernel-owner+w=401wt.eu-S1752069AbZL2AtF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069AbZL2AtF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 19:49:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751061AbZL2Asz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 19:48:55 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:60539 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751922AbZL2Asr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 19:48:47 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 5/5] perf diff: Fix support for all --sort combinations
Date: Mon, 28 Dec 2009 22:48:36 -0200
Message-Id: <1262047716-23171-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1262047716-23171-1-git-send-email-acme@infradead.org>
References: <1262047716-23171-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

When we finish creating the hist_entries we _already_ have them sorted "by
name", in fact by what is in --sort, that is exactly how we can find the pairs
in perf_session__match_hists as 'comm', 'dso' & 'symbol' all are strings we
need to find the matches in the baseline session.

So only do the sort by hits followed by a resort by --sort if we need to find
the position for shwowing the --displacement of hist entries.

Now all these modes work correctly:

Example is a simple 'perf record -f find / > /dev/null' ran twice then followed
by the following commands:

  $ perf diff -f --sort comm
  # Baseline  Delta      Command
  # ........ ..........  .......
  #
       0.00%   +100.00%     find
  $ perf diff -f --sort dso
  # Baseline  Delta           Shared Object
  # ........ ..........  ..................
  #
      59.97%     -0.44%  [kernel]
      21.17%     +0.28%  libc-2.5.so
      18.49%     +0.16%  [ext3]
       0.37%             find
  $ perf diff -f --sort symbol | head -8
  # Baseline  Delta      Symbol
  # ........ ..........  ......
  #
       6.21%     +0.36%  [k] ext3fs_dirhash
       3.43%     +0.41%  [.] __GI_strlen
       3.53%     +0.16%  [k] __kmalloc
       3.17%     +0.49%  [k] system_call
       3.06%     +0.37%  [k] ext3_htree_store_dirent
  $ perf diff -f --sort dso,symbol | head -8
  # Baseline  Delta           Shared Object  Symbol
  # ........ ..........  ..................  ......
  #
       6.21%     +0.36%  [ext3]              [k] ext3fs_dirhash
       3.43%     +0.41%  libc-2.5.so         [.] __GI_strlen
       3.53%     +0.16%  [kernel]            [k] __kmalloc
       3.17%     +0.49%  [kernel]            [k] system_call
       3.06%     +0.37%  [ext3]              [k] ext3_htree_store_dirent
  $

And we don't have to do two expensive resorts in the common, non --displacement
case.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-diff.c |   52 ++++++++++++++++++--------------------------
 1 files changed, 21 insertions(+), 31 deletions(-)

diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 876a4b9..924bfb7 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -82,29 +82,19 @@ static void perf_session__insert_hist_entry_by_name(struct rb_root *root,
 	struct hist_entry *iter;
 
 	while (*p != NULL) {
-		int cmp;
 		parent = *p;
 		iter = rb_entry(parent, struct hist_entry, rb_node);
-
-		cmp = strcmp(he->map->dso->name, iter->map->dso->name);
-		if (cmp > 0)
+		if (hist_entry__cmp(he, iter) < 0)
 			p = &(*p)->rb_left;
-		else if (cmp < 0)
+		else
 			p = &(*p)->rb_right;
-		else {
-			cmp = strcmp(he->sym->name, iter->sym->name);
-			if (cmp > 0)
-				p = &(*p)->rb_left;
-			else
-				p = &(*p)->rb_right;
-		}
 	}
 
 	rb_link_node(&he->rb_node, parent, p);
 	rb_insert_color(&he->rb_node, root);
 }
 
-static void perf_session__resort_by_name(struct perf_session *self)
+static void perf_session__resort_hist_entries(struct perf_session *self)
 {
 	unsigned long position = 1;
 	struct rb_root tmp = RB_ROOT;
@@ -122,29 +112,28 @@ static void perf_session__resort_by_name(struct perf_session *self)
 	self->hists = tmp;
 }
 
+static void perf_session__set_hist_entries_positions(struct perf_session *self)
+{
+	perf_session__output_resort(self, self->events_stats.total);
+	perf_session__resort_hist_entries(self);
+}
+
 static struct hist_entry *
-perf_session__find_hist_entry_by_name(struct perf_session *self,
-				      struct hist_entry *he)
+perf_session__find_hist_entry(struct perf_session *self,
+			      struct hist_entry *he)
 {
 	struct rb_node *n = self->hists.rb_node;
 
 	while (n) {
 		struct hist_entry *iter = rb_entry(n, struct hist_entry, rb_node);
-		int cmp = strcmp(he->map->dso->name, iter->map->dso->name);
+		int64_t cmp = hist_entry__cmp(he, iter);
 
-		if (cmp > 0)
+		if (cmp < 0)
 			n = n->rb_left;
-		else if (cmp < 0)
+		else if (cmp > 0)
 			n = n->rb_right;
-		else {
-			cmp = strcmp(he->sym->name, iter->sym->name);
-			if (cmp > 0)
-				n = n->rb_left;
-			else if (cmp < 0)
-				n = n->rb_right;
-			else
-				return iter;
-		}
+		else 
+			return iter;
 	}
 
 	return NULL;
@@ -155,11 +144,9 @@ static void perf_session__match_hists(struct perf_session *old_session,
 {
 	struct rb_node *nd;
 
-	perf_session__resort_by_name(old_session);
-
 	for (nd = rb_first(&new_session->hists); nd; nd = rb_next(nd)) {
 		struct hist_entry *pos = rb_entry(nd, struct hist_entry, rb_node);
-		pos->pair = perf_session__find_hist_entry_by_name(old_session, pos);
+		pos->pair = perf_session__find_hist_entry(old_session, pos);
 	}
 }
 
@@ -177,9 +164,12 @@ static int __cmd_diff(void)
 		ret = perf_session__process_events(session[i], &event_ops);
 		if (ret)
 			goto out_delete;
-		perf_session__output_resort(session[i], session[i]->events_stats.total);
 	}
 
+	perf_session__output_resort(session[1], session[1]->events_stats.total);
+	if (show_displacement)
+		perf_session__set_hist_entries_positions(session[0]);
+
 	perf_session__match_hists(session[0], session[1]);
 	perf_session__fprintf_hists(session[1], session[0],
 				    show_displacement, stdout);
-- 
1.5.5.1

