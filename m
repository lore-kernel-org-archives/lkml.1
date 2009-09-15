Return-Path: <linux-kernel-owner+w=401wt.eu-S1752787AbZIOKWe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752787AbZIOKWe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 06:22:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752762AbZIOKWa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 06:22:30 -0400
Received: from brick.kernel.dk ([93.163.65.50]:54701 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752750AbZIOKWa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 06:22:30 -0400
Date: Tue, 15 Sep 2009 12:22:33 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Jan Kara <jack@suse.cz>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, chris.mason@oracle.com,
       hch@infradead.org, tytso@mit.edu, akpm@linux-foundation.org
Subject: Re: [PATCH 2/7] Assign bdi in super_block
Message-ID: <20090915102232.GI23126@kernel.dk>
References: <1252920994-11141-1-git-send-email-jens.axboe@oracle.com> <1252920994-11141-3-git-send-email-jens.axboe@oracle.com> <20090914130228.GG24075@duck.suse.cz> <1252952724.6866.62.camel@heimdal.trondhjem.org> <20090914183654.GJ14984@kernel.dk> <20090915101457.GE12169@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090915101457.GE12169@duck.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 15 2009, Jan Kara wrote:
> On Mon 14-09-09 20:36:54, Jens Axboe wrote:
> > On Mon, Sep 14 2009, Trond Myklebust wrote:
> > > On Mon, 2009-09-14 at 15:02 +0200, Jan Kara wrote:
> > > > On Mon 14-09-09 11:36:29, Jens Axboe wrote:
> > > > > We do this automatically in get_sb_bdev() from the set_bdev_super()
> > > > > callback. Filesystems that have their own private backing_dev_info
> > > > > must assign that in ->fill_super().
> > > > > 
> > > > > Note that ->s_bdi assignment is required for proper writeback!
> > > > > 
> > > > > Acked-by: Christoph Hellwig <hch@infradead.org>
> > > > > Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
> > > >   Hmm, looking at this again, I'm not sure this will work for NFS. It seems
> > > > to set mapping->backing_dev_info to its private backing dev info for
> > > > regular files while it leaves it intact for other inodes (e.g.
> > > > directories). I'm not sure why it does so but it seems its inodes end up on
> > > > two different BDI lists and thus they wouldn't be synced properly. Trond,
> > > > do I read the code properly?
> > > >   Also we definitely need to set *some* bdi in nfs_get_sb as otherwise sync
> > > > won't work for it.
> > > 
> > > There hasn't really been a need for a bdi in NFS other than for the
> > > regular file read and writeback code. The main reason for making it
> > > private was to ensure that we could set a per-superblock readahead limit
> > > that was a decent multiple of the server's preferred read block size.
> > > 
> > > Is there any reason why we couldn't set sb->s_bdi to point to that
> > > private bdi?
> > 
> > No, that should work fine. NFS already works fine with the bdi flusher
> > threads, so you should just point it at that bdi.
>   But will it really work well? I mean if we sync the superblock on the
> client, it will sync only the private BDI. So it won't sync any directory
> inodes because they are on the default_backing_dev_info (NFS leaves
> sb->s_bdev at NULL).

No you are right, it wont be complete. I talked to Chris about this
yesterday, and we agree that the best option is to give NFS the 'btrfs
treatment' bdi wise.

-- 
Jens Axboe

