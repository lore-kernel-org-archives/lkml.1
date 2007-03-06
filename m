Return-Path: <linux-kernel-owner+w=401wt.eu-S933233AbXCFMNq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933233AbXCFMNq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 07:13:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934091AbXCFMNp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 07:13:45 -0500
Received: from mail.station1.mxsweep.com ([212.147.136.149]:3712 "EHLO
	blue.mxsweep.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933233AbXCFMNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 07:13:44 -0500
Message-ID: <45ED5A49.1010702@draigBrady.com>
Date: Tue, 06 Mar 2007 12:10:49 +0000
From: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>
User-Agent: Thunderbird 1.5.0.8 (X11/20061116)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: bert hubert <bert.hubert@netherlabs.nl>, Rik van Riel <riel@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: userspace pagecache management tool
References: <20070303122935.f1ab0067.akpm@linux-foundation.org>	<45E9DD4A.2060806@redhat.com>	<20070303131204.6706a95c.akpm@linux-foundation.org>	<45E9E910.2070804@redhat.com>	<20070303214108.GA28961@outpost.ds9a.nl>	<20070303141448.1ed70e6d.akpm@linux-foundation.org>	<45E9F454.2080600@redhat.com>	<20070303142609.d3bc9cc3.akpm@linux-foundation.org>	<20070303230155.GA475@outpost.ds9a.nl> <20070303154541.70aed9df.akpm@linux-foundation.org>
In-Reply-To: <20070303154541.70aed9df.akpm@linux-foundation.org>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Mlf-Version: 5.0.2.8415
X-Mlf-UniqueId: o200703061216200093761
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> Yes.  Let's flesh it out the backup program policy some more:
> 
> - Unconditionally invalidate output files
> 
> - on entry to read(), probe pagecache, record which pages in the range are present
> 
> - on entry to next read(), shoot down those pages from the previous read
>   which weren't in pagecache.
> 
> - But we can do better!  LRU the page's files up to a certain number of pages.
> 
> - Once that point is exceeded, we need to reclaim some pages.  Which
>   ones?  Well, we've been observing all reads, so we can record which pages
>   were referenced once, and which ones were referenced multiple times so we
>   can do arbitrarily complex page aging in there.
> 
> - On close(), nuke all pages which weren't in core during open(), even if
>   this app referenced them multiple times.
> 
> - If the backup program decided to read its input files with mmap we're
>   rather screwed.  We can't intercept pagefaults so the best we can do is
>   to restore the file's pagecache to its previous state on close().
> 
>   Or if it's really a problem, get control in there somehow and
>   periodically poll the pagecache occupancy via mincore(), use madvise()
>   then fadvise() to trim it back.
> 
> That all sounds reasonably doable.  It'd be pretty complex to do it
> in-kernel but we could do it there too.  Problem is if course that the
> above strategy is explicitly optimised for the backup program and if it's
> in-kernel it becomes applicable to all other workloads.

I can see the above being possible, but I can't see the reason
for exposing that complexity to userspace. If I'm the target
audience for that API then it's broken as I'd mess it up,
or would take too long to get it right.

Can't we just fix the posix_fadvise() implementation to
only evict pages paged in by the current process.
Perhaps one could possibly just evict pages with _mapcount==0 ?

cheers,
Pádraig.
