Return-Path: <linux-kernel-owner+w=401wt.eu-S1765458AbYDVPnH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765458AbYDVPnH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 11:43:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758259AbYDVPmw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 11:42:52 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:33607 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756862AbYDVPmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 11:42:50 -0400
Date: Tue, 22 Apr 2008 10:41:17 -0500
From: Michael Halcrow <mhalcrow@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@ZenIV.linux.org.uk>
Subject: [PATCH] eCryptfs: Protect crypt_stat->flags in ecryptfs_open()
Message-ID: <20080422154117.GB8034@localhost.austin.ibm.com>
Reply-To: Michael Halcrow <mhalcrow@us.ibm.com>
References: <20080402150736.288c2f91.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080402150736.288c2f91.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro wrote:
> 	Incidentally, looking at ecryptfs open(), WTF is protecting
> crypt_stat->flags?  We take crypt_stat->cs_mutex, do nothing but
> check-and-modify of ->flags under it, then drop and several lines
> later do crypt_stat->flags &= ~(ECRYPTFS_ENCRYPTED); with no
> ->cs_mutex held...

Make sure crypt_stat->flags is protected with a lock in
ecryptfs_open().

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
---
 fs/ecryptfs/file.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/ecryptfs/file.c b/fs/ecryptfs/file.c
index 2b8f5ed..2258b8f 100644
--- a/fs/ecryptfs/file.c
+++ b/fs/ecryptfs/file.c
@@ -195,7 +195,9 @@ static int ecryptfs_open(struct inode *inode, struct file *file)
 		file, ecryptfs_inode_to_private(inode)->lower_file);
 	if (S_ISDIR(ecryptfs_dentry->d_inode->i_mode)) {
 		ecryptfs_printk(KERN_DEBUG, "This is a directory\n");
+		mutex_lock(&crypt_stat->cs_mutex);
 		crypt_stat->flags &= ~(ECRYPTFS_ENCRYPTED);
+		mutex_unlock(&crypt_stat->cs_mutex);
 		rc = 0;
 		goto out;
 	}
-- 
1.5.1.6

