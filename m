Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756011Ab0BKPdo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 10:33:44 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:41165 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755216Ab0BKPdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 10:33:43 -0500
To: Greg KH <gregkh@suse.de>
Cc: Jean Delvare <khali@linux-fr.org>, LKML <linux-kernel@vger.kernel.org>,
       Tejun Heo <tj@kernel.org>, Serge Hallyn <serue@us.ibm.com>
Subject: Re: [PATCH] sysfs: sysfs_sd_setattr set iattrs unconditionally
References: <20100120131602.12aa48f7@hyperion.delvare>
	<m1ocko6fkx.fsf@fess.ebiederm.org>
	<20100120160008.7d59688b@hyperion.delvare>
	<20100122041913.GC4302@suse.de>
	<20100203091138.1ababf5e@hyperion.delvare>
	<20100203142218.GA27676@suse.de> <m1hbpxlbhn.fsf_-_@fess.ebiederm.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 11 Feb 2010 07:33:29 -0800
In-Reply-To: <m1hbpxlbhn.fsf_-_@fess.ebiederm.org> (Eric W. Biederman's message of "Wed\, 03 Feb 2010 23\:13\:24 -0800")
Message-ID: <m1tytn23ee.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Greg I think this patch has slipped through the cracks.
Do I need to resend this regression fix or send it directly to Linus?

chmod and friends have been broken on sysfs since 2.6.32...

Eric

ebiederm@xmission.com (Eric W. Biederman) writes:

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
> -- 
> 1.6.5.2.143.g8cc62
