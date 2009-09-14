Return-Path: <linux-kernel-owner+w=401wt.eu-S933090AbZINSZk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933090AbZINSZk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 14:25:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933076AbZINSZf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 14:25:35 -0400
Received: from mail-out1.uio.no ([129.240.10.57]:42909 "EHLO mail-out1.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933061AbZINSZb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 14:25:31 -0400
Subject: Re: [PATCH 2/7] Assign bdi in super_block
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, chris.mason@oracle.com,
       hch@infradead.org, tytso@mit.edu, akpm@linux-foundation.org
In-Reply-To: <20090914130228.GG24075@duck.suse.cz>
References: <1252920994-11141-1-git-send-email-jens.axboe@oracle.com>
	 <1252920994-11141-3-git-send-email-jens.axboe@oracle.com>
	 <20090914130228.GG24075@duck.suse.cz>
Content-Type: text/plain
Date: Mon, 14 Sep 2009 14:25:24 -0400
Message-Id: <1252952724.6866.62.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 8 msgs/h 1 sum rcpts/h 12 sum msgs/h 1 total rcpts 1418 max rcpts/h 27 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: 3662865E1533526A21363F903360CE404917960E
X-UiO-SPAM-Test: remote_host: 68.40.207.222 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 1 total 246 max/h 6 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-09-14 at 15:02 +0200, Jan Kara wrote:
> On Mon 14-09-09 11:36:29, Jens Axboe wrote:
> > We do this automatically in get_sb_bdev() from the set_bdev_super()
> > callback. Filesystems that have their own private backing_dev_info
> > must assign that in ->fill_super().
> > 
> > Note that ->s_bdi assignment is required for proper writeback!
> > 
> > Acked-by: Christoph Hellwig <hch@infradead.org>
> > Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
>   Hmm, looking at this again, I'm not sure this will work for NFS. It seems
> to set mapping->backing_dev_info to its private backing dev info for
> regular files while it leaves it intact for other inodes (e.g.
> directories). I'm not sure why it does so but it seems its inodes end up on
> two different BDI lists and thus they wouldn't be synced properly. Trond,
> do I read the code properly?
>   Also we definitely need to set *some* bdi in nfs_get_sb as otherwise sync
> won't work for it.

There hasn't really been a need for a bdi in NFS other than for the
regular file read and writeback code. The main reason for making it
private was to ensure that we could set a per-superblock readahead limit
that was a decent multiple of the server's preferred read block size.

Is there any reason why we couldn't set sb->s_bdi to point to that
private bdi?

Cheers
  Trond

