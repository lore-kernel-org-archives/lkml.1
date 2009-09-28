Return-Path: <linux-kernel-owner+w=401wt.eu-S1752028AbZI1EWx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752028AbZI1EWx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 00:22:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751846AbZI1EWw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 00:22:52 -0400
Received: from ozlabs.org ([203.10.76.45]:36853 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751299AbZI1EWu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 00:22:50 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] virtio_blk: revert QUEUE_FLAG_VIRT addition
Date: Mon, 28 Sep 2009 13:06:59 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-15-generic; KDE/4.2.2; i686; ; )
Cc: Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org,
       Jens Axboe <jens.axboe@oracle.com>
References: <200909232235.15076.rusty@rustcorp.com.au> <20090926150124.GA11623@lst.de> <200909281220.26266.rusty@rustcorp.com.au>
In-Reply-To: <200909281220.26266.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909281307.00383.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

It seems like the addition of QUEUE_FLAG_VIRT caueses major performance
regressions for Fedora users:

	https://bugzilla.redhat.com/show_bug.cgi?id=509383
	https://bugzilla.redhat.com/show_bug.cgi?id=505695

while I can't reproduce those extreme regressions myself I think the flag
is wrong.

Rationale:

  QUEUE_FLAG_VIRT expands to QUEUE_FLAG_NONROT which casus the queue
  unplugged immediately.  This is not a good behaviour for at least
  qemu and kvm where we do have significant overhead for every
  I/O operations.  Even with all the latested speeups (native AIO,
  MSI support, zero copy) we can only get native speed for up to 128kb
  I/O requests we already are down to 66% of native performance for 4kb
  requests even on my laptop running the Intel X25-M SSD for which the
  QUEUE_FLAG_NONROT was designed.
  If we ever get virtio-blk overhead low enough that this flag makes
  sense it should only be set based on a feature flag set by the host.
	
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 drivers/block/virtio_blk.c |    1 -
 1 file changed, 1 deletion(-)

Index: linux-2.6/drivers/block/virtio_blk.c
===================================================================
--- linux-2.6.orig/drivers/block/virtio_blk.c	2009-09-04 17:33:48.802523987 -0300
+++ linux-2.6/drivers/block/virtio_blk.c	2009-09-04 17:33:56.186522158 -0300
@@ -314,7 +314,6 @@ static int __devinit virtblk_probe(struc
 	}
 
 	vblk->disk->queue->queuedata = vblk;
-	queue_flag_set_unlocked(QUEUE_FLAG_VIRT, vblk->disk->queue);
 
 	if (index < 26) {
 		sprintf(vblk->disk->disk_name, "vd%c", 'a' + index % 26);
