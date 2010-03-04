Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754816Ab0CDQSX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 11:18:23 -0500
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:49709 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752415Ab0CDQSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 11:18:21 -0500
X-Authority-Analysis: v=1.0 c=1 a=hRh-p0rce0wA:10 a=4XYoNym+EpvD5hZxEfXtKw==:17 a=Lm5c0-V0AAAA:8 a=hGzw-44bAAAA:8 a=0BH8_ERza-xaczCZU8UA:9 a=fIWydjqMYBXZCLlpcyMA:7 a=Az96DOG7iH9UcO2jUbJachH9E24A:4 a=0e_BQ5Ttg00A:10 a=dowx1zmaLagA:10
X-Cloudmark-Score: 0
X-Originating-IP: 71.70.153.3
Date: Thu, 4 Mar 2010 11:18:12 -0500
From: Jeff Layton <jlayton@samba.org>
To: Jon Severinsson <jon@severinsson.net>
Cc: linux-cifs-client@lists.samba.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, obnox@samba.org
Subject: Re: [linux-cifs-client] [RFC PATCH] CIFS posix acl permission
 checking
Message-ID: <20100304111812.6af53003@barsoom.rdu.redhat.com>
In-Reply-To: <201003041150.08341.jon@severinsson.net>
References: <201003041150.08341.jon@severinsson.net>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.18.7; i686-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Mar 2010 11:50:04 +0100
Jon Severinsson <jon@severinsson.net> wrote:

> Hello
> 
> Early this weak I sent a patch implementing posix acl permission checking in 
> the linux cifs filesystem module. Unfortunately I only sent it to linux-fsdev 
> as I was unaware of the linux-cifs-client list. I later tried to submit it to 
> linux-cifs-client as well, but my message seems to have been lost in the 
> moderation queue, so I subscribed and am trying again.
> 
> I don't believe my patch is perfect, but I think it's a good start, and would 
> like some comments from more experienced cifs developers to be able to get it 
> into shape for inclusion in the kernel. 
> 
> I did get some comments from Matthew Wilcox at linux-fsdev, but unfortunately 
> he never followed up on my response, so I'm including some unresolved 
> questions I still have, as well as attaching the patch for further comments.
> 
> Best Regards
> Jon Severinsson
>

(cc'ing Michael Adam since he's been working on a similar patch)

I've looked over the patch and it's pretty good for a first attempt.
There are a few minor problems with it, but it's a reasonable first
pass.

The issues I have are with the approach -- you've stepped into a bit of
a minefield with regards to CIFS' design. The issues that Simo brings up
however are quite valid. Let me just state outright that permission
checking on the client is a completely bogus concept. There are a
couple of problems with this approach:

1) Someone could change the permissions on the server between the time
you check them and when you do your operation. Yes, I know that CIFS
already does this for permission bits, but that's dumb too.

2) Ownership matters. This patch will have no effect on how files get
created. They still get created with the owner set to the user who's
credentials were used, and you can't change them afterward (since users
can't "chown" files to other users). Now, it is possible to mount a
samba server with root's credentials. Then you can use the "setuids"
mount option to make chown's work and you *might* get files created the
way you intend. I really, really do not recommend this though -- it's a
bad idea to allow any user to share root's server credentials.

I'm convinced, after working on it for more than 3 years that the *only*
proper fix for the nightmare that is CIFS permissions is to make CIFS
use proper credentials in the first place. CIFS is currently completely
broken in this regard -- it's designed such that all accesses to the
mount use the same set of credentials, and that's just plain wrong.

Fixing this entails establishing new SMB sessions on the fly whenever a
user wants to do an on the wire operation. Obviously, we can't prompt
for passwords for this, so we need to limit this to krb5 creds or come
up with a way for people to stash credentials for the kernel to use for
this purpose. I'm about 1/3 of the way into a first draft of a patchset
to do this, but it won't be fixed anytime soon and may not be suitable
for CIFS with SMB2 getting development focus now.

