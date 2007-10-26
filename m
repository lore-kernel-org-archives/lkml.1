Return-Path: <linux-kernel-owner+w=401wt.eu-S1761867AbXJZTti@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761867AbXJZTti (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 15:49:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751905AbXJZTtb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 15:49:31 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:52841 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301AbXJZTta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 15:49:30 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@ftp.linux.org.uk>,
       linux-kernel@vger.kernel.org, Pavel Emelyanov <xemul@openvz.org>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       Linux Containers <containers@lists.osdl.org>
Subject: [PATCH] proc: Simplify and correct proc_flush_task
References: <m1y7dp22d4.fsf@ebiederm.dsl.xmission.com>
	<alpine.LFD.0.999.0710261105440.30120@woody.linux-foundation.org>
Date: Fri, 26 Oct 2007 13:43:28 -0600
In-Reply-To: <alpine.LFD.0.999.0710261105440.30120@woody.linux-foundation.org>
	(Linus Torvalds's message of "Fri, 26 Oct 2007 11:06:52 -0700 (PDT)")
Message-ID: <m1r6jhzmov.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Currently we special case when we have only the initial pid namespace.
Unfortunately in doing so the copied case for the other namespaces was
broken so we don't properly flush the thread directories :(

So this patch removes the unnecessary special case (removing a
usage of proc_mnt) and corrects the flushing of the thread directories.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/proc/base.c |   15 ++++++---------
 1 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index aeaf0d0..a17c268 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2328,21 +2328,18 @@ out:
 
 void proc_flush_task(struct task_struct *task)
 {
-	int i, leader;
-	struct pid *pid, *tgid;
+	int i;
+	struct pid *pid, *tgid = NULL;
 	struct upid *upid;
 
-	leader = thread_group_leader(task);
-	proc_flush_task_mnt(proc_mnt, task->pid, leader ? task->tgid : 0);
 	pid = task_pid(task);
-	if (pid->level == 0)
-		return;
+	if (thread_group_leader(task))
+		tgid = task_tgid(task);
 
-	tgid = task_tgid(task);
-	for (i = 1; i <= pid->level; i++) {
+	for (i = 0; i <= pid->level; i++) {
 		upid = &pid->numbers[i];
 		proc_flush_task_mnt(upid->ns->proc_mnt, upid->nr,
-				leader ? 0 : tgid->numbers[i].nr);
+			tgid ? tgid->numbers[i].nr : 0);
 	}
 
 	upid = &pid->numbers[pid->level];
-- 
1.5.3.rc6.17.g1911

