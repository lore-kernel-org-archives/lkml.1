Return-Path: <linux-kernel-owner+w=401wt.eu-S1752889AbZEUGXi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752889AbZEUGXi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 02:23:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751265AbZEUGX3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 02:23:29 -0400
Received: from hera.kernel.org ([140.211.167.34]:59452 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751195AbZEUGX2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 02:23:28 -0400
Message-ID: <4A14F356.3030501@kernel.org>
Date: Thu, 21 May 2009 15:23:18 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Cornelia Huck <cornelia.huck@de.ibm.com>, linux-fsdevel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: Re: [PATCH 04/20] sysfs: Handle the general case of removing of directories
 with subdirectories
References: <m1bppofm9k.fsf@fess.ebiederm.org> <1242865694-2100-1-git-send-email-ebiederm@xmission.com> <1242865694-2100-2-git-send-email-ebiederm@xmission.com> <1242865694-2100-3-git-send-email-ebiederm@xmission.com> <1242865694-2100-4-git-send-email-ebiederm@xmission.com>
In-Reply-To: <1242865694-2100-4-git-send-email-ebiederm@xmission.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 21 May 2009 06:23:21 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> From: Eric W. Biederman <ebiederm@xmission.com>
> 
> Modify sysfs to properly remove directories containing attributes and
> subdirectories.  The code is relatively simple and means we don't have
> to worry about what might use this logic.
> 
> In a quick survey I have only found /sys/dev/char and /sys/dev/block that are
> removing non-enmpty directories today (and they are exclusively filled with symlinks).
> So only removing empty directories does not appear to be an option.
> 
> I don't hold sysfs_mutex across the entire operation as that is unneeded
> for coherence at the sysfs level and some level of coordination is expected
> at the upper layers.
> 
> Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
...
> -void sysfs_remove_subdir(struct sysfs_dirent *sd)
> -{
> -	remove_dir(sd);
> +	struct sysfs_dirent *sd = dir_sd;
> +	mutex_lock(&sysfs_mutex);
> +	while ((sysfs_type(sd) == SYSFS_DIR) && sd->s_dir.children)
> +		sd = sd->s_dir.children;
> +	if (sd != dir_sd)
> +		sysfs_get(sd);
> +	else
> +		sd = NULL;
> +	mutex_unlock(&sysfs_mutex);
> +	return sd;
>  }

Some blank lines wouldn't hurt, especially after local variable
declaration.

> -static void __sysfs_remove_dir(struct sysfs_dirent *dir_sd)
> +static void remove_dir(struct sysfs_dirent *dir_sd)
>  {
>  	struct sysfs_addrm_cxt acxt;
> -	struct sysfs_dirent **pos;
> -
> -	if (!dir_sd)
> -		return;
> +	struct sysfs_dirent *sd;
>  
>  	pr_debug("sysfs %s: removing dir\n", dir_sd->s_name);
> -	sysfs_addrm_start(&acxt, dir_sd);
> -	pos = &dir_sd->s_dir.children;
> -	while (*pos) {
> -		struct sysfs_dirent *sd = *pos;
>  
> -		if (sysfs_type(sd) != SYSFS_DIR)
> -			sysfs_remove_one(&acxt, sd);
> -		else
> -			pos = &(*pos)->s_sibling;
> +	while ((sd = sysfs_get_one(dir_sd))) {
> +		sysfs_addrm_start(&acxt, sd->s_parent);
> +		sysfs_remove_one(&acxt, sd);
> +		sysfs_addrm_finish(&acxt);
> +		sysfs_put(sd);
>  	}
> +	sysfs_addrm_start(&acxt, dir_sd->s_parent);
> +	sysfs_remove_one(&acxt, dir_sd);
>  	sysfs_addrm_finish(&acxt);
> +}

I agree we should be heading this way but what happens to attributes
or directories living below the subdirectories?  If it's gonna handle
recursive case, I think it better do it properly.  I had patches of
similar effect.

 http://article.gmane.org/gmane.linux.kernel/582151
 http://article.gmane.org/gmane.linux.kernel/582155

The patchset didn't really go anywhere but the recursive atomic
removal should be usable.

Thanks.

-- 
tejun
