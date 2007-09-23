Return-Path: <linux-kernel-owner+w=401wt.eu-S1756519AbXIWFun@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756519AbXIWFun (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2007 01:50:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752878AbXIWFue
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Sep 2007 01:50:34 -0400
Received: from mx1.Informatik.Uni-Tuebingen.De ([134.2.12.5]:45456 "EHLO
	mx1.informatik.uni-tuebingen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752819AbXIWFuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2007 01:50:32 -0400
From: Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>
To: mel@skynet.ie (Mel Gorman)
Cc: Andrea Arcangeli <andrea@suse.de>,
       Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>,
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
References: <20070911060349.993975297@sgi.com>
	<200709110452.20363.nickpiggin@yahoo.com.au>
	<20070911121225.GE13132@lazybastard.org>
	<20070915014449.4f9cdb51.akpm@linux-foundation.org>
	<87ir6c3z2l.fsf@informatik.uni-tuebingen.de>
	<20070915155100.GA21861@v2.random> <20070916181504.GB16406@skynet.ie>
	<20070916185052.GG6708@v2.random> <20070916205418.GC16406@skynet.ie>
	<20070916213126.GH6708@v2.random> <20070917101307.GD25706@skynet.ie>
Date: Sun, 23 Sep 2007 07:50:25 +0200
In-Reply-To: <20070917101307.GD25706@skynet.ie> (Mel Gorman's message of "Mon,
	17 Sep 2007 11:13:07 +0100")
Message-ID: <87vea26ice.fsf@informatik.uni-tuebingen.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

mel@skynet.ie (Mel Gorman) writes:

> On (16/09/07 23:31), Andrea Arcangeli didst pronounce:
>> On Sun, Sep 16, 2007 at 09:54:18PM +0100, Mel Gorman wrote:
>> Allocating ptes from slab is fairly simple but I think it would be
>> better to allocate ptes in PAGE_SIZE (64k) chunks and preallocate the
>> nearby ptes in the per-task local pagetable tree, to reduce the number
>> of locks taken and not to enter the slab at all for that.
>
> It runs the risk of pinning up to 60K of data per task that is unusable for
> any other purpose. On average, it'll be more like 32K but worth keeping
> in mind.

Two things to both of you respectively.

Why should we try to stay out of the pte slab? Isn't the slab exactly
made for this thing? To efficiently handle a large number of equal
size objects for quick allocation and dealocation? If it is a locking
problem then there should be a per cpu cache of ptes. Say 0-32
ptes. If you run out you allocate 16 from slab. When you overflow you
free 16 (which would give you your 64k allocations but in multiple
objects).

As for the wastage. Every pte can map 2MB on amd64, 4MB on i386, 8MB
on sparc (?). A 64k pte chunk would be 32MB, 64MB and 32MB (?)
respectively. For the sbrk() and mmap() usage from glibc malloc() that
would be fine as they grow linear and the mmap() call in glibc could
be made to align to those chunks. But for a programm like rtorrent
using mmap to bring in chunks of a 4GB file this looks desasterous.

>> Infact we
>> could allocate the 4 levels (or anyway more than one level) in one
>> single alloc_pages(0) and track the leftovers in the mm (or similar).

Personally I would really go with a per cpu cache. When mapping a page
reserve 4 tables. Then you walk the tree and add entries as
needed. And last you release 0-4 unused entries to the cache.

MfG
        Goswin
