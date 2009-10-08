Return-Path: <linux-kernel-owner+w=401wt.eu-S933813AbZJHVcW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933813AbZJHVcW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 17:32:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932330AbZJHVcV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 17:32:21 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:44316 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932153AbZJHVcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 17:32:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=fniQbLITzR4aybURogkKZg3QoOoWhL8USwCaFYLsqmzE3RJogsKKqpLKSyHR6TEa9s
         3Nn06fCn5By9S6Xy6RXrwI8wms33zRulEhzZ/mjPKxpiN3bzGCt4yTqXSpIINrKmz11E
         /HdROhlY291wSHU14TuiZO3H7sENFJ5kEbq/8=
Message-ID: <4ACE5A53.3010502@gmail.com>
Date: Thu, 08 Oct 2009 23:32:03 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Neil Horman <nhorman@tuxdriver.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 1/3] extend get/setrlimit to support setting rlimits external
 to a process (v4)
References: <20090928200600.GA3053@hmsreliant.think-freely.org> <20091001171538.GB2456@hmsreliant.think-freely.org> <20091005002617.GA5736@localhost.localdomain> <20091005005321.GA7180@localhost.localdomain>
In-Reply-To: <20091005005321.GA7180@localhost.localdomain>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I found some new issues in this patch, sorry ;).

Neil Horman wrote:
> (...)
> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index 6f742f6..631f01b 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -49,6 +49,8 @@
>  
>  #include <asm/uaccess.h>
>  
> +#include <linux/string.h>
> +#include <linux/ctype.h>
>  #include <linux/errno.h>
>  #include <linux/time.h>
>  #include <linux/proc_fs.h>
> @@ -455,72 +457,193 @@ static int proc_oom_score(struct task_struct *task, char *buffer)
>  struct limit_names {
>  	char *name;
>  	char *unit;
> +	char *match;
>  };
>  
>  static const struct limit_names lnames[RLIM_NLIMITS] = {
> -	[RLIMIT_CPU] = {"Max cpu time", "ms"},
> -	[RLIMIT_FSIZE] = {"Max file size", "bytes"},
> -	[RLIMIT_DATA] = {"Max data size", "bytes"},
> -	[RLIMIT_STACK] = {"Max stack size", "bytes"},
> -	[RLIMIT_CORE] = {"Max core file size", "bytes"},
> -	[RLIMIT_RSS] = {"Max resident set", "bytes"},
> -	[RLIMIT_NPROC] = {"Max processes", "processes"},
> -	[RLIMIT_NOFILE] = {"Max open files", "files"},
> -	[RLIMIT_MEMLOCK] = {"Max locked memory", "bytes"},
> -	[RLIMIT_AS] = {"Max address space", "bytes"},
> -	[RLIMIT_LOCKS] = {"Max file locks", "locks"},
> -	[RLIMIT_SIGPENDING] = {"Max pending signals", "signals"},
> -	[RLIMIT_MSGQUEUE] = {"Max msgqueue size", "bytes"},
> -	[RLIMIT_NICE] = {"Max nice priority", NULL},
> -	[RLIMIT_RTPRIO] = {"Max realtime priority", NULL},
> -	[RLIMIT_RTTIME] = {"Max realtime timeout", "us"},
> +	[RLIMIT_CPU] = {"Max cpu time", "ms", "cpu"},
> +	[RLIMIT_FSIZE] = {"Max file size", "bytes", "fsize"},
> +	[RLIMIT_DATA] = {"Max data size", "bytes", "data"},
> +	[RLIMIT_STACK] = {"Max stack size", "bytes", "stack"},
> +	[RLIMIT_CORE] = {"Max core file size", "bytes", "core"},
> +	[RLIMIT_RSS] = {"Max resident set", "bytes", "rss"},
> +	[RLIMIT_NPROC] = {"Max processes", "processes", "nproc"},
> +	[RLIMIT_NOFILE] = {"Max open files", "files", "nofile"},
> +	[RLIMIT_MEMLOCK] = {"Max locked memory", "bytes", "memlock"},
> +	[RLIMIT_AS] = {"Max address space", "bytes", "as"},
> +	[RLIMIT_LOCKS] = {"Max file locks", "locks", "locks"},
> +	[RLIMIT_SIGPENDING] = {"Max pending signals", "signals", "sigpending"},
> +	[RLIMIT_MSGQUEUE] = {"Max msgqueue size", "bytes", "msgqueue"},
> +	[RLIMIT_NICE] = {"Max nice priority", NULL, "nice"},
> +	[RLIMIT_RTPRIO] = {"Max realtime priority", NULL, "rtprio"},
> +	[RLIMIT_RTTIME] = {"Max realtime timeout", "us", "rttime"},
>  };

