Return-Path: <linux-kernel-owner+w=401wt.eu-S1755009AbYJUAu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755009AbYJUAu0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 20:50:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751291AbYJUAuP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 20:50:15 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59110 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751287AbYJUAuO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 20:50:14 -0400
Message-ID: <48FD273F.3040505@cn.fujitsu.com>
Date: Tue, 21 Oct 2008 08:50:07 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Matt Helsley <matthltc@us.ibm.com>, Cedric Le Goater <clg@fr.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Subject: [PATCH 2/4] freezer_cg: remove redundant check in freezer_can_attach()
References: <48FD26F5.1070809@cn.fujitsu.com>
In-Reply-To: <48FD26F5.1070809@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is sufficient to check if @task is frozen, and no need to check if
the original freezer is frozen.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/cgroup_freezer.c |   16 +++++++---------
 1 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/kernel/cgroup_freezer.c b/kernel/cgroup_freezer.c
index 7f54d1c..6fadafe 100644
--- a/kernel/cgroup_freezer.c
+++ b/kernel/cgroup_freezer.c
@@ -162,9 +162,13 @@ static int freezer_can_attach(struct cgroup_subsys *ss,
 			      struct task_struct *task)
 {
 	struct freezer *freezer;
-	int retval;
 
-	/* Anything frozen can't move or be moved to/from */
+	/*
+	 * Anything frozen can't move or be moved to/from.
+	 *
+	 * Since orig_freezer->state == FROZEN means that @task has been
+	 * frozen, so it's sufficient to check the latter condition.
+	 */
 
 	if (is_task_frozen_enough(task))
 		return -EBUSY;
@@ -173,13 +177,7 @@ static int freezer_can_attach(struct cgroup_subsys *ss,
 	if (freezer->state == CGROUP_FROZEN)
 		return -EBUSY;
 
-	retval = 0;
-	task_lock(task);
-	freezer = task_freezer(task);
-	if (freezer->state == CGROUP_FROZEN)
-		retval = -EBUSY;
-	task_unlock(task);
-	return retval;
+	return 0;
 }
 
 static void freezer_fork(struct cgroup_subsys *ss, struct task_struct *task)
-- 
1.5.4.rc3

