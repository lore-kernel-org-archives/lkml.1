Return-Path: <linux-kernel-owner+w=401wt.eu-S1756557AbZCDBwX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756557AbZCDBwX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 20:52:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751719AbZCDBwO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 20:52:14 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:52656 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750868AbZCDBwN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 20:52:13 -0500
Message-ID: <49ADDEF9.7020308@cn.fujitsu.com>
Date: Wed, 04 Mar 2009 09:52:57 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: menage@google.com, kamezawa.hiroyu@jp.fujitsu.com,
       balbir@linux.vnet.ibm.com, dhaval@linux.vnet.ibm.com, serue@us.ibm.com,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
Subject: [PATCH] cgroups: show correct file mode, fix
References: <49ACC037.2090507@cn.fujitsu.com> <20090303122733.af5ceea9.akpm@linux-foundation.org>
In-Reply-To: <20090303122733.af5ceea9.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- 'mode' should have type mode_t
- use S_IRUGO/S_IWUSR instead of 0444/0200

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---

against cgroups-show-correct-file-mode.patch

---
 include/linux/cgroup.h |    2 +-
 kernel/cgroup.c        |   24 ++++++++++++------------
 kernel/cpuset.c        |    2 +-
 3 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 31cc1a9..665fa70 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -262,7 +262,7 @@ struct cftype {
 	 * If not 0, file mode is set to this value, otherwise it will
 	 * be figured out automatically
 	 */
-	int mode;
+	mode_t mode;
 
 	/*
 	 * If non-zero, defines the maximum length of string that can
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 043b24e..ad10c5d 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1686,7 +1686,7 @@ static struct inode_operations cgroup_dir_inode_operations = {
 	.rename = cgroup_rename,
 };
 
-static int cgroup_create_file(struct dentry *dentry, int mode,
+static int cgroup_create_file(struct dentry *dentry, mode_t mode,
 				struct super_block *sb)
 {
 	static struct dentry_operations cgroup_dops = {
@@ -1732,7 +1732,7 @@ static int cgroup_create_file(struct dentry *dentry, int mode,
  * @mode: mode to set on new directory.
  */
 static int cgroup_create_dir(struct cgroup *cgrp, struct dentry *dentry,
-				int mode)
+				mode_t mode)
 {
 	struct dentry *parent;
 	int error = 0;
@@ -1755,24 +1755,24 @@ static int cgroup_create_dir(struct cgroup *cgrp, struct dentry *dentry,
  * @cft: the control file in question
  *
  * returns cft->mode if ->mode is not 0
- * returns 0644 if it has both a read and a write handler
- * returns 0444 if it has only a read handler
- * returns 0200 if it has only a write hander
+ * returns S_IRUGO|S_IWUSR if it has both a read and a write handler
+ * returns S_IRUGO if it has only a read handler
+ * returns S_IWUSR if it has only a write hander
  */
-static int cgroup_file_mode(const struct cftype *cft)
+static mode_t cgroup_file_mode(const struct cftype *cft)
 {
-	int mode = 0;
+	mode_t mode = 0;
 
 	if (cft->mode)
 		return cft->mode;
 
 	if (cft->read || cft->read_u64 || cft->read_s64 ||
 	    cft->read_map || cft->read_seq_string)
-		mode |= 0444;
+		mode |= S_IRUGO;
 
 	if (cft->write || cft->write_u64 || cft->write_s64 ||
 	    cft->write_string || cft->trigger)
-		mode |= 0200;
+		mode |= S_IWUSR;
 
 	return mode;
 }
@@ -1784,7 +1784,7 @@ int cgroup_add_file(struct cgroup *cgrp,
 	struct dentry *dir = cgrp->dentry;
 	struct dentry *dentry;
 	int error;
-	int mode;
+	mode_t mode;
 
 	char name[MAX_CGROUP_TYPE_NAMELEN + MAX_CFTYPE_NAME + 2] = { 0 };
 	if (subsys && !test_bit(ROOT_NOPREFIX, &cgrp->root->flags)) {
@@ -2378,7 +2378,7 @@ static struct cftype files[] = {
 		.write_u64 = cgroup_tasks_write,
 		.release = cgroup_tasks_release,
 		.private = FILE_TASKLIST,
-		.mode = 0644,
+		.mode = S_IRUGO | S_IWUSR,
 	},
 
 	{
@@ -2479,7 +2479,7 @@ static void cgroup_unlock_hierarchy(struct cgroupfs_root *root)
  * Must be called with the mutex on the parent inode held
  */
 static long cgroup_create(struct cgroup *parent, struct dentry *dentry,
-			     int mode)
+			     mode_t mode)
 {
 	struct cgroup *cgrp;
 	struct cgroupfs_root *root = parent->root;
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 31e28b3..0619f10 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -1678,7 +1678,7 @@ static struct cftype files[] = {
 		.read_u64 = cpuset_read_u64,
 		.write_u64 = cpuset_write_u64,
 		.private = FILE_MEMORY_PRESSURE,
-		.mode = 0444,
+		.mode = S_IRUGO,
 	},
 
 	{
-- 
1.5.4.rc3
