Return-Path: <linux-kernel-owner+w=401wt.eu-S1762378AbYETXQY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762378AbYETXQY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 19:16:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754645AbYETXQP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 19:16:15 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:11400 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754006AbYETXQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 19:16:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding:sender;
        b=SIfy+pa3TgwCWa+oGDEQNW5SwLXOLHsw0zoCBwOH55deU7t2Hr3lZqgAQpfeiRaPXsgYxpbV/hf9mE7gAxzDLXgnatuafSQwdx99RNdhSdBNDMnAUOm12vm9lBOII9oWFws9ZlYM3N3JQguXwxgCGlGTNRIgGoKcCXIViuiZ3qQ=
Message-ID: <48335BBF.2040901@users.sourceforge.net>
Date: Wed, 21 May 2008 01:16:15 +0200
From: Andrea Righi <righiandr@users.sourceforge.net>
Reply-To: righiandr@users.sourceforge.net
User-Agent: Swiftdove 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Michael Halcrow <mhalcrow@us.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <prussell@au1.ibm.com>,
       "David J. Kleikamp" <shaggy@us.ibm.com>,
       "SERGE E. HALLYN" <sergeh@us.ibm.com>
Subject: Re: [PATCH] eCryptfs: Privileged kthread for lower file opens
References: <20080520214610.GD32643@halcrowt61p.austin.ibm.com>
In-Reply-To: <20080520214610.GD32643@halcrowt61p.austin.ibm.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Halcrow wrote:
[snip]

Hi,
2 comments on the patch.

