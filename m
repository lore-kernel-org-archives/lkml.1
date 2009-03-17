Return-Path: <linux-kernel-owner+w=401wt.eu-S1759606AbZCQNtI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759606AbZCQNtI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 09:49:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754522AbZCQNsx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 09:48:53 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:47469 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753938AbZCQNsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 09:48:52 -0400
X-Greylist: delayed 488 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Mar 2009 09:48:51 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=ZoGoAXsFacNP7oJFLj8DwuYnlEfwn/MKNJkWb33NiMa+TjqKD5klrCr988RA0MCgbG
         K/KA7bsM3jMOP3LgVwQIn5TRKERwtV+q3y3bWlJ9cDc8CpejH+hwZCwmZ9t6G+8cJG+N
         jQXlPT2+glUeasrlztrrpy3VtFIj02VxxqzKU=
Date: Tue, 17 Mar 2009 16:47:51 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: torvals@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, r0bertz@gentoo.org, viro@ZenIV.linux.org.uk
Subject: [GIT] /proc/*/task getdentds fixlet
Message-ID: <20090317134751.GA3907@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
