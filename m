Return-Path: <linux-kernel-owner+w=401wt.eu-S1752806AbXIHH21@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752806AbXIHH21 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2007 03:28:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751490AbXIHH2T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Sep 2007 03:28:19 -0400
Received: from fk-out-0910.google.com ([209.85.128.189]:16861 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370AbXIHH2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2007 03:28:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=msd5qj+3aBhTTj1CyiXKAAiH5FQrRwFfHggw4Ev4nPxTo/HH92sddT5oklLOWBxaLE5ZXISfFNUPGwYfnRfaEna69Z6Zy0Go08kY0oU4GEY/WVfEtC2d5D80z9nGU9RBN2ZbT2V/V9Q6Pfdw0Zow9ojFhhUxCiZWTU50NMf5LS8=
Date: Sat, 8 Sep 2007 11:28:11 +0400
To: rusty@rustcorp.com.au
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [patch 1/8] Immediate Values - Global Modules List and Module Mutex
Message-ID: <20070908072811.GB1819@martell.zuzino.mipt.ru>
References: <20070906200228.086651361@polymtl.ca> <20070906200314.079453533@polymtl.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070906200314.079453533@polymtl.ca>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Alexey Dobriyan <adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 06, 2007 at 04:02:29PM -0400, Mathieu Desnoyers wrote:
> Remove "static" from module_mutex and the modules list so it can be used by
> other builtin objects in the kernel. Otherwise, every code depending on the
> module list would have to be put in kernel/module.c. Since the immediate values
> depends on the module list but can be considered as logically different, it
> makes sense to implement them in their own file.
> 
> The alternative to this would be to disable preemption in code path that need
> such synchronization, so they can be protected against module unload by
> stop_machine(), but not being able to sleep within while needing such
> synchronization is limiting.

> --- linux-2.6-lttng.orig/kernel/module.c
> +++ linux-2.6-lttng/kernel/module.c
> @@ -64,8 +64,8 @@ extern int module_sysfs_initialized;
>  
>  /* List of modules, protected by module_mutex or preempt_disable
>   * (add/delete uses stop_machine). */
> -static DEFINE_MUTEX(module_mutex);
> -static LIST_HEAD(modules);
> +DEFINE_MUTEX(module_mutex);
> +LIST_HEAD(modules);
>  static DECLARE_MUTEX(notify_mutex);
>  
>  static BLOCKING_NOTIFIER_HEAD(module_notify_list);
> --- linux-2.6-lttng.orig/include/linux/module.h
> +++ linux-2.6-lttng/include/linux/module.h
> @@ -60,6 +60,10 @@ struct module_kobject
>  	struct kobject *drivers_dir;
>  };
>  
> +/* Protects the list of modules. */
> +extern struct mutex module_mutex;
> +extern struct list_head modules;

Rusty, do you still want to keep module_mutex virgin? If not, I can
backout /proc/*/wchan vs rmmod race fix et al and use muuuch simpler version.
