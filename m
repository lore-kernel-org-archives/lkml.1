Return-Path: <linux-kernel-owner+w=401wt.eu-S1753121AbXLFKag@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753121AbXLFKag (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 05:30:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751956AbXLFKa2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 05:30:28 -0500
Received: from swsoft-mipt-nat.sw.ru ([195.214.233.10]:56218 "EHLO iris"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751470AbXLFKa1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 05:30:27 -0500
Message-ID: <4757CF70.3020508@sw.ru>
Date: Thu, 06 Dec 2007 13:31:12 +0300
From: "Denis V. Lunev" <den@sw.ru>
User-Agent: Thunderbird 2.0.0.9 (X11/20071116)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Andrew Morton <akpm@linux-foundation.org>, marcus@better.se,
       containers@lists.osdl.org, devel@openvz.org,
       linux-kernel@vger.kernel.org, "Denis V. Lunev" <den@openvz.org>
Subject: Re: [PATCH] proc: Do not invalidate dentries with submounts
References: <20071205143518.GA24886@iris.sw.ru> <m1bq94t951.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1bq94t951.fsf@ebiederm.dsl.xmission.com>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

you have changed the behavior of revalidation by shadows. I think it
will be better to restore it and keep new one for shadows (and below)
only, which has been done by my yesterday patch.

Regards,
	Den

Eric W. Biederman wrote:
> If the dcache path to a mount point is ever broken it becomes
> impossible to unmount it, and we leak a vfsmount.  Therefore it is not
> valid to invalidate dentries with mount points at or below them.
> 
> This patch uses the have_submounts test as the other network
> filesystem revalidate routines do.
> 
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
> ---
>  fs/proc/base.c    |    9 +++++++++
>  fs/proc/generic.c |    5 +++++
>  2 files changed, 14 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index 0e71707..552d752 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -1216,6 +1216,9 @@ static int pid_revalidate(struct dentry *dentry, struct nameidata *nd)
>  		put_task_struct(task);
>  		return 1;
>  	}
> +	/* Force validity if something is mounted under us */
> +	if (inode && S_ISDIR(inode->i_mode) && have_submounts(dentry))
> +		return 1;
>  	d_drop(dentry);
>  	return 0;
>  }
> @@ -1393,6 +1396,9 @@ static int tid_fd_revalidate(struct dentry *dentry, struct nameidata *nd)
>  		}
>  		put_task_struct(task);
>  	}
> +	/* Force validity if something is mounted under us */
> +	if (inode && S_ISDIR(inode->i_mode) && have_submounts(dentry))
> +		return 1;
>  	d_drop(dentry);
>  	return 0;
>  }
> @@ -2056,6 +2062,9 @@ static int proc_base_revalidate(struct dentry *dentry, struct nameidata *nd)
>  		put_task_struct(task);
>  		return 1;
>  	}
> +	/* Force validity if something is mounted under us */
> +	if (inode && S_ISDIR(inode->i_mode) && have_submounts(dentry))
> +		return 1;
>  	d_drop(dentry);
>  	return 0;
>  }
> diff --git a/fs/proc/generic.c b/fs/proc/generic.c
> index 4abd568..233dcdc 100644
> --- a/fs/proc/generic.c
> +++ b/fs/proc/generic.c
> @@ -370,6 +370,11 @@ static int proc_delete_dentry(struct dentry * dentry)
>  
>  static int proc_revalidate_dentry(struct dentry *dentry, struct nameidata *nd)
>  {
> +	struct inode *inode = dentry->d_inode;
> +
> +	/* Force validity if something is mounted under us */
> +	if (inode && S_ISDIR(inode->i_mode) && have_submounts(dentry))
> +		return 1;
>  	d_drop(dentry);
>  	return 0;
>  }

