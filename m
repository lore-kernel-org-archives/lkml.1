Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756249Ab0CJNPp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 08:15:45 -0500
Received: from hera.kernel.org ([140.211.167.34]:43180 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751103Ab0CJNPf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 08:15:35 -0500
Date: Wed, 10 Mar 2010 13:14:35 GMT
From: tip-bot for Eric B Munson <ebmunson@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
       ebmunson@us.ibm.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, ebmunson@us.ibm.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1267804269-22660-3-git-send-email-acme@infradead.org>
References: <1267804269-22660-3-git-send-email-acme@infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf session: Change add_hist_entry to take the tree root instead of session
Message-ID: <tip-d403d0acc9c5afa679a3f61e71489530d7fa0606@git.kernel.org>
Git-Commit-ID: d403d0acc9c5afa679a3f61e71489530d7fa0606
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 10 Mar 2010 13:14:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d403d0acc9c5afa679a3f61e71489530d7fa0606
Gitweb:     http://git.kernel.org/tip/d403d0acc9c5afa679a3f61e71489530d7fa0606
Author:     Eric B Munson <ebmunson@us.ibm.com>
AuthorDate: Fri, 5 Mar 2010 12:51:06 -0300
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 10 Mar 2010 13:53:47 +0100

perf session: Change add_hist_entry to take the tree root instead of session

In order to minimize the impact of storing multiple events in a
report this function will now take the root of the histogram
tree so that the logic for selecting the proper tree can be
inserted before the call.

Signed-off-by: Eric B Munson <ebmunson@us.ibm.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <1267804269-22660-3-git-send-email-acme@infradead.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
