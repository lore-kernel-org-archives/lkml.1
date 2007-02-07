Return-Path: <linux-kernel-owner+w=401wt.eu-S1161360AbXBGPgZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161360AbXBGPgZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 10:36:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030632AbXBGPgZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 10:36:25 -0500
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:45783 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030631AbXBGPgX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 10:36:23 -0500
Date: Wed, 7 Feb 2007 07:43:32 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: Andreas Gruenbacher <agruen@suse.de>
Cc: Stephen Smalley <sds@tycho.nsa.gov>, Jeff Mahoney <jeffm@suse.de>,
       Christoph Hellwig <hch@infradead.org>, Tony Jones <tonyj@suse.de>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chrisw@sous-sol.org, linux-security-module@vger.kernel.org,
       viro@zeniv.linux.org.uk
Subject: Re: [RFC 0/28] Patches to pass vfsmount to LSM inode security hooks
Message-ID: <20070207154332.GF10574@sequoia.sous-sol.org>
References: <20070205182213.12164.40927.sendpatchset@ermintrude.int.wirex.com> <200702051813.26958.agruen@suse.de> <1170766539.12293.370.camel@moss-spartans.epoch.ncsc.mil> <200702070055.10856.agruen@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702070055.10856.agruen@suse.de>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Andreas Gruenbacher (agruen@suse.de) wrote:
> Reiserfs currently only marks the ".reiserfs_priv" directory as private, but 
> not the files below it -- how about the attached patch to fix that?

I don't think that's right.  Look at ->create or ->lookup.  Both of those
properly set the private flag.  This patch looks like a step backwards,
sprinkling the init in so many places.

> Fix reiserfs xattrs for selinux
> 
> Mark all inodes used for reiserfs xattrs as private so that selinux
> (or any other LSM) will not try to mediate access to the files and
> directories used as the xattr backing store. The xattr operations
> are already protected through the xattr LSM hooks.
> 
> There is no real reason for having reiserfs_mark_inode_private --
> remove it and directly mark the inodes as private.
> 
> Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
> Cc: Jeff Mahoney <jeffm@suse.de>
> 
> Index: b/fs/reiserfs/xattr.c
> ===================================================================
> --- a/fs/reiserfs/xattr.c
> +++ b/fs/reiserfs/xattr.c
> @@ -79,6 +79,7 @@ static struct dentry *create_xa_root(str
>  			dput(privroot);
>  			return ERR_PTR(err);
>  		}
> +		xaroot->d_inode->i_flags |= S_PRIVATE;

Already handled in the above ->mkdir

>  		REISERFS_SB(sb)->xattr_root = dget(xaroot);
>  	}
>  
> @@ -108,6 +109,7 @@ static struct dentry *__get_xa_root(stru
>  		goto out;
>  	}
>  
> +	xaroot->d_inode->i_flags |= S_PRIVATE;

Already handled during xa_root creation

>  	REISERFS_SB(s)->xattr_root = dget(xaroot);
>  
>        out:
> @@ -183,6 +185,7 @@ static struct dentry *open_xa_dir(const 
>  			return ERR_PTR(-ENODATA);
>  		}
>  	}
> +	xadir->d_inode->i_flags |= S_PRIVATE;

Already handled in lookup or mkdir

>  	dput(xaroot);
>  	return xadir;
> @@ -235,6 +238,8 @@ static struct dentry *get_xa_file_dentry
>  	dput(xadir);
>  	if (err)
>  		xafile = ERR_PTR(err);
> +	else
> +		xafile->d_inode->i_flags |= S_PRIVATE;

Already handled in lookup or create

>  	return xafile;
>  }
>  
> @@ -715,6 +720,7 @@ __reiserfs_xattr_del(struct dentry *xadi
>  		err = -ENODATA;
>  		goto out_file;
>  	}
Already handled in lookup

etc...
