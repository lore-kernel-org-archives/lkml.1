Return-Path: <linux-kernel-owner+w=401wt.eu-S1752276AbZJXDpw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752276AbZJXDpw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 23:45:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752073AbZJXDpv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 23:45:51 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:47371 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031AbZJXDpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 23:45:51 -0400
Message-ID: <4AE2786C.7000400@us.ibm.com>
Date: Fri, 23 Oct 2009 20:45:48 -0700
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: john stultz <johnstul@us.ibm.com>
CC: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       lkml <linux-kernel@vger.kernel.org>, Mike Fulton <fultonm@ca.ibm.com>,
       Sean Foley <Sean_Foley@ca.ibm.com>
Subject: Re: [RFC][PATCH] Add prctl to set sibling thread names (take two)
References: <1256347303.5059.26.camel@localhost.localdomain>
In-Reply-To: <1256347303.5059.26.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John,

Just a couple nitpics really, looks pretty good to me - other than the 
need for the wmb()s below.

john stultz wrote:
> This patch exports a task's comm via proc/pid/comm and
> proc/pid/task/tid/comm interfaces, and allows thread siblings to write
> to these values.

And the parent I presume?

> +	/*
> +	 * Threads may access current->comm without holding
> +	 * the task lock, so write the string carefully
> +	 * to avoid non-terminating reads. Readers without a lock
> +	 * with get the oldname, the newname or an empty string.

s/with/will/
s/oldname/old name/ (it isn't a variable right?)
s/newname/new name/ (it isn't a variable right?)

> +	 */
> +	tsk->comm[0] = NULL;
> +	/* XXX - Need an mb() here?*/

I believe you do, yes. Now, which one... hrm... checking... You only 
care about ensuring the the comm[0] store occurs BEFORE the strlcpy. 
But, if no lock is held here, you can be preempted, so this is important 
for both UP and SMP.  I believe what you need here is:

	wmb()

Memory barrier experts, please enlighten us if I am missing something.

> +	strlcpy(tsk->comm+1, buf+1, sizeof(tsk->comm)-1);

And one more here I should think, otherwise that could effectively undo 
the previous one :-)

	wmb()

> +	tsk->comm[0] = buf[0];
>  	task_unlock(tsk);

To be clear, we hold the lock to prevent other threads from changing 
this at the same time as us - any other thread but the target thread 
that is?

> +static ssize_t
> +comm_write(struct file *file, const char __user *buf,
> +	    size_t count, loff_t *offset)
> +{
> +	struct inode *inode = file->f_path.dentry->d_inode;
> +	struct task_struct *p;
> +	char buffer[TASK_COMM_LEN];
> +
> +	memset(buffer, 0, sizeof(buffer));

What purpose does zeroing this entire buffer serve?

> +	if (count > sizeof(buffer) - 1)
> +		count = sizeof(buffer) - 1;
> +	if (copy_from_user(buffer, buf, count))
> +		return -EFAULT;
> +

Extra whitespace

> +
> +	p = get_proc_task(inode);
> +	if (!p)
> +		return -ESRCH;
> +
> +	if (same_thread_group(current, p))
> +		set_task_comm(p, buffer);
> +	else
> +		count = -EINVAL;
> +
> +	put_task_struct(p);
> +
> +	return count;
> +}

Thanks,

-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
