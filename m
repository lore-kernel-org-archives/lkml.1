Return-Path: <linux-kernel-owner+w=401wt.eu-S1758939AbXKLNz6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758939AbXKLNz6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 08:55:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758476AbXKLNzt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 08:55:49 -0500
Received: from mis011-2.exch011.intermedia.net ([64.78.21.129]:59963 "EHLO
	mis011-2.exch011.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758397AbXKLNzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 08:55:49 -0500
From: Amit Shah <amit.shah@qumranet.com>
Organization: Qumranet Technologies
To: Muli Ben-Yehuda <muli@il.ibm.com>
Subject: Re: [kvm-devel] [PATCH 3/8] KVM: PVDMA Guest: Guest-side routines for paravirtualized DMA
Date: Mon, 12 Nov 2007 19:25:27 +0530
User-Agent: KMail/1.9.6
Cc: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <d1c72ce6e3a0e73c18993c3f066d1350b147f726.1194445109.git.amit.shah@qumranet.com> <200711121726.24907.amit.shah@qumranet.com> <20071112133207.GJ3299@rhun.haifa.ibm.com>
In-Reply-To: <20071112133207.GJ3299@rhun.haifa.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711121925.27844.amit.shah@qumranet.com>
X-OriginalArrivalTime: 12 Nov 2007 13:55:48.0378 (UTC) FILETIME=[BA9277A0:01C82533]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 November 2007 19:02:07 Muli Ben-Yehuda wrote:
> On Mon, Nov 12, 2007 at 05:26:24PM +0530, Amit Shah wrote:
> > On Monday 12 November 2007 16:20:01 Muli Ben-Yehuda wrote:
> > > On Wed, Nov 07, 2007 at 04:21:04PM +0200, Amit Shah wrote:
> > > > We make the dma_mapping_ops structure to point to our structure so
> > > > that every DMA access goes through us. (This is the reason this only
> > > > works for 64-bit guest. 32-bit guest doesn't yet have a dma_ops
> > > > struct.)
> > >
> > > I need the same facility for Calgary for falling back to swiotlb if a
> > > translation is disabled on some slot, and IB needs the same facility
> > > for some IB adapters (e.g., ipath). Perhaps it's time to consider
> > > stackable dma-ops (unless someone has a better idea...).
> >
> > That would make great sense and simplify implementations.
> >
> > How do you propose such an implementation? An array of function
> > pointers for each possible call?
>
> I was thinking of simply a chain of dma_ops (via dma_ops->prev_ops) ,
> where it's the responsibility of each dma_ops implementation to call
> or not call the corresponding entry in chain (prev_ops->op()). This
> works well for Calgary (which will only use prev_ops selectively, and
> I think it will work well for the IB folks. Will it work for you?

Selectively? What happens in the case when some iommu doesn't want to invoke 
the prev_op, but the mapping depends on it being called (eg, the hypercalling 
op is embedded somewhere in the prev_op chain)

Hmm, also, a hypercall should be the last operation to be called in a few 
cases, but also the first (and the last) to be called in several other cases. 
For example, in a guest, you can go register any number of iotlbs, but you 
don't actually want to do anything there -- you just want to do a hypercall 
and get the mapping from the host.

But in any case, what ensures that the hypercall op always gets called and 
also that it's the last one?

Also, I'm thinking of implementations where let's say sg_map_free is not 
defined for a particular iotlb, but it was defined in the previously 
registered one. How to handle this?

It seems a small dispatcher which takes care of this seems the likely choice 
here, but avoiding it (or at least caching the decisions) is something that 
needs more thought.
