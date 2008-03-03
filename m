Return-Path: <linux-kernel-owner+w=401wt.eu-S1758787AbYCCUT3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758787AbYCCUT3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 15:19:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755761AbYCCUSu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 15:18:50 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:22852 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755612AbYCCUSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 15:18:47 -0500
Date: Mon, 3 Mar 2008 12:17:58 -0800
From: Joel Becker <Joel.Becker@oracle.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] fs/configfs/ cleanups
Message-ID: <20080303201758.GB679@mail.oracle.com>
Mail-Followup-To: Adrian Bunk <bunk@kernel.org>,
	linux-kernel@vger.kernel.org
References: <20080227212048.GM29269@cs181133002.pp.htv.fi> <20080227223629.GA19656@mail.oracle.com> <20080303180737.GI26072@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080303180737.GI26072@cs181133002.pp.htv.fi>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
	come to perfection.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 03, 2008 at 08:07:37PM +0200, Adrian Bunk wrote:
> > I'd also take a patch to remove configfs_hash_and_remove().
> 
> Patch below.
> 
> > Joel
> 
> cu
> Adrian
> 
> 
> <--  snip  -->
> 
> 
> This patch contains the following cleanups:
> - make the needlessly global file.c:configfs_add_file() static
> - remove the unused inode.c:configfs_hash_and_remove()
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
Acked-by: Joel Becker <joel.becker@oracle.com>

> 
> ---
> 
>  fs/configfs/configfs_internal.h |    3 ---
>  fs/configfs/file.c              |    3 ++-
>  fs/configfs/inode.c             |   23 -----------------------
>  3 files changed, 2 insertions(+), 27 deletions(-)
> 
> 927a9da2f7bae91593a5735477c2605f34872302 foobar
> diff --git a/fs/configfs/configfs_internal.h b/fs/configfs/configfs_internal.h
> index cca9860..378fa36 100644
> --- a/fs/configfs/configfs_internal.h
> +++ b/fs/configfs/configfs_internal.h
> @@ -63,9 +63,6 @@ extern int configfs_create_file(struct config_item *, const struct configfs_attr
>  extern int configfs_make_dirent(struct configfs_dirent *,
>  				struct dentry *, void *, umode_t, int);
>  
> -extern int configfs_add_file(struct dentry *, const struct configfs_attribute *, int);
> -extern void configfs_hash_and_remove(struct dentry * dir, const char * name);
> -
>  extern const unsigned char * configfs_get_name(struct configfs_dirent *sd);
>  extern void configfs_drop_dentry(struct configfs_dirent *sd, struct dentry *parent);
>  extern int configfs_setattr(struct dentry *dentry, struct iattr *iattr);
> diff --git a/fs/configfs/file.c b/fs/configfs/file.c
> index 397cb50..f331a40 100644
> --- a/fs/configfs/file.c
> +++ b/fs/configfs/file.c
> @@ -314,7 +314,8 @@ const struct file_operations configfs_file_operations = {
>  };
>  
>  
> -int configfs_add_file(struct dentry * dir, const struct configfs_attribute * attr, int type)
> +static int configfs_add_file(struct dentry * dir,
> +			     const struct configfs_attribute * attr, int type)
>  {
>  	struct configfs_dirent * parent_sd = dir->d_fsdata;
>  	umode_t mode = (attr->ca_mode & S_IALLUGO) | S_IFREG;
> diff --git a/fs/configfs/inode.c b/fs/configfs/inode.c
> index 4c1ebff..c655024 100644
> --- a/fs/configfs/inode.c
> +++ b/fs/configfs/inode.c
> @@ -233,29 +233,6 @@ void configfs_drop_dentry(struct configfs_dirent * sd, struct dentry * parent)
>  	}
>  }
>  
> -void configfs_hash_and_remove(struct dentry * dir, const char * name)
> -{
> -	struct configfs_dirent * sd;
> -	struct configfs_dirent * parent_sd = dir->d_fsdata;
> -
> -	if (dir->d_inode == NULL)
> -		/* no inode means this hasn't been made visible yet */
> -		return;
> -
> -	mutex_lock(&dir->d_inode->i_mutex);
> -	list_for_each_entry(sd, &parent_sd->s_children, s_sibling) {
> -		if (!sd->s_element)
> -			continue;
> -		if (!strcmp(configfs_get_name(sd), name)) {
> -			list_del_init(&sd->s_sibling);
> -			configfs_drop_dentry(sd, dir);
> -			configfs_put(sd);
> -			break;
> -		}
> -	}
> -	mutex_unlock(&dir->d_inode->i_mutex);
> -}
> -
>  int __init configfs_inode_init(void)
>  {
>  	return bdi_init(&configfs_backing_dev_info);
> 

-- 

"The first requisite of a good citizen in this republic of ours
 is that he shall be able and willing to pull his weight."
	- Theodore Roosevelt

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
