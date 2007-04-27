Return-Path: <linux-kernel-owner+w=401wt.eu-S1754207AbXD0N5k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207AbXD0N5k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 09:57:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755849AbXD0N5k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 09:57:40 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:50337 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754207AbXD0N5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 09:57:39 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Jens Axboe <jens.axboe@oracle.com>, Christoph Lameter <clameter@sgi.com>,
       Christoph Hellwig <hch@infradead.org>, David Chinner <dgc@sgi.com>,
       linux-kernel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
References: <m1mz0vkoux.fsf@ebiederm.dsl.xmission.com>
	<Pine.LNX.4.64.0704261059500.3263@schroedinger.engr.sgi.com>
	<20070426180358.GG2017@kernel.dk>
	<20070426180932.GA10642@infradead.org>
	<20070426181249.GH2017@kernel.dk>
	<Pine.LNX.4.64.0704261127550.3560@schroedinger.engr.sgi.com>
	<20070426182945.GJ2017@kernel.dk>
	<Pine.LNX.4.64.0704261134080.3656@schroedinger.engr.sgi.com>
	<20070426183935.GK2017@kernel.dk>
	<m1irbjj5ej.fsf@ebiederm.dsl.xmission.com>
	<20070426194234.GL2017@kernel.dk>
	<m1ejm6jwbs.fsf@ebiederm.dsl.xmission.com>
	<4631CFCD.7020207@yahoo.com.au>
Date: Fri, 27 Apr 2007 07:51:06 -0600
In-Reply-To: <4631CFCD.7020207@yahoo.com.au> (Nick Piggin's message of "Fri,
	27 Apr 2007 20:26:21 +1000")
Message-ID: <m1ps5qhqnp.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin <nickpiggin@yahoo.com.au> writes:

> Eric W. Biederman wrote:
>> Jens Axboe <jens.axboe@oracle.com> writes:
>
>>>Yes, that is exactly the problem. Once you have that, pktcdvd is pretty
>>>much reduced to setup and init code, the actual data handling can be
>>>done by sr or ide-cd directly. You could merge it into cdrom.c, it would
>>>not be very different from mt-rainier handling (which basically does RMW
>>>in firmware, so it works for any write, but performance is of course
>>>horrible if you don't do it right).
>>
>>
>> Thanks for the clarification.
>>
>> So we do have a clear problem that we do not have generic support for
>> large sector sizes residing in the page cache.
>
> Well, it is a clear limitation. It hasn't mattered too much until
> now, but it is one of the other issues that SGI hit (aside from
> io efficiency) because they have 16K filesystems created on ia64
> systems that I believe they want to access with x86-64 systems.

I think the current pktcdvd story is a better argument.  There is real
hardware with a > 4K sector size.  Of course once we support that
class of hardware support filesystems with a large block size will
also be straight forward.

> I'm slowly looking at patches in the background, but I'm hoping to
> be able to spend a decent chunk of time working on them again soon.
>
> It isn't trivial :)

I guess it depends on how you look at it.

If we can drop the assumption that large sector sizes are virtually
contiguous I expect things will be closer to trivial.

If we can do a page group thing where we keep the all of the I/O state on
the first cache page I expect things won't be to bad.

I do seem to see some VM affects needed from allocating and freeing
several pages together.

I also see an opportunity in allocating several pages at once.  We
could make it one call that returns a vector of pages and the page
allocator could satisfy our request with a high order page split into
individual pages if it was available.  The the I/O layer would have
to notice that we are giving it several page structs that are
physically contiguous.

Eric
