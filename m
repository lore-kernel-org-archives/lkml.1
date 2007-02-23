Return-Path: <linux-kernel-owner+w=401wt.eu-S1752089AbXBWAiJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752089AbXBWAiJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 19:38:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752094AbXBWAiJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 19:38:09 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:37284 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089AbXBWAiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 19:38:05 -0500
Date: Thu, 22 Feb 2007 18:38:03 -0600
From: Michael Halcrow <mhalcrow@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mhalcrow@us.ibm.com, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] eCryptfs: set O_LARGEFILE when opening lower file
Message-ID: <20070223003803.GA22599@us.ibm.com>
Reply-To: Michael Halcrow <mhalcrow@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitriy Monakhov <dmonakhov@openvz.org> wrote:
> Lets explicitly add O_LARGEFILE to opened lower file flags as it
> done in unionfs and nfsd. Also remove unnecessery #define from
> ecryptfs_initialize_file().

O_LARGEFILE should be set here when opening the lower file.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
---
 fs/ecryptfs/file.c  |    1 +
 fs/ecryptfs/inode.c |    3 ---
 2 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/fs/ecryptfs/file.c b/fs/ecryptfs/file.c
index bd969ad..7a7d25d 100644
--- a/fs/ecryptfs/file.c
+++ b/fs/ecryptfs/file.c
@@ -205,6 +205,7 @@ int ecryptfs_open_lower_file(struct file **lower_file,
 {
 	int rc = 0;
 
+	flags |= O_LARGEFILE;
 	dget(lower_dentry);
 	mntget(lower_mnt);
 	*lower_file = dentry_open(lower_dentry, lower_mnt, flags);
diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
index cf02a66..1b12e49 100644
--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -200,9 +200,6 @@ static int ecryptfs_initialize_file(struct dentry *ecryptfs_dentry)
 	inode = ecryptfs_dentry->d_inode;
 	crypt_stat = &ecryptfs_inode_to_private(inode)->crypt_stat;
 	lower_flags = ((O_CREAT | O_TRUNC) & O_ACCMODE) | O_RDWR;
-#if BITS_PER_LONG != 32
-	lower_flags |= O_LARGEFILE;
-#endif
 	lower_mnt = ecryptfs_dentry_to_lower_mnt(ecryptfs_dentry);
 	/* Corresponding fput() at end of this function */
 	if ((rc = ecryptfs_open_lower_file(&lower_file, lower_dentry, lower_mnt,
-- 
1.4.4.4

