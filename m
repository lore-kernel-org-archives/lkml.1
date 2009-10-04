Return-Path: <linux-kernel-owner+w=401wt.eu-S1755435AbZJDMQr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435AbZJDMQr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 08:16:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752537AbZJDMQq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 08:16:46 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:48933 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760AbZJDMQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 08:16:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=WNfF1d5VHt1nh6Tkh0WTlFH2dzkGfm5R3mPtcOaDGyBWuwR8UtXfOUJYzA14wL5/V2
         P133dT4laOhPITlNSpTzBzzeGeYtSZT+dFs38LZH1PXyJSApNC8jdIH5muTDg3CVquuj
         a/DG2wAp32DdGMcCg+RiwdCl+Sctt4eQAQa2k=
Message-ID: <4AC891B9.7090108@gmail.com>
Date: Sun, 04 Oct 2009 14:14:49 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Neil Horman <nhorman@tuxdriver.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 1/3] extend get/setrlimit to support setting rlimits external
 to a process (v3)
References: <20090928200600.GA3053@hmsreliant.think-freely.org> <20091001171538.GB2456@hmsreliant.think-freely.org> <20091001171644.GC2456@hmsreliant.think-freely.org>
In-Reply-To: <20091001171644.GC2456@hmsreliant.think-freely.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Neil Horman wrote:
> Augment /proc/<pid>/limits file to support limit setting
>(...)
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
> +	size_t ccount = 0;
> +	struct task_struct *task = get_proc_task(file->f_path.dentry->d_inode);
>  
>  	struct rlimit rlim[RLIM_NLIMITS];
>  
> +	bufptr = kzalloc(PAGE_SIZE, GFP_KERNEL);
> +	if (!bufptr)
> +		goto out;
> +
>  	if (!lock_task_sighand(task, &flags))
> -		return 0;
> +		goto out;

memory leak (bufptr)

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
> +	}
> +
> +	if (*ppos >= bcount)
> +		goto out_task;

again

> +
> +	ccount = min(count, (size_t)(bcount-(*ppos)));
> +	ccount = ccount - copy_to_user(buf, &bufptr[*ppos], ccount);
> +	*ppos += ccount;
> +	kfree(bufptr);
> +out_task:
> +	put_task_struct(task);
> +out:
> +	return ccount;
> +}
> +
> +static ssize_t proc_pid_limit_write(struct file *file, const char __user *buf,
> +		size_t count, loff_t *ppos)
> +{
> +	char *buffer;
> +	char *element, *vmc, *vmm;
> +	struct rlimit new_rlim;
> +	unsigned long flags;
> +	int i;
> +	int index = -1;
> +	size_t wcount = 0;
> +	struct task_struct *task = get_proc_task(file->f_path.dentry->d_inode);
> +
> +
> +	if (*ppos != 0)
> +		goto out;
> +
> +	if (count > 128)
> +		goto out;
> +	buffer = kzalloc(128, GFP_KERNEL);
> +
> +	if (!buffer)
> +		goto out;

element, vmc, vmm are not initialized and you kfree them in this case

> +
> +	element = kzalloc(sizeof(buffer), GFP_KERNEL);
> +	vmc = kzalloc(sizeof(buffer), GFP_KERNEL);
> +	vmm = kzalloc(sizeof(buffer), GFP_KERNEL);

sizeof(buffer) == 4 or 8 - pretty short buffer...

> +
> +	if (!element || !vmm || !vmc)
> +		goto out_free;
> +
> +	wcount = count - copy_from_user(buffer, buf, count);
> +	if (wcount < count)
> +		goto out_free;

copy_from_user usage usually looks like:
if (copy_from_user()) {
	ret = -EFAULT;
	goto err;
}
you don't seem to use copy_from_user return value for anything useful

> +
> +	i = sscanf(buffer, "%s %s %s", element, vmc, vmm);

what if user pass strings longer than size of buffers?

> +
> +	if (i < 3)
> +		goto out_free;
> +
> +	for (i = 0; i <= strlen(element); i++)
> +		element[i] = tolower(element[i]);

it's harmless, but should be "i < strlen"

> +
> +	if (!strncmp(vmc, "unlimited", 9))
> +		new_rlim.rlim_cur = RLIM_INFINITY;
> +	else
> +		new_rlim.rlim_cur = simple_strtoull(vmc, NULL, 10);
> +
> +	if (!strncmp(vmm, "unlimited", 9))
> +		new_rlim.rlim_max = RLIM_INFINITY;
> +	else
> +		new_rlim.rlim_max = simple_strtoull(vmm, NULL, 10);
> +
> +	for (i = 0; i < RLIM_NLIMITS; i++) {
> +		if ((lnames[i].match) &&
> +		    !strncmp(element, lnames[i].match,
> +		     strlen(lnames[i].match))) {
> +			index = i;
> +			break;
> +		}
>  	}
>  
> +	if (!lock_task_sighand(task, &flags))
> +		goto out_free;
> +
> +	if ((index >= 0) && (index < RLIM_NLIMITS))
> +		do_setrlimit(index, &new_rlim, task);
> +
> +	unlock_task_sighand(task, &flags);
> +
> +out_free:
> +	kfree(element);
> +	kfree(vmc);
> +	kfree(vmm);
> +	kfree(buffer);
> +out:
> +	*ppos += count;
> +	put_task_struct(task);
>  	return count;
>  }
>  
> (...)