Now, all of that said...I don't have a specific issue with adding a
patch to do this. I think this approach is completely ass-backwards and
broken, but we do already attempt to enforce permission bits on the
client currently. Adding checks for POSIX acl's don't make this (much)
worse.

The one thing I don't think we want though is to turn this on by
default since it means an extra round trip to the server every time
you want to check permissions. This needs to be "switchable" somehow --
possibly via mount option (maybe -o checkposixacls or something?)

> commit fa0b9415cda17b31966542101bc4ceb0c97c87cb
> Author: Jon Severinsson <jon@severinsson.net>
> Date:   Mon Mar 1 19:24:30 2010 +0100
> 
>     [CIFS] Adds support for permision checking vs. posix acl.
>     
>     CIFS already supports getting and setting acls through getfacl and setfacl, but
>     prior to this patch, any acls was ignored when doing permission checking.
> 
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index 29f1da7..0605e11 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -284,7 +284,7 @@ static int cifs_permission(struct inode *inode, int mask)
>  		on the client (above and beyond ACL on servers) for
>  		servers which do not support setting and viewing mode bits,
>  		so allowing client to check permissions is useful */
> -		return generic_permission(inode, mask, NULL);
> +		return generic_permission(inode, mask, inode->i_op->check_acl);
>  }
>  
>  static struct kmem_cache *cifs_inode_cachep;
> @@ -702,6 +702,9 @@ const struct inode_operations cifs_dir_inode_ops = {
>  	.getxattr = cifs_getxattr,
>  	.listxattr = cifs_listxattr,
>  	.removexattr = cifs_removexattr,
> +#ifdef CONFIG_CIFS_POSIX
> +	.check_acl = cifs_check_acl,
> +#endif
>  #endif
>  };
>  
> @@ -716,6 +719,9 @@ const struct inode_operations cifs_file_inode_ops = {
>  	.getxattr = cifs_getxattr,
>  	.listxattr = cifs_listxattr,
>  	.removexattr = cifs_removexattr,
> +#ifdef CONFIG_CIFS_POSIX
> +	.check_acl = cifs_check_acl,
> +#endif
>  #endif
>  };
>  
> @@ -732,6 +738,9 @@ const struct inode_operations cifs_symlink_inode_ops = {
>  	.getxattr = cifs_getxattr,
>  	.listxattr = cifs_listxattr,
>  	.removexattr = cifs_removexattr,
> +#ifdef CONFIG_CIFS_POSIX
> +	.check_acl = cifs_check_acl,
> +#endif
>  #endif
>  };
>  
> diff --git a/fs/cifs/cifsfs.h b/fs/cifs/cifsfs.h
> index ac2b24c..6409a83 100644
> --- a/fs/cifs/cifsfs.h
> +++ b/fs/cifs/cifsfs.h
> @@ -102,11 +102,15 @@ extern int cifs_readlink(struct dentry *direntry, char __user *buffer,
>  			 int buflen);
>  extern int cifs_symlink(struct inode *inode, struct dentry *direntry,
>  			const char *symname);
> +
> +/* Functions related to extended attributes */
>  extern int	cifs_removexattr(struct dentry *, const char *);
>  extern int 	cifs_setxattr(struct dentry *, const char *, const void *,
>  			size_t, int);
>  extern ssize_t	cifs_getxattr(struct dentry *, const char *, void *, size_t);
>  extern ssize_t	cifs_listxattr(struct dentry *, char *, size_t);
> +extern int cifs_check_acl(struct inode *inode, int mask);
> +
>  extern long cifs_ioctl(struct file *filep, unsigned int cmd, unsigned long arg);
>  
>  #ifdef CONFIG_CIFS_EXPERIMENTAL
> diff --git a/fs/cifs/xattr.c b/fs/cifs/xattr.c
> index a75afa3..a07633b 100644
> --- a/fs/cifs/xattr.c
> +++ b/fs/cifs/xattr.c
> @@ -374,3 +374,71 @@ ssize_t cifs_listxattr(struct dentry *direntry, char *data, size_t buf_size)
>  #endif
>  	return rc;
>  }
> +
> +int cifs_check_acl(struct inode *inode, int mask)
> +{
> +	int rc = -EOPNOTSUPP;
> +#ifdef CONFIG_CIFS_XATTR
> +#ifdef CONFIG_CIFS_POSIX
> +	struct dentry *dentry;
> +	size_t buf_size;
> +	void *ea_value = NULL;
> +	ssize_t ea_size;
> +	struct posix_acl *acl = NULL;
> +
> +	/* CIFS gets acl from server by path, and thus needs a dentry rather than
> +	   an inode. Note that the path of each dentry will point to the same inode
> +	   on the backing fs at the server, so their acls will be the same, and it
> +	   doesn't matter which one we pick, so just pick the fist. */

^^^ comments should follow kernel coding styles. Be sure to run your
patch through scripts/checkpatch.pl too.

> +	if (!list_empty(&inode->i_dentry))
> +		dentry = list_first_entry(&inode->i_dentry, struct dentry, d_alias);

		^^^^ you should probably dget this dentry to take a
		reference to it and then put it when you're finished
		with it. It could vanish out of the cache before you
		have a chance to use it otherwise.

> +	else
> +		return -EINVAL;
> +
> +	/* Try to fit the extended attribute corresponding to the posix acl in 4k
> +	   memory. 4k was chosen because it always fits in a single page, and is
> +	   the maximum on a default ext2/3/4 backing fs. */
> +	buf_size = 4096;
> +	ea_value = kmalloc(buf_size, GFP_KERNEL);
> +	if (!ea_value) {
> +		rc = -EAGAIN;
> +		goto check_acl_exit;
> +	}
> +	ea_size = cifs_getxattr(dentry, POSIX_ACL_XATTR_ACCESS, ea_value, buf_size);
> +
> +	/* If 4k wasn't enough, try 64k, the maximum on any current backing fs. */
> +	if (ea_size == -ERANGE) {
> +		kfree(ea_value);
> +		buf_size = 65536;
> +		ea_value = kmalloc(buf_size, GFP_KERNEL);
> +		if (!ea_value) {
> +			rc = -EAGAIN;
> +			goto check_acl_exit;
> +		}
> +		ea_size = cifs_getxattr(dentry, POSIX_ACL_XATTR_ACCESS, ea_value, buf_size);
> +	}
> +
> +	/* If we didn't get any extended attribute, set the error code and exit */
> +	if (ea_size <= 0) {
> +		rc = -EAGAIN;
> +		if (ea_size == -EOPNOTSUPP || ea_size == -EIO || ea_size == -ENOTDIR || ea_size == -ENOENT || ea_size == -EFAULT || ea_size == -EACCES)
> +			rc = ea_size;
> +		goto check_acl_exit;
> +	}
> +
> +	/* Set the appropriate return value. Adapted from ext4. */
> +	acl = posix_acl_from_xattr(ea_value, ea_size);
> +	if (IS_ERR(acl))
> +		rc = PTR_ERR(acl);
> +	else if (acl)
> +		rc = posix_acl_permission(inode, acl, mask);
> +	else
> +		rc = -EAGAIN;
> +
> +check_acl_exit:
> +	posix_acl_release(acl);
> +	kfree(ea_value);
> +#endif /* CONFIG_CIFS_POSIX */
> +#endif /* CONFIG_CIFS_XATTR */
> +	return rc;
> +}

The rest of the patch looks reasonable but I agree with Simo that all
of our time would be better spent working to make CIFS use proper
credentials on the wire.

-- 
Jeff Layton <jlayton@samba.org>
