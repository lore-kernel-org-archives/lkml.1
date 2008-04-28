Return-Path: <linux-kernel-owner+w=401wt.eu-S1764246AbYD1CHr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764246AbYD1CHr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 22:07:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753547AbYD1CHh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 22:07:37 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:30301 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752130AbYD1CHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 22:07:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=rLjjpBvNbT/lc5BZw9X+XaYGo2b3wZqrCce1VYzHQ8stTV3vjFC8jbetZknlinwKupNMqx08HjngPJnvVxK767NGqPDctN6L2T2vvuMFaplWXh9ElS8zN2QFVeigNxaLlbYUHPxgBP3/p6mGSvLl84mWSR5/VMps47IddTkZ0I4=
Date: Mon, 28 Apr 2008 10:08:18 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: jens.axboe@oracle.com
Subject: [PATCH 1/2] loop : change lo_refcnt from int to atomic_t
Message-ID: <20080428020818.GA2698@darkstar.te-china.tietoenator.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's not necessary to use lo_ctl_mutex to lock lo_refcnt. 

So here use atomic_t instead of int for lo_refcnt and leave lo_ctl_mutex just
for ioctl use.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>

---
drivers/block/loop.c |   12 +++++-------
include/linux/loop.h |    2 +-
2 files changed, 6 insertions(+), 8 deletions(-)

diff -upr linux/drivers/block/loop.c linux.new/drivers/block/loop.c
--- linux/drivers/block/loop.c	2008-04-25 10:10:25.000000000 +0800
+++ linux.new/drivers/block/loop.c	2008-04-25 10:30:54.000000000 +0800
@@ -891,7 +891,7 @@ static int loop_clr_fd(struct loop_devic
 	if (lo->lo_state != Lo_bound)
 		return -ENXIO;
 
-	if (lo->lo_refcnt > 1)	/* we needed one fd for the ioctl */
+	if (atomic_read(&lo->lo_refcnt) > 1)/* we needed one fd for the ioctl */
 		return -EBUSY;
 
 	if (filp == NULL)
@@ -1331,9 +1331,7 @@ static int lo_open(struct inode *inode, 
 {
 	struct loop_device *lo = inode->i_bdev->bd_disk->private_data;
 
-	mutex_lock(&lo->lo_ctl_mutex);
-	lo->lo_refcnt++;
-	mutex_unlock(&lo->lo_ctl_mutex);
+	atomic_inc(&lo->lo_refcnt);
 
 	return 0;
 }
@@ -1342,10 +1340,10 @@ static int lo_release(struct inode *inod
 {
 	struct loop_device *lo = inode->i_bdev->bd_disk->private_data;
 
-	mutex_lock(&lo->lo_ctl_mutex);
-	--lo->lo_refcnt;
+	atomic_dec(&lo->lo_refcnt);
 
-	if ((lo->lo_flags & LO_FLAGS_AUTOCLEAR) && !lo->lo_refcnt)
+	mutex_lock(&lo->lo_ctl_mutex);
+	if ((lo->lo_flags & LO_FLAGS_AUTOCLEAR) && !atomic_read(&lo->lo_refcnt))
 		loop_clr_fd(lo, inode->i_bdev);
 
 	mutex_unlock(&lo->lo_ctl_mutex);
diff -upr linux/include/linux/loop.h linux.new/include/linux/loop.h
--- linux/include/linux/loop.h	2008-04-25 10:31:23.000000000 +0800
+++ linux.new/include/linux/loop.h	2008-04-25 10:31:34.000000000 +0800
@@ -30,7 +30,7 @@ struct loop_func_table;
 
 struct loop_device {
 	int		lo_number;
-	int		lo_refcnt;
+	atomic_t	lo_refcnt;
 	loff_t		lo_offset;
 	loff_t		lo_sizelimit;
 	int		lo_flags;
