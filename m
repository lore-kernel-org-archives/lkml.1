Return-Path: <linux-kernel-owner+w=401wt.eu-S1757943AbZJDUcP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757943AbZJDUcP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 16:32:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757752AbZJDUcP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 16:32:15 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:57097 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754006AbZJDUcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 16:32:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=GsV4O5TnVR65A2QLBfwIKR9QqKJHuO2p9Mf+hmOCul4AyxZmJg2fbSjLZz9V5p31Zj
         8ZiVHqw9T/HFk2fqDvCCWDVjxa5+RhfzIXLJedE6Cw/D29UTJ59HgipcB1hSDcUB0h0n
         T7vH0eZ1AdJLEfedhyc47o/+N5rpwBE5894pE=
Message-ID: <4AC905E0.2070309@gmail.com>
Date: Sun, 04 Oct 2009 22:30:24 +0200
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

Shouldn't proc_pid_limit_write return 0 or some error in this case?
Right now it silently fails...

> +	buffer = kzalloc(128, GFP_KERNEL);
> +
> +	if (!buffer)
> +		goto out;
> +
> +	element = kzalloc(sizeof(buffer), GFP_KERNEL);
> +	vmc = kzalloc(sizeof(buffer), GFP_KERNEL);
> +	vmm = kzalloc(sizeof(buffer), GFP_KERNEL);
> +
> +	if (!element || !vmm || !vmc)
> +		goto out_free;
> +
> +	wcount = count - copy_from_user(buffer, buf, count);
> +	if (wcount < count)
> +		goto out_free;
> +
> +	i = sscanf(buffer, "%s %s %s", element, vmc, vmm);
> +
> +	if (i < 3)
> +		goto out_free;
> +
> +	for (i = 0; i <= strlen(element); i++)
> +		element[i] = tolower(element[i]);
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

Another 2 silent failures:
- when user passed wrong name
- when do_setrlimit failed

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
