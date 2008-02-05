Return-Path: <linux-kernel-owner+w=401wt.eu-S1762156AbYBEVjH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762156AbYBEVjH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 16:39:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761646AbYBEVhr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 16:37:47 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:38768 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761576AbYBEVho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 16:37:44 -0500
Message-Id: <20080205213706.641671363@szeredi.hu>
References: <20080205213616.343721693@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Tue, 05 Feb 2008 22:36:24 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org, hch@infradead.org, serue@us.ibm.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 08/10] unprivileged mounts: make fuse safe
Content-Disposition: inline; filename=unprivileged-mounts-allow-unprivileged-fuse-mounts.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Don't require the "user_id=" and "group_id=" options for unprivileged mounts,
but if they are present, verify them for sanity.

Disallow the "allow_other" option for unprivileged mounts.

Document new way of enabling unprivileged mounts for fuse.

Document problems with unprivileged mounts.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Acked-by: Serge Hallyn <serue@us.ibm.com>
---

Index: linux/fs/fuse/inode.c
===================================================================
--- linux.orig/fs/fuse/inode.c	2008-02-04 23:47:46.000000000 +0100
+++ linux/fs/fuse/inode.c	2008-02-04 23:48:06.000000000 +0100
@@ -359,6 +359,19 @@ static int parse_fuse_opt(char *opt, str
 	d->max_read = ~0;
 	d->blksize = FUSE_DEFAULT_BLKSIZE;
 
+	/*
+	 * For unprivileged mounts use current uid/gid.  Still allow
+	 * "user_id" and "group_id" options for compatibility, but
+	 * only if they match these values.
+	 */
+	if (!capable(CAP_SYS_ADMIN)) {
+		d->user_id = current->uid;
+		d->user_id_present = 1;
+		d->group_id = current->gid;
+		d->group_id_present = 1;
+
+	}
+
 	while ((p = strsep(&opt, ",")) != NULL) {
 		int token;
 		int value;
@@ -387,6 +400,8 @@ static int parse_fuse_opt(char *opt, str
 		case OPT_USER_ID:
 			if (match_int(&args[0], &value))
 				return 0;
+			if (d->user_id_present && d->user_id != value)
+				return 0;
 			d->user_id = value;
 			d->user_id_present = 1;
 			break;
@@ -394,6 +409,8 @@ static int parse_fuse_opt(char *opt, str
 		case OPT_GROUP_ID:
 			if (match_int(&args[0], &value))
 				return 0;
+			if (d->group_id_present && d->group_id != value)
+				return 0;
 			d->group_id = value;
 			d->group_id_present = 1;
 			break;
@@ -603,6 +620,10 @@ static int fuse_fill_super(struct super_
 	if (!parse_fuse_opt((char *) data, &d, is_bdev))
 		return -EINVAL;
 
+	/* This is a privileged option */
+	if ((d.flags & FUSE_ALLOW_OTHER) && !capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
 	if (is_bdev) {
 #ifdef CONFIG_BLOCK
 		if (!sb_set_blocksize(sb, d.blksize))
Index: linux/Documentation/filesystems/fuse.txt
===================================================================
--- linux.orig/Documentation/filesystems/fuse.txt	2008-01-24 23:58:37.000000000 +0100
+++ linux/Documentation/filesystems/fuse.txt	2008-02-05 19:34:24.000000000 +0100
@@ -215,11 +215,87 @@ the filesystem.  There are several ways 
   - Abort filesystem through the FUSE control filesystem.  Most
     powerful method, always works.
 
-How do non-privileged mounts work?
-~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+Unprivileged fuse mounts
+~~~~~~~~~~~~~~~~~~~~~~~~
 
-Since the mount() system call is a privileged operation, a helper
-program (fusermount) is needed, which is installed setuid root.
+Possible problems with unprivileged fuse mounts
+-----------------------------------------------
+
+FUSE was designed from the beginning to be safe for unprivileged
+users.  This has also been verified in practice over many years, with
+some distributions enabling unprivileged FUSE mounts by default.
+
+However, there are cases when unprivileged mounting a fuse filesystem
+may be problematic, particularly for multi-user systems with untrusted
+users.  So here are few words of warning:
+
+Due to the design of the process freezer, a hanging (due to network
+problems, etc) or malicious filesystem may prevent suspending to ram
+or hibernation to succeed.  This is not actually unique to FUSE, as
+any hanging network filesystem will have the same affect.
+
+It is not always possible to use kill(2) (not even with SIGKILL) to
+terminate a process using a FUSE filesystem (see section "Interrupting
+filesystem operations" above).  As a special case of the above,
+killing a self-deadlocked FUSE process is not possible, and even
+killall5 will not terminate it.
+
+If the above could pose a threat to the system, it is recommended,
+that unprivileged fuse mounts are not enabled.
+
+Ways of enabling user mounts
+----------------------------
+
+Now there are two different ways of allowing unprivileged fuse mounts:
+
+ 1) new way: unprivileged mount syscall
+
+ 2) old way: suid-root fusermount utility
+
+Unprivileged mount syscall
+--------------------------
+
+To enable this do
+
+  echo 1 > /proc/sys/fs/types/fuse/usermount_safe
+
+or add this line to /etc/sysctl.conf:
+
+  fs.types.fuse.usermount_safe = 1
+
+More information can be found in Documentation/filesystems/proc.txt
+under the /proc/sys/fs/types/ heading.  Also see description of
+nr_user_mounts and max_user_mounts under /proc/sys/fs.
+
+This doesn't in itself allow users to create mounts, first root needs
+to create a mount owned by the user, under which the user can create
+submounts.
+
+For example to enable submounts under /home/xyz/mnt do:
+
+  mount --bind -ouser=xyz /home/xyz/mnt /home/xyz/mnt
+
+or add this line to /etc/fstab:
+
+  /home/xyz/mnt  /home/xyz/mnt  none  bind,user=xyz  0 0
+
+And finally, make sure, that the user has read and write permissions
+on /dev/fuse (installing fuse should have already taken care of this):
+
+  chmod 0666 /dev/fuse
+
+or create a file under /etc/udev/rules.d/ containing:
+
+  KERNEL=="fuse", MODE="0666"
+
+After this, mounting fuse filesystems under ~xyz/mnt should work, even
+if fusermount is not installed setuid-root.
+
+Suid-root fusermount utility
+----------------------------
+
+[Some of the details described here apply to the new, unprivileged
+mount system call as well].
 
 The implication of providing non-privileged mounts is that the mount
 owner must not be able to use this capability to compromise the
@@ -235,7 +311,7 @@ system.  Obvious requirements arising fr
     other users' or the super user's processes
 
 How are requirements fulfilled?
-~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+- - - - - - - - - - - - - - - -
 
  A) The mount owner could gain elevated privileges by either:
 
@@ -300,7 +376,7 @@ How are requirements fulfilled?
 	filesystem, since SIGSTOP can be used to get a similar effect.
 
 I think these limitations are unacceptable?
-~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+- - - - - - - - - - - - - - - - - - - - - -
 
 If a sysadmin trusts the users enough, or can ensure through other
 measures, that system processes will never enter non-privileged

--
