Return-Path: <linux-kernel-owner+w=401wt.eu-S1765675AbYCGBcl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765675AbYCGBcl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 20:32:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759080AbYCGBbd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 20:31:33 -0500
Received: from kumera.dghda.com ([80.68.90.171]:1996 "EHLO kumera.dghda.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758208AbYCGBbc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 20:31:32 -0500
From: "Duane Griffin" <duaneg@dghda.com>
To: linux-ext4@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Theodore Tso <tytso@mit.edu>, sct@redhat.com,
       akpm@linux-foundation.org, adilger@clusterfs.com,
       Duane Griffin <duaneg@dghda.com>
Subject: [PATCH 3/3] jbd2: only create debugfs and stats entries if cache initialisation is successful
Date: Fri,  7 Mar 2008 01:31:24 +0000
Message-Id: <1204853484-25968-3-git-send-email-duaneg@dghda.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1204853484-25968-2-git-send-email-duaneg@dghda.com>
References: <1204853484-25968-1-git-send-email-duaneg@dghda.com>
 <1204853484-25968-2-git-send-email-duaneg@dghda.com>
Message-Id: <dcb02b202f5a84c79c9e8b1b0102e6ad52ed3b53.1204844851.git.duaneg@dghda.com>
In-Reply-To: <5e28cd633c71f6354a203a43000cbe5fef045589.1204844851.git.duaneg@dghda.com>
References: <5e28cd633c71f6354a203a43000cbe5fef045589.1204844851.git.duaneg@dghda.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

jbd2 debugfs and stats entries should only be created if cache initialisation
is successful. At the moment they are being created unconditionally which will
leave them dangling if cache (and hence module) initialisation fails.

Signed-off-by: Duane Griffin <duaneg@dghda.com>
---
 fs/jbd2/journal.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 0d8a595..9d48419 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -2315,10 +2315,12 @@ static int __init journal_init(void)
 	BUILD_BUG_ON(sizeof(struct journal_superblock_s) != 1024);
 
 	ret = journal_init_caches();
-	if (ret != 0)
+	if (ret == 0) {
+		jbd2_create_debugfs_entry();
+		jbd2_create_jbd_stats_proc_entry();
+	} else {
 		jbd2_journal_destroy_caches();
-	jbd2_create_debugfs_entry();
-	jbd2_create_jbd_stats_proc_entry();
+	}
 	return ret;
 }
 
-- 
1.5.3.7

