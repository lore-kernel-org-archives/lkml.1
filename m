Return-Path: <linux-kernel-owner+w=401wt.eu-S1754124AbZGSBtN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754124AbZGSBtN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 21:49:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754102AbZGSBtL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 21:49:11 -0400
Received: from hera.kernel.org ([140.211.167.34]:47931 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754091AbZGSBtL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 21:49:11 -0400
Message-ID: <4A627B7D.7080900@kernel.org>
Date: Sun, 19 Jul 2009 10:48:45 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Rakib Mullick <rakib.mullick@gmail.com>
CC: axboe@kernel.dk, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] block: Mark virtio_blk with __refdata in virtio_blk.c
References: <b9df5fa10907120413l21761e1cxfc26436481954c2a@mail.gmail.com>	 <4A6013F3.1030101@kernel.org> <b9df5fa10907170713u508f5c3br2463d0fc0ba0515@mail.gmail.com>
In-Reply-To: <b9df5fa10907170713u508f5c3br2463d0fc0ba0515@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 19 Jul 2009 01:49:08 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I slightly massaged the commit message and comment and committed it to
#tj-block-for-linus.  Will push it out in a few days.

Thanks.

>From 4fbfff76079a5c0e1751b0ddf53160d33f7831e7 Mon Sep 17 00:00:00 2001
From: Rakib Mullick <rakib.mullick@gmail.com>
Date: Fri, 17 Jul 2009 20:13:22 +0600
Subject: [PATCH] virtio_blk: mark virtio_blk with __refdata to kill spurious section mismatch

The variable virtio_blk references the function virtblk_probe() (which
is in .devinit section) and also references the function
virtblk_remove() ( which is in .devexit section). So, virtio_blk
simultaneously refers .devinit and .devexit section. To avoid this
messup, we mark virtio_blk as __refdata.

We were warned by the following warning:

  LD      drivers/block/built-in.o
  WARNING: drivers/block/built-in.o(.data+0xc8dc): Section mismatch in
  reference from the variable virtio_blk to the function
  .devinit.text:virtblk_probe()
  The variable virtio_blk references
  the function __devinit virtblk_probe()
  If the reference is valid then annotate the
  variable with __init* or __refdata (see linux/init.h) or name the variable:
  *driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,

  WARNING: drivers/block/built-in.o(.data+0xc8e0): Section mismatch in
  reference from the variable virtio_blk to the function
  .devexit.text:virtblk_remove()
  The variable virtio_blk references
  the function __devexit virtblk_remove()
  If the reference is valid then annotate the
  variable with __exit* (see linux/init.h) or name the variable:
  *driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,

Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
 drivers/block/virtio_blk.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 43db3ea..024f2d2 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -424,7 +424,12 @@ static unsigned int features[] = {
 	VIRTIO_BLK_F_SCSI, VIRTIO_BLK_F_IDENTIFY
 };
 
-static struct virtio_driver virtio_blk = {
+/*
+ * virtio_blk causes spurious section mismatch warning by
+ * simultaneously referring to a __devinit and a __devexit function.
+ * Use __refdata to avoid this warning.
+ */
+static struct virtio_driver __refdata virtio_blk = {
 	.feature_table = features,
 	.feature_table_size = ARRAY_SIZE(features),
 	.driver.name =	KBUILD_MODNAME,
-- 
1.6.0.2

