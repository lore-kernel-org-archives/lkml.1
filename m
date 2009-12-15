Return-Path: <linux-kernel-owner+w=401wt.eu-S1759215AbZLOPaZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759215AbZLOPaZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 10:30:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758022AbZLOPaM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 10:30:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57113 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754228AbZLOP2M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 10:28:12 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip 07/14] perf tools: Add for_each macros for strlist
To: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>
Cc: Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Jason Baron <jbaron@redhat.com>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Date: Tue, 15 Dec 2009 10:31:56 -0500
Message-ID: <20091215153156.17436.49157.stgit@dhcp-100-2-132.bos.redhat.com>
In-Reply-To: <20091215153106.17436.66584.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20091215153106.17436.66584.stgit@dhcp-100-2-132.bos.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add for_each iteration macros for strlist. This patch
introduces strlist__for_each() and strlist__for_each_safe(),
both are similar to list_for_each() and list_for_each_safe().

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Frank Ch. Eigler <fche@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jason Baron <jbaron@redhat.com>
Cc: K.Prasad <prasad@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---

 tools/perf/util/strlist.h |   34 ++++++++++++++++++++++++++++++++++
 1 files changed, 34 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/strlist.h b/tools/perf/util/strlist.h
index 59091c7..3ba8390 100644
--- a/tools/perf/util/strlist.h
+++ b/tools/perf/util/strlist.h
@@ -40,5 +40,39 @@ static inline unsigned int strlist__nr_entries(const struct strlist *self)
 	return self->nr_entries;
 }
 
+/* For strlist iteration */
+static inline struct str_node *strlist__first(struct strlist *self)
+{
+	struct rb_node *rn = rb_first(&self->entries);
+	return rn ? rb_entry(rn, struct str_node, rb_node) : NULL;
+}
+static inline struct str_node *strlist__next(struct str_node *sn)
+{
+	struct rb_node *rn;
+	if (!sn)
+		return NULL;
+	rn = rb_next(&sn->rb_node);
+	return rn ? rb_entry(rn, struct str_node, rb_node) : NULL;
+}
+
+/**
+ * strlist_for_each      - iterate over a strlist
+ * @pos:	the &struct str_node to use as a loop cursor.
+ * @self:	the &struct strlist for loop.
+ */
+#define strlist__for_each(pos, self)	\
+	for (pos = strlist__first(self); pos; pos = strlist__next(pos))
+
+/**
+ * strlist_for_each_safe - iterate over a strlist safe against removal of
+ *                         str_node
+ * @pos:	the &struct str_node to use as a loop cursor.
+ * @n:		another &struct str_node to use as temporary storage.
+ * @self:	the &struct strlist for loop.
+ */
+#define strlist__for_each_safe(pos, n, self)	\
+	for (pos = strlist__first(self), n = strlist__next(pos); pos;\
+	     pos = n, n = strlist__next(n))
+
 int strlist__parse_list(struct strlist *self, const char *s);
 #endif /* __PERF_STRLIST_H */


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
