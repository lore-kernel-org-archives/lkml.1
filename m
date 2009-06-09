Return-Path: <linux-kernel-owner+w=401wt.eu-S1759276AbZFIJCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759276AbZFIJCT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 05:02:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752356AbZFIJCH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 05:02:07 -0400
Received: from smtp.nokia.com ([192.100.122.233]:46182 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809AbZFIJCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 05:02:06 -0400
From: alexander.shishckin@gmail.com
To: linux-fsdevel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
       Alexander Shishkin <alexander.shishckin@gmail.com>
Subject: [PATCH] [RESEND] RFC: List per-process file descriptor consumption when hitting file-max
Date: Tue,  9 Jun 2009 12:01:11 +0300
Message-Id: <1244538071-992-1-git-send-email-alexander.shishckin@gmail.com>
X-Mailer: git-send-email 1.6.3.1
X-OriginalArrivalTime: 09 Jun 2009 09:02:01.0963 (UTC) FILETIME=[F3EF3BB0:01C9E8E0]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Shishkin <alexander.shishckin@gmail.com>

[resending to aim at wider audience]
When a file descriptor limit is hit, it might be useful to see all the
users to be able to identify those that leak descriptors.

Signed-off-by: Alexander Shishkin <alexander.shishckin@gmail.com>
---
 fs/file_table.c |   27 +++++++++++++++++++++++++++
 1 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/fs/file_table.c b/fs/file_table.c
index 54018fe..9e53167 100644
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -136,8 +136,35 @@ struct file *get_empty_filp(void)
 over:
 	/* Ran out of filps - report that */
 	if (get_nr_files() > old_max) {
+		struct task_struct *p;
+		struct files_struct *files;
+		struct fdtable *fdt;
+		int i, count = 0;
+
 		printk(KERN_INFO "VFS: file-max limit %d reached\n",
 					get_max_files());
+
+		read_lock(&tasklist_lock);
+		for_each_process(p) {
+			files = get_files_struct(p);
+			if (!files)
+				continue;
+
+			spin_lock(&files->file_lock);
+			fdt = files_fdtable(files);
+
+			/* we have to actually *count* the fds */
+			for (count = i = 0; i < fdt->max_fds; i++)
+				count += !!fcheck_files(files, i);
+
+			printk(KERN_INFO "=> %s [%d]: %d\n", p->comm,
+					p->pid, count);
+
+			spin_unlock(&files->file_lock);
+			put_files_struct(files);
+		}
+		read_unlock(&tasklist_lock);
+
 		old_max = get_nr_files();
 	}
 	goto fail;
-- 
1.6.1.3

