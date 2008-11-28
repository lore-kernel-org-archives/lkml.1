Return-Path: <linux-kernel-owner+w=401wt.eu-S1753839AbYK1Jh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753839AbYK1Jh2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 04:37:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750906AbYK1JhS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 04:37:18 -0500
Received: from ns2.suse.de ([195.135.220.15]:36442 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750896AbYK1JhQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 04:37:16 -0500
Date: Fri, 28 Nov 2008 10:37:13 +0100
From: Nick Piggin <npiggin@suse.de>
To: Mike Waychison <mikew@google.com>
Cc: Ying Han <yinghan@google.com>, Ingo Molnar <mingo@elte.hu>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       akpm <akpm@linux-foundation.org>, David Rientjes <rientjes@google.com>,
       Rohit Seth <rohitseth@google.com>, Hugh Dickins <hugh@veritas.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "H. Peter Anvin" <hpa@zytor.com>, edwintorok@gmail.com
Subject: Re: [RFC v1][PATCH]page_fault retry with NOPAGE_RETRY
Message-ID: <20081128093713.GB1818@wotan.suse.de>
References: <604427e00811212247k1fe6b63u9efe8cfe37bddfb5@mail.gmail.com> <20081123091843.GK30453@elte.hu> <604427e00811251042t1eebded6k9916212b7c0c2ea0@mail.gmail.com> <20081126123246.GB23649@wotan.suse.de> <492DAA24.8040100@google.com> <20081127085554.GD28285@wotan.suse.de> <492E6849.6090205@google.com> <20081127130817.GP28285@wotan.suse.de> <492EEF0C.9040607@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <492EEF0C.9040607@google.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 27, 2008 at 11:03:40AM -0800, Mike Waychison wrote:
> Nick Piggin wrote:
> >On Thu, Nov 27, 2008 at 01:28:41AM -0800, Mike Waychison wrote:
> >>
> >>Török however identified mmap taking on the order of several 
> >>milliseconds due to this exact problem:
> >>
> >>http://lkml.org/lkml/2008/9/12/185
> >
> >Turns out to be a different problem.
> >
> 
> What do you mean?

His is just contending on the write side. The retry patch doesn't help.


> >>We generally try to avoid such things, but sometimes it a) can't be 
> >>easily avoided (third party libraries for instance) and b) when it hits 
> >>us, it affects the overall health of the machine/cluster (the monitoring 
> >>daemons get blocked, which isn't very healthy).
> >
> >Are you doing appropriate posix_fadvise to prefetch in the files before
> >faulting, and madvise hints if appropriate?
> >
> 
> Yes, we've been slowly rolling out fadvise hints out, though not to 
> prefetch, and definitely not for faulting.  I don't see how issuing a 
> prefetch right before we try to fault in a page is going to help 
> matters.  The pages may appear in pagecache, but they won't be uptodate 
> by the time we look at them anyway, so we're back to square one.

The whole point of a prefetch is to issue it sufficiently early so
it makes a difference. Actually if you can tell quite well where the
major faults will be, but don't know it sufficiently in advance to
do very good prefetching, then perhaps we could add a new madvise hint
to synchronously bring the page in (dropping the mmap_sem over the IO).

