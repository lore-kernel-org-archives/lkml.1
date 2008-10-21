Return-Path: <linux-kernel-owner+w=401wt.eu-S1754646AbYJUAtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754646AbYJUAtS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 20:49:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751968AbYJUAtI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 20:49:08 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60090 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751291AbYJUAtG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 20:49:06 -0400
Message-ID: <48FD26F5.1070809@cn.fujitsu.com>
Date: Tue, 21 Oct 2008 08:48:53 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Matt Helsley <matthltc@us.ibm.com>, Cedric Le Goater <clg@fr.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Subject: [PATCH 1/4] freezer_cg: fix improper BUG_ON() causing oops
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The BUG_ON() should be protected by freezer->lock, otherwise it
can be triggered easily when a task has been unfreezed but the
corresponding cgroup hasn't been changed to FROZEN state.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/cgroup_freezer.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/cgroup_freezer.c b/kernel/cgroup_freezer.c
index e950569..7f54d1c 100644
--- a/kernel/cgroup_freezer.c
+++ b/kernel/cgroup_freezer.c
@@ -190,8 +190,9 @@ static void freezer_fork(struct cgroup_subsys *ss, struct task_struct *task)
 	freezer = task_freezer(task);
 	task_unlock(task);
 
-	BUG_ON(freezer->state == CGROUP_FROZEN);
 	spin_lock_irq(&freezer->lock);
+	BUG_ON(freezer->state == CGROUP_FROZEN);
+
 	/* Locking avoids race with FREEZING -> THAWED transitions. */
 	if (freezer->state == CGROUP_FREEZING)
 		freeze_task(task, true);
-- 
1.5.4.rc3

