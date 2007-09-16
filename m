Return-Path: <linux-kernel-owner+w=401wt.eu-S1753850AbXIPSvL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850AbXIPSvL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 14:51:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752215AbXIPSu4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 14:50:56 -0400
Received: from ns.suse.de ([195.135.220.2]:46659 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752125AbXIPSuz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 14:50:55 -0400
Date: Sun, 16 Sep 2007 20:50:52 +0200
From: Andrea Arcangeli <andrea@suse.de>
To: Mel Gorman <mel@skynet.ie>
Cc: Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Joern Engel <joern@logfs.org>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Christoph Lameter <clameter@sgi.com>, torvalds@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, hugh@veritas.com
Subject: Re: [00/41] Large Blocksize Support V7 (adds memmap support)
Message-ID: <20070916185052.GG6708@v2.random>
References: <20070911060349.993975297@sgi.com> <200709110452.20363.nickpiggin@yahoo.com.au> <20070911121225.GE13132@lazybastard.org> <20070915014449.4f9cdb51.akpm@linux-foundation.org> <87ir6c3z2l.fsf@informatik.uni-tuebingen.de> <20070915155100.GA21861@v2.random> <20070916181504.GB16406@skynet.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070916181504.GB16406@skynet.ie>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 16, 2007 at 07:15:04PM +0100, Mel Gorman wrote:
> Except now as I've repeatadly pointed out, you have internal fragmentation
> problems. If we went with the SLAB, we would need 16MB slabs on PowerPC for
> example to get the same sort of results and a lot of copying and moving when

Well not sure about the 16MB number, since I'm unsure what the size of
the ram was. But clearly I agree there are fragmentation issues in the
slab too, there have always been, except they're much less severe, and
the slab is meant to deal with that regardless of the PAGE_SIZE. That
is not a new problem, you are introducing a new problem instead.

We can do a lot better than slab currently does without requiring any
defrag move-or-shrink at all.

slab is trying to defrag memory for small objects at nearly zero cost,
by not giving pages away randomly. I thought you agreed that solving
the slab fragmentation was going to provide better guarantees when in
another email you suggested that you could start allocating order > 0
pages in the slab to reduce the fragmentation (to achieve most of the
guarantee provided by config-page-shift, but while still keeping the
order 0 at 4k for whatever reason I can't see).

> a suitable slab page was not available.

You ignore one other bit, when "/usr/bin/free" says 1G is free, with
config-page-shift it's free no matter what, same goes for not mlocked
cache. With variable order page cache, /usr/bin/free becomes mostly a
lie as long as there's no 4k fallback (like fsblock).

And most important you're only tackling on the pagecache and I/O
performance with the inefficient I/O devices, the whole kernel has no
cahnce to get a speedup, infact you're making the fast paths slower,
just the opposite of config-page-shift and original Hugh's large
PAGE_SIZE ;).
