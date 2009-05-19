Return-Path: <linux-kernel-owner+w=401wt.eu-S1754547AbZESRYA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754547AbZESRYA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 13:24:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752614AbZESRXu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 13:23:50 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47102 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752136AbZESRXu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 13:23:50 -0400
Date: Tue, 19 May 2009 13:23:27 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: jblunck@suse.de, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
       bharata@in.ibm.com, dwmw2@infradead.org, mszeredi@suse.cz
Subject: Re: [PATCH 00/32] VFS based Union Mount (V3)
Message-ID: <20090519172327.GB722@shell>
References: <1242662968-11684-1-git-send-email-jblunck@suse.de> <E1M6LvU-0000mN-HN@pomaz-ex.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1M6LvU-0000mN-HN@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 19, 2009 at 11:48:00AM +0200, Miklos Szeredi wrote:
> On Mon, 18 May 2009, Jan Blunck wrote:
> > Here is another post of the VFS based union mount implementation.
> > 
> > Traditionally the mount operation is opaque, which means that the content of
> > the mount point, the directory where the file system is mounted on, is hidden
> > by the content of the mounted file system's root directory until the file
> > system is unmounted again. Unlike the traditional UNIX mount mechanism, that
> > hides the contents of the mount point, a union mount presents a view as if
> > both filesystems are merged together. Although only the topmost layer of the
> > mount stack can be altered, it appears as if transparent file system mounts
> > allow any file to be created, modified or deleted.
> > 
> > Most people know the concepts and features of union mounts from other
> > operating systems like Sun's Translucent Filesystem, Plan9 or BSD. For an
> > in-depth review of union mounts and other unioning file systems, see:
> > 
> > http://lwn.net/Articles/324291/
> > http://lwn.net/Articles/325369/
> > http://lwn.net/Articles/327738/
> > 
> > Here are the key features of this implementation:
> > - completely VFS based
> > - does not change the namespace stacking
> > - directory listings have duplicate entries removed in the kernel
> > - writable unions: only the topmost file system layer may be writable
> > - writable unions: new whiteout filetype handled inside the kernel
> > 
> > Major changes since last post:
> > - Updated the whiteout patches:
> >   - DCACHE_WHITEOUT flag set on a negative dentry
> >   - uses filetype instead of reserved inode number on EXT2
> > - Copy-up directories during lookup
> > - Implemented fallthru support for in-kernel readdir() as proposed by
> >   Valerie Aurora (Henson)
> 
> Does this copy up directories persistently?  If so, does this
> implementation no longer supports union of all read-only branches?

As Jan said, readdir() of read-only unioned file systems works with a
tmpfs top layer.  If you think about it, this is the exact equivalent
of the version of union mounts which used the in-kernel caching
approach - except that it's better, because it reuses existing code
and caches between readdir() calls.  Cool, huh?

Do you have ideas for how to do this better?  I particularly would
like to be able to get rid of the tmpfs dentries when no one is
readdir()ing on that directory.

-VAL
