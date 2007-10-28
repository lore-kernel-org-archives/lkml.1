Return-Path: <linux-kernel-owner+w=401wt.eu-S1754907AbXJ1XIa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907AbXJ1XIa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 19:08:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752558AbXJ1XIW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 19:08:22 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:35359 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752310AbXJ1XIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 19:08:21 -0400
Subject: [PATCH] Allow auto-destruction of loop devices.
From: David Woodhouse <dwmw2@infradead.org>
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Bernardo Innocenti <bernie@codewiz.org>
Content-Type: text/plain
Date: Sun, 28 Oct 2007 19:08:31 -0400
Message-Id: <1193612911.2915.80.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 (2.12.1-3.fc8.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This allows a flag to be set on loop devices so that when they are
closed for the last time, they'll self-destruct.

Signed-off-by: David Woodhouse <dwmw2@infradead.org>

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 56e2304..7fae828 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -973,6 +973,10 @@ loop_set_status(struct loop_device *lo, const struct loop_info64 *info)
 	lo->transfer = xfer->transfer;
 	lo->ioctl = xfer->ioctl;
 
+	if ( (lo->lo_flags & LO_FLAGS_AUTOCLEAR) !=
+	     (info->lo_flags & LO_FLAGS_AUTOCLEAR))
+		lo->lo_flags ^= LO_FLAGS_AUTOCLEAR;
+
 	lo->lo_encrypt_key_size = info->lo_encrypt_key_size;
 	lo->lo_init[0] = info->lo_init[0];
 	lo->lo_init[1] = info->lo_init[1];
@@ -1331,6 +1335,10 @@ static int lo_release(struct inode *inode, struct file *file)
 
 	mutex_lock(&lo->lo_ctl_mutex);
 	--lo->lo_refcnt;
+
+	if ((lo->lo_flags & LO_FLAGS_AUTOCLEAR) && !lo->lo_refcnt)
+		loop_clr_fd(lo, inode->i_bdev);
+
 	mutex_unlock(&lo->lo_ctl_mutex);
 
 	return 0;
diff --git a/include/linux/loop.h b/include/linux/loop.h
index 26a0a10..46169a7 100644
--- a/include/linux/loop.h
+++ b/include/linux/loop.h
@@ -76,6 +76,7 @@ struct loop_device {
 enum {
 	LO_FLAGS_READ_ONLY	= 1,
 	LO_FLAGS_USE_AOPS	= 2,
+	LO_FLAGS_AUTOCLEAR	= 4,
 };
 
 #include <asm/posix_types.h>	/* for __kernel_old_dev_t */

-- 
dwmw2

