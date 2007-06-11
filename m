Return-Path: <linux-kernel-owner+w=401wt.eu-S1754875AbXFKUsp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754875AbXFKUsp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 16:48:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751467AbXFKUsh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 16:48:37 -0400
Received: from mga01.intel.com ([192.55.52.88]:65014 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751251AbXFKUsg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 16:48:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,409,1175497200"; 
   d="scan'208";a="255670225"
Date: Mon, 11 Jun 2007 13:44:42 -0700
From: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
To: Andi Kleen <ak@suse.de>
Cc: Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>,
       linux-kernel@vger.kernel.org, gregkh@suse.de, muli@il.ibm.com,
       asit.k.mallick@intel.com, suresh.b.siddha@intel.com,
       arjan@linux.intel.com, ashok.raj@intel.com, shaohua.li@intel.com,
       davem@davemloft.net
Subject: Re: [Intel-IOMMU 02/10] Library routine for pre-allocat pool handling
Message-ID: <20070611204442.GA4074@linux-os.sc.intel.com>
Reply-To: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
References: <20070606185658.138237000@askeshav-devel.jf.intel.com> <200706090056.49279.ak@suse.de> <Pine.LNX.4.64.0706081558090.4373@schroedinger.engr.sgi.com> <200706091147.24705.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706091147.24705.ak@suse.de>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 09, 2007 at 11:47:23AM +0200, Andi Kleen wrote:
> 
> > > Now there is a anon dirty limit since a few releases, but I'm not
> > > fully convinced it solves the problem completely.
> > 
> > A gut feeling or is there more?
> 
> Lots of other subsystem can allocate a lot of memory
> and they usually don't cooperate and have similar dirty limit concepts.
> So you could run out of usable memory anyways and then have a similar
> issue.
> 
> For example a flood of network packets could always steal your
> GFP_ATOMIC pools very quickly in the background (gigabit or 10gig 
> can transfer a lot of data very quickly) > 
> Also iirc try_to_free_pages() is not completely fair and might fail
> under extreme load for some requesters.
> 
> Not requiring memory allocation for any IO would be certainly safer.
> 
> Anyways, it's a theoretic question because you can't sleep in 
> there anyways unless something drastic changes in the driver interfaces.

Agree, that the ideal thing would be to make such changes in the driver
interfaces where in dma_map_{singe|sg} API's are not called in the
interrupt context and/or spinlock held, there by IOMMU drivers are 
free to  block when memory is not available. This seems to be a  
noble goal invloving huge changes and testing beyond the scope of the 
current IOMMU driver. I guess it would be ideal if this gets discussed
and resolved at kernel summit. 

Assuming that we may have to live with the above limitations for a
while, what is the best way to allocate memory in the
dma_map_{single|sg} API's for the IOMMU drivers? (these memory
are required to setup internal IOMMU pagetables etc.)

In the first implementation of ours, we had used mempools api's to 
allocate memory and we were told that mempools with GFP_ATOMIC is
useless and hence in the second implementation we came up with
resource pools ( which is preallocate pools) and again as I understand
the argument is why create another when we have slab allocation which
is similar to this resource pools.

Hence, can I assume that the conclusion of this 
discussion is to use kmem_cache_alloc() functions 
to allocate memory in dma_map_{single|sg} API's?

Again, if dma_map_{single|sg} API's fails due to 
failure to allocate memory, the only thing that can
be done is to panic as this is what few of the other 
IOMMU implementation is doing today. 

Please advice.

Thanks,
Anil
