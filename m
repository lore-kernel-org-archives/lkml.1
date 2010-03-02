Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844Ab0CBOmp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 09:42:45 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:62395 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753531Ab0CBOmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 09:42:38 -0500
From: Eric B Munson <ebmunson@us.ibm.com>
To: a.p.zijlstra@chello.nl
Cc: paulus@samba.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       Eric B Munson <ebmunson@us.ibm.com>
Subject: [PATCH 2/5] Change add_hist_entry to take the tree root instead of session
Date: Tue,  2 Mar 2010 14:42:28 +0000
Message-Id: <e7af758a4e846f0cb6aac996f0ab36261a92b325.1267537676.git.ebmunson@us.ibm.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <71583fc64cb167adcdb0039b53b8bc76fed21f80.1267537676.git.ebmunson@us.ibm.com>
References: <cover.1267537676.git.ebmunson@us.ibm.com>
 <71583fc64cb167adcdb0039b53b8bc76fed21f80.1267537676.git.ebmunson@us.ibm.com>
In-Reply-To: <cover.1267537676.git.ebmunson@us.ibm.com>
References: <cover.1267537676.git.ebmunson@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to minimize the impact of storing multiple events in a report
this function will now take the root of the histogram tree so that the
logic for selecting the proper tree can be inserted before the call.

Signed-off-by: Eric B Munson <ebmunson@us.ibm.com>
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
1.6.3.3

