Return-Path: <linux-kernel-owner+w=401wt.eu-S1756558AbZAVQtl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756558AbZAVQtl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 11:49:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752602AbZAVQtc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 11:49:32 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:50694 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862AbZAVQtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 11:49:31 -0500
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: <linux-kernel@vger.kernel.org>, Al Viro <viro@ZenIV.linux.org.uk>,
       Tejun Heo <tj@kernel.org>, Cornelia Huck <cornelia.huck@de.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 22 Jan 2009 08:49:21 -0800
In-Reply-To: <m13afch1sw.fsf@fess.ebiederm.org> (Eric W. Biederman's message of "Wed\, 21 Jan 2009 11\:55\:11 -0800")
Message-ID: <m1k58nffqm.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
References: <m13afch1sw.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=24.130.11.59;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Rcpt-To: too long (recipient list exceeded maximum allowed size of 128 bytes)
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 
X-Spam-Combo: ;Greg Kroah-Hartman <gregkh@suse.de>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: [PATCH] sysfs: Reference sysfs_dirent from sysfs inodes.
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: Yes (on mx04.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The sysfs_dirent serves as both an inode and a directory entry
for sysfs.  To prevent the sysfs inode numbers from being freed
prematurely hold a reference to sysfs_dirent from the sysfs inode.

Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
---
 fs/sysfs/inode.c |   10 ++++++++++
 fs/sysfs/mount.c |    1 +
 fs/sysfs/sysfs.h |    1 +
 3 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
index dfa3d94..dd269df 100644
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -147,6 +147,7 @@ static void sysfs_init_inode(struct sysfs_dirent *sd, struct inode *inode)
 {
 	struct bin_attribute *bin_attr;
 
+	inode->i_private = sysfs_get(sd);
 	inode->i_mapping->a_ops = &sysfs_aops;
 	inode->i_mapping->backing_dev_info = &sysfs_backing_dev_info;
 	inode->i_op = &sysfs_inode_operations;
@@ -214,6 +215,15 @@ struct inode * sysfs_get_inode(struct sysfs_dirent *sd)
 	return inode;
 }
 
+void sysfs_delete_inode(struct inode *inode)
+{
+	struct sysfs_dirent *sd  = inode->i_private;
+
+	truncate_inode_pages(&inode->i_data, 0);
+	clear_inode(inode);
+	sysfs_put(sd);
+}
+
 int sysfs_hash_and_remove(struct sysfs_dirent *dir_sd, const char *name)
 {
 	struct sysfs_addrm_cxt acxt;
diff --git a/fs/sysfs/mount.c b/fs/sysfs/mount.c
index f3e34fd..59fcd58 100644
--- a/fs/sysfs/mount.c
+++ b/fs/sysfs/mount.c
@@ -30,6 +30,7 @@ struct kmem_cache *sysfs_dir_cachep;
 static const struct super_operations sysfs_ops = {
 	.statfs		= simple_statfs,
 	.drop_inode	= generic_delete_inode,
+	.delete_inode	= sysfs_delete_inode,
 };
 
 struct sysfs_dirent sysfs_root = {
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index 93c6d6b..9055d04 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -145,6 +145,7 @@ static inline void __sysfs_put(struct sysfs_dirent *sd)
  * inode.c
  */
 struct inode *sysfs_get_inode(struct sysfs_dirent *sd);
+void sysfs_delete_inode(struct inode *inode);
 int sysfs_setattr(struct dentry *dentry, struct iattr *iattr);
 int sysfs_hash_and_remove(struct sysfs_dirent *dir_sd, const char *name);
 int sysfs_inode_init(void);
-- 
1.5.6.3

