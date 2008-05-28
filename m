Return-Path: <linux-kernel-owner+w=401wt.eu-S1754015AbYE1IgV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015AbYE1IgV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 04:36:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751268AbYE1IgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 04:36:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51298 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751150AbYE1IgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 04:36:11 -0400
Date: Wed, 28 May 2008 01:35:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Guillaume Chazarain <guichaz@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs-writeback: handle errors in sync_sb_inodes()
Message-Id: <20080528013549.9636349c.akpm@linux-foundation.org>
In-Reply-To: <20080528082550.GD3819@disturbed>
References: <20080523203429.11846.84137.stgit@localhost.localdomain>
	<20080527223832.f7131761.akpm@linux-foundation.org>
	<20080528082550.GD3819@disturbed>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 May 2008 18:25:50 +1000 Dave Chinner <david@fromorbit.com> wrote:

> On Tue, May 27, 2008 at 10:38:32PM -0700, Andrew Morton wrote:
> > On Fri, 23 May 2008 22:34:29 +0200 Guillaume Chazarain <guichaz@gmail.com> wrote:
> > > diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> > > index 495214d..0e6881e 100644
> > > --- a/fs/fs-writeback.c
> > > +++ b/fs/fs-writeback.c
> > > @@ -454,6 +454,7 @@ void generic_sync_sb_inodes(struct super_block *sb,
> > >  		struct address_space *mapping = inode->i_mapping;
> > >  		struct backing_dev_info *bdi = mapping->backing_dev_info;
> > >  		long pages_skipped;
> > > +		int err;
> > >  
> > >  		if (!bdi_cap_writeback_dirty(bdi)) {
> > >  			redirty_tail(inode);
> > > @@ -498,7 +499,8 @@ void generic_sync_sb_inodes(struct super_block *sb,
> > >  		BUG_ON(inode->i_state & I_FREEING);
> > >  		__iget(inode);
> > >  		pages_skipped = wbc->pages_skipped;
> > > -		__writeback_single_inode(inode, wbc);
> > > +		err = __writeback_single_inode(inode, wbc);
> > > +		mapping_set_error(mapping, err);
> > >  		if (wbc->sync_mode == WB_SYNC_HOLD) {
> > >  			inode->dirtied_when = jiffies;
> > >  			list_move(&inode->i_list, &sb->s_dirty);
> > 
> > ho hum, I've forgotten why I didn't like this.  Let's give it a run.
> 
> IIRC, it'll produce lots of spurious EIO errors under writeback on
> XFS as XFS will return EAGAIN if we've been asked for a non-blocking
> flush and we would have blocked....

OIC.  This, I guess...

--- a/fs/fs-writeback.c~fs-writeback-handle-errors-in-sync_sb_inodes-fix
+++ a/fs/fs-writeback.c
@@ -500,7 +500,8 @@ void generic_sync_sb_inodes(struct super
 		__iget(inode);
 		pages_skipped = wbc->pages_skipped;
 		err = __writeback_single_inode(inode, wbc);
-		mapping_set_error(mapping, err);
+		if (err == -EIO || err == -ENOSPC) /* xfs can return -EAGAIN */
+			mapping_set_error(mapping, err);
 		if (wbc->sync_mode == WB_SYNC_HOLD) {
 			inode->dirtied_when = jiffies;
 			list_move(&inode->i_list, &sb->s_dirty);
_

I do so need to find time to work out where this all really has gone wrong.
