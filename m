Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933766Ab0BQALf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 19:11:35 -0500
Received: from kroah.org ([198.145.64.141]:41521 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933739Ab0BQALb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 19:11:31 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, stable <stable@kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 1/2] sysfs: sysfs_sd_setattr set iattrs unconditionally
Date: Tue, 16 Feb 2010 16:11:28 -0800
Message-Id: <1266365489-32082-1-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <20100217000206.GB31137@kroah.com>
References: <20100217000206.GB31137@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

There is currently a bug in sysfs_sd_setattr inherited from
sysfs_setattr in 2.6.32 where the first time we set the attributes
on a sysfs file we allocate backing store but do not set the
backing store attributes.  Resulting in overly restrictive
permissions on sysfs files.

The fix is to simply modify the code so that it always executes
when we update the sysfs attributes, as we did in 2.6.31 and earlier.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Tested-by: Jean Delvare <khali@linux-fr.org>
Cc: stable <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/inode.c |   35 +++++++++++++++++------------------
 1 files changed, 17 insertions(+), 18 deletions(-)

diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
index 220b758..6a06a1d 100644
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -81,24 +81,23 @@ int sysfs_sd_setattr(struct sysfs_dirent *sd, struct iattr * iattr)
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
-			iattrs->ia_atime = iattr->ia_atime;
-		if (ia_valid & ATTR_MTIME)
-			iattrs->ia_mtime = iattr->ia_mtime;
-		if (ia_valid & ATTR_CTIME)
-			iattrs->ia_ctime = iattr->ia_ctime;
-		if (ia_valid & ATTR_MODE) {
-			umode_t mode = iattr->ia_mode;
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
+		iattrs->ia_atime = iattr->ia_atime;
+	if (ia_valid & ATTR_MTIME)
+		iattrs->ia_mtime = iattr->ia_mtime;
+	if (ia_valid & ATTR_CTIME)
+		iattrs->ia_ctime = iattr->ia_ctime;
+	if (ia_valid & ATTR_MODE) {
+		umode_t mode = iattr->ia_mode;
+		iattrs->ia_mode = sd->s_mode = mode;
 	}
 	return 0;
 }
-- 
1.7.0

