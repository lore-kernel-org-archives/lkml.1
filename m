Return-Path: <linux-kernel-owner+w=401wt.eu-S1757030AbYFBDvj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757030AbYFBDvj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 23:51:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754574AbYFBDv1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 23:51:27 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:39608 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754303AbYFBDv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 23:51:26 -0400
Date: Sun, 1 Jun 2008 23:51:07 -0400
Message-Id: <200806020351.m523p7Lw026335@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Arnd Bergmann <arnd@arndb.de>, Jamie Lokier <jamie@shareable.org>,
       Phillip Lougher <phillip@lougher.demon.co.uk>,
       David Newall <davidn@davidnewall.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, hch@lst.de
Subject: Re: [RFC 0/7] [RFC] cramfs: fake write support 
In-reply-to: Your message of "Mon, 02 Jun 2008 11:48:22 +0900."
             <9785.1212374902@jrobl> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Jamie Lokier wrote:
> > Phillip Lougher wrote:
> > If I read the patches correctly, when a file page is written to, only 
> > that page gets copied into the page cache and locked, the other pages 
> > continue to be read off disk from cramfs?  With Unionfs a page write 
> > causes the entire file to be copied up to the r/w tmpfs and locked into 
> > the page cache causing unnecessary RAM overhead.

Yes, unionfs does copyup whole files, but it doesn't lock the entire file
into the page cache.  But I agree, that copying up large files to a tmpfs
partition adds more memory pressure, at least temporarily (until pdflush
kicks in).

> Ok, so why not fix that in unionfs?  An option so that holes in the
> overlay file let through data from the underlying file sounds like it
> would be generally useful, and quite easy to implement.

If I understand you right, you want to copyup one page at a time, right?
That's not nearly as easy as one might imagine.  First, you can't do it on
file systems which don't support holes.  Second, holes is a file-systems
specific implementation issue, and the knowledge of holes AFAIC, is hidden
from the VFS (IIRC, FreeBSD has a specific "zfod" page flag, which is turned
on when the VM has a page that came out of a f/s hole).

You'll need a way to tell if a given page was copied up or not, and
distinguish b/t pages which are naturally filled with zeros vs. those which
came from f/s holes.

Copyup is also providing persistency: you can copyup to a persistent f/s
such as ext2.  So you'll need a bitmap or some sort of record that will
survive file system remount and system reboot; such a bitmap will have to
tell which pages of a file have been copied up or not.

I'm not saying it's not possible, but it's to do this page-wise caching at a
stackable layer than inside a native f/s such as ext2.  Now, if there was a
generic VFS op that allowed me to query a file system whether a page it a
given file is a hole or not, then unionfs would be able to do page-wise
copyup easily.

Frankly, I think something like support for a copied-up file, page-by-page,
should probably be supported by a block layer virtual driver (this might be
easier in a BSD-like geom layer.)

BTW, I believe FSCache has page-wise caching, right?  Caching is a
copy-on-read operation, and it doesn't take much to make it cache (read:
copy) on writes.  So FScache might be a good starting point for such an
effort.

> If not unionfs, a "union-tmpfs" combination would be good.  Many
> filesystems aren't well suited to being the overlay filesystem -
> adding to the implementation's complexity - but a modified tmpfs could
> be very well suited.

I think a union-tmpfs is a better solution than a cramfs-specific one, b/c
at least with union-tmpfs, many more users could use it.  Even if you
restrict yourself to using tmpfs as the r-w layer, and read-only from just
one other source f/s, that still will cover a large portion of unioning
users.

> -- Jamie

Cheers,
Erez.
