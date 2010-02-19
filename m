Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755428Ab0BSRGB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 12:06:01 -0500
Received: from kroah.org ([198.145.64.141]:57774 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755019Ab0BSRBI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 12:01:08 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Feb 19 08:32:52 2010
Message-Id: <20100219163252.087068581@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 19 Feb 2010 08:30:10 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [77/93] sysfs: sysfs_sd_setattr set iattrs unconditionally
In-Reply-To: <20100219165717.GA15002@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Eric W. Biederman <ebiederm@xmission.com>

commit 7c0ff870d1ed287504a61ed865f3d728c757436b upstream.

There is currently a bug in sysfs_sd_setattr inherited from
sysfs_setattr in 2.6.32 where the first time we set the attributes
on a sysfs file we allocate backing store but do not set the
backing store attributes.  Resulting in overly restrictive
permissions on sysfs files.

The fix is to simply modify the code so that it always executes
when we update the sysfs attributes, as we did in 2.6.31 and earlier.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Tested-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/sysfs/inode.c |   43 +++++++++++++++++++++----------------------
 1 file changed, 21 insertions(+), 22 deletions(-)

--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -94,30 +94,29 @@ int sysfs_setattr(struct dentry * dentry
 		if (!sd_attrs)
 			return -ENOMEM;
 		sd->s_iattr = sd_attrs;
-	} else {
-		/* attributes were changed at least once in past */
-		iattrs = &sd_attrs->ia_iattr;
+	}
+	/* attributes were changed at least once in past */
+	iattrs = &sd_attrs->ia_iattr;
 
-		if (ia_valid & ATTR_UID)
-			iattrs->ia_uid = iattr->ia_uid;
-		if (ia_valid & ATTR_GID)
-			iattrs->ia_gid = iattr->ia_gid;
-		if (ia_valid & ATTR_ATIME)
-			iattrs->ia_atime = timespec_trunc(iattr->ia_atime,
-					inode->i_sb->s_time_gran);
-		if (ia_valid & ATTR_MTIME)
-			iattrs->ia_mtime = timespec_trunc(iattr->ia_mtime,
-					inode->i_sb->s_time_gran);
-		if (ia_valid & ATTR_CTIME)
-			iattrs->ia_ctime = timespec_trunc(iattr->ia_ctime,
-					inode->i_sb->s_time_gran);
-		if (ia_valid & ATTR_MODE) {
-			umode_t mode = iattr->ia_mode;
+	if (ia_valid & ATTR_UID)
+		iattrs->ia_uid = iattr->ia_uid;
+	if (ia_valid & ATTR_GID)
+		iattrs->ia_gid = iattr->ia_gid;
+	if (ia_valid & ATTR_ATIME)
+		iattrs->ia_atime = timespec_trunc(iattr->ia_atime,
+			inode->i_sb->s_time_gran);
+	if (ia_valid & ATTR_MTIME)
+		iattrs->ia_mtime = timespec_trunc(iattr->ia_mtime,
+			inode->i_sb->s_time_gran);
+	if (ia_valid & ATTR_CTIME)
+		iattrs->ia_ctime = timespec_trunc(iattr->ia_ctime,
+			inode->i_sb->s_time_gran);
+	if (ia_valid & ATTR_MODE) {
+		umode_t mode = iattr->ia_mode;
 
-			if (!in_group_p(inode->i_gid) && !capable(CAP_FSETID))
-				mode &= ~S_ISGID;
-			iattrs->ia_mode = sd->s_mode = mode;
-		}
+		if (!in_group_p(inode->i_gid) && !capable(CAP_FSETID))
+			mode &= ~S_ISGID;
+		iattrs->ia_mode = sd->s_mode = mode;
 	}
 	return error;
 }


