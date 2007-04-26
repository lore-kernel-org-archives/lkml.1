Return-Path: <linux-kernel-owner+w=401wt.eu-S1754714AbXDZFhr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754714AbXDZFhr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 01:37:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754727AbXDZFhr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 01:37:47 -0400
Received: from smtp109.mail.mud.yahoo.com ([209.191.85.219]:31667 "HELO
	smtp109.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754714AbXDZFhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 01:37:46 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=gl2w+O5HjMyTXkm36TicpA4F0i2VtYDeIlvOuktdyJxE+cNVn5fXqkzvWzaecWTylMRa9G8DzUSm8ux90jBf0QHplli42eb4Raoh9Z3oiqFhN3kv2KKABulmkz9Gi4PGl4wkdZaeraZh89sMQz/2b2fJvdVW4mlMkGfKvBUsRQ8=  ;
Message-ID: <46303A98.9000605@yahoo.com.au>
Date: Thu, 26 Apr 2007 15:37:28 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: clameter@sgi.com, linux-kernel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
References: <20070424222105.883597089@sgi.com> <m1hcr3oi0m.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1hcr3oi0m.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> clameter@sgi.com writes:
> 
> 
>>V2->V3
>>- More restructuring
>>- It actually works!
>>- Add XFS support
>>- Fix up UP support
>>- Work out the direct I/O issues
>>- Add CONFIG_LARGE_BLOCKSIZE. Off by default which makes the inlines revert
>>  back to constants. Disabled for 32bit and HIGHMEM configurations.
>>  This also allows a gradual migration to the new page cache
>>  inline functions. LARGE_BLOCKSIZE capabilities can be
>>  added gradually and if there is a problem then we can disable
>>  a subsystem.
>>
>>V1->V2
>>- Some ext2 support
>>- Some block layer, fs layer support etc.
>>- Better page cache macros
>>- Use macros to clean up code.
>>
>>This patchset modifies the Linux kernel so that larger block sizes than
>>page size can be supported. Larger block sizes are handled by using
>>compound pages of an arbitrary order for the page cache instead of
>>single pages with order 0.
> 
> 
> Huh?
> 
> You seem to be mixing two very different concepts.
> 
> The page cache has no problems supporting things with a block
> size larger then page size.  Now the block device layer may not
> have the code to do the scatter gather into small pages and it
> may not handle buffer heads whose data is split between multiple
> pages. 

Yeah, this patch is not really large blocksize support (which we normally
think of as block size > page cache size).


> But this is not a page cache issue.
> 
> And generally larger physical pages are a mistake to use.
> Especially as it looks from some of the later comment you don't
> date test on 32bit because the memory fragments faster.

I actually completely agree with this, and I'm concerned in general about
using higher order pages. I think it is fundamentally the wrong approach
because of fragmentation and defragmentation costs (similarly to Linus's
take on page colouring).

I think starting with the assumption that we _want_ to use higher order
allocations, and then creating all this complexity around that is not a
good one, and if we start introducing things that _require_ significant
higher order allocations to function then it is a nasty thing for
robustness.


> Is it common for hardware that supports large block sizes to not
> support splitting those blocks apart during DMA?  Unless it is common
> the whole premise of this patchset seems broken.
> 
> I suspect what needs to be fixed is the page cache block device
> interface so that we have helper functions that know how to stuff
> a single block into several pages.

I am working now and again on some code to do this, it is a big job but
I think it is the right way to do it. But it would take a long time to
get stable and supported by filesystems...


> That would make the choice of using larger order pages (essentially
> increasing PAGE_SIZE) something that can be investigated in parallel.

I agree that hardware inefficiencies should be handled by increasing
PAGE_SIZE (not making PAGE_CACHE_SIZE > PAGE_SIZE) at the arch level.

-- 
SUSE Labs, Novell Inc.
