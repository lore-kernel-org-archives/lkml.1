Return-Path: <linux-kernel-owner+w=401wt.eu-S1754632AbYKFLFZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754632AbYKFLFZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 06:05:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753449AbYKFLFL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 06:05:11 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:58761 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753287AbYKFLFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 06:05:09 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, Alexey Dobriyan <adobriyan@gmail.com>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       Linux Containers <containers@lists.osdl.org>
References: <m1ej1p2l6u.fsf@frodo.ebiederm.org>
	<m1abcd2kqk.fsf@frodo.ebiederm.org>
	<m163n12ko9.fsf_-_@frodo.ebiederm.org>
	<m1y6zx15yj.fsf_-_@frodo.ebiederm.org>
	<m1skq515ti.fsf_-_@frodo.ebiederm.org>
	<m1od0t15rz.fsf_-_@frodo.ebiederm.org>
Date: Thu, 06 Nov 2008 02:58:20 -0800
In-Reply-To: <m1od0t15rz.fsf_-_@frodo.ebiederm.org> (Eric W. Biederman's
	message of "Thu, 06 Nov 2008 02:57:04 -0800")
Message-ID: <m1k5bh15pv.fsf_-_@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=24.130.11.59;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Rcpt-To: akpm@linux-foundation.org, containers@lists.osdl.org, viro@ZenIV.linux.org.uk, adobriyan@gmail.com, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Andrew Morton <akpm@linux-foundation.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: [PATCH 7/7] proc: Cleanup proc_flush_task.
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: Yes (on mx04.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


- shrink_dcache_parent is guarnateed to only flush dcache entries
  from the specified superblock.  So the the insanely subtle
  PF_EXITING check desgined to avoid flushing filesystems inodes
  that are not safe to call during exit is unecessary.

- The test to avoid excess flushing of dcache entries in proc
  got inverted and generally broken for threads, and frankly
  all it saved was a single d_hash_and_lookup so there was
  very little point to it.  So remove the check and keep
  the code stupid and correct.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/proc/base.c |   11 +++--------
 1 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 8b0d066..cb2222a 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2560,15 +2560,11 @@ static void proc_flush_task_mnt(struct vfsmount *mnt, pid_t pid, pid_t tgid)
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
@@ -2629,13 +2625,12 @@ void proc_flush_task(struct task_struct *task)
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
1.5.3.rc6.17.g1911

