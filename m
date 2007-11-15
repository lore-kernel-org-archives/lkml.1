Return-Path: <linux-kernel-owner+w=401wt.eu-S933231AbXKOG6q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933231AbXKOG6q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 01:58:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762372AbXKOGrU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 01:47:20 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:57977 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765062AbXKOGrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 01:47:17 -0500
Date: Wed, 14 Nov 2007 22:44:44 -0800
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Junichi Nomura <j-nomura@ce.jp.nec.com>,
       dm-devel@redhat.com, Alasdair G Kergon <agk@redhat.com>
Subject: [patch 16/40] dm: fix thaw_bdev
Message-ID: <20071115064444.GQ19218@kroah.com>
References: <20071115062710.885284510@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="dm-fix-thaw_bdev.patch"
In-Reply-To: <20071115064302.GA19218@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>

patch ae9da83f6d800fe1f3b23bfbc8f7222ad1c5bb74 in mainline.

This patch fixes a bd_mount_sem counter corruption bug in device-mapper.

thaw_bdev() should be called only when freeze_bdev() was called for the
device.
Otherwise, thaw_bdev() will up bd_mount_sem and corrupt the semaphore counter.
struct block_device with the corrupted semaphore may remain in slab cache
and be reused later.

Attached patch will fix it by calling unlock_fs() instead.
unlock_fs() will determine whether it should call thaw_bdev()
by checking the device is frozen or not.

Easy reproducer is:
  #!/bin/sh
  while [ 1 ]; do
     dmsetup --notable create a
     dmsetup --nolockfs suspend a
     dmsetup remove a
  done

It's not easy to see the effect of corrupted semaphore.
So I have tested with putting printk below in bdev_alloc_inode():
        if (atomic_read(&ei->bdev.bd_mount_sem.count) != 1)
                printk(KERN_DEBUG "Incorrect semaphore count = %d (%p)\n",
                        atomic_read(&ei->bdev.bd_mount_sem.count),
                        &ei->bdev);

Without the patch, I saw something like:
 Incorrect semaphore count = 17 (f2ab91c0)

With the patch, the message didn't appear.

The bug was introduced in 2.6.16 with this bug fix:

commit d9dde59ba03095e526640988c0fedd75e93bc8b7
Date:   Fri Feb 24 13:04:24 2006 -0800

    [PATCH] dm: missing bdput/thaw_bdev at removal
    
    Need to unfreeze and release bdev otherwise the bdev inode with
    inconsistent state is reused later and cause problem.
    
and backported to 2.6.15.5.

It occurs only in free_dev(), which is called only when the dm device is
removed.  The buggy code is executed only if md->suspended_bdev is
non-NULL and that can happen only when the device was suspended without
noflush.

Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 drivers/md/dm.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1064,12 +1064,14 @@ static struct mapped_device *alloc_dev(i
 	return NULL;
 }
 
+static void unlock_fs(struct mapped_device *md);
+
 static void free_dev(struct mapped_device *md)
 {
 	int minor = md->disk->first_minor;
 
 	if (md->suspended_bdev) {
-		thaw_bdev(md->suspended_bdev, NULL);
+		unlock_fs(md);
 		bdput(md->suspended_bdev);
 	}
 	mempool_destroy(md->tio_pool);

-- 
