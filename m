Return-Path: <linux-kernel-owner+w=401wt.eu-S1753291AbYLVBZf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753291AbYLVBZf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 20:25:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751744AbYLVBZT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 20:25:19 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:58429 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752719AbYLVBZS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 20:25:18 -0500
Message-ID: <494EEC36.8080602@cn.fujitsu.com>
Date: Mon, 22 Dec 2008 09:24:06 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Paul Menage <menage@google.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH -mm] a fixlet for cgroups-make-cgroup_path-rcu-safe.patch
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With cgroups-make-cgroup_path-rcu-safe.patch applied, I can trigger
kernel panic easily using this test program:
	for ((; ;))
	{
		mount -t cgroup -o debug xxx /mnt
		mkdir /mnt/0
		rmdir /mnt/0
		umount /mnt
	}

It's caused by the deactive_super() in rcu callback.

This patch restores the original code that call deactive_super() in
cgroup_diput().

Also remove duplicated comment in cgroup.h added by the patch.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 include/linux/cgroup.h |    6 ------
 kernel/cgroup.c        |   11 ++++++-----
 2 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/include/linux/cgroup.h.orig b/include/linux/cgroup.h
index 880528d..e267e62 100644
--- a/include/linux/cgroup.h.orig
+++ b/include/linux/cgroup.h
@@ -334,12 +334,6 @@ int cgroup_add_files(struct cgroup *cgrp,
 
 int cgroup_is_removed(const struct cgroup *cgrp);
 
-/*
- * cgroup_path() fills in a filesystem-like path for the given cgroup
- * into "buf", up to "buflen" characters. Should be called with
- * cgroup_mutex held, or else in an RCU section with an RCU-protected
- * cgroup reference
- */
 int cgroup_path(const struct cgroup *cgrp, char *buf, int buflen);
 
 int cgroup_task_count(const struct cgroup *cgrp);
diff --git a/kernel/cgroup.c.orig b/kernel/cgroup.c
index 5cfd005..d49e97d 100644
--- a/kernel/cgroup.c.orig
+++ b/kernel/cgroup.c
@@ -598,11 +598,6 @@ static void cgroup_call_pre_destroy(struct cgroup *cgrp)
 static void free_cgroup_rcu(struct rcu_head *obj)
 {
 	struct cgroup *cgrp = container_of(obj, struct cgroup, rcu_head);
-	/*
-	 * Drop the active superblock reference that we took when we
-	 * created the cgroup
-	 */
-	deactivate_super(cgrp->root->sb);
 
 	kfree(cgrp);
 }
@@ -632,6 +627,12 @@ static void cgroup_diput(struct dentry *dentry, struct inode *inode)
 		cgrp->root->number_of_cgroups--;
 		mutex_unlock(&cgroup_mutex);
 
+		/*
+		 * Drop the active superblock reference that we took when we
+		 * created the cgroup
+		 */
+		deactivate_super(cgrp->root->sb);
+
 		call_rcu(&cgrp->rcu_head, free_cgroup_rcu);
 	}
 	iput(inode);

