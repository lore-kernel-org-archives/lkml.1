Return-Path: <linux-kernel-owner+w=401wt.eu-S1756155AbYDHL1k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756155AbYDHL1k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 07:27:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754810AbYDHLTv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 07:19:51 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:20224 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752710AbYDHLTu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 07:19:50 -0400
From: "Denis V. Lunev" <den@openvz.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, "Denis V. Lunev" <den@openvz.org>
Subject: [PATCH 7/29] jbd2: use non-racy method for proc entries creation
Date: Tue,  8 Apr 2008 15:19:14 +0400
Message-Id: <1207653576-12640-7-git-send-email-den@openvz.org>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1207653508.7171.18.camel@iris.sw.ru>
References: <1207653508.7171.18.camel@iris.sw.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use proc_create()/proc_create_data() to make sure that ->proc_fops and
->data be setup before gluing PDE to main tree.

Signed-off-by: Denis V. Lunev <den@openvz.org>
CC: sct@redhat.com
CC: adilger@clusterfs.com
CC: linux-ext4@vger.kernel.org
---
 fs/jbd2/journal.c |   17 ++++-------------
 1 files changed, 4 insertions(+), 13 deletions(-)

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 6ea7801..255e0dc 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -904,19 +904,10 @@ static void jbd2_stats_proc_init(journal_t *journal)
 	snprintf(name, sizeof(name) - 1, "%s", bdevname(journal->j_dev, name));
 	journal->j_proc_entry = proc_mkdir(name, proc_jbd2_stats);
 	if (journal->j_proc_entry) {
-		struct proc_dir_entry *p;
-		p = create_proc_entry("history", S_IRUGO,
-				journal->j_proc_entry);
-		if (p) {
-			p->proc_fops = &jbd2_seq_history_fops;
-			p->data = journal;
-			p = create_proc_entry("info", S_IRUGO,
-						journal->j_proc_entry);
-			if (p) {
-				p->proc_fops = &jbd2_seq_info_fops;
-				p->data = journal;
-			}
-		}
+		proc_create_data("history", S_IRUGO, journal->j_proc_entry,
+				 &jbd2_seq_history_fops, journal);
+		proc_create_data("info", S_IRUGO, journal->j_proc_entry,
+				 &jbd2_seq_info_fops, journal);
 	}
 }
 
-- 
1.5.3.rc5

