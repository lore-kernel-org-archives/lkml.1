Return-Path: <linux-kernel-owner+w=401wt.eu-S1754202AbXL1Uo4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202AbXL1Uo4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 15:44:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753001AbXL1Uni
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 15:43:38 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:37088 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752539AbXL1Ung (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 15:43:36 -0500
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>, Hugh Dickins <hugh@veritas.com>
Subject: [PATCH 03/30] Unionfs: use locking around i_size_write in 32-bit systems
Date: Fri, 28 Dec 2007 15:42:37 -0500
Message-Id: <1198874586764-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <11988745841003-git-send-email-ezk@cs.sunysb.edu>
References: <11988745841003-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC: Hugh Dickins <hugh@veritas.com>

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/super.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/fs/unionfs/super.c b/fs/unionfs/super.c
index 0ff9a9e..ed3eb04 100644
--- a/fs/unionfs/super.c
+++ b/fs/unionfs/super.c
@@ -69,7 +69,13 @@ static void unionfs_read_inode(struct inode *inode)
  */
 static void unionfs_delete_inode(struct inode *inode)
 {
+#if BITS_PER_LONG == 32 && defined(CONFIG_SMP)
+	spin_lock(&inode->i_lock);
+#endif
 	i_size_write(inode, 0);	/* every f/s seems to do that */
+#if BITS_PER_LONG == 32 && defined(CONFIG_SMP)
+	spin_unlock(&inode->i_lock);
+#endif
 
 	if (inode->i_data.nrpages)
 		truncate_inode_pages(&inode->i_data, 0);
-- 
1.5.2.2

