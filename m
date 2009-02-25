Return-Path: <linux-kernel-owner+w=401wt.eu-S1760394AbZBYIBV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760394AbZBYIBV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 03:01:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757274AbZBYIBF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 03:01:05 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:58696 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1759998AbZBYIBE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 03:01:04 -0500
Message-ID: <49A4FAC9.2080701@cn.fujitsu.com>
Date: Wed, 25 Feb 2009 16:01:13 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "containers@lists.linux-foundation.org" 
	<containers@lists.linux-foundation.org>,
       "menage@google.com" <menage@google.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/2] cgroup allow subsys to set default mode of its own
 file
References: <20090225163555.d2a0b24c.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090225163555.d2a0b24c.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> cgroup's subsys has "readonly" files, but default permission is always
> rw-r--r--. This allows to create r--r--r-- file to subsys.
> (The user can do chmod on this read-only file. But this behavior is not
>  different from current pseudo file systems as /proc.)
> 
> Reason:
>  When I wrote tools for maintain cgroup, I can't find which file is
>  writable intarfece or not via cgroup file systems. (finally, I did
>  dirty approach.)
>  IMHO, showing "this file is read-only" in explicit way is useful
>  for user-land (tools). In other story, a file whose name sounds read-only
>  may have "trigger" operation and support reseting. In this case,
>  "writable" is informative.
>  

I once planed to do so. I think there's one trial issue, that some files are
read-only in top-cgroup, but read-write in sub-dirs, like cpuset.cpus and
cpuset.mems. But for those files, they must have a write function, so I think
it's still valid to mask them as read-write even they are in top-cgroup.

Unless Paul has different option towards this:

Acked-by: Li Zefan <lizf@cn.fujitsu.cn>

> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> ---
>  include/linux/cgroup.h |    2 ++
>  kernel/cgroup.c        |    5 ++++-
>  2 files changed, 6 insertions(+), 1 deletion(-)
> 
> Index: mmotm-2.6.29-Feb24/include/linux/cgroup.h
> ===================================================================
> --- mmotm-2.6.29-Feb24.orig/include/linux/cgroup.h
> +++ mmotm-2.6.29-Feb24/include/linux/cgroup.h
> @@ -258,6 +258,8 @@ struct cftype {
>  	 */
>  	char name[MAX_CFTYPE_NAME];
>  	int private;
> +	/* if not 0, mode is set to mode, otherwise 0644 */
> +	int mode;
>  
>  	/*
>  	 * If non-zero, defines the maximum length of string that can
> Index: mmotm-2.6.29-Feb24/kernel/cgroup.c
> ===================================================================
> --- mmotm-2.6.29-Feb24.orig/kernel/cgroup.c
> +++ mmotm-2.6.29-Feb24/kernel/cgroup.c
> @@ -1767,7 +1767,10 @@ int cgroup_add_file(struct cgroup *cgrp,
>  	BUG_ON(!mutex_is_locked(&dir->d_inode->i_mutex));
>  	dentry = lookup_one_len(name, dir, strlen(name));
>  	if (!IS_ERR(dentry)) {
> -		error = cgroup_create_file(dentry, 0644 | S_IFREG,
> +		int mode = 0644;
> +		if (cft->mode)
> +			mode = cft->mode;
> +		error = cgroup_create_file(dentry, mode | S_IFREG,
>  						cgrp->root->sb);
>  		if (!error)
>  			dentry->d_fsdata = (void *)cft;
> 
