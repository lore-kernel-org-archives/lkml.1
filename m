Return-Path: <linux-kernel-owner+w=401wt.eu-S1760581AbZBMQgV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760581AbZBMQgV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 11:36:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752982AbZBMQgN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 11:36:13 -0500
Received: from soda1.next-web.ne.jp ([211.10.8.3]:61702 "HELO
	soda1.next-web.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752872AbZBMQgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 11:36:12 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Fri, 13 Feb 2009 11:36:11 EST
Subject: Re: vfs: Add MS_FLUSHONFSYNC mount flag
From: Fernando Luis Vazquez Cao <fernando@kic.ac.jp>
To: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@redhat.com>,
       Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>,
       Jan Kara <jack@suse.cz>, Theodore Tso <tytso@MIT.EDU>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Pavel Machek <pavel@suse.cz>,
       kernel list <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, Ric Wheeler <rwheeler@redhat.com>
In-Reply-To: <20090213122051.GX8830@disturbed>
References: <1232185639.4831.18.camel@sebastian.kern.oss.ntt.co.jp>
	 <1232186449.4831.29.camel@sebastian.kern.oss.ntt.co.jp>
	 <20090119120349.GA10193@duck.suse.cz>
	 <1233135913.5399.57.camel@sebastian.kern.oss.ntt.co.jp>
	 <20090128095518.GA16554@duck.suse.cz>
	 <1234434811.15270.7.camel@sebastian.kern.oss.ntt.co.jp>
	 <1234434970.15433.4.camel@sebastian.kern.oss.ntt.co.jp>
	 <499458C1.90105@redhat.com>
	 <1234487679.3795.15.camel@sebastian.kern.oss.ntt.co.jp>
	 <49951121.80807@redhat.com>  <20090213122051.GX8830@disturbed>
Content-Type: text/plain
Organization: =?UTF-8?Q?=E7=A5=9E=E6=88=B8=E6=83=85=E5=A0=B1=E5=A4=A7=E5=AD=A6?=
 =?UTF-8?Q?=E9=99=A2=E5=A4=A7=E5=AD=A6?=
Date: Sat, 14 Feb 2009 01:29:28 +0900
Message-Id: <1234542568.9916.183.camel@bladerunner>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-02-13 at 23:20 +1100, Dave Chinner wrote:
> On Fri, Feb 13, 2009 at 12:20:17AM -0600, Eric Sandeen wrote:
> > I'm just a little leery of the "dangerous" mount option proliferation, I
> > guess.
> 
> You're not the only one, Eric. It's bad enough having to explain to
> users what barriers do once they have lost data after a power loss,
> let alone confusing them further by adding more mount options they
> will get wrong by accident....

That is precisely the reason why we should use sensible defaults, which
in this case means enabling barriers and flushing disk caches on
fsync()/fdatasync() by default.

Adding either a new mount option (as you yourself suggest below) or a
sysfs tunable is desirable for those cases when we really do not need to
flush the disk write cache to guarantee integrity (battery-backed block
devices come to mind), or we want to be fast at the cost of potentially
losing some data.

> Quite frankly, the VFS should do stuff that is slow and safe
> and filesystems can choose to ignore the VFS (via filesystem
> specific mount options) if they want to be fast and potentially
> unsafe.

To avoid unnecessary flushes and allow for filesystem-specific
optimizations I was considering the following approach:

1- Add flushonfsync mount option (as an aside, I am of the opinion that
it should be set by default).
2- Modify file_fsync() so that it checks whether FLUSHONFSYNC is set and
flushes the underlying device accordingly. With this we would cover all
filesystems that use the vfs-provided file_fsync() as their fsync method
(commonly used filesystems such as fat fall in this group).
3- Advanced filesystems (ext3/4, XFS, btrfs, etc) which provide their
own fsync implementations are allowed to perform filesystem-specific
optimizations there to minimize the number of flushes and maximize
throughput.

In this patch set I implemented (1) and (3) for ext3/4 to have some code
to comment on.

Does this approach make sense? Thoughts?

- Fernando

