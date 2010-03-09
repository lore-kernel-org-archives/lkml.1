Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754828Ab0CITtr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 14:49:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45793 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752376Ab0CITti (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 14:49:38 -0500
Date: Tue, 9 Mar 2010 14:49:16 -0500
From: Valerie Aurora <vaurora@redhat.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: viro@zeniv.linux.org.uk, hch@infradead.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, jblunck@suse.de
Subject: Re: [PATCH 1/6] union-mount: Introduce union_mount structure and basic operations
Message-ID: <20100309194916.GB10605@shell>
References: <1267567889-4637-1-git-send-email-vaurora@redhat.com> <1267567889-4637-2-git-send-email-vaurora@redhat.com> <E1NmsRk-0003tE-BO@pomaz-ex.szeredi.hu> <20100303204513.GC19689@shell> <E1NnDr7-00067s-NJ@pomaz-ex.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1NnDr7-00067s-NJ@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 04, 2010 at 05:24:57PM +0100, Miklos Szeredi wrote:
> On Wed, 3 Mar 2010, Valerie Aurora wrote:
> > On Wed, Mar 03, 2010 at 06:33:20PM +0100, Miklos Szeredi wrote:
> > > On Tue,  2 Mar 2010, Valerie Aurora wrote:
> > > > +struct union_mount *union_alloc(struct dentry *this, struct vfsmount *this_mnt,
> > > > +				struct dentry *next, struct vfsmount *next_mnt)
> > > 
> > > 
> > > Why doesn't union_alloc, append_to_union, union_lookup,
> > > union_down_one, etc use "struct path *" arg instead of separate
> > > vfsmount and dentry pointers?
> > 
> > I'd prefer that too, but it isn't a clear win.  For append_to_union(),
> > the reason is that we call it when a file system is mounted, using mnt
> > and mnt->mnt_root as the first args:
> > 
> > int attach_mnt_union(struct vfsmount *mnt, struct vfsmount *dest_mnt,
> > 		     struct dentry *dest_dentry)
> > {
> > 	if (!IS_MNT_UNION(mnt))
> > 		return 0;
> > 
> > 	return append_to_union(mnt, mnt->mnt_root, dest_mnt, dest_dentry);
> > }
> > 
> > Same thing happens in detach_mnt_union() with union_lookup().  That
> > trickles down into the rest.  I suppose I could create a temporary
> > path variable for those two functions and then we'd be paths
> > everywhere else.  What do you think?
> 
> If it's just two temporary vars, then IMO it's a win.  It's much
> easier to read the functions if it has half the arguments.

I agree, I'll make that change.

> > > > +     um = kmem_cache_alloc(union_cache, GFP_ATOMIC);
> > > > +     if (!um)
> > > > +             return NULL;
> > > > +
> > > > +     atomic_set(&um->u_count, 1);
> > > 
> > > Why is u_count not a "struct kref"?
> > 
> > We stole this from the inode cache code, so for the same reason inodes
> > have i_count as atomic_t instead of a kref (whatever that is). :)
> 
> i_count does some tricky things.  If you just want plain an simple
> refcounting then you should be using krefs.

Could you elaborate more?  I don't see what's so tricky about an
atomic counter.

Thanks,

-VAL
