Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754385Ab0CEPv1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 10:51:27 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:43755 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753831Ab0CEPvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 10:51:24 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Eric B Munson <ebmunson@us.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 3/6] perf session: Change add_hist_entry to take the tree root instead of session
Date: Fri,  5 Mar 2010 12:51:06 -0300
Message-Id: <1267804269-22660-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1267804269-22660-1-git-send-email-acme@infradead.org>
References: <1267804269-22660-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric B Munson <ebmunson@us.ibm.com>

In order to minimize the impact of storing multiple events in a report
this function will now take the root of the histogram tree so that the
logic for selecting the proper tree can be inserted before the call.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Eric B Munson <ebmunson@us.ibm.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-annotate.c |    2 +-
 tools/perf/builtin-diff.c     |    3 ++-
 tools/perf/builtin-report.c   |    3 ++-
 tools/perf/util/hist.c        |    6 +++---
 tools/perf/util/hist.h        |    3 ++-
 5 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 5ec5de9..4b734c7 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -116,7 +116,7 @@ static int perf_session__add_hist_entry(struct perf_session *self,
 		return 0;
 	}
 
-	he = __perf_session__add_hist_entry(self, al, NULL, count, &hit);
+	he = __perf_session__add_hist_entry(&self->hists, al, NULL, count, &hit);
 	if (he == NULL)
 		return -ENOMEM;
 
diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 18b3f50..20df735 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -26,7 +26,8 @@ static int perf_session__add_hist_entry(struct perf_session *self,
 					struct addr_location *al, u64 count)
 {
 	bool hit;
-	struct hist_entry *he = __perf_session__add_hist_entry(self, al, NULL,
+	struct hist_entry *he = __perf_session__add_hist_entry(&self->hists,
+							       al, NULL,
 							       count, &hit);
 	if (he == NULL)
 		return -ENOMEM;
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index cfc655d..cd16e6a 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -56,7 +56,8 @@ static int perf_session__add_hist_entry(struct perf_session *self,
 	if ((sort__has_parent || symbol_conf.use_callchain) && chain)
 		syms = perf_session__resolve_callchain(self, al->thread,
 						       chain, &parent);
-	he = __perf_session__add_hist_entry(self, al, parent, count, &hit);
+	he = __perf_session__add_hist_entry(&self->hists, al, parent,
+					    count, &hit);
 	if (he == NULL)
 		return -ENOMEM;
 
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index e8daf5c..55dd911 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -12,12 +12,12 @@ struct callchain_param	callchain_param = {
  * histogram, sorted on item, collects counts
  */
 
-struct hist_entry *__perf_session__add_hist_entry(struct perf_session *self,
+struct hist_entry *__perf_session__add_hist_entry(struct rb_root *hists,
 						  struct addr_location *al,
 						  struct symbol *sym_parent,
 						  u64 count, bool *hit)
 {
-	struct rb_node **p = &self->hists.rb_node;
+	struct rb_node **p = &hists->rb_node;
 	struct rb_node *parent = NULL;
 	struct hist_entry *he;
 	struct hist_entry entry = {
@@ -53,7 +53,7 @@ struct hist_entry *__perf_session__add_hist_entry(struct perf_session *self,
 		return NULL;
 	*he = entry;
 	rb_link_node(&he->rb_node, parent, p);
-	rb_insert_color(&he->rb_node, &self->hists);
+	rb_insert_color(&he->rb_node, hists);
 	*hit = false;
 	return he;
 }
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index e5f99b2..7b48590 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -10,8 +10,9 @@ struct perf_session;
 struct hist_entry;
 struct addr_location;
 struct symbol;
+struct rb_root;
 
-struct hist_entry *__perf_session__add_hist_entry(struct perf_session *self,
+struct hist_entry *__perf_session__add_hist_entry(struct rb_root *hists,
 						  struct addr_location *al,
 						  struct symbol *parent,
 						  u64 count, bool *hit);
-- 
1.5.5.6

