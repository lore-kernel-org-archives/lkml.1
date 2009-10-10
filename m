Return-Path: <linux-kernel-owner+w=401wt.eu-S934828AbZJJTzZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934828AbZJJTzZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 15:55:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934806AbZJJTzX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 15:55:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53562 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934801AbZJJTzW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 15:55:22 -0400
Date: Sat, 10 Oct 2009 21:54:22 +0200 (CEST)
From: John Kacur <jkacur@redhat.com>
X-X-Sender: jkacur@localhost.localdomain
To: Thomas Gleixner <tglx@linutronix.de>
cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Vincent Sanders <vince@simtec.co.uk>, Jonathan Corbet <corbet@lwn.net>,
       Christoph Hellwig <hch@infradead.org>,
       Mark Gross <mgross@linux.intel.com>
Subject: Re: [patch 02/28] pm_qos: clean up racy global "name" variable
In-Reply-To: <20091010153349.113570550@linutronix.de>
Message-ID: <alpine.LFD.2.00.0910102147020.3669@localhost.localdomain>
References: <20091010153314.827301943@linutronix.de> <20091010153349.113570550@linutronix.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 10 Oct 2009, Thomas Gleixner wrote:

> "name" is a poor name for a file-global variable.  It was used in three
> different functions, with no mutual exclusion.  But it's just a tiny,
> temporary string; let's just move it onto the stack in the functions that
> need it.  Also use snprintf() just in case.
> 
> Signed-off-by: Jonathan Corbet <corbet@lwn.net>
> Cc: Mark Gross <mgross@linux.intel.com>
> Reviewed-by: Frederic Weisbecker <fweisbec@gmail.com>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> 
> diff --git a/kernel/pm_qos_params.c b/kernel/pm_qos_params.c
> index d96b83e..3db49b9 100644
> --- a/kernel/pm_qos_params.c
> +++ b/kernel/pm_qos_params.c
> @@ -343,18 +343,18 @@ int pm_qos_remove_notifier(int pm_qos_class, struct notifier_block *notifier)
>  }
>  EXPORT_SYMBOL_GPL(pm_qos_remove_notifier);
>  
> -#define PID_NAME_LEN sizeof("process_1234567890")
> -static char name[PID_NAME_LEN];
> +#define PID_NAME_LEN 32

Hmnn, why 32? Seems arbitrary. At least you see with "process_1234567890" 
which is 19, an attempt to show what the maximum string size would be. If 
a system were configured to enlarge the maximum PID from 32767 to 4194303 
that would still only be 7 digits, so "process_1234567" - which is 16 
digits with the newline would enough.

So, I suggest you change that to
#define PID_NAME_LEN sizeof("process_1234567")

Other than that, Reviewed-by: John Kacur <jkacur@redhat.com>

>  
>  static int pm_qos_power_open(struct inode *inode, struct file *filp)
>  {
>  	int ret;
>  	long pm_qos_class;
> +	char name[PID_NAME_LEN];
>  
>  	pm_qos_class = find_pm_qos_object_by_minor(iminor(inode));
>  	if (pm_qos_class >= 0) {
>  		filp->private_data = (void *)pm_qos_class;
> -		sprintf(name, "process_%d", current->pid);
> +		snprintf(name, PID_NAME_LEN, "process_%d", current->pid);
>  		ret = pm_qos_add_requirement(pm_qos_class, name,
>  					PM_QOS_DEFAULT_VALUE);
>  		if (ret >= 0)
> @@ -366,9 +366,10 @@ static int pm_qos_power_open(struct inode *inode, struct file *filp)
>  static int pm_qos_power_release(struct inode *inode, struct file *filp)
>  {
>  	int pm_qos_class;
> +	char name[PID_NAME_LEN];
>  
>  	pm_qos_class = (long)filp->private_data;
> -	sprintf(name, "process_%d", current->pid);
> +	snprintf(name, PID_NAME_LEN, "process_%d", current->pid);
>  	pm_qos_remove_requirement(pm_qos_class, name);
>  
>  	return 0;
> @@ -379,13 +380,14 @@ static ssize_t pm_qos_power_write(struct file *filp, const char __user *buf,
>  {
>  	s32 value;
>  	int pm_qos_class;
> +	char name[PID_NAME_LEN];
>  
>  	pm_qos_class = (long)filp->private_data;
>  	if (count != sizeof(s32))
>  		return -EINVAL;
>  	if (copy_from_user(&value, buf, sizeof(s32)))
>  		return -EFAULT;
> -	sprintf(name, "process_%d", current->pid);
> +	snprintf(name, PID_NAME_LEN, "process_%d", current->pid);
>  	pm_qos_update_requirement(pm_qos_class, name, value);
>  
>  	return  sizeof(s32);
> 
> 
> 
