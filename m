Return-Path: <linux-kernel-owner+w=401wt.eu-S1031301AbXDZQHW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031301AbXDZQHW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 12:07:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031300AbXDZQHW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 12:07:22 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:47570 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031301AbXDZQHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 12:07:20 -0400
Date: Thu, 26 Apr 2007 17:07:15 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Christoph Lameter <clameter@sgi.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
Message-ID: <20070426160715.GB16337@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Nick Piggin <nickpiggin@yahoo.com.au>,
	Christoph Lameter <clameter@sgi.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	linux-kernel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
	William Lee Irwin III <wli@holomorphy.com>,
	David Chinner <dgc@sgi.com>, Jens Axboe <jens.axboe@oracle.com>,
	Badari Pulavarty <pbadari@gmail.com>,
	Maxim Levitsky <maximlevitsky@gmail.com>
References: <m1hcr3oi0m.fsf@ebiederm.dsl.xmission.com> <Pine.LNX.4.64.0704252154250.29271@schroedinger.engr.sgi.com> <m1abwvofke.fsf@ebiederm.dsl.xmission.com> <463048FE.5000600@yahoo.com.au> <Pine.LNX.4.64.0704252341560.30340@schroedinger.engr.sgi.com> <46304D50.1040706@yahoo.com.au> <Pine.LNX.4.64.0704260008280.30731@schroedinger.engr.sgi.com> <46305327.2000206@yahoo.com.au> <Pine.LNX.4.64.0704260028190.31003@schroedinger.engr.sgi.com> <4630593C.8070905@yahoo.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4630593C.8070905@yahoo.com.au>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2007 at 05:48:12PM +1000, Nick Piggin wrote:
> >Well maybe you could explain what you want. Preferably without redefining 
> >the established terms?
> 
> Support for larger buffers than page cache pages.

I don't think you really want this :)  The whole non-pagecache I/O
path before 2.3 was a toal pain just because it used buffers to drive
I/O.  Add to that buffers bigger than a page and you add another
two mangnitudes of complexity.  If you want to see a mess like that
download on of the eary XFS/Linux releases that had an I/O path
like that.  I _really_ _really_ don't want to go there.

Linux has a long tradition of trading a tiny bit of efficieny for
much cleaner code, and I'd for 100% go down Christoph's route here.
Then again I'd actually be rather surprised if > page buffers
were more efficient - you'd run into shitloads over overhead due to
them beeing non-contingous like calling vmap all over the place,
reprogramming iommus to at least make them look virtually contingous [1],
etc..

I also don't quite get what your problem with higher order allocations
are.  order 1 allocations are generally just fine, and in fact
thread stacks are >= oder 1 on most architectures.  And if the pagecache
uses higher order allocations that means we'll finally fix our problems
with them, which we have to do anyway.  Workloads continue to grow and
with them the kernel overhead to manage them, while the pagesize for
many architectures is fixed.  So we'll have to deal with order 1
and order 2 allocations better just for backing kmalloc and co.

Or think jumboframes for that matter.


[1] many iommu implementation of course also have a limit of how many
    segments they can actually virtually merge
