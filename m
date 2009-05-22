Return-Path: <linux-kernel-owner+w=401wt.eu-S1757598AbZEVE7o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757598AbZEVE7o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 00:59:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753087AbZEVE4C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 00:56:02 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:45240 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753986AbZEVEz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 00:55:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=dgtcIa6/gpSnft3Ih4iaZZJblsouJlnuIJIRDrqRcev+47ttOgzIyMteENWnSwM0cw
         x0winH1LZEO2YPDU1+Elc3xlXo3CaTmDtarvEtYoijtMD39PDK0KGJE8FOqT+lTZ9mkN
         4JcYTtZ2UcbRq2M+0vO2oGQjugQUMEpcSQU1E=
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       torvalds@linux-foundation.org, xemul@parallels.com,
       orenl@cs.columbia.edu, serue@us.ibm.com, dave@linux.vnet.ibm.com,
       mingo@elte.hu, Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 17/38] groups: move code to kernel/groups.c
Date: Fri, 22 May 2009 08:55:11 +0400
Message-Id: <1242968132-1044-17-git-send-email-adobriyan@gmail.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1242968132-1044-1-git-send-email-adobriyan@gmail.com>
References: <1242968132-1044-1-git-send-email-adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move supplementary groups implementation to kernel/groups.c .
kernel/sys.c already accumulated quite a few random stuff.

Do strictly copy/paste + add required headers to compile.
Compile-tested on many configs and archs.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 kernel/Makefile |    1 +
 kernel/groups.c |  288 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 kernel/sys.c    |  283 ------------------------------------------------------
 3 files changed, 289 insertions(+), 283 deletions(-)
 create mode 100644 kernel/groups.c

diff --git a/kernel/Makefile b/kernel/Makefile
index 4242366..705ad3d 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -11,6 +11,7 @@ obj-y     = sched.o fork.o exec_domain.o panic.o printk.o \
 	    hrtimer.o rwsem.o nsproxy.o srcu.o semaphore.o \
 	    notifier.o ksysfs.o pm_qos_params.o sched_clock.o cred.o \
 	    async.o
+obj-y += groups.o
 
 ifdef CONFIG_FUNCTION_TRACER
 # Do not trace debug files and internal ftrace files
