Return-Path: <linux-kernel-owner+w=401wt.eu-S1755177AbZAEX3z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755177AbZAEX3z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 18:29:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752288AbZAEX3h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 18:29:37 -0500
Received: from mail-ew0-f17.google.com ([209.85.219.17]:40952 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755105AbZAEX3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 18:29:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=EpynVZ5GMK6C6cP3j3zftrLcXZpYapcrqR/QUILxoio818+LU0ZEviKp7uQlvvO4iZ
         jsl2K0emmCRshF0O3ryMPRoSQJ6HijXJGDPU+STv0LMD8WxdYOkJm4Z5bnRPkbbLF0V6
         vil4VdA57XK9VeR5lSHJIzPdGP2jfZNHKmN+8=
Date: Tue, 6 Jan 2009 02:34:47 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: ebiederm@xmission.com, viro@zeniv.linux.org.uk
Cc: linux-kernel@vger.kernel.org, containers@lists.osdl.org, sds@tycho.nsa.gov,
       jmorris@namei.org
Subject: [PATCH 6/6] proc: cleanup proc_flush_task()
Message-ID: <20090105233447.GF3924@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From f9485836e531dec10b15bf97e95dc20fa2d6914a Mon Sep 17 00:00:00 2001
From: Eric W. Biederman <ebiederm@xmission.com>
Date: Wed, 19 Nov 2008 05:16:17 +0300
Subject: [PATCH 6/6] proc: cleanup proc_flush_task()

- shrink_dcache_parent is guaranteed to only flush dcache entries
  from the specified superblock.  So the the insanely subtle
  PF_EXITING check designed to avoid flushing filesystems inodes
  that are not safe to call during exit is unecessary.

- The test to avoid excess flushing of dcache entries in proc
  got inverted and generally broken for threads, and frankly
  all it saved was a single d_hash_and_lookup so there was
  very little point to it.  So remove the check and keep
  the code stupid and correct.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 fs/proc/base.c |   11 +++--------
 1 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index a4b7cac..e43a013 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2600,15 +2600,11 @@ static void proc_flush_task_mnt(struct vfsmount *mnt, pid_t pid, pid_t tgid)
 	name.len = snprintf(buf, sizeof(buf), "%d", pid);
 	dentry = d_hash_and_lookup(mnt->mnt_root, &name);
 	if (dentry) {
-		if (!(current->flags & PF_EXITING))
-			shrink_dcache_parent(dentry);
+		shrink_dcache_parent(dentry);
 		d_drop(dentry);
 		dput(dentry);
 	}
 
-	if (tgid == 0)
-		goto out;
-
 	name.name = buf;
 	name.len = snprintf(buf, sizeof(buf), "%d", tgid);
 	leader = d_hash_and_lookup(mnt->mnt_root, &name);
@@ -2669,13 +2665,12 @@ void proc_flush_task(struct task_struct *task)
 	struct upid *upid;
 
 	pid = task_pid(task);
-	if (thread_group_leader(task))
-		tgid = task_tgid(task);
+	tgid = task_tgid(task);
 
 	for (i = 0; i <= pid->level; i++) {
 		upid = &pid->numbers[i];
 		proc_flush_task_mnt(upid->ns->proc_mnt, upid->nr,
-			tgid ? tgid->numbers[i].nr : 0);
+				    tgid->numbers[i].nr);
 	}
 
 	upid = &pid->numbers[pid->level];
-- 
1.5.6.5

