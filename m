Return-Path: <linux-kernel-owner+w=401wt.eu-S1757369AbYB0NyV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757369AbYB0NyV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 08:54:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752861AbYB0NyM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 08:54:12 -0500
Received: from sacred.ru ([62.205.161.221]:45233 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752913AbYB0NyL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 08:54:11 -0500
Message-ID: <47C56B81.8000101@openvz.org>
Date: Wed, 27 Feb 2008 16:54:09 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] Sysctl: add the ->permissions callback on the ctl_table_root
References: <47C569DE.9060208@openvz.org>
In-Reply-To: <47C569DE.9060208@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Wed, 27 Feb 2008 16:53:59 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When reading from/writing to some table, a root, which this table 
came from, may affect this table's permissions, depending on who is 
working with the table.

The core hunk is at the bottom of this patch. All the rest is
just pushing the ctl_table_root argument up to the sysctl_perm()
function.

This will be mostly (only?) used in the net sysctls.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
---
 fs/proc/proc_sysctl.c  |    4 ++--
 include/linux/sysctl.h |    7 ++++++-
 kernel/sysctl.c        |   25 ++++++++++++++++++-------
 3 files changed, 26 insertions(+), 10 deletions(-)

diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
index 5e31585..5acc001 100644
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -190,7 +190,7 @@ static ssize_t proc_sys_call_handler(struct file *filp, void __user *buf,
 	 * and won't be until we finish.
 	 */
 	error = -EPERM;
-	if (sysctl_perm(table, write ? MAY_WRITE : MAY_READ))
+	if (sysctl_perm(head->root, table, write ? MAY_WRITE : MAY_READ))
 		goto out;
 
 	/* careful: calling conventions are nasty here */
@@ -388,7 +388,7 @@ static int proc_sys_permission(struct inode *inode, int mask, struct nameidata *
 		goto out;
 
 	/* Use the permissions on the sysctl table entry */
-	error = sysctl_perm(table, mask);
+	error = sysctl_perm(head->root, table, mask);
 out:
 	sysctl_head_finish(head);
 	return error;
diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
index 8e50196..3239561 100644
--- a/include/linux/sysctl.h
+++ b/include/linux/sysctl.h
@@ -945,11 +945,14 @@ enum
 /* For the /proc/sys support */
 struct ctl_table;
 struct nsproxy;
+struct ctl_table_root;
+
 extern struct ctl_table_header *sysctl_head_next(struct ctl_table_header *prev);
 extern struct ctl_table_header *__sysctl_head_next(struct nsproxy *namespaces,
 						struct ctl_table_header *prev);
 extern void sysctl_head_finish(struct ctl_table_header *prev);
-extern int sysctl_perm(struct ctl_table *table, int op);
+extern int sysctl_perm(struct ctl_table_root *root,
+		struct ctl_table *table, int op);
 
 typedef struct ctl_table ctl_table;
 
@@ -1049,6 +1052,8 @@ struct ctl_table_root {
 	struct list_head header_list;
 	struct list_head *(*lookup)(struct ctl_table_root *root,
 					   struct nsproxy *namespaces);
+	int (*permissions)(struct ctl_table_root *root,
+			struct nsproxy *namespaces, struct ctl_table *table);
 };
 
 /* struct ctl_table_header is used to maintain dynamic lists of
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 27aa50a..12b793a 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1454,7 +1454,8 @@ void register_sysctl_root(struct ctl_table_root *root)
 
 #ifdef CONFIG_SYSCTL_SYSCALL
 /* Perform the actual read/write of a sysctl table entry. */
-static int do_sysctl_strategy(struct ctl_table *table,
+static int do_sysctl_strategy(struct ctl_table_root *root,
+			struct ctl_table *table,
 			int __user *name, int nlen,
 			void __user *oldval, size_t __user *oldlenp,
 			void __user *newval, size_t newlen)
@@ -1465,7 +1466,7 @@ static int do_sysctl_strategy(struct ctl_table *table,
 		op |= 004;
 	if (newval)
 		op |= 002;
-	if (sysctl_perm(table, op))
+	if (sysctl_perm(root, table, op))
 		return -EPERM;
 
 	if (table->strategy) {
@@ -1491,6 +1492,7 @@ static int do_sysctl_strategy(struct ctl_table *table,
 static int parse_table(int __user *name, int nlen,
 		       void __user *oldval, size_t __user *oldlenp,
 		       void __user *newval, size_t newlen,
+		       struct ctl_table_root *root,
 		       struct ctl_table *table)
 {
 	int n;
@@ -1505,14 +1507,14 @@ repeat:
 		if (n == table->ctl_name) {
 			int error;
 			if (table->child) {
-				if (sysctl_perm(table, 001))
+				if (sysctl_perm(root, table, 001))
 					return -EPERM;
 				name++;
 				nlen--;
 				table = table->child;
 				goto repeat;
 			}
-			error = do_sysctl_strategy(table, name, nlen,
+			error = do_sysctl_strategy(root, table, name, nlen,
 						   oldval, oldlenp,
 						   newval, newlen);
 			return error;
@@ -1538,7 +1540,8 @@ int do_sysctl(int __user *name, int nlen, void __user *oldval, size_t __user *ol
 	for (head = sysctl_head_next(NULL); head;
 			head = sysctl_head_next(head)) {
 		error = parse_table(name, nlen, oldval, oldlenp, 
-					newval, newlen, head->ctl_table);
+					newval, newlen,
+					head->root, head->ctl_table);
 		if (error != -ENOTDIR) {
 			sysctl_head_finish(head);
 			break;
@@ -1584,13 +1587,21 @@ static int test_perm(int mode, int op)
 	return -EACCES;
 }
 
-int sysctl_perm(struct ctl_table *table, int op)
+int sysctl_perm(struct ctl_table_root *root, struct ctl_table *table, int op)
 {
 	int error;
+	int mode;
+
 	error = security_sysctl(table, op);
 	if (error)
 		return error;
-	return test_perm(table->mode, op);
+
+	if (root->permissions)
+		mode = root->permissions(root, current->nsproxy, table);
+	else
+		mode = table->mode;
+
+	return test_perm(mode, op);
 }
 
 static void sysctl_set_parent(struct ctl_table *parent, struct ctl_table *table)
-- 
1.5.3.4

