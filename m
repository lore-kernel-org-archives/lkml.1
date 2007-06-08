Return-Path: <linux-kernel-owner+w=401wt.eu-S1031453AbXFHSZ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031453AbXFHSZ4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 14:25:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968984AbXFHSZo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 14:25:44 -0400
Received: from mga01.intel.com ([192.55.52.88]:53156 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S969142AbXFHSZn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 14:25:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,400,1175497200"; 
   d="scan'208";a="254835569"
Date: Fri, 8 Jun 2007 11:21:57 -0700
From: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: anil.s.keshavamurthy@intel.com, linux-kernel@vger.kernel.org, ak@suse.de,
       gregkh@suse.de, muli@il.ibm.com, asit.k.mallick@intel.com,
       suresh.b.siddha@intel.com, arjan@linux.intel.com, ashok.raj@intel.com,
       shaohua.li@intel.com, davem@davemloft.net
Subject: Re: [Intel-IOMMU 02/10] Library routine for pre-allocat pool handling
Message-ID: <20070608182156.GA24865@linux-os.sc.intel.com>
Reply-To: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
References: <20070606185658.138237000@askeshav-devel.jf.intel.com> <20070606190042.510643000@askeshav-devel.jf.intel.com> <20070607162726.2236a296.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070607162726.2236a296.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 07, 2007 at 04:27:26PM -0700, Andrew Morton wrote:
> On Wed, 06 Jun 2007 11:57:00 -0700
> anil.s.keshavamurthy@intel.com wrote:
> 
> > Signed-off-by: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
> 
> That was a terse changelog.
> 
> Obvious question: how does this differ from mempools, and would it be
> better to fill in any gaps in mempool functionality instead of
> implementing something similar-looking?

Very good question. Mempool pre-allocates the elements
to the required minimum count size during its initilization time.
However when mempool_alloc() is called it tries to obtain the
element from OS and if that fails then it looks for the element in 
its pool. If there are no elements in its pool and if the gpf_t 
flags says it can wait then it waits untill someone puts the element 
back to pool, else if gpf_t flag say it can;t wait then it returns NULL. 
In other words, mempool acts as *emergency* pool, i.e only if the OS fails 
to allocate the required memory, then the pool object is used.


In the IOMMU case, we need exactly opposite of what mempool provides,
i.e we always want to look for the element in the pool and if the pool
has no element then go to OS as a worst case. This resource pool
library routines do the same. Again, this resource pools 
grows and shrinks automatically to maintain the minimum pool 
elements in the background. I am not sure whether this totally
opposite functionality of mempools and resource pools can be 
merged.

In fact the very first version of this IOMMU patch used mempools
and the performance was worse because mempool did not help as
IOMMU did a very frequent alloc and free of pool objects and
every call to alloc/free used to go to os. Andi Kleen, 
noticied and told us that mempool usage for IOMMU is wrong and
hence we came up with resource pool concept.

> 
> The changelog very much should describe all this, as well as explaining
> what the dynamic behaviour of this new thing is, and what applications are
> envisaged, what problems it solves, etc, etc.

I can gladly update the changelog if the resource pool concept is 
approved. I will fix all the below minor comments.

I envision that this might be useful for all vendor's (IBM, AMD, Intel, etc) IOMMU driver
and for any kernel component which does lots of dynamic alloc/free an object of same size.

thanks,
Anil
