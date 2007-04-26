Return-Path: <linux-kernel-owner+w=401wt.eu-S933113AbXDZGu3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933113AbXDZGu3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 02:50:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933115AbXDZGu3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 02:50:29 -0400
Received: from smtp110.mail.mud.yahoo.com ([209.191.85.220]:36134 "HELO
	smtp110.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933114AbXDZGuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 02:50:20 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=5RolmQUxAxxaCKpn3Zu3gGq1jOLspvISfq4RVJxQo0irAQLPmxcshgZHFpigZlXQVjM74184Y9WW+k5coe5i0SErzTTVAu12lB0e2O9IHoT2hzhOy2PVqYaL9H/g5R0dDPwVB5pTKEp8Pp0TlMBZlpebUSUHg+XSQc+dw0Ab4XE=  ;
X-YMail-OSG: r9ZtJDUVM1lTOODIizzEjc.H1ostLn1w.t3idqsDcUopfsLEJg.JiWRr0TGq4k4b39K2D6kIZg--
Message-ID: <46304B9E.5070604@yahoo.com.au>
Date: Thu, 26 Apr 2007 16:50:06 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: David Chinner <dgc@sgi.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>, clameter@sgi.com,
       linux-kernel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
References: <20070424222105.883597089@sgi.com> <m1hcr3oi0m.fsf@ebiederm.dsl.xmission.com> <46303A98.9000605@yahoo.com.au> <20070426063830.GE32602149@melbourne.sgi.com>
In-Reply-To: <20070426063830.GE32602149@melbourne.sgi.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Chinner wrote:
> On Thu, Apr 26, 2007 at 03:37:28PM +1000, Nick Piggin wrote:
> 
>>I think starting with the assumption that we _want_ to use higher order
>>allocations, and then creating all this complexity around that is not a
>>good one, and if we start introducing things that _require_ significant
>>higher order allocations to function then it is a nasty thing for
>>robustness.
> 
> 
>>From my POV, we started with the problem of how to provide atomic
> access to a multi-page block in the page cache. For example, we want
> to lock the filesystem block and prevent any updates to it, so we
> need to lock all the pages in it. And then when we write them back,
> they all need to change state at the same time, and they all need to
> have their radix tree tags changed at the same time, the problem of
> mapping them to disk, getting writeback to do block aligned and
> sized writeback chunks, and so on.
> 
> And then there's the problem that most hardware is limited to 128
> s/g entries and that means 128 non-contiguous pages in memory is the
> maximum I/O size we can issue to these devices. We have RAID arrays
> that go twice as fast if we can send them 1MB I/Os instead of 512k
> I/Os and that means we need contiguous pages to be handled to the
> devices....
> 
> All of these things require some aggregating structure to
> co-ordinate. In times gone by on other OSs, this has been done with
> a buffer cache, but Linux got rid of that long ago and we don't want
> to reintroduce one. We can't use buffer heads - they can only point
> to one page. So what do we do?

Improving the buffer layer would be a good way. Of course, that is
a long and difficult task, so nobody wants to do it.


> That's where compound pages are so nice - they solve all of these
> problems with only a very small amount of code perturbation and they
> don't change any algorithms or fundamental design of the OS at all.
> 
> We don't have to rewrite filesystems to support this. We don't have
> to redesign the VM to support this. We don't have to do very much
> work to the block layer and drivers to make this work.

Fragmentation is the problem. The anti-frag patches don't actually
guarantee anything about fragmentation, and even if they did, then
it takes more effort to actually find and reclaim higher order
pages (even after the lumpy reclaim thing). So we've redesigned
the page allocator and page reclaim and still don't have something
that you should rely on without fallbacks.


> FWIW, if you want 32 bit machines to support larger than 16TB
> devices, you need high order page indexing in the page cache....

How about a 64-bit pgoff_t and radix-tree key? Or larger PAGE_SIZE?


>>I am working now and again on some code to do this, it is a big job but
>>I think it is the right way to do it. But it would take a long time to
>>get stable and supported by filesystems...
> 
> 
> Compared to a method that requires almost no change to the
> filesystems that want to support large block sizes?

Luckily we have filesystem maintainers who want to support larger
block sizes ;)


>>>That would make the choice of using larger order pages (essentially
>>>increasing PAGE_SIZE) something that can be investigated in parallel.
>>
>>I agree that hardware inefficiencies should be handled by increasing
>>PAGE_SIZE (not making PAGE_CACHE_SIZE > PAGE_SIZE) at the arch level.
> 
> 
> And what do we do for arches that can't do multiple page sizes, only
> only have a limited and mostly useless set of page sizes to choose
> from?

Well, for those architectures (and this would solve your large block
size and 16TB pagecache size without any core kernel changes), you
can manage 1<<order hardware ptes as a single Linux pte. There is
nothing that says you must implement PAGE_SIZE as a single TLB sized
page.

-- 
SUSE Labs, Novell Inc.