> diff --git a/fs/ecryptfs/kthread.c b/fs/ecryptfs/kthread.c
> new file mode 100644
> index 0000000..dba7c67
> --- /dev/null
> +++ b/fs/ecryptfs/kthread.c
> @@ -0,0 +1,211 @@
> +/**
> + * eCryptfs: Linux filesystem encryption layer
> + *
> + * Copyright (C) 2008 International Business Machines Corp.
> + *   Author(s): Michael A. Halcrow <mahalcro@us.ibm.com>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License as
> + * published by the Free Software Foundation; either version 2 of the
> + * License, or (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful, but
> + * WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA
> + * 02111-1307, USA.
> + */
> +
> +#include <linux/kthread.h>
> +#include <linux/freezer.h>
> +#include <linux/wait.h>
> +#include <linux/mount.h>
> +#include "ecryptfs_kernel.h"
> +
> +struct task_struct *ecryptfs_kthread;
> +struct ecryptfs_kthread_ctl ecryptfs_kthread_ctl;
> +
> +struct kmem_cache *ecryptfs_open_req_cache;
> +
> +/**
> + * ecryptfs_threadfn
> + * @ignored: ignored
> + *
> + * The eCryptfs kernel thread that has the responsibility of getting
> + * the lower persistent file with RW permissions.
> + *
> + * Returns zero on success; non-zero otherwise
> + */
> +static int ecryptfs_threadfn(void *ignored)
> +{
> +	set_freezable();
> +	while (1)  {
> +		struct ecryptfs_open_req *req;
> +
> +		wait_event_freezable(
> +			ecryptfs_kthread_ctl.wait,
> +			!list_empty(&ecryptfs_kthread_ctl.req_list));
> +		mutex_lock(&ecryptfs_kthread_ctl.mux);
> +		if (ecryptfs_kthread_ctl.flags & ECRYPTFS_KTHREAD_ZOMBIE) {
> +			mutex_unlock(&ecryptfs_kthread_ctl.mux);
> +			goto out;
> +		}
> +		while (!list_empty(&ecryptfs_kthread_ctl.req_list)) {
> +			req = list_first_entry(&ecryptfs_kthread_ctl.req_list,
> +					       struct ecryptfs_open_req,
> +					       kthread_ctl_list);
> +			BUG_ON(!req);
> +			mutex_lock(&req->mux);
> +			list_del(&req->kthread_ctl_list);
> +			if (req->flags & ECRYPTFS_REQ_ZOMBIE)
> +				mutex_unlock(&req->mux);
> +			else {
> +				dget(req->lower_dentry);
> +				mntget(req->lower_mnt);
> +				(*req->lower_file) = dentry_open(
> +					req->lower_dentry, req->lower_mnt,
> +					(O_RDWR | O_LARGEFILE));
> +				req->flags |= ECRYPTFS_REQ_PROCESSED;
> +				wake_up_process(req->requesting_task);
> +				mutex_unlock(&req->mux);
> +			}

Why not:
			if (!(req->flags & ECRYPTFS_REQ_ZOMBIE))
				dget(req->lower_dentry);
				mntget(req->lower_mnt);
				(*req->lower_file) = dentry_open(
					req->lower_dentry, req->lower_mnt,
					(O_RDWR | O_LARGEFILE));
				req->flags |= ECRYPTFS_REQ_PROCESSED;
				wake_up_process(req->requesting_task);
			}
			mutex_unlock(&req->mux);

> +		}
> +		mutex_unlock(&ecryptfs_kthread_ctl.mux);
> +	}
> +out:
> +	do_exit(0);
> +}
> +
> +int ecryptfs_init_kthread(void)
> +{
> +	int rc = 0;
> +
> +	mutex_init(&ecryptfs_kthread_ctl.mux);
> +	init_waitqueue_head(&ecryptfs_kthread_ctl.wait);
> +	INIT_LIST_HEAD(&ecryptfs_kthread_ctl.req_list);
> +	ecryptfs_kthread = kthread_create(&ecryptfs_threadfn, NULL,
> +					  "ecryptfs-kthread");
> +	if (IS_ERR(ecryptfs_kthread)) {
> +		rc = PTR_ERR(ecryptfs_kthread);
> +		printk(KERN_ERR "%s: Failed to create kernel thread; rc = [%d]"
> +		       "\n", __func__, rc);
> +	}
> +	wake_up_process(ecryptfs_kthread);
> +	return rc;
> +}
> +
> +void ecryptfs_destroy_kthread(void)
> +{
> +	struct ecryptfs_open_req tmp_req;
> +	struct ecryptfs_open_req *req;
> +
> +	mutex_lock(&ecryptfs_kthread_ctl.mux);
> +	ecryptfs_kthread_ctl.flags |= ECRYPTFS_KTHREAD_ZOMBIE;
> +	list_for_each_entry(req, &ecryptfs_kthread_ctl.req_list,
> +			    kthread_ctl_list) {
> +		mutex_lock(&req->mux);
> +		req->flags |= ECRYPTFS_REQ_ZOMBIE;
> +		wake_up_process(req->requesting_task);
> +		mutex_unlock(&req->mux);
> +	}
> +	memset(&tmp_req, 0, sizeof(tmp_req));
> +	tmp_req.flags = ECRYPTFS_REQ_ZOMBIE;
> +	list_add_tail(&tmp_req.kthread_ctl_list,
> +		      &ecryptfs_kthread_ctl.req_list);
> +	mutex_unlock(&ecryptfs_kthread_ctl.mux);
> +	wake_up(&ecryptfs_kthread_ctl.wait);
> +}
> +
> +/**
> + * ecryptfs_privileged_open
> + * @lower_file: Result of dentry_open by root on lower dentry
> + * @lower_dentry: Lower dentry for file to open
> + * @lower_mnt: Lower vfsmount for file to open
> + *
> + * This function gets a r/w file opened againt the lower dentry.
> + *
> + * Returns zero on success; non-zero otherwise
> + */
> +int ecryptfs_privileged_open(struct file **lower_file,
> +			     struct dentry *lower_dentry,
> +			     struct vfsmount *lower_mnt)
> +{
> +	struct ecryptfs_open_req *req;
> +	int rc = 0;
> +
> +	/* Corresponding dput() and mntput() are done when the
> +	 * persistent file is fput() when the eCryptfs inode is
> +	 * destroyed. */
> +	dget(lower_dentry);
> +	mntget(lower_mnt);
> +	(*lower_file) = dentry_open(lower_dentry, lower_mnt,
> +				    (O_RDWR | O_LARGEFILE));
> +	if (!IS_ERR(*lower_file))
> +		goto out;
> +	req = kmem_cache_alloc(ecryptfs_open_req_cache, GFP_KERNEL);
> +	if (!req) {
> +		rc = -ENOMEM;
> +		goto out;
> +	}
> +	mutex_init(&req->mux);
> +	req->lower_file = lower_file;
> +	req->lower_dentry = lower_dentry;
> +	req->lower_mnt = lower_mnt;
> +	req->requesting_task = current;
> +	req->flags = 0;
> +	mutex_lock(&ecryptfs_kthread_ctl.mux);
> +	mutex_lock(&req->mux);
> +	if (ecryptfs_kthread_ctl.flags & ECRYPTFS_KTHREAD_ZOMBIE) {
> +		rc = -EIO;

Isn't a mutex_unlock(&req->mux) missing here?

> +		mutex_unlock(&ecryptfs_kthread_ctl.mux);
> +		printk(KERN_ERR "%s: We are in the middle of shutting down; "
> +		       "aborting privileged request to open lower file\n",
> +			__func__);
> +		goto out_free;
> +	}
> +	list_add_tail(&req->kthread_ctl_list, &ecryptfs_kthread_ctl.req_list);
> +	mutex_unlock(&req->mux);
> +	mutex_unlock(&ecryptfs_kthread_ctl.mux);
> +	wake_up(&ecryptfs_kthread_ctl.wait);
> +schedule:
> +	set_current_state(TASK_INTERRUPTIBLE);
> +	schedule();
> +	mutex_lock(&req->mux);
> +	if (req->flags == 0) {
> +		mutex_unlock(&req->mux);
> +		goto schedule;
> +	}
> +	set_current_state(TASK_RUNNING);
> +	if (req->flags & ECRYPTFS_REQ_DROPPED
> +	    || req->flags & ECRYPTFS_REQ_ZOMBIE) {
> +		rc = -EIO;
> +		printk(KERN_WARNING "%s: Privileged open request dropped\n",
> +		       __func__);
> +		goto out_unlock;
> +	}
> +	if (IS_ERR(*req->lower_file)) {
> +		rc = PTR_ERR(*req->lower_file);
> +		dget(lower_dentry);
> +		mntget(lower_mnt);
> +		(*lower_file) = dentry_open(lower_dentry, lower_mnt,
> +					    (O_RDONLY | O_LARGEFILE));
> +		if (IS_ERR(*lower_file)) {
> +			rc = PTR_ERR(*req->lower_file);
> +			(*lower_file) = NULL;
> +			printk(KERN_WARNING "%s: Error attempting privileged "
> +			       "open of lower file with either RW or RO "
> +			       "perms; rc = [%d]. Giving up.\n",
> +			       __func__, rc);
> +		}
> +	}
> +out_unlock:
> +	mutex_unlock(&req->mux);
> +out_free:
> +	kmem_cache_free(ecryptfs_open_req_cache, req);
> +out:
> +	return rc;
> +}
