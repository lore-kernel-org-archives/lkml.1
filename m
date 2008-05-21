Return-Path: <linux-kernel-owner+w=401wt.eu-S936133AbYEUPb2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936133AbYEUPb2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 11:31:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936060AbYEUPbD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 11:31:03 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:39085 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765621AbYEUPa7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 11:30:59 -0400
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: linux-mm@kvack.org
Cc: Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Paul Menage <menage@google.com>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, Pavel Emelianov <xemul@openvz.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Wed, 21 May 2008 20:59:59 +0530
Message-Id: <20080521152959.15001.14495.sendpatchset@localhost.localdomain>
In-Reply-To: <20080521152921.15001.65968.sendpatchset@localhost.localdomain>
References: <20080521152921.15001.65968.sendpatchset@localhost.localdomain>
Subject: [-mm][PATCH 3/4] cgroup mm owner callback changes to add task info (v5)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch adds an additional field to the mm_owner callbacks. This field
is required to get to the mm that changed. Hold mmap_sem in write mode
before calling the mm_owner_changed callback

Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
---

 include/linux/cgroup.h |    3 ++-
 kernel/cgroup.c        |    4 +++-
 kernel/exit.c          |    3 +++
 3 files changed, 8 insertions(+), 2 deletions(-)

diff -puN include/linux/cgroup.h~cgroup-add-task-to-mm-owner-callbacks include/linux/cgroup.h
--- linux-2.6.26-rc2/include/linux/cgroup.h~cgroup-add-task-to-mm-owner-callbacks	2008-05-21 20:56:54.000000000 +0530
+++ linux-2.6.26-rc2-balbir/include/linux/cgroup.h	2008-05-21 20:56:54.000000000 +0530
@@ -310,7 +310,8 @@ struct cgroup_subsys {
 	 */
 	void (*mm_owner_changed)(struct cgroup_subsys *ss,
 					struct cgroup *old,
-					struct cgroup *new);
+					struct cgroup *new,
+					struct task_struct *p);
 	int subsys_id;
 	int active;
 	int disabled;
diff -puN kernel/cgroup.c~cgroup-add-task-to-mm-owner-callbacks kernel/cgroup.c
--- linux-2.6.26-rc2/kernel/cgroup.c~cgroup-add-task-to-mm-owner-callbacks	2008-05-21 20:56:54.000000000 +0530
+++ linux-2.6.26-rc2-balbir/kernel/cgroup.c	2008-05-21 20:56:54.000000000 +0530
@@ -2758,6 +2758,8 @@ void cgroup_fork_callbacks(struct task_s
  * Called on every change to mm->owner. mm_init_owner() does not
  * invoke this routine, since it assigns the mm->owner the first time
  * and does not change it.
+ *
+ * The callbacks are invoked with mmap_sem held in read mode.
  */
 void cgroup_mm_owner_callbacks(struct task_struct *old, struct task_struct *new)
 {
@@ -2772,7 +2774,7 @@ void cgroup_mm_owner_callbacks(struct ta
 			if (oldcgrp == newcgrp)
 				continue;
 			if (ss->mm_owner_changed)
-				ss->mm_owner_changed(ss, oldcgrp, newcgrp);
+				ss->mm_owner_changed(ss, oldcgrp, newcgrp, new);
 		}
 	}
 }
diff -puN kernel/exit.c~cgroup-add-task-to-mm-owner-callbacks kernel/exit.c
--- linux-2.6.26-rc2/kernel/exit.c~cgroup-add-task-to-mm-owner-callbacks	2008-05-21 20:56:54.000000000 +0530
+++ linux-2.6.26-rc2-balbir/kernel/exit.c	2008-05-21 20:56:54.000000000 +0530
@@ -621,6 +621,7 @@ retry:
 assign_new_owner:
 	BUG_ON(c == p);
 	get_task_struct(c);
+	down_write(&mm->mmap_sem);
 	/*
 	 * The task_lock protects c->mm from changing.
 	 * We always want mm->owner->mm == mm
@@ -634,12 +635,14 @@ assign_new_owner:
 	if (c->mm != mm) {
 		task_unlock(c);
 		put_task_struct(c);
+		up_write(&mm->mmap_sem);
 		goto retry;
 	}
 	cgroup_mm_owner_callbacks(mm->owner, c);
 	mm->owner = c;
 	task_unlock(c);
 	put_task_struct(c);
+	up_write(&mm->mmap_sem);
 }
 #endif /* CONFIG_MM_OWNER */
 
_

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
