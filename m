Return-Path: <linux-kernel-owner+w=401wt.eu-S1755228AbYJUAv2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755228AbYJUAv2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 20:51:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752755AbYJUAvV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 20:51:21 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57193 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752822AbYJUAvU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 20:51:20 -0400
Message-ID: <48FD2784.30906@cn.fujitsu.com>
Date: Tue, 21 Oct 2008 08:51:16 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Matt Helsley <matthltc@us.ibm.com>, Cedric Le Goater <clg@fr.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Subject: [PATCH 3/4] freezer_cg: use thaw_process() in unfreeze_cgroup()
References: <48FD26F5.1070809@cn.fujitsu.com> <48FD273F.3040505@cn.fujitsu.com>
In-Reply-To: <48FD273F.3040505@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't duplicate the implementation of thaw_process().

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/cgroup_freezer.c |   15 ++++-----------
 1 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/kernel/cgroup_freezer.c b/kernel/cgroup_freezer.c
index 6fadafe..3ea57e4 100644
--- a/kernel/cgroup_freezer.c
+++ b/kernel/cgroup_freezer.c
@@ -275,25 +275,18 @@ static int try_to_freeze_cgroup(struct cgroup *cgroup, struct freezer *freezer)
 	return num_cant_freeze_now ? -EBUSY : 0;
 }
 
-static int unfreeze_cgroup(struct cgroup *cgroup, struct freezer *freezer)
+static void unfreeze_cgroup(struct cgroup *cgroup, struct freezer *freezer)
 {
 	struct cgroup_iter it;
 	struct task_struct *task;
 
 	cgroup_iter_start(cgroup, &it);
 	while ((task = cgroup_iter_next(cgroup, &it))) {
-		int do_wake;
-
-		task_lock(task);
-		do_wake = __thaw_process(task);
-		task_unlock(task);
-		if (do_wake)
-			wake_up_process(task);
+		thaw_process(task);
 	}
 	cgroup_iter_end(cgroup, &it);
-	freezer->state = CGROUP_THAWED;
 
-	return 0;
+	freezer->state = CGROUP_THAWED;
 }
 
 static int freezer_change_state(struct cgroup *cgroup,
@@ -320,7 +313,7 @@ static int freezer_change_state(struct cgroup *cgroup,
 		}
 		/* state == FREEZING and goal_state == THAWED, so unfreeze */
 	case CGROUP_FROZEN:
-		retval = unfreeze_cgroup(cgroup, freezer);
+		unfreeze_cgroup(cgroup, freezer);
 		break;
 	default:
 		break;
-- 
1.5.4.rc3
