Return-Path: <linux-kernel-owner+w=401wt.eu-S1759486AbYAYSQe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759486AbYAYSQe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 13:16:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755004AbYAYSQ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 13:16:26 -0500
Received: from styx.suse.cz ([82.119.242.94]:42545 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754737AbYAYSQ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 13:16:26 -0500
Date: Fri, 25 Jan 2008 19:16:24 +0100
From: Jan Kara <jack@suse.cz>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH RESEND] Minimal fix for private_list handling races
Message-ID: <20080125181624.GA3234@duck.suse.cz>
References: <20080122171025.GB4485@duck.suse.cz> <200801240205.17005.nickpiggin@yahoo.com.au> <20080123154818.GD10144@duck.suse.cz> <200801251934.08160.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801251934.08160.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 25-01-08 19:34:07, Nick Piggin wrote:
> On Thursday 24 January 2008 02:48, Jan Kara wrote:
> 
  <snip>

> > In the current version, we readd buffer to 
> > private_list if it is found dirty in the second while loop of
> > fsync_buffers() and that should be enough.
> 
> Sure, I think there is still a data race though, but if there is one
> it's already been there for a long time and nobody cares too much about
> those anyway.
> 
> 
> > > But let's see... there must be a memory ordering problem here in existing
> > > code anyway, because I don't see any barriers. Between b_assoc_buffers
> > > and b_state (via buffer_dirty); fsync_buffers_list vs
> > > mark_buffer_dirty_inode, right?
> >
> >   I'm not sure. What exactly to you mean? BTW: spin_lock is a memory
> > barrier, isn't it?
> 
> In existing code:
> 
> mark_buffer_dirty_inode():              fsync_buffers_list():
>  test_set_buffer_dirty(bh);              list_del_init(&bh->b_assoc_buffers);
>  if (list_empty(&bh->b_assoc_buffers))   if (buffer_dirty(bh)) {
>      ...                                   list_add(&bh->b_assoc_buffers, );
> 
> These two code sequences can run concurrently because only fsync_buffers_list
> takes the lock.
> 
> So fsync_buffers_list can speculatively load bh->b_state before
> its stores to clear b_assoc_buffers propagate to the CPU running
> mark_buffer_dirty_inode.
> 
> So if there is a !dirty buffer on the list, then fsync_buffers_list will
> remove it from the list, but mark_buffer_dirty_inode won't see it has been
> removed from the list and won't re-add it. I think.
> 
> This is actually even possible to hit on x86 because they reorder loads
> past stores. It needs a smp_mb() before if (buffer_dirty(bh) {}.
  OK, I'll believe you ;) I was never completely sure what all can happen
if two processors access+write some memory without exclusion by a lock...

> Actually I very much dislike testing list entries locklessly, because they
> are not trivially atomic operations like single stores... which is another
> reason why I like your first patch.
  Yes, that was actually the reason why I changed the checks from
list_empty() to b_assoc_map testing. Well, so I'll add the barrier and
maybe also change these list_empty() checks to b_assoc_map tests...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
