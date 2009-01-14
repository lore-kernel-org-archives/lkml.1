Return-Path: <linux-kernel-owner+w=401wt.eu-S1760656AbZANWJ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760656AbZANWJ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 17:09:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755275AbZANWJQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 17:09:16 -0500
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:62139 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755272AbZANWJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 17:09:15 -0500
Date: Wed, 14 Jan 2009 17:09:00 -0500
From: Theodore Tso <tytso@MIT.EDU>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
       linux-kernel@vger.kernel.org, pavel@suse.cz
Subject: Re: [PATCH 2/2] ext2: Add blk_issue_flush() to syncing paths
Message-ID: <20090114220900.GO6222@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	pavel@suse.cz
References: <1231945948-23676-1-git-send-email-jack@suse.cz> <1231945948-23676-2-git-send-email-jack@suse.cz> <20090114101834.fbb9ea12.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090114101834.fbb9ea12.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2009 at 10:18:34AM -0800, Andrew Morton wrote:
> On Wed, 14 Jan 2009 16:12:28 +0100 Jan Kara <jack@suse.cz> wrote:
> 
> > To be really safe that the data hit the platter, we should also flush drive's
> > writeback caches on fsync and for O_SYNC files or O_DIRSYNC inodes.
> > 
> 
> It's not good to randomly sprinkle blkdev_issue_flush() calls all over
> the filesystem like this.  How do we know that you didn't miss a site? 
> How do we ensure that people who modify the fs in the future don't
> forget to add the blkdev_issue_flush() call, if needed?
> 
> IOW, it is fragile.  Is there anything we can do to make this more
> robust?  Do the flush calls from some higher-level callsite?  Perhaps
> even the VFS?

The problem with doing it in the VFS is that we might end up calling
flush twice; it may very well be that for some filesystems, we'll be
calling the flush operation as part of writing out the commit block,
for example.

I'm not sure it's fair to say that we need to "randomly sprinkle
blkdev_issue_flush() calls all over the place".  The number of places
where we need to do O_SYNC or fsync() handling is in fact quite small.
We were simply ignoring this problem before.

> > +			blkdev_issue_flush(dir->i_sb->s_bdev, NULL);
> 
> The patch itself would have been a bit neater if it had added
> 
> int ext3_blkdev_issue_flush(struct inode *inode)

What, just to avoid needing the "..->i_sb->s_bdev" construction?  I
personally find extra levels of inline functions to be harder to deal
with long term, since I then I have to track down the definition of
ext3_blkdev_issue_flush in the header files to make sure there isn't
any other magic hiding in there other than the i->i_sb->s_bdev
derefencing.

						- Ted
