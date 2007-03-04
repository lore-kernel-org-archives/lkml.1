Return-Path: <linux-kernel-owner+w=401wt.eu-S1751376AbXCDBCr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751376AbXCDBCr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 20:02:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751377AbXCDBCr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 20:02:47 -0500
Received: from smtp.osdl.org ([65.172.181.24]:50645 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751376AbXCDBCq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 20:02:46 -0500
Date: Sat, 3 Mar 2007 17:02:37 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: userspace pagecache management tool
Message-Id: <20070303170237.31d26382.akpm@linux-foundation.org>
In-Reply-To: <45EA0C3D.1010001@redhat.com>
References: <20070303122935.f1ab0067.akpm@linux-foundation.org>
	<45E9DD4A.2060806@redhat.com>
	<20070303131204.6706a95c.akpm@linux-foundation.org>
	<45E9E910.2070804@redhat.com>
	<20070303140744.b22699dd.akpm@linux-foundation.org>
	<45E9F5DA.2070708@redhat.com>
	<20070303145221.2a42cc0f.akpm@linux-foundation.org>
	<45EA0C3D.1010001@redhat.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 03 Mar 2007 19:01:01 -0500 Rik van Riel <riel@redhat.com> wrote:

> Andrew Morton wrote:
> > On Sat, 03 Mar 2007 17:25:30 -0500 Rik van Riel <riel@redhat.com> wrote:
> > 
> >> backup program
> > 
> > A suitable policy for a backup program would probably be to invalidate any
> > output file(s) and to invalidate those pages of the input files which were
> > not in cache when the backup program first opened those files.  That way
> > the backup program will have no effect on the cache state, except for the
> > race situation where someone read an uncached file while the backup program
> > was reading from it too.
> 
> The use-once policy we have in the kernel should work
> perfectly fine for backups.  All we need to do is
> actually honor the accessed bit on active page cache
> pages, instead of flushing them onto the inactive
> list.
> 
> What am I overlooking?

That'll improve backups but will break other things.

To do this effectively we'd need to change the policy so that new pagecache
allocations cause no scanning of used-twice pages at all.  So that even
after many gigs of backing up, the working set is still there.

Problem is, (for example) what about the person who has 80% of memory in
used-twice state and who then reads a file or files which are 20% or more of
the size of memory, two or more times.  It'll be 100% cache misses, every time.
This will happen quite a lot.  IOW, once those pages are in used-twice state,
how does further pagecache activity ever get them _out_ of that state?  Only
by joining the used-twice page set, and that can't happen if the used-once-so-far
pages got reclaimed.

Doing a refault thing would help a bit, but stops working at a certain point.


> > This can be added in an hour or two with no kernel changes (use mincore).
> 
> mincore only works for mmaped areas, we'd need an fincore
> to work with file handles.

The LD_PRELOAD code has the fd and can mmap it to perform the pagecache
probe.

fincore() would be a bit neater, but given the rarity with which mincore()
is used it's perhaps hard to justify adding a slightly more efficient and
slightly more convenient subset of mincore().

