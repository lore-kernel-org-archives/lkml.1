Return-Path: <linux-kernel-owner+w=401wt.eu-S932376AbYAaKJB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932376AbYAaKJB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 05:09:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753239AbYAaKIs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 05:08:48 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:35506 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156AbYAaKIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 05:08:46 -0500
Subject: Re: [patch 2/6] mm: bdi: export BDI attributes in sysfs
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, kay.sievers@vrfy.org,
       greg@kroah.com, trond.myklebust@fys.uio.no
In-Reply-To: <20080131015453.d5c98955.akpm@linux-foundation.org>
References: <20080129154900.145303789@szeredi.hu>
	 <20080129154948.823761079@szeredi.hu>
	 <20080130162839.977d1e63.akpm@linux-foundation.org>
	 <E1JKVss-0001yr-7A@pomaz-ex.szeredi.hu>
	 <20080131015453.d5c98955.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 31 Jan 2008 11:08:39 +0100
Message-Id: <1201774119.28547.272.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-01-31 at 01:54 -0800, Andrew Morton wrote:
> On Thu, 31 Jan 2008 10:39:02 +0100 Miklos Szeredi <miklos@szeredi.hu> wrote:
> 
> > > On Tue, 29 Jan 2008 16:49:02 +0100
> > > Miklos Szeredi <miklos@szeredi.hu> wrote:
> > > 
> > > > From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > > > 
> > > > Provide a place in sysfs (/sys/class/bdi) for the backing_dev_info
> > > > object.  This allows us to see and set the various BDI specific
> > > > variables.
> > > > 
> > > > In particular this properly exposes the read-ahead window for all
> > > > relevant users and /sys/block/<block>/queue/read_ahead_kb should be
> > > > deprecated.
> > > 
> > > This description is not complete.  It implies that the readahead window is
> > > not "properly" exposed for some "relevant" users.  The reader is left
> > > wondering what on earth this is referring to.  I certainly don't know.
> > > Perhaps when this information is revealed, we can work out what was
> > > wrong with per-queue readahead tuning.
> > 
> > I think Peter meant, that the readahead window was only exposed for
> > block devices, and not things like NFS or FUSE.
> 
> OK.

And queue-less block devices like loop-back md/dm and whatnot.

> > 
> > > > +blk-NAME
> > > > +
> > > > +	Block devices, NAME is 'sda', 'loop0', etc...
> > > 
> > > But if I've done `mknod /dev/pizza-party 8 0', I'm looking for
> > > blk-pizza-party, not blk-sda.
> > > 
> > > But I might still have /dev/sda, too.
> > 
> > An alternative would be to uniformly use MAJOR:MINOR in there.  It
> > would work for block devices and anonymous devices (NFS/FUSE) as well.
> > 
> > Would that be any better?
> 
> I suppose so.  sysfs likes to use symlinks to point over at related
> things in different directories...

Yeah, I think that would work best. Its more consistent as well.

> > > 
> > > > +FSTYPE-MAJOR:MINOR
> > > > +
> > > > +	Non-block device backed filesystems which provide their own
> > > > +	BDI, such as NFS and FUSE.  MAJOR:MINOR is the value of st_dev
> > > > +	for files on this filesystem.
> > > > +
> > > > +default
> > > > +
> > > > +	The default backing dev, used for non-block device backed
> > > > +	filesystems which do not provide their own BDI.
> > > > +
> > > > +Files under /sys/class/bdi/<bdi>/
> > > > +---------------------------------
> > > > +
> > > > +read_ahead_kb (read-write)
> > > > +
> > > > +	Size of the read-ahead window in kilobytes
> > > > +
> > > > +reclaimable_kb (read-only)
> > > > +
> > > > +	Reclaimable (dirty or unstable) memory destined for writeback
> > > > +	to this device
> > > > +
> > > > +writeback_kb (read-only)
> > > > +
> > > > +	Memory currently under writeback to this device
> > > > +
> > > > +dirty_kb (read-only)
> > > > +
> > > > +	Global threshold for reclaimable + writeback memory
> > > > +
> > > > +bdi_dirty_kb (read-only)
> > > > +
> > > > +	Current threshold on this BDI for reclaimable + writeback
> > > > +	memory
> > > > +
> > > 
> > > I dunno.  A number of the things which you're exposing are closely tied to
> > > present-day kernel implementation and may be irrelevant or even
> > > unimplementable in a few years' time.
> > 
> > Which ones?
> 
> I don't know - I misplaced my copy of linux-2.6.44 :)
> 
> The whole concept of a BDI might go away, who knows?  Progress in
> non-volatile semiconductor storage might make the whole
> rotating-platter-with-a-seek-head thing obsolete.
> 
> read_ahead_kb is likely to be stable.  writeback_kb is a stable concept
> too, although we might lose the ability to keep track of it some time in
> the future.
> 
> Suppose that /dev/sda and /dev/sdb share the same queue - we lose the ability
> to track some of these things?
> 
> >  They could possibly be moved to debugfs, or something.
> > 
> > I agree, that sysfs should be relatively stable.
> 
> This does look more like a debugging feature than a permanently-offered,
> support-it-forever part of the kernel ABI.

Agreed, all except the read_ahead tunable are debugish. The min/max
things are real tunables though. (writing up a little text on the
why/how of those as we speak - well, write)

