Return-Path: <linux-kernel-owner+w=401wt.eu-S1753554AbZHGGEB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554AbZHGGEB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 02:04:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752764AbZHGGEA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 02:04:00 -0400
Received: from mail-ew0-f214.google.com ([209.85.219.214]:39819 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752740AbZHGGEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 02:04:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=WBszdF2mZUflPSjH27fwapD3rtTPesfuBpc3w65H9zZ+KNGXp2lvMIAyCW/zPOYLVR
         g9OhmRR4kJ9ry0rDMZc0OaH5S+NCcvQa/h95xpsAU6KER7di4IG3I4t2IEaOLpbu3uUA
         ulkkBvxZFnBzcjo2NfOaEX7psFANL7UdKB1N0=
Date: Fri, 7 Aug 2009 08:03:56 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Mark Gross <mgross@linux.intel.com>
Subject: Re: [PATCH 2/2] pm_qos: clean up racy "name" variable
Message-ID: <20090807060355.GC9182@nowhere>
References: <20090806135841.46682114@bike.lwn.net> <20090806200509.2320a3fd@bike.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090806200509.2320a3fd@bike.lwn.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 06, 2009 at 08:05:09PM -0600, Jonathan Corbet wrote:
> "name" is an awful name for a file-global variable.  It was used in
> three different functions, with no mutual exclusion.  But it's just a
> tiny, temporary string; let's just move it onto the stack in the
> functions that need it.  Also use snprintf() just in case.
> 
> Signed-off-by: Jonathan Corbet <corbet@lwn.net>
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


Oh, and nothing was protecting this string between open/write/release...
So, double effect, bkl killing, and race condition fixed!

Reviewed-by: Frederic Weisbecker <fweisbec@gmail.com> (if that matters, I
don't know much this file...)

