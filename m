Return-Path: <linux-kernel-owner+w=401wt.eu-S1754562AbYJ2THX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754562AbYJ2THX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 15:07:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753339AbYJ2THI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 15:07:08 -0400
Received: from mx2.redhat.com ([66.187.237.31]:37665 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753253AbYJ2THG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 15:07:06 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH -v1 2/3] vm: use new has_capability_noaudit
To: linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org
Cc: sds@tycho.nsa.gov, jmorris@nameil.org, serue@us.ibm.com, morgan@kernel.org,
       casey@schaufler-ca.com, esandeen@redhat.com
Date: Wed, 29 Oct 2008 15:06:58 -0400
Message-ID: <20081029190658.31292.10620.stgit@paris.rdu.redhat.com>
In-Reply-To: <20081029190652.31292.5901.stgit@paris.rdu.redhat.com>
References: <20081029190652.31292.5901.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The oomkiller calculations make decisions based on capabilities.  Since
these are not security decisions and LSMs should not record if they fall
the request they should use the new has_capability_noaudit() interface so
the denials will not be recorded.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 fs/proc/base.c |    2 +-
 mm/oom_kill.c  |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 486cf3f..ef83e81 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1020,7 +1020,7 @@ static ssize_t oom_adjust_write(struct file *file, const char __user *buf,
 	task = get_proc_task(file->f_path.dentry->d_inode);
 	if (!task)
 		return -ESRCH;
-	if (oom_adjust < task->oomkilladj && !capable(CAP_SYS_RESOURCE)) {
+	if (oom_adjust < task->oomkilladj && !has_capability_noaudit(current, CAP_SYS_RESOURCE)) {
 		put_task_struct(task);
 		return -EACCES;
 	}
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 64e5b4b..34a458a 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -129,8 +129,8 @@ unsigned long badness(struct task_struct *p, unsigned long uptime)
 	 * Superuser processes are usually more important, so we make it
 	 * less likely that we kill those.
 	 */
-	if (has_capability(p, CAP_SYS_ADMIN) ||
-	    has_capability(p, CAP_SYS_RESOURCE))
+	if (has_capability_noaudit(p, CAP_SYS_ADMIN) ||
+	    has_capability_noaudit(p, CAP_SYS_RESOURCE))
 		points /= 4;
 
 	/*
@@ -139,7 +139,7 @@ unsigned long badness(struct task_struct *p, unsigned long uptime)
 	 * tend to only have this flag set on applications they think
 	 * of as important.
 	 */
-	if (has_capability(p, CAP_SYS_RAWIO))
+	if (has_capability_noaudit(p, CAP_SYS_RAWIO))
 		points /= 4;
 
 	/*

