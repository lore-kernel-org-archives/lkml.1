Return-Path: <linux-kernel-owner+w=401wt.eu-S932843AbXJPNDX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932843AbXJPNDX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 09:03:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757896AbXJPNDL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 09:03:11 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:38528 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759434AbXJPNDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 09:03:09 -0400
Subject: Re: More Large blocksize benchmarks
From: Chris Mason <chris.mason@oracle.com>
To: David Chinner <dgc@sgi.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Nathan Scott <nscott@aconex.com>, Andrea Arcangeli <andrea@suse.de>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Christoph Lameter <clameter@sgi.com>, Mel Gorman <mel@skynet.ie>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>,
       William Lee Irwin III <wli@holomorphy.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, hugh@veritas.com, joern@lazybastard.org
In-Reply-To: <20071016023627.GQ995458@sgi.com>
References: <20071016002231.GA21378@think.oraclecorp.com>
	 <20071016023627.GQ995458@sgi.com>
Content-Type: text/plain
Date: Tue, 16 Oct 2007 09:01:01 -0400
Message-Id: <1192539661.25603.38.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-10-16 at 12:36 +1000, David Chinner wrote:
> On Mon, Oct 15, 2007 at 08:22:31PM -0400, Chris Mason wrote:
> > Hello everyone,
> > 
> > I'm stealing the cc list and reviving and old thread because I've
> > finally got some numbers to go along with the Btrfs variable blocksize
> > feature.  The basic idea is to create a read/write interface to
> > map a range of bytes on the address space, and use it in Btrfs for all
> > metadata operations (file operations have always been extent based).
> > 
> > So, instead of casting buffer_head->b_data to some structure, I read and
> > write at offsets in a struct extent_buffer.  The extent buffer is very
> > small and backed by an address space, and I get large block sizes the
> > same way file_write gets to write to 16k at a time, by finding the
> > appropriate page in the addess space.  This is an over simplification
> > since I try to cache these mapping decisions to avoid using too much
> > CPU, but hopefully you get the idea.
> > 
> > The advantage to this approach is the changes are all inside Btrfs.  No
> > extra kernel patches were required.
> > 
> > Dave reported that XFS saw much higher write throughput with large
> > blocksizes, but so far I'm seeing the most benefits during reads.
> 
> Apples to oranges, Chris ;)
> 

Grin, if the two were the same, there'd be no reason to write a new one.
I didn't expect faster writes on btrfs, at least not for workloads that
did not require reads.  The basic idea is to show there are a variety of
ways the larger blocks can improve (and hurt) performance.

Also, vmap isn't the only implementation path.  Its true the Btrfs
changes for this were huge, but a big chunk of the changes were for
different leaf/node blocksizes, something that may never get used in
practice.

-chris


