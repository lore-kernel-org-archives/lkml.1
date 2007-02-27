Return-Path: <linux-kernel-owner+w=401wt.eu-S1161464AbXB0AHq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161464AbXB0AHq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 19:07:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161451AbXB0AHq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 19:07:46 -0500
Received: from mail.kroah.org ([69.55.234.183]:44877 "EHLO perch.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161464AbXB0AHl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 19:07:41 -0500
Date: Mon, 26 Feb 2007 16:06:14 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, Greg KH <greg@kroah.com>
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Chris Wright <chrisw@sous-sol.org>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       Andreas Gruenbacher <agruen@suse.de>, Hugh Dickins <hugh@veritas.com>
Subject: [patch 1/9] fix umask when noACL kernel meets extN tuned for ACLs
Message-ID: <20070227000614.GB6283@kroah.com>
References: <20070226235248.438556696@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fix-umask-when-noacl-kernel-meets-extn-tuned-for-acls.patch"
In-Reply-To: <20070227000538.GA6283@kroah.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Hugh Dickins <hugh@veritas.com>

Fix insecure default behaviour reported by Tigran Aivazian: if an ext2
or ext3 or ext4 filesystem is tuned to mount with "acl", but mounted by
a kernel built without ACL support, then umask was ignored when creating
inodes - though root or user has umask 022, touch creates files as 0666,
and mkdir creates directories as 0777.

This appears to have worked right until 2.6.11, when a fix to the default
mode on symlinks (always 0777) assumed VFS applies umask: which it does,
unless the mount is marked for ACLs; but ext[234] set MS_POSIXACL in
s_flags according to s_mount_opt set according to def_mount_opts.

We could revert to the 2.6.10 ext[234]_init_acl (adding an S_ISLNK test);
but other filesystems only set MS_POSIXACL when ACLs are configured.  We
could fix this at another level; but it seems most robust to avoid setting
the s_mount_opt flag in the first place (at the expense of more ifdefs).

Likewise don't set the XATTR_USER flag when built without XATTR support.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Acked-by: Andreas Gruenbacher <agruen@suse.de>
Cc: Tigran Aivazian <tigran@aivazian.fsnet.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ext2/super.c |    4 ++++
 fs/ext3/super.c |    4 ++++
 fs/ext4/super.c |    4 ++++
 3 files changed, 12 insertions(+)

--- linux-2.6.19.5.orig/fs/ext2/super.c
+++ linux-2.6.19.5/fs/ext2/super.c
@@ -710,10 +710,14 @@ static int ext2_fill_super(struct super_
 		set_opt(sbi->s_mount_opt, GRPID);
 	if (def_mount_opts & EXT2_DEFM_UID16)
 		set_opt(sbi->s_mount_opt, NO_UID32);
+#ifdef CONFIG_EXT2_FS_XATTR
 	if (def_mount_opts & EXT2_DEFM_XATTR_USER)
 		set_opt(sbi->s_mount_opt, XATTR_USER);
+#endif
+#ifdef CONFIG_EXT2_FS_POSIX_ACL
 	if (def_mount_opts & EXT2_DEFM_ACL)
 		set_opt(sbi->s_mount_opt, POSIX_ACL);
+#endif
 	
 	if (le16_to_cpu(sbi->s_es->s_errors) == EXT2_ERRORS_PANIC)
 		set_opt(sbi->s_mount_opt, ERRORS_PANIC);
--- linux-2.6.19.5.orig/fs/ext3/super.c
+++ linux-2.6.19.5/fs/ext3/super.c
@@ -1455,10 +1455,14 @@ static int ext3_fill_super (struct super
 		set_opt(sbi->s_mount_opt, GRPID);
 	if (def_mount_opts & EXT3_DEFM_UID16)
 		set_opt(sbi->s_mount_opt, NO_UID32);
+#ifdef CONFIG_EXT3_FS_XATTR
 	if (def_mount_opts & EXT3_DEFM_XATTR_USER)
 		set_opt(sbi->s_mount_opt, XATTR_USER);
+#endif
+#ifdef CONFIG_EXT3_FS_POSIX_ACL
 	if (def_mount_opts & EXT3_DEFM_ACL)
 		set_opt(sbi->s_mount_opt, POSIX_ACL);
+#endif
 	if ((def_mount_opts & EXT3_DEFM_JMODE) == EXT3_DEFM_JMODE_DATA)
 		sbi->s_mount_opt |= EXT3_MOUNT_JOURNAL_DATA;
 	else if ((def_mount_opts & EXT3_DEFM_JMODE) == EXT3_DEFM_JMODE_ORDERED)
--- linux-2.6.19.5.orig/fs/ext4/super.c
+++ linux-2.6.19.5/fs/ext4/super.c
@@ -1512,10 +1512,14 @@ static int ext4_fill_super (struct super
 		set_opt(sbi->s_mount_opt, GRPID);
 	if (def_mount_opts & EXT4_DEFM_UID16)
 		set_opt(sbi->s_mount_opt, NO_UID32);
+#ifdef CONFIG_EXT4DEV_FS_XATTR
 	if (def_mount_opts & EXT4_DEFM_XATTR_USER)
 		set_opt(sbi->s_mount_opt, XATTR_USER);
+#endif
+#ifdef CONFIG_EXT4DEV_FS_POSIX_ACL
 	if (def_mount_opts & EXT4_DEFM_ACL)
 		set_opt(sbi->s_mount_opt, POSIX_ACL);
+#endif
 	if ((def_mount_opts & EXT4_DEFM_JMODE) == EXT4_DEFM_JMODE_DATA)
 		sbi->s_mount_opt |= EXT4_MOUNT_JOURNAL_DATA;
 	else if ((def_mount_opts & EXT4_DEFM_JMODE) == EXT4_DEFM_JMODE_ORDERED)

--
