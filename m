Return-Path: <linux-kernel-owner+w=401wt.eu-S1759199AbXKZQuk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759199AbXKZQuk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 11:50:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758235AbXKZQs4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 11:48:56 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:53088 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758697AbXKZQsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 11:48:55 -0500
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>, Hugh Dickins <hugh@veritas.com>
Subject: [PATCH 14/16] Unionfs: prevent multiple writers to lower_page
Date: Mon, 26 Nov 2007 11:44:11 -0500
Message-Id: <11960954592000-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <11960954531503-git-send-email-ezk@cs.sunysb.edu>
References: <11960954531503-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Without this patch, the LTP fs test "rwtest04" triggers a
BUG_ON(PageWriteback(page)) in fs/buffer.c:1706.

CC: Hugh Dickins <hugh@veritas.com>

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/mmap.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/unionfs/mmap.c b/fs/unionfs/mmap.c
index 623a913..ea5ef3d 100644
--- a/fs/unionfs/mmap.c
+++ b/fs/unionfs/mmap.c
@@ -73,6 +73,7 @@ static int unionfs_writepage(struct page *page, struct writeback_control *wbc)
 
 	BUG_ON(!lower_mapping->a_ops->writepage);
 	clear_page_dirty_for_io(lower_page); /* emulate VFS behavior */
+	wait_on_page_writeback(lower_page); /* prevent multiple writers */
 	err = lower_mapping->a_ops->writepage(lower_page, wbc);
 	if (err < 0)
 		goto out_release;
-- 
1.5.2.2

