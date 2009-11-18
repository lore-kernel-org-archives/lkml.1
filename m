Return-Path: <linux-kernel-owner+w=401wt.eu-S1756479AbZKRVzY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756479AbZKRVzY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 16:55:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755727AbZKRVzX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 16:55:23 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57244 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753685AbZKRVzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 16:55:22 -0500
Date: Wed, 18 Nov 2009 13:54:57 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: john stultz <johnstul@us.ibm.com>
Cc: Andi Kleen <andi@firstfloor.org>, Arjan van de Ven <arjan@infradead.org>,
       lkml <linux-kernel@vger.kernel.org>, Mike Fulton <fultonm@ca.ibm.com>,
       Sean Foley <Sean_Foley@ca.ibm.com>, Darren Hart <dvhltc@us.ibm.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH] Allow threads to rename siblings via
 /proc/pid/tasks/tid/comm
Message-Id: <20091118135457.6471af1f.akpm@linux-foundation.org>
In-Reply-To: <1258405867.10576.2.camel@work-vm>
References: <1256347303.5059.26.camel@localhost.localdomain>
	<1257557918.3298.21.camel@localhost.localdomain>
	<87aayy6j8b.fsf@basil.nowhere.org>
	<1258405867.10576.2.camel@work-vm>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Nov 2009 13:11:07 -0800
john stultz <johnstul@us.ibm.com> wrote:

> Setting a thread's comm to be something unique is a very useful ability
> and is helpful for debugging complicated threaded applications. However
> currently the only way to set a thread name is for the thread to name
> itself via the PR_SET_NAME prctl.
> 
> However, there may be situations where it would be advantageous for a
> thread dispatcher to be naming the threads its managing, rather then
> having the threads self-describe themselves. This sort of behavior is
> available on other systems via the pthread_setname_np() interface.
> 
> This patch exports a task's comm via proc/pid/comm and
> proc/pid/task/tid/comm interfaces, and allows thread siblings to write
> to these values.
> 

Would be nice to document the new userspace interface. 
Documentation/filesystems/proc.txt, perhaps.

> 
> diff --git a/fs/exec.c b/fs/exec.c
> index d49be6b..90003f8 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -926,6 +926,15 @@ char *get_task_comm(char *buf, struct task_struct *tsk)
>  void set_task_comm(struct task_struct *tsk, char *buf)
>  {
>  	task_lock(tsk);
> +
> +	/*
> +	 * Threads may access current->comm without holding
> +	 * the task lock, so write the string carefully.
> +	 * Readers without a lock may see incomplete new
> +	 * names but are safe from non-terminating string reads.
> +	 */
> +	memset(tsk->comm, 0, TASK_COMM_LEN);
> +	wmb();

OK.

>  	strlcpy(tsk->comm, buf, sizeof(tsk->comm));
>  	task_unlock(tsk);
>  	perf_event_comm(tsk);
> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index 837469a..7f59af1 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -1265,6 +1265,78 @@ static const struct file_operations proc_pid_sched_operations = {
>  
>  #endif
>  
> +
> +
> +static ssize_t
> +comm_write(struct file *file, const char __user *buf,
> +	    size_t count, loff_t *offset)
> +{
> +	struct inode *inode = file->f_path.dentry->d_inode;
> +	struct task_struct *p;
> +	char buffer[TASK_COMM_LEN];
> +
> +	memset(buffer, 0, sizeof(buffer));
> +	if (count > sizeof(buffer) - 1)
> +		count = sizeof(buffer) - 1;

Is this the best policy?  If userspace tries to apply a too-long name
to a thread, the kernel will silently truncate (ie: corrupt) it?  I'd
have thought that returning an error would be more robust?

> +	if (copy_from_user(buffer, buf, count))
> +		return -EFAULT;
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

Is same_thread_group() sufficient?  Are any security/permission-related
checks appropriate here, for example?

The restriction to a separate thread group seems a bit arbitrary,
really.  There's no reason I can see why we cannot permit unrelated
(but suitably authorised) processes to do this.

This patch makes task->comm inconsistent with /prod/pid/cmdline.  What
are the implications of that for userspace?  None, I guess, given that
this can already be done.

> +
> +static int comm_show(struct seq_file *m, void *v)
> +{
> +	struct inode *inode = m->private;
> +	struct task_struct *p;
> +
> +	p = get_proc_task(inode);
> +	if (!p)
> +		return -ESRCH;
> +
> +	task_lock(p);
> +	seq_printf(m, "%s\n", p->comm);
> +	task_unlock(p);
> +
> +	put_task_struct(p);
> +
> +	return 0;
> +}
> +
> +static int comm_open(struct inode *inode, struct file *filp)
> +{
> +	int ret;
> +
> +	ret = single_open(filp, comm_show, NULL);
> +	if (!ret) {
> +		struct seq_file *m = filp->private_data;
> +
> +		m->private = inode;
> +	}
> +	return ret;
> +}
> +
> +

The patch has a seemingly-random inexplicable mixture of \n and \n\n.

> +static const struct file_operations proc_pid_set_comm_operations = {
> +	.open		= comm_open,
> +	.read		= seq_read,
> +	.write		= comm_write,
> +	.llseek		= seq_lseek,
> +	.release	= single_release,
> +};
> +
> +
>  /*
>   * We added or removed a vma mapping the executable. The vmas are only mapped
>   * during exec and are not mapped with the mmap system call.
> @@ -2504,6 +2576,7 @@ static const struct pid_entry tgid_base_stuff[] = {
>  #ifdef CONFIG_SCHED_DEBUG
>  	REG("sched",      S_IRUGO|S_IWUSR, proc_pid_sched_operations),
>  #endif
> +	REG("comm",      S_IRUGO|S_IWUSR, proc_pid_set_comm_operations),
>  #ifdef CONFIG_HAVE_ARCH_TRACEHOOK
>  	INF("syscall",    S_IRUSR, proc_pid_syscall),
>  #endif
> @@ -2839,6 +2912,7 @@ static const struct pid_entry tid_base_stuff[] = {
>  #ifdef CONFIG_SCHED_DEBUG
>  	REG("sched",     S_IRUGO|S_IWUSR, proc_pid_sched_operations),
>  #endif
> +	REG("comm",      S_IRUGO|S_IWUSR, proc_pid_set_comm_operations),
>  #ifdef CONFIG_HAVE_ARCH_TRACEHOOK
>  	INF("syscall",   S_IRUSR, proc_pid_syscall),
>  #endif

