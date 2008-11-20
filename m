Return-Path: <linux-kernel-owner+w=401wt.eu-S1754209AbYKTHfI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209AbYKTHfI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 02:35:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753033AbYKTHey
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 02:34:54 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:56409 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753275AbYKTHex (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 02:34:53 -0500
Date: Thu, 20 Nov 2008 08:33:01 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: stern@rowland.harvard.edu, bigeasy@linutronix.de,
       Thomas.Hommel@gefanuc.com, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, James.Bottomley@HansenPartnership.com
Subject: Re: ISP1760 driver crashes
Message-ID: <20081120073301.GY26308@kernel.dk>
References: <20081119153923.GR26308@kernel.dk> <Pine.LNX.4.44L0.0811191131320.2418-100000@iolanthe.rowland.org> <20081119172125.GS26308@kernel.dk> <20081120144125P.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081120144125P.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20 2008, FUJITA Tomonori wrote:
> On Wed, 19 Nov 2008 18:21:25 +0100
> Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > On Wed, Nov 19 2008, Alan Stern wrote:
> > > On Wed, 19 Nov 2008, Jens Axboe wrote:
> > > 
> > > > > --- usb-2.6.orig/drivers/scsi/scsi_lib.c
> > > > > +++ usb-2.6/drivers/scsi/scsi_lib.c
> > > > > @@ -1684,7 +1684,7 @@ static void scsi_request_fn(struct reque
> > > > >  u64 scsi_calculate_bounce_limit(struct Scsi_Host *shost)
> > > > >  {
> > > > >  	struct device *host_dev;
> > > > > -	u64 bounce_limit = 0xffffffff;
> > > > > +	u64 bounce_limit = BLK_BOUNCE_HIGH;
> > > > >  
> > > > >  	if (shost->unchecked_isa_dma)
> > > > >  		return BLK_BOUNCE_ISA;
> > > > > 
> > > > 
> > > > The best solution is probably to either provide a "doesn't do highmem"
> > > > in the scsi host template, or provide an appropriate DMA mask for the
> > > > pci device to indicate it through that setting instead.
> > > 
> > > The DMA mask is currently set to NULL.  Is that not appropriate for a 
> > > device that can't do DMA?  If not, then what would be appropriate?
> > 
> > It's changing behaviour. There's no current rule that says if you don't
> > have a dma mask set, we only do PIO (even if such a rule DOES make
> > sense). Additionally, you don't HAVE to bounce for PIO. As I wrote
> > earlier, it's perfectly feasible to use bio kmap'ings to do the
> > transfer.
> > 
> > > Also, is the patch above not correct?
> > 
> > It'll certainly work in the sense that if you don't have a dma_mask set,
> > you only get lowmem pages. Whether the new behaviour is something we
> > want, not sure. Check with James what he thinks, it's his domain.
> 
> We have been used 4GB for long time if dma_mask is zero (I guess we
> use 4GB as kinda the default dma address limit at several places). The
> majority of drivers (such as pci) sets properly dev->dma_mask so the
> patch might not change anything but suddenly changing the
> long-standing rule in an odd way (use BLK_BOUNCE_HIGH if dma_mask is
> zero) doesn't sound a good idea to me.
> 
> Why not calling blk_queue_bounce_limit() in the slave_configure hook?
> I think that it's the common way for SCSI LLDs with odd bounce limit.

Yep, that should indeed work just fine and is preferable to changing
this logic.

-- 
Jens Axboe

