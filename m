Return-Path: <linux-kernel-owner+w=401wt.eu-S1757572AbZDWQnx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757572AbZDWQnx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 12:43:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757399AbZDWQng
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 12:43:36 -0400
Received: from mail2.shareable.org ([80.68.89.115]:34167 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756832AbZDWQne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 12:43:34 -0400
Date: Thu, 23 Apr 2009 17:43:30 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Theodore Tso <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>,
       Valerie Aurora Henson <vaurora@redhat.com>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Chris Mason <chris.mason@oracle.com>, Eric Sandeen <sandeen@redhat.com>,
       Ric Wheeler <rwheeler@redhat.com>
Subject: Re: [RFC PATCH] fpathconf() for fsync() behavior
Message-ID: <20090423164330.GA9399@shareable.org>
References: <20090423001257.GA16540@shell> <20090422221748.8c9022d1.akpm@linux-foundation.org> <20090423112105.GA1589@shareable.org> <20090423124230.GF2723@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090423124230.GF2723@mit.edu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso wrote:
> On Thu, Apr 23, 2009 at 12:21:05PM +0100, Jamie Lokier wrote:
> > Maybe it's time to do fsync properly?
> 
> Application writers don't care about OS portability (it only has to
> work on Linux), or working on multiple filesystems (it only has work
> on ext3, and any filesystems which doesn't do automagic fsync's at the
> right magic times automagically is broken by design).  This includes
> many GNOME and KDE developers.  So as we concluded at the filesystem
> and storage workshop, we probably will have to keep automagic
> hueristics out there, for all of the broken applications.  Heck, Linus
> even refused to call those applications "broken".

Sure, most apps are low quality in all respects. Many don't care about
a bit of corruption when the battery runs out.  There's no pressure to
get that right, and it's quite hard to get right without good practice
to follow, and good APIs which encourage good practice naturally.

Imho, the rename-automagic-safety rule now in ext3/4 is _better_ than
requiring apps to call fsync, because it doesn't require an immediate,
synchronous disk flush and hardware cache flush.  Fsync requires those
things, to be useful for databases and mail servers.  If you're
renaming a lot of files, 1000s of explicit fsyncs serialises badly on
rotating media.

> So we can create a more finer-grained controlled system call ---
> although I would suggest that we just add some extra flags to
> sync_file_range() --- but it's doubtful that many application
> programmers will use it.

I proposed some flags to sync_file_range() last year, and got very
little response.  Mind you there's been a lot of fsync issues coming
up since then, so maybe it stirred something :-)

sync_file_range() itself is just too weird to use.  Reading the man
page many times, I still couldn't be sure what it does or is meant to
do until asking on l-k a few years ago.  My guess, from reading the
man page, turned out to be wrong.  The recommended way to use it for a
database-like application was quite convoluted and required the app to
apply its own set of mm-style heuristics.  I never did find out if it
commits data-locating metadata and file size after extending a file or
filling a hole.  It never seemed to emit I/O barriers.

Does anything at all use it?  Maybe sync_file_range() can be improved
though.

I hold more hope for Nick Piggins work on fsync_range() - which at
least is comprehensible :-)

It says something that instead of writing a small wrapper around
sync_file_range() which is _supposed_ to be usable as range fsync, and
fixing sync_file_range() to behave properly, Nick found it easier to
start a separate implementation :-)

-- Jamie
