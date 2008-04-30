Return-Path: <linux-kernel-owner+w=401wt.eu-S932832AbYD3V2z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932832AbYD3V2z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 17:28:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763206AbYD3V2c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 17:28:32 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:41343 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762786AbYD3V2b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 17:28:31 -0400
Subject: Re: [RFC][PATCH 3/5] Container Freezer: Implement freezer cgroup
	subsystem
From: Matt Helsley <matthltc@us.ibm.com>
To: Linux-Kernel <linux-kernel@vger.kernel.org>
Cc: Cedric Le Goater <clg@fr.ibm.com>, Paul Menage <menage@google.com>,
       Oren Laadan <orenl@cs.columbia.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Pavel Machek <pavel@ucw.cz>, linux-pm@lists.linux-foundation.org,
       Linux Containers <containers@lists.linux-foundation.org>
In-Reply-To: <20080424064757.526468716@us.ibm.com>
References: <20080424064756.643890130@us.ibm.com>
	 <20080424064757.526468716@us.ibm.com>
Content-Type: text/plain
Organization: IBM Linux Technology Center
Date: Wed, 30 Apr 2008 14:28:25 -0700
Message-Id: <1209590905.29759.38.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-04-23 at 23:47 -0700, Matt Helsley wrote:

<snip>

> +static ssize_t freezer_write(struct cgroup *cgroup,
> +			     struct cftype *cft,
> +			     struct file *file,
> +			     const char __user *userbuf,
> +			     size_t nbytes, loff_t *unused_ppos)
> +{
> +	char *buffer;
> +	int retval = 0;
> +	enum freezer_state goal_state;
> +
> +	if (nbytes >= PATH_MAX)
> +		return -E2BIG;
> +
> +	/* +1 for nul-terminator */
> +	buffer = kmalloc(nbytes + 1, GFP_KERNEL);
> +	if (buffer == NULL)
> +		return -ENOMEM;
> +
> +	if (copy_from_user(buffer, userbuf, nbytes)) {
> +		retval = -EFAULT;
> +		goto free_buffer;
> +	}
> +	buffer[nbytes] = 0;	/* nul-terminate */
> +	strstrip(buffer);
> +	if (strcmp(buffer, "RUNNING") == 0)
> +		goal_state = STATE_RUNNING;
> +	else if (strcmp(buffer, "FROZEN") == 0)
> +		goal_state = STATE_FROZEN;
> +	else {
> +		retval = -EIO;
> +		goto free_buffer;
> +	}
> +
> +	cgroup_lock();
> +
> +	if (cgroup_is_removed(cgroup)) {
> +		retval = -ENODEV;
> +		goto unlock;
> +	}

I think this was copy/paste'd from cgroup_common_file_write() which
modifies the cgroup hierarchy. However this function does not modify the
cgroup hierarchy and we're not getting the cgroup from the task. So I
don't think cgroup_lock()/unlock() are needed here. Paul, do you agree?

> +	retval = freezer_freeze(cgroup, goal_state);
> +	if (retval == 0)
> +		retval = nbytes;
> +unlock:
> +	cgroup_unlock();
> +free_buffer:
> +	kfree(buffer);
> +	return retval;
> +}

Cheers,
	-Matt Helsley

