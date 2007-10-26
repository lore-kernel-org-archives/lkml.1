Return-Path: <linux-kernel-owner+w=401wt.eu-S1765553AbXJZWa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765553AbXJZWa1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 18:30:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757211AbXJZWaN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 18:30:13 -0400
Received: from tetsuo.zabbo.net ([207.173.201.20]:39432 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757190AbXJZWaM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 18:30:12 -0400
Message-ID: <47226A75.1020008@oracle.com>
Date: Fri, 26 Oct 2007 15:30:13 -0700
From: Zach Brown <zach.brown@oracle.com>
User-Agent: Thunderbird 2.0.0.6 (Macintosh/20070728)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Karl Schendel <kschendel@datallegro.com>,
       Zach Brown <zach.brown@oracle.com>, Benjamin LaHaise <bcrl@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Leonid Ananiev <leonid.i.ananiev@linux.intel.com>,
       Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] Fix bad data from non-direct-io read after direct-io
 write
References: <47225835.4050309@datallegro.com> <alpine.LFD.0.999.0710261425240.30120@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0710261425240.30120@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> Hmm. If I read this right, this bug seems to have been introduced by 
> commit 65b8291c4000e5f38fc94fb2ca0cb7e8683c8a1b ("dio: invalidate clean 
> pages before dio write") back in March.

Agreed.  And it's a really dumb bug.  ->direct_io will almost always
return -EIOCBQUEUED for aio dio so it won't be invalidating for aio dio
writes.  (Notice that the testing in that commit mentions two racing
processes, I bet U$1M that I only tested sync dio :/)

I think that test should be changed to

  if (retval < 0 && retval != -EIOCBQUEUED)
	goto out;


> However, with both the old and the new code _and_ with your patch, the 
> return code - in case the invalidate failed - was corrupted. So we may 
> actually end up doing some IO, but then returning the "wrong" error code 
> from the invalidate. Hmm?

If the invalidation fails then the app is left with stale data in the
page cache and current data on disk.  The return code corruption you're
referring to was intended to communicate this scary situation to the app
with EIO.

It sucks.  Does it suck more than returning success for the dio write
when later buffered reads will return stale data?  I dunno.  What does
the peanut gallery think?

> And maybe some day we can all agree that direct_IO is crap and should not 
> be done.

Chris (Mason) and I certainly love the idea of getting rid of
fs/direct-io.c.  Getting O_DIRECT working with the page-granular
buffered locking rules while doing large IOs (and, as far as I know,
potentially sector-granular) without noticeable performance regressions
is a mess.

- z
