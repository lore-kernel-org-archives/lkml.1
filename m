Return-Path: <linux-kernel-owner+w=401wt.eu-S1752772AbZIBODZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772AbZIBODZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 10:03:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752368AbZIBODY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 10:03:24 -0400
Received: from cantor.suse.de ([195.135.220.2]:49731 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752316AbZIBN72 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 09:59:28 -0400
From: Jan Kara <jack@suse.cz>
To: linux-fsdevel@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, hch@lst.de, Jan Kara <jack@suse.cz>,
       Felix Blyakher <felixb@sgi.com>, xfs@oss.sgi.com
Subject: [PATCH 13/16] xfs: Convert sync_page_range() to simple filemap_write_and_wait_range()
Date: Wed,  2 Sep 2009 15:59:23 +0200
Message-Id: <1251899966-7316-14-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1251899966-7316-1-git-send-email-jack@suse.cz>
References: <1251899966-7316-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig says that it is enough for XFS to call
filemap_write_and_wait_range() instead of sync_page_range() because we do
all the metadata syncing when forcing the log.

CC: Felix Blyakher <felixb@sgi.com>
CC: xfs@oss.sgi.com
CC: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/xfs/linux-2.6/xfs_lrw.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_lrw.c b/fs/xfs/linux-2.6/xfs_lrw.c
index 7078974..fde63a3 100644
--- a/fs/xfs/linux-2.6/xfs_lrw.c
+++ b/fs/xfs/linux-2.6/xfs_lrw.c
@@ -817,7 +817,8 @@ write_retry:
 		xfs_iunlock(xip, iolock);
 		if (need_i_mutex)
 			mutex_unlock(&inode->i_mutex);
-		error2 = sync_page_range(inode, mapping, pos, ret);
+		error2 = filemap_write_and_wait_range(mapping, pos,
+						      pos + ret - 1);
 		if (!error)
 			error = error2;
 		if (need_i_mutex)
-- 
1.6.0.2

