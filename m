Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753618Ab0BVO4q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 09:56:46 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39870 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753115Ab0BVO4p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 09:56:45 -0500
Date: Tue, 23 Feb 2010 01:56:39 +1100
From: Nick Piggin <npiggin@suse.de>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/7] vfs: notify_changes() error handling
Message-ID: <20100222145639.GW9738@laptop>
References: <1266608845-13212-1-git-send-email-dmonakhov@openvz.org>
 <20100222103516.GA5131@atrey.karlin.mff.cuni.cz>
 <20100222111510.GT9738@laptop>
 <87eikdo0st.fsf@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87eikdo0st.fsf@openvz.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 22, 2010 at 04:30:26PM +0300, Dmitry Monakhov wrote:
> Nick Piggin <npiggin@suse.de> writes:
> 
> > On Mon, Feb 22, 2010 at 11:35:17AM +0100, Jan Kara wrote:
> >> > After this notify_change() perform all necessary checks inside
> >> > inode_change_ok() and simply call nofail version of vmtruncate().
> >>   Actually, there are more problems than these in the truncate path.  Some
> >> filesystems can decide to fail truncate only in their .truncate method but that
> >> is called only after i_size is set which is too late.  Nick Piggin has a patch
> >> set which was addressing this problem and should be basically a superset of
> >> your changes. But I'm not sure whether the patch series is available somewhere
> >> or what it's current status. Nick?
> >
> > I think Al is happy with it in principle, I changed it as he suggested.
> > Maybe it was put on hold for other reasons. Anyway, here is the core
> > patch again. It now is basically just adding more helpers, so it's not
> > so intrusive.
> >
> > Al, what are your thoughts on merging? It doesn't appear to conflict
> > with the -vfs tree.
> >
> > Dmitry, this doesn't solve your quota problem, but they obviously clash
> > rather heavily. Do you see any problems with the way my patch goes?
> In fact i dont tried to solve quota issue. I just want to understand
> why error paths in my code becomes so huge and why they so differ
> from existing code, now i do understand why :)

Oh, but you attempted it (partially?) by moving the inode size
check into inode_change_ok().

> As soon as i understand this patch add changes only for core part.
> And later other filesystems will handle the rest.

Yes. Most of them we have converted to the new sequence in
subsequent patches. From that point it should be easier to improve
error handling.

> I am agree with it, vmtruncate is nightmare.
> But imho also we have to solve generic inode attr check/set issue
> fs_XXX_setattr()
> {
> ...
>    ret = inode_size_ok(inode, attr)
>    if (ret)
>         goto bad;
>    if(private_fs_update_on_disk_data(new_size))
>         goto bad;
>    if(simple_setsize(inode,new_size)) {
>      /* We still can get in to this because RLIMIT_FSIZE may be
>       * changed after inode_size_ok();
>       * So we have to roll back all fs-speciffic data which may be 
>       * paintfull or impossible
>       */
>       ret = private_fs_update_on_disk_data(old_size)
>       BUG_ON(ret)
>     }
> }
> So my purpose is:
> 1) to move inode_size_ok check in to inode_change_ok()
> 2) Introduce simple_setsize_nocheck() which just do it's work
>    after all checks was already done.
>    And call simple_setsize_nocheck() inside fsXXX_setattr instead
>    of simple_setsize().
> 
> Patch prepared agains yours "truncate: introduce new sequence"
 
Hmm, I wonder if it would be safer to rename the function if
changing behaviour like this so it loudly breaks external modules.

Possibly this breaks nfsd usage?

But as a general rule it's a good idea to do the easy checks first,
so I can't see the harm in moving inode_newsize_ok checks as early
as possible.


