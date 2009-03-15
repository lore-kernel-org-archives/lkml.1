Return-Path: <linux-kernel-owner+w=401wt.eu-S1759437AbZCOVpB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759437AbZCOVpB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 17:45:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753796AbZCOVou
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 17:44:50 -0400
Received: from thunk.org ([69.25.196.29]:43156 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753128AbZCOVot (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 17:44:49 -0400
Date: Sun, 15 Mar 2009 17:44:26 -0400
From: Theodore Tso <tytso@mit.edu>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Daniel Phillips <phillips@phunq.net>, linux-fsdevel@vger.kernel.org,
       tux3@tux3.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [Tux3] Tux3 report: Tux3 Git tree available
Message-ID: <20090315214426.GA6357@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Nick Piggin <nickpiggin@yahoo.com.au>,
	Daniel Phillips <phillips@phunq.net>, linux-fsdevel@vger.kernel.org,
	tux3@tux3.org, Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <200903110925.37614.phillips@phunq.net> <200903130004.40483.nickpiggin@yahoo.com.au> <200903141941.10030.phillips@phunq.net> <200903151445.04552.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200903151445.04552.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 15, 2009 at 02:45:04PM +1100, Nick Piggin wrote:
> > As it happens, Tux3 also physically allocates each _physical_ metadata
> > block (i.e., what is currently called buffer cache) at the time it is
> > dirtied.  I don't know if this is the best thing to do, but it is
> > interesting that you do the same thing.  I also don't know if I want to
> > trust a library to get this right, before having completely proved out
> > the idea in a non-trival filesystem.  But good luck with that!  It
> 
> I'm not sure why it would be a big problem. fsblock isn't allocating
> the block itself of course, it just asks the filesystem to. It's
> trivial to do for fsblock.

So the really unfortunate thing about allocating the block as soon as
the page is dirty is that it spikes out delayed allocation.  By
delaying the physical allocation of the logical->physical mapping as
long as possible, the filesystem can select the best possible physical
location.  XFS, for example, keeps a btree of free regions indexed by
size so that it can select the perfect location for a newly written
file which is 24k or 56k long.  If fsblock forces the physical
allocation of blocks the moment the page is dirty, it will destroy
XFS's capability to select the perfect file.

In addition, XFS uses delayed allocation to avoid the problem of
uninitalized data becoming visible in the event of a crash.  If
fsblock immediately allocates the physical block, then either the
unitialized data might become available on a system crash (which is a
security problem), or XFS is going to have to force all newly written
data blocks to disk before a commit.  If that sounds familiar it's
what ext3's data=ordered mode does, and it's what is responsible for
the Firefox 3.0 fsync performance problem.

A similar issue exists for ext4's delayed allocation.

							- Ted
