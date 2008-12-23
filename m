Return-Path: <linux-kernel-owner+w=401wt.eu-S1752225AbYLWQ2k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752225AbYLWQ2k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 11:28:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750951AbYLWQ2c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 11:28:32 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:60694 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903AbYLWQ2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 11:28:31 -0500
Date: Tue, 23 Dec 2008 10:28:26 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Containers <containers@lists.linux-foundation.org>,
       Paul Menage <menage@google.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cgroups: avoid accessing uninitialized data in failure
	path
Message-ID: <20081223162826.GA16914@us.ibm.com>
References: <4950595C.9070907@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4950595C.9070907@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Li Zefan (lizf@cn.fujitsu.com):
> If cgroup_get_rootdir() failed, free_cg_links() will be called
> in the failure path, but tmp_cg_links hasn't been initialized
> at that time.
> 
> I should be blamed to introduce this bug in 2.6.26 merge window.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

Certainly looks right.

Acked-by: Serge Hallyn <serue@us.ibm.com>

> ---
>  kernel/cgroup.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index 8185a0f..330b7ae 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -1024,7 +1024,7 @@ static int cgroup_get_sb(struct file_system_type *fs_type,
>  		if (ret == -EBUSY) {
>  			mutex_unlock(&cgroup_mutex);
>  			mutex_unlock(&inode->i_mutex);
> -			goto drop_new_super;
> +			goto free_cg_links;
>  		}
> 
>  		/* EBUSY should be the only error here */
> @@ -1073,10 +1073,11 @@ static int cgroup_get_sb(struct file_system_type *fs_type,
> 
>  	return simple_set_mnt(mnt, sb);
> 
> + free_cg_links:
> +	free_cg_links(&tmp_cg_links);
>   drop_new_super:
>  	up_write(&sb->s_umount);
>  	deactivate_super(sb);
> -	free_cg_links(&tmp_cg_links);
>  	return ret;
>  }
> 
> -- 
> 1.5.4.rc3
> 
> _______________________________________________
> Containers mailing list
> Containers@lists.linux-foundation.org
> https://lists.linux-foundation.org/mailman/listinfo/containers
