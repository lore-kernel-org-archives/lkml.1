Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1758377AbYLQJNJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758377AbYLQJNJ (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 04:13:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750806AbYLQJMt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 04:12:49 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:55532 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755817AbYLQJMs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 04:12:48 -0500
Message-ID: <4948C245.9000108@cn.fujitsu.com>
Date: Wed, 17 Dec 2008 17:11:33 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Make cgroup_path() RCU-safe
References: <6599ad830812161558t4da0e5e7l4ad7d6f3a0dfbe6e@mail.gmail.com>
In-Reply-To: <6599ad830812161558t4da0e5e7l4ad7d6f3a0dfbe6e@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +static void free_cgroup_rcu(struct rcu_head *obj)
> +{
> +	struct cgroup *cgrp = container_of(obj, struct cgroup, rcu_head);
> +	/*
> +	 * Drop the active superblock reference that we took when we
> +	 * created the cgroup
> +	 */
> +	deactivate_super(cgrp->root->sb);
> +
> +	kfree(cgrp);
> +}

I just wrote a different test program, and triggered kernel panic immediately:
	for ((; ;))
	{
		mount -t cgroup -o cpu xxx /mnt
		mkdir /mnt/0
		rmdir /mnt/0
		umount /mnt
	}

I know little about vfs internal, but it seems wrong to call deactivate_super()
here. I tried to call deactivate_super() before call_rcu(), and ran 2 test
programs simultaneously, and my box are working find.

> +
>  static void cgroup_diput(struct dentry *dentry, struct inode *inode)
>  {
>  	/* is dentry a directory ? if so, kfree() associated cgroup */
> @@ -620,11 +632,7 @@ static void cgroup_diput(struct dentry *dentry,
> struct inode *inode)
>  		cgrp->root->number_of_cgroups--;
>  		mutex_unlock(&cgroup_mutex);
> 
> -		/* Drop the active superblock reference that we took when we
> -		 * created the cgroup */
> -		deactivate_super(cgrp->root->sb);
> -
> -		kfree(cgrp);
> +		call_rcu(&cgrp->rcu_head, free_cgroup_rcu);
>  	}
>  	iput(inode);
>  }

