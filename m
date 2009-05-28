Return-Path: <linux-kernel-owner+w=401wt.eu-S1761985AbZE1Op5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761985AbZE1Op5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 10:45:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753421AbZE1Ops
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 10:45:48 -0400
Received: from cantor.suse.de ([195.135.220.2]:35012 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751083AbZE1Ops (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 10:45:48 -0400
Date: Thu, 28 May 2009 16:45:48 +0200
From: Jan Kara <jack@suse.cz>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, yanmin_zhang@linux.intel.com,
       richard@rsk.demon.co.uk, damien.wyart@free.fr
Subject: Re: [PATCH 04/11] writeback: switch to per-bdi threads for
	flushing data
Message-ID: <20090528144548.GO29199@duck.suse.cz>
References: <1243417312-7444-1-git-send-email-jens.axboe@oracle.com> <1243417312-7444-5-git-send-email-jens.axboe@oracle.com> <20090527151452.GI16006@duck.suse.cz> <20090527175019.GN11363@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090527175019.GN11363@kernel.dk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 27-05-09 19:50:19, Jens Axboe wrote:
> > > +static int bdi_forker_task(void *ptr)
> > > +{
> > > +	struct backing_dev_info *me = ptr;
> > > +	DEFINE_WAIT(wait);
> > > +
> > > +	for (;;) {
> > > +		struct backing_dev_info *bdi, *tmp;
> > > +
> > > +		/*
> > > +		 * Do this periodically, like kupdated() did before.
> > > +		 */
> > > +		sync_supers();
> >   Ugh, this looks nasty. Moreover I'm afraid of forker_task() getting stuck
> > (and thus not being able to start new threads) in sync_supers() when some
> > fs is busy and other needs to create flusher thread...
> >   Why not just having a separate thread for this? I know we have lots of
> > kernel threads already but this one seems like a useful one... Or do you
> > plan getting rid of this completely sometime in the near future and sync
> > supers also from per-bdi thread (which would make a lot of sence to me)?
> 
> It's ugly, and I think this is precisely what Ted hit. He's in umount,
> has ->s_umount sem held and waiting for IO.
  I've looked into this a bit more because it was still nagging in the back
of my mind and I think there indeed is a race (although your sync writeback
waiting has now hidden it). The problem is following:
  bdi flusher threads lives independently of filesystem being mounted or
not. So it can happen that bdi_kupdate() or bdi_pdflush() runs in parallel
with umount running in another thread. That should not really happen
because
  1) umount can fail with EBUSY because generic_sync_bdi_inodes() holds
    a reference to inode
  2) we race more subtly and we get to call __writeback_single_inode() after
    the filesystem has been unmounted (put_super() has been called).

  So I believe you simply have to deal with superblock references and
umount semaphore in your patches...

> So there's definitely trouble brewing there. As a short term solution, a
> separate thread will do. Longer term, the sync_supers_bdi() type setup I
> mentioned earlier would probably be the best. But once we start dealing
> with the super blocks, we have to be more careful with referencing.
> Which we also discussed in a previous mail :-)

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
