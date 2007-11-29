Return-Path: <linux-kernel-owner+w=401wt.eu-S933966AbXK2V45@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933966AbXK2V45 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 16:56:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933726AbXK2Vzx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 16:55:53 -0500
Received: from relay1.sgi.com ([192.48.171.29]:45906 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933705AbXK2Vzv (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 16:55:51 -0500
Date: Fri, 30 Nov 2007 08:55:44 +1100
From: David Chinner <dgc@sgi.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Race between generic_forget_inode() and sync_sb_inodes()?
Message-ID: <20071129215544.GK115527101@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


If we are in the process of dropping an inode and it is hashed,
generic_forget_inode() will mark it I_WILL_FREE and drop the
inode_lock before calling write_inode_now().

However, at this point, the inode is still on the sb->s_dirty_list
so sync_sb_inodes() could see it and try to write it back.
i.e.:

	generic_forget_inode		sync_sb_inodes

	i_state |= I_WILL_FREE
	spin_unlock(inode_lock)
	write_inode_now()
					spin_lock(inode_lock)
					__iget(inode)
					__writeback_single_inode()
					spin_unlock(inode_lock)
	spin_lock(inode_lock)
	i_state &= ~I_WILL_FREE
	(remove from lists)
	i_state |= I_FREEING
	spin_unlock(inode_lock)
	i_state = I_CLEAR
					spin_lock(inode_lock)
					iput(inode)
					BUG_ON(i_state == I_CLEAR)
	(inode gets freed)


I came across this because I've been making changes to XFS to avoid the
inode hash, and I've found that I need to remove the inode from the
dirty list when setting I_WILL_FREE to avoid this race. I can't see
how this race is avoided when inodes are hashed, so I'm wondering
if we've just been lucky or there's something that I'm missing that
means the above does not occur.

If it really is a race, then sync_sb_inodes() should really check
I_WILL_FREE before doing an __iget(), I think. If I_WILL_FREE is set
we are already doing writeback so we don't need to do it from 
sync_sb_inodes(), right?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
