Return-Path: <linux-kernel-owner+w=401wt.eu-S934790AbYCSUpT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934790AbYCSUpT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 16:45:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757887AbYCSToJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:44:09 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55887 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758109AbYCSTn0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:43:26 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20080229004405.4142.32147.stgit@warthog.procyon.org.uk>
References: <20080229004405.4142.32147.stgit@warthog.procyon.org.uk> <20080229004332.4142.51771.stgit@warthog.procyon.org.uk>
To: akpm@linux-foundation.org, torvalds@osdl.org
Cc: dhowells@redhat.com, Trond.Myklebust@netapp.com, chuck.lever@oracle.com,
       nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org
Subject: Performance degradation measurement [was Re: [PATCH 06/37] Security: Separate task security context from task_struct [ver #34]]
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Date: Wed, 19 Mar 2008 17:12:08 +0000
Message-ID: <17688.1205946728@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=

David Howells <dhowells@redhat.com> wrote:

> Separate the task security context from task_struct.  At this point, the
> security data is temporarily embedded in the task_struct with two pointers
> pointing to it.

This patch degrades performance of the kernel in general.  This is because
accessing the security data (UID, GID, groups list, LSM security pointer, etc)
requires an extra dereference (eg: task->uid => task->act_as->uid).

I've done some benchmarking to attempt to determine what the degradation is.

Firstly, the setup: my test machine has a Core 2 Duo CPU and a gig of RAM.  The
system is running as limited a set of daemons as I can get away with - this
means no syslogd, no klogd - as these can make the timings unstable.
Basically, init, mgetty, sshd and auditd are it.

On the test machines's disk is a test partition with 266 directories and 19255
files distributed across those directories.  For each test, the system is
rebooted, then the test partition is mounted:

	mount /dev/sda6 /var/fscache/ -o user_xattr,noatime,ro

and the test program attached is run a couple of times to make sure that the
disk backing that partition need not be touched again (the whole metadata fits
in RAM):

	time /tmp/openit /var/fscache

Then the program is run nine times in succession and the 'real' values emitted
by the time program are averaged.

The program stats and opens each regular file and directory in the tree,
reading and recursing into each directory.  It does not read any data from the
regular files as this is likely to swamp the variance due to this security
patch.


So, I did five runs with different sets of patches and configurations:

 (1) SELinux enabled, none of the security patches:

	(gdb) p (1.119+1.110+1.104+1.106+1.095+1.112+1.094+1.091+1.112)/9
	$3 = 1.104777777777777

 (2) SELinux enabled, all the security patches:

	(gdb) p (1.204+1.190+1.182+1.190+1.200+1.205+1.199+1.197+1.209)/9
	$2 = 1.1973333333333329

The percentage degradation is:

	(gdb) p 1.1973333333333329/1.104777777777777
	$4 = 1.0837775319320126

or about 8.4%.


I then created a performance improvement patch (attached) to reduce the number
of times current->act_as was calculated and applied that:

 (3) SELinux enabled, all the security patches plus performance patch:

	(gdb) p (1.212+1.161+1.202+1.205+1.203+1.151+1.195+1.205+1.186)/9
	$2 = 1.1911111111111106

The percentage degradation is

	(gdb) p 1.1911111111111106/1.104777777777777
	$3 = 1.0781454289449866

about 7.8%.


I then turned SELinux off to see how much of a difference that made:

 (4) LSM/SELinux disabled, none of the security patches:

	(gdb) p (1.121+1.136+1.137+1.121+1.122+1.131+1.121+1.131+1.118)/9
	$7 = 1.1264444444444437

 (5) LSM/SELinux disabled, all the security patches:

	(gdb) p (1.120+1.129+1.116+1.115+1.114+1.129+1.127+1.124+1.128)/9
	$6 = 1.1224444444444437

This resulted in an improvement, which is slightly odd:

	(gdb) p 1.1224444444444437/1.1264444444444437
	$8 = 0.99644900374827372

or about -0.4%.


For some reason the results returned by the time program are quite variable,
but I'm not sure why.  I suspect that with SELinux off, the difference in times
is within the variance of the results.

The performance improvement patch can probably be itself improved by passing
the calculated value of current->act_as down into LSM hooks instead of current
if the former is available.  Similarly, passing this into capable() or similar
could probably improve things too, but there are a couple of problems there as
the auditing code in SELinux's task_has_capability() wants to access the
task_struct for pid and comm:-/

David


--=-=-=
Content-Type: text/x-c
Content-Disposition: attachment; filename=openit.c
Content-Description: File opener test program

/* Simple recurive open test
 *
 * Copyright (C) 2008 Red Hat, Inc. All Rights Reserved.
 * Written by David Howells (dhowells@redhat.com)
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public Licence
 * as published by the Free Software Foundation; either version
 * 2 of the Licence, or (at your option) any later version.
 */

#define _GNU_SOURCE
#include <stdio.h>
#include <string.h>
#include <dirent.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/stat.h>

void process(int dirfd, const char *filename);

void process_dir(int dirfd, const char *filename)
{
	struct dirent *de;
	DIR *dir;
	int fd;

	dir = fdopendir(dirfd);
	if (dir) {
		while (de = readdir(dir)) {
			if (de->d_name[0] == '.' &&
			    (de->d_name[1] == '\0' ||
			     de->d_name[1] == '.' && de->d_name[2] == '\0'))
				continue;
			process(dirfd, de->d_name);
		}

		closedir(dir);
	}
}

void process(int dirfd, const char *filename)
{
	struct stat st;
	int fd;

	if (fstatat(dirfd, filename, &st, AT_SYMLINK_NOFOLLOW) >= 0) {
		if (S_ISREG(st.st_mode)) {
			fd = openat(dirfd, filename, O_RDONLY);
			if (fd >= 0)
				close(fd);
		} else if (S_ISDIR(st.st_mode)) {
			fd = openat(dirfd, filename, O_RDONLY | O_DIRECTORY);
			if (fd >= 0)
				process_dir(fd, filename);
		}
	}
}

int main(int argc, char **argv)
{
	for (argv++; *argv; argv++)
		process(AT_FDCWD, *argv);
	return 0;
}

--=-=-=
Content-Type: text/x-c
Content-Disposition: attachment; filename=15-security-speed-ext3.diff
Content-Description: Performance improvement patch

Security: Improve performance by reusing current->act_as calculations

From: David Howells <dhowells@redhat.com>

Improve performance of the subjective security patches a little by reusing
current->act_as calculations in a few places.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/attr.c             |   13 +++++++------
 fs/namei.c            |   11 +++++++----
 fs/posix_acl.c        |    9 +++++----
 include/linux/fs.h    |    4 +++-
 include/linux/sched.h |    8 +++++++-
 kernel/sys.c          |    3 +--
 6 files changed, 30 insertions(+), 18 deletions(-)


diff --git a/fs/attr.c b/fs/attr.c
index 117cca7..ba90b9f 100644
--- a/fs/attr.c
+++ b/fs/attr.c
@@ -20,6 +20,7 @@
 /* POSIX UID/GID verification for setting inode attributes. */
 int inode_change_ok(struct inode *inode, struct iattr *attr)
 {
+	struct task_security *act_as = current->act_as;
 	int retval = -EPERM;
 	unsigned int ia_valid = attr->ia_valid;
 
@@ -29,30 +30,30 @@ int inode_change_ok(struct inode *inode, struct iattr *attr)
 
 	/* Make sure a caller can chown. */
 	if ((ia_valid & ATTR_UID) &&
-	    (current_fsuid() != inode->i_uid ||
+	    (act_as->uid != inode->i_uid ||
 	     attr->ia_uid != inode->i_uid) && !capable(CAP_CHOWN))
 		goto error;
 
 	/* Make sure caller can chgrp. */
 	if ((ia_valid & ATTR_GID) &&
-	    (current_fsuid() != inode->i_uid ||
-	    (!in_group_p(attr->ia_gid) && attr->ia_gid != inode->i_gid)) &&
+	    (act_as->uid != inode->i_uid ||
+	     (!__in_group_p(act_as, attr->ia_gid) && attr->ia_gid != inode->i_gid)) &&
 	    !capable(CAP_CHOWN))
 		goto error;
 
 	/* Make sure a caller can chmod. */
 	if (ia_valid & ATTR_MODE) {
-		if (!is_owner_or_cap(inode))
+		if (!__is_owner_or_cap(act_as, inode))
 			goto error;
 		/* Also check the setgid bit! */
-		if (!in_group_p((ia_valid & ATTR_GID) ? attr->ia_gid :
+		if (!__in_group_p(act_as, (ia_valid & ATTR_GID) ? attr->ia_gid :
 				inode->i_gid) && !capable(CAP_FSETID))
 			attr->ia_mode &= ~S_ISGID;
 	}
 
 	/* Check for setting the inode time. */
 	if (ia_valid & (ATTR_MTIME_SET | ATTR_ATIME_SET)) {
-		if (!is_owner_or_cap(inode))
+		if (!__is_owner_or_cap(act_as, inode))
 			goto error;
 	}
 fine:
diff --git a/fs/namei.c b/fs/namei.c
index 495c759..81277fa 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -182,9 +182,10 @@ EXPORT_SYMBOL(putname);
 int generic_permission(struct inode *inode, int mask,
 		int (*check_acl)(struct inode *inode, int mask))
 {
+	struct task_security *act_as = current->act_as;
 	umode_t			mode = inode->i_mode;
 
-	if (current_fsuid() == inode->i_uid)
+	if (act_as->uid == inode->i_uid)
 		mode >>= 6;
 	else {
 		if (IS_POSIXACL(inode) && (mode & S_IRWXG) && check_acl) {
@@ -195,7 +196,7 @@ int generic_permission(struct inode *inode, int mask,
 				return error;
 		}
 
-		if (in_group_p(inode->i_gid))
+		if (__in_group_p(act_as, inode->i_gid))
 			mode >>= 3;
 	}
 
@@ -457,14 +458,16 @@ static struct dentry * cached_lookup(struct dentry * parent, struct qstr * name,
 static int exec_permission_lite(struct inode *inode,
 				       struct nameidata *nd)
 {
+	struct task_security *act_as;
 	umode_t	mode = inode->i_mode;
 
 	if (inode->i_op && inode->i_op->permission)
 		return -EAGAIN;
 
-	if (current_fsuid() == inode->i_uid)
+	act_as = current->act_as;
+	if (act_as->uid == inode->i_uid)
 		mode >>= 6;
-	else if (in_group_p(inode->i_gid))
+	else if (__in_group_p(act_as, inode->i_gid))
 		mode >>= 3;
 
 	if (mode & MAY_EXEC)
diff --git a/fs/posix_acl.c b/fs/posix_acl.c
index 39df95a..623370d 100644
--- a/fs/posix_acl.c
+++ b/fs/posix_acl.c
@@ -211,28 +211,29 @@ int
 posix_acl_permission(struct inode *inode, const struct posix_acl *acl, int want)
 {
 	const struct posix_acl_entry *pa, *pe, *mask_obj;
+	struct task_security *act_as = current->act_as;
 	int found = 0;
 
 	FOREACH_ACL_ENTRY(pa, acl, pe) {
                 switch(pa->e_tag) {
                         case ACL_USER_OBJ:
 				/* (May have been checked already) */
-				if (inode->i_uid == current_fsuid())
+				if (inode->i_uid == act_as->uid)
                                         goto check_perm;
                                 break;
                         case ACL_USER:
-				if (pa->e_id == current_fsuid())
+				if (pa->e_id == act_as->uid)
                                         goto mask;
 				break;
                         case ACL_GROUP_OBJ:
-                                if (in_group_p(inode->i_gid)) {
+                                if (__in_group_p(act_as, inode->i_gid)) {
 					found = 1;
 					if ((pa->e_perm & want) == want)
 						goto mask;
                                 }
 				break;
                         case ACL_GROUP:
-                                if (in_group_p(pa->e_id)) {
+                                if (__in_group_p(act_as, pa->e_id)) {
 					found = 1;
 					if ((pa->e_perm & want) == want)
 						goto mask;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index d218ef5..cdf3e28 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1064,8 +1064,10 @@ enum {
 #define put_fs_excl() atomic_dec(&current->fs_excl)
 #define has_fs_excl() atomic_read(&current->fs_excl)
 
+#define __is_owner_or_cap(act_as, inode) \
+	(((act_as)->uid == (inode)->i_uid) || capable(CAP_FOWNER))
 #define is_owner_or_cap(inode)	\
-	((current_fsuid() == (inode)->i_uid) || capable(CAP_FOWNER))
+	(__is_owner_or_cap(current->act_as, (inode)))
 
 /* not quite ready to be deprecated, but... */
 extern void lock_super(struct super_block *);
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 983b532..f0d645d 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1739,7 +1739,13 @@ extern void wake_up_new_task(struct task_struct *tsk,
 extern void sched_fork(struct task_struct *p, int clone_flags);
 extern void sched_dead(struct task_struct *p);
 
-extern int in_group_p(gid_t);
+extern int __in_group_p(struct task_security *, gid_t);
+
+static inline int in_group_p(gid_t grp)
+{
+	return __in_group_p(current->act_as, grp);
+}
+
 extern int in_egroup_p(gid_t);
 
 extern void proc_caches_init(void);
diff --git a/kernel/sys.c b/kernel/sys.c
index ec0c251..7bc39f9 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1337,9 +1337,8 @@ asmlinkage long sys_setgroups(int gidsetsize, gid_t __user *grouplist)
 /*
  * Check whether we're fsgid/egid or in the supplemental group..
  */
-int in_group_p(gid_t grp)
+int __in_group_p(struct task_security *act_as, gid_t grp)
 {
-	struct task_security *act_as = current->act_as;
 	int retval = 1;
 	if (grp != act_as->fsgid)
 		retval = groups_search(act_as->group_info, grp);

--=-=-=--
