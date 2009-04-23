Return-Path: <linux-kernel-owner+w=401wt.eu-S1756747AbZDWRa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756747AbZDWRa3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 13:30:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756385AbZDWR3k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 13:29:40 -0400
Received: from thunk.org ([69.25.196.29]:36798 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756395AbZDWR3i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 13:29:38 -0400
Date: Thu, 23 Apr 2009 13:29:25 -0400
From: Theodore Tso <tytso@mit.edu>
To: Jamie Lokier <jamie@shareable.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Valerie Aurora Henson <vaurora@redhat.com>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Chris Mason <chris.mason@oracle.com>, Eric Sandeen <sandeen@redhat.com>,
       Ric Wheeler <rwheeler@redhat.com>
Subject: Re: [RFC PATCH] fpathconf() for fsync() behavior
Message-ID: <20090423172925.GL2723@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Jamie Lokier <jamie@shareable.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Valerie Aurora Henson <vaurora@redhat.com>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	Chris Mason <chris.mason@oracle.com>,
	Eric Sandeen <sandeen@redhat.com>,
	Ric Wheeler <rwheeler@redhat.com>
References: <20090423001257.GA16540@shell> <20090422221748.8c9022d1.akpm@linux-foundation.org> <20090423112105.GA1589@shareable.org> <20090423124230.GF2723@mit.edu> <20090423164330.GA9399@shareable.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090423164330.GA9399@shareable.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 23, 2009 at 05:43:30PM +0100, Jamie Lokier wrote:
> Sure, most apps are low quality in all respects. Many don't care about
> a bit of corruption when the battery runs out.  There's no pressure to
> get that right, and it's quite hard to get right without good practice
> to follow, and good APIs which encourage good practice naturally.
> 
> Imho, the rename-automagic-safety rule now in ext3/4 is _better_ than
> requiring apps to call fsync, because it doesn't require an immediate,
> synchronous disk flush and hardware cache flush.  Fsync requires those
> things, to be useful for databases and mail servers.  If you're
> renaming a lot of files, 1000s of explicit fsyncs serialises badly on
> rotating media.

Well, some KDE deskops rewrites *hundreds* of files on on startup, and
users get very cranky when their window layouts, for which they have
spent *hours* optimizing just so, get lost on application crash.  (It
doesn't help that KDE was rewriting files even though nothing had
changed.... I can't remember if it was via rename or truncate, but I
have a bad feeling it was via truncate.)

> sync_file_range() itself is just too weird to use.  Reading the man
> page many times, I still couldn't be sure what it does or is meant to
> do until asking on l-k a few years ago.  My guess, from reading the
> man page, turned out to be wrong.  The recommended way to use it for a
> database-like application was quite convoluted and required the app to
> apply its own set of mm-style heuristics.  I never did find out if it
> commits data-locating metadata and file size after extending a file or
> filling a hole.  It never seemed to emit I/O barriers.

Have you looked at the man page for sync_file_range()?  It's gotten a
lot better.  My version says it was last updated 2008-05-27, and it
now answers your question about whether it commits data-locating
metadata (it doesn't).  It now has a bunch of examples how how to use
the flags in combination.

In terms of making it easier to use, some predefined bitfield
combinations is all that's necessary.

As far as extending the implementation so it calls into filesystem to
commit data-locating metadata, and other semantics such as "flush on
next commit, or "flush-when-upcoming-metadata-changes-such-as-a-rename", 
we might need to change the implementation somewhat (or a lot).

But the interface does make a lot of sense.  (But maybe that's because
I've spent too much time staring at all of the page writeback call
paths, and compared to that even string theory is pretty simple.  :-)

       	   	       	    	 	       - Ted
