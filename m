Return-Path: <linux-kernel-owner+w=401wt.eu-S1752744AbZIGWa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752744AbZIGWa1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 18:30:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752477AbZIGWa1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 18:30:27 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35991 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751965AbZIGWa0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 18:30:26 -0400
Date: Tue, 8 Sep 2009 00:30:28 +0200
From: Jan Kara <jack@suse.cz>
To: Chris Mason <chris.mason@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, tytso@mit.edu
Subject: Re: [PATCH RFC] Add locking to ext3_do_update_inode
Message-ID: <20090907223028.GC11748@duck.suse.cz>
References: <20090904200613.GJ17033@think>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090904200613.GJ17033@think>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi,

On Fri 04-09-09 16:06:13, Chris Mason wrote:
> I've been struggling with this off and on while I've been testing the
> data=guarded work.  The symptom is corrupted orphan lists and inodes
> with the wrong i_size stored on disk.  I was convinced the
> data=guarded code was just missing a call to ext3_mark_inode_dirty, but
> tracing showed the i_disksize I was sending to ext3_mark_inode_dirty
> wasn't actually making it to the drive.
> 
> ext3_mark_inode_dirty can be called without locks held (atime updates
> and a few others), so the data=guarded code uses locks while updating
> the in-memory inode, and then calls ext3_mark_inode_dirty
> without any locks held.
> 
> But, ext3_mark_inode_dirty has no internal locking to make sure that
> only one CPU is updating the buffer head at a time.  Generally this
> works out ok because everyone that changes the inode then calls
> ext3_mark_inode_dirty themselves.  Even though it races, eventually
> someone updates the buffer heads and things move on.
> 
> But there is still a risk of the wrong values getting in, and the
> data=guarded code seems to hit the race very often.
> 
> Since everyone that changes the inode also logs it, it should be
> possible to fix this with some memory barriers.  I'll leave that as an
> exercise to the reader and lock the buffer head instead.
  One more thing - Ted, I believe ext4 needs a similar patch.

> It it probably a good idea to have a different patch series for lockless
> bit flipping on the ext3 i_state field.  ext3_do_update_inode &= clears
> EXT3_STATE_NEW without any locks held.
  Yeah, the locking around handling of i_state and i_flags is kind of
unclean...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
