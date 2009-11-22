Return-Path: <linux-kernel-owner+w=401wt.eu-S1752847AbZKVJ55@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847AbZKVJ55 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 04:57:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752204AbZKVJ54
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 04:57:56 -0500
Received: from smtp6.welho.com ([213.243.153.40]:35029 "EHLO smtp6.welho.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752140AbZKVJ5z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 04:57:55 -0500
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Li Zefan <lizf@cn.fujitsu.com>, Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: [PATCH] perf kmem: Add --sort hit and --sort frag
Date: Sun, 22 Nov 2009 11:58:00 +0200
Message-Id: <1258883880-7149-1-git-send-email-penberg@cs.helsinki.fi>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for "--sort hit" and "--sort frag" to the "perf kmem"
tool. The former was already mentioned in the help text and the latter is
useful for finding call-sites that exhibit worst case behavior for SLAB
allocators.

Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Cc: linux-mm@kvack.org <linux-mm@kvack.org>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 tools/perf/builtin-kmem.c |   29 ++++++++++++++++++++++++++++-
 1 files changed, 28 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index f315b05..4145049 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -443,6 +443,15 @@ static int callsite_cmp(struct alloc_stat *l, struct alloc_stat *r)
 	return 0;
 }
 
+static int hit_cmp(struct alloc_stat *l, struct alloc_stat *r)
+{
+	if (l->hit < r->hit)
+		return -1;
+	else if (l->hit > r->hit)
+		return 1;
+	return 0;
+}
+
 static int bytes_cmp(struct alloc_stat *l, struct alloc_stat *r)
 {
 	if (l->bytes_alloc < r->bytes_alloc)
@@ -452,6 +461,20 @@ static int bytes_cmp(struct alloc_stat *l, struct alloc_stat *r)
 	return 0;
 }
 
+static int frag_cmp(struct alloc_stat *l, struct alloc_stat *r)
+{
+	double x, y;
+
+	x = fragmentation(l->bytes_req, l->bytes_alloc);
+	y = fragmentation(r->bytes_req, r->bytes_alloc);
+
+	if (x < y)
+		return -1;
+	else if (x > y)
+		return 1;
+	return 0;
+}
+
 static int parse_sort_opt(const struct option *opt __used,
 			  const char *arg, int unset __used)
 {
@@ -464,8 +487,12 @@ static int parse_sort_opt(const struct option *opt __used,
 		sort_fn = ptr_cmp;
 	else if (strcmp(arg, "call_site") == 0)
 		sort_fn = callsite_cmp;
+	else if (strcmp(arg, "hit") == 0)
+		sort_fn = hit_cmp;
 	else if (strcmp(arg, "bytes") == 0)
 		sort_fn = bytes_cmp;
+	else if (strcmp(arg, "frag") == 0)
+		sort_fn = frag_cmp;
 	else
 		return -1;
 
@@ -517,7 +544,7 @@ static const struct option kmem_options[] = {
 		     "stat selector, Pass 'alloc' or 'caller'.",
 		     parse_stat_opt),
 	OPT_CALLBACK('s', "sort", NULL, "key",
-		     "sort by key: ptr, call_site, hit, bytes",
+		     "sort by key: ptr, call_site, hit, bytes, frag",
 		     parse_sort_opt),
 	OPT_CALLBACK('l', "line", NULL, "num",
 		     "show n lins",
-- 
1.6.0.4

