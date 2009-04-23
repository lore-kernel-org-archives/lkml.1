Return-Path: <linux-kernel-owner+w=401wt.eu-S1757532AbZDWLKx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757532AbZDWLKx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 07:10:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755526AbZDWLKm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 07:10:42 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58523 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753759AbZDWLKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 07:10:41 -0400
Date: Thu, 23 Apr 2009 07:10:40 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] vfs: Fix sys_sync() and fsync_super() reliability
Message-ID: <20090423111040.GB4833@infradead.org>
References: <1240415781-17834-1-git-send-email-jack@suse.cz> <1240415781-17834-2-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1240415781-17834-2-git-send-email-jack@suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 22, 2009 at 05:56:20PM +0200, Jan Kara wrote:
> So far, do_sync() called:
>   sync_inodes(0);
>   sync_supers();
>   sync_filesystems(0);
>   sync_filesystems(1);
>   sync_inodes(1);
> 
> This ordering makes it kind of hard for filesystems as sync_inodes(0) need not
> submit all the IO (for example it skips inodes with I_SYNC set) so e.g. forcing
> transaction to disk in ->sync_fs() is not really enough. Therefore sys_sync has
> not been completely reliable on some filesystems (ext3, ext4, reiserfs, ocfs2
> and others are hit by this) when racing e.g. with background writeback. A
> similar problem hits also other filesystems (e.g. ext2) because of
> write_supers() being called before the sync_inodes(1).
> 
> Change the ordering of calls in do_sync() - this requires a new function
> sync_blkdevs() to preserve the property that block devices are always synced
> after write_super() / sync_fs() call.
> 
> The same issue is fixed in __fsync_super() function used on umount /
> remount read-only.

This looks reasonable, but I always fear we break something when
touching this path. It would be really nice if we could rewrite do_sync
to sit ontop of __fsync_super.  E.g. do a 

	for_each_sb()
		__fsync_super(sb, ASYNC);
	for_each_sb()
		__fsync_super(sb, SYNC);

so that we have one central place that makes sure a filesystem is
properly synced.

Another thing I want to do in this area is sort out the meaning of
write_super.  I'd really prefer to have every filesystem implement
->sync_fs for actual data-integerity syncs, and only leave ->write_super
for the periodic writeouts, as the current implementation is extrenly
confusing and causes a lot of trouble for filesystems doing their own
periodic sb writeback.
