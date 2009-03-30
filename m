Return-Path: <linux-kernel-owner+w=401wt.eu-S1755871AbZC3WtX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755871AbZC3WtX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 18:49:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751192AbZC3WtM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 18:49:12 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:1904 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929AbZC3WtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 18:49:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=vRQQMFKhu34qpTTL3zxNCKIpJvQfSO4LsnrclgQ5pTFKkKwxodjvCBEkUwrh0CCpkT
         aUP09As/faNQ1yjPJ0o06g429ZUz+h5BFsiwfbGJraqrEFeeYws5hPdIVdRJBIVN87b5
         zHgL+c5tibmkbeoZrJR1nV7njuo34vqO+Nx/o=
Date: Tue, 31 Mar 2009 02:56:41 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: viro@ZenIV.linux.org.uk
Cc: ebiederm@xmission.com, linux-kernel@vger.kernel.org, andrea@suse.de
Subject: [PATCH] proc 6/6: cleanup proc_flush_task()
Message-ID: <20090330225641.GG19892@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From d789ba9bf62f4fffa0ad75c22815abdf5f46fb06 Mon Sep 17 00:00:00 2001
From: Eric W. Biederman <ebiederm@xmission.com>
Date: Wed, 19 Nov 2008 05:16:17 +0300
Subject: [PATCH 11/11] proc 6/6: cleanup proc_flush_task()

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
index 82eea38..0cb37f1 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2578,15 +2578,11 @@ static void proc_flush_task_mnt(struct vfsmount *mnt, pid_t pid, pid_t tgid)
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
@@ -2647,13 +2643,12 @@ void proc_flush_task(struct task_struct *task)
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

