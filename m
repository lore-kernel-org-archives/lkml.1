Return-Path: <linux-kernel-owner+w=401wt.eu-S1762831AbXJPAZK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762831AbXJPAZK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 20:25:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756822AbXJPAY5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 20:24:57 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:30826 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752701AbXJPAY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 20:24:56 -0400
Date: Mon, 15 Oct 2007 20:22:31 -0400
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
Subject: More Large blocksize benchmarks
Message-ID: <20071016002231.GA21378@think.oraclecorp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone,

I'm stealing the cc list and reviving and old thread because I've
finally got some numbers to go along with the Btrfs variable blocksize
feature.  The basic idea is to create a read/write interface to
map a range of bytes on the address space, and use it in Btrfs for all
metadata operations (file operations have always been extent based).

So, instead of casting buffer_head->b_data to some structure, I read and
write at offsets in a struct extent_buffer.  The extent buffer is very
small and backed by an address space, and I get large block sizes the
same way file_write gets to write to 16k at a time, by finding the
appropriate page in the addess space.  This is an over simplification
since I try to cache these mapping decisions to avoid using too much
CPU, but hopefully you get the idea.

The advantage to this approach is the changes are all inside Btrfs.  No
extra kernel patches were required.

Dave reported that XFS saw much higher write throughput with large
blocksizes, but so far I'm seeing the most benefits during reads.

The next step is a bunch more benchmarks.  I've done the first round
and posted it here:

http://oss.oracle.com/~mason/blocksizes/

The Btrfs code makes it relatively easy to experiment, and so this may
be a good step toward figuring out if some automagic solution is worth
it in general.  I can even use different sizes for nodes and leaves,
although I haven't done much testing at all there yet.

-chris

