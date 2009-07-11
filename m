Return-Path: <linux-kernel-owner+w=401wt.eu-S1752655AbZGKRZr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655AbZGKRZr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 13:25:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751748AbZGKRZk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 13:25:40 -0400
Received: from hera.kernel.org ([140.211.167.34]:39225 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751564AbZGKRZj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 13:25:39 -0400
Date: Sat, 11 Jul 2009 17:25:06 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1247325517-12272-2-git-send-email-acme@redhat.com>
References: <1247325517-12272-2-git-send-email-acme@redhat.com>
Subject: [tip:perfcounters/core] strlist: Introduce strlist__entry and strlist__nr_entries methods
Message-ID: <tip-27d0fd410c3cee00ece2e55f4354a7a9ec1a6a6a@git.kernel.org>
Git-Commit-ID: 27d0fd410c3cee00ece2e55f4354a7a9ec1a6a6a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 11 Jul 2009 17:25:07 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  27d0fd410c3cee00ece2e55f4354a7a9ec1a6a6a
Gitweb:     http://git.kernel.org/tip/27d0fd410c3cee00ece2e55f4354a7a9ec1a6a6a
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Sat, 11 Jul 2009 12:18:34 -0300
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 11 Jul 2009 19:20:25 +0200

strlist: Introduce strlist__entry and strlist__nr_entries methods

The strlist__entry method allows accessing strlists like an
array, will be used in the 'perf report' to access the first
entry.

We now keep the nr_entries so that we can check if we have just
one entry, will be used in 'perf report' to improve the output
by showing just at the top when we have just, say, one DSO.

While at it use nr_entries to optimize strlist__is_empty by not
using the far more costly rb_first based implementation.

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <1247325517-12272-2-git-send-email-acme@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


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
