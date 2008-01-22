Return-Path: <linux-kernel-owner+w=401wt.eu-S1761578AbYAVDKk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761578AbYAVDKk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 22:10:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759082AbYAVDFh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 22:05:37 -0500
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:65372 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759003AbYAVDFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 22:05:33 -0500
From: "Theodore Ts'o" <tytso@MIT.EDU>
To: linux-kernel@vger.kernel.org
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 23/49] Add buffer head related helper functions
Date: Mon, 21 Jan 2008 22:02:02 -0500
Message-Id: <1200970948-17903-24-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.5.4.rc3.31.g1271-dirty
In-Reply-To: <1200970948-17903-23-git-send-email-tytso@mit.edu>
References: <1200970948-17903-1-git-send-email-tytso@mit.edu>
 <1200970948-17903-2-git-send-email-tytso@mit.edu>
 <1200970948-17903-3-git-send-email-tytso@mit.edu>
 <1200970948-17903-4-git-send-email-tytso@mit.edu>
 <1200970948-17903-5-git-send-email-tytso@mit.edu>
 <1200970948-17903-6-git-send-email-tytso@mit.edu>
 <1200970948-17903-7-git-send-email-tytso@mit.edu>
 <1200970948-17903-8-git-send-email-tytso@mit.edu>
 <1200970948-17903-9-git-send-email-tytso@mit.edu>
 <1200970948-17903-10-git-send-email-tytso@mit.edu>
 <1200970948-17903-11-git-send-email-tytso@mit.edu>
 <1200970948-17903-12-git-send-email-tytso@mit.edu>
 <1200970948-17903-13-git-send-email-tytso@mit.edu>
 <1200970948-17903-14-git-send-email-tytso@mit.edu>
 <1200970948-17903-15-git-send-email-tytso@mit.edu>
 <1200970948-17903-16-git-send-email-tytso@mit.edu>
 <1200970948-17903-17-git-send-email-tytso@mit.edu>
 <1200970948-17903-18-git-send-email-tytso@mit.edu>
 <1200970948-17903-19-git-send-email-tytso@mit.edu>
 <1200970948-17903-20-git-send-email-tytso@mit.edu>
 <1200970948-17903-21-git-send-email-tytso@mit.edu>
 <1200970948-17903-22-git-send-email-tytso@mit.edu>
 <1200970948-17903-23-git-send-email-tytso@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

Add buffer head related helper function bh_uptodate_or_lock and
bh_submit_read which can be used by file system

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/buffer.c                 |   41 +++++++++++++++++++++++++++++++++++++++++
 include/linux/buffer_head.h |    2 ++
 2 files changed, 43 insertions(+), 0 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 7249e01..7593ff3 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -3213,6 +3213,47 @@ static int buffer_cpu_notify(struct notifier_block *self,
 	return NOTIFY_OK;
 }
 
+/**
+ * bh_uptodate_or_lock: Test whether the buffer is uptodate
+ * @bh: struct buffer_head
+ *
+ * Return true if the buffer is up-to-date and false,
+ * with the buffer locked, if not.
+ */
+int bh_uptodate_or_lock(struct buffer_head *bh)
+{
+	if (!buffer_uptodate(bh)) {
+		lock_buffer(bh);
+		if (!buffer_uptodate(bh))
+			return 0;
+		unlock_buffer(bh);
+	}
+	return 1;
+}
+EXPORT_SYMBOL(bh_uptodate_or_lock);
+/**
+ * bh_submit_read: Submit a locked buffer for reading
+ * @bh: struct buffer_head
+ *
+ * Returns a negative error
+ */
+int bh_submit_read(struct buffer_head *bh)
+{
+	if (!buffer_locked(bh))
+		lock_buffer(bh);
+
+	if (buffer_uptodate(bh))
+		return 0;
+
+	get_bh(bh);
+	bh->b_end_io = end_buffer_read_sync;
+	submit_bh(READ, bh);
+	wait_on_buffer(bh);
+	if (buffer_uptodate(bh))
+		return 0;
+	return -EIO;
+}
+EXPORT_SYMBOL(bh_submit_read);
 void __init buffer_init(void)
 {
 	int nrpages;
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index da0d83f..e98801f 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -192,6 +192,8 @@ int sync_dirty_buffer(struct buffer_head *bh);
 int submit_bh(int, struct buffer_head *);
 void write_boundary_block(struct block_device *bdev,
 			sector_t bblock, unsigned blocksize);
+int bh_uptodate_or_lock(struct buffer_head *bh);
+int bh_submit_read(struct buffer_head *bh);
 
 extern int buffer_heads_over_limit;
 
-- 
1.5.4.rc3.31.g1271-dirty

