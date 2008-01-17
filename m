Return-Path: <linux-kernel-owner+w=401wt.eu-S1754183AbYAQOSs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754183AbYAQOSs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 09:18:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750952AbYAQOSi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 09:18:38 -0500
Received: from mail.windriver.com ([147.11.1.11]:48317 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750949AbYAQOSi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 09:18:38 -0500
Message-ID: <478F63A1.3030509@windriver.com>
Date: Thu, 17 Jan 2008 08:18:09 -0600
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Jan Kiszka <jan.kiszka@siemens.com>
CC: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au,
       kgdb-bugreport@lists.sourceforge.net
Subject: Re: [PATCH 16/21] KGDB: This allows for KGDB to better deal with
 autoloaded   modules.
References: <4713B289.20204@windriver.com> <478F5E82.8060300@siemens.com>
In-Reply-To: <478F5E82.8060300@siemens.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Jan 2008 14:18:10.0342 (UTC) FILETIME=[C9B56C60:01C85913]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kiszka wrote:
> These days, notify_mutex should better be a real mutex.
>
> Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
>
> ---
>  kernel/module.c |   14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
>
> Index: b/kernel/module.c
> ===================================================================
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -66,7 +66,7 @@ extern int module_sysfs_initialized;
>   * (add/delete uses stop_machine). */
>  static DEFINE_MUTEX(module_mutex);
>  static LIST_HEAD(modules);
> -static DECLARE_MUTEX(notify_mutex);
> +static DEFINE_MUTEX(notify_mutex);
>  
>  static BLOCKING_NOTIFIER_HEAD(module_notify_list);
>  
> @@ -712,10 +712,10 @@ sys_delete_module(const char __user *nam
>  	if (ret != 0)
>  		goto out;
>  
> -	down(&notify_mutex);
> +	mutex_lock(&notify_mutex);
>  	blocking_notifier_call_chain(&module_notify_list, MODULE_STATE_GOING,
>  								 mod);
> -	up(&notify_mutex);
> +	mutex_unlock(&notify_mutex);
>  
>  
>  	/* Never wait if forced. */
> @@ -730,10 +730,10 @@ sys_delete_module(const char __user *nam
>  	}
>  	free_module(mod);
>  
> -	down(&notify_mutex);
> +	mutex_lock(&notify_mutex);
>  	blocking_notifier_call_chain(&module_notify_list, MODULE_STATE_GONE,
>  			NULL);
> -	up(&notify_mutex);
> +	mutex_unlock(&notify_mutex);
>  
>   out:
>  	mutex_unlock(&module_mutex);
> @@ -2182,11 +2182,11 @@ sys_init_module(void __user *umod,
>  		/* Init routine failed: abort.  Try to protect us from
>                     buggy refcounters. */
>  		mod->state = MODULE_STATE_GOING;
> -		down(&notify_mutex);
> +		mutex_lock(&notify_mutex);
>  		blocking_notifier_call_chain(&module_notify_list,
>  				MODULE_STATE_GOING,
>  				mod);
> -		up(&notify_mutex);
> +		mutex_unlock(&notify_mutex);
>  		synchronize_sched();
>  		module_put(mod);
>  		mutex_lock(&module_mutex);
>   
Jan,

This looks fine.

I committed this to the latest development branch as well as the 2.6.24
branch.  It will show up in the kernel.org & cvs repository later today.

Thanks,
Jason.

