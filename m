Return-Path: <linux-kernel-owner+w=401wt.eu-S1161087AbXAaXkd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161087AbXAaXkd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 18:40:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161092AbXAaXkd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 18:40:33 -0500
Received: from smtp4-g19.free.fr ([212.27.42.30]:55408 "EHLO smtp4-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161087AbXAaXkc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 18:40:32 -0500
Message-ID: <45C12953.4070205@yahoo.fr>
Date: Thu, 01 Feb 2007 00:42:11 +0100
From: Guillaume Chazarain <guichaz@yahoo.fr>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] procfs: Fix listing of /proc/NOT_A_TGID/task
Content-Type: multipart/mixed;
 boundary="------------090002070403080906060904"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090002070403080906060904
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

I think this is 2.6.20 material, if it gets appropriately reviewed ;-)

Thanks.

-- 
Guillaume


--------------090002070403080906060904
Content-Type: text/x-patch;
 name="procfs-fix-task-on-non-leader.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="procfs-fix-task-on-non-leader.patch"

Listing /proc/PID/task were PID is not a TGID
should not result in duplicated entries.

[g ~]$ pidof thunderbird-bin
2751
[g ~]$ ls /proc/2751/task
2751  2770  2771  2824  2826  2834  2835  2851  2853
[g ~]$ ls /proc/2770/task
2751  2770  2771  2824  2826  2834  2835  2851  2853
2770  2771  2824  2826  2834  2835  2851  2853
[g ~]$ 

Signed-off-by: Guillaume Chazarain <guichaz@yahoo.fr>
---

 fs/proc/base.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff -r f99a8b402753 fs/proc/base.c
--- a/fs/proc/base.c	Wed Jan 31 05:00:31 2007 +0000
+++ b/fs/proc/base.c	Thu Feb 01 00:25:33 2007 +0100
@@ -2328,13 +2328,23 @@ static int proc_task_readdir(struct file
 {
 	struct dentry *dentry = filp->f_path.dentry;
 	struct inode *inode = dentry->d_inode;
-	struct task_struct *leader = get_proc_task(inode);
+	struct task_struct *leader = NULL;
 	struct task_struct *task;
 	int retval = -ENOENT;
 	ino_t ino;
 	int tid;
 	unsigned long pos = filp->f_pos;  /* avoiding "long long" filp->f_pos */
 
+	task = get_proc_task(inode);
+	if (!task)
+		goto out_no_task;
+	rcu_read_lock();
+	if (pid_alive(task)) {
+		leader = task->group_leader;
+		get_task_struct(leader);
+	}
+	rcu_read_unlock();
+	put_task_struct(task);
 	if (!leader)
 		goto out_no_task;
 	retval = 0;

--------------090002070403080906060904--
