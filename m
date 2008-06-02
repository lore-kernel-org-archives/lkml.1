Return-Path: <linux-kernel-owner+w=401wt.eu-S1758385AbYFBLHk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758385AbYFBLHk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 07:07:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752048AbYFBLHc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 07:07:32 -0400
Received: from mail2.shareable.org ([80.68.89.115]:36951 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbYFBLHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 07:07:31 -0400
Date: Mon, 2 Jun 2008 12:07:08 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Erez Zadok <ezk@cs.sunysb.edu>
Cc: Arnd Bergmann <arnd@arndb.de>,
       Phillip Lougher <phillip@lougher.demon.co.uk>,
       David Newall <davidn@davidnewall.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, hch@lst.de
Subject: Re: [RFC 0/7] [RFC] cramfs: fake write support
Message-ID: <20080602110708.GE31032@shareable.org>
References: <9785.1212374902@jrobl> <200806020351.m523p7Lw026335@agora.fsl.cs.sunysb.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200806020351.m523p7Lw026335@agora.fsl.cs.sunysb.edu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Erez Zadok wrote:
> 
> > Jamie Lokier wrote:
> > > Phillip Lougher wrote:
> > > If I read the patches correctly, when a file page is written to, only 
> > > that page gets copied into the page cache and locked, the other pages 
> > > continue to be read off disk from cramfs?  With Unionfs a page write 
> > > causes the entire file to be copied up to the r/w tmpfs and locked into 
> > > the page cache causing unnecessary RAM overhead.
> 
> Yes, unionfs does copyup whole files, but it doesn't lock the entire file
> into the page cache.  But I agree, that copying up large files to a tmpfs
> partition adds more memory pressure, at least temporarily (until pdflush
> kicks in).

1: I'm thinking systems which have union-over-cramfs probably don't have
swap at all...

2: It's a problem when you modify a very large file, even on a fast PC
with plenty of RAM.  LVM snapshots might be better for this sort of
thing.

> > Ok, so why not fix that in unionfs?  An option so that holes in the
> > overlay file let through data from the underlying file sounds like it
> > would be generally useful, and quite easy to implement.
> 
> If I understand you right, you want to copyup one page at a time, right?
> That's not nearly as easy as one might imagine.  First, you can't do it on
> file systems which don't support holes.  Second, holes is a file-systems
> specific implementation issue, and the knowledge of holes AFAIC, is hidden
> from the VFS (IIRC, FreeBSD has a specific "zfod" page flag, which is turned
> on when the VM has a page that came out of a f/s hole).

True, although the new FIEMAP ioctl is supposed to make holes more
filesystem independent, when they are supported.

> You'll need a way to tell if a given page was copied up or not, and
> distinguish b/t pages which are naturally filled with zeros vs. those which
> came from f/s holes.

Metadata.  Don't you have other metadata anyway, like whiteouts? :-)

> Copyup is also providing persistency: you can copyup to a persistent f/s
> such as ext2.  So you'll need a bitmap or some sort of record that will
> survive file system remount and system reboot; such a bitmap will have to
> tell which pages of a file have been copied up or not.

Yes.

> I'm not saying it's not possible, but it's to do this page-wise caching at a
> stackable layer than inside a native f/s such as ext2.  Now, if there was a
> generic VFS op that allowed me to query a file system whether a page it a
> given file is a hole or not, then unionfs would be able to do page-wise
> copyup easily.

See FIEMAP.  Is it any use?

-- Jamie
