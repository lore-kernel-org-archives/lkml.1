Return-Path: <linux-kernel-owner+w=401wt.eu-S1751779AbZHRXaT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751779AbZHRXaT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 19:30:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751261AbZHRXaS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 19:30:18 -0400
Received: from mga09.intel.com ([134.134.136.24]:14119 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751075AbZHRXaR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 19:30:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,404,1246863600"; 
   d="scan'208";a="440418164"
Date: Tue, 18 Aug 2009 16:30:17 -0700
From: mgross <mgross@linux.intel.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 2/2] pm_qos: clean up racy file-global variable
Message-ID: <20090818233016.GC16014@linux.intel.com>
Reply-To: mgross@linux.intel.com
References: <20090813140554.014ce1e0@bike.lwn.net> <20090813140825.0a39d5b6@bike.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090813140825.0a39d5b6@bike.lwn.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 13, 2009 at 02:08:25PM -0600, Jonathan Corbet wrote:
> "name" is a poor name for a file-global variable.  It was used in three
True. 

> different functions, with no mutual exclusion.  But it's just a tiny,
> temporary string; let's just move it onto the stack in the functions that
> need it.  Also use snprintf() just in case.
> 

Signed-off-by: Mark Gross <mgross@intel.com>


> Signed-off-by: Jonathan Corbet <corbet@lwn.net>
> Cc: Mark Gross <mgross@linux.intel.com>
> Reviewed-by: Frederic Weisbecker <fweisbec@gmail.com>
> ---
>  kernel/pm_qos_params.c |   12 +++++++-----
>  1 files changed, 7 insertions(+), 5 deletions(-)
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
> -- 
> 1.6.2.5
