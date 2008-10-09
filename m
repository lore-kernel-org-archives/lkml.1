Return-Path: <linux-kernel-owner+w=401wt.eu-S1759277AbYJIEOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759277AbYJIEOT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 00:14:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757923AbYJIEHN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 00:07:13 -0400
Received: from www.church-of-our-saviour.org ([69.25.196.31]:54505 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757597AbYJIEGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 00:06:13 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 14/42] ext4: truncate block allocated on a failed ext4_write_begin
Date: Thu,  9 Oct 2008 00:05:32 -0400
Message-Id: <1223525160-9887-15-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.5.6.1.205.ge2c7.dirty
In-Reply-To: <1223525160-9887-14-git-send-email-tytso@mit.edu>
References: <1223525160-9887-1-git-send-email-tytso@mit.edu>
 <1223525160-9887-2-git-send-email-tytso@mit.edu>
 <1223525160-9887-3-git-send-email-tytso@mit.edu>
 <1223525160-9887-4-git-send-email-tytso@mit.edu>
 <1223525160-9887-5-git-send-email-tytso@mit.edu>
 <1223525160-9887-6-git-send-email-tytso@mit.edu>
 <1223525160-9887-7-git-send-email-tytso@mit.edu>
 <1223525160-9887-8-git-send-email-tytso@mit.edu>
 <1223525160-9887-9-git-send-email-tytso@mit.edu>
 <1223525160-9887-10-git-send-email-tytso@mit.edu>
 <1223525160-9887-11-git-send-email-tytso@mit.edu>
 <1223525160-9887-12-git-send-email-tytso@mit.edu>
 <1223525160-9887-13-git-send-email-tytso@mit.edu>
 <1223525160-9887-14-git-send-email-tytso@mit.edu>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

For blocksize < pagesize we need to remove blocks that got allocated in
block_write_begin() if we fail with ENOSPC for later blocks.
block_write_begin() internally does this if it allocated pages locally.
This makes sure we don't have blocks outside inode.i_size during ENOSPC.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/inode.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index f97b347..634f0bc 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1391,6 +1391,13 @@ retry:
 		unlock_page(page);
 		ext4_journal_stop(handle);
 		page_cache_release(page);
+		/*
+		 * block_write_begin may have instantiated a few blocks
+		 * outside i_size.  Trim these off again. Don't need
+		 * i_size_read because we hold i_mutex.
+		 */
+		if (pos + len > inode->i_size)
+			vmtruncate(inode, inode->i_size);
 	}
 
 	if (ret == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
@@ -2560,6 +2567,13 @@ retry:
 		unlock_page(page);
 		ext4_journal_stop(handle);
 		page_cache_release(page);
+		/*
+		 * block_write_begin may have instantiated a few blocks
+		 * outside i_size.  Trim these off again. Don't need
+		 * i_size_read because we hold i_mutex.
+		 */
+		if (pos + len > inode->i_size)
+			vmtruncate(inode, inode->i_size);
 	}
 
 	if (ret == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
-- 
1.5.6.1.205.ge2c7.dirty

