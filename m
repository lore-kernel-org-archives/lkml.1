Return-Path: <linux-kernel-owner+w=401wt.eu-S1754212AbXD0MO3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754212AbXD0MO3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 08:14:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755741AbXD0MO3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 08:14:29 -0400
Received: from ozlabs.org ([203.10.76.45]:34736 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754212AbXD0MO1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 08:14:27 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17969.59676.356383.189020@cargo.ozlabs.ibm.com>
Date: Fri, 27 Apr 2007 22:14:20 +1000
From: Paul Mackerras <paulus@samba.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>, David Chinner <dgc@sgi.com>,
       linux-kernel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
In-Reply-To: <4631E173.7000204@yahoo.com.au>
References: <20070424222105.883597089@sgi.com>
	<20070426190438.3a856220.akpm@linux-foundation.org>
	<20070427022731.GF65285596@melbourne.sgi.com>
	<20070426195357.597ffd7e.akpm@linux-foundation.org>
	<20070427042046.GI65285596@melbourne.sgi.com>
	<20070426221528.655d79cb.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0704262239580.4758@schroedinger.engr.sgi.com>
	<20070426235542.bad7035a.akpm@linux-foundation.org>
	<17969.55533.59287.509889@cargo.ozlabs.ibm.com>
	<4631E173.7000204@yahoo.com.au>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin writes:

> For the TLB issue, higher order pagecache doesn't help. If distros

Oh?  Assuming your hardware is capable of supporting a variety of page
sizes, and of putting a page at any address that is a multiple of its
size, it should help, potentially a great deal, as far as I can see.
I'm thinking in particular of machines that have software-loaded
fully-associative TLBs and support a lot of page sizes, e.g.
4kB * 4^n for n = 0 up to 8 or so, like some embedded powerpc chips.

It's not as simple on 64-bit powerpc with the hash table of course,
because the page size is chosen at the segment (256MB) level,
restricting where we can put 64k and 16M pages to some degree.

> ship with a 4K page size on powerpc, and use some larger pages in
> the pagecache, some people are still going to get angry because
> they wanted to use 64K pages... But I agree 64K pages is too big
> for most things anyway, and 16 would be better as a default (which
> hopefully x86-64 will get one day).

Even 16k is going to bloat the page cache, and some people will
complain.  One way that x86-64 could do 16k pages is by still indexing
the PTE page in units of 4k, but then have an indicator in the PTE
that this is a 16k page.  Thus a 16k page would occupy 4 consecutive
PTEs, but once it was loaded into the TLB, a single TLB entry would
map the whole 16k.  That would give the expanded TLB reach and allow
4k and 16k pages to be intermixed freely.

Paul.
