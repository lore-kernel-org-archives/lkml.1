Return-Path: <linux-kernel-owner+w=401wt.eu-S1759727AbYGERt7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759727AbYGERt7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 13:49:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756665AbYGERiR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 13:38:17 -0400
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:33085 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755915AbYGERgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 13:36:32 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>,
       Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       Mingming Cao <cmm@us.ibm.com>, "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 17/52] ext4: Update i_disksize properly when allocating from fallocate area.
Date: Sat,  5 Jul 2008 13:35:43 -0400
Message-Id: <1215279378-30504-18-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.5.6.rc3.1.g36b7.dirty
In-Reply-To: <1215279378-30504-17-git-send-email-tytso@mit.edu>
References: <1215279378-30504-1-git-send-email-tytso@mit.edu>
 <1215279378-30504-2-git-send-email-tytso@mit.edu>
 <1215279378-30504-3-git-send-email-tytso@mit.edu>
 <1215279378-30504-4-git-send-email-tytso@mit.edu>
 <1215279378-30504-5-git-send-email-tytso@mit.edu>
 <1215279378-30504-6-git-send-email-tytso@mit.edu>
 <1215279378-30504-7-git-send-email-tytso@mit.edu>
 <1215279378-30504-8-git-send-email-tytso@mit.edu>
 <1215279378-30504-9-git-send-email-tytso@mit.edu>
 <1215279378-30504-10-git-send-email-tytso@mit.edu>
 <1215279378-30504-11-git-send-email-tytso@mit.edu>
 <1215279378-30504-12-git-send-email-tytso@mit.edu>
 <1215279378-30504-13-git-send-email-tytso@mit.edu>
 <1215279378-30504-14-git-send-email-tytso@mit.edu>
 <1215279378-30504-15-git-send-email-tytso@mit.edu>
 <1215279378-30504-16-git-send-email-tytso@mit.edu>
 <1215279378-30504-17-git-send-email-tytso@mit.edu>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

When allocating unitialized space at the end of file which had been
preallocated with the FALLOC_FL_KEEP_SIZE option, the file size is not
updated at that time.  But the later we are not updating the file size
when writing to that preallocated space.

These changes are for code correctness.  This patch allows us to update
the i_disksize at the write_end() callback of filesystem properly.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Mingming Cao <cmm@us.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/extents.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 47929c4..f7a746b 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2716,13 +2716,13 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
 		goto out2;
 	}
 
-	if (extend_disksize && inode->i_size > EXT4_I(inode)->i_disksize)
-		EXT4_I(inode)->i_disksize = inode->i_size;
-
 	/* previous routine could use block we allocated */
 	newblock = ext_pblock(&newex);
 	allocated = ext4_ext_get_actual_len(&newex);
 outnew:
+	if (extend_disksize && inode->i_size > EXT4_I(inode)->i_disksize)
+		EXT4_I(inode)->i_disksize = inode->i_size;
+
 	__set_bit(BH_New, &bh_result->b_state);
 
 	/* Cache only when it is _not_ an uninitialized extent */
-- 
1.5.6.rc3.1.g36b7.dirty

