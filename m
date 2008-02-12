Return-Path: <linux-kernel-owner+w=401wt.eu-S1761529AbYBLJIQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761529AbYBLJIQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 04:08:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762276AbYBLJHz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 04:07:55 -0500
Received: from mtagate5.de.ibm.com ([195.212.29.154]:7467 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762216AbYBLJHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 04:07:50 -0500
Date: Tue, 12 Feb 2008 11:07:45 +0200
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: David Miller <davem@davemloft.net>
Cc: mgross@linux.intel.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH]intel-iommu batched iotlb flushes
Message-ID: <20080212090745.GH5750@rhun.haifa.ibm.com>
References: <20080211224105.GB24412@linux.intel.com> <20080212085256.GF5750@rhun.haifa.ibm.com> <20080212.010006.255202479.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080212.010006.255202479.davem@davemloft.net>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2008 at 01:00:06AM -0800, David Miller wrote:
> From: Muli Ben-Yehuda <muli@il.ibm.com>
> Date: Tue, 12 Feb 2008 10:52:56 +0200
> 
> > The streaming DMA-API was designed to conserve IOMMU mappings for
> > machines where IOMMU mappings are a scarce resource, and is a poor
> > fit for a modern IOMMU such as VT-d with a 64-bit IO address space
> > (or even an IOMMU with a 32-bit address space such as Calgary)
> > where there are plenty of IOMMU mappings available.
> 
> For the 64-bit case what you are suggesting eventually amounts to
> mapping all available RAM in the IOMMU.
> 
> Although an extreme version of your suggestion, it would be the most
> efficient as it would require zero IOMMU flush operations.
>
> But we'd lose things like protection and other benefits.

For the extreme case you are correct. There's an inherent trade-off
between IOMMU performance and protection guarantees, where one end of
the spectrum is represented by the streaming DMA-API and the other end
is represented by simply mapping all available memory. It's an open
question what is the right point in between. I think that an optimal
strategy might be "keep the mapping around for as long as it is safe",
i.e., keep a mapping to a frame for as long as the frame is owned by
whoever requested the mapping in the first place. Once ownership of
the frame is passed to another entity (e.g., from the driver to the
stack), revoke the original mapping. This implies a way for the kernel
to track frame ownership and communicate frame ownership changes to
the DMA-API layer, which we don't currently have.

Cheers,
Muli

