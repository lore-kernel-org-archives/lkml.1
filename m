Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755626Ab0BDIgn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 03:36:43 -0500
Received: from bamako.nerim.net ([62.4.17.28]:54976 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751341Ab0BDIgl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 03:36:41 -0500
Date: Thu, 4 Feb 2010 09:36:38 +0100
From: Jean Delvare <khali@linux-fr.org>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       Tejun Heo <tj@kernel.org>, Serge Hallyn <serue@us.ibm.com>
Subject: Re: [PATCH] sysfs: sysfs_sd_setattr set iattrs unconditionally
Message-ID: <20100204093638.3116055e@hyperion.delvare>
In-Reply-To: <m1hbpxlbhn.fsf_-_@fess.ebiederm.org>
References: <20100120131602.12aa48f7@hyperion.delvare>
	<m1ocko6fkx.fsf@fess.ebiederm.org>
	<20100120160008.7d59688b@hyperion.delvare>
	<20100122041913.GC4302@suse.de>
	<20100203091138.1ababf5e@hyperion.delvare>
	<20100203142218.GA27676@suse.de>
	<m1hbpxlbhn.fsf_-_@fess.ebiederm.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 03 Feb 2010 23:13:24 -0800, Eric W. Biederman wrote:
> 
> There is currently a bug in sysfs_sd_setattr inherited from
> sysfs_setattr in 2.6.32 where the first time we set the attributes
> on a sysfs file we allocate backing store but do not set the
> backing store attributes.  Resulting in overly restrictive
> permissions on sysfs files.
> 
> The fix is to simply modify the code so that it always executes
> when we update the sysfs attributes, as we did in 2.6.31 and earlier.
> 
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>

Tested-by: Jean Delvare <khali@linux-fr.org>

> ---
>  fs/sysfs/inode.c |   35 +++++++++++++++++------------------
>  1 files changed, 17 insertions(+), 18 deletions(-)
> 
> diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
> index 220b758..6a06a1d 100644
> --- a/fs/sysfs/inode.c
> +++ b/fs/sysfs/inode.c
> @@ -81,24 +81,23 @@ int sysfs_sd_setattr(struct sysfs_dirent *sd, struct iattr * iattr)
>  		if (!sd_attrs)
>  			return -ENOMEM;
>  		sd->s_iattr = sd_attrs;
> -	} else {
> -		/* attributes were changed at least once in past */
> -		iattrs = &sd_attrs->ia_iattr;
> -
> -		if (ia_valid & ATTR_UID)
> -			iattrs->ia_uid = iattr->ia_uid;
> -		if (ia_valid & ATTR_GID)
> -			iattrs->ia_gid = iattr->ia_gid;
> -		if (ia_valid & ATTR_ATIME)
> -			iattrs->ia_atime = iattr->ia_atime;
> -		if (ia_valid & ATTR_MTIME)
> -			iattrs->ia_mtime = iattr->ia_mtime;
> -		if (ia_valid & ATTR_CTIME)
> -			iattrs->ia_ctime = iattr->ia_ctime;
> -		if (ia_valid & ATTR_MODE) {
> -			umode_t mode = iattr->ia_mode;
> -			iattrs->ia_mode = sd->s_mode = mode;
> -		}
> +	}
> +	/* attributes were changed at least once in past */
> +	iattrs = &sd_attrs->ia_iattr;
> +
> +	if (ia_valid & ATTR_UID)
> +		iattrs->ia_uid = iattr->ia_uid;
> +	if (ia_valid & ATTR_GID)
> +		iattrs->ia_gid = iattr->ia_gid;
> +	if (ia_valid & ATTR_ATIME)
> +		iattrs->ia_atime = iattr->ia_atime;
> +	if (ia_valid & ATTR_MTIME)
> +		iattrs->ia_mtime = iattr->ia_mtime;
> +	if (ia_valid & ATTR_CTIME)
> +		iattrs->ia_ctime = iattr->ia_ctime;
> +	if (ia_valid & ATTR_MODE) {
> +		umode_t mode = iattr->ia_mode;
> +		iattrs->ia_mode = sd->s_mode = mode;
>  	}
>  	return 0;
>  }


-- 
Jean Delvare
