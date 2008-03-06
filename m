Return-Path: <linux-kernel-owner+w=401wt.eu-S932858AbYCFCHz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932858AbYCFCHz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 21:07:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755026AbYCFCGH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 21:06:07 -0500
Received: from kumera.dghda.com ([80.68.90.171]:1428 "EHLO kumera.dghda.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752248AbYCFCGE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 21:06:04 -0500
From: "Duane Griffin" <duaneg@dghda.com>
To: linux-ext4@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Theodore Tso <tytso@mit.edu>, sct@redhat.com,
       akpm@linux-foundation.org, adilger@clusterfs.com,
       Duane Griffin <duaneg@dghda.com>
Subject: [RFC, PATCH 2/6] jbd: replace potentially false assertion with if block
Date: Thu,  6 Mar 2008 01:59:10 +0000
Message-Id: <1204768754-29655-3-git-send-email-duaneg@dghda.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1204768754-29655-2-git-send-email-duaneg@dghda.com>
References: <1204768754-29655-1-git-send-email-duaneg@dghda.com>
 <1204768754-29655-2-git-send-email-duaneg@dghda.com>
Message-Id: <7fbb2f28dcb417e3173ffacc103932c36683f2f0.1204685366.git.duaneg@dghda.com>
In-Reply-To: <a047dfbd7855d5f484ae8a3434f6a073302505be.1204685366.git.duaneg@dghda.com>
References: <a047dfbd7855d5f484ae8a3434f6a073302505be.1204685366.git.duaneg@dghda.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If an error occurs during jbd cache initialisation it is possible for the
journal_head_cache to be NULL when journal_destroy_journal_head_cache is
called. Replace the J_ASSERT with an if block to handle the situation
correctly.

Note that even with this fix things will break badly if ext3 is statically
compiled in and cache initialisation fails.

Signed-off-by: Duane Griffin <duaneg@dghda.com>
---

At the moment the cache destruction methods are inconsistent in whether they
set the cache pointers to NULL after destroying them. To be precise,
journal_destroy_handle_cache doesn't, the others do. I haven't changed that,
although I was sorely tempted. I think it would be better to be consistent and
that NULLing the pointers is preferable. Any objections?

This patch is an independent bug fix and following patches in this series do
not depend on it.

 fs/jbd/journal.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
index 3943a89..3f334a3 100644
--- a/fs/jbd/journal.c
+++ b/fs/jbd/journal.c
@@ -1635,9 +1635,10 @@ static int journal_init_journal_head_cache(void)
 
 static void journal_destroy_journal_head_cache(void)
 {
-	J_ASSERT(journal_head_cache != NULL);
-	kmem_cache_destroy(journal_head_cache);
-	journal_head_cache = NULL;
+	if (journal_head_cache) {
+		kmem_cache_destroy(journal_head_cache);
+		journal_head_cache = NULL;
+	}
 }
 
 /*
-- 
1.5.3.7

