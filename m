Return-Path: <linux-kernel-owner+w=401wt.eu-S1031380AbXDZRuw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031380AbXDZRuw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 13:50:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031383AbXDZRuw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 13:50:52 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:37588 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031381AbXDZRuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 13:50:51 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Christoph Hellwig <hch@infradead.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, David Chinner <dgc@sgi.com>,
       clameter@sgi.com, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@skynet.ie>, William Lee Irwin III <wli@holomorphy.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
References: <20070424222105.883597089@sgi.com>
	<m1hcr3oi0m.fsf@ebiederm.dsl.xmission.com>
	<46303A98.9000605@yahoo.com.au>
	<20070426063830.GE32602149@melbourne.sgi.com>
	<46304B9E.5070604@yahoo.com.au> <20070426161152.GC16337@infradead.org>
Date: Thu, 26 Apr 2007 11:49:26 -0600
In-Reply-To: <20070426161152.GC16337@infradead.org> (Christoph Hellwig's
	message of "Thu, 26 Apr 2007 17:11:52 +0100")
Message-ID: <m1mz0vkoux.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig <hch@infradead.org> writes:

> On Thu, Apr 26, 2007 at 04:50:06PM +1000, Nick Piggin wrote:
>> Improving the buffer layer would be a good way. Of course, that is
>> a long and difficult task, so nobody wants to do it.
>
> It's also a stupid idea.  We got rid of the buffer layer because it's
> a complete pain in the ass, and now you want to reintroduce one that's
> even more complex, and most likely even slower than the elegant solution?

No. I'm really suggesting improving the translation from BIO's 
to the page cache.  A set of helper functions.

This patch is suggesting we move to a BSD like buffer cache, except
that everything is physically mapped.

My most practical suggestion is to have support code so that you can
do all of the locking (that I/O cares about) on the first page of a
page group in the page cache.  You don't need larger physical pages to
do that.

>> Well, for those architectures (and this would solve your large block
>> size and 16TB pagecache size without any core kernel changes), you
>> can manage 1<<order hardware ptes as a single Linux pte. There is
>> nothing that says you must implement PAGE_SIZE as a single TLB sized
>> page.
>
> Well, ppc64 can do that.  And guess what, it really painfull for a lot
> of workloads.  Think of a poor ps3 with 256 from which the broken hypervisor
> already takes a lot away and now every file in the pagecache takes
> 64k, every thread stack takes 64k, etc?  It's good to have variable
> sized objects in places where it makes sense, and the pagecache is
> definitively one of them.

Agreed the page cache is all about variable sized objects known as files!
You don't need to do anything extra.  The problem is only with building
I/O requests from what is there.

Iff we really the larger physical page size to support the hardware
then it makes sense to go down a path of larger pages.  But it doesn't.

There is also a more fundamental reasons this patch is silly.  It assumes
that there is a trivial mapping between filesystems (the primary target
of the page cache and blocks on disk).  Now I admit this is common but
there is no reason to supposed it is true, and this patch appears to
exacerbate things.

Eric