diff --git a/kernel/groups.c b/kernel/groups.c
new file mode 100644
index 0000000..1b95b2f
--- /dev/null
+++ b/kernel/groups.c
@@ -0,0 +1,288 @@
+/*
+ * Supplementary group IDs
+ */
+#include <linux/cred.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/security.h>
+#include <linux/syscalls.h>
+#include <asm/uaccess.h>
+
+/* init to 2 - one for init_task, one to ensure it is never freed */
+struct group_info init_groups = { .usage = ATOMIC_INIT(2) };
+
+struct group_info *groups_alloc(int gidsetsize)
+{
+	struct group_info *group_info;
+	int nblocks;
+	int i;
+
+	nblocks = (gidsetsize + NGROUPS_PER_BLOCK - 1) / NGROUPS_PER_BLOCK;
+	/* Make sure we always allocate at least one indirect block pointer */
+	nblocks = nblocks ? : 1;
+	group_info = kmalloc(sizeof(*group_info) + nblocks*sizeof(gid_t *), GFP_USER);
+	if (!group_info)
+		return NULL;
+	group_info->ngroups = gidsetsize;
+	group_info->nblocks = nblocks;
+	atomic_set(&group_info->usage, 1);
+
+	if (gidsetsize <= NGROUPS_SMALL)
+		group_info->blocks[0] = group_info->small_block;
+	else {
+		for (i = 0; i < nblocks; i++) {
+			gid_t *b;
+			b = (void *)__get_free_page(GFP_USER);
+			if (!b)
+				goto out_undo_partial_alloc;
+			group_info->blocks[i] = b;
+		}
+	}
+	return group_info;
+
+out_undo_partial_alloc:
+	while (--i >= 0) {
+		free_page((unsigned long)group_info->blocks[i]);
+	}
+	kfree(group_info);
+	return NULL;
+}
+
+EXPORT_SYMBOL(groups_alloc);
+
+void groups_free(struct group_info *group_info)
+{
+	if (group_info->blocks[0] != group_info->small_block) {
+		int i;
+		for (i = 0; i < group_info->nblocks; i++)
+			free_page((unsigned long)group_info->blocks[i]);
+	}
+	kfree(group_info);
+}
+
+EXPORT_SYMBOL(groups_free);
+
+/* export the group_info to a user-space array */
+static int groups_to_user(gid_t __user *grouplist,
+			  const struct group_info *group_info)
+{
+	int i;
+	unsigned int count = group_info->ngroups;
+
+	for (i = 0; i < group_info->nblocks; i++) {
+		unsigned int cp_count = min(NGROUPS_PER_BLOCK, count);
+		unsigned int len = cp_count * sizeof(*grouplist);
+
+		if (copy_to_user(grouplist, group_info->blocks[i], len))
+			return -EFAULT;
+
+		grouplist += NGROUPS_PER_BLOCK;
+		count -= cp_count;
+	}
+	return 0;
+}
+
+/* fill a group_info from a user-space array - it must be allocated already */
+static int groups_from_user(struct group_info *group_info,
+    gid_t __user *grouplist)
+{
+	int i;
+	unsigned int count = group_info->ngroups;
+
+	for (i = 0; i < group_info->nblocks; i++) {
+		unsigned int cp_count = min(NGROUPS_PER_BLOCK, count);
+		unsigned int len = cp_count * sizeof(*grouplist);
+
+		if (copy_from_user(group_info->blocks[i], grouplist, len))
+			return -EFAULT;
+
+		grouplist += NGROUPS_PER_BLOCK;
+		count -= cp_count;
+	}
+	return 0;
+}
+
+/* a simple Shell sort */
+static void groups_sort(struct group_info *group_info)
+{
+	int base, max, stride;
+	int gidsetsize = group_info->ngroups;
+
+	for (stride = 1; stride < gidsetsize; stride = 3 * stride + 1)
+		; /* nothing */
+	stride /= 3;
+
+	while (stride) {
+		max = gidsetsize - stride;
+		for (base = 0; base < max; base++) {
+			int left = base;
+			int right = left + stride;
+			gid_t tmp = GROUP_AT(group_info, right);
+
+			while (left >= 0 && GROUP_AT(group_info, left) > tmp) {
+				GROUP_AT(group_info, right) =
+				    GROUP_AT(group_info, left);
+				right = left;
+				left -= stride;
+			}
+			GROUP_AT(group_info, right) = tmp;
+		}
+		stride /= 3;
+	}
+}
+
+/* a simple bsearch */
+int groups_search(const struct group_info *group_info, gid_t grp)
+{
+	unsigned int left, right;
+
+	if (!group_info)
+		return 0;
+
+	left = 0;
+	right = group_info->ngroups;
+	while (left < right) {
+		unsigned int mid = (left+right)/2;
+		int cmp = grp - GROUP_AT(group_info, mid);
+		if (cmp > 0)
+			left = mid + 1;
+		else if (cmp < 0)
+			right = mid;
+		else
+			return 1;
+	}
+	return 0;
+}
+
+/**
+ * set_groups - Change a group subscription in a set of credentials
+ * @new: The newly prepared set of credentials to alter
+ * @group_info: The group list to install
+ *
+ * Validate a group subscription and, if valid, insert it into a set
+ * of credentials.
+ */
+int set_groups(struct cred *new, struct group_info *group_info)
+{
+	int retval;
+
+	retval = security_task_setgroups(group_info);
+	if (retval)
+		return retval;
+
+	put_group_info(new->group_info);
+	groups_sort(group_info);
+	get_group_info(group_info);
+	new->group_info = group_info;
+	return 0;
+}
+
+EXPORT_SYMBOL(set_groups);
+
+/**
+ * set_current_groups - Change current's group subscription
+ * @group_info: The group list to impose
+ *
+ * Validate a group subscription and, if valid, impose it upon current's task
+ * security record.
+ */
+int set_current_groups(struct group_info *group_info)
+{
+	struct cred *new;
+	int ret;
+
+	new = prepare_creds();
+	if (!new)
+		return -ENOMEM;
+
+	ret = set_groups(new, group_info);
+	if (ret < 0) {
+		abort_creds(new);
+		return ret;
+	}
+
+	return commit_creds(new);
+}
+
+EXPORT_SYMBOL(set_current_groups);
+
+SYSCALL_DEFINE2(getgroups, int, gidsetsize, gid_t __user *, grouplist)
+{
+	const struct cred *cred = current_cred();
+	int i;
+
+	if (gidsetsize < 0)
+		return -EINVAL;
+
+	/* no need to grab task_lock here; it cannot change */
+	i = cred->group_info->ngroups;
+	if (gidsetsize) {
+		if (i > gidsetsize) {
+			i = -EINVAL;
+			goto out;
+		}
+		if (groups_to_user(grouplist, cred->group_info)) {
+			i = -EFAULT;
+			goto out;
+		}
+	}
+out:
+	return i;
+}
+
+/*
+ *	SMP: Our groups are copy-on-write. We can set them safely
+ *	without another task interfering.
+ */
+ 
+SYSCALL_DEFINE2(setgroups, int, gidsetsize, gid_t __user *, grouplist)
+{
+	struct group_info *group_info;
+	int retval;
+
+	if (!capable(CAP_SETGID))
+		return -EPERM;
+	if ((unsigned)gidsetsize > NGROUPS_MAX)
+		return -EINVAL;
+
+	group_info = groups_alloc(gidsetsize);
+	if (!group_info)
+		return -ENOMEM;
+	retval = groups_from_user(group_info, grouplist);
+	if (retval) {
+		put_group_info(group_info);
+		return retval;
+	}
+
+	retval = set_current_groups(group_info);
+	put_group_info(group_info);
+
+	return retval;
+}
+
+/*
+ * Check whether we're fsgid/egid or in the supplemental group..
+ */
+int in_group_p(gid_t grp)
+{
+	const struct cred *cred = current_cred();
+	int retval = 1;
+
+	if (grp != cred->fsgid)
+		retval = groups_search(cred->group_info, grp);
+	return retval;
+}
+
+EXPORT_SYMBOL(in_group_p);
+
+int in_egroup_p(gid_t grp)
+{
+	const struct cred *cred = current_cred();
+	int retval = 1;
+
+	if (grp != cred->egid)
+		retval = groups_search(cred->group_info, grp);
+	return retval;
+}
+
+EXPORT_SYMBOL(in_egroup_p);
diff --git a/kernel/sys.c b/kernel/sys.c
index e7998cf..4edcf51 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1112,289 +1112,6 @@ out:
 	return err;
 }
 
