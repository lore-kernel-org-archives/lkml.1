Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756767Ab0BDHcn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 02:32:43 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:43538 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975Ab0BDHcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 02:32:41 -0500
To: Greg KH <gregkh@suse.de>
Cc: Jean Delvare <khali@linux-fr.org>, LKML <linux-kernel@vger.kernel.org>,
       Tejun Heo <tj@kernel.org>, Serge Hallyn <serue@us.ibm.com>,
       stable@kernel.org
Subject: [PATCH] sysfs: sysfs_setattr set iattrs unconditionally
References: <20100120131602.12aa48f7@hyperion.delvare>
	<m1ocko6fkx.fsf@fess.ebiederm.org>
	<20100120160008.7d59688b@hyperion.delvare>
	<20100122041913.GC4302@suse.de>
	<20100203091138.1ababf5e@hyperion.delvare>
	<20100203142218.GA27676@suse.de>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 03 Feb 2010 23:32:36 -0800
In-Reply-To: <20100203142218.GA27676@suse.de> (Greg KH's message of "Wed\, 3 Feb 2010 06\:22\:18 -0800")
Message-ID: <m1d40llaln.fsf_-_@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


There is currently a bug in sysfs_setattr where the first time
we set the attributes on a sysfs file we allocate backing store
but do not set the backing store attributes.  Resulting in overly
restrictive permissions on sysfs files.

This bug is masked by the fact we that we do update the vfs inode
so it will only show up after the vfs inode has been evicted
causing surprise sysfs attribute changes.

The fix is to simply modify the code so that it always executes
when we update the sysfs attributes, as we did in 2.6.31 and earlier.

This is a backported version of my similiar change for 2.6.33-rc6
against sysfs_sd_setattr, for the stable 2.6.32 tree.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/sysfs/inode.c |   47 +++++++++++++++++++++++------------------------
 1 files changed, 23 insertions(+), 24 deletions(-)

diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
index e28cecf..02a022a 100644
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -94,30 +94,29 @@ int sysfs_setattr(struct dentry * dentry, struct iattr * iattr)
 		if (!sd_attrs)
 			return -ENOMEM;
 		sd->s_iattr = sd_attrs;
-	} else {
-		/* attributes were changed at least once in past */
-		iattrs = &sd_attrs->ia_iattr;
-
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
-
-			if (!in_group_p(inode->i_gid) && !capable(CAP_FSETID))
-				mode &= ~S_ISGID;
-			iattrs->ia_mode = sd->s_mode = mode;
-		}
+	}
+	/* attributes were changed at least once in past */
+	iattrs = &sd_attrs->ia_iattr;
+
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
+
+		if (!in_group_p(inode->i_gid) && !capable(CAP_FSETID))
+			mode &= ~S_ISGID;
+		iattrs->ia_mode = sd->s_mode = mode;
 	}
 	return error;
 }
-- 
1.6.5.2.143.g8cc62

