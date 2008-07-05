Return-Path: <linux-kernel-owner+w=401wt.eu-S1756158AbYGERTc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756158AbYGERTc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 13:19:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755274AbYGERTT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 13:19:19 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:13975 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754396AbYGERTS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 13:19:18 -0400
From: Dmitri Monakhov <dmonakhov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: jens.axboe@oracle.com, Dmitri Monakhov <dmonakhov@openvz.org>
Subject: [PATCH] loop: prevent get_user pages call from kernel thread(v2)
Date: Sat,  5 Jul 2008 21:19:00 +0400
Message-Id: <1215278340-3509-1-git-send-email-dmonakhov@openvz.org>
X-Mailer: git-send-email 1.5.4.rc4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes... everybody know that it is bad to write from kernel thread, and it is
madness to do it with O_DIRECT. But occasionly file with O_DIRECT flag
may be passed to loop device via LOOP_SET_FD. So if file-system has't
address_space ops, or simply hide it like GFS, it is possible to kill kernel
via two lines program. In fact we can't effectively guard kernel space by
deny O_DIRECT in loop's code, because user space can set it via
fcntl(,F_SETFL,). Let's simply add sanity check mm related logic.	

Signed-off-by: Dmitri Monakhov <dmonakhov@openvz.org>
---
 drivers/block/loop.c |    5 +++++
 fs/direct-io.c       |    4 ++++
 2 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index d3a25b0..01e2133 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -789,6 +789,11 @@ static int loop_set_fd(struct loop_device *lo, struct file *lo_file,
 	if (!(lo_file->f_mode & FMODE_WRITE))
 		lo_flags |= LO_FLAGS_READ_ONLY;
 
+	/* We can't use f_op->write with O_DIRECT from kernel thread. */
+	if (!(lo_flags & (LO_FLAGS_USE_AOPS | LO_FLAGS_READ_ONLY)) &&
+		file->f_mode & O_DIRECT)
+		goto out_putf;
+
 	set_device_ro(bdev, (lo_flags & LO_FLAGS_READ_ONLY) != 0);
 
 	lo->lo_blocksize = lo_blocksize;
diff --git a/fs/direct-io.c b/fs/direct-io.c
index 9606ee8..c383766 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -149,6 +149,10 @@ static int dio_refill_pages(struct dio *dio)
 	int ret;
 	int nr_pages;
 
+	if (unlikely(!current->mm)) {
+		WARN_ON_ONCE(1);
+		return -EINVAL;
+	}
 	nr_pages = min(dio->total_pages - dio->curr_page, DIO_PAGES);
 	ret = get_user_pages_fast(
 		dio->curr_user_address,		/* Where from? */
-- 
1.5.4.rc4

