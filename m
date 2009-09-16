Return-Path: <linux-kernel-owner+w=401wt.eu-S1760296AbZIPWgf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760296AbZIPWgf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 18:36:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758133AbZIPWg1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 18:36:27 -0400
Received: from kroah.org ([198.145.64.141]:40987 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760120AbZIPWcq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 18:32:46 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Sep 16 15:29:04 2009
Message-Id: <20090916222904.399551476@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Sep 2009 15:28:40 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Christoph Hellwig <hch@lst.de>, Rusty Russell <rusty@rustcorp.com.au>,
       Chuck Ebbert <cebbert@redhat.com>
Subject: [patch 21/24] virtio_blk: dont bounce highmem requests
References: <20090916222819.244332644@mini.kroah.org>
Content-Disposition: inline; filename=virtio_blk-don-t-bounce-highmem-requests.patch
In-Reply-To: <20090916222934.GA31846@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Christoph Hellwig <hch@lst.de>

commit 4eff3cae9c9809720c636e64bc72f212258e0bd5 upstream

virtio_blk: don't bounce highmem requests

By default a block driver bounces highmem requests, but virtio-blk is
perfectly fine with any request that fit into it's 64 bit addressing scheme,
mapped in the kernel virtual space or not.

Besides improving performance on highmem systems this also makes the
reproducible oops in __bounce_end_io go away (but hiding the real cause).

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---

---
 drivers/block/virtio_blk.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -308,6 +308,9 @@ static int virtblk_probe(struct virtio_d
 	else
 		blk_queue_max_segment_size(vblk->disk->queue, -1U);
 
+	/* No need to bounce any requests */
+	blk_queue_bounce_limit(vblk->disk->queue, BLK_BOUNCE_ANY);
+
 	/* Host can optionally specify the block size of the device */
 	err = virtio_config_val(vdev, VIRTIO_BLK_F_BLK_SIZE,
 				offsetof(struct virtio_blk_config, blk_size),


