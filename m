Return-Path: <linux-kernel-owner+w=401wt.eu-S1754563AbYHML1R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754563AbYHML1R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 07:27:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752778AbYHML1G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 07:27:06 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41363 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752337AbYHML1E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 07:27:04 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20080813053427.GA5248@ldl.fc.hp.com>
References: <20080813053427.GA5248@ldl.fc.hp.com>
To: Alex Chiang <achiang@hp.com>
Cc: dhowells@redhat.com, jmorris@namei.org, serue@us.ibm.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] CRED: Fixup credentials build breakage
X-Mailer: MH-E 8.0.3+cvs; nmh 1.3; GNU Emacs 23.0.50
Date: Wed, 13 Aug 2008 12:26:49 +0100
Message-ID: <15419.1218626809@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Chiang <achiang@hp.com> wrote:

> A recent patch titled:
> 
> 	CRED: Separate task security context from task_struct
> 	
> removed task security context from task_struct, but did not
> update all locations to use the new struct cred that was
> introduced.
> 
> The change to task_struct broke perfmon and ia32 syscalls on
> ia64.  This patch fixes the build.

I've submitted a patch to fix this.

> All things considered, I'd prefer to see this patch folded into
> 7931c65268777ed10cab22486de149d742a1f269 so we can keep
> bisectability. Would that be possible, given that these changes
> are "only" in linux-next and haven't hit Linus's tree yet?

Probably.  I'll have to talk to Stephen about how to do this.  I can't maintain
my patches on top of linux-next now:-/

> Also, I'm not exactly sure why wrappers were provided for
> task_gid, but then later removed. Additionally, I wasn't sure why
> no wrapper was provided for task_suid and friends. But I admit
> that I didn't read the patch series in depth; only enough to fix
> the build.

Generally, accesses to task->gid are accompanied by accesses to task->uid
and/or task->groups, in which case using multiple wrappers in series introduces
excess locking and superfluous memory barriers.  To access task->gid, one must
take the RCU read lock and then use rcu_dereference().

However, I can't use the cred struct until the patch in which it is introduced.
The wrappers, however, allow me to grep for things I've missed, and thus make
it easier to do things in stages.

Your patch also has a couple of issues:

> +	get_group_info(current->cred->group_info);

The call to get_group_info() is not necessary.  Only current may change its own
groups.

> +	    || (uid != task->cred->suid)
> +	    || (gid != task->cred->egid)
> +	    || (gid != task->cred->sgid)
> +	    || (gid != task->cred->gid))

This is incorrect.  You must hold the RCU read lock whilst you make this
access, and you must pass task->cred through rcu_dereference(), or better
still, use __task_cred(task) to get at it.

My patch is below.  Note that there is a problem with it, presumably something
to do with GIT's merging (the ad1848 files being deleted).

David
---
Fix the IA64 arch's use of COW credentials.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/ia64/ia32/sys_ia32.c     |    7 +++----
 arch/ia64/kernel/perfmon.c    |   32 ++++++++++++++++++++------------
 include/sound/ad1848.h        |    0 
 sound/isa/ad1848/ad1848_lib.c |    0 
 4 files changed, 23 insertions(+), 16 deletions(-)
 delete mode 100644 include/sound/ad1848.h
 delete mode 100644 sound/isa/ad1848/ad1848_lib.c

diff --git a/arch/ia64/ia32/sys_ia32.c b/arch/ia64/ia32/sys_ia32.c
index 465116a..7f0704f 100644
--- a/arch/ia64/ia32/sys_ia32.c
+++ b/arch/ia64/ia32/sys_ia32.c
@@ -2084,25 +2084,24 @@ groups16_from_user(struct group_info *group_info, short __user *grouplist)
 asmlinkage long
 sys32_getgroups16 (int gidsetsize, short __user *grouplist)
 {
+	const struct cred *cred = current_cred();
 	int i;
 
 	if (gidsetsize < 0)
 		return -EINVAL;
 
-	get_group_info(current->group_info);
-	i = current->group_info->ngroups;
+	i = cred->group_info->ngroups;
 	if (gidsetsize) {
 		if (i > gidsetsize) {
 			i = -EINVAL;
 			goto out;
 		}
-		if (groups16_to_user(grouplist, current->group_info)) {
+		if (groups16_to_user(grouplist, cred->group_info)) {
 			i = -EFAULT;
 			goto out;
 		}
 	}
 out:
-	put_group_info(current->group_info);
 	return i;
 }
 
diff --git a/arch/ia64/kernel/perfmon.c b/arch/ia64/kernel/perfmon.c
index ffe6de0..a1aead7 100644
--- a/arch/ia64/kernel/perfmon.c
+++ b/arch/ia64/kernel/perfmon.c
@@ -2403,25 +2403,33 @@ error_kmem:
 static int
 pfm_bad_permissions(struct task_struct *task)
 {
+	const struct cred *tcred;
 	uid_t uid = current_uid();
 	gid_t gid = current_gid();
+	int ret;
+
+	rcu_read_lock();
+	tcred = __task_cred(task);
 
 	/* inspired by ptrace_attach() */
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
+		tcred->euid,
+		tcred->suid,
+		tcred->uid,
+		tcred->egid,
+		tcred->sgid));
+
+	ret = ((uid != tcred->euid)
+	       || (uid != tcred->suid)
+	       || (uid != tcred->uid)
+	       || (gid != tcred->egid)
+	       || (gid != tcred->sgid)
+	       || (gid != tcred->gid)) && !capable(CAP_SYS_PTRACE);
+
+	rcu_read_unlock();
+	return ret;
 }
 
 static int
diff --git a/include/sound/ad1848.h b/include/sound/ad1848.h
deleted file mode 100644
index e69de29..0000000
diff --git a/sound/isa/ad1848/ad1848_lib.c b/sound/isa/ad1848/ad1848_lib.c
deleted file mode 100644
index e69de29..0000000

