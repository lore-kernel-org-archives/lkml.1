Return-Path: <linux-kernel-owner+w=401wt.eu-S1754636AbXJUXyi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636AbXJUXyi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 19:54:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752723AbXJUXwG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 19:52:06 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:49213 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192AbXJUXvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 19:51:54 -0400
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>,
       Christoph Hellwig <hch@lst.de>, Jeff Layton <jlayton@redhat.com>,
       Christoph Hellwig <hch@lst.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 8/9] Unionfs: fix unionfs_setattr to handle ATTR_KILL_S*ID
Date: Sun, 21 Oct 2007 19:51:21 -0400
Message-Id: <1193010686931-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <11930106823372-git-send-email-ezk@cs.sunysb.edu>
References: <11930106823372-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Layton <jlayton@redhat.com>

Don't allow unionfs_setattr to trip the BUG() in notify_change. Clear
ATTR_MODE if the either ATTR_KILL_S*ID is set. This also allows the
lower filesystem to interpret these bits in its own way.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Cc: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/inode.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/fs/unionfs/inode.c b/fs/unionfs/inode.c
index 4e59ace..6ca52f4 100644
--- a/fs/unionfs/inode.c
+++ b/fs/unionfs/inode.c
@@ -1048,6 +1048,13 @@ static int unionfs_setattr(struct dentry *dentry, struct iattr *ia)
 	bend = dbend(dentry);
 	inode = dentry->d_inode;
 
+	/*
+	 * mode change is for clearing setuid/setgid. Allow lower filesystem
+	 * to reinterpret it in its own way.
+	 */
+	if (ia->ia_valid & (ATTR_KILL_SUID | ATTR_KILL_SGID))
+		ia->ia_valid &= ~ATTR_MODE;
+
 	for (bindex = bstart; (bindex <= bend) || (bindex == bstart);
 	     bindex++) {
 		lower_dentry = unionfs_lower_dentry_idx(dentry, bindex);
-- 
1.5.2.2

