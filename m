Return-Path: <linux-kernel-owner+w=401wt.eu-S1757989AbYC2DH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757989AbYC2DH1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 23:07:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753710AbYC2DHU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 23:07:20 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:49644 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752851AbYC2DHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 23:07:20 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] jbd/jbd2 NULL noise
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1JfRPa-0002U9-J5@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Sat, 29 Mar 2008 03:07:18 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/jbd/journal.c  |    4 ++--
 fs/jbd/revoke.c   |    4 ++--
 fs/jbd2/journal.c |   12 ++++++------
 fs/jbd2/revoke.c  |    4 ++--
 4 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
index 9816293..0e081d5 100644
--- a/fs/jbd/journal.c
+++ b/fs/jbd/journal.c
@@ -1620,14 +1620,14 @@ static int journal_init_journal_head_cache(void)
 {
 	int retval;
 
-	J_ASSERT(journal_head_cache == 0);
+	J_ASSERT(journal_head_cache == NULL);
 	journal_head_cache = kmem_cache_create("journal_head",
 				sizeof(struct journal_head),
 				0,		/* offset */
 				SLAB_TEMPORARY,	/* flags */
 				NULL);		/* ctor */
 	retval = 0;
-	if (journal_head_cache == 0) {
+	if (!journal_head_cache) {
 		retval = -ENOMEM;
 		printk(KERN_EMERG "JBD: no memory for journal_head cache\n");
 	}
diff --git a/fs/jbd/revoke.c b/fs/jbd/revoke.c
index ad2eacf..d5f8eee 100644
--- a/fs/jbd/revoke.c
+++ b/fs/jbd/revoke.c
@@ -173,13 +173,13 @@ int __init journal_init_revoke_caches(void)
 					   0,
 					   SLAB_HWCACHE_ALIGN|SLAB_TEMPORARY,
 					   NULL);
-	if (revoke_record_cache == 0)
+	if (!revoke_record_cache)
 		return -ENOMEM;
 
 	revoke_table_cache = kmem_cache_create("revoke_table",
 					   sizeof(struct jbd_revoke_table_s),
 					   0, SLAB_TEMPORARY, NULL);
-	if (revoke_table_cache == 0) {
+	if (!revoke_table_cache) {
 		kmem_cache_destroy(revoke_record_cache);
 		revoke_record_cache = NULL;
 		return -ENOMEM;
diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 96ba846..954cff0 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -219,7 +219,7 @@ static int jbd2_journal_start_thread(journal_t *journal)
 	if (IS_ERR(t))
 		return PTR_ERR(t);
 
-	wait_event(journal->j_wait_done_commit, journal->j_task != 0);
+	wait_event(journal->j_wait_done_commit, journal->j_task != NULL);
 	return 0;
 }
 
@@ -231,7 +231,7 @@ static void journal_kill_thread(journal_t *journal)
 	while (journal->j_task) {
 		wake_up(&journal->j_wait_commit);
 		spin_unlock(&journal->j_state_lock);
-		wait_event(journal->j_wait_done_commit, journal->j_task == 0);
+		wait_event(journal->j_wait_done_commit, journal->j_task == NULL);
 		spin_lock(&journal->j_state_lock);
 	}
 	spin_unlock(&journal->j_state_lock);
@@ -1969,14 +1969,14 @@ static int journal_init_jbd2_journal_head_cache(void)
 {
 	int retval;
 
-	J_ASSERT(jbd2_journal_head_cache == 0);
+	J_ASSERT(jbd2_journal_head_cache == NULL);
 	jbd2_journal_head_cache = kmem_cache_create("jbd2_journal_head",
 				sizeof(struct journal_head),
 				0,		/* offset */
 				SLAB_TEMPORARY,	/* flags */
 				NULL);		/* ctor */
 	retval = 0;
-	if (jbd2_journal_head_cache == 0) {
+	if (!jbd2_journal_head_cache) {
 		retval = -ENOMEM;
 		printk(KERN_EMERG "JBD: no memory for journal_head cache\n");
 	}
@@ -2002,14 +2002,14 @@ static struct journal_head *journal_alloc_journal_head(void)
 	atomic_inc(&nr_journal_heads);
 #endif
 	ret = kmem_cache_alloc(jbd2_journal_head_cache, GFP_NOFS);
-	if (ret == 0) {
+	if (!ret) {
 		jbd_debug(1, "out of memory for journal_head\n");
 		if (time_after(jiffies, last_warning + 5*HZ)) {
 			printk(KERN_NOTICE "ENOMEM in %s, retrying.\n",
 			       __FUNCTION__);
 			last_warning = jiffies;
 		}
-		while (ret == 0) {
+		while (!ret) {
 			yield();
 			ret = kmem_cache_alloc(jbd2_journal_head_cache, GFP_NOFS);
 		}
diff --git a/fs/jbd2/revoke.c b/fs/jbd2/revoke.c
index df36f42..2e1453a 100644
--- a/fs/jbd2/revoke.c
+++ b/fs/jbd2/revoke.c
@@ -174,13 +174,13 @@ int __init jbd2_journal_init_revoke_caches(void)
 					   0,
 					   SLAB_HWCACHE_ALIGN|SLAB_TEMPORARY,
 					   NULL);
-	if (jbd2_revoke_record_cache == 0)
+	if (!jbd2_revoke_record_cache)
 		return -ENOMEM;
 
 	jbd2_revoke_table_cache = kmem_cache_create("jbd2_revoke_table",
 					   sizeof(struct jbd2_revoke_table_s),
 					   0, SLAB_TEMPORARY, NULL);
-	if (jbd2_revoke_table_cache == 0) {
+	if (!jbd2_revoke_table_cache) {
 		kmem_cache_destroy(jbd2_revoke_record_cache);
 		jbd2_revoke_record_cache = NULL;
 		return -ENOMEM;
-- 
1.5.3.GIT


