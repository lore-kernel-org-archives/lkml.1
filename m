Return-Path: <linux-kernel-owner+w=401wt.eu-S1758814AbXEJLgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758814AbXEJLgU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 07:36:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754492AbXEJLgH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 07:36:07 -0400
Received: from wr-out-0506.google.com ([64.233.184.235]:56748 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754173AbXEJLgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 07:36:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=OlqWsRuxpSB6y4O4Wp+QvsZGjyy4F09IhBbnXRR5amM+Aup2dF6g6A93hEsjfk4VOCwHe4q7WYogHvE1fD0rZ0oV/OKeF+74jHel9O+UYxvfp9sHTtndRDqU3fB7gBEGxSVKDLTu4p8i2gSwFf78mHm9QeERFwWXxLrjp2n9SGQ=
Message-ID: <a781481a0705100436r389bad5ct85bd2a1bec9ab0d0@mail.gmail.com>
Date: Thu, 10 May 2007 17:06:04 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/4] ext2: remove inode constructor
Cc: "Pekka J Enberg" <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       sct@redhat.com, adilger@clusterfs.com, clameter@sgi.com
In-Reply-To: <20070509133948.814128f4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0705051256530.20886@sbz-30.cs.Helsinki.FI>
	 <20070509133948.814128f4.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/10/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Sat, 5 May 2007 12:57:46 +0300 (EEST)
> Pekka J Enberg <penberg@cs.helsinki.fi> wrote:
>
> > From: Pekka Enberg <penberg@cs.helsinki.fi>
> >
> > As alloc_inode() touches the same cache line as init_once(), we gain
> > nothing from using slab constructors.
> >
> > Cc: Stephen C. Tweedie <sct@redhat.com>
> > Cc: Andreas Dilger <adilger@clusterfs.com>
> > Cc: Christoph Lameter <clameter@sgi.com>
> > Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
> > ---
> >  fs/ext2/super.c |   32 +++++++++++++-------------------
> >  1 file changed, 13 insertions(+), 19 deletions(-)
> >
> > Index: 26-mm/fs/ext2/super.c
> > ===================================================================
> > --- 26-mm.orig/fs/ext2/super.c        2007-05-05 12:26:15.000000000 +0300
> > +++ 26-mm/fs/ext2/super.c     2007-05-05 12:30:50.000000000 +0300
> > @@ -140,16 +140,24 @@ static struct kmem_cache * ext2_inode_ca
> >  static struct inode *ext2_alloc_inode(struct super_block *sb)
> >  {
> >       struct ext2_inode_info *ei;
> > -     ei = (struct ext2_inode_info *)kmem_cache_alloc(ext2_inode_cachep,
> > -                                             GFP_KERNEL|__GFP_RECLAIMABLE);
> > +     struct inode *inode;
> > +
> > +     ei = kmem_cache_alloc(ext2_inode_cachep, GFP_KERNEL|__GFP_RECLAIMABLE);
> >       if (!ei)
> >               return NULL;
> > +     rwlock_init(&ei->i_meta_lock);
> > +#ifdef CONFIG_EXT2_FS_XATTR
> > +     init_rwsem(&ei->xattr_sem);
> > +#endif
> > +     mutex_init(&ei->truncate_mutex);
>
> ext2 has no truncate_mutex.

2.6.21-mm2/broken-out/ext2-reservations.patch seems to have added one.

> These patches are rather tangled up with the unmerged __GFP_RECLAIMABLE
> stuff.

So _and_ the unmerged ext2-reservations stuff, you mean :-)

> I'll duck them for now.
