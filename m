Return-Path: <linux-kernel-owner+w=401wt.eu-S1756162AbZCYWFu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756162AbZCYWFu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 18:05:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752251AbZCYWFm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 18:05:42 -0400
Received: from THUNK.ORG ([69.25.196.29]:34106 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752121AbZCYWFl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 18:05:41 -0400
Date: Wed, 25 Mar 2009 18:05:30 -0400
From: Theodore Tso <tytso@mit.edu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
Message-ID: <20090325220530.GR32307@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.2.00.0903231617550.3032@localhost.localdomain> <49C87B87.4020108@krogh.cc> <72dbd3150903232346g5af126d7sb5ad4949a7b5041f@mail.gmail.com> <49C88C80.5010803@krogh.cc> <72dbd3150903241200v38720ca0x392c381f295bdea@mail.gmail.com> <20090325183011.GN32307@mit.edu> <alpine.LFD.2.00.0903251139260.3032@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0903251139260.3032@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 25, 2009 at 11:40:28AM -0700, Linus Torvalds wrote:
> On Wed, 25 Mar 2009, Theodore Tso wrote:
> > I'm beginning to think that using a "ratio" may be the wrong way to
> > go.  We probably need to add an optional dirty_max_megabytes field
> > where we start pushing dirty blocks out when the number of dirty
> > blocks exceeds either the dirty_ratio or the dirty_max_megabytes,
> > which ever comes first.
> 
> We have that. Except it's called "dirty_bytes" and 
> "dirty_background_bytes", and it defaults to zero (off).
> 
> The problem being that unlike the ratio, there's no sane default value 
> that you can at least argue is not _entirely_ pointless.

Well, if the maximum time that someone wants to wait for an fsync() to
return is one second, and the RAID array can write 100MB/sec, then
setting a value of 100MB makes a certain amount of sense.  Yes, this
doesn't take seek overheads into account, and it may be that we're not
writing things out in an optimal order, as Alan as pointed out.  But
100MB is much lower number than 5% of 32GB (1.6GB).  It would be
better if these numbers were accounted on a per-filesystem instead of
a global threshold, but for people who are complaining about huge
latencies, it at least a partial workaround that they can use today.

I agree, it's not perfect, but this is a fundamentally hard problem.
We have multiple solutions, such as ext4 and XFS's delayed allocation,
which some people don't like because applications aren't calling
fsync().  We can boost the I/O priority of kjournald which definitely
helps, as Arjan has suggested, but Andrew has vetoed that.  I have a
patch which hopefully is less controversial, that posts writes using
WRITE_SYNC instead of WRITE, but which only will help in some
circumstances, but not in the distcc/icecream/fast downloads
scnearios.  We can use data=writeback, but folks don't like the
security implications of that.

People can call file system developers idiots if it makes them feel
better --- sure, OK, we all suck.  If someone wants to try to create a
better file system, show us how to do better, or send us some patches.
But this is not a problem that's easy to solve in a way that's going
to make everyone happy; else it would have been solved already.

						- Ted
