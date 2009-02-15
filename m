Return-Path: <linux-kernel-owner+w=401wt.eu-S1751372AbZBOHMJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751372AbZBOHMJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 02:12:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752651AbZBOHLy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 02:11:54 -0500
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:55468 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752631AbZBOHLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 02:11:52 -0500
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
In-Reply-To: <20090215024807.GZ8830@disturbed>
References: <20090128095518.GA16554@duck.suse.cz>
	 <1234434811.15270.7.camel@sebastian.kern.oss.ntt.co.jp>
	 <1234434970.15433.4.camel@sebastian.kern.oss.ntt.co.jp>
	 <499458C1.90105@redhat.com>
	 <1234487679.3795.15.camel@sebastian.kern.oss.ntt.co.jp>
	 <49951121.80807@redhat.com> <20090213122051.GX8830@disturbed>
	 <1234542568.9916.183.camel@bladerunner> <20090214112443.GY8830@disturbed>
	 <1234616633.19783.91.camel@sebastian.kern.oss.ntt.co.jp>
	 <20090215024807.GZ8830@disturbed>
Content-Type: text/plain; charset=utf-8
Organization: NTT Open Source Software Center
Date: Sun, 15 Feb 2009 16:11:50 +0900
Message-Id: <1234681910.19783.207.camel@sebastian.kern.oss.ntt.co.jp>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-02-15 at 13:48 +1100, Dave Chinner wrote:
> On Sat, Feb 14, 2009 at 10:03:53PM +0900, Fernando Luis Vázquez Cao wrote:
> > On Sat, 2009-02-14 at 22:24 +1100, Dave Chinner wrote:
> > > On Sat, Feb 14, 2009 at 01:29:28AM +0900, Fernando Luis Vazquez Cao wrote:
> > > > On Fri, 2009-02-13 at 23:20 +1100, Dave Chinner wrote:
> > > > > On Fri, Feb 13, 2009 at 12:20:17AM -0600, Eric Sandeen wrote:
> > > > > > I'm just a little leery of the "dangerous" mount option proliferation, I
> > > > > > guess.
> > > > > 
> > > > > You're not the only one, Eric. It's bad enough having to explain to
> > > > > users what barriers do once they have lost data after a power loss,
> > > > > let alone confusing them further by adding more mount options they
> > > > > will get wrong by accident....
> > > > 
> > > > That is precisely the reason why we should use sensible defaults, which
> > > > in this case means enabling barriers and flushing disk caches on
> > > > fsync()/fdatasync() by default.
> > > > 
> > > > Adding either a new mount option (as you yourself suggest below) or a
> > > > sysfs tunable is desirable for those cases when we really do not need to
> > > > flush the disk write cache to guarantee integrity (battery-backed block
> > > > devices come to mind), or we want to be fast at the cost of potentially
> > > > losing some data.
> > > 
> > > Mount options are the wrong place for this. if you want to change
> > > the behaviour of the block device, then it should be at that level.
> > 
> > To be more precise, what we are trying to change is the behavior of
> > fsync()/fdatasync(), which users might want to change on a per-partition
> > basis. I guess this is the reason the barrier switch was made a mount
> > option, and I just wanted to be consistent.
> 
> This has no place in the kernel. Use LD_PRELOAD to make fsync() a
> no-op.

The purpose of flushonfsync is not making fsync() a no-op and goes
beyond what we can currently achieve with LD_PRELOAD. For example, if we
send the data to disk but avoid flushing the block device's write cache
we can potentially improve I/O performance at the cost of compromising
data and filesystem integrity. This is a risk that those who play fast
and loose may want assume. By the way, sadly enough this is the way many
of the filesystems in Linus' tree behave. I just wanted to change this
situation by making all filesystems issue write-cache flushes by
default.

Some people suggested to leave a knob for those who wanted to revert to
the old behavior and I myself thought that it could make sense in some
cases so decided to add the tunable flushonsync.

If there is consensus flushonfsync should be a per-device tunable I am
more than willing to make it so. My goal is to fix all filesystem so
that they emit barriers and disk flushes when they should. flushonfsync
is just a nicety I added for those who, for whatever reason, still want
the old behavior.

For the next iteration of this patchset I will take out the contentious
bits and leave only the filesystem/VFS fixes so that we can move forward
while we discuss the propriety of adding a per-device or a
per-filesystem tunable such as flushonfsync to change the default (and
safe) behavior.

> > > No mount option - too confusing for someone to work out what
> > > combination of barriers and flushing for things to work correctly.
> > 
> > As I suggested in a previous email, it is just a matter of using a safe
> > combination by default so that users do not need to figure out anything.
> 
> Too many users think that they need to specify everything rather
> than rely on defaults...

Well that is their business. From my experience most admins in the field
do not stray from their enterprise-distro provided defaults.

> > > Just make filesystems issue the necessary flush calls or barrier IOs
> > 
> > "ext3: call blkdev_issue_flush on fsync" and "ext4: call
> > blkdev_issue_flush on fsync" in this patch set implement just that for
> > ext3/4.
> > 
> > >  and allow the block devices to ignore flushes.
> > 
> > Wouldn't it make more sense to avoid sending bios down the block layer
> > which we can know in advance are going to be ignored by the block
> > device?
> 
> As soon as the block layer reports EOPNOTSUPPORTED to a barrier IO,
> the filesystem will switch them off and not issue them anymore.

Yes, that certainly makes sense. But the point in discussion is whether
users should be allowed to switch them off (it arguably makes sense in
some scenarios). I am afraid that some users will not be happy if we do
not leave the door open for them to revert to the old behavior.

> > > I don't think we want (1) at all, and I thought that if ext3/4 are using
> > > barriers then the barrier I/O issued by the journal does the flush
> > > already. Hence (3) is redundant, right?
> > 
> > No, it is no redundant because a barrier is not issued in all cases. The
> > aforementioned two patches fix ext3/4 by emitting a device flush only
> > when necessary (i.e. when a barrier would not be emitted).
> 
> Then that is a filesystem fix, not something that requires VFS
> modifications or new mount options....

Yup, as mentioned above flushonfsync is just a nicety I added to the
second iteration of this patchset and is independent from the filesystem
fixes.

Regards,

Fernando

