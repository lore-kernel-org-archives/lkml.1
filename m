Return-Path: <linux-kernel-owner+w=401wt.eu-S1755030AbZG2XOF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755030AbZG2XOF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 19:14:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754344AbZG2XOF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 19:14:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47622 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753989AbZG2XOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 19:14:03 -0400
Date: Wed, 29 Jul 2009 16:13:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Rientjes <rientjes@google.com>
Cc: riel@redhat.com, menage@google.com, kosaki.motohiro@jp.fujitsu.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch -mm v2] mm: introduce oom_adj_child
Message-Id: <20090729161341.269b90e3.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.00.0907282125260.554@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0907282125260.554@chino.kir.corp.google.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Jul 2009 21:27:15 -0700 (PDT)
David Rientjes <rientjes@google.com> wrote:

> +static ssize_t oom_adj_child_write(struct file *file, const char __user *buf,
> +				size_t count, loff_t *ppos)
> +{
> +	struct task_struct *task;
> +	char buffer[PROC_NUMBUF], *end;
> +	int oom_adj_child;
> +
> +	memset(buffer, 0, sizeof(buffer));
> +	if (count > sizeof(buffer) - 1)
> +		count = sizeof(buffer) - 1;
> +	if (copy_from_user(buffer, buf, count))
> +		return -EFAULT;
> +	oom_adj_child = simple_strtol(buffer, &end, 0);
> +	if ((oom_adj_child < OOM_ADJUST_MIN ||
> +	     oom_adj_child > OOM_ADJUST_MAX) && oom_adj_child != OOM_DISABLE)
> +		return -EINVAL;
> +	if (*end == '\n')
> +		end++;
> +	task = get_proc_task(file->f_path.dentry->d_inode);
> +	if (!task)
> +		return -ESRCH;
> +	task_lock(task);
> +	if (task->mm && oom_adj_child < task->mm->oom_adj &&
> +	    !capable(CAP_SYS_RESOURCE)) {
> +		task_unlock(task);
> +		put_task_struct(task);
> +		return -EINVAL;
> +	}
> +	task_unlock(task);
> +	task->oom_adj_child = oom_adj_child;
> +	put_task_struct(task);
> +	if (end - buffer == 0)
> +		return -EIO;
> +	return end - buffer;
> +}

Do we really need to do all that string hacking?  All it does is reads
a plain old integer from userspace.

It's weird that the obfuscated check for zero-length input happens
right at the end of the function, particularly as we couldn't have got
that far anyway, because we'd already have returned -EINVAL.

And even after all that, I suspect the function will permit illogical
input such as "12foo" - which is what strict_strtoul() is for (as
checkpatch points out!).



grumble.  At how many codesites do we read an ascii integer from
userspace?  Thousands, surely.  You'd think we'd have a little function
to do it by now.


