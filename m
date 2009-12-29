Return-Path: <linux-kernel-owner+w=401wt.eu-S1752792AbZL2Vgg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752792AbZL2Vgg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 16:36:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752766AbZL2Vgf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 16:36:35 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:52315 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752633AbZL2Vge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 16:36:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=WnEjG7E0y4uKRH0gcmAVOrIYaNGR3BHGTeli0422aHfgiX9frMa4muTZn0z4KxUokj
         BYR3A/ntfTqXW5fzFdlJIGol/kLjmbOCv4mKHIrpbC8bBOUSZhmylhVg9htsfB/fGQ0g
         SBJAbhS/0k8EI6tt1mB5D63yAxUxcVKmWL1ys=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Chris Mason <chris.mason@oracle.com>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] reiserfs: Fix remaining in-reclaim-fs <-> reclaim-fs-on locking inversion
Date: Tue, 29 Dec 2009 22:36:30 +0100
Message-Id: <1262122590-27900-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <a4423d670912200409w51690618i229b31c8c00f8dc4@mail.gmail.com>
References: <a4423d670912200409w51690618i229b31c8c00f8dc4@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 500f5a0bf5f0624dae34307010e240ec090e4cde
(reiserfs: Fix possible recursive lock) fixed a vmalloc under reiserfs
lock that triggered a lockdep warning because of a
IN-FS-RECLAIM <-> RECLAIM-FS-ON locking dependency inversion.

But this patch has ommitted another vmalloc call in the same path
that allocates the journal. Relax the lock for this one too.

Reported-by: Alexander Beregalov <a.beregalov@gmail.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>
---
 fs/reiserfs/journal.c |   15 ++++++++++++---
 1 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/fs/reiserfs/journal.c b/fs/reiserfs/journal.c
index 2f8a7e7..a059879 100644
--- a/fs/reiserfs/journal.c
+++ b/fs/reiserfs/journal.c
@@ -2758,11 +2758,18 @@ int journal_init(struct super_block *sb, const char *j_dev_name,
 	struct reiserfs_journal *journal;
 	struct reiserfs_journal_list *jl;
 	char b[BDEVNAME_SIZE];
+	int ret;
 
+	/*
+	 * Unlock here to avoid various RECLAIM-FS-ON <-> IN-RECLAIM-FS
+	 * dependency inversion warnings.
+	 */
+	reiserfs_write_unlock(sb);
 	journal = SB_JOURNAL(sb) = vmalloc(sizeof(struct reiserfs_journal));
 	if (!journal) {
 		reiserfs_warning(sb, "journal-1256",
 				 "unable to get memory for journal structure");
+		reiserfs_write_lock(sb);
 		return 1;
 	}
 	memset(journal, 0, sizeof(struct reiserfs_journal));
@@ -2771,10 +2778,12 @@ int journal_init(struct super_block *sb, const char *j_dev_name,
 	INIT_LIST_HEAD(&journal->j_working_list);
 	INIT_LIST_HEAD(&journal->j_journal_list);
 	journal->j_persistent_trans = 0;
-	if (reiserfs_allocate_list_bitmaps(sb,
-					   journal->j_list_bitmap,
-					   reiserfs_bmap_count(sb)))
+	ret = reiserfs_allocate_list_bitmaps(sb, journal->j_list_bitmap,
+					   reiserfs_bmap_count(sb));
+	reiserfs_write_lock(sb);
+	if (ret)
 		goto free_and_return;
+
 	allocate_bitmap_nodes(sb);
 
 	/* reserved for journal area support */
-- 
1.6.2.3

