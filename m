Return-Path: <linux-kernel-owner+w=401wt.eu-S932490AbZHUQmG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932490AbZHUQmG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 12:42:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932440AbZHUQmE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 12:42:04 -0400
Received: from adelie.canonical.com ([91.189.90.139]:52656 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932444AbZHUQmC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 12:42:02 -0400
From: Andy Whitcroft <apw@canonical.com>
To: "Ed L. Cashin" <ecashin@coraid.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Cc: Andy Whitcroft <apw@canonical.com>
Subject: [PATCH 1/1] aoe: ensure we initialise the request_queue correctly
Date: Fri, 21 Aug 2009 17:41:44 +0100
Message-Id: <1250872904-10993-2-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.6.3.rc3.199.g24398
In-Reply-To: <1250872904-10993-1-git-send-email-apw@canonical.com>
References: <1250872904-10993-1-git-send-email-apw@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BugLink: http://bugs.launchpad.net/bugs/410198

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

Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 drivers/block/aoe/aoe.h    |    2 +-
 drivers/block/aoe/aoeblk.c |    6 +++---
 drivers/block/aoe/aoedev.c |   11 ++++++++++-
 3 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/block/aoe/aoe.h b/drivers/block/aoe/aoe.h
index 5e41e6d..db195ab 100644
--- a/drivers/block/aoe/aoe.h
+++ b/drivers/block/aoe/aoe.h
@@ -155,7 +155,7 @@ struct aoedev {
 	u16 fw_ver;		/* version of blade's firmware */
 	struct work_struct work;/* disk create work struct */
 	struct gendisk *gd;
-	struct request_queue blkq;
+	struct request_queue *blkq;
 	struct hd_geometry geo; 
 	sector_t ssize;
 	struct timer_list timer;
diff --git a/drivers/block/aoe/aoeblk.c b/drivers/block/aoe/aoeblk.c
index 2307a27..83e0dfd 100644
--- a/drivers/block/aoe/aoeblk.c
+++ b/drivers/block/aoe/aoeblk.c
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
diff --git a/drivers/block/aoe/aoedev.c b/drivers/block/aoe/aoedev.c
index eeea477..0add442 100644
--- a/drivers/block/aoe/aoedev.c
+++ b/drivers/block/aoe/aoedev.c
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
-- 
1.6.3.rc3.199.g24398

