Return-Path: <linux-kernel-owner+w=401wt.eu-S1754048AbXEGGn5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754048AbXEGGn5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 02:43:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754052AbXEGGn5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 02:43:57 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:32778 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754048AbXEGGn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 02:43:56 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: David Chinner <dgc@sgi.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Theodore Tso <tytso@mit.edu>,
       Andrew Morton <akpm@linux-foundation.org>, clameter@sgi.com,
       linux-kernel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
References: <20070427042046.GI65285596@melbourne.sgi.com>
	<20070426221528.655d79cb.akpm@linux-foundation.org>
	<20070427060921.GA77450368@melbourne.sgi.com>
	<20070427000403.6013d1fa.akpm@linux-foundation.org>
	<20070427080321.GG32602149@melbourne.sgi.com>
	<20070427014849.41f383f7.akpm@linux-foundation.org>
	<20070427164535.GH24852@thunk.org>
	<m1abwku30d.fsf@ebiederm.dsl.xmission.com>
	<20070507042925.GT32602149@melbourne.sgi.com>
	<m1tzupkzmw.fsf@ebiederm.dsl.xmission.com>
	<20070507052729.GV32602149@melbourne.sgi.com>
Date: Mon, 07 May 2007 00:43:19 -0600
In-Reply-To: <20070507052729.GV32602149@melbourne.sgi.com> (David Chinner's
	message of "Mon, 7 May 2007 15:27:29 +1000")
Message-ID: <m17irlkubc.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Chinner <dgc@sgi.com> writes:

> On Sun, May 06, 2007 at 10:48:23PM -0600, Eric W. Biederman wrote:
>> David Chinner <dgc@sgi.com> writes:
>> 
>> > On Fri, May 04, 2007 at 07:33:54AM -0600, Eric W. Biederman wrote:
>> >> >
>> >> > So while the jury is out about how many other filesystems might use
>> >> > it, I suspect it's more than you might think.  At the very least,
>> >> > there may be some IA64 users who might be trying to transition their
>> >> > way to x86_64, and have existing filesystems using a 8k or 16k
>> >> > block filesystems.  :-)
>> >> 
>> >> How much of a problem would it be if those blocks were not necessarily
>> >> contiguous in RAM, but placed in normal 4K pages in the page cache?
>> >
>> > If you need to treat the block in a contiguous range, then you need to
>> > vmap() the discontiguous pages. That has substantial overhead if you
>> > have to do it regularly.
>> 
>> Which is why I would prefer not to do it.  I think vmap is not really
>> compatible with the design of the linux page cache.
>
> Right - so how do we efficiently  manipulate data inside a large
> block that spans multiple discontigous pages if we don't vmap
> it?

You don't manipulate data except for copy_from_user, copy_to_user.
That is easy comparatively to deal with, and certainly doesn't
need vmap.

Meta-data may be trickier, but a lot of that depends on your
individual filesystem and how it organizes it's meta-data.

>> Although we can't even count on the pages being mapped into low
>> memory right now and have to call kmap if we want to access them
>> so things might not be that bad.  Even if it was a multipage kmap
>> type operation.
>
> Except when you structures span page boundaries. Then you can't directly
> reference the structure - it needs to be copied out elsewhere, modified
> and copied back. That's messy and will require significant modification
> to any filesystem that wants large block sizes....

Potentially.  This is a just a meta data problem, and possibly we
solve it with something like vmap.  Possibly the filesystem won't
cross those kinds of boundaries and we simply never care.

The fact that it is a meta-data problem suggests it isn't the fast
path and we can incur a little more cost.  Especially if we filesytems
with large block sizes are rare.

> I'm not sure I follow you here - copyin/copyout is to userspace and
> has to handle things like RMW cycles to a filesystem block. e.g. if
> we get a partial block over-write, we need to read in all the bits
> around it and that will span multiple discontiguous pages. Currently
> these function only handle RMW operations on something up to a
> single page in size - to handle a RMW cycle on a block larger than a
> page they are going to need substantial modification or entirely
> new interfaces.

Bleh.  It has been to many days since I have hacked that code I forgot
which piece that was.  Yes. prepare_to_write is called before
we write to the page cache from the filesystem.

We already handle multiple page writes fairly well in that context.
prepare_write, commit_write may need a page cache but it may not.
All that really needs to happen is that all of the pages that
are part of the block get marked dirty in the page cache so one
won't get written without the others.

> The high order page cache avoids the need to redesign interfaces
> because it doesn't change the interfaces between the filesystem
> and the page cache - everything still effectively operates
> on single pages and the filesystem block size never exceeds the
> size of a single page.....

Yes, instead of having to redesign the interface between the
fs and the page cache for those filesystems that handle large
blocks we instead need to redesign significant parts of the VM interface.
Shift the redesign work to another group of people and call it a trivial.

That is hardly a gain when it looks like you can have the same effect
with some moderately simple changes to mm/filemap.c and the existing
interfaces.

Eric
