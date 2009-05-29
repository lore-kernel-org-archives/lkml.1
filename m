Return-Path: <linux-kernel-owner+w=401wt.eu-S1757578AbZE2JP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757578AbZE2JP1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 05:15:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756475AbZE2JPQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 05:15:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:33377 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755922AbZE2JPP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 05:15:15 -0400
Message-ID: <4A1FA777.3040200@kernel.org>
Date: Fri, 29 May 2009 18:14:31 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Cornelia Huck <cornelia.huck@de.ibm.com>, linux-fsdevel@vger.kernel.org,
       Kay Sievers <kay.sievers@vrfy.org>, Greg KH <greg@kroah.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: Re: [PATCH 04/24] sysfs: Normalize removing sysfs directories.
References: <m1zlcwltri.fsf_-_@fess.ebiederm.org> <1243551665-23596-4-git-send-email-ebiederm@xmission.com>
In-Reply-To: <1243551665-23596-4-git-send-email-ebiederm@xmission.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 29 May 2009 09:14:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Eric W. Biederman wrote:
> @@ -732,12 +732,28 @@ const struct inode_operations sysfs_dir_inode_operations = {
>  	.setattr	= sysfs_setattr,
>  };
>  
> -static void remove_dir(struct sysfs_dirent *sd)
> +static void remove_dir(struct sysfs_dirent *dir_sd)
>  {
>  	struct sysfs_addrm_cxt acxt;
>  
> -	sysfs_addrm_start(&acxt, sd->s_parent);
> -	sysfs_remove_one(&acxt, sd);
> +	pr_debug("sysfs %s: removing dir\n", dir_sd->s_name);
> +
> +	/* Removing non-empty directories is not valid complain! */
						     ^^^
						  missing . or ,

> +static struct sysfs_dirent *get_dirent_to_remove(struct sysfs_dirent *dir_sd)
> +{
> +	struct sysfs_dirent *sd;
> +
> +	mutex_lock(&sysfs_mutex);
> +	for (sd = dir_sd->s_dir.children; sd; sd = sd->s_sibling) {
> +		/* Directories might be owned by someone else
> +		 * making recursive directory removal unsafe.
> +		 */
> +		if (sysfs_type(sd) == SYSFS_DIR)
> +			continue;
> +		break;
> +	}
> +	sysfs_get(sd);
> +	mutex_unlock(&sysfs_mutex);
> +
> +	return sd;
> +}
>  
>  static void __sysfs_remove_dir(struct sysfs_dirent *dir_sd)
>  {
>  	struct sysfs_addrm_cxt acxt;
> -	struct sysfs_dirent **pos;
> -
> -	if (!dir_sd)
> -		return;
> -
> -	pr_debug("sysfs %s: removing dir\n", dir_sd->s_name);
> -	sysfs_addrm_start(&acxt, dir_sd);
> -	pos = &dir_sd->s_dir.children;
> -	while (*pos) {
> -		struct sysfs_dirent *sd = *pos;
> +	struct sysfs_dirent *sd;
>  
> -		if (sysfs_type(sd) != SYSFS_DIR)
> -			sysfs_remove_one(&acxt, sd);
> -		else
> -			pos = &(*pos)->s_sibling;
> +	/* Remove children that we think are safe */
> +	while ((sd = get_dirent_to_remove(dir_sd))) {
> +		sysfs_addrm_start(&acxt, sd->s_parent);
> +		sysfs_remove_one(&acxt, sd);
> +		sysfs_addrm_finish(&acxt);
> +		sysfs_put(sd);
>  	}
> -	sysfs_addrm_finish(&acxt);

Ummm... Null @dir_sd handling is being removed, which could be fine
but please do it in a separate patch or at least mention it in the
patch description.  Also, I'm quite uncomfortable with these things
being done in non-atomic manner.  It can be made to work but things
like this can lead to subtle race conditions and with the kind of
layering we put on top of sysfs (kobject, driver model, driver
midlayers and so on), it isn't all that easy to verify what's going
on, so NACK for this one.

Thanks.

-- 
tejun
