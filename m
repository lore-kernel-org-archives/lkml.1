Return-Path: <linux-kernel-owner+w=401wt.eu-S1754312AbZKDCnd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754312AbZKDCnd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 21:43:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754294AbZKDCnd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 21:43:33 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:52917 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754284AbZKDCnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 21:43:31 -0500
Date: Tue, 3 Nov 2009 20:43:32 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Cornelia Huck <cornelia.huck@de.ibm.com>,
       linux-fsdevel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
       Benjamin LaHaise <bcrl@lhnet.ca>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: Re: [PATCH 04/13] sysfs: Simplify sysfs_chmod_file semantics
Message-ID: <20091104024332.GA27639@us.ibm.com>
References: <m13a4vbz8r.fsf@fess.ebiederm.org> <1257249429-12384-4-git-send-email-ebiederm@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257249429-12384-4-git-send-email-ebiederm@xmission.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric W. Biederman (ebiederm@xmission.com):
> From: Eric W. Biederman <ebiederm@xmission.com>
> 
> Currently every caller of sysfs_chmod_file happens at either
> file creation time to set a non-default mode or in response
> to a specific user requested space change in policy.  Making
> timestamps of when the chmod happens and notification of
> a file changing mode uninteresting.

But these changes can occur by togging values in sysfs files
(i.e. f71805f.c), right?  Is this (specifically not doing inotify)
definately uncontroversial?

I can't exactly picture an admin sitting there watching
nautilus for a sysfs file to become writeable, but could
imagine some site's automation getting hung...  Or am I way
off base?

> Remove the unnecessary time stamp and filesystem change
> notification, and removes the last of the explicit inotify
> and donitfy support from sysfs.
> 
> Acked-by: Tejun Heo <tj@kernel.org>
> Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
> ---
>  fs/sysfs/file.c |   10 +---------
>  1 files changed, 1 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
> index f5ea468..faa1a80 100644
> --- a/fs/sysfs/file.c
> +++ b/fs/sysfs/file.c
> @@ -604,17 +604,9 @@ int sysfs_chmod_file(struct kobject *kobj, struct attribute *attr, mode_t mode)
>  	mutex_lock(&inode->i_mutex);
> 
>  	newattrs.ia_mode = (mode & S_IALLUGO) | (inode->i_mode & ~S_IALLUGO);
> -	newattrs.ia_valid = ATTR_MODE | ATTR_CTIME;
> -	newattrs.ia_ctime = current_fs_time(inode->i_sb);
> +	newattrs.ia_valid = ATTR_MODE;
>  	rc = sysfs_setattr(victim, &newattrs);
> 
> -	if (rc == 0) {
> -		fsnotify_change(victim, newattrs.ia_valid);
> -		mutex_lock(&sysfs_mutex);
> -		victim_sd->s_mode = newattrs.ia_mode;
> -		mutex_unlock(&sysfs_mutex);
> -	}
> -
>  	mutex_unlock(&inode->i_mutex);
>   out:
>  	dput(victim);
> -- 
> 1.6.5.2.143.g8cc62
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
