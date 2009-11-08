Return-Path: <linux-kernel-owner+w=401wt.eu-S1754421AbZKHM0n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754421AbZKHM0n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 07:26:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754325AbZKHM0l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 07:26:41 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:59084 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754018AbZKHMW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 07:22:26 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: linux-kernel@vger.kernel.org
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 07/23] sysctl: Don't look at ctl_name and strategy in the generic code
Date: Sun,  8 Nov 2009 04:21:54 -0800
Message-Id: <1257682930-31401-7-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.6.5.2.143.g8cc62
In-Reply-To: <m14op5jjo4.fsf@fess.ebiederm.org>
References: <m14op5jjo4.fsf@fess.ebiederm.org>
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

The ctl_name and strategy fields are unused, now that sys_sysctl
is a compatibility wrapper around /proc/sys.  No longer looking
at them in the generic code is effectively what we are doing
now and provides the guarantee that during further cleanups
we can just remove references to those fields and everything
will work ok.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/proc/proc_sysctl.c  |    4 ++--
 include/linux/sysctl.h |   17 ++---------------
 kernel/sysctl.c        |   29 +++++++----------------------
 3 files changed, 11 insertions(+), 39 deletions(-)

diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
index f667e8a..6ff9981 100644
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -48,7 +48,7 @@ out:
 static struct ctl_table *find_in_table(struct ctl_table *p, struct qstr *name)
 {
 	int len;
-	for ( ; p->ctl_name || p->procname; p++) {
+	for ( ; p->procname; p++) {
 
 		if (!p->procname)
 			continue;
@@ -218,7 +218,7 @@ static int scan(struct ctl_table_header *head, ctl_table *table,
 		void *dirent, filldir_t filldir)
 {
 
-	for (; table->ctl_name || table->procname; table++, (*pos)++) {
+	for (; table->procname; table++, (*pos)++) {
 		int res;
 
 		/* Can't do anything without a proc name */
diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
index 82c32b8..7c4aabc 100644
--- a/include/linux/sysctl.h
+++ b/include/linux/sysctl.h
@@ -1005,8 +1005,8 @@ extern ctl_handler sysctl_ms_jiffies;
 
 /*
  * Register a set of sysctl names by calling register_sysctl_table
- * with an initialised array of struct ctl_table's.  An entry with zero
- * ctl_name and NULL procname terminates the table.  table->de will be
+ * with an initialised array of struct ctl_table's.  An entry with 
+ * NULL procname terminates the table.  table->de will be
  * set up by the registration and need not be initialised in advance.
  *
  * sysctl names can be mirrored automatically under /proc/sys.  The
@@ -1019,24 +1019,11 @@ extern ctl_handler sysctl_ms_jiffies;
  * under /proc; non-leaf nodes will be represented by directories.  A
  * null procname disables /proc mirroring at this node.
  *
- * sysctl entries with a zero ctl_name will not be available through
- * the binary sysctl interface.
- *
  * sysctl(2) can automatically manage read and write requests through
  * the sysctl table.  The data and maxlen fields of the ctl_table
  * struct enable minimal validation of the values being written to be
  * performed, and the mode field allows minimal authentication.
  * 
- * More sophisticated management can be enabled by the provision of a
- * strategy routine with the table entry.  This will be called before
- * any automatic read or write of the data is performed.
- * 
- * The strategy routine may return:
- * <0: Error occurred (error is passed to user process)
- * 0:  OK - proceed with automatic read or write.
- * >0: OK - read or write has been done by the strategy routine, so 
- *     return immediately.
- * 
  * There must be a proc_handler routine for any terminal nodes
  * mirrored under /proc/sys (non-terminals are handled by a built-in
  * directory handler).  Several default handlers are available to
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index f6dacc3..b6b6eb1 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1618,7 +1618,7 @@ int sysctl_perm(struct ctl_table_root *root, struct ctl_table *table, int op)
 
 static void sysctl_set_parent(struct ctl_table *parent, struct ctl_table *table)
 {
-	for (; table->ctl_name || table->procname; table++) {
+	for (; table->procname; table++) {
 		table->parent = parent;
 		if (table->child)
 			sysctl_set_parent(table, table->child);
@@ -1650,11 +1650,11 @@ static struct ctl_table *is_branch_in(struct ctl_table *branch,
 		return NULL;
 
 	/* ... and nothing else */
-	if (branch[1].procname || branch[1].ctl_name)
+	if (branch[1].procname)
 		return NULL;
 
 	/* table should contain subdirectory with the same name */
-	for (p = table; p->procname || p->ctl_name; p++) {
+	for (p = table; p->procname; p++) {
 		if (!p->child)
 			continue;
 		if (p->procname && strcmp(p->procname, s) == 0)
@@ -1699,8 +1699,7 @@ static void try_attach(struct ctl_table_header *p, struct ctl_table_header *q)
  *
  * The members of the &struct ctl_table structure are used as follows:
  *
- * ctl_name - This is the numeric sysctl value used by sysctl(2). The number
- *            must be unique within that level of sysctl
+ * ctl_name - Dead
  *
  * procname - the name of the sysctl file under /proc/sys. Set to %NULL to not
  *            enter a sysctl file
@@ -1716,7 +1715,7 @@ static void try_attach(struct ctl_table_header *p, struct ctl_table_header *q)
  *
  * proc_handler - the text handler routine (described below)
  *
- * strategy - the strategy routine (described below)
+ * strategy - Dead
  *
  * de - for internal use by the sysctl routines
  *
@@ -1730,19 +1729,6 @@ static void try_attach(struct ctl_table_header *p, struct ctl_table_header *q)
  * struct enable minimal validation of the values being written to be
  * performed, and the mode field allows minimal authentication.
  *
- * More sophisticated management can be enabled by the provision of a
- * strategy routine with the table entry.  This will be called before
- * any automatic read or write of the data is performed.
- *
- * The strategy routine may return
- *
- * < 0 - Error occurred (error is passed to user process)
- *
- * 0   - OK - proceed with automatic read or write.
- *
- * > 0 - OK - read or write has been done by the strategy routine, so
- *       return immediately.
- *
  * There must be a proc_handler routine for any terminal nodes
  * mirrored under /proc/sys (non-terminals are handled by a built-in
  * directory handler).  Several default handlers are available to
@@ -1769,13 +1755,13 @@ struct ctl_table_header *__register_sysctl_paths(
 	struct ctl_table_set *set;
 
 	/* Count the path components */
-	for (npath = 0; path[npath].ctl_name || path[npath].procname; ++npath)
+	for (npath = 0; path[npath].procname; ++npath)
 		;
 
 	/*
 	 * For each path component, allocate a 2-element ctl_table array.
 	 * The first array element will be filled with the sysctl entry
-	 * for this, the second will be the sentinel (ctl_name == 0).
+	 * for this, the second will be the sentinel (procname == 0).
 	 *
 	 * We allocate everything in one go so that we don't have to
 	 * worry about freeing additional memory in unregister_sysctl_table.
@@ -1792,7 +1778,6 @@ struct ctl_table_header *__register_sysctl_paths(
 	for (n = 0; n < npath; ++n, ++path) {
 		/* Copy the procname */
 		new->procname = path->procname;
-		new->ctl_name = path->ctl_name;
 		new->mode     = 0555;
 
 		*prevp = new;
-- 
1.6.5.2.143.g8cc62

