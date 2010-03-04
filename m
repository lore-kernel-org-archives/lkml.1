Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755400Ab0CDQZV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 11:25:21 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:47347 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754869Ab0CDQZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 11:25:18 -0500
To: Valerie Aurora <vaurora@redhat.com>
CC: miklos@szeredi.hu, viro@zeniv.linux.org.uk, hch@infradead.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       jblunck@suse.de
In-reply-to: <20100303204513.GC19689@shell> (message from Valerie Aurora on
	Wed, 3 Mar 2010 15:45:13 -0500)
Subject: Re: [PATCH 1/6] union-mount: Introduce union_mount structure and basic operations
References: <1267567889-4637-1-git-send-email-vaurora@redhat.com> <1267567889-4637-2-git-send-email-vaurora@redhat.com> <E1NmsRk-0003tE-BO@pomaz-ex.szeredi.hu> <20100303204513.GC19689@shell>
Message-Id: <E1NnDr7-00067s-NJ@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 04 Mar 2010 17:24:57 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Mar 2010, Valerie Aurora wrote:
> On Wed, Mar 03, 2010 at 06:33:20PM +0100, Miklos Szeredi wrote:
> > On Tue,  2 Mar 2010, Valerie Aurora wrote:
> > > +struct union_mount *union_alloc(struct dentry *this, struct vfsmount *this_mnt,
> > > +				struct dentry *next, struct vfsmount *next_mnt)
> > 
> > 
> > Why doesn't union_alloc, append_to_union, union_lookup,
> > union_down_one, etc use "struct path *" arg instead of separate
> > vfsmount and dentry pointers?
> 
> I'd prefer that too, but it isn't a clear win.  For append_to_union(),
> the reason is that we call it when a file system is mounted, using mnt
> and mnt->mnt_root as the first args:
> 
> int attach_mnt_union(struct vfsmount *mnt, struct vfsmount *dest_mnt,
> 		     struct dentry *dest_dentry)
> {
> 	if (!IS_MNT_UNION(mnt))
> 		return 0;
> 
> 	return append_to_union(mnt, mnt->mnt_root, dest_mnt, dest_dentry);
> }
> 
> Same thing happens in detach_mnt_union() with union_lookup().  That
> trickles down into the rest.  I suppose I could create a temporary
> path variable for those two functions and then we'd be paths
> everywhere else.  What do you think?

If it's just two temporary vars, then IMO it's a win.  It's much
easier to read the functions if it has half the arguments.

> 
> > > +     um = kmem_cache_alloc(union_cache, GFP_ATOMIC);
> > > +     if (!um)
> > > +             return NULL;
> > > +
> > > +     atomic_set(&um->u_count, 1);
> > 
> > Why is u_count not a "struct kref"?
> 
> We stole this from the inode cache code, so for the same reason inodes
> have i_count as atomic_t instead of a kref (whatever that is). :)

i_count does some tricky things.  If you just want plain an simple
refcounting then you should be using krefs.

> > > > +/*
> > > + * WARNING! Confusing terminology alert.
> > > + *
> > > + * Note that the directions "up" and "down" in union mounts are the
> > > + * opposite of "up" and "down" in normal VFS operation terminology.
> > > + * "up" in the rest of the VFS means "towards the root of the mount
> > > + * tree."  If you mount B on top of A, following B "up" will get you
> > > + * A.  In union mounts, "up" means "towards the most recently mounted
> > > + * layer of the union stack."  If you union mount B on top of A,
> > > + * following A "up" will get you to B.  Another way to put it is that
> > > + * "up" in the VFS means going from this mount towards the direction
> > > + * of its mnt->mnt_parent pointer, but "up" in union mounts means
> > > + * going in the opposite direction (until you run out of union
> > > + * layers).
> > > + */
> > 
> > So if this is confusing, why not use a different terminology for union
> > layers?  Like "next" and "prev" like it is already used in the
> > structures.
> 
> Unfortunately, "upper" and "lower" are fairly well established
> concepts in layering file systems and seem to be the most natural way
> for programmers to think about unioned file systems.  It's only the
> VFS (which most people never touch) that uses "up" and "down" in the
> opposite sense.  I think the better path is to replace "next" and
> "prev" in the structure.

Okay.

Thanks,
Miklos
