Return-Path: <linux-kernel-owner+w=401wt.eu-S1754508AbZEUJlo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508AbZEUJlo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 05:41:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751482AbZEUJlf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 05:41:35 -0400
Received: from hera.kernel.org ([140.211.167.34]:43712 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750782AbZEUJle (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 05:41:34 -0400
Message-ID: <4A1521C2.4000506@kernel.org>
Date: Thu, 21 May 2009 18:41:22 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Cornelia Huck <cornelia.huck@de.ibm.com>, linux-fsdevel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: Re: [PATCH 16/20] sysfs: Propagate renames to the vfs on demand
References: <m1bppofm9k.fsf@fess.ebiederm.org> <1242865694-2100-1-git-send-email-ebiederm@xmission.com> <1242865694-2100-2-git-send-email-ebiederm@xmission.com> <1242865694-2100-3-git-send-email-ebiederm@xmission.com> <1242865694-2100-4-git-send-email-ebiederm@xmission.com> <1242865694-2100-5-git-send-email-ebiederm@xmission.com> <1242865694-2100-6-git-send-email-ebiederm@xmission.com> <1242865694-2100-7-git-send-email-ebiederm@xmission.com> <1242865694-2100-8-git-send-email-ebiederm@xmission.com> <1242865694-2100-9-git-send-email-ebiederm@xmission.com> <1242865694-2100-10-git-send-email-ebiederm@xmission.com> <1242865694-2100-11-git-send-email-ebiederm@xmission.com> <1242865694-2100-12-git-send-email-ebiederm@xmission.com> <1242865694-2100-13-git-send-email-ebiederm@xmission.com> <1242865694-2100-14-git-send-email-ebiederm@xmission.com> <1242865694-2100-15-git-send-email-ebiederm@xmission.com> <1242865694-2100-16-git-send-email-ebiederm@xmission.com>
In-Reply-To: <1242865694-2100-16-git-send-email-ebiederm@xmission.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 21 May 2009 09:41:25 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> From: Eric W. Biederman <ebiederm@xmission.com>
> 
> By teaching sysfs_revalidate to hide a dentry for
> a sysfs_dirent if the sysfs_dirent has been renamed,
> and by teaching sysfs_lookup to return the original
> dentry if the sysfs dirent has been renamed.  I can
> show the results of renames correctly without having to
> update the dcache during the directory rename.
> 
> This massively simplifies the rename logic allowing a lot
> of weird sysfs special cases to be removed along with
> a lot of now unnecesary helper code.
> 
> Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>

It's probably a good idea to cc Al Viro?

> @@ -311,6 +270,14 @@ static int sysfs_dentry_revalidate(struct dentry *dentry, struct nameidata *nd)
>  	if (sd->s_flags & SYSFS_FLAG_REMOVED)
>  		goto out_bad;
>  
> +	/* The sysfs dirent has been moved? */
> +	if (dentry->d_parent->d_fsdata != sd->s_parent)
> +		goto out_bad;
> +
> +	/* The sysfs dirent has been renamed */
> +	if (strcmp(dentry->d_name.name, sd->s_name) != 0)
> +		goto out_bad;
> +
>  	mutex_unlock(&sysfs_mutex);
>  out_valid:
>  	return 1;
> @@ -318,6 +285,12 @@ out_bad:
>  	/* Remove the dentry from the dcache hashes.
>  	 * If this is a deleted dentry we use d_drop instead of d_delete
>  	 * so sysfs doesn't need to cope with negative dentries.
> +	 *
> +	 * If this is a dentry that has simply been renamed we
> +	 * use d_drop to remove it from the dcache lookup on it's
							     ^^^^
							     its

> +	 * old parent.  If this dentry persists later when a lookup
> +	 * is performed at it's new name the dentry will be readded
                           ^^^^
			   its

Other than the above comment changes,

Acked-by: Tejun Heo <tj@kernel.org>

-- 
tejun
