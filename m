Return-Path: <linux-kernel-owner+w=401wt.eu-S934266AbZIDUpA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934266AbZIDUpA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 16:45:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934082AbZIDUo7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 16:44:59 -0400
Received: from verein.lst.de ([213.95.11.210]:53730 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933957AbZIDUo6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 16:44:58 -0400
Date: Fri, 4 Sep 2009 22:44:42 +0200
From: Christoph Hellwig <hch@lst.de>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Mark McLoughlin <markmc@redhat.com>
Subject: [PATCH for-2.6.31] virtio_blk: revert QUEUE_FLAG_VIRT addition
Message-ID: <20090904204442.GA30941@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
