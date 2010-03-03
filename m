Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756652Ab0CCUpn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 15:45:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46315 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752860Ab0CCUpf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 15:45:35 -0500
Date: Wed, 3 Mar 2010 15:45:13 -0500
From: Valerie Aurora <vaurora@redhat.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: viro@zeniv.linux.org.uk, hch@infradead.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, jblunck@suse.de
Subject: Re: [PATCH 1/6] union-mount: Introduce union_mount structure and basic operations
Message-ID: <20100303204513.GC19689@shell>
References: <1267567889-4637-1-git-send-email-vaurora@redhat.com> <1267567889-4637-2-git-send-email-vaurora@redhat.com> <E1NmsRk-0003tE-BO@pomaz-ex.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1NmsRk-0003tE-BO@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 03, 2010 at 06:33:20PM +0100, Miklos Szeredi wrote:
> On Tue,  2 Mar 2010, Valerie Aurora wrote:
> > +struct union_mount *union_alloc(struct dentry *this, struct vfsmount *this_mnt,
> > +				struct dentry *next, struct vfsmount *next_mnt)
> 
> 
> Why doesn't union_alloc, append_to_union, union_lookup,
> union_down_one, etc use "struct path *" arg instead of separate
> vfsmount and dentry pointers?

I'd prefer that too, but it isn't a clear win.  For append_to_union(),
the reason is that we call it when a file system is mounted, using mnt
and mnt->mnt_root as the first args:

int attach_mnt_union(struct vfsmount *mnt, struct vfsmount *dest_mnt,
		     struct dentry *dest_dentry)
{
	if (!IS_MNT_UNION(mnt))
		return 0;

	return append_to_union(mnt, mnt->mnt_root, dest_mnt, dest_dentry);
}

Same thing happens in detach_mnt_union() with union_lookup().  That
trickles down into the rest.  I suppose I could create a temporary
path variable for those two functions and then we'd be paths
everywhere else.  What do you think?

> > +     um = kmem_cache_alloc(union_cache, GFP_ATOMIC);
> > +     if (!um)
> > +             return NULL;
> > +
> > +     atomic_set(&um->u_count, 1);
> 
> Why is u_count not a "struct kref"?

We stole this from the inode cache code, so for the same reason inodes
have i_count as atomic_t instead of a kref (whatever that is). :)

> > > +/*
> > + * WARNING! Confusing terminology alert.
> > + *
> > + * Note that the directions "up" and "down" in union mounts are the
> > + * opposite of "up" and "down" in normal VFS operation terminology.
> > + * "up" in the rest of the VFS means "towards the root of the mount
> > + * tree."  If you mount B on top of A, following B "up" will get you
> > + * A.  In union mounts, "up" means "towards the most recently mounted
> > + * layer of the union stack."  If you union mount B on top of A,
> > + * following A "up" will get you to B.  Another way to put it is that
> > + * "up" in the VFS means going from this mount towards the direction
> > + * of its mnt->mnt_parent pointer, but "up" in union mounts means
> > + * going in the opposite direction (until you run out of union
> > + * layers).
> > + */
> 
> So if this is confusing, why not use a different terminology for union
> layers?  Like "next" and "prev" like it is already used in the
> structures.

Unfortunately, "upper" and "lower" are fairly well established
concepts in layering file systems and seem to be the most natural way
for programmers to think about unioned file systems.  It's only the
VFS (which most people never touch) that uses "up" and "down" in the
opposite sense.  I think the better path is to replace "next" and
"prev" in the structure.

-VAL
