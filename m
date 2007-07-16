Return-Path: <linux-kernel-owner+w=401wt.eu-S1755623AbXGPEQn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755623AbXGPEQn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 00:16:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750988AbXGPEQe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 00:16:34 -0400
Received: from nlpi043.sbcis.sbc.com ([207.115.36.72]:48049 "EHLO
	nlpi043.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817AbXGPEQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 00:16:33 -0400
X-Greylist: delayed 448 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Jul 2007 00:16:33 EDT
X-ORBL: [68.91.195.235]
Date: Sun, 15 Jul 2007 23:01:00 -0500
From: Michael Halcrow <mhalcrow@us.ibm.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, konishi.ryusuke@lab.ntt.co.jp,
       mhalcrow@us.ibm.com
Subject: [PATCH] eCryptfs: ecryptfs_setattr() bugfix
Message-ID: <20070716040059.GA6275@halcrow.us>
Reply-To: Michael Halcrow <mhalcrow@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

There is another bug recently introduced into the ecryptfs_setattr()
function in 2.6.22. eCryptfs will attempt to treat special files like
regular eCryptfs files on chmod, chown, and so forth. This leads to a
NULL pointer dereference. This patch validates that the file is a
regular file before proceeding with operations related to the inode's
crypt_stat.

Thanks to Ryusuke Konishi for finding this bug and suggesting the fix.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
---
 fs/ecryptfs/inode.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
index 83e94fe..9c6877c 100644
--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -902,8 +902,9 @@ static int ecryptfs_setattr(struct dentry *dentry, struct iattr *ia)
 	mutex_lock(&crypt_stat->cs_mutex);
 	if (S_ISDIR(dentry->d_inode->i_mode))
 		crypt_stat->flags &= ~(ECRYPTFS_ENCRYPTED);
-	else if (!(crypt_stat->flags & ECRYPTFS_POLICY_APPLIED)
-		 || !(crypt_stat->flags & ECRYPTFS_KEY_VALID)) {
+	else if (S_ISREG(dentry->d_inode->i_mode)
+		 && (!(crypt_stat->flags & ECRYPTFS_POLICY_APPLIED)
+		     || !(crypt_stat->flags & ECRYPTFS_KEY_VALID))) {
 		struct vfsmount *lower_mnt;
 		struct file *lower_file = NULL;
 		struct ecryptfs_mount_crypt_stat *mount_crypt_stat;
-- 
1.5.2.1
