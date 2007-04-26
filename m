Return-Path: <linux-kernel-owner+w=401wt.eu-S1751240AbXDZSZT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751240AbXDZSZT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 14:25:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031425AbXDZSZT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 14:25:19 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:36593 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031411AbXDZSZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 14:25:17 -0400
Date: Thu, 26 Apr 2007 19:24:56 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>,
       Christoph Lameter <clameter@sgi.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, David Chinner <dgc@sgi.com>,
       linux-kernel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
Message-ID: <20070426182456.GA13066@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Jens Axboe <jens.axboe@oracle.com>,
	Christoph Lameter <clameter@sgi.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Nick Piggin <nickpiggin@yahoo.com.au>, David Chinner <dgc@sgi.com>,
	linux-kernel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
	William Lee Irwin III <wli@holomorphy.com>,
	Badari Pulavarty <pbadari@gmail.com>,
	Maxim Levitsky <maximlevitsky@gmail.com>
References: <m1hcr3oi0m.fsf@ebiederm.dsl.xmission.com> <46303A98.9000605@yahoo.com.au> <20070426063830.GE32602149@melbourne.sgi.com> <46304B9E.5070604@yahoo.com.au> <20070426161152.GC16337@infradead.org> <m1mz0vkoux.fsf@ebiederm.dsl.xmission.com> <Pine.LNX.4.64.0704261059500.3263@schroedinger.engr.sgi.com> <20070426180358.GG2017@kernel.dk> <20070426180932.GA10642@infradead.org> <20070426181249.GH2017@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070426181249.GH2017@kernel.dk>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2007 at 08:12:51PM +0200, Jens Axboe wrote:
> > Exactly.  But the only counter-proposal we have so far seems far worse :)
> 
> Lets look at some numbers. I'll just concentrate on the scatterlist,
> since the bio_vec is smaller. On x86 32-bit, the scatterlist is 20 bytes
> long. If we accept that 2^1 allocations are ok (they should be), then we
> can support ~1.6mb ios just like that.
> 
> My approach would be to support scatterlist chaining. Essentially you'd
> have the last element of the sglist pointing to the next array of
> entries. We can then stick to 128 entry arrays which fit nicely in a
> single page allocation and easily support >> 2mb ios. The only caveat is
> that you'd need to update the drivers to get there, since a regular
> iteration over the array isn't enough. My plan was to add an sglist
> iterator helper that hides this from the drivers, if they need to loop
> over the scatterlist. Things like {dma/pci}_map_sg() would of course be
> updated.
> 
> The above can be implemented fairly cleanly, and on a need-to-have
> basis. It's not something that'll break drivers.
> 
> What do you think?

Purely for the I/O sizes to external arrays problem that's nice,
and I think we (well, you :)) should implement it.

But there's other reasons why larger objects in the page cache make
sense that are mostly related to keeping overhead for large files
in the operating system down.  So I'd go both for s/g list chaining
and variable order pagecache.

Btw, we should talk a little about the sglist iterators on linux-scsi,
as a lot of the dma mapping API will need updates for bidirection dmas
anyway, and we should try to get everything done in one rush.
