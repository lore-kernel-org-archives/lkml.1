Return-Path: <linux-kernel-owner+w=401wt.eu-S1753931AbXEGEts@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931AbXEGEts (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 00:49:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753932AbXEGEtr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 00:49:47 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:39030 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753931AbXEGEtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 00:49:47 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: David Chinner <dgc@sgi.com>
Cc: Theodore Tso <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>,
       clameter@sgi.com, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@skynet.ie>, William Lee Irwin III <wli@holomorphy.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
References: <20070427022731.GF65285596@melbourne.sgi.com>
	<20070426195357.597ffd7e.akpm@linux-foundation.org>
	<20070427042046.GI65285596@melbourne.sgi.com>
	<20070426221528.655d79cb.akpm@linux-foundation.org>
	<20070427060921.GA77450368@melbourne.sgi.com>
	<20070427000403.6013d1fa.akpm@linux-foundation.org>
	<20070427080321.GG32602149@melbourne.sgi.com>
	<20070427014849.41f383f7.akpm@linux-foundation.org>
	<20070427164535.GH24852@thunk.org>
	<m1abwku30d.fsf@ebiederm.dsl.xmission.com>
	<20070507042925.GT32602149@melbourne.sgi.com>
Date: Sun, 06 May 2007 22:48:23 -0600
In-Reply-To: <20070507042925.GT32602149@melbourne.sgi.com> (David Chinner's
	message of "Mon, 7 May 2007 14:29:25 +1000")
Message-ID: <m1tzupkzmw.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Chinner <dgc@sgi.com> writes:

> On Fri, May 04, 2007 at 07:33:54AM -0600, Eric W. Biederman wrote:
>> >
>> > So while the jury is out about how many other filesystems might use
>> > it, I suspect it's more than you might think.  At the very least,
>> > there may be some IA64 users who might be trying to transition their
>> > way to x86_64, and have existing filesystems using a 8k or 16k
>> > block filesystems.  :-)
>> 
>> How much of a problem would it be if those blocks were not necessarily
>> contiguous in RAM, but placed in normal 4K pages in the page cache?
>
> If you need to treat the block in a contiguous range, then you need to
> vmap() the discontiguous pages. That has substantial overhead if you
> have to do it regularly.

Which is why I would prefer not to do it.  I think vmap is not really
compatible with the design of the linux page cache.

Although we can't even count on the pages being mapped into low
memory right now and have to call kmap if we want to access them
so things might not be that bad.  Even if it was a multipage kmap
type operation.

> We do this in xfs_buf.c for > page size blocks - the overhead that
> caused when operating on inode clusters resulted in us doing some
> pointer fiddling and directly addresing the contents of each page
> to avoid the vmap overhead. See xfs_buf_offset() and friends....
>
>> I expect meta data operations would have to be modified but that otherwise
>> you would not care.
>
> I think you might need to modify the copy-in and copy-out operations
> substantially (e.g. prepare_/commit_write()) as they assume a buffer doesn't
> span multple pages.....

But in a filesystem like ext2 except for a zeroing some unused hunks
of the page all that really happens is you setup for DMA straight out
of the page cache.  So this is primarily an issue for meta-data.

Eric
