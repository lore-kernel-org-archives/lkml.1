Return-Path: <linux-kernel-owner+w=401wt.eu-S932093AbYBMJPX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932093AbYBMJPX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 04:15:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751584AbYBMJPA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 04:15:00 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38065 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750899AbYBMJO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 04:14:57 -0500
Date: Wed, 13 Feb 2008 01:13:10 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, a.p.zijlstra@chello.nl
Subject: Re: [RFC v2 PATCH] RTTIME watchdog timer proc interface
Message-Id: <20080213011310.e27dd9cf.akpm@linux-foundation.org>
In-Reply-To: <47B220A6.5090707@ct.jp.nec.com>
References: <47B220A6.5090707@ct.jp.nec.com>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Feb 2008 14:41:42 -0800 Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com> wrote:

> From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> 
> Introduce new proc interface for RTTIME watchdog.
> It makes administrator able to set RTTIME watchdog to existing
> real-time applications without impact.
> 
> $ echo 10000000 > /proc/<pid>/rttime
> set RTTIME current value to 10000000, it means 10sec.
> 
> $ echo "10000000 20000000" > /proc/<pid>/rttime
> set RTTIME current value to 10000000 and max value to 20000000.

How does one set it to `unlimited'?

> And /proc/<pid>/task/<tid>/rttime is also accessible.

Please describe the format in the changelog.

> Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> ---
>  fs/proc/base.c |   89 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 89 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index 7c6b4ec..3212b44 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -381,6 +381,93 @@ static const struct file_operations proc_lstats_operations = {
>  
>  #endif
>  
> +static int rttime_show_proc(struct seq_file *m, void *v)
> +{
> +	struct task_struct *task = m->private;
> +	struct signal_struct *signal = task->signal;
> +	struct rlimit *rt = &signal->rlim[RLIMIT_RTTIME];
> +
> +	if (rt->rlim_cur == RLIM_INFINITY)
> +		seq_printf(m, "unlimited ");
> +	else
> +		seq_printf(m, "%lu ", rt->rlim_cur);
> +
> +	if (rt->rlim_max == RLIM_INFINITY)
> +		seq_printf(m, "unlimited\n");
> +	else
> +		seq_printf(m, "%lu\n", rt->rlim_max);
> +
> +	return 0;
> +}
> +
> +static int rttime_open(struct inode *inode, struct file *file)
> +{
> +	int ret;
> +	struct seq_file *m;
> +	struct task_struct *task = get_proc_task(inode);
> +
> +	ret = single_open(file, rttime_show_proc, NULL);
> +	if (!ret) {
> +		m = file->private_data;
> +		m->private = task;
> +	}
> +	return ret;
> +}

get_proc_task() can return NULL, in which case it appears that the kernel
will later oops?

> +static ssize_t rttime_write(struct file *file,
> +			    const char __user *buf,
> +			    size_t count,
> +			    loff_t *ppos)
> +{
> +	struct seq_file *m = file->private_data;
> +	struct task_struct *task = m->private;
> +	char buffer[PROC_NUMBUF], *end;
> +	struct rlimit new_rlim, *old_rlim;
> +	int n, ret;

`n' should be size_t.  And a better name would be nice.

> +	old_rlim = task->signal->rlim + RLIMIT_RTTIME;
> +	new_rlim = *old_rlim;
> +	memset(buffer, 0, sizeof(buffer));
> +	n = count;
> +	if (n > sizeof(buffer) - 1)
> +		n = sizeof(buffer) - 1;

min()

> +	if (copy_from_user(buffer, buf, n))
> +		return -EFAULT;
> +	new_rlim.rlim_cur = simple_strtoul(buffer, &end, 0);
> +	if (*end == ' ') {
> +		++end;
> +		buf += end - buffer;
> +		memset(buffer, 0, sizeof(buffer));
> +		n = count - (end - buffer);
> +		if (n > sizeof(buffer) - 1)
> +			n = sizeof(buffer) - 1;

min()

> +		if (copy_from_user(buffer, buf, n))
> +			return -EFAULT;
> +		new_rlim.rlim_max = simple_strtoul(buffer, &end, 0);

strict_strtoul()?

> +	}
> +	if (new_rlim.rlim_cur > new_rlim.rlim_max)
> +		return -EINVAL;
> +	if ((new_rlim.rlim_max > old_rlim->rlim_max) &&
> +	    !capable(CAP_SYS_RESOURCE))
> +		return -EPERM;
> +	ret = security_task_setrlimit(RLIMIT_RTTIME, &new_rlim);
> +	if (ret)
> +		return ret;
> +	task_lock(task->group_leader);
> +	*old_rlim = new_rlim;
> +	task_unlock(task->group_leader);

hm.  Why do we lock on ->group_leader rather than the task itself?

> +	return count;
> +}
> +
> +static const struct file_operations proc_rttime_operations = {
> +	.open		= rttime_open,
> +	.read		= seq_read,
> +	.write		= rttime_write,
> +	.llseek		= seq_lseek,
> +	.release	= single_release,
> +};
> +
>  /* The badness from the OOM killer */
>  unsigned long badness(struct task_struct *p, unsigned long uptime);
>  static int proc_oom_score(struct task_struct *task, char *buffer)
> @@ -2300,6 +2387,7 @@ static const struct pid_entry tgid_base_stuff[] = {
>  	LNK("exe",        exe),
>  	REG("mounts",     S_IRUGO, mounts),
>  	REG("mountstats", S_IRUSR, mountstats),
> +	REG("rttime",     S_IRUSR|S_IWUSR, rttime),
>  #ifdef CONFIG_PROC_PAGE_MONITOR
>  	REG("clear_refs", S_IWUSR, clear_refs),
>  	REG("smaps",      S_IRUGO, smaps),
> @@ -2630,6 +2718,7 @@ static const struct pid_entry tid_base_stuff[] = {
>  	LNK("root",      root),
>  	LNK("exe",       exe),
>  	REG("mounts",    S_IRUGO, mounts),
> +	REG("rttime",    S_IRUSR|S_IWUSR, rttime),
>  #ifdef CONFIG_PROC_PAGE_MONITOR
>  	REG("clear_refs", S_IWUSR, clear_refs),
>  	REG("smaps",     S_IRUGO, smaps),

