Return-Path: <linux-kernel-owner+w=401wt.eu-S1763005AbYBZPne@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763005AbYBZPne (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 10:43:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759111AbYBZPnW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 10:43:22 -0500
Received: from mail2.shareable.org ([80.68.89.115]:37514 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757362AbYBZPnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 10:43:21 -0500
Date: Tue, 26 Feb 2008 15:43:15 +0000
From: Jamie Lokier <jamie@shareable.org>
To: Ric Wheeler <ric@emc.com>
Cc: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Chris Wedgwood <cw@f00f.org>
Subject: Re: Proposal for "proper" durable fsync() and fdatasync()
Message-ID: <20080226154315.GC18118@shareable.org>
References: <20080226072649.GB30238@shareable.org> <47C3C33F.1070908@garzik.org> <47C40269.7060309@emc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47C40269.7060309@emc.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ric Wheeler wrote:
> >>I was surprised that fsync() doesn't do this already.  There was a lot
> >>of effort put into block I/O write barriers during 2.5, so that
> >>journalling filesystems can force correct write ordering, using disk
> >>flush cache commands.
> >>
> >>After all that effort, I was very surprised to notice that Linux 2.6.x
> >>doesn't use that capability to ensure fsync() flushes the disk cache
> >>onto stable storage.
> >
> >It's surprising you are surprised, given that this [lame] fsync behavior 
> >has remaining consistently lame throughout Linux's history.
> 
> Maybe I am confused, but isn't this is what fsync() does today whenever 
> barriers are enabled (the fsync() invalidates the drive's write cache).

No, fsync() doesn't always flush the drive's write cache.  It often
does, any I think many people are under the impression it always does,
but it doesn't.

Try this code on ext3:

	fd = open ("test_file", O_RDWR | O_CREAT | O_TRUNC, 0666);
	while (1) {
		char byte;
		usleep (100000);
		pwrite (fd, &byte, 1, 0);
		fsync (fd);
	}

It will do just over 10 write ops per second on an idle system (13 on
mine), and 1 flush op per second.

That's because ext3 fsync() only does a journal commit when the inode
has changed.  The inode mtime is changed by write only with 1 second
granularity.  Without a journal commit, there's no barrier, which
translates to not flushing disk write cache.

If you add "fchmod (fd, 0644); fchmod (fd, 0664);" between the write
and fsync, you'll see at least 20 write ops and 20 flush ops per
second, and you'll here the disk seeking more.  That's because the
fchmod dirties the inode, so fsync() writes the inode with a journal
commit.

It turns out even _that_ is not sufficient according to the kernel
internals.  A journal commit uses an ordered request, which isn't the
same as a flush potentially, it just happens to use flush in this
instance.  I'm not sure if ordered requests are actually implemented
by any drivers at the moment.  If not now, they will be one day.

We could change ext3 fsync() to always do a journal commit, and depend
on the non-existence of block drivers which do ordered (not flush)
barrier requests.  But there's lots of things wrong with that.  Not
least, it sucks performance for database-like applications and virtual
machines, a lot due to unnecessary seeks.  That way lies wrongness.

Rightness is to make fdatasync() work well, with a genuine flush (or
equivalent (see FUA), only when required, and not a mere ordered
barrier), no inode write, and to make sync_file_range()[*] offer the
fancier applications finer controls which reflect what they actually
need.

[*] - or whatever.

-- Jamie
