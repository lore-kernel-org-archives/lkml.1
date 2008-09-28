Return-Path: <linux-kernel-owner+w=401wt.eu-S1753055AbYI1Soj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753055AbYI1Soj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2008 14:44:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752066AbYI1So3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Sep 2008 14:44:29 -0400
Received: from 8bytes.org ([88.198.83.132]:38628 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751477AbYI1So2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2008 14:44:28 -0400
Date: Sun, 28 Sep 2008 20:44:24 +0200
From: Joerg Roedel <joro@8bytes.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: joerg.roedel@amd.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       iommu@lists.linux-foundation.org, dwmw2@infradead.org, muli@il.ibm.com,
       amit.shah@qumranet.com, mingo@redhat.com
Subject: Re: [PATCH 9/9] x86/iommu: use dma_ops_list in get_dma_ops
Message-ID: <20080928184424.GA26563@8bytes.org>
References: <1222107681-8185-1-git-send-email-joerg.roedel@amd.com> <1222107681-8185-10-git-send-email-joerg.roedel@amd.com> <20080928231211X.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080928231211X.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 28, 2008 at 11:21:23PM +0900, FUJITA Tomonori wrote:
> > +struct dma_mapping_ops *find_dma_ops_for_device(struct device *dev)
> > +{
> > +	int i;
> > +	unsigned long flags;
> > +	struct dma_mapping_ops *entry, *ops = NULL;
> > +
> > +	read_lock_irqsave(&dma_ops_list_lock, flags);
> > +
> > +	for (i = 0; i < DMA_OPS_TYPE_MAX; ++i)
> > +		list_for_each_entry(entry, &dma_ops_list[i], list) {
> > +			if (!entry->device_supported)
> > +				continue;
> > +			if (entry->device_supported(dev)) {
> > +				ops = entry;
> > +				goto out;
> > +			}
> > +		}
> > +out:
> > +	read_unlock_irqrestore(&dma_ops_list_lock, flags);
> 
> Hmm, every time we call dma_sg/map_single, we call
> read_lock_irqsave(&dma_ops_list_lock, flags). It's likely that we see
> notable performance drop?

Hmm, we should only call find_dma_ops_for_device() the first time a
dma api call is done (look into get_dma_ops). But I also thought about
how this lock can be avoided. In the real world it should not be
necessary because the dma_ops list is initialized before dma api calls
are done. But since there is now a register function which can be called
its safer this way. What do you think, are we still safe enough without
this lock?

Joerg

