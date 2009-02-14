Return-Path: <linux-kernel-owner+w=401wt.eu-S1751881AbZBNLY7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751881AbZBNLY7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 06:24:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751337AbZBNLYv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 06:24:51 -0500
Received: from ipmail01.adl6.internode.on.net ([203.16.214.146]:12425 "EHLO
	ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750978AbZBNLYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 06:24:50 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtUCABc5lkl5LClxgWdsb2JhbACUUwEBFiK9MIQcBoYM
X-IronPort-AV: E=Sophos;i="4.38,206,1233495000"; 
   d="scan'208";a="290700748"
Date: Sat, 14 Feb 2009 22:24:43 +1100
From: Dave Chinner <david@fromorbit.com>
To: Fernando Luis Vazquez Cao <fernando@kic.ac.jp>
Cc: Eric Sandeen <sandeen@redhat.com>,
       Fernando Luis =?iso-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>,
       Jan Kara <jack@suse.cz>, Theodore Tso <tytso@MIT.EDU>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Pavel Machek <pavel@suse.cz>,
       kernel list <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, Ric Wheeler <rwheeler@redhat.com>
Subject: Re: vfs: Add MS_FLUSHONFSYNC mount flag
Message-ID: <20090214112443.GY8830@disturbed>
Mail-Followup-To: Fernando Luis Vazquez Cao <fernando@kic.ac.jp>,
	Eric Sandeen <sandeen@redhat.com>,
	Fernando Luis =?iso-8859-1?Q?V=E1zquez?= Cao <fernando@oss.ntt.co.jp>,
	Jan Kara <jack@suse.cz>, Theodore Tso <tytso@MIT.EDU>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, Pavel Machek <pavel@suse.cz>,
	kernel list <linux-kernel@vger.kernel.org>,
	Jens Axboe <jens.axboe@oracle.com>,
	Ric Wheeler <rwheeler@redhat.com>
References: <20090119120349.GA10193@duck.suse.cz> <1233135913.5399.57.camel@sebastian.kern.oss.ntt.co.jp> <20090128095518.GA16554@duck.suse.cz> <1234434811.15270.7.camel@sebastian.kern.oss.ntt.co.jp> <1234434970.15433.4.camel@sebastian.kern.oss.ntt.co.jp> <499458C1.90105@redhat.com> <1234487679.3795.15.camel@sebastian.kern.oss.ntt.co.jp> <49951121.80807@redhat.com> <20090213122051.GX8830@disturbed> <1234542568.9916.183.camel@bladerunner>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234542568.9916.183.camel@bladerunner>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 14, 2009 at 01:29:28AM +0900, Fernando Luis Vazquez Cao wrote:
> On Fri, 2009-02-13 at 23:20 +1100, Dave Chinner wrote:
> > On Fri, Feb 13, 2009 at 12:20:17AM -0600, Eric Sandeen wrote:
> > > I'm just a little leery of the "dangerous" mount option proliferation, I
> > > guess.
> > 
> > You're not the only one, Eric. It's bad enough having to explain to
> > users what barriers do once they have lost data after a power loss,
> > let alone confusing them further by adding more mount options they
> > will get wrong by accident....
> 
> That is precisely the reason why we should use sensible defaults, which
> in this case means enabling barriers and flushing disk caches on
> fsync()/fdatasync() by default.
> 
> Adding either a new mount option (as you yourself suggest below) or a
> sysfs tunable is desirable for those cases when we really do not need to
> flush the disk write cache to guarantee integrity (battery-backed block
> devices come to mind), or we want to be fast at the cost of potentially
> losing some data.

Mount options are the wrong place for this. if you want to change
the behaviour of the block device, then it should be at that level.

> > Quite frankly, the VFS should do stuff that is slow and safe
> > and filesystems can choose to ignore the VFS (via filesystem
> > specific mount options) if they want to be fast and potentially
> > unsafe.
> 
> To avoid unnecessary flushes and allow for filesystem-specific
> optimizations I was considering the following approach:
> 
> 1- Add flushonfsync mount option (as an aside, I am of the opinion that
> it should be set by default).

No mount option - too confusing for someone to work out what
combination of barriers and flushing for things to work correctly.
Just make filesystems issue the necessary flush calls or barrier
IOs and allow the block devices to ignore flushes.

> 2- Modify file_fsync() so that it checks whether FLUSHONFSYNC is set and
> flushes the underlying device accordingly. With this we would cover all
> filesystems that use the vfs-provided file_fsync() as their fsync method
> (commonly used filesystems such as fat fall in this group).

Just make it flush the block device.

> 3- Advanced filesystems (ext3/4, XFS, btrfs, etc) which provide their
> own fsync implementations are allowed to perform filesystem-specific
> optimizations there to minimize the number of flushes and maximize
> throughput.

Um, you are describing what we already have in place.  Almost every
filesystem provides it's own ->fsync method, not just the "advanced"
ones. It is those methods that need to be fixed to issue flushes, not just
file_fsync().

> In this patch set I implemented (1) and (3) for ext3/4 to have some code
> to comment on.

I don't think we want (1) at all, and I thought that if ext3/4 are using
barriers then the barrier I/O issued by the journal does the flush
already. Hence (3) is redundant, right?

FWIW, block device flushes are implemented by barrier IOs, so if
the underlying block device doesn't support barriers then you can't
flush the cache, either...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
