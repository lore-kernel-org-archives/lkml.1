Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1758506AbYLPX6y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758506AbYLPX6y (ORCPT <rfc822;akpm@linux-foundation.org>);
	Tue, 16 Dec 2008 18:58:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754080AbYLPX6n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 18:58:43 -0500
Received: from smtp-out.google.com ([216.239.45.13]:17707 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317AbYLPX6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 18:58:42 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:date:message-id:subject:from:to:content-type:content-transfer-encoding;
	b=FmYnpeVTWRoBXuvQ9YEdlef+XiY9tch+6Jv343KOX1o6wrojWR9tVtUExN5AQ+84b
	K0iDNEhnQ1ZfygyXaj0nw==
MIME-Version: 1.0
Date: Tue, 16 Dec 2008 15:58:38 -0800
Message-ID: <6599ad830812161558t4da0e5e7l4ad7d6f3a0dfbe6e@mail.gmail.com>
Subject: [PATCH] Make cgroup_path() RCU-safe
From: Paul Menage <menage@google.com>
To: Ingo Molnar <mingo@elte.hu>, Li Zefan <lizf@cn.fujitsu.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make cgroup_path() RCU safe

This patch fixes races between /proc/sched_debug by freeing
cgroup objects via an RCU callback. Thus any cgroup reference obtained
from an RCU-safe source will remain valid during the RCU section. Since
dentries are also RCU-safe, this allows us to traverse up the tree safely.

Additionally, make cgroup_path() check for a NULL cgrp->dentry to avoid
trying to report a path for a partially-created cgroup.

Signed-off-by: Paul Menage <menage@google.com>

--

There are more RCU changes that I can make for 2.6.29+, but this
should fix the problem in 2.6.28

 include/linux/cgroup.h |   11 ++++++++++-
 kernel/cgroup.c        |   33 ++++++++++++++++++++++-----------
 2 files changed, 32 insertions(+), 12 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index f68dfd8..3f46212 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -116,7 +116,7 @@ struct cgroup {
 	struct list_head children;	/* my children */

 	struct cgroup *parent;	/* my parent */
-	struct dentry *dentry;	  	/* cgroup fs entry */
+	struct dentry *dentry;	  	/* cgroup fs entry, RCU protected */

 	/* Private pointers for each registered subsystem */
 	struct cgroup_subsys_state *subsys[CGROUP_SUBSYS_COUNT];
@@ -145,6 +145,9 @@ struct cgroup {
 	int pids_use_count;
 	/* Length of the current tasks_pids array */
 	int pids_length;
+
+	/* For RCU-protected deletion */
+	struct rcu_head rcu_head;
 };

 /* A css_set is a structure holding pointers to a set of
@@ -305,6 +308,12 @@ int cgroup_add_files(struct cgroup *cgrp,

 int cgroup_is_removed(const struct cgroup *cgrp);

+/*
+ * cgroup_path() fills in a filesystem-like path for the given cgroup
+ * into "buf", up to "buflen" characters. Should be called with
+ * cgroup_mutex held, or else in an RCU section with an RCU-protected
+ * cgroup reference
+ */
 int cgroup_path(const struct cgroup *cgrp, char *buf, int buflen);

 int cgroup_task_count(const struct cgroup *cgrp);
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index f9d9467..43fa013 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -271,7 +271,7 @@ static void __put_css_set(struct css_set *cg, int taskexit)

 	rcu_read_lock();
 	for (i = 0; i < CGROUP_SUBSYS_COUNT; i++) {
-		struct cgroup *cgrp = cg->subsys[i]->cgroup;
+		struct cgroup *cgrp = rcu_dereference(cg->subsys[i]->cgroup);
 		if (atomic_dec_and_test(&cgrp->count) &&
 		    notify_on_release(cgrp)) {
 			if (taskexit)
@@ -595,6 +595,18 @@ static void cgroup_call_pre_destroy(struct cgroup *cgrp)
 	return;
 }

+static void free_cgroup_rcu(struct rcu_head *obj)
+{
+	struct cgroup *cgrp = container_of(obj, struct cgroup, rcu_head);
+	/*
+	 * Drop the active superblock reference that we took when we
+	 * created the cgroup
+	 */
+	deactivate_super(cgrp->root->sb);
+
+	kfree(cgrp);
+}
+
 static void cgroup_diput(struct dentry *dentry, struct inode *inode)
 {
 	/* is dentry a directory ? if so, kfree() associated cgroup */
@@ -620,11 +632,7 @@ static void cgroup_diput(struct dentry *dentry,
struct inode *inode)
 		cgrp->root->number_of_cgroups--;
 		mutex_unlock(&cgroup_mutex);

-		/* Drop the active superblock reference that we took when we
-		 * created the cgroup */
-		deactivate_super(cgrp->root->sb);
-
-		kfree(cgrp);
+		call_rcu(&cgrp->rcu_head, free_cgroup_rcu);
 	}
 	iput(inode);
 }
@@ -1134,14 +1142,16 @@ static inline struct cftype *__d_cft(struct
dentry *dentry)
  * @buf: the buffer to write the path into
  * @buflen: the length of the buffer
  *
- * Called with cgroup_mutex held. Writes path of cgroup into buf.
- * Returns 0 on success, -errno on error.
+ * Called with cgroup_mutex held or else with an RCU-protected cgroup
+ * reference.  Writes path of cgroup into buf.  Returns 0 on success,
+ * -errno on error.
  */
 int cgroup_path(const struct cgroup *cgrp, char *buf, int buflen)
 {
 	char *start;
+	struct dentry *dentry = rcu_dereference(cgrp->dentry);

-	if (cgrp == dummytop) {
+	if (!dentry || cgrp == dummytop) {
 		/*
 		 * Inactive subsystems have no dentry for their root
 		 * cgroup
@@ -1154,13 +1164,14 @@ int cgroup_path(const struct cgroup *cgrp,
char *buf, int buflen)

 	*--start = '\0';
 	for (;;) {
-		int len = cgrp->dentry->d_name.len;
+		int len = dentry->d_name.len;
 		if ((start -= len) < buf)
 			return -ENAMETOOLONG;
 		memcpy(start, cgrp->dentry->d_name.name, len);
 		cgrp = cgrp->parent;
 		if (!cgrp)
 			break;
+		dentry = rcu_dereference(cgrp->dentry);
 		if (!cgrp->parent)
 			continue;
 		if (--start < buf)
@@ -1663,7 +1674,7 @@ static int cgroup_create_dir(struct cgroup
*cgrp, struct dentry *dentry,
 	if (!error) {
 		dentry->d_fsdata = cgrp;
 		inc_nlink(parent->d_inode);
-		cgrp->dentry = dentry;
+		rcu_assign_pointer(cgrp->dentry, dentry);
 		dget(dentry);
 	}
 	dput(dentry);