-/*
- * Supplementary group IDs
- */
-
-/* init to 2 - one for init_task, one to ensure it is never freed */
-struct group_info init_groups = { .usage = ATOMIC_INIT(2) };
-
-struct group_info *groups_alloc(int gidsetsize)
-{
-	struct group_info *group_info;
-	int nblocks;
-	int i;
-
-	nblocks = (gidsetsize + NGROUPS_PER_BLOCK - 1) / NGROUPS_PER_BLOCK;
-	/* Make sure we always allocate at least one indirect block pointer */
-	nblocks = nblocks ? : 1;
-	group_info = kmalloc(sizeof(*group_info) + nblocks*sizeof(gid_t *), GFP_USER);
-	if (!group_info)
-		return NULL;
-	group_info->ngroups = gidsetsize;
-	group_info->nblocks = nblocks;
-	atomic_set(&group_info->usage, 1);
-
-	if (gidsetsize <= NGROUPS_SMALL)
-		group_info->blocks[0] = group_info->small_block;
-	else {
-		for (i = 0; i < nblocks; i++) {
-			gid_t *b;
-			b = (void *)__get_free_page(GFP_USER);
-			if (!b)
-				goto out_undo_partial_alloc;
-			group_info->blocks[i] = b;
-		}
-	}
-	return group_info;
-
-out_undo_partial_alloc:
-	while (--i >= 0) {
-		free_page((unsigned long)group_info->blocks[i]);
-	}
-	kfree(group_info);
-	return NULL;
-}
-
-EXPORT_SYMBOL(groups_alloc);
-
-void groups_free(struct group_info *group_info)
-{
-	if (group_info->blocks[0] != group_info->small_block) {
-		int i;
-		for (i = 0; i < group_info->nblocks; i++)
-			free_page((unsigned long)group_info->blocks[i]);
-	}
-	kfree(group_info);
-}
-
-EXPORT_SYMBOL(groups_free);
-
-/* export the group_info to a user-space array */
-static int groups_to_user(gid_t __user *grouplist,
-			  const struct group_info *group_info)
-{
-	int i;
-	unsigned int count = group_info->ngroups;
-
-	for (i = 0; i < group_info->nblocks; i++) {
-		unsigned int cp_count = min(NGROUPS_PER_BLOCK, count);
-		unsigned int len = cp_count * sizeof(*grouplist);
-
-		if (copy_to_user(grouplist, group_info->blocks[i], len))
-			return -EFAULT;
-
-		grouplist += NGROUPS_PER_BLOCK;
-		count -= cp_count;
-	}
-	return 0;
-}
-
-/* fill a group_info from a user-space array - it must be allocated already */
-static int groups_from_user(struct group_info *group_info,
-    gid_t __user *grouplist)
-{
-	int i;
-	unsigned int count = group_info->ngroups;
-
-	for (i = 0; i < group_info->nblocks; i++) {
-		unsigned int cp_count = min(NGROUPS_PER_BLOCK, count);
-		unsigned int len = cp_count * sizeof(*grouplist);
-
-		if (copy_from_user(group_info->blocks[i], grouplist, len))
-			return -EFAULT;
-
-		grouplist += NGROUPS_PER_BLOCK;
-		count -= cp_count;
-	}
-	return 0;
-}
-
-/* a simple Shell sort */
-static void groups_sort(struct group_info *group_info)
-{
-	int base, max, stride;
-	int gidsetsize = group_info->ngroups;
-
-	for (stride = 1; stride < gidsetsize; stride = 3 * stride + 1)
-		; /* nothing */
-	stride /= 3;
-
-	while (stride) {
-		max = gidsetsize - stride;
-		for (base = 0; base < max; base++) {
-			int left = base;
-			int right = left + stride;
-			gid_t tmp = GROUP_AT(group_info, right);
-
-			while (left >= 0 && GROUP_AT(group_info, left) > tmp) {
-				GROUP_AT(group_info, right) =
-				    GROUP_AT(group_info, left);
-				right = left;
-				left -= stride;
-			}
-			GROUP_AT(group_info, right) = tmp;
-		}
-		stride /= 3;
-	}
-}
-
-/* a simple bsearch */
-int groups_search(const struct group_info *group_info, gid_t grp)
-{
-	unsigned int left, right;
-
-	if (!group_info)
-		return 0;
-
-	left = 0;
-	right = group_info->ngroups;
-	while (left < right) {
-		unsigned int mid = (left+right)/2;
-		int cmp = grp - GROUP_AT(group_info, mid);
-		if (cmp > 0)
-			left = mid + 1;
-		else if (cmp < 0)
-			right = mid;
-		else
-			return 1;
-	}
-	return 0;
-}
-
-/**
- * set_groups - Change a group subscription in a set of credentials
- * @new: The newly prepared set of credentials to alter
- * @group_info: The group list to install
- *
- * Validate a group subscription and, if valid, insert it into a set
- * of credentials.
- */
-int set_groups(struct cred *new, struct group_info *group_info)
-{
-	int retval;
-
-	retval = security_task_setgroups(group_info);
-	if (retval)
-		return retval;
-
-	put_group_info(new->group_info);
-	groups_sort(group_info);
-	get_group_info(group_info);
-	new->group_info = group_info;
-	return 0;
-}
-
-EXPORT_SYMBOL(set_groups);
-
-/**
- * set_current_groups - Change current's group subscription
- * @group_info: The group list to impose
- *
- * Validate a group subscription and, if valid, impose it upon current's task
- * security record.
- */
-int set_current_groups(struct group_info *group_info)
-{
-	struct cred *new;
-	int ret;
-
-	new = prepare_creds();
-	if (!new)
-		return -ENOMEM;
-
-	ret = set_groups(new, group_info);
-	if (ret < 0) {
-		abort_creds(new);
-		return ret;
-	}
-
-	return commit_creds(new);
-}
-
-EXPORT_SYMBOL(set_current_groups);
-
-SYSCALL_DEFINE2(getgroups, int, gidsetsize, gid_t __user *, grouplist)
-{
-	const struct cred *cred = current_cred();
-	int i;
-
-	if (gidsetsize < 0)
-		return -EINVAL;
-
-	/* no need to grab task_lock here; it cannot change */
-	i = cred->group_info->ngroups;
-	if (gidsetsize) {
-		if (i > gidsetsize) {
-			i = -EINVAL;
-			goto out;
-		}
-		if (groups_to_user(grouplist, cred->group_info)) {
-			i = -EFAULT;
-			goto out;
-		}
-	}
-out:
-	return i;
-}
-
-/*
- *	SMP: Our groups are copy-on-write. We can set them safely
- *	without another task interfering.
- */
- 
-SYSCALL_DEFINE2(setgroups, int, gidsetsize, gid_t __user *, grouplist)
-{
-	struct group_info *group_info;
-	int retval;
-
-	if (!capable(CAP_SETGID))
-		return -EPERM;
-	if ((unsigned)gidsetsize > NGROUPS_MAX)
-		return -EINVAL;
-
-	group_info = groups_alloc(gidsetsize);
-	if (!group_info)
-		return -ENOMEM;
-	retval = groups_from_user(group_info, grouplist);
-	if (retval) {
-		put_group_info(group_info);
-		return retval;
-	}
-
-	retval = set_current_groups(group_info);
-	put_group_info(group_info);
-
-	return retval;
-}
-
-/*
- * Check whether we're fsgid/egid or in the supplemental group..
- */
-int in_group_p(gid_t grp)
-{
-	const struct cred *cred = current_cred();
-	int retval = 1;
-
-	if (grp != cred->fsgid)
-		retval = groups_search(cred->group_info, grp);
-	return retval;
-}
-
-EXPORT_SYMBOL(in_group_p);
-
-int in_egroup_p(gid_t grp)
-{
-	const struct cred *cred = current_cred();
-	int retval = 1;
-
-	if (grp != cred->egid)
-		retval = groups_search(cred->group_info, grp);
-	return retval;
-}
-
-EXPORT_SYMBOL(in_egroup_p);
-
 DECLARE_RWSEM(uts_sem);
 
 SYSCALL_DEFINE1(newuname, struct new_utsname __user *, name)
-- 
1.5.6.5

