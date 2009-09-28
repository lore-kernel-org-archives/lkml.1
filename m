Return-Path: <linux-kernel-owner+w=401wt.eu-S1752223AbZI1PET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752223AbZI1PET (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 11:04:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751878AbZI1PES
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 11:04:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41308 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751400AbZI1PEQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 11:04:16 -0400
Date: Mon, 28 Sep 2009 17:04:07 +0200 (CEST)
From: John Kacur <jkacur@redhat.com>
X-X-Sender: jkacur@localhost.localdomain
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: mingo@elte.hu, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org
Subject: Re: [PATCH] Put common histogram functions for perf in their own
 file
In-Reply-To: <20090928140158.GA6178@nowhere>
Message-ID: <alpine.LFD.2.00.0909281652001.10299@localhost.localdomain>
References: <alpine.LFD.2.00.0909281457530.8316@localhost.localdomain> <20090928140158.GA6178@nowhere>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 28 Sep 2009, Frederic Weisbecker wrote:

> On Mon, Sep 28, 2009 at 03:05:29PM +0200, John Kacur wrote:
> > From d187ab3a62526ffbdff91911f4b2da813ccf037f Mon Sep 17 00:00:00 2001
> > From: John Kacur <jkacur@redhat.com>
> > Date: Mon, 28 Sep 2009 14:53:08 +0200
> > Subject: [PATCH] Move histogram related functions into their own files (hist.c and hist.h)
> >  and make use of them in builtin-annotate.c and builtin-report.c
> 
> 
> 
> I guess a part of the title should be in the changelog, and the title
> should be a compressed version :)

Okay - I added the title of the mail to the changelog

