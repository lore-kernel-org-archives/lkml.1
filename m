Return-Path: <linux-kernel-owner+w=401wt.eu-S936031AbXJPUaQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936031AbXJPUaQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 16:30:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760111AbXJPU35
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 16:29:57 -0400
Received: from brick.kernel.dk ([87.55.233.238]:29634 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764269AbXJPU34 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 16:29:56 -0400
Date: Tue, 16 Oct 2007 22:29:50 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: remove blk_queue_max_phys_segments in libata
Message-ID: <20071016202950.GG9942@kernel.dk>
References: <200710161809.l9GI9YTS008023@hera.kernel.org> <47151BF3.4080208@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47151BF3.4080208@garzik.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16 2007, Jeff Garzik wrote:
> Linux Kernel Mailing List wrote:
> >Gitweb:     
> >http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=8889e3c129780cdbe15fed3c366ba3aa3026684d
> >Commit:     8889e3c129780cdbe15fed3c366ba3aa3026684d
> >Parent:     fd820f405574a30aacf9a859886e173d641f080b
> >Author:     FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> >AuthorDate: Tue Sep 18 12:16:45 2007 +0200
> >Committer:  Jens Axboe <jens.axboe@oracle.com>
> >CommitDate: Tue Oct 16 11:24:44 2007 +0200
> >
> >    remove blk_queue_max_phys_segments in libata
> >    
> >    LIBATA_MAX_PRD is the maximum number of DMA scatter/gather elements
> >    permitted by the HBA's DMA engine. It's properly set to
> >    q->max_hw_segments via the sg_tablesize parameter.
> >    
> >    libata shouldn't call blk_queue_max_phys_segments. Now LIBATA_MAX_PRD
> >    is equal to SCSI_MAX_PHYS_SEGMENTS by default (both is 128), so
> >    everything is fine. But if they are changed, some code (like the scsi
> >    mid layer, sg chaining, etc) might not work properly.
> >    
> >    (Addition from Jens) The basic issue is that the physical segment
> >    setting is purely a driver issue. And since SCSI is managing the 
> >    sglist,
> >    libata has no business changing the setting. All libata should care
> >    about is the hw segment setting.
> >    
> >    Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> >    Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
> >---
> > drivers/ata/libata-scsi.c |    2 --
> > 1 files changed, 0 insertions(+), 2 deletions(-)
> >
> >diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> >index d63c81e..ba62d53 100644
> >--- a/drivers/ata/libata-scsi.c
> >+++ b/drivers/ata/libata-scsi.c
> >@@ -801,8 +801,6 @@ int ata_scsi_slave_config(struct scsi_device *sdev)
> > 
> > 	ata_scsi_sdev_config(sdev);
> > 
> >-	blk_queue_max_phys_segments(sdev->request_queue, LIBATA_MAX_PRD);
> >-
> > 	sdev->manage_start_stop = 1;
> 
> As I noted when this first patch was posted...   this line of code 
> existed because the difference between hw-segments and phys-segments was 
> incredibly difficult to discern.  The names say basically the same thing 
> to me, and I could find no documentation explaining the difference?

We discussed this change to death afair, so I'm a little surprised you
say that. The commit message itself has good reasoning as well.

> Does such documentation exist?  If not, can you please explain the 
> difference?

OK, I can give a brief summary. The driver can set two restrictions -
hardware and physical. I'm not sure who originally came up with the
naming (I think it's prety terrible), but essentially the 'hardware'
restriction is what the hardware can support (OK that name works) and
the 'physical' restriction is imposed by the driver. Typically that last
restriction has to do with structure limitations, like allocating stuff
on the stack or limiting the size of the sgtable you have to allocate.

> Finally, some notification and coordination would have been helpful. 

Confused, as I mentioned, we discussed this at quite some length a few
months ago.

> Commit 6c08772e49622e90d39903e7ff0be1a0f463ac86 appears to have been 
> missed, at the very least... or is it actually correct?

Depends on what you think it does. The number of hardware segments will
never be larger than the physical segments. But it looks like you want
to set the hw seg value there. As mentioned in the commit above, since
libata doesn't allocate its own sg tables, letting it fiddle with the
physical segment limit is dodgy at best.

-- 
Jens Axboe

