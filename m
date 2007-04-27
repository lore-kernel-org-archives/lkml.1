Return-Path: <linux-kernel-owner+w=401wt.eu-S1754173AbXD0KFo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754173AbXD0KFo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 06:05:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755528AbXD0KFo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 06:05:44 -0400
Received: from smtp105.mail.mud.yahoo.com ([209.191.85.215]:43797 "HELO
	smtp105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754173AbXD0KFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 06:05:42 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=GJO68kQd8H42DzpDZJyoFDhO+t9XKsPv+0InTQcigeaz4CQqMWBig9NF2Tc545TkXkHR6yOZSImuL2MogUtOMMF929OW14QF4aVwjHsvlnnCdtNvram8Nsg9ip6hPfeRZaJPtEVOW35qbqN/ZKsEYZ0BMucWFoEj9afwkfaAfDU=  ;
X-YMail-OSG: vYW9hL4VM1mQQcV3e3ZD1mM39uxXyJ3PED7kadCPz8TGgsXW36rhd9UdlNpFOBf0FPUh4ZArKQ--
Message-ID: <4631CAE7.2080109@yahoo.com.au>
Date: Fri, 27 Apr 2007 20:05:27 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Christoph Lameter <clameter@sgi.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
References: <m1hcr3oi0m.fsf@ebiederm.dsl.xmission.com> <Pine.LNX.4.64.0704252154250.29271@schroedinger.engr.sgi.com> <m1abwvofke.fsf@ebiederm.dsl.xmission.com> <463048FE.5000600@yahoo.com.au> <Pine.LNX.4.64.0704252341560.30340@schroedinger.engr.sgi.com> <46304D50.1040706@yahoo.com.au> <Pine.LNX.4.64.0704260008280.30731@schroedinger.engr.sgi.com> <46305327.2000206@yahoo.com.au> <Pine.LNX.4.64.0704260028190.31003@schroedinger.engr.sgi.com> <4630593C.8070905@yahoo.com.au> <20070426160715.GB16337@infradead.org>
In-Reply-To: <20070426160715.GB16337@infradead.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> On Thu, Apr 26, 2007 at 05:48:12PM +1000, Nick Piggin wrote:
> 
>>>Well maybe you could explain what you want. Preferably without redefining 
>>>the established terms?
>>
>>Support for larger buffers than page cache pages.
> 
> 
> I don't think you really want this :)  The whole non-pagecache I/O
> path before 2.3 was a toal pain just because it used buffers to drive
> I/O.  Add to that buffers bigger than a page and you add another
> two mangnitudes of complexity.  If you want to see a mess like that
> download on of the eary XFS/Linux releases that had an I/O path
> like that.  I _really_ _really_ don't want to go there.

I'm not actually suggesting to add anything like that. But I think
larger blocks can be doable while retaining the "buffer" layer as a
relatively simple pagecache to block translation.

Anyway, I'm working on patches... they might crash and burn, but we
might have something to talk about later.


> Linux has a long tradition of trading a tiny bit of efficieny for
> much cleaner code, and I'd for 100% go down Christoph's route here.
> Then again I'd actually be rather surprised if > page buffers
> were more efficient - you'd run into shitloads over overhead due to
> them beeing non-contingous like calling vmap all over the place,
> reprogramming iommus to at least make them look virtually contingous [1],
> etc..

I still think hardware should work reasonably well with 4K pages. The
SGI io controllers and/or the Linux block layer that doesn't allow more
than 128 sg entries is clearly suboptimal if the hardware runs twice as
fast with 2MB submissions.


> I also don't quite get what your problem with higher order allocations
> are.  order 1 allocations are generally just fine, and in fact
> thread stacks are >= oder 1 on most architectures.  And if the pagecache
> uses higher order allocations that means we'll finally fix our problems
> with them, which we have to do anyway.  Workloads continue to grow and
> with them the kernel overhead to manage them, while the pagesize for
> many architectures is fixed.  So we'll have to deal with order 1
> and order 2 allocations better just for backing kmalloc and co.

The pagecache is much bigger and often a lot more activity than these
other things though. Also, the more things you add to higher order
allocations, the more pressure you have.

I like PAGE_SIZE pagecache, because it is reliable and really fast, if
you need to reclaim a page it should be almost O(1).


> Or think jumboframes for that matter.

They can actually run into problems if the hardware wants contiguous
memory.

I don't know why you think the fragmentation issues are just magically
fixed. It is hard and inefficient to reclaim larger order blocks (even
with lumpy reclaim), and Mel's patches aren't perfect. Actually, last
time I looked, they needed to keep at least 16MB of pages free to be
reasonably effective (or do we just say that people with less than XMB
of memory shouldn't be accessing these filesystems anyway?), and I'm
not sure if they have been tested for long term stability in the
presence of a reasonable amount of higher order allocations.

-- 
SUSE Labs, Novell Inc.
