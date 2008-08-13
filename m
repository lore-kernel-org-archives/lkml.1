Return-Path: <linux-kernel-owner+w=401wt.eu-S1753345AbYHMFeh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345AbYHMFeh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 01:34:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751588AbYHMFe3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 01:34:29 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:3346 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336AbYHMFe2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 01:34:28 -0400
Date: Tue, 12 Aug 2008 23:34:27 -0600
From: Alex Chiang <achiang@hp.com>
To: dhowells@redhat.com, jmorris@namei.org, serue@us.ibm.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] CRED: Fixup credentials build breakage
Message-ID: <20080813053427.GA5248@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>, dhowells@redhat.com,
	jmorris@namei.org, serue@us.ibm.com, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A recent patch titled:

	CRED: Separate task security context from task_struct
	
removed task security context from task_struct, but did not
update all locations to use the new struct cred that was
introduced.

The change to task_struct broke perfmon and ia32 syscalls on
ia64.  This patch fixes the build.
---
All things considered, I'd prefer to see this patch folded into
7931c65268777ed10cab22486de149d742a1f269 so we can keep
bisectability. Would that be possible, given that these changes
are "only" in linux-next and haven't hit Linus's tree yet?

My hope for folding in this patch into the bigger patch is the
reason why I didn't refer to the commit by SHA1 in the
changelog...

Also, I'm not exactly sure why wrappers were provided for
task_gid, but then later removed. Additionally, I wasn't sure why
no wrapper was provided for task_suid and friends. But I admit
that I didn't read the patch series in depth; only enough to fix
the build.

 arch/ia64/ia32/sys_ia32.c  |    8 ++++----
 arch/ia64/kernel/perfmon.c |   24 ++++++++++++------------
 2 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/arch/ia64/ia32/sys_ia32.c b/arch/ia64/ia32/sys_ia32.c
index 465116a..950b63a 100644
--- a/arch/ia64/ia32/sys_ia32.c
+++ b/arch/ia64/ia32/sys_ia32.c
@@ -2089,20 +2089,20 @@ sys32_getgroups16 (int gidsetsize, short __user *grouplist)
 	if (gidsetsize < 0)
 		return -EINVAL;
 
-	get_group_info(current->group_info);
-	i = current->group_info->ngroups;
+	get_group_info(current->cred->group_info);
+	i = current->cred->group_info->ngroups;
 	if (gidsetsize) {
 		if (i > gidsetsize) {
 			i = -EINVAL;
 			goto out;
 		}
-		if (groups16_to_user(grouplist, current->group_info)) {
+		if (groups16_to_user(grouplist, current->cred->group_info)) {
 			i = -EFAULT;
 			goto out;
 		}
 	}
 out:
-	put_group_info(current->group_info);
+	put_group_info(current->cred->group_info);
 	return i;
 }
 
diff --git a/arch/ia64/kernel/perfmon.c b/arch/ia64/kernel/perfmon.c
index ffe6de0..7df49bc 100644
--- a/arch/ia64/kernel/perfmon.c
+++ b/arch/ia64/kernel/perfmon.c
@@ -2410,18 +2410,18 @@ pfm_bad_permissions(struct task_struct *task)
 	DPRINT(("cur: uid=%d gid=%d task: euid=%d suid=%d uid=%d egid=%d sgid=%d\n",
 		uid,
 		gid,
-		task->euid,
-		task->suid,
-		task->uid,
-		task->egid,
-		task->sgid));
-
-	return (uid != task->euid)
-	    || (uid != task->suid)
-	    || (uid != task->uid)
-	    || (gid != task->egid)
-	    || (gid != task->sgid)
-	    || (gid != task->gid)) && !capable(CAP_SYS_PTRACE);
+		task_euid(task),
+		task->cred->suid,
+		task_uid(task),
+		task->cred->egid,
+		task->cred->sgid));
+
+	return ((uid != task_euid(task))
+	    || (uid != task->cred->suid)
+	    || (uid != task_uid(task))
+	    || (gid != task->cred->egid)
+	    || (gid != task->cred->sgid)
+	    || (gid != task->cred->gid)) && !capable(CAP_SYS_PTRACE);
 }
 
 static int
-- 
1.5.3.1.gbed62

