Return-Path: <linux-kernel-owner+w=401wt.eu-S1754081AbZBDJMq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081AbZBDJMq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 04:12:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751274AbZBDJM3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 04:12:29 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:56220 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751268AbZBDJM2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 04:12:28 -0500
Message-ID: <49895BD7.8090405@cn.fujitsu.com>
Date: Wed, 04 Feb 2009 17:11:51 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Paul Menage <menage@google.com>, LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Subject: [PATCH] cgroups: fix lockdep subclasses overflow
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I enabled all cgroup subsystems when compiling kernel, and then:
 # mount -t cgroup -o net_cls xxx /mnt
 # mkdir /mnt/0

This showed up immediately:
 BUG: MAX_LOCKDEP_SUBCLASSES too low!
 turning off the locking correctness validator.

It's caused by the cgroup hierarchy lock:
	for (i = 0; i < CGROUP_SUBSYS_COUNT; i++) {
		struct cgroup_subsys *ss = subsys[i];
		if (ss->root == root)
			mutex_lock_nested(&ss->hierarchy_mutex, i);
	}

Now we have 9 cgroup subsystems, and the above 'i' for net_cls is 9, but
MAX_LOCKDEP_SUBCLASSES is 8.

This patch uses different lockdep keys for different subsystems.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 include/linux/cgroup.h |    1 +
 kernel/cgroup.c        |    3 ++-
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index e4e8e11..499900d 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -378,6 +378,7 @@ struct cgroup_subsys {
 	 * - initiating hotplug events
 	 */
 	struct mutex hierarchy_mutex;
+	struct lock_class_key subsys_key;
 
 	/*
 	 * Link to parent, and list entry in parent's children.
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 5a54ff4..e14db9c 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2351,7 +2351,7 @@ static void cgroup_lock_hierarchy(struct cgroupfs_root *root)
 	for (i = 0; i < CGROUP_SUBSYS_COUNT; i++) {
 		struct cgroup_subsys *ss = subsys[i];
 		if (ss->root == root)
-			mutex_lock_nested(&ss->hierarchy_mutex, i);
+			mutex_lock(&ss->hierarchy_mutex);
 	}
 }
 
@@ -2637,6 +2637,7 @@ static void __init cgroup_init_subsys(struct cgroup_subsys *ss)
 	BUG_ON(!list_empty(&init_task.tasks));
 
 	mutex_init(&ss->hierarchy_mutex);
+	lockdep_set_class(&ss->hierarchy_mutex, &ss->subsys_key);
 	ss->active = 1;
 }
 
-- 
1.5.4.rc3



