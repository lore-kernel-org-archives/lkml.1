Return-Path: <linux-kernel-owner+w=401wt.eu-S1753939AbZA0X6h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753939AbZA0X6h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 18:58:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751961AbZA0X6H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 18:58:07 -0500
Received: from sh.osrg.net ([192.16.179.4]:47295 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751839AbZA0X6F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 18:58:05 -0500
Date: Wed, 28 Jan 2009 08:57:43 +0900
To: stefanr@s5r6.in-berlin.de
Cc: fujita.tomonori@lab.ntt.co.jp, linux1394-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: swiotlb default size (64 MB) too small?
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <497F9CC5.8080807@s5r6.in-berlin.de>
References: <tkrat.9e61b4a2f7087aca@s5r6.in-berlin.de>
	<20090128083135Y.fujita.tomonori@lab.ntt.co.jp>
	<497F9CC5.8080807@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090128085825W.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Jan 2009 00:46:13 +0100
Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:

> FUJITA Tomonori wrote:
> > On Tue, 27 Jan 2009 18:03:40 +0100 (CET)
> > Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
> >> +static void sbp2_unmap_scatterlist(struct device *card_device,
> >> +				   struct sbp2_command_orb *orb)
> >> +{
> >> +	if (scsi_sg_count(orb->cmd))
> >> +		dma_unmap_sg(card_device, scsi_sglist(orb->cmd),
> >> +			     scsi_sg_count(orb->cmd),
> >> +			     orb->cmd->sc_data_direction);
> >> +
> >> +	if (orb->page_table_bus)
> >> +		dma_unmap_single(card_device, orb->page_table_bus,
> >> +				 sizeof(orb->page_table), DMA_TO_DEVICE);
> > 
> > Well, this does not look correct since zero can be a valid dma
> > address.
> 
> Hmm.
> 
> > static void sbp2_unmap_scatterlist(struct device *card_device,
> > 				   struct sbp2_command_orb *orb)
> > {
> > 	if (scsi_sg_count(orb->cmd))
> > 		dma_unmap_sg(card_device, scsi_sglist(orb->cmd),
> > 			     scsi_sg_count(orb->cmd),
> > 			     orb->cmd->sc_data_direction);
> > 
> > 	if (scsi_sg_count(orb->cmd) > 1)
> > 		dma_unmap_single(card_device, orb->page_table_bus,
> > 				 sizeof(orb->page_table), DMA_TO_DEVICE);
> > 
> > 
> > Well, looks cranky a bit but firewire is cranky for me :)
> 
> Even if scsi_sg_count(cmd) > 1, the outcome of dma_map_sg() could have
> been 1, couldn't it?  So I need to take note of that in another way.

Oops, right. Probably, you need to store the return value of
dma_map_sg in orb.
