Return-Path: <linux-kernel-owner+w=401wt.eu-S932326AbXJPCha@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932326AbXJPCha (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 22:37:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757798AbXJPChT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 22:37:19 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:59038 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757559AbXJPChQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 22:37:16 -0400
Date: Tue, 16 Oct 2007 12:36:27 +1000
From: David Chinner <dgc@sgi.com>
To: Chris Mason <chris.mason@oracle.com>
Cc: David Chinner <dgc@sgi.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
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
Subject: Re: More Large blocksize benchmarks
Message-ID: <20071016023627.GQ995458@sgi.com>
References: <20071016002231.GA21378@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071016002231.GA21378@think.oraclecorp.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 15, 2007 at 08:22:31PM -0400, Chris Mason wrote:
> Hello everyone,
> 
> I'm stealing the cc list and reviving and old thread because I've
> finally got some numbers to go along with the Btrfs variable blocksize
> feature.  The basic idea is to create a read/write interface to
> map a range of bytes on the address space, and use it in Btrfs for all
> metadata operations (file operations have always been extent based).
> 
> So, instead of casting buffer_head->b_data to some structure, I read and
> write at offsets in a struct extent_buffer.  The extent buffer is very
> small and backed by an address space, and I get large block sizes the
> same way file_write gets to write to 16k at a time, by finding the
> appropriate page in the addess space.  This is an over simplification
> since I try to cache these mapping decisions to avoid using too much
> CPU, but hopefully you get the idea.
> 
> The advantage to this approach is the changes are all inside Btrfs.  No
> extra kernel patches were required.
> 
> Dave reported that XFS saw much higher write throughput with large
> blocksizes, but so far I'm seeing the most benefits during reads.

Apples to oranges, Chris ;)

btrfs linearises writes due to it's COW behaviour and this is trades
off read speed. i.e. we take more seeks to read data so we can keep
the write speed high. By using large blocks, you're reducing the
number of seeks needed to find anything, and hence the read speed
will increase. Write speed will be pretty much unchanged because
btrfs does linear writes no matter the block size.

XFS doesn't linearise writes and optimises it's layout for a large
number of disks and a low number of seeks on reads - the opposite
of btrfs. Hence large block sizes reduce the number of writes XFS
needs to write a given set of data+metadata and hence write speed
increases much more than the read speed (until you get to large tree
traversals).

The basic conclusion is that different filesystems will benefit in
different ways with large block sizes....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
