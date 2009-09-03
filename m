Return-Path: <linux-kernel-owner+w=401wt.eu-S1755847AbZICPhZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755847AbZICPhZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 11:37:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755800AbZICPhZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 11:37:25 -0400
Received: from verein.lst.de ([213.95.11.210]:42944 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755148AbZICPhY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 11:37:24 -0400
Date: Thu, 3 Sep 2009 17:37:22 +0200
From: Christoph Hellwig <hch@lst.de>
To: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>, linux-fsdevel@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 06/16] vfs: Rename generic_file_aio_write_nolock
Message-ID: <20090903153722.GA19337@lst.de>
References: <1251899966-7316-1-git-send-email-jack@suse.cz> <1251899966-7316-7-git-send-email-jack@suse.cz> <20090902214722.GA4226@lst.de> <20090903102436.GC5060@duck.novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090903102436.GC5060@duck.novell.com>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 03, 2009 at 12:24:36PM +0200, Jan Kara wrote:
> > Move it to fs/block_dev.c, rename it to blkdev_aio_write, export it _GPL
> > only and make it very clear it's only for block devices and raw.
>   Yes, fine with me. I'll replace my patch with yours so that we don't
> rename the function twice unnecessarily.

It's not a replacement, it's ontop of yours.  But folding it into yours
would make a lot of sense.

> > And btw, I'm not actually sure it is the right thing for raw.  Raw is
> > supposed to do direct I/O only, and in fact forced O_DIRECT on.  Because
> > there are no holes it also can't fall back to direct I/O.  So strictly
> > spreaking we could just use __generic_file_aio_write directly.   That
> > is until we care about the hw disk caches..
>   I'm slightly confused with the above - probably you mean it cannot fall
> back to buffered I/O and it could use generic_file_direct_write (because
> __generic_file_aio_write is just blkdev_aio_write without syncing in case
> of O_SYNC).

It can not fall back to buffered I/O, yes.  Any given that it does not
not do buffered I/O and the block/raw device also doesn' have any
inode metadata we could just use __generic_file_aio_write directly.
That is until my patch to flush the disk cache in ->fsync goes in in
which case we'll at least need that one again.  But we might just be
better off to opencode that instead of really using fsync - that avoids
the superflous call to filemap_write_and_wait and performs the cache
flush without i_mutex which we don't need.

That is the story for the block device, now the raw device is more
difficult as I would be surprised if the user of it used fsync on it.
Then again that would require us to find those users first, although
they apparently exist as removal of this horrible raw device feature
was vetoed by the big distros.
