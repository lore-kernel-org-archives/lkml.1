Return-Path: <linux-kernel-owner+w=401wt.eu-S1753250AbYKSIPU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250AbYKSIPU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 03:15:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751360AbYKSIPH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 03:15:07 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:62512 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751187AbYKSIPG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 03:15:06 -0500
Message-ID: <4923CAF1.1020404@cn.fujitsu.com>
Date: Wed, 19 Nov 2008 16:14:41 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Paul Menage <menage@google.com>, Balbir Singh <balbir@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Subject: [PATCH] cgroups: fix a serious bug in cgroupstats
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Try this, and you'll get oops immediately:
 # cd Documentation/accounting/
 # gcc -o getdelays getdelays.c
 # mount -t cgroup -o debug xxx /mnt
 # ./getdelays -C /mnt/tasks

Because a normal file's dentry->d_fsdata is a pointer to struct cftype,
not struct cgroup.

After the patch, it returns EINVAL if we try to get cgroupstats
from a normal file.

CC: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/cgroup.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 358e775..f6f5219 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2039,10 +2039,13 @@ int cgroupstats_build(struct cgroupstats *stats, struct dentry *dentry)
 	struct cgroup *cgrp;
 	struct cgroup_iter it;
 	struct task_struct *tsk;
+
 	/*
-	 * Validate dentry by checking the superblock operations
+	 * Validate dentry by checking the superblock operations,
+	 * and make sure it's a directory.
 	 */
-	if (dentry->d_sb->s_op != &cgroup_ops)
+	if (dentry->d_sb->s_op != &cgroup_ops ||
+	    !S_ISDIR(dentry->d_inode->i_mode))
 		 goto err;
 
 	ret = 0;
-- 
1.5.4.rc3
