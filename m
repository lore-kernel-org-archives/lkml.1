Return-Path: <linux-kernel-owner+w=401wt.eu-S1753900AbXDJVWJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753900AbXDJVWJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 17:22:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753908AbXDJVWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 17:22:09 -0400
Received: from wr-out-0506.google.com ([64.233.184.236]:29175 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753900AbXDJVWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 17:22:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=CpZfABcWstBVooX1q+GYiA2VW/Xwqf/JcB5yvFdjaRiQgOem6Tnji7QBzmIkLkxdiyMdwKz6UjEoCtWijFYHqOShBlEJwjc2TSE1CiAlSuOFJ77zzPkEblUEP5r5rK2Fsxp9b4dC9eCiGwUj1Zsec7fj1uaBmahzGOmUGtNwXJA=
Message-ID: <5c49b0ed0704101422k42841e33q50e8da578b215797@mail.gmail.com>
Date: Tue, 10 Apr 2007 14:22:03 -0700
From: "Nate Diller" <nate.diller@gmail.com>
To: "Anton Altaparmakov" <aia21@cam.ac.uk>
Subject: Re: [PATCH 1/2] fs: use memclear_highpage_flush to zero page data
Cc: "Alexander Viro" <viro@zeniv.linux.org.uk>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "Linux Filesystems" <linux-fsdevel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <964C9C13-69B7-4B05-968D-CAAFDDD3FFBF@cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070410043137.19370.2295.patchbomb.py@localhost>
	 <20070409231006.242a8304.akpm@linux-foundation.org>
	 <964C9C13-69B7-4B05-968D-CAAFDDD3FFBF@cam.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/10/07, Anton Altaparmakov <aia21@cam.ac.uk> wrote:
> On 10 Apr 2007, at 07:10, Andrew Morton wrote:
> > On Mon, 09 Apr 2007 21:31:37 -0700 Nate Diller
> > <nate.diller@gmail.com> wrote:
> >> It's very common for file systems to need to zero part or all of a
> >> page, the
> >> simplist way is just to use kmap_atomic() and memset().  There's
> >> actually a
> >> library function in include/linux/highmem.h that does exactly
> >> that, but it's
> >> confusingly named memclear_highpage_flush(), which is descriptive
> >> of *how*
> >> it does the work rather than what the *purpose* is.  So this patch
> >> renames
> >> the function to zero_page_data(), and calls it from the various
> >> places that
> >> currently open code it.
> >>
> >> Compile tested in x86_64.
> >>
> >> signed-off-by: Nate Diller <nate.diller@gmail.com>
> >>
> >> ---
> >>
> >>  drivers/block/loop.c                     |    6 ---
> >>  fs/affs/file.c                           |    6 ---
> >>  fs/buffer.c                              |   53 ++++
> >> +--------------------------
> >>  fs/direct-io.c                           |    8 +---
> >>  fs/ecryptfs/mmap.c                       |   14 +-------
> >>  fs/ext3/inode.c                          |   12 +------
> >>  fs/ext4/inode.c                          |   12 +------
> >>  fs/ext4/writeback.c                      |   12 +------
> >>  fs/gfs2/bmap.c                           |    6 ---
> >>  fs/mpage.c                               |   11 +-----
> >>  fs/nfs/read.c                            |   10 ++---
> >>  fs/nfs/write.c                           |    2 -
> >>  fs/ntfs/aops.c                           |   32 +++---------------
> >>  fs/ntfs/file.c                           |   47 ++++
> >> +----------------------
> >>  fs/ocfs2/aops.c                          |    5 --
> >>  fs/reiser4/plugin/file/cryptcompress.c   |   19 +----------
> >>  fs/reiser4/plugin/file/file.c            |    6 ---
> >>  fs/reiser4/plugin/item/ctail.c           |    6 ---
> >>  fs/reiser4/plugin/item/extent_file_ops.c |   19 +++--------
> >>  fs/reiser4/plugin/item/tail.c            |    8 +---
> >>  fs/reiserfs/file.c                       |   39 +++++
> >> +----------------
> >>  fs/reiserfs/inode.c                      |   13 +------
> >>  fs/xfs/linux-2.6/xfs_lrw.c               |    2 -
> >>  include/linux/highmem.h                  |    2 -
> >>  mm/filemap_xip.c                         |    7 ----
> >>  mm/truncate.c                            |    2 -
> >>  26 files changed, 78 insertions(+), 281 deletions(-)
> >>
> >
> > Not sure that I agree with the name zero_page_data().  People might
> > use it
> > to, err, zero a page's data.  Whereas it is really only for use
> > against
> > *user* pages.   zero_user_page(), perhaps.
> >
> > Plus..
> >
> > This patch as presented causes me surprising amounts of trouble.  I
> > need to
> > split it up into
> >
> >   - core plus filesystems which don't have maintainers (for me to
> > merge)
> >
> >   - filesystems which do have maintainers (one patch per), for
> >     maintainers to merge.
> >
> >   - another patch for reiser4, to remain in -mm.
> >
> > And this is actually not possible to do, because my merge and the
> > subsystem
> > maintainers' merges will happen at different times.  In the
> > intervening
> > window, the kernel won't compile.
> >
> > So instead I need to
> >
> >   - split off the reiser4 bit
> >
> >   - get acks from fs maintainers on the rest
> >
> >   - merge the whole thing in one hit (minus reiser4)
> >
> > And I can do that, but it is the less preferable option.
> >
> >
> > The better way to do this merge is:
> >
> > patch #1:
> >
> > static inline void memclear_highpage_flush(...) __deprecated
> > {
> >       zero_user_page(...);
> > }
> >
> > patch #2..n:  convert filesystems.
> >
> >
> > then, when all filesystems are converted, we're ready to remove
> > memclear_highpage_flush().  But we do that six months later - let's
> > not
> > screw out-of-tree fs maintainers (and their users) unnecessarily.
>
> Nate, I think you either do not understand what the KM_* constants
> passed to kmap_atomic() mean or you were overeager in your code
> replacement...  You really, really cannot replace KM_BIO_SRC_IRQ with
> KM_USER0 in the NTFS i/o completion handler without trashing people's
> data left right an centre!

good catch, I was indeed careless on that one.  I just double checked
all the other changes and that was the only non-KM_USER0 that slipped
through.  Thanks!

I will submit a new patch later today that fixes this problem and the
issues AKPM raised.

NATE
