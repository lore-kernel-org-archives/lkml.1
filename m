Return-Path: <linux-kernel-owner+w=401wt.eu-S1760150AbYGQN45@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760150AbYGQN45 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 09:56:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756516AbYGQN4r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 09:56:47 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:45096 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756323AbYGQN4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 09:56:44 -0400
Subject: Re: [PATCH] block: fix q->max_segment_size checking in
	blk_recalc_rq_segments about VMERGE
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, mpatocka@redhat.com,
       jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, davem@davemloft.net,
       linux-parisc@vger.kernel.org
In-Reply-To: <487F48B7.3010807@panasas.com>
References: <Pine.LNX.4.64.0807161359001.30207@devserv.devel.redhat.com>
	 <20080717131444K.fujita.tomonori@lab.ntt.co.jp>
	 <Pine.LNX.4.64.0807170746001.31185@devserv.devel.redhat.com>
	 <20080717221908D.fujita.tomonori@lab.ntt.co.jp>
	 <487F48B7.3010807@panasas.com>
Content-Type: text/plain
Date: Thu, 17 Jul 2008 08:56:39 -0500
Message-Id: <1216302999.5515.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-07-17 at 16:27 +0300, Boaz Harrosh wrote:
> FUJITA Tomonori wrote:
> > On Thu, 17 Jul 2008 07:50:24 -0400 (EDT)
> > Mikulas Patocka <mpatocka@redhat.com> wrote:
> > 
> >>>>> Please give me an example how the boundary restriction of a device can
> >>>>> break the VMERGE accounting and an IOMMU if you aren't still sure.
> >>>> You have dma_get_seg_boundary and dma_get_max_seg_size. On sparc64, adding 
> >>>> one of these broken VMERGE accounting (the VMERGE didn't happen past 64-kb 
> >>>> boundary and bio layer thought that VMERGE would be possible).
> >>> If the device has 64KB boundary restriction, the device also has
> >>> max_seg_size restriction of 64KB or under. So the vmerge acounting
> >>> works (though we need to fix it to handle max_seg_size, as discussed).
> >>>
> >>>> And if you fix this case, someone will break it again, sooner or later, by 
> >>>> adding new restriction.
> >>> All restrictions that IOMMUs need to know are dma_get_seg_boundary and
> >>> dma_get_max_seg_size.
> >>>
> >>> What is your new restriction?
> >> We don't know what happens in the future.
> > 
> > It's very unlikely to add new restrictions.
> > 
> > 
> >> And that is the problem that we 
> >> don't know --- but we have two pieces of code (blk-merge and iommu) that 
> >> try to calculate the same number (number of hw segments) and if they get 
> >> different result, it will crash. If the calculations were done at one 
> >> place, there would be no problem with that.
> > 
> > I don't think that your argument, 'the problem that we don't know', is
> > true.
> > 
> > With the vmerge accounting, we calculate at two places. So if we add
> > a new restriction, we need to handle it at two places. It's a logical
> > result.
> > 
> > Of course, it's easier to calculate at one place rather than two
> > places. But 'we don't know what restriction we will need' isn't a
> > problem.
> > 
> > 
> > BTW, as I've already said, I'm not against removing the vmerge
> > accounting from the block layer.
> 
> I have a question. Does the block layer know of the IOMMU in use
> for the device? can it call into the IOMMU to calculate the
> restriction?

Yes and no.  The parameter PCI_DMA_BUS_IS_PHYS is set if the platform
doesn't have one.  Nowadays, that's not enough; with VT and bypass what
the system really needs to know is if the device will be using the
iommu.

The idea of calling into the platform iommu code was considered when all
this was done, but it was rejected.  Function pointer calls are
incredibly expensive on most platforms that at that time had iommus.
The best way was to construct a theoretical parametrisation of an iommu
and get the block layer to follow that model.

James


