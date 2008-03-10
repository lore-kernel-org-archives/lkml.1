Return-Path: <linux-kernel-owner+w=401wt.eu-S1752968AbYCJMlf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752968AbYCJMlf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 08:41:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750799AbYCJMl1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 08:41:27 -0400
Received: from rv-out-0910.google.com ([209.85.198.190]:35474 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515AbYCJMl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 08:41:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=aa32zpCOYpNw2TOqZw0/gHpI/r14jrqRlMiE+LuVsMiWAQwuwzBc4R2tOTww9Q5tI1/MOAfXnhNcylrd9Rj4ECQYk8aCQWCt0qBOWDdP3k53e6dbKYy5mDQcnQYL65yPZUOyw+yIznbtB7rlP7Zf/5mhe6LRGiw6KFYYbX6NpPw=
Date: Mon, 10 Mar 2008 21:33:43 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] block: fix blk_register_queue() return value
Message-ID: <20080310123341.GA3351@APFDCB5C>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

blk_register_queue() returns -ENXIO when queue->request_fn is NULL.
But there are some block drivers that call blk_register_queue()
via add_disk() with queue->request_fn == NULL. (For example, brd, loop)

Although no one checks return value of blk_register_queue(), this patch
makes it return 0 instead of -ENXIO when queue->request_fn is NULL,

Also this patch adds warning when blk_register_queue() and
blk_unregister_queue() are called with queue == NULL rather than
ignore invalid usage silently.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>
---
 block/blk-sysfs.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

Index: 2.6-rc/block/blk-sysfs.c
===================================================================
--- 2.6-rc.orig/block/blk-sysfs.c
+++ 2.6-rc/block/blk-sysfs.c
@@ -276,9 +276,12 @@ int blk_register_queue(struct gendisk *d
 
 	struct request_queue *q = disk->queue;
 
-	if (!q || !q->request_fn)
+	if (WARN_ON(!q))
 		return -ENXIO;
 
+	if (!q->request_fn)
+		return 0;
+
 	ret = kobject_add(&q->kobj, kobject_get(&disk->dev.kobj),
 			  "%s", "queue");
 	if (ret < 0)
@@ -300,7 +303,10 @@ void blk_unregister_queue(struct gendisk
 {
 	struct request_queue *q = disk->queue;
 
-	if (q && q->request_fn) {
+	if (WARN_ON(!q))
+		return;
+
+	if (q->request_fn) {
 		elv_unregister_queue(q);
 
 		kobject_uevent(&q->kobj, KOBJ_REMOVE);
