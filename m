Return-Path: <linux-kernel-owner+w=401wt.eu-S1753416AbXHTRuR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416AbXHTRuR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 13:50:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750827AbXHTRt6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 13:49:58 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:56608 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512AbXHTRtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 13:49:55 -0400
Date: Mon, 20 Aug 2007 19:49:53 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] Refine FAT chmod checks
In-Reply-To: <87absm6tr1.fsf@duaron.myhome.or.jp>
Message-ID: <Pine.LNX.4.64.0708201935470.5333@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0708201500490.30570@fbirervta.pbzchgretzou.qr>
 <87ps1i6xrh.fsf@duaron.myhome.or.jp> <Pine.LNX.4.64.0708201803080.5333@fbirervta.pbzchgretzou.qr>
 <87absm6tr1.fsf@duaron.myhome.or.jp>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 21 2007 01:44, OGAWA Hirofumi wrote:
>> +
>> +	if (error == 0 && (attr->ia_valid & ATTR_MODE))
>> +		if ((error = check_mode(sbi, attr->ia_mode)) != 0 &&
>> +		    sbi->options.quiet)
>> +			error = 0;
>
>This test is really here? The error is always "0", and it seems
>anybody doesn't check after that.

Thank you for the corrections. Fix below.

===
[fs/fat/]: Refine chmod checks

Prohibit mode changes in non-quiet mode that cannot be stored reliably
with the on-disk format.

Suppose a vfat filesystem is mounted with umask=0 and [not-quiet].
Then all files will have mode 0777. Trying to change the owner will
fail, because fat does not know about owners or groups. chmod 0770,
on the other hand, will succeed, even though fat does not know about
the permission triplet [user/group/other].

So this patch changes fat's not-quiet behavior so that only UNIX
modes are accepted that can be mapped lossless between the fat disk
format and the local system. There is only one attribute, and that is
the readonly attribute, which is mapped to the UNIX write permission
bit(s). chmod 0555 is therefore valid (taking away the +w bits <=>
setting the readonly attribute). Since chmod 0775 and chmod 0755 is
an ambiguous case as to whether to set or clear the readonly bit,
these modes are also denied.

In quiet mode, chmod and chown will continue to "succeed" as they did
before, meaning that a subsequent stat() will temporarily return the
new mode as long as the inode is not reread from disk, and chown will
silently do nothing, not even return the new uid/gid in stat().

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

---
 fs/fat/file.c |   47 ++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 44 insertions(+), 3 deletions(-)

Index: linux-2.6.22/fs/fat/file.c
===================================================================
--- linux-2.6.22.orig/fs/fat/file.c
+++ linux-2.6.22/fs/fat/file.c
@@ -155,6 +155,42 @@ out:
 	return err;
 }
 
+static int check_mode(const struct msdos_sb_info *sbi, mode_t mode)
+{
+	mode_t req = mode & ~S_IFMT;
+
+	/*
+	 * Of the r and x bits, all (subject to umask) must be present. Of the
+	 * w bits, either all (subject to umask) or none must be present.
+	 */
+
+	if (S_ISREG(mode)) {
+		req &= ~sbi->options.fs_fmask;
+
+		if ((req & (S_IRUGO | S_IXUGO)) !=
+		    ((S_IRUGO | S_IXUGO) & ~sbi->options.fs_fmask))
+			return -EPERM;
+
+		if ((req & S_IWUGO) != 0 &&
+		    (req & S_IWUGO) != (S_IWUGO & ~sbi->options.fs_fmask))
+			return -EPERM;
+	} else if (S_ISDIR(mode)) {
+		req &= ~sbi->options.fs_dmask;
+
+		if ((req & (S_IRUGO | S_IXUGO)) !=
+		    ((S_IRUGO | S_IXUGO) & ~sbi->options.fs_dmask))
+			return -EPERM;
+
+		if ((req & S_IWUGO) != 0 &&
+		    (req & S_IWUGO) != (S_IWUGO & ~sbi->options.fs_dmask))
+			return -EPERM;
+	} else {
+		return -EPERM;
+	}
+
+	return 0;
+}
+
 int fat_notify_change(struct dentry *dentry, struct iattr *attr)
 {
 	struct msdos_sb_info *sbi = MSDOS_SB(dentry->d_sb);
@@ -186,9 +222,7 @@ int fat_notify_change(struct dentry *den
 	if (((attr->ia_valid & ATTR_UID) &&
 	     (attr->ia_uid != sbi->options.fs_uid)) ||
 	    ((attr->ia_valid & ATTR_GID) &&
-	     (attr->ia_gid != sbi->options.fs_gid)) ||
-	    ((attr->ia_valid & ATTR_MODE) &&
-	     (attr->ia_mode & ~MSDOS_VALID_MODE)))
+	     (attr->ia_gid != sbi->options.fs_gid)))
 		error = -EPERM;
 
 	if (error) {
@@ -196,6 +230,13 @@ int fat_notify_change(struct dentry *den
 			error = 0;
 		goto out;
 	}
+
+	if (attr->ia_valid & ATTR_MODE) {
+		error = check_mode(sbi, attr->ia_mode);
+		if (error != 0 && !sbi->options.quiet)
+			goto out;
+	}
+
 	error = inode_setattr(inode, attr);
 	if (error)
 		goto out;
