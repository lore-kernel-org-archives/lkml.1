Return-Path: <linux-kernel-owner+w=401wt.eu-S1755122AbZCPGvk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755122AbZCPGvk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 02:51:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751428AbZCPGva
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 02:51:30 -0400
Received: from xylophone.i-cable.com ([203.83.115.99]:64867 "HELO
	xylophone.i-cable.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751354AbZCPGv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 02:51:29 -0400
X-Greylist: delayed 395 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Mar 2009 02:51:29 EDT
From: Zhang Le <r0bertz@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: torvalds@osdl.org, alan@redhat.com, Zhang Le <r0bertz@gentoo.org>
Subject: [PATCH] filp->f_pos not correctly updated in proc_task_readdir
Date: Mon, 16 Mar 2009 14:44:31 +0800
Message-Id: <1237185871-3343-1-git-send-email-r0bertz@gentoo.org>
X-Mailer: git-send-email 1.6.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

filp->f_pos only get updated at the end of the function. Thus d_off of those
dirents who are in the middle will be 0, and this will cause a problem in
glibc's readdir implementation, specifically endless loop. Because when overflow
occurs, f_pos will be set to next dirent to read, however it will be 0, unless
the next one is the last one. So it will start over again and again.

There is a sample program in man 2 gendents. This is the output of the program
running on a multithread program's task dir before this patch is applied:

$ ./a.out /proc/3807/task
--------------- nread=128 ---------------
i-node#  file type  d_reclen  d_off   d_name
  506442  directory    16          1  .
  506441  directory    16          0  ..
  506443  directory    16          0  3807
  506444  directory    16          0  3809
  506445  directory    16          0  3812
  506446  directory    16          0  3861
  506447  directory    16          0  3862
  506448  directory    16          8  3863

This is the output after this patch is applied

$ ./a.out /proc/3807/task
--------------- nread=128 ---------------
i-node#  file type  d_reclen  d_off   d_name
  506442  directory    16          1  .
  506441  directory    16          2  ..
  506443  directory    16          3  3807
  506444  directory    16          4  3809
  506445  directory    16          5  3812
  506446  directory    16          6  3861
  506447  directory    16          7  3862
  506448  directory    16          8  3863

Signed-off-by: Zhang Le <r0bertz@gentoo.org>
---
 fs/proc/base.c |   16 +++++++---------
 1 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 0c9de19..cc6ea23 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -3066,7 +3066,6 @@ static int proc_task_readdir(struct file * filp, void * dirent, filldir_t filldi
 	int retval = -ENOENT;
 	ino_t ino;
 	int tid;
-	unsigned long pos = filp->f_pos;  /* avoiding "long long" filp->f_pos */
 	struct pid_namespace *ns;
 
 	task = get_proc_task(inode);
@@ -3083,18 +3082,18 @@ static int proc_task_readdir(struct file * filp, void * dirent, filldir_t filldi
 		goto out_no_task;
 	retval = 0;
 
-	switch (pos) {
+	switch (filp->f_pos) {
 	case 0:
 		ino = inode->i_ino;
-		if (filldir(dirent, ".", 1, pos, ino, DT_DIR) < 0)
+		if (filldir(dirent, ".", 1, filp->f_pos, ino, DT_DIR) < 0)
 			goto out;
-		pos++;
+		filp->f_pos++;
 		/* fall through */
 	case 1:
 		ino = parent_ino(dentry);
-		if (filldir(dirent, "..", 2, pos, ino, DT_DIR) < 0)
+		if (filldir(dirent, "..", 2, filp->f_pos, ino, DT_DIR) < 0)
 			goto out;
-		pos++;
+		filp->f_pos++;
 		/* fall through */
 	}
 
@@ -3104,9 +3103,9 @@ static int proc_task_readdir(struct file * filp, void * dirent, filldir_t filldi
 	ns = filp->f_dentry->d_sb->s_fs_info;
 	tid = (int)filp->f_version;
 	filp->f_version = 0;
-	for (task = first_tid(leader, tid, pos - 2, ns);
+	for (task = first_tid(leader, tid, filp->f_pos - 2, ns);
 	     task;
-	     task = next_tid(task), pos++) {
+	     task = next_tid(task), filp->f_pos++) {
 		tid = task_pid_nr_ns(task, ns);
 		if (proc_task_fill_cache(filp, dirent, filldir, task, tid) < 0) {
 			/* returning this tgid failed, save it as the first
@@ -3117,7 +3116,6 @@ static int proc_task_readdir(struct file * filp, void * dirent, filldir_t filldi
 		}
 	}
 out:
-	filp->f_pos = pos;
 	put_task_struct(leader);
 out_no_task:
 	return retval;
-- 
1.6.2

