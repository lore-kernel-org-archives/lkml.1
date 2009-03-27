Return-Path: <linux-kernel-owner+w=401wt.eu-S1760158AbZC0TdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760158AbZC0TdT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 15:33:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753166AbZC0TdF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 15:33:05 -0400
Received: from THUNK.ORG ([69.25.196.29]:50338 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752958AbZC0TdC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 15:33:02 -0400
Date: Fri, 27 Mar 2009 15:32:49 -0400
From: Theodore Tso <tytso@mit.edu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
Message-ID: <20090327193249.GY6239@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20090327150811.09b313f5@lxorguk.ukuu.org.uk> <20090327152221.GA25234@srcf.ucam.org> <20090327161553.31436545@lxorguk.ukuu.org.uk> <20090327162841.GA26860@srcf.ucam.org> <20090327165150.7e69d9e1@lxorguk.ukuu.org.uk> <20090327170208.GA27646@srcf.ucam.org> <20090327171955.78662c1e@lxorguk.ukuu.org.uk> <alpine.LFD.2.00.0903271058060.3994@localhost.localdomain> <20090327190339.GW6239@mit.edu> <20090327191426.3d478b6b@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090327191426.3d478b6b@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 27, 2009 at 07:14:26PM +0000, Alan Cox wrote:
> > Agreed, we need a middle ground.  We need a transition path that
> > recognizes that ext3 won't be the dominant filesystem for Linux in
> > perpetuity, and that ext3's data=ordered semantics will someday no
> > longer be a major factor in application design.  fbarrier() semantics
> > might be one approach; there may be others.  It's something we need to
> > figure out.
> 
> Would making close imply fbarrier() rather than fsync() work for this ?
> That would give people the ordering they want even if they are less
> careful but wouldn't give the media error cases - which are less
> interesting.

The thought that I had was to create a new system call, fbarrier()
which has the semantics that it will request the filesystem to make
sure that (at least) changes that have been made data blocks to date
should be forced out to disk when the next metadata operation is
committed.  For ext3 in data=ordered mode, this would be a no-op.  For
other filesystems that had fast/efficient fsync()'s, it could simply
be an fsync().  For other filesystems, it could trigger an
asynchronous writeout, if the journal commit will wait for the
writeout to complete.  For yet other filesystems, it might set a flag
that will cause the filesystem to start a synchronous writeout of the
file as part of the commit operations.  The bottom line was that what
we could *then* tell application programmers to do is
open/write/fbarrier/close/rename.  (And for operating systems where
they don't have fbarrier, they can use autoconf magic to replace
fbarrier with fsync.)

We could potentially make close() imply fbarrier(), but there are
plenty of times when that might not be such a great idea.  If we do
that, we're back to requiring synchronous data writes for all files on
close(), which might lead to huge latencies, just as ext3's
data=ordered mode did.  And in many cases, where the files in
questions can be easily regenerated (such as object files in a kernel
tree build), there really is no reason why it's a good idea to force
the blocks to disk on close().  In the highly unusual case where we
crash in the middle of a kernel build; we can do a "make clean; make"
and regenerate the object files.

The fundamental idea here is not all files need to be forced to disk
on close.  Not all files need fsync(), or even fbarrier().  We can
make the system go much more quickly if we can make a distinction
between these two cases.  It can also make SSD drives last longer if
we don't force blocks to disk for non-precious files.  If people
disagree with this premise, we can go back to something very much like
ext3's data=ordered mode; but then we get *all* of the problems of
ext3's data=ordered mode, including the unexpected filesystem
latencies that Linus and Ingo have been complaining about so much.
The two are very much related.

Anyway, this is just one idea; I'm not claiming that fbarrier() is the
perfect solution --- but it is one I plan to propose at the upcoming
Linux Storage and Filesystem workshop in San Francisco in a week or
so.   Maybe someone else will have a better idea.  

					- Ted


