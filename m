Return-Path: <linux-kernel-owner+w=401wt.eu-S1755592AbYDHLU7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755592AbYDHLU7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 07:20:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752494AbYDHLTX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 07:19:23 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:20150 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752375AbYDHLTU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 07:19:20 -0400
From: "Denis V. Lunev" <den@openvz.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, "Denis V. Lunev" <den@openvz.org>
Subject: [PATCH 6/29] reiserfs: use non-racy method for proc entries creation
Date: Tue,  8 Apr 2008 15:19:13 +0400
Message-Id: <1207653576-12640-6-git-send-email-den@openvz.org>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1207653508.7171.18.camel@iris.sw.ru>
References: <1207653508.7171.18.camel@iris.sw.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use proc_create()/proc_create_data() to make sure that ->proc_fops and
->data be setup before gluing PDE to main tree.

/proc entry owner is also added.

Signed-off-by: Denis V. Lunev <den@openvz.org>
CC: reiserfs-dev@namesys.com
CC: reiserfs-devel@vger.kernel.org
---
 fs/reiserfs/procfs.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/reiserfs/procfs.c b/fs/reiserfs/procfs.c
index 8f86c52..b9dbeec 100644
--- a/fs/reiserfs/procfs.c
+++ b/fs/reiserfs/procfs.c
@@ -467,6 +467,7 @@ static const struct file_operations r_file_operations = {
 	.read = seq_read,
 	.llseek = seq_lseek,
 	.release = seq_release,
+	.owner = THIS_MODULE,
 };
 
 static struct proc_dir_entry *proc_info_root = NULL;
@@ -475,12 +476,8 @@ static const char proc_info_root_name[] = "fs/reiserfs";
 static void add_file(struct super_block *sb, char *name,
 		     int (*func) (struct seq_file *, struct super_block *))
 {
-	struct proc_dir_entry *de;
-	de = create_proc_entry(name, 0, REISERFS_SB(sb)->procdir);
-	if (de) {
-		de->data = func;
-		de->proc_fops = &r_file_operations;
-	}
+	proc_create_data(name, 0, REISERFS_SB(sb)->procdir,
+			 &r_file_operations, func);
 }
 
 int reiserfs_proc_info_init(struct super_block *sb)
-- 
1.5.3.rc5

