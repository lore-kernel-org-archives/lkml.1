Return-Path: <linux-kernel-owner+w=401wt.eu-S933213AbXCHTky@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933213AbXCHTky (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 14:40:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933230AbXCHTkx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 14:40:53 -0500
Received: from pfx2.jmh.fr ([194.153.89.55]:51815 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933213AbXCHTkw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 14:40:52 -0500
From: Eric Dumazet <dada1@cosmosbay.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] procfs : reorder struct pid_dentry to save space on 64bit archs, and constify them
Date: Thu, 8 Mar 2007 20:40:57 +0100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <20070308101947.f77ab27f.akpm@linux-foundation.org>
In-Reply-To: <20070308101947.f77ab27f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_JbG8F83wU2LhxpZ"
Message-Id: <200703082040.57150.dada1@cosmosbay.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_JbG8F83wU2LhxpZ
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

This patches changes the order of fields of struct pid_entry (file 
fs/proc/base.c) in order to avoid a hole on 64bit archs. (8 bytes saved per 
object)

It also changes all pid_entry arrays to be const qualified, to make clear they 
must not be modified.

Before (on x86_64) :

# size fs/proc/base.o
   text    data     bss     dec     hex filename
  15549    2192       0   17741    454d fs/proc/base.o

After :

# size fs/proc/base.o
   text    data     bss     dec     hex filename
  17229     176       0   17405    43fd fs/proc/base.o

Thats 336 bytes saved on kernel size on x86_64

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>

 fs/proc/base.c |   53 +++++++++++++++++++++++------------------------
 1 file changed, 27 insertions(+), 26 deletions(-)

--Boundary-00=_JbG8F83wU2LhxpZ
Content-Type: text/plain;
  charset="iso-8859-1";
  name="pid_entry.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="pid_entry.patch"

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 01f7769..d71135b 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -90,8 +90,8 @@ #include "internal.h"
 #define PROC_NUMBUF 13
 
 struct pid_entry {
-	int len;
 	char *name;
+	int len;
 	mode_t mode;
 	const struct inode_operations *iop;
 	const struct file_operations *fop;
@@ -99,8 +99,8 @@ struct pid_entry {
 };
 
 #define NOD(NAME, MODE, IOP, FOP, OP) {			\
-	.len  = sizeof(NAME) - 1,			\
 	.name = (NAME),					\
+	.len  = sizeof(NAME) - 1,			\
 	.mode = MODE,					\
 	.iop  = IOP,					\
 	.fop  = FOP,					\
@@ -1121,7 +1121,8 @@ static struct dentry_operations pid_dent
 
 /* Lookups */
 
-typedef struct dentry *instantiate_t(struct inode *, struct dentry *, struct task_struct *, void *);
+typedef struct dentry *instantiate_t(struct inode *, struct dentry *,
+				struct task_struct *, const void *);
 
 /*
  * Fill a directory entry.
@@ -1137,7 +1138,7 @@ typedef struct dentry *instantiate_t(str
  */
 static int proc_fill_cache(struct file *filp, void *dirent, filldir_t filldir,
 	char *name, int len,
-	instantiate_t instantiate, struct task_struct *task, void *ptr)
+	instantiate_t instantiate, struct task_struct *task, const void *ptr)
 {
 	struct dentry *child, *dir = filp->f_path.dentry;
 	struct inode *inode;
@@ -1272,9 +1273,9 @@ static struct dentry_operations tid_fd_d
 };
 
 static struct dentry *proc_fd_instantiate(struct inode *dir,
-	struct dentry *dentry, struct task_struct *task, void *ptr)
+	struct dentry *dentry, struct task_struct *task, const void *ptr)
 {
-	unsigned fd = *(unsigned *)ptr;
+	unsigned fd = *(const unsigned *)ptr;
 	struct file *file;
 	struct files_struct *files;
  	struct inode *inode;
@@ -1422,9 +1423,9 @@ static const struct inode_operations pro
 };
 
 static struct dentry *proc_pident_instantiate(struct inode *dir,
-	struct dentry *dentry, struct task_struct *task, void *ptr)
+	struct dentry *dentry, struct task_struct *task, const void *ptr)
 {
-	struct pid_entry *p = ptr;
+	const struct pid_entry *p = ptr;
 	struct inode *inode;
 	struct proc_inode *ei;
 	struct dentry *error = ERR_PTR(-EINVAL);
@@ -1453,13 +1454,13 @@ out:
 
 static struct dentry *proc_pident_lookup(struct inode *dir, 
 					 struct dentry *dentry,
-					 struct pid_entry *ents,
+					 const struct pid_entry *ents,
 					 unsigned int nents)
 {
 	struct inode *inode;
 	struct dentry *error;
 	struct task_struct *task = get_proc_task(dir);
-	struct pid_entry *p, *last;
+	const struct pid_entry *p, *last;
 
 	error = ERR_PTR(-ENOENT);
 	inode = NULL;
@@ -1488,8 +1489,8 @@ out_no_task:
 	return error;
 }
 
-static int proc_pident_fill_cache(struct file *filp, void *dirent, filldir_t filldir,
-	struct task_struct *task, struct pid_entry *p)
+static int proc_pident_fill_cache(struct file *filp, void *dirent,
+	filldir_t filldir, struct task_struct *task, const struct pid_entry *p)
 {
 	return proc_fill_cache(filp, dirent, filldir, p->name, p->len,
 				proc_pident_instantiate, task, p);
@@ -1497,14 +1498,14 @@ static int proc_pident_fill_cache(struct
 
 static int proc_pident_readdir(struct file *filp,
 		void *dirent, filldir_t filldir,
-		struct pid_entry *ents, unsigned int nents)
+		const struct pid_entry *ents, unsigned int nents)
 {
 	int i;
 	int pid;
 	struct dentry *dentry = filp->f_path.dentry;
 	struct inode *inode = dentry->d_inode;
 	struct task_struct *task = get_proc_task(inode);
-	struct pid_entry *p, *last;
+	const struct pid_entry *p, *last;
 	ino_t ino;
 	int ret;
 
@@ -1628,7 +1629,7 @@ static const struct file_operations proc
 	.write		= proc_pid_attr_write,
 };
 
-static struct pid_entry attr_dir_stuff[] = {
+static const struct pid_entry attr_dir_stuff[] = {
 	REG("current",    S_IRUGO|S_IWUGO, pid_attr),
 	REG("prev",       S_IRUGO,	   pid_attr),
 	REG("exec",       S_IRUGO|S_IWUGO, pid_attr),
@@ -1694,7 +1695,7 @@ static const struct inode_operations pro
  * that properly belong to the /proc filesystem, as they describe
  * describe something that is process related.
  */
-static struct pid_entry proc_base_stuff[] = {
+static const struct pid_entry proc_base_stuff[] = {
 	NOD("self", S_IFLNK|S_IRWXUGO,
 		&proc_self_inode_operations, NULL, {}),
 };
@@ -1723,9 +1724,9 @@ static struct dentry_operations proc_bas
 };
 
 static struct dentry *proc_base_instantiate(struct inode *dir,
-	struct dentry *dentry, struct task_struct *task, void *ptr)
+	struct dentry *dentry, struct task_struct *task, const void *ptr)
 {
-	struct pid_entry *p = ptr;
+	const struct pid_entry *p = ptr;
 	struct inode *inode;
 	struct proc_inode *ei;
 	struct dentry *error = ERR_PTR(-EINVAL);
@@ -1773,7 +1774,7 @@ static struct dentry *proc_base_lookup(s
 {
 	struct dentry *error;
 	struct task_struct *task = get_proc_task(dir);
-	struct pid_entry *p, *last;
+	const struct pid_entry *p, *last;
 
 	error = ERR_PTR(-ENOENT);
 
@@ -1799,8 +1800,8 @@ out_no_task:
 	return error;
 }
 
-static int proc_base_fill_cache(struct file *filp, void *dirent, filldir_t filldir,
-	struct task_struct *task, struct pid_entry *p)
+static int proc_base_fill_cache(struct file *filp, void *dirent,
+	filldir_t filldir, struct task_struct *task, const struct pid_entry *p)
 {
 	return proc_fill_cache(filp, dirent, filldir, p->name, p->len,
 				proc_base_instantiate, task, p);
@@ -1837,7 +1838,7 @@ #endif
 static const struct file_operations proc_task_operations;
 static const struct inode_operations proc_task_inode_operations;
 
-static struct pid_entry tgid_base_stuff[] = {
+static const struct pid_entry tgid_base_stuff[] = {
 	DIR("task",       S_IRUGO|S_IXUGO, task),
 	DIR("fd",         S_IRUSR|S_IXUSR, fd),
 	INF("environ",    S_IRUSR, pid_environ),
@@ -1979,7 +1980,7 @@ out:
 
 static struct dentry *proc_pid_instantiate(struct inode *dir,
 					   struct dentry * dentry,
-					   struct task_struct *task, void *ptr)
+					   struct task_struct *task, const void *ptr)
 {
 	struct dentry *error = ERR_PTR(-ENOENT);
 	struct inode *inode;
@@ -2094,7 +2095,7 @@ int proc_pid_readdir(struct file * filp,
 		goto out_no_task;
 
 	for (; nr < ARRAY_SIZE(proc_base_stuff); filp->f_pos++, nr++) {
-		struct pid_entry *p = &proc_base_stuff[nr];
+		const struct pid_entry *p = &proc_base_stuff[nr];
 		if (proc_base_fill_cache(filp, dirent, filldir, reaper, p) < 0)
 			goto out;
 	}
@@ -2120,7 +2121,7 @@ out_no_task:
 /*
  * Tasks
  */
-static struct pid_entry tid_base_stuff[] = {
+static const struct pid_entry tid_base_stuff[] = {
 	DIR("fd",        S_IRUSR|S_IXUSR, fd),
 	INF("environ",   S_IRUSR, pid_environ),
 	INF("auxv",      S_IRUSR, pid_auxv),
@@ -2189,7 +2190,7 @@ static const struct inode_operations pro
 };
 
 static struct dentry *proc_task_instantiate(struct inode *dir,
-	struct dentry *dentry, struct task_struct *task, void *ptr)
+	struct dentry *dentry, struct task_struct *task, const void *ptr)
 {
 	struct dentry *error = ERR_PTR(-ENOENT);
 	struct inode *inode;

--Boundary-00=_JbG8F83wU2LhxpZ--
