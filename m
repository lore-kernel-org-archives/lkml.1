Return-Path: <linux-kernel-owner+w=401wt.eu-S1753619AbZGFHTM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753619AbZGFHTM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 03:19:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752976AbZGFHS5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 03:18:57 -0400
Received: from mx2.redhat.com ([66.187.237.31]:54798 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752906AbZGFHS4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 03:18:56 -0400
Date: Mon, 6 Jul 2009 03:18:29 -0400
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jeff Mahoney <jeffm@suse.com>, Yan Zheng <zheng.yan@oracle.com>,
       Josef Bacik <jbacik@redhat.com>, Arjan <arjan@infradead.org>,
       Chris Mason <chris.mason@oracle.com>, Amerigo Wang <amwang@redhat.com>,
       akpm@linux-foundation.org, linux-btrfs@vger.kernel.org,
       Sven Wegener <sven.wegener@stealer.net>
Message-Id: <20090706072043.6555.13669.sendpatchset@localhost.localdomain>
Subject: [Patch v2] btrfs: use file_remove_suid() after i_mutex is held
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


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

---
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 7c3cd24..09ef5d6 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -944,14 +944,17 @@ static ssize_t btrfs_file_write(struct file *file, const char __user *buf,
 	if (count == 0)
 		goto out_nolock;
 
+	pages = kmalloc(nrptrs * sizeof(struct page *), GFP_KERNEL);
+	if (!pages)
+		goto out_nolock;
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
