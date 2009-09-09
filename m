Return-Path: <linux-kernel-owner+w=401wt.eu-S1752591AbZIIAVN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752591AbZIIAVN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 20:21:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752169AbZIIAVM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 20:21:12 -0400
Received: from joe.mail.tiscali.it ([213.205.33.54]:49168 "EHLO
	joe.mail.tiscali.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900AbZIIAVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 20:21:12 -0400
From: Giuseppe Scrivano <gscrivano@gnu.org>
To: linux-kernel@vger.kernel.org
Subject: extend inotify to support file descriptors in addition to paths
CC: bug-coreutils@gnu.org
Date: Wed, 09 Sep 2009 02:21:09 +0200
Message-ID: <87fxaxvuh6.fsf@master.homenet>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

at the moment inotify permits to add new files to be watched using their
path.  There are situations where the file path is not know but a
descriptor is available.  It would be desiderable to have the
possibility to use the inotify system even in these (rare) cases.

A concrete example of application that can take advantage of this
possibility is GNU tail.  GNU tail, since version 7.5, is using inotify
to watch changes on files.  This command will make `tail' sleeps until
some events are catched:

     tail -qf foo bar baz

Inotify can't be used when stdin is watched too:

    tail -qf boo bar - < baz

While the user gets the same result, internally it is a completely
different thing because polling is done on stdin instead of graciously
sleep until something is ready.
I don't know if it is possible to obtain the former result when the fd
is know but the path isn't.


My proposal is to extend inotify adding a new syscall:

   long sys_inotify_add_watch_fd(int wd, int fd, u32 mask);

in this way the same mechanism can be used indifferently either a
descriptor or on a path is provided.

What do you think about this idea?  Is there another way to get the same
result?

Regards,
Giuseppe


P.S.
In the attached patch I changed the syscalls table only for x86.

>From 6f3340347fb5d26000bec3a0a9cd8ef59c710922 Mon Sep 17 00:00:00 2001
From: Giuseppe Scrivano <gscrivano@gnu.org>
Date: Tue, 8 Sep 2009 23:40:03 +0200
Subject: [PATCH] Add new syscall \`inotify_add_watch_fd'.

It makes possible to register a file to be watched by inotify using
its file descriptor instead of its path.
---
 arch/x86/kernel/syscall_table_32.S |    1 +
 fs/notify/inotify/inotify_user.c   |   54 ++++++++++++++++++++++++++++++++++--
 include/linux/syscalls.h           |    3 ++
 3 files changed, 55 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/syscall_table_32.S b/arch/x86/kernel/syscall_table_32.S
index d51321d..46eb4ac 100644
--- a/arch/x86/kernel/syscall_table_32.S
+++ b/arch/x86/kernel/syscall_table_32.S
@@ -336,3 +336,4 @@ ENTRY(sys_call_table)
 	.long sys_pwritev
 	.long sys_rt_tgsigqueueinfo	/* 335 */
 	.long sys_perf_counter_open
+	.long sys_inotify_add_watch_fd
diff --git a/fs/notify/inotify/inotify_user.c b/fs/notify/inotify/inotify_user.c
index dcd2040..53f3c41 100644
--- a/fs/notify/inotify/inotify_user.c
+++ b/fs/notify/inotify/inotify_user.c
@@ -747,16 +747,64 @@ SYSCALL_DEFINE3(inotify_add_watch, int, fd, const char __user *, pathname,
 
 	/* create/update an inode mark */
 	ret = inotify_update_watch(group, inode, mask);
-	if (unlikely(ret))
-		goto path_put_and_out;
 
-path_put_and_out:
 	path_put(&path);
 fput_and_out:
 	fput_light(filp, fput_needed);
 	return ret;
 }
 
+SYSCALL_DEFINE3(inotify_add_watch_fd, int, wd, int, fd,	u32, mask)
+{
+	struct fsnotify_group *group;
+	struct inode *inode;
+	struct path path;
+	struct file *filp;
+	struct file *filp2;
+	int ret, fput_needed, fput2_needed;
+	unsigned flags = 0;
+
+	filp = fget_light(wd, &fput_needed);
+	if (unlikely(!filp))
+		return -EBADF;
+
+	/* verify that this is indeed an inotify instance */
+	if (unlikely(filp->f_op != &inotify_fops)) {
+		ret = -EINVAL;
+		goto fput_and_out;
+	}
+
+	if (!(mask & IN_DONT_FOLLOW))
+		flags |= LOOKUP_FOLLOW;
+	if (mask & IN_ONLYDIR)
+		flags |= LOOKUP_DIRECTORY;
+
+	filp2 = fget_light(fd, &fput2_needed);
+
+	if (unlikely(!filp2)){
+		ret = -EBADF;
+		goto fput_and_out;
+	}
+
+	/* you can only watch an inode if you have read permissions on it */
+	ret = inode_permission(filp2->f_path.dentry->d_inode, MAY_READ);
+	if (ret)
+		goto fput2_and_out;
+
+	/* inode held in place by reference to path; group by fget on fd */
+	inode = filp2->f_path.dentry->d_inode;
+	group = filp->private_data;
+
+	/* create/update an inode mark */
+  ret = inotify_update_watch(group, inode, mask);
+
+fput2_and_out:
+	fput_light(filp2, fput2_needed);
+fput_and_out:
+	fput_light(filp, fput_needed);
+	return ret;
+}
+
 SYSCALL_DEFINE2(inotify_rm_watch, int, fd, __s32, wd)
 {
 	struct fsnotify_group *group;
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 80de700..0833b1d 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -761,4 +761,7 @@ int kernel_execve(const char *filename, char *const argv[], char *const envp[]);
 asmlinkage long sys_perf_counter_open(
 		struct perf_counter_attr __user *attr_uptr,
 		pid_t pid, int cpu, int group_fd, unsigned long flags);
+
+
+asmlinkage long sys_inotify_add_watch_fd(int wd, int fd, u32 mask);
 #endif
-- 
1.6.3.3
