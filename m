Return-Path: <linux-kernel-owner+w=401wt.eu-S1759047AbXKLOCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759047AbXKLOCS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 09:02:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758460AbXKLOCG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 09:02:06 -0500
Received: from mtagate6.de.ibm.com ([195.212.29.155]:39167 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758301AbXKLOCC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 09:02:02 -0500
Date: Mon, 12 Nov 2007 16:01:55 +0200
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: Amit Shah <amit.shah@qumranet.com>
Cc: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] [PATCH 3/8] KVM: PVDMA Guest: Guest-side routines for paravirtualized DMA
Message-ID: <20071112140155.GL3299@rhun.haifa.ibm.com>
References: <d1c72ce6e3a0e73c18993c3f066d1350b147f726.1194445109.git.amit.shah@qumranet.com> <200711121726.24907.amit.shah@qumranet.com> <20071112133207.GJ3299@rhun.haifa.ibm.com> <200711121925.27844.amit.shah@qumranet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200711121925.27844.amit.shah@qumranet.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 12, 2007 at 07:25:27PM +0530, Amit Shah wrote:

> Selectively? What happens in the case when some iommu doesn't want
> to invoke the prev_op, but the mapping depends on it being called
> (eg, the hypercalling op is embedded somewhere in the prev_op chain)

Bad things :-)
There needs to be a hierarchy of dma-ops, e.g., nommu/swiotlb, then a
hardware iommu, then pvdma. Not sure where IB fits in here. The
calling order would be the reverse of the initialization order, so
pvdma->hardare->nommu/swiotlb.

> Hmm, also, a hypercall should be the last operation to be called in
> a few cases, but also the first (and the last) to be called in
> several other cases. For example, in a guest, you can go register
> any number of iotlbs, but you don't actually want to do anything
> there -- you just want to do a hypercall and get the mapping from
> the host.
> 
> But in any case, what ensures that the hypercall op always gets
> called and also that it's the last one?

If it gets called first it can ensure that it runs either first or
last, or both, since it controls when to run the other hooks, before
or after it does what it needs to do.
 
> Also, I'm thinking of implementations where let's say sg_map_free is
> not defined for a particular iotlb, but it was defined in the
> previously registered one. How to handle this?

Good point, this will require all dma ops implementation to provide
stubs that just return prev_ops->op if it's set.

> It seems a small dispatcher which takes care of this seems the
> likely choice here, but avoiding it (or at least caching the
> decisions) is something that needs more thought.

Yeah, I'm not too enthusiastic about it, but we do need such a generic
mechanism or we will each end up implementing our own versions of
it...

Cheers,
Muli
