Return-Path: <linux-kernel-owner+w=401wt.eu-S1759352AbYDDMzf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759352AbYDDMzf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 08:55:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757887AbYDDMyt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 08:54:49 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:63562 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756728AbYDDMyq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 08:54:46 -0400
Message-Id: <20080404122402.649094693@I-love.SAKURA.ne.jp>
References: <20080404122242.867070732@I-love.SAKURA.ne.jp>
User-Agent: quilt/0.46-1
Date: Fri, 04 Apr 2008 21:22:56 +0900
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Cc: Kentaro Takeda <takedakn@nttdata.co.jp>,
       Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
       Toshiharu Harada <haradats@nttdata.co.jp>
Subject: [TOMOYO #7 14/30] Shadow mount prevention part.
Content-Disposition: inline; filename=tomoyo-shadow-mount-prevention-part.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is usually an undesirable thing to allow mount requests that shadow
already mounted tree. For example, mounting /usr when /usr/local is
already mounted is undesirable because it makes /usr/local inaccessible.

This file forbids such mount request.

Signed-off-by: Kentaro Takeda <takedakn@nttdata.co.jp>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Toshiharu Harada <haradats@nttdata.co.jp>
---
 fs/sakura_maymount.c |  113 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 113 insertions(+)

--- /dev/null
+++ linux-2.6.25-rc8-mm1/fs/sakura_maymount.c
@@ -0,0 +1,113 @@
+/*
+ * fs/sakura_maymount.c
+ *
+ * Implementation of the Domain-Free Mandatory Access Control.
+ *
+ * Copyright (C) 2005-2008  NTT DATA CORPORATION
+ *
+ * Version: 1.6.0   2008/04/01
+ *
+ */
+
+#include <linux/ccs_common.h>
+#include <linux/sakura.h>
+#include <linux/realpath.h>
+#include <linux/mount.h>
+#include <linux/mnt_namespace.h>
+#include <linux/namei.h>
+
+/**
+ * check_conceal_mount - Check whether this mount request shadows existing mounts.
+ *
+ * @nd:     Pointer to "struct nameidata".
+ * @vfsmnt: Pointer to "struct vfsmount".
+ * @dentry: Pointer to "struct dentry".
+ *
+ * Returns true if @vfsmnt is parent directory compared to @nd, false otherwise.
+ */
+static bool check_conceal_mount(struct nameidata *nd, struct vfsmount *vfsmnt,
+				struct dentry *dentry)
+{
+	/***** CRITICAL SECTION START *****/
+	while (1) {
+		if (nd->path.mnt->mnt_root == vfsmnt->mnt_root &&
+		    nd->path.dentry == dentry)
+			return true;
+		if (dentry == vfsmnt->mnt_root || IS_ROOT(dentry)) {
+			if (vfsmnt->mnt_parent == vfsmnt)
+				break;
+			dentry = vfsmnt->mnt_mountpoint;
+			vfsmnt = vfsmnt->mnt_parent;
+			continue;
+		}
+		dentry = dentry->d_parent;
+	}
+	return false;
+	/***** CRITICAL SECTION END *****/
+}
+
+/**
+ * print_error - Print error message.
+ *
+ * @nd:   Pointer to "struct nameidata".
+ * @mode: Access control mode.
+ *
+ * Returns 0 if @mode is not enforcing or permitted by the administrator's
+ * decision, negative value otherwise.
+ */
+static int print_error(struct nameidata *nd, const u8 mode)
+{
+	int error;
+	const bool is_enforce = (mode == 3);
+	const char *dir = ccs_realpath_from_dentry(nd->path.dentry,
+						   nd->path.mnt);
+	const char *exename = ccs_get_exe();
+	printk(KERN_WARNING "SAKURA-%s: mount %s (pid=%d:exe=%s): "
+	       "Permission denied.\n", ccs_get_msg(is_enforce), dir,
+	       current->pid, exename);
+	if (is_enforce)
+		error = ccs_check_supervisor("# %s is requesting\n"
+					     "mount on %s\n", exename, dir);
+	else
+		error = 0;
+	ccs_free(exename);
+	ccs_free(dir);
+	return error;
+}
+
+/**
+ * ccs_may_mount - Check whether this mount request shadows existing mounts.
+ *
+ * @nd: Pointer to "struct nameidata".
+ *
+ * Returns 0 on success, negative value otherwise.
+ */
+int ccs_may_mount(struct nameidata *nd)
+{
+	struct list_head *p;
+	bool flag = false;
+	const u8 mode = ccs_check_flags(CCS_SAKURA_DENY_CONCEAL_MOUNT);
+	struct mnt_namespace *namespace = current->nsproxy->mnt_ns;
+	if (!mode)
+		return 0;
+	if (!namespace)
+		return 0;
+	list_for_each(p, &namespace->list) {
+		struct vfsmount *vfsmnt = list_entry(p, struct vfsmount,
+						     mnt_list);
+		struct dentry *dentry = vfsmnt->mnt_root;
+		/***** CRITICAL SECTION START *****/
+		spin_lock(&dcache_lock);
+		spin_lock(&vfsmount_lock);
+		if (IS_ROOT(dentry) || !d_unhashed(dentry))
+			flag = check_conceal_mount(nd, vfsmnt, dentry);
+		spin_unlock(&vfsmount_lock);
+		spin_unlock(&dcache_lock);
+		/***** CRITICAL SECTION END *****/
+		if (flag)
+			break;
+	}
+	if (flag)
+		return print_error(nd, mode);
+	return 0;
+}

-- 