> 
> 
>  
> > Signed-off-by: John Kacur <jkacur@redhat.com>
> >  static int
> >  process_sample_event(event_t *event, unsigned long offset, unsigned long head)
> >  {
> > @@ -861,7 +713,7 @@ more:
> >  		dsos__fprintf(stdout);
> >  
> >  	collapse__resort();
> > -	output__resort();
> > +	output__resort(total);
> 
> 
> 
> Now I wonder if we actually ever need to sort the entries
> in perf annotate. The only thing we need is to count the
> hits per ip.

perf annotate still will not sort the entries with these changes.
because callchain will be equal to zero.

Calling output__resort(total) will be harmless because the calculation
will be thrown away in output__insert_entry() here:
if (callchain)
		callchain_param.sort(&he->sorted_chain, &he->callchain,
				      min_callchain_hits, &callchain_param);

> 
> 
> >  
> >  	find_annotations();
> >  
> > diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
> > index 7b43504..ff6de9e 100644
> > --- a/tools/perf/builtin-report.c
> > +++ b/tools/perf/builtin-report.c
> > @@ -28,6 +28,7 @@
> >  
> >  #include "util/thread.h"
> >  #include "util/sort.h"
> > +#include "util/hist.h"
> >  
> >  static char		const *input_name = "perf.data";
> >  
> > @@ -55,8 +56,6 @@ static int		exclude_other = 1;
> >  
> >  static char		callchain_default_opt[] = "fractal,0.5";
> >  
> > -static int		callchain;
> > -
> >  static char		__cwd[PATH_MAX];
> >  static char		*cwd = __cwd;
> >  static int		cwdlen;
> > @@ -66,50 +65,8 @@ static struct thread	*last_match;
> >  
> >  static struct perf_header *header;
> >  
> > -static
> > -struct callchain_param	callchain_param = {
> > -	.mode	= CHAIN_GRAPH_REL,
> > -	.min_percent = 0.5
> > -};
> 
> 
> 
> At least for now, this part is only used by report. May be better
> keep it in report?
> 
> Concerning the whole, that looks nice. Especially annotate doesn't
> even seem to need any sort.
> 
> So we could eventually keep the hist sorting only in report.
> But that said, it's nice to make all these sorting and histogram
> features in a separate file for general purpose. We can bet that will
> be reused soon or later. If not this is still good to split it, to clear
> a bit builtin-report.c
> 
> But the callchain bits should perhaps stay in report. If that needs
> to be used elsewhere, it would need a kind of cleanup before.
> 

Okay, I agree with you, so I am respinning the patch with callchain and
callchain_param put back in builtin-report.c.

>From 7c6a2035c32d17db0e566a36c7e345ec2182f722 Mon Sep 17 00:00:00 2001
From: John Kacur <jkacur@redhat.com>
Date: Mon, 28 Sep 2009 14:53:08 +0200
Subject: [PATCH] Put common histogram functions for perf in their own file

Move histogram related functions into their own files (hist.c and hist.h)
and make use of them in builtin-annotate.c and builtin-report.c

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 tools/perf/Makefile           |    2 +
 tools/perf/builtin-annotate.c |  152 +--------------------------------------
 tools/perf/builtin-report.c   |  160 +----------------------------------------
 tools/perf/builtin.h          |    3 +
 tools/perf/util/hist.c        |  158 ++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/hist.h        |   45 ++++++++++++
 6 files changed, 212 insertions(+), 308 deletions(-)
 create mode 100644 tools/perf/util/hist.c
 create mode 100644 tools/perf/util/hist.h

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 0a9e5ae..3a99a9f 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -340,6 +340,7 @@ LIB_H += util/module.h
 LIB_H += util/color.h
 LIB_H += util/values.h
 LIB_H += util/sort.h
+LIB_H += util/hist.h
 
 LIB_OBJS += util/abspath.o
 LIB_OBJS += util/alias.o
@@ -376,6 +377,7 @@ LIB_OBJS += util/trace-event-read.o
 LIB_OBJS += util/trace-event-info.o
 LIB_OBJS += util/svghelper.o
 LIB_OBJS += util/sort.o
+LIB_OBJS += util/hist.o
 
 BUILTIN_OBJS += builtin-annotate.o
 BUILTIN_OBJS += builtin-help.o
diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 059c565..df516dc 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -23,6 +23,7 @@
 #include "util/parse-events.h"
 #include "util/thread.h"
 #include "util/sort.h"
+#include "util/hist.h"
 
 static char		const *input_name = "perf.data";
 
@@ -47,45 +48,6 @@ struct sym_ext {
 	char		*path;
 };
 
-/*
- * histogram, sorted on item, collects counts
- */
-
-static struct rb_root hist;
-
-static int64_t
-hist_entry__cmp(struct hist_entry *left, struct hist_entry *right)
-{
-	struct sort_entry *se;
-	int64_t cmp = 0;
-
-	list_for_each_entry(se, &hist_entry__sort_list, list) {
-		cmp = se->cmp(left, right);
-		if (cmp)
-			break;
-	}
-
-	return cmp;
-}
-
-static int64_t
-hist_entry__collapse(struct hist_entry *left, struct hist_entry *right)
-{
-	struct sort_entry *se;
-	int64_t cmp = 0;
-
-	list_for_each_entry(se, &hist_entry__sort_list, list) {
-		int64_t (*f)(struct hist_entry *, struct hist_entry *);
-
-		f = se->collapse ?: se->cmp;
-
-		cmp = f(left, right);
-		if (cmp)
-			break;
-	}
-
-	return cmp;
-}
 
 /*
  * collect histogram counts
@@ -163,116 +125,6 @@ hist_entry__add(struct thread *thread, struct map *map, struct dso *dso,
 	return 0;
 }
 
-static void hist_entry__free(struct hist_entry *he)
-{
-	free(he);
-}
-
-/*
- * collapse the histogram
- */
-
-static struct rb_root collapse_hists;
-
-static void collapse__insert_entry(struct hist_entry *he)
-{
-	struct rb_node **p = &collapse_hists.rb_node;
-	struct rb_node *parent = NULL;
-	struct hist_entry *iter;
-	int64_t cmp;
-
-	while (*p != NULL) {
-		parent = *p;
-		iter = rb_entry(parent, struct hist_entry, rb_node);
-
-		cmp = hist_entry__collapse(iter, he);
-
-		if (!cmp) {
-			iter->count += he->count;
-			hist_entry__free(he);
-			return;
-		}
-
-		if (cmp < 0)
-			p = &(*p)->rb_left;
-		else
-			p = &(*p)->rb_right;
-	}
-
-	rb_link_node(&he->rb_node, parent, p);
-	rb_insert_color(&he->rb_node, &collapse_hists);
-}
-
-static void collapse__resort(void)
-{
-	struct rb_node *next;
-	struct hist_entry *n;
-
-	if (!sort__need_collapse)
-		return;
-
-	next = rb_first(&hist);
-	while (next) {
-		n = rb_entry(next, struct hist_entry, rb_node);
-		next = rb_next(&n->rb_node);
-
-		rb_erase(&n->rb_node, &hist);
-		collapse__insert_entry(n);
-	}
-}
-
-/*
- * reverse the map, sort on count.
- */
-
-static struct rb_root output_hists;
-
-static void output__insert_entry(struct hist_entry *he)
-{
-	struct rb_node **p = &output_hists.rb_node;
-	struct rb_node *parent = NULL;
-	struct hist_entry *iter;
-
-	while (*p != NULL) {
-		parent = *p;
-		iter = rb_entry(parent, struct hist_entry, rb_node);
-
-		if (he->count > iter->count)
-			p = &(*p)->rb_left;
-		else
-			p = &(*p)->rb_right;
-	}
-
-	rb_link_node(&he->rb_node, parent, p);
-	rb_insert_color(&he->rb_node, &output_hists);
-}
-
-static void output__resort(void)
-{
-	struct rb_node *next;
-	struct hist_entry *n;
-	struct rb_root *tree = &hist;
-
-	if (sort__need_collapse)
-		tree = &collapse_hists;
-
-	next = rb_first(tree);
-
-	while (next) {
-		n = rb_entry(next, struct hist_entry, rb_node);
-		next = rb_next(&n->rb_node);
-
-		rb_erase(&n->rb_node, tree);
-		output__insert_entry(n);
-	}
-}
-
-static unsigned long total = 0,
-		     total_mmap = 0,
-		     total_comm = 0,
-		     total_fork = 0,
-		     total_unknown = 0;
-
 static int
 process_sample_event(event_t *event, unsigned long offset, unsigned long head)
 {
@@ -861,7 +713,7 @@ more:
 		dsos__fprintf(stdout);
 
 	collapse__resort();
-	output__resort();
+	output__resort(total);
 
 	find_annotations();
 
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 7b43504..a942d45 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -28,6 +28,7 @@
 
 #include "util/thread.h"
 #include "util/sort.h"
+#include "util/hist.h"
 
 static char		const *input_name = "perf.data";
 
@@ -54,8 +55,7 @@ static unsigned long	mmap_window = 32;
 static int		exclude_other = 1;
 
 static char		callchain_default_opt[] = "fractal,0.5";
-
-static int		callchain;
+int		callchain;
 
 static char		__cwd[PATH_MAX];
 static char		*cwd = __cwd;
@@ -66,7 +66,6 @@ static struct thread	*last_match;
 
 static struct perf_header *header;
 
-static
 struct callchain_param	callchain_param = {
 	.mode	= CHAIN_GRAPH_REL,
 	.min_percent = 0.5
@@ -74,42 +73,6 @@ struct callchain_param	callchain_param = {
 
 static u64		sample_type;
 
-static struct rb_root hist;
-
-static int64_t
-hist_entry__cmp(struct hist_entry *left, struct hist_entry *right)
-{
-	struct sort_entry *se;
-	int64_t cmp = 0;
-
-	list_for_each_entry(se, &hist_entry__sort_list, list) {
-		cmp = se->cmp(left, right);
-		if (cmp)
-			break;
-	}
-
-	return cmp;
-}
-
-static int64_t
-hist_entry__collapse(struct hist_entry *left, struct hist_entry *right)
-{
-	struct sort_entry *se;
-	int64_t cmp = 0;
-
-	list_for_each_entry(se, &hist_entry__sort_list, list) {
-		int64_t (*f)(struct hist_entry *, struct hist_entry *);
-
-		f = se->collapse ?: se->cmp;
-
-		cmp = f(left, right);
-		if (cmp)
-			break;
-	}
-
-	return cmp;
-}
-
 static size_t ipchain__fprintf_graph_line(FILE *fp, int depth, int depth_mask)
 {
 	int i;
@@ -308,7 +271,6 @@ hist_entry_callchain__fprintf(FILE *fp, struct hist_entry *self,
 	return ret;
 }
 
-
 static size_t
 hist_entry__fprintf(FILE *fp, struct hist_entry *self, u64 total_samples)
 {
@@ -573,117 +535,6 @@ hist_entry__add(struct thread *thread, struct map *map, struct dso *dso,
 	return 0;
 }
 
-static void hist_entry__free(struct hist_entry *he)
-{
-	free(he);
-}
-
-/*
- * collapse the histogram
- */
-
-static struct rb_root collapse_hists;
-
-static void collapse__insert_entry(struct hist_entry *he)
-{
-	struct rb_node **p = &collapse_hists.rb_node;
-	struct rb_node *parent = NULL;
-	struct hist_entry *iter;
-	int64_t cmp;
-
-	while (*p != NULL) {
-		parent = *p;
-		iter = rb_entry(parent, struct hist_entry, rb_node);
-
-		cmp = hist_entry__collapse(iter, he);
-
-		if (!cmp) {
-			iter->count += he->count;
-			hist_entry__free(he);
-			return;
-		}
-
-		if (cmp < 0)
-			p = &(*p)->rb_left;
-		else
-			p = &(*p)->rb_right;
-	}
-
-	rb_link_node(&he->rb_node, parent, p);
-	rb_insert_color(&he->rb_node, &collapse_hists);
-}
-
-static void collapse__resort(void)
-{
-	struct rb_node *next;
-	struct hist_entry *n;
-
-	if (!sort__need_collapse)
-		return;
-
-	next = rb_first(&hist);
-	while (next) {
-		n = rb_entry(next, struct hist_entry, rb_node);
-		next = rb_next(&n->rb_node);
-
-		rb_erase(&n->rb_node, &hist);
-		collapse__insert_entry(n);
-	}
-}
-
-/*
- * reverse the map, sort on count.
- */
-
-static struct rb_root output_hists;
-
-static void output__insert_entry(struct hist_entry *he, u64 min_callchain_hits)
-{
-	struct rb_node **p = &output_hists.rb_node;
-	struct rb_node *parent = NULL;
-	struct hist_entry *iter;
-
-	if (callchain)
-		callchain_param.sort(&he->sorted_chain, &he->callchain,
-				      min_callchain_hits, &callchain_param);
-
-	while (*p != NULL) {
-		parent = *p;
-		iter = rb_entry(parent, struct hist_entry, rb_node);
-
-		if (he->count > iter->count)
-			p = &(*p)->rb_left;
-		else
-			p = &(*p)->rb_right;
-	}
-
-	rb_link_node(&he->rb_node, parent, p);
-	rb_insert_color(&he->rb_node, &output_hists);
-}
-
-static void output__resort(u64 total_samples)
-{
-	struct rb_node *next;
-	struct hist_entry *n;
-	struct rb_root *tree = &hist;
-	u64 min_callchain_hits;
-
-	min_callchain_hits = total_samples * (callchain_param.min_percent / 100);
-
-	if (sort__need_collapse)
-		tree = &collapse_hists;
-
-	next = rb_first(tree);
-
-	while (next) {
-		n = rb_entry(next, struct hist_entry, rb_node);
-		next = rb_next(&n->rb_node);
-
-		rb_erase(&n->rb_node, tree);
-		output__insert_entry(n, min_callchain_hits);
-	}
-}
-
 static size_t output__fprintf(FILE *fp, u64 total_samples)
 {
 	struct hist_entry *pos;
@@ -778,13 +629,6 @@ print_entries:
 	return ret;
 }
 
-static unsigned long total = 0,
-		     total_mmap = 0,
-		     total_comm = 0,
-		     total_fork = 0,
-		     total_unknown = 0,
-		     total_lost = 0;
-
 static int validate_chain(struct ip_callchain *chain, event_t *event)
 {
 	unsigned int chain_size;
diff --git a/tools/perf/builtin.h b/tools/perf/builtin.h
index e11d8d2..5d46892 100644
--- a/tools/perf/builtin.h
+++ b/tools/perf/builtin.h
@@ -4,6 +4,9 @@
 #include "util/util.h"
 #include "util/strbuf.h"
 
+extern int callchain;
+extern struct callchain_param	callchain_param;
+
 extern const char perf_version_string[];
 extern const char perf_usage_string[];
 extern const char perf_more_info_string[];
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
new file mode 100644
index 0000000..fbe5444
--- /dev/null
+++ b/tools/perf/util/hist.c
@@ -0,0 +1,158 @@
+#include "hist.h"
+
+struct rb_root hist;
+struct rb_root collapse_hists;
+struct rb_root output_hists;
+
+unsigned long total;
+unsigned long total_mmap;
+unsigned long total_comm;
+unsigned long total_fork;
+unsigned long total_unknown;
+unsigned long total_lost;
+
+/*
+ * histogram, sorted on item, collects counts
+ */
+
+int64_t
+hist_entry__cmp(struct hist_entry *left, struct hist_entry *right)
+{
+	struct sort_entry *se;
+	int64_t cmp = 0;
+
+	list_for_each_entry(se, &hist_entry__sort_list, list) {
+		cmp = se->cmp(left, right);
+		if (cmp)
+			break;
+	}
+
+	return cmp;
+}
+
+int64_t
+hist_entry__collapse(struct hist_entry *left, struct hist_entry *right)
+{
+	struct sort_entry *se;
+	int64_t cmp = 0;
+
+	list_for_each_entry(se, &hist_entry__sort_list, list) {
+		int64_t (*f)(struct hist_entry *, struct hist_entry *);
+
+		f = se->collapse ?: se->cmp;
+
+		cmp = f(left, right);
+		if (cmp)
+			break;
+	}
+
+	return cmp;
+}
+
+void hist_entry__free(struct hist_entry *he)
+{
+	free(he);
+}
+
+/*
+ * collapse the histogram
+ */
+
+void collapse__insert_entry(struct hist_entry *he)
+{
+	struct rb_node **p = &collapse_hists.rb_node;
+	struct rb_node *parent = NULL;
+	struct hist_entry *iter;
+	int64_t cmp;
+
+	while (*p != NULL) {
+		parent = *p;
+		iter = rb_entry(parent, struct hist_entry, rb_node);
+
+		cmp = hist_entry__collapse(iter, he);
+
+		if (!cmp) {
+			iter->count += he->count;
+			hist_entry__free(he);
+			return;
+		}
+
+		if (cmp < 0)
+			p = &(*p)->rb_left;
+		else
+			p = &(*p)->rb_right;
+	}
+
+	rb_link_node(&he->rb_node, parent, p);
+	rb_insert_color(&he->rb_node, &collapse_hists);
+}
+
+void collapse__resort(void)
+{
+	struct rb_node *next;
+	struct hist_entry *n;
+
+	if (!sort__need_collapse)
+		return;
+
+	next = rb_first(&hist);
+	while (next) {
+		n = rb_entry(next, struct hist_entry, rb_node);
+		next = rb_next(&n->rb_node);
+
+		rb_erase(&n->rb_node, &hist);
+		collapse__insert_entry(n);
+	}
+}
+
+/*
+ * reverse the map, sort on count.
+ */
+
+void output__insert_entry(struct hist_entry *he, u64 min_callchain_hits)
+{
+	struct rb_node **p = &output_hists.rb_node;
+	struct rb_node *parent = NULL;
+	struct hist_entry *iter;
+
+	if (callchain)
+		callchain_param.sort(&he->sorted_chain, &he->callchain,
+				      min_callchain_hits, &callchain_param);
+
+	while (*p != NULL) {
+		parent = *p;
+		iter = rb_entry(parent, struct hist_entry, rb_node);
+
+		if (he->count > iter->count)
+			p = &(*p)->rb_left;
+		else
+			p = &(*p)->rb_right;
+	}
+
+	rb_link_node(&he->rb_node, parent, p);
+	rb_insert_color(&he->rb_node, &output_hists);
+}
+
+void output__resort(u64 total_samples)
+{
+	struct rb_node *next;
+	struct hist_entry *n;
+	struct rb_root *tree = &hist;
+	u64 min_callchain_hits;
+
+	min_callchain_hits =
+		total_samples * (callchain_param.min_percent / 100);
+
+	if (sort__need_collapse)
+		tree = &collapse_hists;
+
+	next = rb_first(tree);
+
+	while (next) {
+		n = rb_entry(next, struct hist_entry, rb_node);
+		next = rb_next(&n->rb_node);
+
+		rb_erase(&n->rb_node, tree);
+		output__insert_entry(n, min_callchain_hits);
+	}
+}
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
new file mode 100644
index 0000000..dba47e1
--- /dev/null
+++ b/tools/perf/util/hist.h
@@ -0,0 +1,45 @@
+#ifndef __PERF_HIST_H
+#define __PERF_HIST_H
+#include "../builtin.h"
+
+#include "util.h"
+
+#include "color.h"
+#include <linux/list.h>
+#include "cache.h"
+#include <linux/rbtree.h>
+#include "symbol.h"
+#include "string.h"
+#include "callchain.h"
+#include "strlist.h"
+#include "values.h"
+
+#include "../perf.h"
+#include "debug.h"
+#include "header.h"
+
+#include "parse-options.h"
+#include "parse-events.h"
+
+#include "thread.h"
+#include "sort.h"
+
+extern struct rb_root hist;
+extern struct rb_root collapse_hists;
+extern struct rb_root output_hists;
+extern unsigned long total;
+extern unsigned long total_mmap;
+extern unsigned long total_comm;
+extern unsigned long total_fork;
+extern unsigned long total_unknown;
+extern unsigned long total_lost;
+
+extern int64_t hist_entry__cmp(struct hist_entry *, struct hist_entry *);
+extern int64_t hist_entry__collapse(struct hist_entry *, struct hist_entry *);
+extern void hist_entry__free(struct hist_entry *);
+extern void collapse__insert_entry(struct hist_entry *);
+extern void collapse__resort(void);
+extern void output__insert_entry(struct hist_entry *, u64);
+extern void output__resort(u64);
+
+#endif	/* __PERF_HIST_H */
-- 
1.6.0.6

