Return-Path: <linux-kernel-owner+w=401wt.eu-S1757098AbZEUAao@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757098AbZEUAao (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 20:30:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756634AbZEUA2f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 20:28:35 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:46327 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754216AbZEUA2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 20:28:17 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Cc: <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
       Cornelia Huck <cornelia.huck@de.ibm.com>,
       <linux-fsdevel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: [PATCH 08/20] sysfs: Optimize just changing the sysfs file mode.
Date: Wed, 20 May 2009 17:28:02 -0700
Message-Id: <1242865694-2100-8-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.6.1.2.350.g88cc
In-Reply-To: <1242865694-2100-7-git-send-email-ebiederm@xmission.com>
References: <m1bppofm9k.fsf@fess.ebiederm.org>
 <1242865694-2100-1-git-send-email-ebiederm@xmission.com>
 <1242865694-2100-2-git-send-email-ebiederm@xmission.com>
 <1242865694-2100-3-git-send-email-ebiederm@xmission.com>
 <1242865694-2100-4-git-send-email-ebiederm@xmission.com>
 <1242865694-2100-5-git-send-email-ebiederm@xmission.com>
 <1242865694-2100-6-git-send-email-ebiederm@xmission.com>
 <1242865694-2100-7-git-send-email-ebiederm@xmission.com>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: akpm@linux-foundation.org, gregkh@suse.de, linux-kernel@vger.kernel.org, tj@kernel.org, cornelia.huck@de.ibm.com, linux-fsdevel@vger.kernel.org, ebiederm@xmission.com, ebiederm@aristanetworks.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

Don't allocate a struct iattr for the sysfs dentry if just
the mode changes because we have a field for that on the
sysfs_dirent, and we can trigger that case with sysfs_chmod_file.

Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
---
 fs/sysfs/inode.c |   22 ++++++++++++++--------
 1 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
index 555f0ff..70ff2a2 100644
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -60,12 +60,16 @@ int sysfs_setattr(struct dentry * dentry, struct iattr * iattr)
 		return error;
 
 	iattr->ia_valid &= ~ATTR_SIZE; /* ignore size changes */
+	if (iattr->ia_valid & ATTR_MODE) {
+		if (!in_group_p(inode->i_gid) && !capable(CAP_FSETID))
+			iattr->ia_mode &= ~S_ISGID;
+	}
 
 	error = inode_setattr(inode, iattr);
 	if (error)
 		return error;
 
-	if (!sd_iattr) {
+	if (!sd_iattr && (ia_valid & ~ATTR_MODE)) {
 		/* setting attributes for the first time, allocate now */
 		sd_iattr = kzalloc(sizeof(struct iattr), GFP_KERNEL);
 		if (!sd_iattr)
@@ -78,6 +82,13 @@ int sysfs_setattr(struct dentry * dentry, struct iattr * iattr)
 		sd->s_iattr = sd_iattr;
 	}
 
+	if (ia_valid & ATTR_MODE)
+		sd->s_mode = iattr->ia_mode;
+
+	/* If we don't need the extra attributes leave */
+	if (!sd_iattr)
+		return 0;
+
 	/* attributes were changed atleast once in past */
 
 	if (ia_valid & ATTR_UID)
@@ -93,13 +104,8 @@ int sysfs_setattr(struct dentry * dentry, struct iattr * iattr)
 	if (ia_valid & ATTR_CTIME)
 		sd_iattr->ia_ctime = timespec_trunc(iattr->ia_ctime,
 						inode->i_sb->s_time_gran);
-	if (ia_valid & ATTR_MODE) {
-		umode_t mode = iattr->ia_mode;
-
-		if (!in_group_p(inode->i_gid) && !capable(CAP_FSETID))
-			mode &= ~S_ISGID;
-		sd_iattr->ia_mode = sd->s_mode = mode;
-	}
+	if (ia_valid & ATTR_MODE)
+		sd_iattr->ia_mode = iattr->ia_mode;
 
 	return error;
 }
-- 
1.6.1.2.350.g88cc

