Return-Path: <linux-kernel-owner+w=401wt.eu-S1755425AbZAISLk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425AbZAISLk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 13:11:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753945AbZAISLR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 13:11:17 -0500
Received: from 8bytes.org ([88.198.83.132]:49198 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754013AbZAISLQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 13:11:16 -0500
Date: Fri, 9 Jan 2009 19:11:14 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Joerg Roedel <joerg.roedel@amd.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       mingo@redhat.com
Subject: Re: [PATCH 10/16] dma-debug: add add checking for map/unmap_sg
Message-ID: <20090109181114.GA9466@8bytes.org>
References: <1231517970-20288-1-git-send-email-joerg.roedel@amd.com> <1231517970-20288-11-git-send-email-joerg.roedel@amd.com> <20090109180836.GD30168@ioremap.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090109180836.GD30168@ioremap.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 09, 2009 at 09:08:36PM +0300, Evgeniy Polyakov wrote:
> On Fri, Jan 09, 2009 at 05:19:24PM +0100, Joerg Roedel (joerg.roedel@amd.com) wrote:
> > +void debug_map_sg(struct device *dev, struct scatterlist *sg,
> > +		  int nents, int direction)
> > +{
> > +	struct dma_debug_entry *entry;
> > +	struct scatterlist *s;
> > +	int i;
> > +
> > +	if (global_disable)
> > +		return;
> > +
> > +	for_each_sg(sg, s, nents, i) {
> > +		entry = dma_entry_alloc();
> > +		if (!entry)
> > +			return;
> > +
> > +		entry->type      = dma_debug_sg;
> > +		entry->dev       = dev;
> > +		entry->cpu_addr  = sg_virt(s);
> > +		entry->size      = s->length;
> > +		entry->dev_addr  = s->dma_address;
> > +		entry->direction = direction;
> > +
> > +		add_dma_entry(entry);
> > +	}
> > +}
> > +EXPORT_SYMBOL(debug_map_sg);
> > +
> > +void debug_unmap_sg(struct device *dev, struct scatterlist *sglist,
> > +		    int nelems, int dir)
> > +{
> > +	struct scatterlist *s;
> > +	int i;
> > +
> > +	if (global_disable)
> > +		return;
> > +
> > +	for_each_sg(sglist, s, nelems, i) {
> > +
> > +		struct dma_debug_entry ref = {
> > +			.type           = dma_debug_sg,
> > +			.dev            = dev,
> > +			.cpu_addr       = sg_virt(s),
> > +			.dev_addr       = s->dma_address,
> > +			.size           = s->length,
> > +			.direction      = dir,
> > +		};
> > +
> > +		check_unmap(&ref);
> 
> Will this print false errors if above map debug failed to add an entry
> into the list?

No. The code disables itself if adding an entry fails. This can only
happen when we run out of preallocated dma_debug_entries.

Joerg
