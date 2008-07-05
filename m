Return-Path: <linux-kernel-owner+w=401wt.eu-S1756883AbYGERl5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756883AbYGERl5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 13:41:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756048AbYGERg4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 13:36:56 -0400
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:33042 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754550AbYGERg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 13:36:29 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>,
       Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       Mingming Cao <cmm@us.ibm.com>, "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 02/52] ext4: start searching for the right extent from the goal group.
Date: Sat,  5 Jul 2008 13:35:28 -0400
Message-Id: <1215279378-30504-3-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.5.6.rc3.1.g36b7.dirty
In-Reply-To: <1215279378-30504-2-git-send-email-tytso@mit.edu>
References: <1215279378-30504-1-git-send-email-tytso@mit.edu>
 <1215279378-30504-2-git-send-email-tytso@mit.edu>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

With mballoc we search for the best extent using different
criteria. We should always use the goal group when we are
starting with a new criteria.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Mingming Cao <cmm@us.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/mballoc.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index c9900aa..e4b1ea3 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -1730,10 +1730,6 @@ ext4_mb_regular_allocator(struct ext4_allocation_context *ac)
 		ac->ac_g_ex.fe_start = sbi->s_mb_last_start;
 		spin_unlock(&sbi->s_md_lock);
 	}
-
-	/* searching for the right group start from the goal value specified */
-	group = ac->ac_g_ex.fe_group;
-
 	/* Let's just scan groups to find more-less suitable blocks */
 	cr = ac->ac_2order ? 0 : 1;
 	/*
@@ -1743,6 +1739,12 @@ ext4_mb_regular_allocator(struct ext4_allocation_context *ac)
 repeat:
 	for (; cr < 4 && ac->ac_status == AC_STATUS_CONTINUE; cr++) {
 		ac->ac_criteria = cr;
+		/*
+		 * searching for the right group start
+		 * from the goal value specified
+		 */
+		group = ac->ac_g_ex.fe_group;
+
 		for (i = 0; i < EXT4_SB(sb)->s_groups_count; group++, i++) {
 			struct ext4_group_info *grp;
 			struct ext4_group_desc *desc;
-- 
1.5.6.rc3.1.g36b7.dirty

