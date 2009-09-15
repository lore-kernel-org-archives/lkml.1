Return-Path: <linux-kernel-owner+w=401wt.eu-S1752522AbZIOKPA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522AbZIOKPA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 06:15:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752077AbZIOKO4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 06:14:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49904 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751580AbZIOKOz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 06:14:55 -0400
Date: Tue, 15 Sep 2009 12:14:57 +0200
From: Jan Kara <jack@suse.cz>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>, Jan Kara <jack@suse.cz>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, hch@infradead.org, tytso@mit.edu,
       akpm@linux-foundation.org
Subject: Re: [PATCH 2/7] Assign bdi in super_block
Message-ID: <20090915101457.GE12169@duck.suse.cz>
References: <1252920994-11141-1-git-send-email-jens.axboe@oracle.com> <1252920994-11141-3-git-send-email-jens.axboe@oracle.com> <20090914130228.GG24075@duck.suse.cz> <1252952724.6866.62.camel@heimdal.trondhjem.org> <20090914183654.GJ14984@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090914183654.GJ14984@kernel.dk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 14-09-09 20:36:54, Jens Axboe wrote:
> On Mon, Sep 14 2009, Trond Myklebust wrote:
> > On Mon, 2009-09-14 at 15:02 +0200, Jan Kara wrote:
> > > On Mon 14-09-09 11:36:29, Jens Axboe wrote:
> > > > We do this automatically in get_sb_bdev() from the set_bdev_super()
> > > > callback. Filesystems that have their own private backing_dev_info
> > > > must assign that in ->fill_super().
> > > > 
> > > > Note that ->s_bdi assignment is required for proper writeback!
> > > > 
> > > > Acked-by: Christoph Hellwig <hch@infradead.org>
> > > > Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
> > >   Hmm, looking at this again, I'm not sure this will work for NFS. It seems
> > > to set mapping->backing_dev_info to its private backing dev info for
> > > regular files while it leaves it intact for other inodes (e.g.
> > > directories). I'm not sure why it does so but it seems its inodes end up on
> > > two different BDI lists and thus they wouldn't be synced properly. Trond,
> > > do I read the code properly?
> > >   Also we definitely need to set *some* bdi in nfs_get_sb as otherwise sync
> > > won't work for it.
> > 
> > There hasn't really been a need for a bdi in NFS other than for the
> > regular file read and writeback code. The main reason for making it
> > private was to ensure that we could set a per-superblock readahead limit
> > that was a decent multiple of the server's preferred read block size.
> > 
> > Is there any reason why we couldn't set sb->s_bdi to point to that
> > private bdi?
> 
> No, that should work fine. NFS already works fine with the bdi flusher
> threads, so you should just point it at that bdi.
  But will it really work well? I mean if we sync the superblock on the
client, it will sync only the private BDI. So it won't sync any directory
inodes because they are on the default_backing_dev_info (NFS leaves
sb->s_bdev at NULL).

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
