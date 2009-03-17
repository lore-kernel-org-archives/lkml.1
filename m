Return-Path: <linux-kernel-owner+w=401wt.eu-S1756349AbZCQP7m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756349AbZCQP7m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 11:59:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753768AbZCQP7b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 11:59:31 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:37139 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753624AbZCQP7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 11:59:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=BZjQyiVsgMnVR7/RRpBHdu487ET6+bSN76AdK+A+Prn1DNZ9cYTFUfXK6Uof1ZTbWV
         7Y7h/wgPQJQ2vXSJdhuRFrOB834xZW6d+RKutCQpWMqEbhU+CZCDgcUq5qGED7A4rYKk
         VPH8bp9yoIfVXlTJ3td4Lb58DGAh2Pgiqe4EI=
Date: Tue, 17 Mar 2009 19:06:38 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, r0bertz@gentoo.org, viro@ZenIV.linux.org.uk
Subject: [GIT] /proc/*/task getdents fixlet
Message-ID: <20090317160638.GA2246@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[third time Linus's email should written right]

Linus, please from

	git://git.kernel.org/pub/scm/linux/kernel/git/adobriyan/proc.git proc-linus

to get the following patch:

Zhang Le (1):
      proc: update ->f_pos correctly in proc_task_readdir()

fs/proc/base.c |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

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
+	switch ((unsigned long)filp->f_pos) {
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
