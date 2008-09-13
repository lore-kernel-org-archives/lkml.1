Return-Path: <linux-kernel-owner+w=401wt.eu-S1753473AbYIMPeB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473AbYIMPeB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2008 11:34:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752371AbYIMPdt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Sep 2008 11:33:49 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:51022 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752467AbYIMPds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2008 11:33:48 -0400
From: "Theodore Ts'o" <tytso@MIT.EDU>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       "Theodore Ts'o" <tytso@MIT.EDU>, linux-ext4@vger.kernel.org
Subject: [PATCH 2/4] ext3: truncate block allocated on a failed ext3_write_begin
Date: Sat, 13 Sep 2008 11:32:49 -0400
Message-Id: <1221319971-29879-2-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.5.6.1.205.ge2c7.dirty
In-Reply-To: <1221319971-29879-1-git-send-email-tytso@mit.edu>
References: <1221319971-29879-1-git-send-email-tytso@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

For blocksize < pagesize we need to remove blocks that got allocated in
block_write_begin() if we fail with ENOSPC for later blocks.
block_write_begin() internally does this if it allocated page
locally. This makes sure we don't have blocks outside inode.i_size
during ENOSPC.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org
---
 fs/ext3/inode.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index 507d868..bff22b9 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -1178,6 +1178,13 @@ write_begin_failed:
 		ext3_journal_stop(handle);
 		unlock_page(page);
 		page_cache_release(page);
+		/*
+		 * block_write_begin may have instantiated a few blocks
+		 * outside i_size.  Trim these off again. Don't need
+		 * i_size_read because we hold i_mutex.
+		 */
+		if (pos + len > inode->i_size)
+			vmtruncate(inode, inode->i_size);
 	}
 	if (ret == -ENOSPC && ext3_should_retry_alloc(inode->i_sb, &retries))
 		goto retry;
-- 
1.5.6.1.205.ge2c7.dirty

