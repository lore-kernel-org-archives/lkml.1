Return-Path: <linux-kernel-owner+w=401wt.eu-S1752857AbZBNNEJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857AbZBNNEJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 08:04:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751596AbZBNND4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 08:03:56 -0500
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:54606 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537AbZBNNDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 08:03:55 -0500
Subject: Re: vfs: Add MS_FLUSHONFSYNC mount flag
From: Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
To: Dave Chinner <david@fromorbit.com>
Cc: Fernando Luis Vazquez Cao <fernando@kic.ac.jp>,
       Eric Sandeen <sandeen@redhat.com>, Jan Kara <jack@suse.cz>,
       Theodore Tso <tytso@MIT.EDU>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Pavel Machek <pavel@suse.cz>,
       kernel list <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, Ric Wheeler <rwheeler@redhat.com>
In-Reply-To: <20090214112443.GY8830@disturbed>
References: <20090119120349.GA10193@duck.suse.cz>
	 <1233135913.5399.57.camel@sebastian.kern.oss.ntt.co.jp>
	 <20090128095518.GA16554@duck.suse.cz>
	 <1234434811.15270.7.camel@sebastian.kern.oss.ntt.co.jp>
	 <1234434970.15433.4.camel@sebastian.kern.oss.ntt.co.jp>
	 <499458C1.90105@redhat.com>
	 <1234487679.3795.15.camel@sebastian.kern.oss.ntt.co.jp>
	 <49951121.80807@redhat.com> <20090213122051.GX8830@disturbed>
	 <1234542568.9916.183.camel@bladerunner>  <20090214112443.GY8830@disturbed>
Content-Type: text/plain
Organization: NTT Open Source Software Center
Date: Sat, 14 Feb 2009 22:03:53 +0900
Message-Id: <1234616633.19783.91.camel@sebastian.kern.oss.ntt.co.jp>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-02-14 at 22:24 +1100, Dave Chinner wrote:
> On Sat, Feb 14, 2009 at 01:29:28AM +0900, Fernando Luis Vazquez Cao wrote:
> > On Fri, 2009-02-13 at 23:20 +1100, Dave Chinner wrote:
> > > On Fri, Feb 13, 2009 at 12:20:17AM -0600, Eric Sandeen wrote:
> > > > I'm just a little leery of the "dangerous" mount option proliferation, I
> > > > guess.
> > > 
> > > You're not the only one, Eric. It's bad enough having to explain to
> > > users what barriers do once they have lost data after a power loss,
> > > let alone confusing them further by adding more mount options they
> > > will get wrong by accident....
> > 
> > That is precisely the reason why we should use sensible defaults, which
> > in this case means enabling barriers and flushing disk caches on
> > fsync()/fdatasync() by default.
> > 
> > Adding either a new mount option (as you yourself suggest below) or a
> > sysfs tunable is desirable for those cases when we really do not need to
> > flush the disk write cache to guarantee integrity (battery-backed block
> > devices come to mind), or we want to be fast at the cost of potentially
> > losing some data.
> 
> Mount options are the wrong place for this. if you want to change
> the behaviour of the block device, then it should be at that level.

To be more precise, what we are trying to change is the behavior of
fsync()/fdatasync(), which users might want to change on a per-partition
basis. I guess this is the reason the barrier switch was made a mount
option, and I just wanted to be consistent.

My fear is that making one of them a mount option (barriers) and the
other a sysfs-tunable block device property (device flushes on fsync())
might end up creating more confusion than using a mount option for both.

Anyway, I do not have strong feelings on this issue and if there is
consensus I would be willing to change the patches so that flushonfsync
becomes a per block device tunable instead.

> > > Quite frankly, the VFS should do stuff that is slow and safe
> > > and filesystems can choose to ignore the VFS (via filesystem
> > > specific mount options) if they want to be fast and potentially
> > > unsafe.
> > 
> > To avoid unnecessary flushes and allow for filesystem-specific
> > optimizations I was considering the following approach:
> > 
> > 1- Add flushonfsync mount option (as an aside, I am of the opinion that
> > it should be set by default).
> 
> No mount option - too confusing for someone to work out what
> combination of barriers and flushing for things to work correctly.

As I suggested in a previous email, it is just a matter of using a safe
combination by default so that users do not need to figure out anything.

> Just make filesystems issue the necessary flush calls or barrier IOs

"ext3: call blkdev_issue_flush on fsync" and "ext4: call
blkdev_issue_flush on fsync" in this patch set implement just that for
ext3/4.

>  and allow the block devices to ignore flushes.

Wouldn't it make more sense to avoid sending bios down the block layer
which we can know in advance are going to be ignored by the block
device?

> > 2- Modify file_fsync() so that it checks whether FLUSHONFSYNC is set and
> > flushes the underlying device accordingly. With this we would cover all
> > filesystems that use the vfs-provided file_fsync() as their fsync method
> > (commonly used filesystems such as fat fall in this group).
> 
> Just make it flush the block device.

I wrote a patch that does exactly that but, in addition, it checks
whether FLUSHONFSYNC is set to avoid sending unnecessary flushes down
the block layer (this patch is not included in this patch-set, but I
will add it in the next iteration).

As I mentioned above, if everyone thinks this small optimization not
elegant or an undesirable layering violation I will remove it.

> > 3- Advanced filesystems (ext3/4, XFS, btrfs, etc) which provide their
> > own fsync implementations are allowed to perform filesystem-specific
> > optimizations there to minimize the number of flushes and maximize
> > throughput.
> 
> Um, you are describing what we already have in place.  Almost every
> filesystem provides it's own ->fsync method, not just the "advanced"
> ones.

Yes, I know. There are some remarkable exceptions such as fat, though.

>  It is those methods that need to be fixed to issue flushes, not just
> file_fsync().

Exactly, and this patch-set is my first attempt at that. For the first
submission I limited myself to fixing only ext3/4 so that I can get some
early feedback on my approach before moving forward.

> > In this patch set I implemented (1) and (3) for ext3/4 to have some code
> > to comment on.
> 
> I don't think we want (1) at all, and I thought that if ext3/4 are using
> barriers then the barrier I/O issued by the journal does the flush
> already. Hence (3) is redundant, right?

No, it is no redundant because a barrier is not issued in all cases. The
aforementioned two patches fix ext3/4 by emitting a device flush only
when necessary (i.e. when a barrier would not be emitted).

My impression is that we all agree in the basic approach, the only point
of contention being whether filesystems/VFS should be allowed to
optimize out disk flushes when the user told the kernel to do so (be it
via a sysfs tunable or mount option).

Cheers,

Fernando