> >From a876d30dd06dfa772ca2a2184416762843fc3708 Mon Sep 17 00:00:00 2001
> From: Dmitry Monakhov <dmonakhov@openvz.org>
> Date: Mon, 22 Feb 2010 16:15:57 +0300
> Subject: [PATCH] vfs: inode_change_ok have to perform all necessery checks
> 
> Usually this is the only function which called before inode
> attributes manipulation. In fact inode_change_ok performs only
> posix checks. But it new_size check is also important. Otherwise
> we mail fail in very late stage.
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> ---
>  fs/attr.c          |   20 ++++++++++++++++++--
>  fs/libfs.c         |   26 +++++++++++++++++++-------
>  include/linux/fs.h |    5 +++--
>  3 files changed, 40 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/attr.c b/fs/attr.c
> index 1bca479..007c706 100644
> --- a/fs/attr.c
> +++ b/fs/attr.c
> @@ -18,7 +18,7 @@
>  /* Taken over from the old code... */
>  
>  /* POSIX UID/GID verification for setting inode attributes. */
> -int inode_change_ok(const struct inode *inode, struct iattr *attr)
> +int inode_change_posix_ok(const struct inode *inode, struct iattr *attr)
>  {
>  	int retval = -EPERM;
>  	unsigned int ia_valid = attr->ia_valid;
> @@ -60,7 +60,7 @@ fine:
>  error:
>  	return retval;
>  }
> -EXPORT_SYMBOL(inode_change_ok);
> +EXPORT_SYMBOL(inode_change_posix_ok);
>  
>  /**
>   * inode_newsize_ok - may this inode be truncated to a given size
> @@ -105,6 +105,22 @@ out_big:
>  }
>  EXPORT_SYMBOL(inode_newsize_ok);
>  
> +/*
> + * General verification for setting inode attributes.
> + */
> +int inode_change_ok(const struct inode *inode, struct iattr *attr)
> +{
> +	int ret;
> +	ret = inode_change_posix_ok(inode, attr);
> +	if (ret)
> +		return ret;
> +	if (attr->ia_valid & ATTR_SIZE)
> +		ret = inode_newsize_ok(inode, attr->ia_size);
> +	return ret;
> +}
> +EXPORT_SYMBOL(inode_change_ok);
> +
> +
>  /**
>   * generic_setattr - copy simple metadata updates into the generic inode
>   * @inode:	the inode to be updated
> diff --git a/fs/libfs.c b/fs/libfs.c
> index 338575b..2aa89d7 100644
> --- a/fs/libfs.c
> +++ b/fs/libfs.c
> @@ -329,6 +329,23 @@ int simple_rename(struct inode *old_dir, struct dentry *old_dentry,
>  
>  	return 0;
>  }
> +/**
> + * simple_setsize_nocheck - handle core mm and vfs requirements for file
> + * size change
> + * @inode: inode
> + * @newsize: new file size
> + * simple_setsize_nocheck must be called with inode_mutex held.
> + *
> + * Caller is responsible for all appropriate checks
> + */
> +void simple_setsize_nocheck(struct inode *inode, loff_t newsize)
> +{
> +	loff_t oldsize;
> +	oldsize = inode->i_size;
> +	i_size_write(inode, newsize);
> +	truncate_pagecache(inode, oldsize, newsize);
> +}
> +EXPORT_SYMBOL(simple_setsize_nocheck);
>  
>  /**
>   * simple_setsize - handle core mm and vfs requirements for file size change
> @@ -358,18 +375,13 @@ int simple_rename(struct inode *old_dir, struct dentry *old_dentry,
>   */
>  int simple_setsize(struct inode *inode, loff_t newsize)
>  {
> -	loff_t oldsize;
>  	int error;
>  
>  	error = inode_newsize_ok(inode, newsize);
>  	if (error)
>  		return error;
> -
> -	oldsize = inode->i_size;
> -	i_size_write(inode, newsize);
> -	truncate_pagecache(inode, oldsize, newsize);
> -
> -	return error;
> +	simple_setsize_nocheck(inode, newsize);
> +	return 0;
>  }
>  EXPORT_SYMBOL(simple_setsize);

If we move the inode_newsize_ok check up to inode_change_ok position,
then I think just the non-checking variant should be kept. Or it's
now simple enough that it can just be open-coded.

