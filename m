Return-Path: <linux-kernel-owner+w=401wt.eu-S1761383AbZBEA1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761383AbZBEA1S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 19:27:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758670AbZBEA06
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 19:26:58 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:33398 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757379AbZBEA05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 19:26:57 -0500
Date: Wed, 4 Feb 2009 18:26:55 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, hpa@zytor.com, hch@lst.de,
       sukadev@us.ibm.com, Containers <containers@lists.osdl.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [v2][PATCH 3/5] Move common mknod_ptmx() calls into caller
Message-ID: <20090205002655.GD17354@us.ibm.com>
References: <20090204043516.GB25963@us.ibm.com> <20090204043732.GC26202@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090204043732.GC26202@us.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Sukadev Bhattiprolu (sukadev@linux.vnet.ibm.com):
> 
> From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
> Date: Wed, 28 Jan 2009 18:54:25 -0800
> Subject: [v2][PATCH 3/5] Move common mknod_ptmx() calls into caller
> 
> We create 'ptmx' node in both single-instance and multiple-instance
> mounts. So devpts_get_sb() can call mknod_ptmx() once rather than
> have both modes calling mknod_ptmx() separately.
> 
> Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>

Acked-by: Serge Hallyn <serue@us.ibm.com>

And now I see, you could get rid of update_ptmx() because
mknod_ptmx() will be called again anyway.  So if you
haven't replied yet pls ignore my previous email where I
asked about that :)

thanks,
-serge

> ---
>  fs/devpts/inode.c |   36 +++++++++++++++++-------------------
>  1 files changed, 17 insertions(+), 19 deletions(-)
> 
> diff --git a/fs/devpts/inode.c b/fs/devpts/inode.c
> index 9b24de8..f7e887c 100644
> --- a/fs/devpts/inode.c
> +++ b/fs/devpts/inode.c
> @@ -343,17 +343,7 @@ static int new_pts_mount(struct file_system_type *fs_type, int flags,
>  	fsi = DEVPTS_SB(mnt->mnt_sb);
>  	memcpy(&fsi->mount_opts, opts, sizeof(opts));
> 
> -	err = mknod_ptmx(mnt->mnt_sb);
> -	if (err)
> -		goto fail;
> -
>  	return 0;
> -
> -fail:
> -	dput(mnt->mnt_sb->s_root);
> -	up_write(&mnt->mnt_sb->s_umount);
> -	deactivate_super(mnt->mnt_sb);
> -	return err;
>  }
> 
>  /*
> @@ -421,13 +411,6 @@ static int init_pts_mount(struct file_system_type *fs_type, int flags,
>  	if (err)
>  		return err;
> 
> -	err = mknod_ptmx(mnt->mnt_sb);
> -	if (err) {
> -		dput(mnt->mnt_sb->s_root);
> -		up_write(&mnt->mnt_sb->s_umount);
> -		deactivate_super(mnt->mnt_sb);
> -	}
> -
>  	return err;
>  }
> 
> @@ -445,9 +428,24 @@ static int devpts_get_sb(struct file_system_type *fs_type,
>  	}
> 
>  	if (opts.newinstance)
> -		return new_pts_mount(fs_type, flags, data, &opts, mnt);
> +		error = new_pts_mount(fs_type, flags, data, &opts, mnt);
>  	else
> -		return init_pts_mount(fs_type, flags, data, &opts, mnt);
> +		error = init_pts_mount(fs_type, flags, data, &opts, mnt);
> +
> +	if (error)
> +		return error;
> +
> +	error = mknod_ptmx(mnt->mnt_sb);
> +	if (error)
> +		goto out_dput;
> +
> +	return 0;
> +
> +out_dput:
> +	dput(mnt->mnt_sb->s_root);
> +	up_write(&mnt->mnt_sb->s_umount);
> +	deactivate_super(mnt->mnt_sb);
> +	return error;
>  }
> 
>  #else
> -- 
> 1.5.2.5
