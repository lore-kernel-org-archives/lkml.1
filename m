Return-Path: <linux-kernel-owner+w=401wt.eu-S1762164AbYAaJ4F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762164AbYAaJ4F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 04:56:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758182AbYAaJzt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 04:55:49 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47422 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754954AbYAaJzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 04:55:47 -0500
Date: Thu, 31 Jan 2008 01:54:53 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, kay.sievers@vrfy.org,
       greg@kroah.com, trond.myklebust@fys.uio.no
Subject: Re: [patch 2/6] mm: bdi: export BDI attributes in sysfs
Message-Id: <20080131015453.d5c98955.akpm@linux-foundation.org>
In-Reply-To: <E1JKVss-0001yr-7A@pomaz-ex.szeredi.hu>
References: <20080129154900.145303789@szeredi.hu>
	<20080129154948.823761079@szeredi.hu>
	<20080130162839.977d1e63.akpm@linux-foundation.org>
	<E1JKVss-0001yr-7A@pomaz-ex.szeredi.hu>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jan 2008 10:39:02 +0100 Miklos Szeredi <miklos@szeredi.hu> wrote:

> > On Tue, 29 Jan 2008 16:49:02 +0100
> > Miklos Szeredi <miklos@szeredi.hu> wrote:
> > 
> > > From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > > 
> > > Provide a place in sysfs (/sys/class/bdi) for the backing_dev_info
> > > object.  This allows us to see and set the various BDI specific
> > > variables.
> > > 
> > > In particular this properly exposes the read-ahead window for all
> > > relevant users and /sys/block/<block>/queue/read_ahead_kb should be
> > > deprecated.
> > 
> > This description is not complete.  It implies that the readahead window is
> > not "properly" exposed for some "relevant" users.  The reader is left
> > wondering what on earth this is referring to.  I certainly don't know.
> > Perhaps when this information is revealed, we can work out what was
> > wrong with per-queue readahead tuning.
> 
> I think Peter meant, that the readahead window was only exposed for
> block devices, and not things like NFS or FUSE.

OK.

> 
> > > +blk-NAME
> > > +
> > > +	Block devices, NAME is 'sda', 'loop0', etc...
> > 
> > But if I've done `mknod /dev/pizza-party 8 0', I'm looking for
> > blk-pizza-party, not blk-sda.
> > 
> > But I might still have /dev/sda, too.
> 
> An alternative would be to uniformly use MAJOR:MINOR in there.  It
> would work for block devices and anonymous devices (NFS/FUSE) as well.
> 
> Would that be any better?

I suppose so.  sysfs likes to use symlinks to point over at related
things in different directories...

> > 
> > > +FSTYPE-MAJOR:MINOR
> > > +
> > > +	Non-block device backed filesystems which provide their own
> > > +	BDI, such as NFS and FUSE.  MAJOR:MINOR is the value of st_dev
> > > +	for files on this filesystem.
> > > +
> > > +default
> > > +
> > > +	The default backing dev, used for non-block device backed
> > > +	filesystems which do not provide their own BDI.
> > > +
> > > +Files under /sys/class/bdi/<bdi>/
> > > +---------------------------------
> > > +
> > > +read_ahead_kb (read-write)
> > > +
> > > +	Size of the read-ahead window in kilobytes
> > > +
> > > +reclaimable_kb (read-only)
> > > +
> > > +	Reclaimable (dirty or unstable) memory destined for writeback
> > > +	to this device
> > > +
> > > +writeback_kb (read-only)
> > > +
> > > +	Memory currently under writeback to this device
> > > +
> > > +dirty_kb (read-only)
> > > +
> > > +	Global threshold for reclaimable + writeback memory
> > > +
> > > +bdi_dirty_kb (read-only)
> > > +
> > > +	Current threshold on this BDI for reclaimable + writeback
> > > +	memory
> > > +
> > 
> > I dunno.  A number of the things which you're exposing are closely tied to
> > present-day kernel implementation and may be irrelevant or even
> > unimplementable in a few years' time.
> 
> Which ones?

I don't know - I misplaced my copy of linux-2.6.44 :)

The whole concept of a BDI might go away, who knows?  Progress in
non-volatile semiconductor storage might make the whole
rotating-platter-with-a-seek-head thing obsolete.

read_ahead_kb is likely to be stable.  writeback_kb is a stable concept
too, although we might lose the ability to keep track of it some time in
the future.

Suppose that /dev/sda and /dev/sdb share the same queue - we lose the ability
to track some of these things?

>  They could possibly be moved to debugfs, or something.
> 
> I agree, that sysfs should be relatively stable.

This does look more like a debugging feature than a permanently-offered,
support-it-forever part of the kernel ABI.

