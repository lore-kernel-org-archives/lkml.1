Return-Path: <linux-kernel-owner+w=401wt.eu-S1754583AbYE3TGs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754583AbYE3TGs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 15:06:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752926AbYE3TGk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 15:06:40 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:55411 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752921AbYE3TGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 15:06:40 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Dave Jones <davej@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Rsync cannot copy to a vfat partition on kernel 2.6.25
References: <bug-449080-176318@bugzilla.redhat.com>
	<200805301659.m4UGx3AW001503@bz-web2.app.phx.redhat.com>
	<20080530171432.GA32480@redhat.com>
Date: Sat, 31 May 2008 04:06:35 +0900
In-Reply-To: <20080530171432.GA32480@redhat.com> (Dave Jones's message of
	"Fri, 30 May 2008 13:14:32 -0400")
Message-ID: <87prr36284.fsf@duaron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones <davej@redhat.com> writes:

> We had a user report at https://bugzilla.redhat.com/show_bug.cgi?id=449080
> that in 2.6.25, he can no longer rsync to a vfat partition, even as root.
> I just reproduced this here. It gets -EPERM in the mkstemp call.
> (full strace in the bug report).
>
> Did we change behaviour somehow in the vfat code?
> 2.6.24.7 works fine apparently.

Yes, it was changed. New one allows only acceptable chmod(), and if not
acceptable, it returns -EPERM. Old one allows even if it can't store the
disk inode. But it may be too strict for users.

Umm.. anyway, the following patch (still untested) will relax the check...
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>




Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

 fs/fat/file.c |   25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff -puN fs/fat/file.c~fat_setattr-fix fs/fat/file.c
--- linux-2.6/fs/fat/file.c~fat_setattr-fix	2008-05-31 03:49:09.000000000 +0900
+++ linux-2.6-hirofumi/fs/fat/file.c	2008-05-31 04:03:45.000000000 +0900
@@ -262,7 +262,7 @@ static int fat_check_mode(const struct m
 {
 	mode_t mask, req = mode & ~S_IFMT;
 
-	if (S_ISREG(mode))
+	if (S_ISREG(inode->i_mode))
 		mask = sbi->options.fs_fmask;
 	else
 		mask = sbi->options.fs_dmask;
@@ -299,7 +299,7 @@ int fat_setattr(struct dentry *dentry, s
 {
 	struct msdos_sb_info *sbi = MSDOS_SB(dentry->d_sb);
 	struct inode *inode = dentry->d_inode;
-	int mask, error = 0;
+	int error = 0;
 	unsigned int ia_valid;
 
 	lock_kernel();
@@ -332,12 +332,13 @@ int fat_setattr(struct dentry *dentry, s
 			error = 0;
 		goto out;
 	}
+
 	if (((attr->ia_valid & ATTR_UID) &&
 	     (attr->ia_uid != sbi->options.fs_uid)) ||
 	    ((attr->ia_valid & ATTR_GID) &&
 	     (attr->ia_gid != sbi->options.fs_gid)) ||
 	    ((attr->ia_valid & ATTR_MODE) &&
-	     fat_check_mode(sbi, inode, attr->ia_mode) < 0))
+	     (attr->ia_mode & ~MSDOS_VALID_MODE)))
 		error = -EPERM;
 
 	if (error) {
@@ -346,15 +347,17 @@ int fat_setattr(struct dentry *dentry, s
 		goto out;
 	}
 
-	error = inode_setattr(inode, attr);
-	if (error)
-		goto out;
+	/*
+	 * If we can't store to storage, don't set this permission.
+	 * We don't return -EPERM here. Yes, strange, but this is too
+	 * old behavior.
+	 */
+	if (attr->ia_valid & ATTR_MODE) {
+		if (fat_check_mode(sbi, inode, attr->ia_mode) < 0)
+			attr->ia_mode &= ~ATTR_MODE;
+	}
 
-	if (S_ISDIR(inode->i_mode))
-		mask = sbi->options.fs_dmask;
-	else
-		mask = sbi->options.fs_fmask;
-	inode->i_mode &= S_IFMT | (S_IRWXUGO & ~mask);
+	error = inode_setattr(inode, attr);
 out:
 	unlock_kernel();
 	return error;
_
