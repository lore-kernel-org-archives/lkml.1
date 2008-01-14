Return-Path: <linux-kernel-owner+w=401wt.eu-S1756022AbYANL73@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756022AbYANL73 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 06:59:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755112AbYANL7X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 06:59:23 -0500
Received: from styx.suse.cz ([82.119.242.94]:49189 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754763AbYANL7W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 06:59:22 -0500
Date: Mon, 14 Jan 2008 12:59:20 +0100
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, supriyak@in.ibm.com
Subject: Re: [PATCH] Fix private_list handling
Message-ID: <20080114115920.GE4214@duck.suse.cz>
References: <20080110154959.GA12697@duck.suse.cz> <20080110155513.GB12697@duck.suse.cz> <20080110163635.33e7640e.akpm@linux-foundation.org> <20080111142130.GA28698@duck.suse.cz> <20080111153354.324a5af9.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080111153354.324a5af9.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 11-01-08 15:33:54, Andrew Morton wrote:
> On Fri, 11 Jan 2008 15:21:31 +0100
> Jan Kara <jack@suse.cz> wrote:
> 
> > On Thu 10-01-08 16:36:35, Andrew Morton wrote:
> > > On Thu, 10 Jan 2008 16:55:13 +0100
> > > Jan Kara <jack@suse.cz> wrote:
> > > 
> > > >   Hi,
> > > > 
> > > >   sorry for the previous empty email...
> > > > 
> > > >   Supriya noted in his testing that sometimes buffers removed by
> > > > __remove_assoc_queue() don't have b_assoc_mapping set (and thus IO error
> > > > won't be properly propagated). Actually, looking more into the code I found
> > > > there are some more races. The patch below should fix them. It survived
> > > > beating with LTP and fsstress on ext2 filesystem on my testing machine so
> > > > it should be reasonably bugfree... Andrew, would you put the patch into
> > > > -mm? Thanks.
> > > > 
> > > > 								Honza
> > > > -- 
> > > > Jan Kara <jack@suse.cz>
> > > > SUSE Labs, CR
> > > > ---
> > > > 
> > > > There are two possible races in handling of private_list in buffer cache.
> > > > 1) When fsync_buffers_list() processes a private_list, it clears
> > > > b_assoc_mapping and moves buffer to its private list. Now drop_buffers() comes,
> > > > sees a buffer is on list so it calls __remove_assoc_queue() which complains
> > > > about b_assoc_mapping being cleared (as it cannot propagate possible IO error).
> > > > This race has been actually observed in the wild.
> > > 
> > > private_lock should prevent this race.
> > > 
> > > Which call to drop_buffers() is the culprit?  The first one in
> > > try_to_free_buffers(), I assume?  The "can this still happen?" one?
> > > 
> > > If so, it can happen.  How?  Perhaps this is a bug.
> >   Good question but I don't think so. The problem is that
> > fsync_buffers_list() drops the private_lock() e.g. when it does
> > wait_on_buffer(). And buffers on the list fsync_buffers_list() constructs
> > have b_assoc_mapping set to NULL but the test
> > !list_empty(bh->b_assoc_buffers) succeeds for them and thus
> > __remove_assoc_queue() is called and it complains.
> >   We could also silence the warning by leaving b_assoc_mapping set when we
> > move the buffer to the constructed list.
> 
> Could fsync_buffers_list() leave the buffer not on a list when it does the
> ll_rw_block() and only add it to tmp afterwards if it sees that the buffer
> is still not on a list?
> 
> I guess not, as it still needs to find the buffer to wait upon it.
  Exactly... We have to have submitted buffers on some list.

> > But given the problem below
> > I've decided to do a more complete cleanup of the code.
> 
> Well.  Large-scale changes to long-established code like this are a last
> resort.  We should fully investigate little local fixups first.
  I see. Well, I could do the following minimal changes if it'd make you more
comfortable about it):
  1) Don't clear b_assoc_map in fsync_buffers_list() (that would get rid of
race with drop_buffers())
  2) Change fsync_buffers_list() to readd buffer into private_list when it
is dirty after we've waited on it. That should get rid of the second
race.
  But I still think that unnecessary temporary list is worth a cleanup ;).

> > > > 2) When fsync_buffers_list() processes a private_list,
> > > > mark_buffer_dirty_inode() can be called on bh which is already on the private
> > > > list of fsync_buffers_list(). As buffer is on some list (note that the check is
> > > > performed without private_lock), it is not readded to the mapping's
> > > > private_list and after fsync_buffers_list() finishes, we have a dirty buffer
> > > > which should be on private_list but it isn't. This race has not been reported,
> > > > probably because most (but not all) callers of mark_buffer_dirty_inode() hold
> > > > i_mutex and thus are serialized with fsync().
> > > 
> > > Maybe fsync_buffers_list should put the buffer back onto private_list if it
> > > got dirtied again.
> >   Yes, that's what it does in my new version. Only the locking is a bit
> > subtle if we want to avoid taking private_lock in mark_buffer_dirty_inode()
> > when the buffer is already on some list...
> 
> I fear rewrites in there.  It took five years to find this bug.  How long
> will it take to find new ones which get added?
  Well, I've added that WARN_ON() which warned us about the problem about
14 month ago so it was not that bad. But I agree that bugs are hard to
detect here as they result either in lost IO error or in not writing all
buffers on fsync both of which go mostly unnoticed.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
