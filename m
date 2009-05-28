Return-Path: <linux-kernel-owner+w=401wt.eu-S1756113AbZE1XG4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756113AbZE1XG4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 19:06:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754240AbZE1XDE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 19:03:04 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:48872 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753629AbZE1XCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 19:02:24 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Cc: <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
       Cornelia Huck <cornelia.huck@de.ibm.com>,
       <linux-fsdevel@vger.kernel.org>, Kay Sievers <kay.sievers@vrfy.org>,
       Greg KH <greg@kroah.com>, "Eric W. Biederman" <ebiederm@xmission.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Date: Thu, 28 May 2009 16:00:59 -0700
Message-Id: <1243551665-23596-18-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.6.3.1.54.g99dd.dirty
In-Reply-To: <m1zlcwltri.fsf_-_@fess.ebiederm.org>
References: <m1zlcwltri.fsf_-_@fess.ebiederm.org>
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: akpm@linux-foundation.org, gregkh@suse.de, linux-kernel@vger.kernel.org, tj@kernel.org, cornelia.huck@de.ibm.com, linux-fsdevel@vger.kernel.org, kay.sievers@vrfy.org, greg@kroah.com, ebiederm@xmission.com, ebiederm@aristanetworks.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Andrew Morton <akpm@linux-foundation.org>, Greg Kroah-Hartman
	<gregkh@suse.de>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0004]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: [PATCH 18/24] sysfs: Pass super_block to sysfs_get_inode
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

Currently sysfs_get_inode magically returns an inode on
sysfs_sb.  Make the super_block parameter explicit and
the code becomes clearer.

Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
---
 fs/sysfs/dir.c   |    2 +-
 fs/sysfs/inode.c |    5 +++--
 fs/sysfs/mount.c |    2 +-
 fs/sysfs/sysfs.h |    2 +-
 4 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 1f8fb9c..39c6944 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -579,7 +579,7 @@ static struct dentry * sysfs_lookup(struct inode *dir, struct dentry *dentry,
 	}
 
 	/* attach dentry and inode */
-	inode = sysfs_get_inode(sd);
+	inode = sysfs_get_inode(dir->i_sb, sd);
 	if (!inode) {
 		ret = ERR_PTR(-ENOMEM);
 		goto out_unlock;
diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
index a1917b5..c725aeb 100644
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -210,6 +210,7 @@ static void sysfs_init_inode(struct sysfs_dirent *sd, struct inode *inode)
 
 /**
  *	sysfs_get_inode - get inode for sysfs_dirent
+ *	@sb: super block
  *	@sd: sysfs_dirent to allocate inode for
  *
  *	Get inode for @sd.  If such inode doesn't exist, a new inode
@@ -222,11 +223,11 @@ static void sysfs_init_inode(struct sysfs_dirent *sd, struct inode *inode)
  *	RETURNS:
  *	Pointer to allocated inode on success, NULL on failure.
  */
-struct inode * sysfs_get_inode(struct sysfs_dirent *sd)
+struct inode * sysfs_get_inode(struct super_block *sb, struct sysfs_dirent *sd)
 {
 	struct inode *inode;
 
-	inode = iget_locked(sysfs_sb, sd->s_ino);
+	inode = iget_locked(sb, sd->s_ino);
 	if (inode && (inode->i_state & I_NEW))
 		sysfs_init_inode(sd, inode);
 
diff --git a/fs/sysfs/mount.c b/fs/sysfs/mount.c
index 4974995..89db07e 100644
--- a/fs/sysfs/mount.c
+++ b/fs/sysfs/mount.c
@@ -54,7 +54,7 @@ static int sysfs_fill_super(struct super_block *sb, void *data, int silent)
 
 	/* get root inode, initialize and unlock it */
 	mutex_lock(&sysfs_mutex);
-	inode = sysfs_get_inode(&sysfs_root);
+	inode = sysfs_get_inode(sb, &sysfs_root);
 	mutex_unlock(&sysfs_mutex);
 	if (!inode) {
 		pr_debug("sysfs: could not get root inode\n");
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index 2db952c..cf21b06 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -130,7 +130,7 @@ static inline void __sysfs_put(struct sysfs_dirent *sd)
 /*
  * inode.c
  */
-struct inode *sysfs_get_inode(struct sysfs_dirent *sd);
+struct inode *sysfs_get_inode(struct super_block *sb, struct sysfs_dirent *sd);
 void sysfs_delete_inode(struct inode *inode);
 int sysfs_sd_setattr(struct sysfs_dirent *sd, struct iattr *iattr);
 int sysfs_setattr(struct dentry *dentry, struct iattr *iattr);
-- 
1.6.3.1.54.g99dd.dirty

