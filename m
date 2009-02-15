Return-Path: <linux-kernel-owner+w=401wt.eu-S1753865AbZBOCsX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753865AbZBOCsX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 21:48:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752604AbZBOCsP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 21:48:15 -0500
Received: from ipmail01.adl6.internode.on.net ([203.16.214.146]:62626 "EHLO
	ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752393AbZBOCsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 21:48:14 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtADAIsPl0l5LClxgWdsb2JhbACUVAEBFiK8CIQcBg
X-IronPort-AV: E=Sophos;i="4.38,208,1233495000"; 
   d="scan'208";a="291111360"
Date: Sun, 15 Feb 2009 13:48:07 +1100
From: Dave Chinner <david@fromorbit.com>
To: Fernando Luis =?iso-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
Cc: Fernando Luis Vazquez Cao <fernando@kic.ac.jp>,
       Eric Sandeen <sandeen@redhat.com>, Jan Kara <jack@suse.cz>,
       Theodore Tso <tytso@MIT.EDU>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Pavel Machek <pavel@suse.cz>,
       kernel list <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, Ric Wheeler <rwheeler@redhat.com>
Subject: Re: vfs: Add MS_FLUSHONFSYNC mount flag
Message-ID: <20090215024807.GZ8830@disturbed>
Mail-Followup-To: Fernando Luis =?iso-8859-1?Q?V=E1zquez?= Cao <fernando@oss.ntt.co.jp>,
	Fernando Luis Vazquez Cao <fernando@kic.ac.jp>,
	Eric Sandeen <sandeen@redhat.com>, Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@MIT.EDU>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Pavel Machek <pavel@suse.cz>,
	kernel list <linux-kernel@vger.kernel.org>,
	Jens Axboe <jens.axboe@oracle.com>,
	Ric Wheeler <rwheeler@redhat.com>
References: <20090128095518.GA16554@duck.suse.cz> <1234434811.15270.7.camel@sebastian.kern.oss.ntt.co.jp> <1234434970.15433.4.camel@sebastian.kern.oss.ntt.co.jp> <499458C1.90105@redhat.com> <1234487679.3795.15.camel@sebastian.kern.oss.ntt.co.jp> <49951121.80807@redhat.com> <20090213122051.GX8830@disturbed> <1234542568.9916.183.camel@bladerunner> <20090214112443.GY8830@disturbed> <1234616633.19783.91.camel@sebastian.kern.oss.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1234616633.19783.91.camel@sebastian.kern.oss.ntt.co.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 14, 2009 at 10:03:53PM +0900, Fernando Luis Vázquez Cao wrote:
> On Sat, 2009-02-14 at 22:24 +1100, Dave Chinner wrote:
> > On Sat, Feb 14, 2009 at 01:29:28AM +0900, Fernando Luis Vazquez Cao wrote:
> > > On Fri, 2009-02-13 at 23:20 +1100, Dave Chinner wrote:
> > > > On Fri, Feb 13, 2009 at 12:20:17AM -0600, Eric Sandeen wrote:
> > > > > I'm just a little leery of the "dangerous" mount option proliferation, I
> > > > > guess.
> > > > 
> > > > You're not the only one, Eric. It's bad enough having to explain to
> > > > users what barriers do once they have lost data after a power loss,
> > > > let alone confusing them further by adding more mount options they
> > > > will get wrong by accident....
> > > 
> > > That is precisely the reason why we should use sensible defaults, which
> > > in this case means enabling barriers and flushing disk caches on
> > > fsync()/fdatasync() by default.
> > > 
> > > Adding either a new mount option (as you yourself suggest below) or a
> > > sysfs tunable is desirable for those cases when we really do not need to
> > > flush the disk write cache to guarantee integrity (battery-backed block
> > > devices come to mind), or we want to be fast at the cost of potentially
> > > losing some data.
> > 
> > Mount options are the wrong place for this. if you want to change
> > the behaviour of the block device, then it should be at that level.
> 
> To be more precise, what we are trying to change is the behavior of
> fsync()/fdatasync(), which users might want to change on a per-partition
> basis. I guess this is the reason the barrier switch was made a mount
> option, and I just wanted to be consistent.

This has no place in the kernel. Use LD_PRELOAD to make fsync() a
no-op.

> > No mount option - too confusing for someone to work out what
> > combination of barriers and flushing for things to work correctly.
> 
> As I suggested in a previous email, it is just a matter of using a safe
> combination by default so that users do not need to figure out anything.

Too many users think that they need to specify everything rather
than rely on defaults...

> > Just make filesystems issue the necessary flush calls or barrier IOs
> 
> "ext3: call blkdev_issue_flush on fsync" and "ext4: call
> blkdev_issue_flush on fsync" in this patch set implement just that for
> ext3/4.
> 
> >  and allow the block devices to ignore flushes.
> 
> Wouldn't it make more sense to avoid sending bios down the block layer
> which we can know in advance are going to be ignored by the block
> device?

As soon as the block layer reports EOPNOTSUPPORTED to a barrier IO,
the filesystem will switch them off and not issue them anymore.

> > I don't think we want (1) at all, and I thought that if ext3/4 are using
> > barriers then the barrier I/O issued by the journal does the flush
> > already. Hence (3) is redundant, right?
> 
> No, it is no redundant because a barrier is not issued in all cases. The
> aforementioned two patches fix ext3/4 by emitting a device flush only
> when necessary (i.e. when a barrier would not be emitted).

Then that is a filesystem fix, not something that requires VFS
modifications or new mount options....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
