Return-Path: <linux-kernel-owner+w=401wt.eu-S1750850AbXCCXpy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750850AbXCCXpy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 18:45:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750925AbXCCXpx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 18:45:53 -0500
Received: from smtp.osdl.org ([65.172.181.24]:49558 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750850AbXCCXpx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 18:45:53 -0500
Date: Sat, 3 Mar 2007 15:45:41 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: bert hubert <bert.hubert@netherlabs.nl>
Cc: Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: userspace pagecache management tool
Message-Id: <20070303154541.70aed9df.akpm@linux-foundation.org>
In-Reply-To: <20070303230155.GA475@outpost.ds9a.nl>
References: <20070303122935.f1ab0067.akpm@linux-foundation.org>
	<45E9DD4A.2060806@redhat.com>
	<20070303131204.6706a95c.akpm@linux-foundation.org>
	<45E9E910.2070804@redhat.com>
	<20070303214108.GA28961@outpost.ds9a.nl>
	<20070303141448.1ed70e6d.akpm@linux-foundation.org>
	<45E9F454.2080600@redhat.com>
	<20070303142609.d3bc9cc3.akpm@linux-foundation.org>
	<20070303230155.GA475@outpost.ds9a.nl>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 4 Mar 2007 00:01:55 +0100 bert hubert <bert.hubert@netherlabs.nl> wrote:

> On Sat, Mar 03, 2007 at 02:26:09PM -0800, Andrew Morton wrote:
> > > > It is *not* a global instruction.  It uses setenv, so the user's policy
> > > > affects only the target process and its forked children.
> > > 
> > > ... and all other processes accessing the same file(s)!
> > > 
> > > Your library and the system calls may be limited to one process,
> > > but the consequences are global.
> > 
> > Yes.  So what?  If the user wants to go and evict libc.so from pagecache
> > then he can do so - the kernel has provided syscalls with which this can be
> > done for at least seven years.  Bad user, shouldn't do that.
> 
> While I agree with your sentiments that userspace can have a good idea on
> how to deal with the page cache, your program does more than it claims to
> do - because of how linux implements posix_fadvise.
> 
> I don't think anybody expects or desires your program to actually *evict*
> the stuff from the cache you are trying access, which happens in case the
> data was in the cache prior to starting your program.
> 
> What people expect is that a solution such as you wrote it simply won't
> *add* anything to the cache. They don't expect it will actually globally
> *remove* stuff from the cache.
> 
> Making a backup this way would hurt even worse than usual with your
> pagecache management tool if the file being backupped was still being read.
> 
> This is not your fault, but in practice, it makes your program less useful
> than it could be.

yup.  As I said, it's a proof-of-concept.  It's a project.  And I have about one
free femtosecond per fortnight :(

> One could conceivably fix that up using mincore and simply not fadvise if a
> page was in core already.

Yes.  Let's flesh it out the backup program policy some more:

- Unconditionally invalidate output files

- on entry to read(), probe pagecache, record which pages in the range are present

- on entry to next read(), shoot down those pages from the previous read
  which weren't in pagecache.

- But we can do better!  LRU the page's files up to a certain number of pages.

- Once that point is exceeded, we need to reclaim some pages.  Which
  ones?  Well, we've been observing all reads, so we can record which pages
  were referenced once, and which ones were referenced multiple times so we
  can do arbitrarily complex page aging in there.

- On close(), nuke all pages which weren't in core during open(), even if
  this app referenced them multiple times.

- If the backup program decided to read its input files with mmap we're
  rather screwed.  We can't intercept pagefaults so the best we can do is
  to restore the file's pagecache to its previous state on close().

  Or if it's really a problem, get control in there somehow and
  periodically poll the pagecache occupancy via mincore(), use madvise()
  then fadvise() to trim it back.

That all sounds reasonably doable.  It'd be pretty complex to do it
in-kernel but we could do it there too.  Problem is if course that the
above strategy is explicitly optimised for the backup program and if it's
in-kernel it becomes applicable to all other workloads.


