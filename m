Return-Path: <linux-kernel-owner+w=401wt.eu-S933491AbZLOT2a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933491AbZLOT2a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 14:28:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933434AbZLOT21
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 14:28:27 -0500
Received: from hera.kernel.org ([140.211.167.34]:50939 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933429AbZLOT2Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 14:28:24 -0500
Date: Tue, 15 Dec 2009 19:26:12 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: acme@redhat.com, mingo@redhat.com, peterz@infradead.org,
       fweisbec@gmail.com, dle-develop@lists.sourceforge.net,
       rostedt@goodmis.org, jbaron@redhat.com, tglx@linutronix.de,
       mhiramat@redhat.com, systemtap@sources.redhat.com,
       linux-kernel@vger.kernel.org, hpa@zytor.com, paulus@samba.org,
       fche@redhat.com, jkenisto@us.ibm.com, hch@infradead.org,
       ananth@in.ibm.com, srikar@linux.vnet.ibm.com, mingo@elte.hu,
       prasad@linux.vnet.ibm.com
Reply-To: mingo@redhat.com, acme@redhat.com, peterz@infradead.org,
       fweisbec@gmail.com, dle-develop@lists.sourceforge.net,
       rostedt@goodmis.org, jbaron@redhat.com, tglx@linutronix.de,
       mhiramat@redhat.com, systemtap@sources.redhat.com,
       linux-kernel@vger.kernel.org, hpa@zytor.com, paulus@samba.org,
       fche@redhat.com, jkenisto@us.ibm.com, hch@infradead.org,
       ananth@in.ibm.com, srikar@linux.vnet.ibm.com, prasad@linux.vnet.ibm.com,
       mingo@elte.hu
In-Reply-To: <20091215153156.17436.49157.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20091215153156.17436.49157.stgit@dhcp-100-2-132.bos.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools: Add for_each macros for strlist
Message-ID: <tip-abf5ef72477f9fb559a8a034fd6e6c397bb37e1f@git.kernel.org>
Git-Commit-ID: abf5ef72477f9fb559a8a034fd6e6c397bb37e1f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  abf5ef72477f9fb559a8a034fd6e6c397bb37e1f
Gitweb:     http://git.kernel.org/tip/abf5ef72477f9fb559a8a034fd6e6c397bb37e1f
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Tue, 15 Dec 2009 10:31:56 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 15 Dec 2009 20:22:02 +0100

perf tools: Add for_each macros for strlist

Add for_each iteration macros for strlist. This patch
introduces strlist__for_each() and strlist__for_each_safe(),
both are similar to list_for_each() and list_for_each_safe().

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Frank Ch. Eigler <fche@redhat.com>
Cc: Jason Baron <jbaron@redhat.com>
Cc: K.Prasad <prasad@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: systemtap <systemtap@sources.redhat.com>
Cc: DLE <dle-develop@lists.sourceforge.net>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <20091215153156.17436.49157.stgit@dhcp-100-2-132.bos.redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
