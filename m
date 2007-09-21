Return-Path: <linux-kernel-owner+w=401wt.eu-S1757892AbXIUKBQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757892AbXIUKBQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 06:01:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756588AbXIUKA7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 06:00:59 -0400
Received: from gir.skynet.ie ([193.1.99.77]:54581 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757731AbXIUKA6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 06:00:58 -0400
Date: Fri, 21 Sep 2007 11:00:56 +0100
To: Andrew Morton <akpm@linux-foundation.org>
Cc: James Pearson <james-p@moving-picture.com>, linux-kernel@vger.kernel.org,
       aarapov@redhat.com, hpa@zytor.com
Subject: Re: [PATCH -mm] Don't truncate /proc/PID/environ at 4096 characters
Message-ID: <20070921100055.GA3562@skynet.ie>
References: <E1IXziD-0003YJ-0w@moving-picture.com> <20070920164632.fd440b78.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20070920164632.fd440b78.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On (20/09/07 16:46), Andrew Morton didst pronounce:
> On Wed, 19 Sep 2007 14:35:29 +0100
> "James Pearson" <james-p@moving-picture.com> wrote:
> 
> > 
> > From: James Pearson <james-p@moving-picture.com>
> > 
> > /proc/PID/environ currently truncates at 4096 characters, patch based on 
> > the /proc/PID/mem code.
> 
> patch needs to be carefully reviewed from the security POV (ie: permissions)
> as well as for correctness.  Does anyone have time to do that?
> 
> > Signed-off-by: James Pearson <james-p@moving-picture.com>
> > 
> > --- ./fs/proc/base.c.dist	2007-09-19 12:29:46.244929651 +0100
> > +++ ./fs/proc/base.c	2007-09-19 12:36:18.155648760 +0100
> > @@ -202,27 +202,6 @@ static int proc_root_link(struct inode *
> >  	 (task->state == TASK_STOPPED || task->state == TASK_TRACED) && \
> >  	 security_ptrace(current,task) == 0))
> >  
> > -static int proc_pid_environ(struct task_struct *task, char * buffer)
> > -{
> > -	int res = 0;
> > -	struct mm_struct *mm = get_task_mm(task);
> > -	if (mm) {
> > -		unsigned int len;
> > -
> > -		res = -ESRCH;
> > -		if (!ptrace_may_attach(task))
> > -			goto out;
> > -
> > -		len  = mm->env_end - mm->env_start;
> > -		if (len > PAGE_SIZE)
> > -			len = PAGE_SIZE;
> > -		res = access_process_vm(task, mm->env_start, buffer, len, 0);
> > -out:
> > -		mmput(mm);
> > -	}
> > -	return res;
> > -}
> > -
> >  static int proc_pid_cmdline(struct task_struct *task, char * buffer)
> >  {
> >  	int res = 0;
> > @@ -740,6 +719,79 @@ static const struct file_operations proc
> >  	.open		= mem_open,
> >  };
> >  
> > +static ssize_t environ_read(struct file *file, char __user *buf,
> > +			size_t count, loff_t *ppos)
> > +{
> > +	struct task_struct *task = get_proc_task(file->f_dentry->d_inode);
> > +	char *page;
> > +	unsigned long src = *ppos;
> > +	int ret = -ESRCH;
> > +	struct mm_struct *mm;
> > +	size_t max_len;
> > +
> > +	if (!task)
> > +		goto out_no_task;
> > +
> > +	if (!ptrace_may_attach(task))
> > +		goto out;
> > +
> > +	ret = -ENOMEM;
> > +	page = (char *)__get_free_page(GFP_TEMPORARY);
> 
> Now I wonder what inspired you to reach for GFP_TEMPORARY?  Perhaps the
> fact that it is crappily named and undocumented.
> 

Because it's a very short lived allocation? He allocates it here and
frees it at the end of the function again.

> This should be GFP_KERNEL - the page you're allocating here is not
> reclaimable by the VM.
> 

The patch leader documented how this works although you're right in that the
code doesn't explain it adequately. Temporary and short-lived allocations
are grouped with kernel-reclaimable pages such as inode and dcache pages
intentionally.

> > +	if (!page)
> > +		goto out;
> > +
> > +	ret = 0;
> > +
> > +	mm = get_task_mm(task);
> > +	if (!mm)
> > +		goto out_free;
> > +
> > +	max_len = (count > PAGE_SIZE) ? PAGE_SIZE : count;
> > +
> > +	while (count > 0) {
> > +		int this_len, retval;
> > +
> > +		this_len = mm->env_end - (mm->env_start + src);
> > +
> > +		if (this_len <= 0)
> > +			break;
> > +
> > +		if (this_len > max_len)
> > +			this_len = max_len;
> > +
> > +		retval = access_process_vm(task, (mm->env_start + src),
> > +			page, this_len, 0);
> > +
> > +		if (retval <= 0) {
> > +			ret = retval;
> > +			break;
> > +		}
> > +
> > +		if (copy_to_user(buf, page, retval)) {
> > +			ret = -EFAULT;
> > +			break;
> > +		}
> > +
> > +		ret += retval;
> > +		src += retval;
> > +		buf += retval;
> > +		count -= retval;
> > +	}
> 
> Now that's a funky loop.  Someone please convince me that there is no way
> in which `count - retval' can ever go negative (ie: huge positive).
> 
> 
> > +	*ppos = src;
> > +
> > +	mmput(mm);
> > +out_free:
> > +	free_page((unsigned long) page);
> > +out:
> > +	put_task_struct(task);
> > +out_no_task:
> > +	return ret;
> > +}
> > +
> > +static const struct file_operations proc_environ_operations = {
> > +	.read		= environ_read,
> > +};
> > +
> >  static ssize_t oom_adjust_read(struct file *file, char __user *buf,
> >  				size_t count, loff_t *ppos)
> >  {
> > @@ -2092,7 +2144,7 @@ static const struct pid_entry tgid_base_
> >  	DIR("task",       S_IRUGO|S_IXUGO, task),
> >  	DIR("fd",         S_IRUSR|S_IXUSR, fd),
> >  	DIR("fdinfo",     S_IRUSR|S_IXUSR, fdinfo),
> > -	INF("environ",    S_IRUSR, pid_environ),
> > +	REG("environ",    S_IRUSR, environ),
> >  	INF("auxv",       S_IRUSR, pid_auxv),
> >  	INF("status",     S_IRUGO, pid_status),
> >  	INF("limits",	  S_IRUSR, pid_limits),
> > @@ -2421,7 +2473,7 @@ out_no_task:
> >  static const struct pid_entry tid_base_stuff[] = {
> >  	DIR("fd",        S_IRUSR|S_IXUSR, fd),
> >  	DIR("fdinfo",    S_IRUSR|S_IXUSR, fdinfo),
> > -	INF("environ",   S_IRUSR, pid_environ),
> > +	REG("environ",   S_IRUSR, environ),
> >  	INF("auxv",      S_IRUSR, pid_auxv),
> >  	INF("status",    S_IRUGO, pid_status),
> >  	INF("limits",	 S_IRUSR, pid_limits),
> 

-- 
-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
