Return-Path: <linux-kernel-owner+w=401wt.eu-S1754004AbYKTFlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754004AbYKTFlU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 00:41:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753089AbYKTFlI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 00:41:08 -0500
Received: from sh.osrg.net ([192.16.179.4]:60822 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752110AbYKTFlG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 00:41:06 -0500
Date: Thu, 20 Nov 2008 14:40:32 +0900
To: jens.axboe@oracle.com
Cc: stern@rowland.harvard.edu, bigeasy@linutronix.de,
       Thomas.Hommel@gefanuc.com, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, James.Bottomley@HansenPartnership.com
Subject: Re: ISP1760 driver crashes
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20081119172125.GS26308@kernel.dk>
References: <20081119153923.GR26308@kernel.dk>
	<Pine.LNX.4.44L0.0811191131320.2418-100000@iolanthe.rowland.org>
	<20081119172125.GS26308@kernel.dk>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20081120144125P.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Nov 2008 18:21:25 +0100
Jens Axboe <jens.axboe@oracle.com> wrote:

> On Wed, Nov 19 2008, Alan Stern wrote:
> > On Wed, 19 Nov 2008, Jens Axboe wrote:
> > 
> > > > --- usb-2.6.orig/drivers/scsi/scsi_lib.c
> > > > +++ usb-2.6/drivers/scsi/scsi_lib.c
> > > > @@ -1684,7 +1684,7 @@ static void scsi_request_fn(struct reque
> > > >  u64 scsi_calculate_bounce_limit(struct Scsi_Host *shost)
> > > >  {
> > > >  	struct device *host_dev;
> > > > -	u64 bounce_limit = 0xffffffff;
> > > > +	u64 bounce_limit = BLK_BOUNCE_HIGH;
> > > >  
> > > >  	if (shost->unchecked_isa_dma)
> > > >  		return BLK_BOUNCE_ISA;
> > > > 
> > > 
> > > The best solution is probably to either provide a "doesn't do highmem"
> > > in the scsi host template, or provide an appropriate DMA mask for the
> > > pci device to indicate it through that setting instead.
> > 
> > The DMA mask is currently set to NULL.  Is that not appropriate for a 
> > device that can't do DMA?  If not, then what would be appropriate?
> 
> It's changing behaviour. There's no current rule that says if you don't
> have a dma mask set, we only do PIO (even if such a rule DOES make
> sense). Additionally, you don't HAVE to bounce for PIO. As I wrote
> earlier, it's perfectly feasible to use bio kmap'ings to do the
> transfer.
> 
> > Also, is the patch above not correct?
> 
> It'll certainly work in the sense that if you don't have a dma_mask set,
> you only get lowmem pages. Whether the new behaviour is something we
> want, not sure. Check with James what he thinks, it's his domain.

We have been used 4GB for long time if dma_mask is zero (I guess we
use 4GB as kinda the default dma address limit at several places). The
majority of drivers (such as pci) sets properly dev->dma_mask so the
patch might not change anything but suddenly changing the
long-standing rule in an odd way (use BLK_BOUNCE_HIGH if dma_mask is
zero) doesn't sound a good idea to me.

Why not calling blk_queue_bounce_limit() in the slave_configure hook?
I think that it's the common way for SCSI LLDs with odd bounce limit.
