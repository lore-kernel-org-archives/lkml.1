Return-Path: <linux-kernel-owner+w=401wt.eu-S1756975AbZIQJdx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756975AbZIQJdx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 05:33:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753302AbZIQJdw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 05:33:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43037 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752217AbZIQJdv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 05:33:51 -0400
Date: Thu, 17 Sep 2009 11:33:54 +0200
From: Jan Kara <jack@suse.cz>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, chris.mason@oracle.com,
       hch@infradead.org, tytso@mit.edu, akpm@linux-foundation.org,
       trond.myklebust@fys.uio.no
Subject: Re: [PATCH 10/11] writeback: splice dirty inode entries to default
	bdi on bdi_destroy()
Message-ID: <20090917093354.GB16941@duck.suse.cz>
References: <1253038617-30204-1-git-send-email-jens.axboe@oracle.com> <1253038617-30204-11-git-send-email-jens.axboe@oracle.com> <20090916131249.GG26030@duck.suse.cz> <20090916132108.GP23126@kernel.dk> <20090916132952.GI26030@duck.suse.cz> <20090916183129.GS23126@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090916183129.GS23126@kernel.dk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 16-09-09 20:31:29, Jens Axboe wrote:
> On Wed, Sep 16 2009, Jan Kara wrote:
> > On Wed 16-09-09 15:21:08, Jens Axboe wrote:
> > > On Wed, Sep 16 2009, Jan Kara wrote:
> > > > On Tue 15-09-09 20:16:56, Jens Axboe wrote:
> > > > > We cannot safely ensure that the inodes are all gone at this point
> > > > > in time, and we must not destroy this bdi with inodes having off it.
> > > >                                                         ^^^ hanging
> > > > 
> > > > > So just splice our entries to the default bdi since that one will
> > > > > always persist.
> > > >   BTW: Why can't we make sure all inodes on the BDI are clean when we
> > > > destroy it? Common sence would suggest that we better should be able to do
> > > > it :).
> > > >   Maybe it's because most users of private BDI do not call bdi_unregister
> > > > but rather directly bdi_destroy? Is this correct behavior?
> > > Not sure yet, it's on the TODO. This basically works around the problem
> > > for now at least. With dm at least, I'm seeing inodes still hanging off
> > > the bdi after we have done a sync_blockdev(bdev, 1);.
> >   Do you really mean sync_blockdev() or fsync_bdev()? Because the first one
> > just synces the blockdev's mapping not the filesystem...
> 
> Do we want a fsync_bdev() in __blkdev_put()? It's only doing
  No, we cannot call fsync_bdev() there because nothing really guarantees
that there exists any filesystem on the device and that it is setup enough
to handle IO - __blkdev_put() is called e.g. after the filesystem has been
cleaned up in ->put_super(). You can have a look like code in
generic_shutdown_super() looks like. The function is called when user has
no chance of dirtying any more data. In particular sync_filesystem() call
there should write everything to disk. If it does not, it's a bug.
->put_super() can dirty some data again, but only buffers of underlying
blockdev (e.g. when writing bitmaps, superblock etc.). If ->put_super()
method of some filesystem leaves some inodes dirty, it's a bug - we'd see
"VFS: Busy inodes after unmount" message.

> sync_blockdev() on last close, and dm wants to tear down the device at
> that point. So either dm needs to really flush the device when going
> readonly, or we need to strengthen the 'flush on last close'.
  Yes, but at the time __blkdev_put() is called, there should be no dirty
inodes as I've argued above. So I still don't quite get how there could be
any :)

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
