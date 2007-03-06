Return-Path: <linux-kernel-owner+w=401wt.eu-S1751349AbXCFVlF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751349AbXCFVlF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 16:41:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751366AbXCFVlF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 16:41:05 -0500
Received: from smtp.osdl.org ([65.172.181.24]:59759 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751349AbXCFVlC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 16:41:02 -0500
Date: Tue, 6 Mar 2007 13:40:46 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: =?ISO-8859-1?Q?P=E1draig?= Brady <P@draigBrady.com>
Cc: bert hubert <bert.hubert@netherlabs.nl>, Rik van Riel <riel@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: userspace pagecache management tool
Message-Id: <20070306134046.5be821f5.akpm@linux-foundation.org>
In-Reply-To: <45ED5A49.1010702@draigBrady.com>
References: <20070303122935.f1ab0067.akpm@linux-foundation.org>
	<45E9DD4A.2060806@redhat.com>
	<20070303131204.6706a95c.akpm@linux-foundation.org>
	<45E9E910.2070804@redhat.com>
	<20070303214108.GA28961@outpost.ds9a.nl>
	<20070303141448.1ed70e6d.akpm@linux-foundation.org>
	<45E9F454.2080600@redhat.com>
	<20070303142609.d3bc9cc3.akpm@linux-foundation.org>
	<20070303230155.GA475@outpost.ds9a.nl>
	<20070303154541.70aed9df.akpm@linux-foundation.org>
	<45ED5A49.1010702@draigBrady.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 06 Mar 2007 12:10:49 +0000
P__draig Brady <P@draigBrady.com> wrote:

> Andrew Morton wrote:
> > Yes.  Let's flesh it out the backup program policy some more:
> > 
> > - Unconditionally invalidate output files
> > 
> > - on entry to read(), probe pagecache, record which pages in the range are present
> > 
> > - on entry to next read(), shoot down those pages from the previous read
> >   which weren't in pagecache.
> > 
> > - But we can do better!  LRU the page's files up to a certain number of pages.
> > 
> > - Once that point is exceeded, we need to reclaim some pages.  Which
> >   ones?  Well, we've been observing all reads, so we can record which pages
> >   were referenced once, and which ones were referenced multiple times so we
> >   can do arbitrarily complex page aging in there.
> > 
> > - On close(), nuke all pages which weren't in core during open(), even if
> >   this app referenced them multiple times.
> > 
> > - If the backup program decided to read its input files with mmap we're
> >   rather screwed.  We can't intercept pagefaults so the best we can do is
> >   to restore the file's pagecache to its previous state on close().
> > 
> >   Or if it's really a problem, get control in there somehow and
> >   periodically poll the pagecache occupancy via mincore(), use madvise()
> >   then fadvise() to trim it back.
> > 
> > That all sounds reasonably doable.  It'd be pretty complex to do it
> > in-kernel but we could do it there too.  Problem is if course that the
> > above strategy is explicitly optimised for the backup program and if it's
> > in-kernel it becomes applicable to all other workloads.
> 
> I can see the above being possible, but I can't see the reason
> for exposing that complexity to userspace.

That's sophistication, not complexity.  It doesn't have to do all that stuff
to be effective.

> If I'm the target
> audience for that API then it's broken as I'd mess it up,
> or would take too long to get it right.
> 
> Can't we just fix the posix_fadvise() implementation to
> only evict pages paged in by the current process.

The kernel doesn't have that information.

> Perhaps one could possibly just evict pages with _mapcount==0 ?

That is the present fadvise(FADV_DONTNEED) behaviour.
