Return-Path: <linux-kernel-owner+w=401wt.eu-S1031604AbXFHVmc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031604AbXFHVmc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 17:42:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753733AbXFHVmZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 17:42:25 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46092 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750926AbXFHVmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 17:42:24 -0400
Date: Fri, 8 Jun 2007 14:42:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
Cc: Andreas Kleen <ak@suse.de>, linux-kernel@vger.kernel.org, gregkh@suse.de,
       muli@il.ibm.com, asit.k.mallick@intel.com, suresh.b.siddha@intel.com,
       arjan@linux.intel.com, ashok.raj@intel.com, shaohua.li@intel.com,
       davem@davemloft.net
Subject: Re: [Intel-IOMMU 02/10] Library routine for pre-allocat pool
 handling
Message-Id: <20070608144207.07341ee7.akpm@linux-foundation.org>
In-Reply-To: <20070608212054.GB641@linux-os.sc.intel.com>
References: <20070606185658.138237000@askeshav-devel.jf.intel.com>
	<20070606190042.510643000@askeshav-devel.jf.intel.com>
	<20070607162726.2236a296.akpm@linux-foundation.org>
	<20070608182156.GA24865@linux-os.sc.intel.com>
	<20070608120107.245eba96.akpm@linux-foundation.org>
	<6901450.1181335390183.SLOX.WebMail.wwwrun@imap-dhs.suse.de>
	<20070608212054.GB641@linux-os.sc.intel.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Jun 2007 14:20:54 -0700
"Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com> wrote:

> > This means mempools don't work for those (the previous version had non
> > sensical
> > constructs like GFP_ATOMIC mempool calls)
> > 
> > __I haven't looked at Anil's code, but I suspect the only really robust
> > way to handle this case is to always preallocate everything. But I'm not
> > sure
> > why that would need new library functions; it should be just some simple
> > lists that could be open coded.
> 
> Since it is practically impossible to predicit how much to preallocate,
> we have a min_count+grow_count of object allocated and we always use from this
> pool. If the object count goes below certain low threshold(which acts as 
> emergency pool from this point), the pool grows by allocating and 
> adding the newly allocated object into the pool in the
> worker (keventd) thread. 

Asking keventd to do this might be problematic: there may be code in various
dark corners of device drivers which also depend upon keventd services for
IO completion, in which case there might be obscure deadlocks, dunno. 
otoh, keventd already surely does GFP_KERNEL allocations...

But still, the whole thing seems pointless: kswapd is already doing all of
this, replenishing the page reserves.  So why not use that?

> Again, once the IO pressure is over, the PCI driver
> does the unmap calls and we put back the objects back to preallocate pools.
> The smartness is builtin to the pool as the elements are put back to the 
> pool it detects that the pool count is greater then the threshold and 
> it automagically queues the work to free the objects and bring back the 
> pre-allocated object count back to minimum threshold.
> Thus this preallocated pool grow and shrinks based on the demand, while
> acting as both pre-allocated pools and as emergency pool.
> 
> Currently I have made this as a libray functions, if that is not correct,
> we can pull this and make it part of the Intel IOMMU driver itself.
> Please do let me know your suggestions.

I'd say just remove the whole thing and use kmem_cache_alloc().

Put much effort into removing the GFP_ATOMIC and using GFP_NOIO instead:
there's your problem right there.

If for some reason you really can't do that (and a requirement for
allocation-in-interrupt is the only valid reason, really) and if you indeed
can demonstrate memory allocation failures with certain workloads then
let's take a look at that.  As I said, attaching a reserve pool to your
slab cache might be a suitable approach.  But none of these things are
magic: if memory allcoation failures or deadlocks or livelocks are
demonstrable with the reserves absent, then they'll also be possible with
the reserves present.

Unless you use mempools, and can sleep.
