Return-Path: <linux-kernel-owner+w=401wt.eu-S1758096AbZLIWHu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758096AbZLIWHu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 17:07:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757193AbZLIWHo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 17:07:44 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:45353 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753815AbZLIWHo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 17:07:44 -0500
Date: Wed, 9 Dec 2009 23:07:49 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Heinz Diehl <htd@fancy-poultry.org>
Cc: linux-kernel@vger.kernel.org, martin.petersen@oracle.com
Subject: Re: todays git regression (2.6.32-04008.g3ff6a46): lot of device
	mapper warnings
Message-ID: <20091209220749.GD8742@kernel.dk>
References: <200912091049.12604.borntraeger@de.ibm.com> <20091209212516.GA6206@fancy-poultry.org> <20091209214501.GC8742@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091209214501.GC8742@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 09 2009, Jens Axboe wrote:
> On Wed, Dec 09 2009, Heinz Diehl wrote:
> > On 09.12.2009, Christian Borntraeger wrote: 
> > 
> > > with todays git I got a huge amount of warnings for device mapper:
> > > device-mapper: uevent: version 1.0.3                                                                              
> > > device-mapper: ioctl: 4.15.0-ioctl (2009-04-01) initialised: dm-devel@redhat.com                                  
> > > device-mapper: table: 252:0: target device dasdf1 is misaligned: physical_block_size=4096, logical_block_size=4096, alignment_offset=0, start=196608                                                                                
> > [...]
> >  
> > > The same devices produce no warning with a 2.6.32 vanilla kernel.
> > 
> > I have exactly the same here...
> 
> Can either one of you try and bisect it? I've cc'ed Martin, it's likely
> one of the io stacking patches that causes this.

Does this work?

diff --git a/block/blk-settings.c b/block/blk-settings.c
index dd1f1e0..0116d29 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -554,11 +554,13 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
 		ret = -1;
 	}
 
+#if 0
 	if (offset &&
 	    (offset & (b->discard_granularity - 1)) != b->discard_alignment) {
 		t->discard_misaligned = 1;
 		ret = -1;
 	}
+#endif
 
 	/* If top has no alignment offset, inherit from bottom */
 	if (!t->alignment_offset)

-- 
Jens Axboe

