Return-Path: <linux-kernel-owner+w=401wt.eu-S1753889AbZI2BPG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753889AbZI2BPG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 21:15:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753810AbZI2BPF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 21:15:05 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:53454 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753689AbZI2BPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 21:15:03 -0400
Date: Mon, 28 Sep 2009 21:14:55 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] proc: augment /proc/pid/limits to allow setting of
	process limits.
Message-ID: <20090929011455.GA3503@localhost.localdomain>
References: <20090928200600.GA3053@hmsreliant.think-freely.org> <20090928154403.25678002.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090928154403.25678002.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Spam-Score: -4.4 (----)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 28, 2009 at 03:44:03PM -0700, Andrew Morton wrote:
> On Mon, 28 Sep 2009 16:06:00 -0400
> Neil Horman <nhorman@tuxdriver.com> wrote:
> 
> > Augment /proc/<pid>/limits file to support limit setting
> > 
> > It was suggested to me recently that we support a mechanism by which we can set
> > various process limits from points external to the process.  The reasoning being
> > that some processes are very long lived, and it would be beneficial to these
> > long lived processes if we could modify their various limits without needing to
> > kill them, adjust the limits for the user and restarting them.  While individual
> > application can certainly export this control on their own, it would be nice if
> > such functionality were available to a sysadmin, without needing to have each
> > application re-invent the wheel.
> > 
> > As such, I've implemented the below patch, which makes /proc/pid/limits writable
> > for each process.  By writing the following format:
> > <limit> <current value> <max value>
> > to the limits file, an administrator can now dynamically change the limits for
> > the respective process.  Tested by myself with good results.
> > 
> 
> Confused.  This appears to allow processes to cheerily exceed their
> inherited limits, without bound.  See sys_setrliit()'s
> 
> 	if (new_rlim.rlim_cur > new_rlim.rlim_max)
> 		return -EINVAL;
> 
Gaahh!  You're right, in my worry to get all the string parsing right, I didn't
even consider the semantics of setrlimit.  

> It might allow user A to diddle user B's limit too, I didn't check?
> 
No, it can't do that.  file permissions only allow the process owner and root to
modify the limits.

> And it cheerily avoids security_task_setrlimit() too.
> 
Yeah, it completely breaks that.  Sorry.

> Apart from those somewhat fatal problems, it's all a bit unpleasing that
> we now have two ways of setting rlimits, one of which is a superset of
> the other.  Perhaps a better way would be a new sys_setrlimit2() which
> takes a pid (in the current pid namespace, one assumes).  Then deprecate
> sys_setrlimit().
> 
Do you think its worth adding a syscall just for this?  I think theres merit in
this feature (I wrote it :)), but I'm not sure if syscall is really warranted.
you're above notes are obviously a problem, but I think they can be fixed.  Its
easy to make sure that if the writing user is the process owner and restrict the
max value raising, and the selinux check can be added.

clearly I rescind this patch (sorry for the noise).  I'll see if I can add the
checks needed above and repost.
Neil

> >
> > ...
> >
> > +static ssize_t proc_pid_limit_write(struct file *file, const char __user *buf,
> > +		size_t count, loff_t *ppos)
> > +{
> > +	char *buffer;
> > +	char *element, *vmc, *vmm;
> > +	unsigned long long valuec, valuem;
> > +	unsigned long flags;
> > +	int i;
> > +	int index = -1;
> > +	size_t wcount = 0;
> > +	struct task_struct *task = get_proc_task(file->f_path.dentry->d_inode);
> > +
> > +
> > +	if (*ppos != 0)
> > +		goto out;
> > +
> > +	if (count > 128)
> > +		goto out;
> > +	buffer = kzalloc(128, GFP_KERNEL);
> > +
> > +	if (!buffer)
> > +		goto out;
> > +
> > +	element = kzalloc(sizeof(buffer), GFP_KERNEL);
> > +	vmc = kzalloc(sizeof(buffer), GFP_KERNEL);
> > +	vmm = kzalloc(sizeof(buffer), GFP_KERNEL);
> > +
> > +	if (!element || !vmm || !vmc)
> > +		goto out_free;
> > +
> > +	wcount = count - copy_from_user(buffer, buf, count);
> > +	if (wcount < count)
> > +		goto out_free;
> > +
> > +	i = sscanf(buffer, "%s %s %s", element, vmc, vmm);
> > +
> > +	if (i < 3)
> > +		goto out_free;
> > +
> > +	for (i = 0; i <= strlen(element); i++)
> > +		element[i] = tolower(element[i]);
> > +
> > +	if (!strncmp(vmc, "unlimited", 9))
> > +		valuec = RLIM_INFINITY;
> > +	else
> > +		valuec = simple_strtoull(vmc, NULL, 10);
> > +
> > +	if (!strncmp(vmm, "unlimited", 9))
> > +		valuem = RLIM_INFINITY;
> > +	else
> > +		valuem = simple_strtoull(vmm, NULL, 10);
> > +
> > +	for (i = 0; i < RLIM_NLIMITS; i++) {
> > +		if ((lnames[i].match) &&
> > +		    !strncmp(element, lnames[i].match, 
> > +		     strlen(lnames[i].match))) {
> > +			index = i;
> > +			break;
> > +		}
> > +	}
> > +
> > +	if (!lock_task_sighand(task, &flags))
> > +		goto out_free;
> 
> The function silently does nothing if lock_task_sighand() fails.
> 
> > +	if (index >= 0) {
> > +		task->signal->rlim[index].rlim_cur = valuec;
> > +		task->signal->rlim[index].rlim_max = valuem;
> > +	}
> > +
> > +	unlock_task_sighand(task, &flags);
> > +
> > +out_free:
> > +	kfree(element);
> > +	kfree(vmc);
> > +	kfree(vmm);
> > +	kfree(buffer);
> > +out:
> > +	*ppos += count;
> > +	put_task_struct(task);
> >  	return count;
> >  }
> >  
> > +
> > +static const struct file_operations proc_limit_operations = {
> > +        .read           = proc_pid_limit_read,
> > +	.write		= proc_pid_limit_write,
> 
> whitespace got munged.
> 
> > +};
> > +
> 
> 
