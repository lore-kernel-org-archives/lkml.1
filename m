Return-Path: <linux-kernel-owner+w=401wt.eu-S1760639AbZFZO2k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760639AbZFZO2k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 10:28:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760107AbZFZO2I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 10:28:08 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:35961 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753652AbZFZO2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 10:28:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=eCwuVYUyNfND8T4T8jLbFhft6wyXRqqBBxil3vFQaw85h4qJ2OZ4KHR98rPRNoISfL
         oedLLw/xXUcZKNnkyf36KwQsnz7OIBeu+4fvwUKHtS80SsiEKH2LruArjKFsuqQTXWkO
         Btp6Tx/kiO2jX2RdEFn8IwE5M5vU4YtbP/KW0=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 2/2] perfcounter: print sorted callchains per histogram entries
Date: Fri, 26 Jun 2009 16:28:01 +0200
Message-Id: <1246026481-8314-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1246026481-8314-1-git-send-email-fweisbec@gmail.com>
References: <1246026481-8314-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the newly created callchains radix tree to gather the chains stats
from the recorded events and then print the callchains for all of them,
sorted by hits, using the "-c" parameter with perf report.

Example:

 66.15%  [k] atm_clip_exit
            63.08%
                0xffffffffffffff80
                0xffffffff810196a8
                0xffffffff810c14c8
                0xffffffff8101a79c
                0xffffffff810194f3
                0xffffffff8106ab7f
                0xffffffff8106abe5
                0xffffffff8106acde
                0xffffffff8100d94b
                0xffffffff8153e7ea
                [...]

             1.54%
                0xffffffffffffff80
                0xffffffff810196a8
                0xffffffff810c14c8
                0xffffffff8101a79c
		[...]

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 tools/perf/builtin-report.c |   82 +++++++++++++++++++++++++++++++++++++------
 1 files changed, 71 insertions(+), 11 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 28d1cb2..ed391db 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -15,6 +15,7 @@
 #include "util/rbtree.h"
 #include "util/symbol.h"
 #include "util/string.h"
+#include "util/callchain.h"
 
 #include "perf.h"
 #include "util/header.h"
@@ -52,6 +53,7 @@ static char		*parent_pattern = default_parent_pattern;
 static regex_t		parent_regex;
 
 static int		exclude_other = 1;
+static int		callchain;
 
 static u64		sample_type;
 
@@ -488,17 +490,19 @@ static size_t threads__fprintf(FILE *fp)
 static struct rb_root hist;
 
 struct hist_entry {
-	struct rb_node	 rb_node;
-
-	struct thread	 *thread;
-	struct map	 *map;
-	struct dso	 *dso;
-	struct symbol	 *sym;
-	struct symbol	 *parent;
-	u64		 ip;
-	char		 level;
-
-	u64		 count;
+	struct rb_node		rb_node;
+
+	struct thread		*thread;
+	struct map		*map;
+	struct dso		*dso;
+	struct symbol		*sym;
+	struct symbol		*parent;
+	u64			ip;
+	char			level;
+	struct callchain_node	callchain;
+	struct rb_root		sorted_chain;
+
+	u64			count;
 };
 
 /*
@@ -769,6 +773,48 @@ hist_entry__collapse(struct hist_entry *left, struct hist_entry *right)
 }
 
 static size_t
+callchain__fprintf(FILE *fp, struct callchain_node *self, u64 total_samples)
+{
+	struct callchain_list *chain;
+	size_t ret = 0;
+
+	if (!self)
+		return 0;
+
+	ret += callchain__fprintf(fp, self->parent, total_samples);
+
+
+	list_for_each_entry(chain, &self->val, list)
+		ret += fprintf(fp, "                %p\n", (void *)chain->ip);
+
+	return ret;
+}
+
+static size_t
+hist_entry_callchain__fprintf(FILE *fp, struct hist_entry *self,
+			      u64 total_samples)
+{
+	struct rb_node *rb_node;
+	struct callchain_node *chain;
+	size_t ret = 0;
+
+	rb_node = rb_first(&self->sorted_chain);
+	while (rb_node) {
+		double percent;
+
+		chain = rb_entry(rb_node, struct callchain_node, rb_node);
+		percent = chain->hit * 100.0 / total_samples;
+		ret += fprintf(fp, "           %6.2f%%\n", percent);
+		ret += callchain__fprintf(fp, chain, total_samples);
+		ret += fprintf(fp, "\n");
+		rb_node = rb_next(rb_node);
+	}
+
+	return ret;
+}
+
+
+static size_t
 hist_entry__fprintf(FILE *fp, struct hist_entry *self, u64 total_samples)
 {
 	struct sort_entry *se;
@@ -808,6 +854,9 @@ hist_entry__fprintf(FILE *fp, struct hist_entry *self, u64 total_samples)
 
 	ret += fprintf(fp, "\n");
 
+	if (callchain)
+		hist_entry_callchain__fprintf(fp, self, total_samples);
+
 	return ret;
 }
 
@@ -892,6 +941,7 @@ hist_entry__add(struct thread *thread, struct map *map, struct dso *dso,
 		.level	= level,
 		.count	= count,
 		.parent = NULL,
+		.sorted_chain = RB_ROOT
 	};
 	int cmp;
 
@@ -934,6 +984,8 @@ hist_entry__add(struct thread *thread, struct map *map, struct dso *dso,
 
 		if (!cmp) {
 			he->count += count;
+			if (callchain)
+				append_chain(&he->callchain, chain);
 			return 0;
 		}
 
@@ -947,6 +999,10 @@ hist_entry__add(struct thread *thread, struct map *map, struct dso *dso,
 	if (!he)
 		return -ENOMEM;
 	*he = entry;
+	if (callchain) {
+		callchain_init(&he->callchain);
+		append_chain(&he->callchain, chain);
+	}
 	rb_link_node(&he->rb_node, parent, p);
 	rb_insert_color(&he->rb_node, &hist);
 
@@ -1023,6 +1079,9 @@ static void output__insert_entry(struct hist_entry *he)
 	struct rb_node *parent = NULL;
 	struct hist_entry *iter;
 
+	if (callchain)
+		sort_chain_to_rbtree(&he->sorted_chain, &he->callchain);
+
 	while (*p != NULL) {
 		parent = *p;
 		iter = rb_entry(parent, struct hist_entry, rb_node);
@@ -1599,6 +1658,7 @@ static const struct option options[] = {
 		   "regex filter to identify parent, see: '--sort parent'"),
 	OPT_BOOLEAN('x', "exclude-other", &exclude_other,
 		    "Only display entries with parent-match"),
+	OPT_BOOLEAN('c', "callchain", &callchain, "Display callchains"),
 	OPT_END()
 };
 
-- 
1.6.2.3

