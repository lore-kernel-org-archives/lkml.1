Return-Path: <linux-kernel-owner+w=401wt.eu-S1764688AbXILIUf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764688AbXILIUf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 04:20:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757593AbXILIUS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 04:20:18 -0400
Received: from ns.suse.de ([195.135.220.2]:36215 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754325AbXILIUQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 04:20:16 -0400
Date: Wed, 12 Sep 2007 10:20:11 +0200
From: Andrea Arcangeli <andrea@suse.de>
To: Christoph Lameter <clameter@sgi.com>
Cc: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, torvalds@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, hugh@veritas.com
Subject: Re: [00/41] Large Blocksize Support V7 (adds memmap support)
Message-ID: <20070912082011.GA21600@v2.random>
References: <20070911060349.993975297@sgi.com> <200709110452.20363.nickpiggin@yahoo.com.au> <20070911121225.GE13132@lazybastard.org> <Pine.LNX.4.64.0709111303590.25781@schroedinger.engr.sgi.com> <20070911202942.GB20688@lazybastard.org> <Pine.LNX.4.64.0709111337510.26598@schroedinger.engr.sgi.com> <20070911232657.GB14675@v2.random> <Pine.LNX.4.64.0709111700410.29413@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0709111700410.29413@schroedinger.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 11, 2007 at 05:04:41PM -0700, Christoph Lameter wrote:
> I would think that your approach would be slower since you always have to 
> populate 1 << N ptes when mmapping a file? Plus there is a lot of wastage 

I don't have to populate them, I could just map one at time. The only
reason I want to populate every possible pte that could map that page
(by checking vma ranges) is to _improve_ performance by decreasing the
number of page faults of an order of magnitude. Then with the 62th bit
after NX giving me a 64k tlb, I could decrease the frequency of the
tlb misses too.

> of memory because even a file with one character needs an order N page? So 
> there are less pages available for the same workload.

This is a known issue. The same is true for ppc64 64k. If that really
is an issue, that may need some generic solution with tail packing.

> Then you are breaking mmap assumptions of applications becaused the order 
> N kernel will no longer be able to map 4k pages.  You likely need a new 
> binary format that has pages correctly aligned. I know that we would need 
> one on IA64 if we go beyond the established page sizes.

No you misunderstood the whole design. My patch will be 100% backwards
compatible in all respects. If I could break backwards compatibility
70% of the complexity would go away...
