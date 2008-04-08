Return-Path: <linux-kernel-owner+w=401wt.eu-S1758456AbYDHL2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758456AbYDHL2S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 07:28:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754829AbYDHLTx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 07:19:53 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:15520 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754804AbYDHLTv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 07:19:51 -0400
From: "Denis V. Lunev" <den@openvz.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, "Denis V. Lunev" <den@openvz.org>
Subject: [PATCH 5/29] ext4: use non-racy method for proc entries creation
Date: Tue,  8 Apr 2008 15:19:12 +0400
Message-Id: <1207653576-12640-5-git-send-email-den@openvz.org>
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
 fs/ext4/mballoc.c |   15 ++++-----------
 1 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 9a6c70f..cbb47a0 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2455,17 +2455,10 @@ static void ext4_mb_history_init(struct super_block *sb)
 	int i;
 
 	if (sbi->s_mb_proc != NULL) {
-		struct proc_dir_entry *p;
-		p = create_proc_entry("mb_history", S_IRUGO, sbi->s_mb_proc);
-		if (p) {
-			p->proc_fops = &ext4_mb_seq_history_fops;
-			p->data = sb;
-		}
-		p = create_proc_entry("mb_groups", S_IRUGO, sbi->s_mb_proc);
-		if (p) {
-			p->proc_fops = &ext4_mb_seq_groups_fops;
-			p->data = sb;
-		}
+		proc_create_data("mb_history", S_IRUGO, sbi->s_mb_proc,
+				 &ext4_mb_seq_history_fops, sb);
+		proc_create_data("mb_groups", S_IRUGO, sbi->s_mb_proc,
+				 &ext4_mb_seq_groups_fops, sb);
 	}
 
 	sbi->s_mb_history_max = 1000;
-- 
1.5.3.rc5

