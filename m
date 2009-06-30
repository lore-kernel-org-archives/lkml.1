Return-Path: <linux-kernel-owner+w=401wt.eu-S1757267AbZF3WBq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757267AbZF3WBq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 18:01:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754040AbZF3WB1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 18:01:27 -0400
Received: from casper.infradead.org ([85.118.1.10]:59029 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753132AbZF3WB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 18:01:26 -0400
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH tip 1/3] perf_counter tools: Add --dsos parameter to 'perf report'
Date: Tue, 30 Jun 2009 19:01:20 -0300
Message-Id: <1246399282-20934-2-git-send-email-acme@redhat.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1246399282-20934-1-git-send-email-acme@redhat.com>
References: <1246399282-20934-1-git-send-email-acme@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So that we can filter by dso. Symbols in other dsos won't be accounted
for.

Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-report.txt |    4 +
 tools/perf/Makefile                      |    2 +
 tools/perf/builtin-report.c              |   16 +++
 tools/perf/util/strlist.c                |  184 ++++++++++++++++++++++++++++++
 tools/perf/util/strlist.h                |   32 +++++
 5 files changed, 238 insertions(+), 0 deletions(-)
 create mode 100644 tools/perf/util/strlist.c
 create mode 100644 tools/perf/util/strlist.h

diff --git a/tools/perf/Documentation/perf-report.txt b/tools/perf/Documentation/perf-report.txt
index 40c1db8..13d85ca 100644
--- a/tools/perf/Documentation/perf-report.txt
+++ b/tools/perf/Documentation/perf-report.txt
@@ -20,6 +20,10 @@ OPTIONS
 -i::
 --input=::
         Input file name. (default: perf.data)
+-d::
+--dsos=::
+	Only consider symbols in these dsos. CSV that understands
+	file://filename entries.
 
 SEE ALSO
 --------
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 1c1296d..9c6d0ae 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -301,6 +301,7 @@ LIB_H += util/util.h
 LIB_H += util/help.h
 LIB_H += util/strbuf.h
 LIB_H += util/string.h
+LIB_H += util/strlist.h
 LIB_H += util/run-command.h
 LIB_H += util/sigchain.h
 LIB_H += util/symbol.h
@@ -322,6 +323,7 @@ LIB_OBJS += util/run-command.o
 LIB_OBJS += util/quote.o
 LIB_OBJS += util/strbuf.o
 LIB_OBJS += util/string.o
+LIB_OBJS += util/strlist.o
 LIB_OBJS += util/usage.o
 LIB_OBJS += util/wrapper.o
 LIB_OBJS += util/sigchain.o
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index ed391db..7c6b6e7 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -16,6 +16,7 @@
 #include "util/symbol.h"
 #include "util/string.h"
 #include "util/callchain.h"
+#include "util/strlist.h"
 
 #include "perf.h"
 #include "util/header.h"
@@ -32,6 +33,8 @@ static char		*vmlinux = NULL;
 
 static char		default_sort_order[] = "comm,dso";
 static char		*sort_order = default_sort_order;
+static char		*dso_list_str;
+static struct strlist	*dso_list;
 
 static int		input;
 static int		show_mask = SHOW_KERNEL | SHOW_USER | SHOW_HV;
