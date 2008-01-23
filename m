Return-Path: <linux-kernel-owner+w=401wt.eu-S1754126AbYAWPsi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754126AbYAWPsi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 10:48:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753601AbYAWPs0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 10:48:26 -0500
Received: from styx.suse.cz ([82.119.242.94]:37939 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753436AbYAWPsU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 10:48:20 -0500
Date: Wed, 23 Jan 2008 16:48:18 +0100
From: Jan Kara <jack@suse.cz>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH RESEND] Minimal fix for private_list handling races
Message-ID: <20080123154818.GD10144@duck.suse.cz>
References: <20080122171025.GB4485@duck.suse.cz> <200801231200.03016.nickpiggin@yahoo.com.au> <20080123133045.GC10144@duck.suse.cz> <200801240205.17005.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801240205.17005.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 24-01-08 02:05:16, Nick Piggin wrote:
> On Thursday 24 January 2008 00:30, Jan Kara wrote:
> > On Wed 23-01-08 12:00:02, Nick Piggin wrote:
> > > On Wednesday 23 January 2008 04:10, Jan Kara wrote:
> > > >   Hi,
> > > >
> > > >   as I got no answer for a week, I'm resending this fix for races in
> > > > private_list handling. Andrew, do you like them more than the previous
> > > > version?
> > >
> > > FWIW, I reviewed this, and it looks OK although I think some comments
> > > would be in order.
> >
> >   Thanks.
> >
> > > What would be really nice is to avoid the use of b_assoc_buffers
> > > completely in this function like I've attempted (untested). I don't
> > > know if you'd actually call that an improvement...?
> >
> >   I thought about this solution as well. But main issue I had with this
> > solution is that currently, you nicely submit all the metadata buffers at
> > once, so that block layer can sort them and write them in nice order. With
> > the array you submit buffers by 16 (or any other fixed amount) and in
> > mostly random order... So IMHO fsync would become measurably slower.
> 
> Oh, I don't know the filesystems very well... which ones would
> attach a large number of metadata buffers to the inode?
  This logic is actually used only by a few filesystems - ext2 and UDF are
probably the most common ones. For example for ext2, the indirect blocks
are on the list if the file is freshly written, so that is roughly around
1MB of metadata per 1GB of data (for 4KB blocks, with 1KB blocks it is 4MB
per 1GB). Because seeks are expensive, you could really end up with the
write being 16 times slower when you do it in 16 passes instead of one...

> > > Couple of things I noticed while looking at this code.
> > >
> > > - What is osync_buffers_list supposed to do? I couldn't actually
> > >   work it out. Why do we care about waiting for these buffers on
> > >   here that were added while waiting for writeout of other buffers
> > >   to finish? Can we just remove it completely? I must be missing
> > >   something.
> >
> >   The problem here is that mark_buffer_dirty_inode() can move the buffer
> > from 'tmp' list back to private_list while we are waiting for another
> > buffer...
> 
> Hmm, no not while we're waiting for another buffer because b_assoc_buffers
> will not be empty. However it is possible between removing from the inode
> list and insertion onto the temp list I think, because
> 
>   if (list_empty(&bh->b_assoc_buffers)) {
> 
> check in mark_buffer_dirty_inode is done without private_lock held. Nice.
  Oh yes, that was it.

> With that in mind, doesn't your first patch suffer from a race due to
> exactly this unlocked list_empty check when you are removing clean buffers
> from the queue?
> 
>                              if (!buffer_dirty(bh) && !buffer_locked(bh))
> mark_buffer_dirty()
> if (list_empty(&bh->b_assoc_buffers))
>      /* add */
>                                  __remove_assoc_queue(bh);
> 
> Which results in the buffer being dirty but not on the ->private_list,
> doesn't it?
  Hmm, I'm not sure about which patch you speak. Logic with removing clean
buffers has been in the first version (but there mark_buffer_dirty_inode()
was written differently). In the current version, we readd buffer to
private_list if it is found dirty in the second while loop of
fsync_buffers() and that should be enough.

> But let's see... there must be a memory ordering problem here in existing
> code anyway, because I don't see any barriers. Between b_assoc_buffers and
> b_state (via buffer_dirty); fsync_buffers_list vs mark_buffer_dirty_inode,
> right?
  I'm not sure. What exactly to you mean? BTW: spin_lock is a memory barrier,
isn't it?
 
								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
