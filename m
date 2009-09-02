Return-Path: <linux-kernel-owner+w=401wt.eu-S1753383AbZIBTzt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383AbZIBTzt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 15:55:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752789AbZIBTzt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 15:55:49 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51330 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751616AbZIBTzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 15:55:48 -0400
Date: Wed, 2 Sep 2009 12:55:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ed Cashin <ecashin@coraid.com>
Cc: bonbons@linux-vserver.org, ecashin@coraid.com, apw@canonical.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/1] aoe: ensure we initialise the request_queue
 correctly
Message-Id: <20090902125540.9fc9d582.akpm@linux-foundation.org>
In-Reply-To: <6309cc7d77486e24aca5130ec5802dfb@coraid.com>
References: <1250872904-10993-1-git-send-email-apw@canonical.com>
	<9ab0e087296715d764071d4d39542985@coraid.com>
	<20090829154305.723fd86c@neptune.home>
	<6309cc7d77486e24aca5130ec5802dfb@coraid.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Sep 2009 15:15:20 -0400
Ed Cashin <ecashin@coraid.com> wrote:

> The patch looks fine to me.

I translated that into Acked-by:.

> I don't think it should go in my aoe tree for linux-next, since the
> patch addresses a regression.
> 
> Based on the series file in mmotm, I don't think this patch is in mm
> at the moment.  Andrew Morton, do you think this patch should go
> through your mm tree?

I have it now.  Please check that the below is the right patch and that
my cobbled-together changelog makes sense (if not, please send
replacement changelog and/or patch).


From: Andy Whitcroft <apw@canonical.com>

When using the aoe driver we see an oops triggered by use of an
incorrectly initialised request_queue object:

  [ 2645.959090] kobject '<NULL>' (ffff880059ca22c0): tried to add
		an uninitialized object, something is seriously wrong.
  [ 2645.959104] Pid: 6, comm: events/0 Not tainted 2.6.31-5-generic #24-Ubuntu
  [ 2645.959107] Call Trace:
  [ 2645.959139] [<ffffffff8126ca2f>] kobject_add+0x5f/0x70
  [ 2645.959151] [<ffffffff8125b4ab>] blk_register_queue+0x8b/0xf0
  [ 2645.959155] [<ffffffff8126043f>] add_disk+0x8f/0x160
  [ 2645.959161] [<ffffffffa01673c4>] aoeblk_gdalloc+0x164/0x1c0 [aoe]

It seems this driver mearly embeds a request_queue object in its main
control structure and does not attempt to initialise it.  Pull this out
and use blk_init_queue/blk_cleanup_queue to handle initialisation and
teardown of this object.

Bruno bisected this regression down to

  cd43e26f071524647e660706b784ebcbefbd2e44

  block: Expose stacked device queues in sysfs

"This seems to generate /sys/block/$device/queue and its contents for
 everyone who is using queues, not just for those queues that have a
 non-NULL queue->request_fn."

Addresses http://bugs.launchpad.net/bugs/410198
Addresses http://bugzilla.kernel.org/show_bug.cgi?id=13942

Signed-off-by: Andy Whitcroft <apw@canonical.com>
Acked-by: Ed Cashin <ecashin@coraid.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Bruno Premont <bonbons@linux-vserver.org>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/aoe/aoe.h    |    2 +-
 drivers/block/aoe/aoeblk.c |    6 +++---
 drivers/block/aoe/aoedev.c |   11 ++++++++++-
 3 files changed, 14 insertions(+), 5 deletions(-)

diff -puN drivers/block/aoe/aoe.h~aoe-ensure-we-initialise-the-request_queue-correctly drivers/block/aoe/aoe.h
--- a/drivers/block/aoe/aoe.h~aoe-ensure-we-initialise-the-request_queue-correctly
+++ a/drivers/block/aoe/aoe.h
@@ -155,7 +155,7 @@ struct aoedev {
 	u16 fw_ver;		/* version of blade's firmware */
 	struct work_struct work;/* disk create work struct */
 	struct gendisk *gd;
-	struct request_queue blkq;
+	struct request_queue *blkq;
 	struct hd_geometry geo; 
 	sector_t ssize;
 	struct timer_list timer;
diff -puN drivers/block/aoe/aoeblk.c~aoe-ensure-we-initialise-the-request_queue-correctly drivers/block/aoe/aoeblk.c
--- a/drivers/block/aoe/aoeblk.c~aoe-ensure-we-initialise-the-request_queue-correctly
+++ a/drivers/block/aoe/aoeblk.c
@@ -264,8 +264,8 @@ aoeblk_gdalloc(void *vp)
 		goto err_disk;
 	}
 
-	blk_queue_make_request(&d->blkq, aoeblk_make_request);
-	if (bdi_init(&d->blkq.backing_dev_info))
+	blk_queue_make_request(d->blkq, aoeblk_make_request);
+	if (bdi_init(&d->blkq->backing_dev_info))
 		goto err_mempool;
 	spin_lock_irqsave(&d->lock, flags);
 	gd->major = AOE_MAJOR;
@@ -276,7 +276,7 @@ aoeblk_gdalloc(void *vp)
 	snprintf(gd->disk_name, sizeof gd->disk_name, "etherd/e%ld.%d",
 		d->aoemajor, d->aoeminor);
 
-	gd->queue = &d->blkq;
+	gd->queue = d->blkq;
 	d->gd = gd;
 	d->flags &= ~DEVFL_GDALLOC;
 	d->flags |= DEVFL_UP;
diff -puN drivers/block/aoe/aoedev.c~aoe-ensure-we-initialise-the-request_queue-correctly drivers/block/aoe/aoedev.c
--- a/drivers/block/aoe/aoedev.c~aoe-ensure-we-initialise-the-request_queue-correctly
+++ a/drivers/block/aoe/aoedev.c
@@ -113,6 +113,7 @@ aoedev_freedev(struct aoedev *d)
 	if (d->bufpool)
 		mempool_destroy(d->bufpool);
 	skbpoolfree(d);
+	blk_cleanup_queue(d->blkq);
 	kfree(d);
 }
 
@@ -202,6 +203,7 @@ aoedev_by_sysminor_m(ulong sysminor)
 {
 	struct aoedev *d;
 	ulong flags;
+	struct request_queue *rq;
 
 	spin_lock_irqsave(&devlist_lock, flags);
 
@@ -210,9 +212,13 @@ aoedev_by_sysminor_m(ulong sysminor)
 			break;
 	if (d)
 		goto out;
+	rq = blk_init_queue(NULL, NULL);
+	if (!rq)
+		goto out;
 	d = kcalloc(1, sizeof *d, GFP_ATOMIC);
 	if (!d)
-		goto out;
+		goto out_rq;
+	d->blkq = rq;
 	INIT_WORK(&d->work, aoecmd_sleepwork);
 	spin_lock_init(&d->lock);
 	skb_queue_head_init(&d->sendq);
@@ -234,6 +240,9 @@ aoedev_by_sysminor_m(ulong sysminor)
  out:
 	spin_unlock_irqrestore(&devlist_lock, flags);
 	return d;
+ out_rq:
+	blk_cleanup_queue(rq);
+	goto out;
 }
 
 static void
_

