Return-Path: <linux-kernel-owner+w=401wt.eu-S1755201AbYKTLSA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755201AbYKTLSA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 06:18:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754046AbYKTLRw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 06:17:52 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:56321 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753962AbYKTLRv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 06:17:51 -0500
Message-ID: <492546B1.70708@cn.fujitsu.com>
Date: Thu, 20 Nov 2008 19:14:57 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.5 (Windows/20070716)
MIME-Version: 1.0
To: Andrea Righi <righi.andrea@gmail.com>, Ryo Tsuruta <ryov@valinux.co.jp>,
       Hirokazu Takahashi <taka@valinux.co.jp>
CC: menage@google.com, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: [PATCH 6/7] support checking of subsystem dependencies
References: <4925445C.10302@cn.fujitsu.com>
In-Reply-To: <4925445C.10302@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Zefan <lizf@cn.fujitsu.com>

This allows one subsystem to require that it only be mounted when some
other subsystems are also present in or not in the proposed hierarchy.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 Documentation/cgroups/cgroups.txt |    5 +++++
 include/linux/cgroup.h            |    2 ++
 kernel/cgroup.c                   |   21 ++++++++++++++++++++-
 3 files changed, 27 insertions(+), 1 deletions(-)

diff --git a/Documentation/cgroups/cgroups.txt b/Documentation/cgroups/cgroups.txt
index d9014aa..df648c6 100644
--- a/Documentation/cgroups/cgroups.txt
+++ b/Documentation/cgroups/cgroups.txt
@@ -534,6 +534,11 @@ and root cgroup. Currently this will only involve movement between
 the default hierarchy (which never has sub-cgroups) and a hierarchy
 that is being created/destroyed (and hence has no sub-cgroups).
 
+int subsys_depend(struct cgroup_subsys *ss, unsigned long subsys_bits)
+Called when a cgroup subsystem wants to check if some other subsystems
+are also present in the proposed hierarchy. If this method returns error,
+the mount of the cgroup filesystem will fail.
+
 4. Questions
 ============
 
diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 1164963..1899449 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -329,6 +329,8 @@ struct cgroup_subsys {
 			struct cgroup *cgrp);
 	void (*post_clone)(struct cgroup_subsys *ss, struct cgroup *cgrp);
 	void (*bind)(struct cgroup_subsys *ss, struct cgroup *root);
+	int (*subsys_depend)(struct cgroup_subsys *ss,
+			     unsigned long subsys_bits);
 	/*
 	 * This routine is called with the task_lock of mm->owner held
 	 */
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index a512a75..8a07023 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -761,6 +761,25 @@ static int cgroup_show_options(struct seq_file *seq, struct vfsmount *vfs)
 	return 0;
 }
 
+static int check_subsys_dependency(unsigned long subsys_bits)
+{
+	int i;
+	int ret;
+	struct cgroup_subsys *ss;
+	
+	for (i = 0; i < CGROUP_SUBSYS_COUNT; i++) {
+		ss = subsys[i];
+		
+		if (test_bit(i, &subsys_bits) && ss->subsys_depend) {
+			ret = ss->subsys_depend(ss, subsys_bits);
+			if (ret)
+				return ret;
+		}
+	}
+	
+	return 0;
+}
+
 struct cgroup_sb_opts {
 	unsigned long subsys_bits;
 	unsigned long flags;
@@ -821,7 +840,7 @@ static int parse_cgroupfs_options(char *data,
 	if (!opts->subsys_bits)
 		return -EINVAL;
 
-	return 0;
+	return check_subsys_dependency(opts->subsys_bits);
 }
 
 static int cgroup_remount(struct super_block *sb, int *flags, char *data)
-- 1.5.4.rc3



