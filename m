Return-Path: <linux-kernel-owner+w=401wt.eu-S1758897AbXHXPjr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758897AbXHXPjr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 11:39:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752951AbXHXPjj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 11:39:39 -0400
Received: from bc.sympatico.ca ([209.226.175.184]:44316 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751245AbXHXPji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 11:39:38 -0400
Date: Fri, 24 Aug 2007 11:39:33 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Randy Dunlap <rddunlap@osdl.org>, Martin Bligh <mbligh@google.com>
Subject: [PATCH] Sort module list - use ppos instead of m->private
Message-ID: <20070824153933.GA21226@Krystal>
References: <20070812150844.305211039@polymtl.ca> <20070812151039.996081605@polymtl.ca> <20070815033945.GA13134@mail.ustc.edu.cn> <20070815041845.GJ21089@ftp.linux.org.uk> <20070815063741.GB5175@mail.ustc.edu.cn> <20070815065301.GK21089@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070815065301.GK21089@ftp.linux.org.uk>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 11:38:49 up 25 days, 15:57,  5 users,  load average: 0.63, 0.74, 0.74
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sort modules list - use ppos instead of m->private

When reading the data by small chunks (i.e. byte by byte), the index (ppos) is
incremented by seq_read() directly and no "next" callback is called when going
to the next module.

Therefore, use ppos instead of m->private to deal with the fact that this index
is incremented directly to pass to the next module in seq_read() after the
buffer has been emptied.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 fs/seq_file.c            |   17 +++++++++--------
 include/linux/seq_file.h |    4 ++--
 kernel/module.c          |    6 ++----
 3 files changed, 13 insertions(+), 14 deletions(-)

Index: linux-2.6-lttng/kernel/module.c
===================================================================
--- linux-2.6-lttng.orig/kernel/module.c	2007-08-24 11:34:36.000000000 -0400
+++ linux-2.6-lttng/kernel/module.c	2007-08-24 11:35:40.000000000 -0400
@@ -2418,14 +2418,12 @@ unsigned long module_kallsyms_lookup_nam
 static void *m_start(struct seq_file *m, loff_t *pos)
 {
 	mutex_lock(&module_mutex);
-	if (!*pos)
-		m->private = NULL;
-	return seq_sorted_list_start(&modules, m->private);
+	return seq_sorted_list_start(&modules, (void*)(long)pos);
 }
 
 static void *m_next(struct seq_file *m, void *p, loff_t *pos)
 {
-	return seq_sorted_list_next(p, &modules, &m->private);
+	return seq_sorted_list_next(p, &modules, (void**)pos);
 }
 
 static void m_stop(struct seq_file *m, void *p)
Index: linux-2.6-lttng/include/linux/seq_file.h
===================================================================
--- linux-2.6-lttng.orig/include/linux/seq_file.h	2007-08-24 11:34:01.000000000 -0400
+++ linux-2.6-lttng/include/linux/seq_file.h	2007-08-24 11:34:59.000000000 -0400
@@ -73,9 +73,9 @@ extern struct list_head *seq_list_next(v
  * seq_sorted_list_start_head().
  */
 extern struct list_head *seq_sorted_list_start(struct list_head *head,
-		void *pos);
+		void **ppos);
 extern struct list_head *seq_sorted_list_start_head(struct list_head *head,
-		void *pos);
+		void **ppos);
 /*
  * next must be called with an existing p node
  */
Index: linux-2.6-lttng/fs/seq_file.c
===================================================================
--- linux-2.6-lttng.orig/fs/seq_file.c	2007-08-24 11:34:01.000000000 -0400
+++ linux-2.6-lttng/fs/seq_file.c	2007-08-24 11:34:59.000000000 -0400
@@ -501,27 +501,28 @@ struct list_head *seq_list_next(void *v,
 
 EXPORT_SYMBOL(seq_list_next);
 
-struct list_head *seq_sorted_list_start(struct list_head *head, void *pos)
+struct list_head *seq_sorted_list_start(struct list_head *head, void **ppos)
 {
 	struct list_head *lh;
 
 	list_for_each(lh, head)
-		if ((void*)lh >= pos)
-			return lh;
+		if ((void*)lh >= *ppos)
+			return *ppos = lh;
 	return NULL;
 }
 
 EXPORT_SYMBOL(seq_sorted_list_start);
 
-struct list_head *seq_sorted_list_start_head(struct list_head *head, void *pos)
+struct list_head *seq_sorted_list_start_head(struct list_head *head,
+		void **ppos)
 {
 	struct list_head *lh;
 
-	if (!pos)
-		return head;
+	if (!ppos)
+		return *ppos = head;
 	list_for_each(lh, head)
-		if ((void*)lh >= pos)
-			return lh->prev;
+		if ((void*)lh >= *ppos)
+			return *ppos = lh->prev;
 	return NULL;
 }
 
-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
