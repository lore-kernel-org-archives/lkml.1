Return-Path: <linux-kernel-owner+w=401wt.eu-S1031045AbXDZOj6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031045AbXDZOj6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 10:39:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754582AbXDZOj6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 10:39:58 -0400
Received: from holomorphy.com ([66.93.40.71]:59695 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754811AbXDZOj5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 10:39:57 -0400
Date: Thu, 26 Apr 2007 07:40:17 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: David Chinner <dgc@sgi.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, clameter@sgi.com,
       linux-kernel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
Message-ID: <20070426144017.GF19966@holomorphy.com>
References: <20070424222105.883597089@sgi.com> <m1hcr3oi0m.fsf@ebiederm.dsl.xmission.com> <46303A98.9000605@yahoo.com.au> <20070426063830.GE32602149@melbourne.sgi.com> <m1k5vzmoo7.fsf@ebiederm.dsl.xmission.com> <20070426135033.GU65285596@melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070426135033.GU65285596@melbourne.sgi.com>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2007 at 04:10:32AM -0600, Eric W. Biederman wrote:
>> You have HW_PAGE_SIZE != PAGE_SIZE.

On Thu, Apr 26, 2007 at 11:50:33PM +1000, David Chinner wrote:
> That's rather wasteful, though. Better to only use the large pages
> when the filesystem needs them rather than penalise all filesystems.

I found less of an issue with filesystem pagecache than with internal
fragmentation of anonymous memory when I did it. I'd expect, though,
that 4KB is probably too small and 64KB too large, at least for some
workloads. 16KB may do better; if not, 8KB may be worth doing just to
compensate for the larger sizes of pointers and unsigned longs in
struct page with respect to memory overhead so as not to regress vs.
32-bit, which isn't critical, but does have some cache and other
performance impacts.

Basically I found that without some intelligent method of divvying
out fragments of anonymous pages, pathological performance resulted.
The naive scheme of faulting at PAGE_SIZE-aligned boundaries created
swapstorms on memory-constrained hardware (e.g. laptops). Pagecache
was a second-order effect. It's not necessarily all that complex to
handle. One could easily recover the PAGE_SIZE == MMUPAGE_SIZE
behavior by keeping partially utilized anonymous pages cached in the mm
and handing out MMUPAGE_SIZE-sized fragments during COW/zerofill faults.
I had some sort of trouble with tracking the state for it, though I
don't remember what it was.

It's also notable that the two strategies (increasing base page size
and dealing with higher-order pages) don't clash all that much.


-- wli
