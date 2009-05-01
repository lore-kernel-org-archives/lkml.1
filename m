Return-Path: <linux-kernel-owner+w=401wt.eu-S1763406AbZEANcP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763406AbZEANcP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 09:32:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761139AbZEANbO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 09:31:14 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:26133 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760735AbZEANbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 09:31:12 -0400
Subject: Re: [PATCH 5/6] kill-the-BKL/reiserfs: release the write lock
 inside reiserfs_read_bitmap_block()
From: Chris Mason <chris.mason@oracle.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Jeff Mahoney <jeffm@suse.com>,
       ReiserFS Development List <reiserfs-devel@vger.kernel.org>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Alessio Igor Bogani <abogani@texware.it>,
       Jonathan Corbet <corbet@lwn.net>,
       Alexander Viro <viro@zeniv.linux.org.uk>
In-Reply-To: <20090501131955.GC6011@nowhere>
References: <1241145862-21700-1-git-send-email-fweisbec@gmail.com>
	 <1241145862-21700-6-git-send-email-fweisbec@gmail.com>
	 <20090501054734.GE5983@elte.hu>  <20090501131955.GC6011@nowhere>
Content-Type: text/plain
Date: Fri, 01 May 2009 09:30:51 -0400
Message-Id: <1241184651.13084.15.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt707.oracle.com [141.146.40.85]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010209.49FAF98E.00BF:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-05-01 at 15:19 +0200, Frederic Weisbecker wrote:
> On Fri, May 01, 2009 at 07:47:34AM +0200, Ingo Molnar wrote:
> > 
> > * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > 
> > > reiserfs_read_bitmap_block() uses sb_bread() to read the bitmap block. This
> > > helper might sleep.
> > > 
> > > Then, when the bkl was used, it was released at this point. We can then
> > > relax the write lock too here.
> > > 
> > > [ Impact: release the reiserfs write lock when it is not needed ]
> > > 
> > > Cc: Jeff Mahoney <jeffm@suse.com>
> > > Cc: Chris Mason <chris.mason@oracle.com>
> > > Cc: Alexander Beregalov <a.beregalov@gmail.com>
> > > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > > ---
> > >  fs/reiserfs/bitmap.c |    2 ++
> > >  1 files changed, 2 insertions(+), 0 deletions(-)
> > > 
> > > diff --git a/fs/reiserfs/bitmap.c b/fs/reiserfs/bitmap.c
> > > index 1470334..6854957 100644
> > > --- a/fs/reiserfs/bitmap.c
> > > +++ b/fs/reiserfs/bitmap.c
> > > @@ -1249,7 +1249,9 @@ struct buffer_head *reiserfs_read_bitmap_block(struct super_block *sb,
> > >  	else if (bitmap == 0)
> > >  		block = (REISERFS_DISK_OFFSET_IN_BYTES >> sb->s_blocksize_bits) + 1;
> > >  
> > > +	reiserfs_write_unlock(sb);
> > >  	bh = sb_bread(sb, block);
> > > +	reiserfs_write_lock(sb);
> > >  	if (bh == NULL)
> > >  		reiserfs_warning(sb, "sh-2029: %s: bitmap block (#%u) "
> > >  		                 "reading failed", __func__, block);
> > 
> > Note, there's a side-effect here: the access to sb->b_blocksize is 
> > moved outside of the lock. Previously it was accessed via the BKL. 
> > On a mounted filesystem sb->b_blocksize is not supposed to change, 
> > so it's probably not an issue - but wanted to mention it.

> Indeed. Well I guess it can't be dynamically changed.
> This is something that can be chosen with mkfs on filesystem creation
> but I guess it can't be changed, at least not while the filesystem
> is mounted. I hope...

The blocksize should only be changing very early in the mount.  It is
basically:

set the block size to something
read the super block
read the block size from the super block
set the block size to the correct value
use it from then on.

This should all be done with by the time we read bitmaps.

-chris


