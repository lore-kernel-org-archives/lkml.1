Return-Path: <linux-kernel-owner+w=401wt.eu-S1755257AbZGFJQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257AbZGFJQS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 05:16:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753115AbZGFJQF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 05:16:05 -0400
Received: from mx2.redhat.com ([66.187.237.31]:57071 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752709AbZGFJQD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 05:16:03 -0400
Date: Mon, 6 Jul 2009 05:15:33 -0400
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jeff Mahoney <jeffm@suse.com>, Yan Zheng <zheng.yan@oracle.com>,
       Josef Bacik <jbacik@redhat.com>, Arjan <arjan@infradead.org>,
       Chris Mason <chris.mason@oracle.com>, tao.ma@oracle.com,
       Amerigo Wang <amwang@redhat.com>, akpm@linux-foundation.org,
       linux-btrfs@vger.kernel.org, Sven Wegener <sven.wegener@stealer.net>
Message-Id: <20090706091747.6656.91812.sendpatchset@localhost.localdomain>
Subject: [Patch v3] btrfs: use file_remove_suid() after i_mutex is held
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


V2 -> V3:
set 'err' to -ENOMEM when kmalloc() fails. Thanks to Tao.

V1 -> V2:
Move kmalloc() before mutex_lock(), suggested by Arjan.

file_remove_suid() should be called with i_mutex held,
file_update_time() too. So move them after mutex_lock().

Plus, check the return value of kmalloc().

Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: Arjan <arjan@infradead.org>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Yan Zheng <zheng.yan@oracle.com>
Cc: Sven Wegener <sven.wegener@stealer.net>
Cc: Josef Bacik <jbacik@redhat.com>
Cc: Jeff Mahoney <jeffm@suse.com>
Cc: Tao Ma <tao.ma@oracle.com>

---
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 7c3cd24..e7b0d81 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -944,14 +944,19 @@ static ssize_t btrfs_file_write(struct file *file, const char __user *buf,
 	if (count == 0)
 		goto out_nolock;
 
+	pages = kmalloc(nrptrs * sizeof(struct page *), GFP_KERNEL);
+	if (!pages) {
+		err = -ENOMEM;
+		goto out_nolock;
+	}
+
+	mutex_lock(&inode->i_mutex);
+
 	err = file_remove_suid(file);
 	if (err)
-		goto out_nolock;
+		goto out;
 	file_update_time(file);
 
-	pages = kmalloc(nrptrs * sizeof(struct page *), GFP_KERNEL);
-
-	mutex_lock(&inode->i_mutex);
 	BTRFS_I(inode)->sequence++;
 	first_index = pos >> PAGE_CACHE_SHIFT;
 	last_index = (pos + count) >> PAGE_CACHE_SHIFT;
