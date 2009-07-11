Return-Path: <linux-kernel-owner+w=401wt.eu-S1754681AbZGKPSw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681AbZGKPSw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 11:18:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751489AbZGKPSm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 11:18:42 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:35222 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211AbZGKPSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 11:18:41 -0400
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH tip 2/5] strlist: Introduce strlist__entry and strlist__nr_entries methods
Date: Sat, 11 Jul 2009 12:18:34 -0300
Message-Id: <1247325517-12272-2-git-send-email-acme@redhat.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1247325517-12272-1-git-send-email-acme@redhat.com>
References: <1247325517-12272-1-git-send-email-acme@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The strlist__entry method allows accessing strlists like an array, will
be used in the 'perf report' to access the first entry.

We now keep the nr_entries so that we can check if we have just one
entry, will be used in 'perf report' to improve the output by showing
just at the top when we have just, say, one DSO.

While at it use nr_entries to optimize strlist__is_empty by not using
the far more costly rb_first based implementation.

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/strlist.c |   20 ++++++++++++++++++--
 tools/perf/util/strlist.h |   11 +++++++++--
 2 files changed, 27 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/strlist.c b/tools/perf/util/strlist.c
index 025a78e..7ad3817 100644
--- a/tools/perf/util/strlist.c
+++ b/tools/perf/util/strlist.c
@@ -64,6 +64,7 @@ int strlist__add(struct strlist *self, const char *new_entry)
 
 	rb_link_node(&sn->rb_node, parent, p);
 	rb_insert_color(&sn->rb_node, &self->entries);
+	++self->nr_entries;
 
 	return 0;
 }
@@ -155,8 +156,9 @@ struct strlist *strlist__new(bool dupstr, const char *slist)
 	struct strlist *self = malloc(sizeof(*self));
 
 	if (self != NULL) {
-		self->entries = RB_ROOT;
-		self->dupstr = dupstr;
+		self->entries	 = RB_ROOT;
+		self->dupstr	 = dupstr;
+		self->nr_entries = 0;
 		if (slist && strlist__parse_list(self, slist) != 0)
 			goto out_error;
 	}
@@ -182,3 +184,17 @@ void strlist__delete(struct strlist *self)
 		free(self);
 	}
 }
+
+struct str_node *strlist__entry(const struct strlist *self, unsigned int idx)
+{
+	struct rb_node *nd;
+
+	for (nd = rb_first(&self->entries); nd; nd = rb_next(nd)) {
+		struct str_node *pos = rb_entry(nd, struct str_node, rb_node);
+
+		if (!idx--)
+			return pos;
+	}
+
+	return NULL;
+}
diff --git a/tools/perf/util/strlist.h b/tools/perf/util/strlist.h
index 2fdcfee..921818e 100644
--- a/tools/perf/util/strlist.h
+++ b/tools/perf/util/strlist.h
@@ -11,7 +11,8 @@ struct str_node {
 
 struct strlist {
 	struct rb_root entries;
-	bool dupstr;
+	unsigned int   nr_entries;
+	bool	       dupstr;
 };
 
 struct strlist *strlist__new(bool dupstr, const char *slist);
@@ -21,11 +22,17 @@ void strlist__remove(struct strlist *self, struct str_node *sn);
 int strlist__load(struct strlist *self, const char *filename);
 int strlist__add(struct strlist *self, const char *str);
 
+struct str_node *strlist__entry(const struct strlist *self, unsigned int idx);
 bool strlist__has_entry(struct strlist *self, const char *entry);
 
 static inline bool strlist__empty(const struct strlist *self)
 {
-	return rb_first(&self->entries) == NULL;
+	return self->nr_entries == 0;
+}
+
+static inline unsigned int strlist__nr_entries(const struct strlist *self)
+{
+	return self->nr_entries;
 }
 
 int strlist__parse_list(struct strlist *self, const char *s);
-- 
1.6.2.5

