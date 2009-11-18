Return-Path: <linux-kernel-owner+w=401wt.eu-S1753918AbZKRJ0P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918AbZKRJ0P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 04:26:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756870AbZKRJZV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 04:25:21 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39428 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756812AbZKRJZS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 04:25:18 -0500
From: Jan Blunck <jblunck@suse.de>
To: linux-fsdevel@vger.kernel.org
Cc: Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, jkacur@redhat.com,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Hellwig <hch@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
       matthew@wil.cx, Jan Blunck <jblunck@suse.de>,
       Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 17/20] BKL: Remove BKL from cgroup
Date: Wed, 18 Nov 2009 10:24:50 +0100
Message-Id: <1258536293-7762-18-git-send-email-jblunck@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1258536293-7762-1-git-send-email-jblunck@suse.de>
References: <1258536293-7762-1-git-send-email-jblunck@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The BKL is only used in remount_fs and get_sb that are both protected by
the superblocks s_umount rw_semaphore. Therefore it is safe to remove the
BKL entirely.

Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 kernel/cgroup.c |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index b86c378..a8844f3 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -47,7 +47,6 @@
 #include <linux/cgroupstats.h>
 #include <linux/hash.h>
 #include <linux/namei.h>
-#include <linux/smp_lock.h>
 #include <linux/pid_namespace.h>
 #include <linux/idr.h>
 #include <linux/vmalloc.h> /* TODO: replace with more sophisticated array */
@@ -1082,7 +1081,6 @@ static int cgroup_remount(struct super_block *sb, int *flags, char *data)
 	struct cgroup *cgrp = &root->top_cgroup;
 	struct cgroup_sb_opts opts;
 
-	lock_kernel();
 	mutex_lock(&cgrp->dentry->d_inode->i_mutex);
 	mutex_lock(&cgroup_mutex);
 
@@ -1117,7 +1115,6 @@ static int cgroup_remount(struct super_block *sb, int *flags, char *data)
 	kfree(opts.name);
 	mutex_unlock(&cgroup_mutex);
 	mutex_unlock(&cgrp->dentry->d_inode->i_mutex);
-	unlock_kernel();
 	return ret;
 }
 
@@ -1290,8 +1287,6 @@ static int cgroup_get_sb(struct file_system_type *fs_type,
 	struct super_block *sb;
 	struct cgroupfs_root *new_root;
 
-	lock_kernel();
-
 	/* First find the desired set of subsystems */
 	ret = parse_cgroupfs_options(data, &opts);
 	if (ret)
@@ -1412,7 +1407,6 @@ static int cgroup_get_sb(struct file_system_type *fs_type,
 	simple_set_mnt(mnt, sb);
 	kfree(opts.release_agent);
 	kfree(opts.name);
-	unlock_kernel();
 	return 0;
 
  drop_new_super:
@@ -1420,8 +1414,6 @@ static int cgroup_get_sb(struct file_system_type *fs_type,
  out_err:
 	kfree(opts.release_agent);
 	kfree(opts.name);
-	unlock_kernel();
-
 	return ret;
 }
 
-- 
1.6.4.2