@@ -1272,6 +1275,9 @@ process_sample_event(event_t *event, unsigned long offset, unsigned long head)
 	if (show & show_mask) {
 		struct symbol *sym = resolve_symbol(thread, &map, &dso, &ip);
 
+		if (dso_list && dso && dso->name && !strlist__has_entry(dso_list, dso->name))
+			return 0;
+
 		if (hist_entry__add(thread, map, dso, sym, ip, chain, level, period)) {
 			eprintf("problem incrementing symbol count, skipping event\n");
 			return -1;
@@ -1659,6 +1665,8 @@ static const struct option options[] = {
 	OPT_BOOLEAN('x', "exclude-other", &exclude_other,
 		    "Only display entries with parent-match"),
 	OPT_BOOLEAN('c', "callchain", &callchain, "Display callchains"),
+	OPT_STRING('d', "dsos", &dso_list_str, "dso[,dso...]",
+		   "only consider symbols in these dsos"),
 	OPT_END()
 };
 
@@ -1698,6 +1706,14 @@ int cmd_report(int argc, const char **argv, const char *prefix)
 	if (argc)
 		usage_with_options(report_usage, options);
 
+	if (dso_list_str) {
+		dso_list = strlist__new(true, dso_list_str);
+		if (!dso_list) {
+			fprintf(stderr, "problems parsing dso list\n");
+			exit(129);
+		}
+	}
+
 	setup_pager();
 
 	return __cmd_report();
diff --git a/tools/perf/util/strlist.c b/tools/perf/util/strlist.c
new file mode 100644
index 0000000..6f334f1
--- /dev/null
+++ b/tools/perf/util/strlist.c
@@ -0,0 +1,184 @@
+/*
+ * (c) 2009 Arnaldo Carvalho de Melo <acme@redhat.com>
+ *
+ * Licensed under the GPLv2.
+ */
+
+#include "strlist.h"
+#include <errno.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+
+static struct str_node *str_node__new(const char *s, bool dupstr)
+{
+	struct str_node *self = malloc(sizeof(*self));
+
+	if (self != NULL){
+		if (dupstr) {
+			s = strdup(s);
+			if (s == NULL)
+				goto out_delete;
+		}
+		self->s = s;
+	}
+
+	return self;
+
+out_delete:
+	free(self);
+	return NULL;
+}
+
+static void str_node__delete(struct str_node *self, bool dupstr)
+{
+	if (dupstr)
+		free((void *)self->s);
+	free(self);
+}
+
+int strlist__add(struct strlist *self, const char *new_entry)
+{
+	struct rb_node **p = &self->entries.rb_node;
+	struct rb_node *parent = NULL;
+	struct str_node *sn;
+
+	while (*p != NULL) {
+		int rc;
+
+		parent = *p;
+		sn = rb_entry(parent, struct str_node, rb_node);
+		rc = strcmp(sn->s, new_entry);
+
+		if (rc > 0)
+			p = &(*p)->rb_left;
+		else if (rc < 0)
+			p = &(*p)->rb_right;
+		else
+			return -EEXIST;
+	}
+
+	sn = str_node__new(new_entry, self->dupstr);
+	if (sn == NULL)
+		return -ENOMEM;
+
+	rb_link_node(&sn->rb_node, parent, p);
+	rb_insert_color(&sn->rb_node, &self->entries);
+
+	return 0;
+}
+
+int strlist__load(struct strlist *self, const char *filename)
+{
+	char entry[1024];
+	int err;
+	FILE *fp = fopen(filename, "r");
+
+	if (fp == NULL)
+		return errno;
+
+	while (fgets(entry, sizeof(entry), fp) != NULL) {
+		const size_t len = strlen(entry);
+
+		if (len == 0)
+			continue;
+		entry[len - 1] = '\0';
+
+		err = strlist__add(self, entry);
+		if (err != 0)
+			goto out;
+	}
+
+	err = 0;
+out:
+	fclose(fp);
+	return err;
+}
+
+void strlist__remove(struct strlist *self, struct str_node *sn)
+{
+	rb_erase(&sn->rb_node, &self->entries);
+	str_node__delete(sn, self->dupstr);
+}
+
+bool strlist__has_entry(struct strlist *self, const char *entry)
+{
+	struct rb_node **p = &self->entries.rb_node;
+	struct rb_node *parent = NULL;
+
+	while (*p != NULL) {
+		struct str_node *sn;
+		int rc;
+
+		parent = *p;
+		sn = rb_entry(parent, struct str_node, rb_node);
+		rc = strcmp(sn->s, entry);
+
+		if (rc > 0)
+			p = &(*p)->rb_left;
+		else if (rc < 0)
+			p = &(*p)->rb_right;
+		else
+			return true;
+	}
+
+	return false;
+}
+
+static int strlist__parse_list_entry(struct strlist *self, const char *s)
+{
+	if (strncmp(s, "file://", 7) == 0)
+		return strlist__load(self, s + 7);
+
+	return strlist__add(self, s);
+}
+
+int strlist__parse_list(struct strlist *self, const char *s)
+{
+	char *sep;
+	int err;
+
+	while ((sep = strchr(s, ',')) != NULL) {
+		*sep = '\0';
+		err = strlist__parse_list_entry(self, s);
+		*sep = ',';
+		if (err != 0)
+			return err;
+		s = sep + 1;
+	}
+
+	return *s ? strlist__parse_list_entry(self, s) : 0;
+}
+
+struct strlist *strlist__new(bool dupstr, const char *slist)
+{
+	struct strlist *self = malloc(sizeof(*self));
+
+	if (self != NULL) {
+		self->entries = RB_ROOT;
+		self->dupstr = dupstr;
+		if (slist && strlist__parse_list(self, slist) != 0)
+			goto out_error;
+	}
+
+	return self;
+out_error:
+	free(self);
+	return NULL;
+}
+
+void strlist__delete(struct strlist *self)
+{
+	if (self != NULL) {
+		struct str_node *pos;
+		struct rb_node *next = rb_first(&self->entries);
+
+		while (next) {
+			pos = rb_entry(next, struct str_node, rb_node);
+			next = rb_next(&pos->rb_node);
+			strlist__remove(self, pos);
+		}
+		self->entries = RB_ROOT;
+		free(self);
+	}
+}
diff --git a/tools/perf/util/strlist.h b/tools/perf/util/strlist.h
new file mode 100644
index 0000000..2fb117f
--- /dev/null
+++ b/tools/perf/util/strlist.h
@@ -0,0 +1,32 @@
+#ifndef STRLIST_H_
+#define STRLIST_H_
+
+#include "rbtree.h"
+#include <stdbool.h>
+
+struct str_node {
+	struct rb_node rb_node;
+	const char     *s;
+};
+
+struct strlist {
+	struct rb_root entries;
+	bool dupstr;
+};
+
+struct strlist *strlist__new(bool dupstr, const char *slist);
+void strlist__delete(struct strlist *self);
+
+void strlist__remove(struct strlist *self, struct str_node *sn);
+int strlist__load(struct strlist *self, const char *filename);
+int strlist__add(struct strlist *self, const char *str);
+
+bool strlist__has_entry(struct strlist *self, const char *entry);
+
+static inline bool strlist__empty(const struct strlist *self)
+{
+	return rb_first(&self->entries) == NULL;
+}
+
+int strlist__parse_list(struct strlist *self, const char *s);
+#endif /* STRLIST_H_ */
-- 
1.6.2.5