There's no way user can figure out what's the "match" for every limit.
Maybe you could print it after "limit name"?

>  
>  /* Display limits for a process */
> -static int proc_pid_limits(struct task_struct *task, char *buffer)
> +static ssize_t proc_pid_limit_read(struct file *file, char __user *buf,
> +			size_t count, loff_t *ppos)
>  {
>  	unsigned int i;
> -	int count = 0;
>  	unsigned long flags;
> -	char *bufptr = buffer;
> +	char *bufptr;
> +	size_t bcount = 0;
> +	size_t ccount = -ENOMEM;
> +	struct task_struct *task = get_proc_task(file->f_path.dentry->d_inode);
>  
>  	struct rlimit rlim[RLIM_NLIMITS];
>  
> +	bufptr = kzalloc(PAGE_SIZE, GFP_KERNEL);

I think you could derive size of allocation from RLIM_NLIMITS.
If I'm reading correctly it will be something like (RLIM_NLIMITS + 1) * 80.

> +	if (!bufptr)
> +		goto out;
> +
> +	ccount = -EBUSY;
> +
>  	if (!lock_task_sighand(task, &flags))
> -		return 0;
> +		goto out_free;
>  	memcpy(rlim, task->signal->rlim, sizeof(struct rlimit) * RLIM_NLIMITS);
>  	unlock_task_sighand(task, &flags);
>  
>  	/*
>  	 * print the file header
>  	 */
> -	count += sprintf(&bufptr[count], "%-25s %-20s %-20s %-10s\n",
> +	bcount += sprintf(&bufptr[bcount], "%-25s %-20s %-20s %-10s\n",
>  			"Limit", "Soft Limit", "Hard Limit", "Units");
>  
>  	for (i = 0; i < RLIM_NLIMITS; i++) {
>  		if (rlim[i].rlim_cur == RLIM_INFINITY)
> -			count += sprintf(&bufptr[count], "%-25s %-20s ",
> +			bcount += sprintf(&bufptr[bcount], "%-25s %-20s ",
>  					 lnames[i].name, "unlimited");
>  		else
> -			count += sprintf(&bufptr[count], "%-25s %-20lu ",
> +			bcount += sprintf(&bufptr[bcount], "%-25s %-20lu ",
>  					 lnames[i].name, rlim[i].rlim_cur);
>  
>  		if (rlim[i].rlim_max == RLIM_INFINITY)
> -			count += sprintf(&bufptr[count], "%-20s ", "unlimited");
> +			bcount += sprintf(&bufptr[bcount], "%-20s ",
> +					 "unlimited");
>  		else
> -			count += sprintf(&bufptr[count], "%-20lu ",
> +			bcount += sprintf(&bufptr[bcount], "%-20lu ",
>  					 rlim[i].rlim_max);
>  
>  		if (lnames[i].unit)
> -			count += sprintf(&bufptr[count], "%-10s\n",
> +			bcount += sprintf(&bufptr[bcount], "%-10s\n",
>  					 lnames[i].unit);
>  		else
> -			count += sprintf(&bufptr[count], "\n");
> +			bcount += sprintf(&bufptr[bcount], "\n");
>  	}
>  
> -	return count;
> +	ccount = -EMSGSIZE;
> +
> +	if (*ppos >= bcount)
> +		goto out_task;
> +
> +	ccount = min(count, (size_t)(bcount-(*ppos)));
> +	ccount = ccount - copy_to_user(buf, &bufptr[*ppos], ccount);
> +	*ppos += ccount;
> +
> +out_task:
> +	put_task_struct(task);
> +out_free:
> +	kfree(bufptr);
> +out:
> +	return ccount;
> +}
> +
> +#define PROC_PID_BUF_SZ 128
> +static ssize_t proc_pid_limit_write(struct file *file, const char __user *buf,
> +		size_t count, loff_t *ppos)
> +{
> +	char *buffer;
> +	char *element, *vmc, *vmm;
> +	struct rlimit new_rlim;
> +	unsigned long flags;
> +	int i;
> +	int index = -1;
> +	size_t wcount = -EMSGSIZE;
> +	struct task_struct *task = get_proc_task(file->f_path.dentry->d_inode);
> +
> +	if (*ppos != 0)
> +		goto out;
> +
> +	if (count > PROC_PID_BUF_SZ)
> +		goto out;
> +
> +	wcount = -ENOMEM;
> +	buffer = kzalloc(PROC_PID_BUF_SZ, GFP_KERNEL);
> +
> +	if (!buffer)
> +		goto out;
> +
> +	element = kzalloc(PROC_PID_BUF_SZ, GFP_KERNEL);
> +	vmc = kzalloc(PROC_PID_BUF_SZ, GFP_KERNEL);
> +	vmm = kzalloc(PROC_PID_BUF_SZ, GFP_KERNEL);
> +
> +	if (!element || !vmm || !vmc)
> +		goto out_free;
> +
> +	wcount = -EFAULT;
> +	if (copy_from_user(buffer, buf, count))
> +		goto out_free;
> +
> +	i = sscanf(buffer, "%s %s %s", element, vmc, vmm);
> +
> +	if (i < 3)
> +		goto out_free;
> +
> +	for (i = 0; i < strlen(element); i++)
> +		element[i] = tolower(element[i]);

I don't think we should fix user mistakes like this...

> +
> +	if (!strncmp(vmc, "unlimited", 9))
> +		new_rlim.rlim_cur = RLIM_INFINITY;
> +	else
> +		new_rlim.rlim_cur = simple_strtoull(vmc, NULL, 10);

rlim_cur and rlim_max are unsigned long so you should use simple_strtoul

> +
> +	if (!strncmp(vmm, "unlimited", 9))
> +		new_rlim.rlim_max = RLIM_INFINITY;
> +	else
> +		new_rlim.rlim_max = simple_strtoull(vmm, NULL, 10);
> +
> +
> +	for (i = 0; i < RLIM_NLIMITS; i++) {
> +		if ((lnames[i].match) &&

match is always not null, you can drop this check

> +		    !strncmp(element, lnames[i].match,
> +		     strlen(lnames[i].match))) {
> +			index = i;
> +			break;
> +		}
> +	}
> +
> +	wcount = -EBUSY;
> +
> +	if (!lock_task_sighand(task, &flags))
> +		goto out_free;
> +
> +	wcount = -ENOENT;
> +
> +	if ((index >= 0) && (index < RLIM_NLIMITS))
> +		wcount = do_setrlimit(index, &new_rlim, task);
> +
> +	unlock_task_sighand(task, &flags);
> +
> +out_free:
> +	kfree(element);
> +	kfree(vmc);
> +	kfree(vmm);
> +	kfree(buffer);
> +out:
> +	if (!wcount) {
> +		*ppos += count;
> +		wcount = count;
> +	}
> +	put_task_struct(task);
> +	return wcount;
>  }
> (...)
