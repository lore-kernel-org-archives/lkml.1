Return-Path: <linux-kernel-owner+w=401wt.eu-S1031399AbXDZSKa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031399AbXDZSKa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 14:10:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031404AbXDZSKa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 14:10:30 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:44958 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031399AbXDZSK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 14:10:28 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: William Lee Irwin III <wli@holomorphy.com>
Cc: Christoph Lameter <clameter@sgi.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@skynet.ie>, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
References: <20070424222105.883597089@sgi.com>
	<m1hcr3oi0m.fsf@ebiederm.dsl.xmission.com>
	<Pine.LNX.4.64.0704252154250.29271@schroedinger.engr.sgi.com>
	<m1abwvofke.fsf@ebiederm.dsl.xmission.com>
	<463048FE.5000600@yahoo.com.au>
	<Pine.LNX.4.64.0704252341560.30340@schroedinger.engr.sgi.com>
	<46304D50.1040706@yahoo.com.au>
	<Pine.LNX.4.64.0704260008280.30731@schroedinger.engr.sgi.com>
	<46305327.2000206@yahoo.com.au>
	<Pine.LNX.4.64.0704260028190.31003@schroedinger.engr.sgi.com>
	<20070426135038.GE19966@holomorphy.com>
Date: Thu, 26 Apr 2007 12:09:24 -0600
In-Reply-To: <20070426135038.GE19966@holomorphy.com> (William Lee Irwin, III's
	message of "Thu, 26 Apr 2007 06:50:38 -0700")
Message-ID: <m1irbjknxn.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

William Lee Irwin III <wli@holomorphy.com> writes:

> On Thu, 26 Apr 2007, Nick Piggin wrote:
>>> OK, I would like to see them. And also discussions of things like why
>>> we shouldn't increase PAGE_SIZE instead.
>
> On Thu, Apr 26, 2007 at 12:34:50AM -0700, Christoph Lameter wrote:
>> Because 4k is a good page size that is bound to the binary format? Frankly 
>> there is no point in having my text files in large page sizes. However, 
>> when I read a dvd then I may want to transfer 64k chunks or when use my 
>> flash drive I may want to transfer 128k chunks. And yes if a scientific 
>> application needs to do data dump then it should be able to use very high 
>> page sizes (megabytes, gigabytes) to be able to continue its work while 
>> the huge dumps runs at full I/O speed ...
>
> It's possible to divorce PAGE_SIZE from the binary formats, though I
> found it difficult to keep up with the update treadmill. 

On x86_64 the sizes is actually 64K for executable binaries if I
recall correctly.  It certainly is not PAGE_SIZE, so we have some
flexibility there.

> Maybe it's
> like hch says and I just needed to find more and better API cleanups.
> I've only not tried to resurrect it because it's too much for me to do
> on my own. I essentially collapsed under the weight of it and my 2.5.x
> codebase ended up worse than Katrina as a disaster, which I don't want
> to repeat and think collaborators or a different project lead from
> myself are needed to avoid that happening again.

But we still have some issues with mmap. But since we could increase
PAGE_SIZE on x86_64 and not have to even worry about sub PAGE_SIZE
mmaps.  It is being suggested that if people really need larger
physical pages that they just fix PAGE_SIZE.  The everything just
works.

Thinking about it changing PAGE_SIZE on x86_64 should be about as
hard as doing the 3-level vs 2-level page table format.  We say
we have a different page table format that uses a larger PAGE_SIZE.
All arch code, all code in paths that we expect to change.

Boom all done.

It might be worth implementing just so people can play with different
PAGE_SIZE values for benchmarking.

I don't think the larger physical page size is really the issue here
though. 

> It's unclear how much the situation has changed since 32-bit workload
> feasibility issues have been relegated to ignorable or deliberate
> "f**k 32-bit" status. The effect is doubtless to make it easier, though
> to what degree I'm not sure.

Perhaps.

> Anyway, if that's being kicked around as an alternative, it could be
> said that I have some insight into the issues surrounding it.

Partially but also partially they are very much suggesting going down
the same path.  Currently mmap doesn't work with order >0 pages because
they are not yet addressing these issues at all.

This looks like a more flexible version of the old PAGE_CACHE_SIZE >
PAGE_SIZE code.  Which makes seriously question the whole idea.

Eric
