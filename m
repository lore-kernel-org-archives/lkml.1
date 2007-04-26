Return-Path: <linux-kernel-owner+w=401wt.eu-S964932AbXDZPUS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964932AbXDZPUS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 11:20:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031266AbXDZPUR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 11:20:17 -0400
Received: from smtp104.mail.mud.yahoo.com ([209.191.85.214]:20336 "HELO
	smtp104.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S964932AbXDZPUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 11:20:16 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=2XHRiRNXJWmrPX0gYfoPbdDlleyGO6lB7/nSJum64AA5Nyjtp+cC0EnUW4rRT5dVq38DbkoYTclac2gUrUgdn/mqyA8y1ABhlK5jL5+kkKOyy70gZBuY6QpAnCezimqors1yaEn3fzGiA7Odqa3ym9dxMMRUtYU8sme+CAqLuc8=  ;
X-YMail-OSG: NqaQ36wVM1nM18zbzPEn69sX0nZ8CL5NSda.cL.4SVIJLiMP
Message-ID: <4630C326.2030906@yahoo.com.au>
Date: Fri, 27 Apr 2007 01:20:06 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: David Chinner <dgc@sgi.com>
CC: Christoph Lameter <clameter@sgi.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
References: <m1hcr3oi0m.fsf@ebiederm.dsl.xmission.com> <Pine.LNX.4.64.0704252154250.29271@schroedinger.engr.sgi.com> <m1abwvofke.fsf@ebiederm.dsl.xmission.com> <463048FE.5000600@yahoo.com.au> <Pine.LNX.4.64.0704252341560.30340@schroedinger.engr.sgi.com> <46304D50.1040706@yahoo.com.au> <Pine.LNX.4.64.0704260008280.30731@schroedinger.engr.sgi.com> <46305327.2000206@yahoo.com.au> <Pine.LNX.4.64.0704260028190.31003@schroedinger.engr.sgi.com> <4630593C.8070905@yahoo.com.au> <20070426092014.GT65285596@melbourne.sgi.com>
In-Reply-To: <20070426092014.GT65285596@melbourne.sgi.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Chinner wrote:
> On Thu, Apr 26, 2007 at 05:48:12PM +1000, Nick Piggin wrote:
> 
>>Christoph Lameter wrote:
>>
>>>On Thu, 26 Apr 2007, Nick Piggin wrote:
>>>
>>>
>>>
>>>>No I don't want to add another fs layer.
>>>
>>>
>>>Well maybe you could explain what you want. Preferably without redefining 
>>>the established terms?
>>
>>Support for larger buffers than page cache pages.
> 
> 
> The problem with this approach is that it turns around the whole
> way we look at bufferheads. Right now we have well defined 1:n
> mapping of page to bufferheads and so we tpyically lock the
> page first them iterate all the bufferheads on the page.
> 
> Going the other way, we need to support m:n which we means
> the buffer has to become the primary interface for the filesystem
> to the page cache. i.e. we need to lock the bufferhead first, then
> iterate all the pages on it. This is messy because the cache indexes
> via pages, not bufferheads. hence a buffer needs to point to all the
> pages in it explicitly, and this leads to interesting issues with
> locking.
> 
> If you still think that this is a good idea, I suggest that you

Yeah, I think it possibly is. But I don't think that much of the
vm should need to be touched at all, especially not mmap. And I
think only those filesystems interested in supporting it would
have to implement it (maybe a couple), not all of them.

I didn't run into all the issues you mentioned yet, and I don't
see why it would have to turn into a real (traditional) buffer
cache layer rather than just a Linux (ie. block mapping) buffer
layer.


>>So block size > page cache size... also, you should obviously be using
>>hardware that is tuned to work well with 4K pages, because surely there
>>is lots of that around.
> 
> 
> The CPU hardware works well with 4k pages, but in general I/O
> hardware works more efficiently as the numbers of s/g entries they
> require drops for a given I/O size. Given that we limit drivers to
> 128 s/g entries, we really aren't using I/O hardware to it's full
> potential or at it's most efficient by limiting each s/g entry to a
> single 4k page.
> 
> And FWIW, a having a buffer for block size > page size does not
> solve this problem - only contiguous page allocation solves this
> problem.

But this seems to be due to your final IO request size, rather than
the number of sg entries the card has to process, right? My point
is that MMUs and the whole memory and data transfer system is quite
likely to be optimised for 4K pages, so it would be strange to think
that an IO card could not do that.

Why do we limit drivers to 128 sg entries?

-- 
SUSE Labs, Novell Inc.
