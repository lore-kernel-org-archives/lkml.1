Return-Path: <linux-kernel-owner+w=401wt.eu-S1752116AbZEUH3a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752116AbZEUH3a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 03:29:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751221AbZEUH3V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 03:29:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:38704 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751135AbZEUH3U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 03:29:20 -0400
Message-ID: <4A1502C6.5020103@kernel.org>
Date: Thu, 21 May 2009 16:29:10 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Cornelia Huck <cornelia.huck@de.ibm.com>, linux-fsdevel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: Re: [PATCH 08/20] sysfs: Optimize just changing the sysfs file mode.
References: <m1bppofm9k.fsf@fess.ebiederm.org> <1242865694-2100-1-git-send-email-ebiederm@xmission.com> <1242865694-2100-2-git-send-email-ebiederm@xmission.com> <1242865694-2100-3-git-send-email-ebiederm@xmission.com> <1242865694-2100-4-git-send-email-ebiederm@xmission.com> <1242865694-2100-5-git-send-email-ebiederm@xmission.com> <1242865694-2100-6-git-send-email-ebiederm@xmission.com> <1242865694-2100-7-git-send-email-ebiederm@xmission.com> <1242865694-2100-8-git-send-email-ebiederm@xmission.com>
In-Reply-To: <1242865694-2100-8-git-send-email-ebiederm@xmission.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 21 May 2009 07:29:13 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> From: Eric W. Biederman <ebiederm@xmission.com>
> 
> Don't allocate a struct iattr for the sysfs dentry if just
> the mode changes because we have a field for that on the
> sysfs_dirent, and we can trigger that case with sysfs_chmod_file.
> 
> Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
> ---
>  fs/sysfs/inode.c |   22 ++++++++++++++--------
>  1 files changed, 14 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
> index 555f0ff..70ff2a2 100644
> --- a/fs/sysfs/inode.c
> +++ b/fs/sysfs/inode.c
> @@ -60,12 +60,16 @@ int sysfs_setattr(struct dentry * dentry, struct iattr * iattr)
>  		return error;
>  
>  	iattr->ia_valid &= ~ATTR_SIZE; /* ignore size changes */
> +	if (iattr->ia_valid & ATTR_MODE) {
> +		if (!in_group_p(inode->i_gid) && !capable(CAP_FSETID))
> +			iattr->ia_mode &= ~S_ISGID;
> +	}
>  
>  	error = inode_setattr(inode, iattr);
>  	if (error)
>  		return error;
>  
> -	if (!sd_iattr) {
> +	if (!sd_iattr && (ia_valid & ~ATTR_MODE)) {
>  		/* setting attributes for the first time, allocate now */
>  		sd_iattr = kzalloc(sizeof(struct iattr), GFP_KERNEL);
>  		if (!sd_iattr)
> @@ -78,6 +82,13 @@ int sysfs_setattr(struct dentry * dentry, struct iattr * iattr)
>  		sd->s_iattr = sd_iattr;
>  	}
>  
> +	if (ia_valid & ATTR_MODE)
> +		sd->s_mode = iattr->ia_mode;
> +
> +	/* If we don't need the extra attributes leave */
> +	if (!sd_iattr)
> +		return 0;

One visible difference is lack of timestamp update.  Is there any use
case where sysfs file mode changing needs to be fast?

Thanks.

-- 
tejun
