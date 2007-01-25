Return-Path: <linux-kernel-owner+w=401wt.eu-S1030565AbXAYVQ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030565AbXAYVQ7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 16:16:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030575AbXAYVQ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 16:16:59 -0500
Received: from waste.org ([66.93.16.53]:47385 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030565AbXAYVQ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 16:16:58 -0500
Date: Thu, 25 Jan 2007 15:04:29 -0600
From: Matt Mackall <mpm@selenic.com>
To: Chris Rankin <rankincj@yahoo.com>
Cc: Mark Rustad <mrustad@gmail.com>, Alan <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.18-stable release plans?
Message-ID: <20070125210428.GA16722@waste.org>
References: <4238B011-A417-41DE-8998-01BAAA484486@gmail.com> <999038.34946.qm@web52908.mail.yahoo.com> <20070124231153.6bc04063@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070124231153.6bc04063@localhost.localdomain>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 24, 2007 at 11:11:53PM +0000, Alan wrote:
> > I am going to assume that you are being facaetious, because it would be the rarified pinnacle of
> > supreme arrogance to suggest that a cosmic ray event is a more likely explanation than a bug in
> > the kernel.
> 
> A one off non repeatable error experienced by two people out of the
> millions using it does fit the cosmic ray description quite well. That's
> not to say there isn't a bug, but you don't have enough data to even
> begin debugging it unless its rather more reproducable.

The soft error rate (cosmic rays, alpha decay, etc.) for modern memory
at sea level is estimated to be somewhere around 1000 - 5000
FIT/Mbit[1]. FIT is Failures in Time - errors per billion hours of
use. If you've got 1GB of memory, you've got 8000Mbits. So you'd
expect 8M - 40M errors per billion hours on your machine. Or 8 to 40
errors per 1000 hours. That's about one single-bit error per week to
one per day.

Yes, that's a lot. Can it really be that high? Big supercomputer
installations actually measure it in errors per day or hour.

Most of these errors will go completely unnoticed because they happen
in data structures that aren't revisited (stale cache, unused code,
empty memory). The remainder will often look like random disk read or
write errors or random application bugs/crashes. Sound familiar? That's why
people buy ECC memory.

Now if we say that 10% of of that 1GB of RAM (~100MB) is kernel code/data
(not including page cache) and that, say, 1-10% of errors trigger
BUG/WARN code, we'll see these bug messages once every 100 days to
once every 1000 weeks (per GB per user).

As for the relative error rate vs kernel bugs - there are no shortage
of Linux boxes with trouble-free uptimes much longer than the 100 days
above.

So yes, if a user reports a bug that's attributable to a single bit
memory error that's otherwise unreproduced and unexplained, it's
totally reasonable to chalk it up to cosmic rays until some sort of
pattern of reports emerges.

As for your particular bug:

 Eeek! page_mapcount(page) went negative! (-1)
  page->flags = 14
  page->count = 0
  page->mapping = 00000000

This check occurs whenever the last mapping is removed from a page.
It's a very heavily used piece of code. The check is there as
sanity-checking from when this logic was introduced. If there were a
new bug here that could be triggered by gcc or telnet, odds are very
good that it would trigger for TONS of people.

So more likely theories are: a) pointer scribble from something
completely unrelated or b) cosmic rays. As the nearby data (flags,
count, mapping) doesn't appear to be scribbled on, (a) looks less
promising. 

[1] http://www.tezzaron.com/about/papers/soft_errors_1_1_secure.pdf

-- 
Mathematics is the supreme nostalgia of our time.
