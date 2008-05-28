Return-Path: <linux-kernel-owner+w=401wt.eu-S1753323AbYE1Ibq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323AbYE1Ibq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 04:31:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751298AbYE1Ibi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 04:31:38 -0400
Received: from ipmail05.adl2.internode.on.net ([203.16.214.145]:36732 "EHLO
	ipmail05.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751268AbYE1Ibh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 04:31:37 -0400
X-Greylist: delayed 303 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 May 2008 04:31:37 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEADy0PEh5LG9Y/2dsb2JhbACuXg
X-IronPort-AV: E=Sophos;i="4.27,553,1204464600"; 
   d="scan'208";a="124183888"
Date: Wed, 28 May 2008 18:25:50 +1000
From: Dave Chinner <david@fromorbit.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Guillaume Chazarain <guichaz@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs-writeback: handle errors in sync_sb_inodes()
Message-ID: <20080528082550.GD3819@disturbed>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	Guillaume Chazarain <guichaz@gmail.com>,
	linux-kernel@vger.kernel.org
References: <20080523203429.11846.84137.stgit@localhost.localdomain> <20080527223832.f7131761.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080527223832.f7131761.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2008 at 10:38:32PM -0700, Andrew Morton wrote:
> On Fri, 23 May 2008 22:34:29 +0200 Guillaume Chazarain <guichaz@gmail.com> wrote:
> > diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> > index 495214d..0e6881e 100644
> > --- a/fs/fs-writeback.c
> > +++ b/fs/fs-writeback.c
> > @@ -454,6 +454,7 @@ void generic_sync_sb_inodes(struct super_block *sb,
> >  		struct address_space *mapping = inode->i_mapping;
> >  		struct backing_dev_info *bdi = mapping->backing_dev_info;
> >  		long pages_skipped;
> > +		int err;
> >  
> >  		if (!bdi_cap_writeback_dirty(bdi)) {
> >  			redirty_tail(inode);
> > @@ -498,7 +499,8 @@ void generic_sync_sb_inodes(struct super_block *sb,
> >  		BUG_ON(inode->i_state & I_FREEING);
> >  		__iget(inode);
> >  		pages_skipped = wbc->pages_skipped;
> > -		__writeback_single_inode(inode, wbc);
> > +		err = __writeback_single_inode(inode, wbc);
> > +		mapping_set_error(mapping, err);
> >  		if (wbc->sync_mode == WB_SYNC_HOLD) {
> >  			inode->dirtied_when = jiffies;
> >  			list_move(&inode->i_list, &sb->s_dirty);
> 
> ho hum, I've forgotten why I didn't like this.  Let's give it a run.

IIRC, it'll produce lots of spurious EIO errors under writeback on
XFS as XFS will return EAGAIN if we've been asked for a non-blocking
flush and we would have blocked....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
