Return-Path: <linux-kernel-owner+w=401wt.eu-S1756843AbXFKX0m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756843AbXFKX0m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 19:26:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754683AbXFKX0f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 19:26:35 -0400
Received: from mga02.intel.com ([134.134.136.20]:37232 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754622AbXFKX0d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 19:26:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,409,1175497200"; 
   d="scan'208";a="253261279"
Date: Mon, 11 Jun 2007 04:29:50 -0700
From: Ashok Raj <ashok.raj@intel.com>
To: Andi Kleen <ak@suse.de>
Cc: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>,
       Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       gregkh@suse.de, muli@il.ibm.com, asit.k.mallick@intel.com,
       suresh.b.siddha@intel.com, arjan@linux.intel.com, ashok.raj@intel.com,
       shaohua.li@intel.com, davem@davemloft.net
Subject: Re: [Intel-IOMMU 02/10] Library routine for pre-allocat pool handling
Message-ID: <20070611112950.GA18203@araj-amd64.jf.intel.com>
References: <20070606185658.138237000@askeshav-devel.jf.intel.com> <200706091147.24705.ak@suse.de> <20070611204442.GA4074@linux-os.sc.intel.com> <200706120025.58137.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706120025.58137.ak@suse.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12, 2007 at 12:25:57AM +0200, Andi Kleen wrote:
> 
> > Please advice.
> 
> I think the short term only safe option would be to fully preallocate an aperture.
> If it is too small you can try GFP_ATOMIC but it would be just
> a unreliable fallback. For safety you could perhaps have some kernel thread
> that tries to enlarge it in the background depending on current
> use. That would be not 100% guaranteed to keep up with load,
> but would at least keep up if the system is not too busy.
> 
> That is basically what your resource pools do, but they seem
> to be unnecessarily convoluted for the task :- after all you
> could just preallocate the page tables and rewrite/flush them without
> having some kind of allocator inbetween, can't you?

Each iommu has multiple domains, where each domain represents an 
address space. PCIexpress endpoints can be located on its own domain
for addr protection reasons, and also have its own tag for iotlb cache.

each addr space can be either a 3 or 4 level. So it would be hard to predict
how much to setup ahead of time for each domain/device.

Its not a simple single level table with a small window like the gart case.

Just keeping a pool of page sized pages its easy to respond and use where its
really necessary without having to lock pages down without knowing real demand.

The addr space is plenty, so growing on demand is the best use of memory 
available.

> If you make the start value large enough (256+MB?) that might reasonably
> work. How much memory in page tables would that take? Or perhaps scale
> it with available memory or available devices. 
> 
> In theory it could also be precomputed from the block/network device queue 
> lengths etc.; the trouble is just such checks would need to be added to all kinds of 
> other odd subsystems that manage devices too.  That would be much more work.
> 
> Some investigation how to do sleeping block/network submit would be
> also interesting (e.g. replace the spinlocks there with mutexes and see how
> much it affects performance). For networking you would need to keep 
> at least a non sleeping path though because packets can be legally
> submitted from interrupt context. If it works out then sleeping
> interfaces to the IOMMU code could be added.
> 
> -Andi
