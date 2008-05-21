Return-Path: <linux-kernel-owner+w=401wt.eu-S935947AbYEUPRo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935947AbYEUPRo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 11:17:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763362AbYEUPR3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 11:17:29 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:56171 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759421AbYEUPR2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 11:17:28 -0400
Date: Wed, 21 May 2008 10:14:30 -0500
From: Michael Halcrow <mhalcrow@us.ibm.com>
To: Andrea Righi <righiandr@users.sourceforge.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <prussell@au1.ibm.com>,
       "David J. Kleikamp" <shaggy@us.ibm.com>,
       "SERGE E. HALLYN" <sergeh@us.ibm.com>
Subject: Re: [PATCH] eCryptfs: Privileged kthread for lower file opens
Message-ID: <20080521151430.GG32643@halcrowt61p.austin.ibm.com>
Reply-To: Michael Halcrow <mhalcrow@us.ibm.com>
References: <20080520214610.GD32643@halcrowt61p.austin.ibm.com> <48335BBF.2040901@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48335BBF.2040901@users.sourceforge.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2008 at 01:16:15AM +0200, Andrea Righi wrote:
> Michael Halcrow wrote:
>> +	req = kmem_cache_alloc(ecryptfs_open_req_cache, GFP_KERNEL);
>> +	if (!req) {
>> +		rc = -ENOMEM;
>> +		goto out;
>> +	}
>> +	mutex_init(&req->mux);
>> +	req->lower_file = lower_file;
>> +	req->lower_dentry = lower_dentry;
>> +	req->lower_mnt = lower_mnt;
>> +	req->requesting_task = current;
>> +	req->flags = 0;
>> +	mutex_lock(&ecryptfs_kthread_ctl.mux);
>> +	mutex_lock(&req->mux);
>> +	if (ecryptfs_kthread_ctl.flags & ECRYPTFS_KTHREAD_ZOMBIE) {
>> +		rc = -EIO;
>
> Isn't a mutex_unlock(&req->mux) missing here?

Nobody else actually has a reference to req at this point, so the
unlock is not really necessary. It might not be a bad idea to jump to
out_unlock anyway just to avoid future bugs.

>> +		mutex_unlock(&ecryptfs_kthread_ctl.mux);
>> +		printk(KERN_ERR "%s: We are in the middle of shutting down; "
>> +		       "aborting privileged request to open lower file\n",
>> +			__func__);
>> +		goto out_free;
>> +	}
>> +	list_add_tail(&req->kthread_ctl_list, &ecryptfs_kthread_ctl.req_list);
>> +	mutex_unlock(&req->mux);
>> +	mutex_unlock(&ecryptfs_kthread_ctl.mux);
>> +	wake_up(&ecryptfs_kthread_ctl.wait);
>> +schedule:
>> +	set_current_state(TASK_INTERRUPTIBLE);
>> +	schedule();
>> +	mutex_lock(&req->mux);
>> +	if (req->flags == 0) {
>> +		mutex_unlock(&req->mux);
>> +		goto schedule;
>> +	}
>> +	set_current_state(TASK_RUNNING);
>> +	if (req->flags & ECRYPTFS_REQ_DROPPED
>> +	    || req->flags & ECRYPTFS_REQ_ZOMBIE) {
>> +		rc = -EIO;
>> +		printk(KERN_WARNING "%s: Privileged open request dropped\n",
>> +		       __func__);
>> +		goto out_unlock;
>> +	}
>> +	if (IS_ERR(*req->lower_file)) {
>> +		rc = PTR_ERR(*req->lower_file);
>> +		dget(lower_dentry);
>> +		mntget(lower_mnt);
>> +		(*lower_file) = dentry_open(lower_dentry, lower_mnt,
>> +					    (O_RDONLY | O_LARGEFILE));
>> +		if (IS_ERR(*lower_file)) {
>> +			rc = PTR_ERR(*req->lower_file);
>> +			(*lower_file) = NULL;
>> +			printk(KERN_WARNING "%s: Error attempting privileged "
>> +			       "open of lower file with either RW or RO "
>> +			       "perms; rc = [%d]. Giving up.\n",
>> +			       __func__, rc);
>> +		}
>> +	}
>> +out_unlock:
>> +	mutex_unlock(&req->mux);
>> +out_free:
>> +	kmem_cache_free(ecryptfs_open_req_cache, req);
>> +out:
>> +	return rc;
>> +}
