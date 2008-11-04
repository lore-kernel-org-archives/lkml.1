Return-Path: <linux-kernel-owner+w=401wt.eu-S1754548AbYKDGvy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548AbYKDGvy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 01:51:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752171AbYKDGvp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 01:51:45 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:53403 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751709AbYKDGvo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 01:51:44 -0500
Message-ID: <490FF047.2030008@cn.fujitsu.com>
Date: Tue, 04 Nov 2008 14:48:39 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Matt Helsley <matthltc@us.ibm.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>,
       linux-pm@lists.linux-foundation.org, Cedric Le Goater <clg@fr.ibm.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>, Paul Menage <menage@google.com>
Subject: [PATCH] freezer_cg: remove task_lock from freezer_fork()
References: <20080811235323.872291138@us.ibm.com>	 <20080811235325.121356317@us.ibm.com>	 <6599ad830811032143h51eae533k5b0c17e65a7fa675@mail.gmail.com>	 <490FE7B5.8020400@cn.fujitsu.com>
In-Reply-To: <490FE7B5.8020400@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In theory the task can be moved to another cgroup and the freezer will
be freed right after task_lock is dropped, so the lock results in zero
protection.

But in the case of freezer_fork() no lock is needed, since the task
is not in tasklist yet so it won't be moved to another cgroup, so
task->cgroups won't be changed or invalidated.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/cgroup_freezer.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup_freezer.c b/kernel/cgroup_freezer.c
index 7fa476f..6605907 100644
--- a/kernel/cgroup_freezer.c
+++ b/kernel/cgroup_freezer.c
@@ -184,9 +184,13 @@ static void freezer_fork(struct cgroup_subsys *ss, struct task_struct *task)
 {
 	struct freezer *freezer;
 
-	task_lock(task);
+	/*
+	 * No lock is needed, since the task isn't on tasklist yet,
+	 * so it can't be moved to another cgroup, which means the
+	 * freezer won't be removed and will be valid during this
+	 * function call.
+	 */
 	freezer = task_freezer(task);
-	task_unlock(task);
 
 	spin_lock_irq(&freezer->lock);
 	BUG_ON(freezer->state == CGROUP_FROZEN);
-- 
1.5.4.rc3
