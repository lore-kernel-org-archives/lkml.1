Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754335Ab0BVUth (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 15:49:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53611 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753342Ab0BVUtf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 15:49:35 -0500
Date: Mon, 22 Feb 2010 15:49:20 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org
Subject: [RFC PATCH] block: warn if blk_stack_limits() undermines atomicity
Message-ID: <20100222204920.GA24514@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linux Device Mapper (DM) and Software Raid (MD) device drivers can be
used to arbitrarily combine devices with different "I/O Limits".  The
kernel's block layer goes to great lengths to reasonably combine the
"I/O Limits" of the individual devices.  The kernel will not prevent
combining heterogenuous devices but the user should be aware of the risk
associated with doing so.

For instance, a 512 byte device and a 4K device may be combined into a
single logical DM device; the resulting DM device would have a
logical_block_size of 4K.  Filesystems layered on such a hybrid device
assume that 4K will be written atomically but in reality that 4K will be
split into 8 512 byte IOs when issued to the 512 byte device.  Using a
4K logical_block_size for the higher-level DM device increases potential
for a partial write to the 512b device if there is a system crash.

If combining multiple devices' "I/O Limits" results in a conflict the
block layer will report a warning that the device is more susceptible to
partial writes and misaligned. [NOTE: setting "misaligned" for this
warning is somewhat awkward but blk_stack_limits() return of -1 can be
viewed as there was an "alignment inconsistency".  Would it be better to
return -1 but avoid setting t->misaligned?]

Signed-off-by: Mike Snitzer <snitzer@redhat.com>

diff --git a/block/blk-settings.c b/block/blk-settings.c
index 5eeb9e0..33bebe7 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -566,8 +566,16 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
 		}
 	}
 
+	top = t->logical_block_size;
 	t->logical_block_size = max(t->logical_block_size,
 				    b->logical_block_size);
+	if (top && top < t->logical_block_size) {
+		printk(KERN_NOTICE "Warning: changing logical_block_size of top device "
+		       "(from %u to %u) increases potential for partial writes\n",
+		       top, t->logical_block_size);
+		t->misaligned = 1;
+		ret = -1;
+	}
 
 	t->physical_block_size = max(t->physical_block_size,
 				     b->physical_block_size);
