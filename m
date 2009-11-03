Return-Path: <linux-kernel-owner+w=401wt.eu-S1752419AbZKCLzM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752419AbZKCLzM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 06:55:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751747AbZKCLzL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 06:55:11 -0500
Received: from smtp.nokia.com ([192.100.122.230]:52633 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500AbZKCLzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 06:55:09 -0500
Date: Tue, 3 Nov 2009 13:54:44 +0200
From: Jarkko Lavinen <jarkko.lavinen@nokia.com>
To: ext Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Jens Axboe <axboe@kernel.dk>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>
Subject: Re: [PATCH 1/2] Disk hot removal causing oopses and fixes
Message-ID: <20091103115444.GA8507@angel.research.nokia.com>
Reply-To: Jarkko Lavinen <jarkko.lavinen@nokia.com>
References: <20091021161201.GA16968@angel.research.nokia.com>
 <4ADF752D.7010206@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="azLHFNyN32YCQGCU"
Content-Disposition: inline
In-Reply-To: <4ADF752D.7010206@s5r6.in-berlin.de>
X-Operating-System: GNU/Linux angel.research.nokia.com
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 03 Nov 2009 11:54:45.0874 (UTC) FILETIME=[7007CD20:01CA5C7C]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--azLHFNyN32YCQGCU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Steven

Sorry for late reply.

> It has to reference-count its objects so that they are not freed as long
> as they are used by upper layers,

The block layer and device removal seems to be designed from
top-down approach.  Althouh disc is referenced from
__blkdev_get(), disc's request queue is not.  Also
blk_cleanup_queue() calls elevator_exit() without caring if
anyone still uses the elevator.

A remedy would be to take reference of the request queue in
__blkdev_get() and move elevator_exit() from blk_cleanup_queue()
to blk_release_queue().

I've tried this and it works fine. I am unable to cause oops within
the elevator or anywhere else with hot card removal.  This is how
it should be, since first the queue is marked dead and no new
requests are added into queue and old requests are flushed with
elevator_exit before releasing it and the dead status takes care
they don't even reach to requst issue function.

The caveat is ihat when request queue is initialzed with
blk_init_queue(), caller provides a pointer to spinlock.  When
blk_cleanup_queue() is called, drivers release the lock before
elevator_exit() is finished.  In mmc driver the struct containing
queue_lock is released immediately after returning blk_cleanup_queue().
Then later when request queue is released, elevator_exit() tries to
use the released spinlock.

Kind of hack workaround is to reset the queue_lock pointer to
request queue's internal lock in blk_cleanup_queue().

Jarkko Lavvinen
---
>From 8ccee6132f376d78bb6e355016ecc06c9ca47b9f Mon Sep 17 00:00:00 2001
From: Jarkko Lavinen <jarkko.lavinen@nokia.com>
Date: Tue, 3 Nov 2009 09:48:00 +0200
Subject: [PATCH] block: Move elevator exit from blk_cleanup_queue() to blk_release_queue()

If block_cleanup_queue() should not remove elevator if it is still
in use. Better call the elevator exit in blk_release_queue() when
all the reference to queue are gone.  Since drivers could use queue
locks which are freed after returning from blk_cleanup_queue(),
switch the queue lock to internal one.

Signed-off-by: Jarkko Lavinen <jarkko.lavinen@nokia.com>
---
 block/blk-core.c  |    8 ++++++--
 block/blk-sysfs.c |    3 +++
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 9daf621..8d7d5aa 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -449,6 +449,8 @@ void blk_put_queue(struct request_queue *q)
 
 void blk_cleanup_queue(struct request_queue *q)
 {
+	spinlock_t *oldlock;
+
 	/*
 	 * We know we have process context here, so we can be a little
 	 * cautious and ensure that pending block actions on this device
@@ -461,8 +463,10 @@ void blk_cleanup_queue(struct request_queue *q)
 	queue_flag_set_unlocked(QUEUE_FLAG_DEAD, q);
 	mutex_unlock(&q->sysfs_lock);
 
-	if (q->elevator)
-		elevator_exit(q->elevator);
+	oldlock = q->queue_lock;
+	spin_lock_irq(oldlock);
+	q->queue_lock = &q->__queue_lock;
+	spin_unlock_irq(oldlock);
 
 	blk_put_queue(q);
 }
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 21e275d..8ac3e5b 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -304,6 +304,9 @@ static void blk_release_queue(struct kobject *kobj)
 		container_of(kobj, struct request_queue, kobj);
 	struct request_list *rl = &q->rq;
 
+	if (q->elevator)
+		elevator_exit(q->elevator);
+
 	blk_sync_queue(q);
 
 	if (rl->rq_pool)
-- 
1.6.5


--azLHFNyN32YCQGCU
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0002-block-Move-elevator-exit-from-blk_cleanup_queue-to-b.patch"

>From 8ccee6132f376d78bb6e355016ecc06c9ca47b9f Mon Sep 17 00:00:00 2001
From: Jarkko Lavinen <jarkko.lavinen@nokia.com>
Date: Tue, 3 Nov 2009 09:48:00 +0200
Subject: [PATCH] block: Move elevator exit from blk_cleanup_queue() to blk_release_queue()

If block_cleanup_queue() should not remove elevator if it is still
in use. Better call the elevator exit in blk_release_queue() when
all the reference to queue are gone.  Since drivers could use queue
locks which are freed after returning from blk_cleanup_queue(),
switch the queue lock to internal one.

Signed-off-by: Jarkko Lavinen <jarkko.lavinen@nokia.com>
---
 block/blk-core.c  |    8 ++++++--
 block/blk-sysfs.c |    3 +++
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 9daf621..8d7d5aa 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -449,6 +449,8 @@ void blk_put_queue(struct request_queue *q)
 
 void blk_cleanup_queue(struct request_queue *q)
 {
+	spinlock_t *oldlock;
+
 	/*
 	 * We know we have process context here, so we can be a little
 	 * cautious and ensure that pending block actions on this device
@@ -461,8 +463,10 @@ void blk_cleanup_queue(struct request_queue *q)
 	queue_flag_set_unlocked(QUEUE_FLAG_DEAD, q);
 	mutex_unlock(&q->sysfs_lock);
 
-	if (q->elevator)
-		elevator_exit(q->elevator);
+	oldlock = q->queue_lock;
+	spin_lock_irq(oldlock);
+	q->queue_lock = &q->__queue_lock;
+	spin_unlock_irq(oldlock);
 
 	blk_put_queue(q);
 }
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 21e275d..8ac3e5b 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -304,6 +304,9 @@ static void blk_release_queue(struct kobject *kobj)
 		container_of(kobj, struct request_queue, kobj);
 	struct request_list *rl = &q->rq;
 
+	if (q->elevator)
+		elevator_exit(q->elevator);
+
 	blk_sync_queue(q);
 
 	if (rl->rq_pool)
-- 
1.6.5


--azLHFNyN32YCQGCU--
