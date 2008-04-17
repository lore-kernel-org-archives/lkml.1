Return-Path: <linux-kernel-owner+w=401wt.eu-S934367AbYDQJu6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934367AbYDQJu6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 05:50:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933748AbYDQJ0i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 05:26:38 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46228 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933675AbYDQJ03 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 05:26:29 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Christoph Hellwig <hch@lst.de>, Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 36/48] [GFS2] fix file_system_type leak on gfs2meta mount
Date: Thu, 17 Apr 2008 09:39:12 +0100
Message-Id: <12084216431261-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <12084216402644-git-send-email-swhiteho@redhat.com>
References: 12084214272083-git-send-email-swhiteho@redhat.com
 <12084215642582-git-send-email-swhiteho@redhat.com>
 <1208421571478-git-send-email-swhiteho@redhat.com>
 <12084215742081-git-send-email-swhiteho@redhat.com>
 <12084215763647-git-send-email-swhiteho@redhat.com>
 <12084215781246-git-send-email-swhiteho@redhat.com>
 <12084215802470-git-send-email-swhiteho@redhat.com>
 <12084215833555-git-send-email-swhiteho@redhat.com>
 <12084215851158-git-send-email-swhiteho@redhat.com>
 <120842158797-git-send-email-swhiteho@redhat.com>
 <12084215891940-git-send-email-swhiteho@redhat.com>
 <12084215913125-git-send-email-swhiteho@redhat.com>
 <12084215931509-git-send-email-swhiteho@redhat.com>
 <12084215961690-git-send-email-swhiteho@redhat.com>
 <1208421597980-git-send-email-swhiteho@redhat.com>
 <12084216003676-git-send-email-swhiteho@redhat.com>
 <12084216023999-git-send-email-swhiteho@redhat.com>
 <12084216044123-git-send-email-swhiteho@redhat.com>
 <12084216061172-git-send-email-swhiteho@redhat.com>
 <12084216082638-git-send-email-swhiteho@redhat.com>
 <12084216101961-git-send-email-swhiteho@redhat.com>
 <12084216121811-git-send-email-swhiteho@redhat.com>
 <12084216153016-git-send-email-swhiteho@redhat.com>
 <1208421617421-git-send-email-swhiteho@redhat.com>
 <12084216182363-git-send-email-swhiteho@redhat.com>
 <12084216204027-git-send-email-swhiteho@redhat.com>
 <12084216222853-git-send-email-swhiteho@redhat.com>
 <12084216241802-git-send-email-swhiteho@redhat.com>
 <12084216262937-git-send-email-swhiteho@redhat.com>
 <12084216281152-git-send-email-swhiteho@redhat.com>
 <12084216301107-git-send-email-swhiteho@redhat.com>
 <12084216323165-git-send-email-swhiteho@redhat.com>
 <1208421634101-git-send-email-swhiteho@redhat.com>
 <12084216372363-git-send-email-swhiteho@redhat.com>
 <12084216391215-git-send-email-swhiteho@redhat.com>
 <12084216402644-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

get_gfs2_sb does a get_fs_type without doing a put_filesystem and
thus leaking a file_system_type reference everytime it's called.

Just use gfs2_fs_type directly instead of doing the lookup and thus
fix the problem.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index c4b7a21..63d5fd2 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -943,7 +943,6 @@ static struct super_block* get_gfs2_sb(const char *dev_name)
 {
 	struct kstat stat;
 	struct nameidata nd;
-	struct file_system_type *fstype;
 	struct super_block *sb = NULL, *s;
 	int error;
 
@@ -955,8 +954,7 @@ static struct super_block* get_gfs2_sb(const char *dev_name)
 	}
 	error = vfs_getattr(nd.path.mnt, nd.path.dentry, &stat);
 
-	fstype = get_fs_type("gfs2");
-	list_for_each_entry(s, &fstype->fs_supers, s_instances) {
+	list_for_each_entry(s, &gfs2_fs_type.fs_supers, s_instances) {
 		if ((S_ISBLK(stat.mode) && s->s_dev == stat.rdev) ||
 		    (S_ISDIR(stat.mode) &&
 		     s == nd.path.dentry->d_inode->i_sb)) {
-- 
1.5.1.2

