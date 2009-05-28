Return-Path: <linux-kernel-owner+w=401wt.eu-S1751253AbZE1XEh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751253AbZE1XEh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 19:04:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754080AbZE1XCh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 19:02:37 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:48841 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752819AbZE1XCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 19:02:22 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Cc: <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
       Cornelia Huck <cornelia.huck@de.ibm.com>,
       <linux-fsdevel@vger.kernel.org>, Kay Sievers <kay.sievers@vrfy.org>,
       Greg KH <greg@kroah.com>, "Eric W. Biederman" <ebiederm@xmission.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Date: Thu, 28 May 2009 16:00:49 -0700
Message-Id: <1243551665-23596-8-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.6.3.1.54.g99dd.dirty
In-Reply-To: <m1zlcwltri.fsf_-_@fess.ebiederm.org>
References: <m1zlcwltri.fsf_-_@fess.ebiederm.org>
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: akpm@linux-foundation.org, gregkh@suse.de, linux-kernel@vger.kernel.org, tj@kernel.org, cornelia.huck@de.ibm.com, linux-fsdevel@vger.kernel.org, kay.sievers@vrfy.org, greg@kroah.com, ebiederm@xmission.com, ebiederm@aristanetworks.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Andrew Morton <akpm@linux-foundation.org>, Greg Kroah-Hartman
	<gregkh@suse.de>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.7 BAYES_20 BODY: Bayesian spam probability is 5 to 20%
	*      [score: 0.1707]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: [PATCH 08/24] sysfs: Optimize just changing the sysfs file mode.
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
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
1.6.3.1.54.g99dd.dirty

