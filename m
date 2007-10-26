Return-Path: <linux-kernel-owner+w=401wt.eu-S1761491AbXJZXiq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761491AbXJZXiq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 19:38:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751933AbXJZXih
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 19:38:37 -0400
Received: from tetsuo.zabbo.net ([207.173.201.20]:46180 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751792AbXJZXig (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 19:38:36 -0400
Message-ID: <47227A7E.70903@oracle.com>
Date: Fri, 26 Oct 2007 16:38:38 -0700
From: Zach Brown <zach.brown@oracle.com>
User-Agent: Thunderbird 2.0.0.6 (Macintosh/20070728)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Karl Schendel <kschendel@datallegro.com>,
       Benjamin LaHaise <bcrl@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Leonid Ananiev <leonid.i.ananiev@linux.intel.com>,
       Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] Fix bad data from non-direct-io read after direct-io
 write
References: <47225835.4050309@datallegro.com> <alpine.LFD.0.999.0710261425240.30120@woody.linux-foundation.org> <47226A75.1020008@oracle.com> <alpine.LFD.0.999.0710261541410.30120@woody.linux-foundation.org> <47227015.6060708@oracle.com> <alpine.LFD.0.999.0710261611511.30120@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0710261611511.30120@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Fri, 26 Oct 2007, Zach Brown wrote:
>> I can throw together a patch if you haven't already committed one by the
>> time you read this ;).
> 
> I'm not touching that code except to send out possible patches for others 
> to test and comment on. I have no test-cases, nor any real interest in it. 
> So yeah, please send me a tested and thought-through patch.

Sure thing.  It looks like Karl just sent out the patch I had in mind,
so I'll run it through the tests on Monday.  I assume everyone can
handle waiting that long.

> It sounded like Karl actually had a test-case to trigger this, but maybe 
> I'm confused (and it sounds a bit unlikely, since it should be hard to 
> trigger..

It's disappointingly easy to trigger with ext3 and ordered extending
writes.  The invalidation can race with jbd pinning the bhs while it
commits the transaction.  It happens that ext3 returns failure from
->releasepage if jbd is committing the transaction.

http://git.kernel.org/?p=linux/kernel/git/zab/aio-dio-regress.git;a=blob;f=c/aio-dio-invalidate-failure.c

> Although maybe you can trigger it by doing a direct_IO write 
> with the *source* being an mmap() of the file you're writing to, and 
> depending on the write itself re-populating the destination in the page 
> cache?)

dio will definitely bring the page in with get_user_pages() but I'd like
to think that that pinned page could be safely invalidated out of the
page cache while dio holds a page reference.  I've never tried it, though.

- z
