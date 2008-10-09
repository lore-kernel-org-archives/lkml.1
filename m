Return-Path: <linux-kernel-owner+w=401wt.eu-S1758813AbYJIELR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758813AbYJIELR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 00:11:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751119AbYJIEGm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 00:06:42 -0400
Received: from www.church-of-our-saviour.org ([69.25.196.31]:54470 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757432AbYJIEGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 00:06:08 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Eric Sandeen <sandeen@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 24/42] ext4: use percpu data structures for lg_prealloc_list
Date: Thu,  9 Oct 2008 00:05:42 -0400
Message-Id: <1223525160-9887-25-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.5.6.1.205.ge2c7.dirty
In-Reply-To: <1223525160-9887-24-git-send-email-tytso@mit.edu>
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
 <1223525160-9887-15-git-send-email-tytso@mit.edu>
 <1223525160-9887-16-git-send-email-tytso@mit.edu>
 <1223525160-9887-17-git-send-email-tytso@mit.edu>
 <1223525160-9887-18-git-send-email-tytso@mit.edu>
 <1223525160-9887-19-git-send-email-tytso@mit.edu>
 <1223525160-9887-20-git-send-email-tytso@mit.edu>
 <1223525160-9887-21-git-send-email-tytso@mit.edu>
 <1223525160-9887-22-git-send-email-tytso@mit.edu>
 <1223525160-9887-23-git-send-email-tytso@mit.edu>
 <1223525160-9887-24-git-send-email-tytso@mit.edu>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Sandeen <sandeen@redhat.com>

lg_prealloc_list seems to cry out for a per-cpu data structure; on a large
smp system I think this should be better.  I've lightly tested this change
on a 4-cpu system.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Acked-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/mballoc.c |   13 +++++--------
 1 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index af48548..01a7daa 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2541,17 +2541,16 @@ int ext4_mb_init(struct super_block *sb, int needs_recovery)
 	sbi->s_mb_history_filter = EXT4_MB_HISTORY_DEFAULT;
 	sbi->s_mb_group_prealloc = MB_DEFAULT_GROUP_PREALLOC;
 
-	i = sizeof(struct ext4_locality_group) * nr_cpu_ids;
-	sbi->s_locality_groups = kmalloc(i, GFP_KERNEL);
+	sbi->s_locality_groups = alloc_percpu(struct ext4_locality_group);
 	if (sbi->s_locality_groups == NULL) {
 		clear_opt(sbi->s_mount_opt, MBALLOC);
 		kfree(sbi->s_mb_offsets);
 		kfree(sbi->s_mb_maxs);
 		return -ENOMEM;
 	}
-	for (i = 0; i < nr_cpu_ids; i++) {
+	for_each_possible_cpu(i) {
 		struct ext4_locality_group *lg;
-		lg = &sbi->s_locality_groups[i];
+		lg = per_cpu_ptr(sbi->s_locality_groups, i);
 		mutex_init(&lg->lg_mutex);
 		for (j = 0; j < PREALLOC_TB_SIZE; j++)
 			INIT_LIST_HEAD(&lg->lg_prealloc_list[j]);
@@ -2648,8 +2647,7 @@ int ext4_mb_release(struct super_block *sb)
 				atomic_read(&sbi->s_mb_discarded));
 	}
 
-	kfree(sbi->s_locality_groups);
-
+	free_percpu(sbi->s_locality_groups);
 	ext4_mb_history_release(sb);
 	ext4_mb_destroy_per_dev_proc(sb);
 
@@ -4100,8 +4098,7 @@ static void ext4_mb_group_or_file(struct ext4_allocation_context *ac)
 	 * per cpu locality group is to reduce the contention between block
 	 * request from multiple CPUs.
 	 */
-	ac->ac_lg = &sbi->s_locality_groups[get_cpu()];
-	put_cpu();
+	ac->ac_lg = per_cpu_ptr(sbi->s_locality_groups, raw_smp_processor_id());
 
 	/* we're going to use group allocation */
 	ac->ac_flags |= EXT4_MB_HINT_GROUP_ALLOC;
-- 
1.5.6.1.205.ge2c7.dirty

