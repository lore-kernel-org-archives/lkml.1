Return-Path: <linux-kernel-owner+w=401wt.eu-S1753171AbZEUGlZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753171AbZEUGlZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 02:41:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751474AbZEUGlR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 02:41:17 -0400
Received: from hera.kernel.org ([140.211.167.34]:39418 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751437AbZEUGlQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 02:41:16 -0400
Message-ID: <4A14F781.6010103@kernel.org>
Date: Thu, 21 May 2009 15:41:05 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Cornelia Huck <cornelia.huck@de.ibm.com>, linux-fsdevel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: Re: [PATCH 06/20] sysfs: Use dentry_ops instead of directly playing
 with the dcache
References: <m1bppofm9k.fsf@fess.ebiederm.org> <1242865694-2100-1-git-send-email-ebiederm@xmission.com> <1242865694-2100-2-git-send-email-ebiederm@xmission.com> <1242865694-2100-3-git-send-email-ebiederm@xmission.com> <1242865694-2100-4-git-send-email-ebiederm@xmission.com> <1242865694-2100-5-git-send-email-ebiederm@xmission.com> <1242865694-2100-6-git-send-email-ebiederm@xmission.com>
In-Reply-To: <1242865694-2100-6-git-send-email-ebiederm@xmission.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 21 May 2009 06:41:09 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Eric W. Biederman wrote:
> Calling d_drop unconditionally when a sysfs_dirent is deleted has
> the potential to leak mounts, so instead implement dentry delete
> and revalidate operations that cause sysfs dentries to be removed
> at the appropriate time.
> 
> Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>

Great, thanks for doing this.  It's much better than the fragile vfs
tinkering sysfs has been doing.

> +static int sysfs_dentry_revalidate(struct dentry *dentry, struct nameidata *nd)
> +{
> +	struct sysfs_dirent *sd = dentry->d_fsdata;
> +	int is_dir;
> +
> +	mutex_lock(&sysfs_mutex);
> +
> +	/* The sysfs dirent has been deleted */
> +	if (sd->s_flags & SYSFS_FLAG_REMOVED)
> +		goto out_bad;
> +
> +	mutex_unlock(&sysfs_mutex);
> +out_valid:
> +	return 1;
> +out_bad:
> +	/* Remove the dentry from the dcache hashes.
> +	 * If this is a deleted dentry we use d_drop instead of d_delete
> +	 * so sysfs doesn't need to cope with negative dentries.
> +	 */
> +	is_dir = (sysfs_type(sd) == SYSFS_DIR);
> +	mutex_unlock(&sysfs_mutex);
> +	if (is_dir) {
> +		/* If we have submounts we must allow the vfs caches
> +		 * to lie about the state of the filesystem to prevent
> +		 * leaks and other nasty things.
> +		 */
> +		if (have_submounts(dentry))
> +			goto out_valid;
> +		shrink_dcache_parent(dentry);
> +	}
> +	d_drop(dentry);
> +	return 0;
> +}

Ummm... what happens if sysfs recreates those identical nodes again
while the old dentries are lingering?  The dead ones will linger till
the submounts are gone and then look ups after that will show the new
ones, right?

Thanks.

-- 
tejun
