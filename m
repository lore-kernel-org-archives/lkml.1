Return-Path: <linux-kernel-owner+w=401wt.eu-S932101AbZEEAhv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932101AbZEEAhv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 20:37:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755934AbZEEAhm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 20:37:42 -0400
Received: from smtp-out.google.com ([216.239.45.13]:37770 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755852AbZEEAhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 20:37:41 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=l9J2FbgNZeW6iW+z4AhaOy66qqrsQCrhSmeVTq9x6Bjxblo3+a3oclGvjhzCOucX4
	mJUcjxUgvE0MBDS7Fd7bQ==
Date: Mon, 4 May 2009 17:37:34 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       linux-pm@lists.linux-foundation.org, pavel@ucw.cz,
       torvalds@linux-foundation.org, jens.axboe@oracle.com,
       alan-jenkins@tuffmail.co.uk, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org
Subject: Re: [PATCH 1/5] mm: Add __GFP_NO_OOM_KILL flag
In-Reply-To: <200905050023.38064.rjw@sisk.pl>
Message-ID: <alpine.DEB.2.00.0905041735590.24101@chino.kir.corp.google.com>
References: <nY3-4PrO6XH.A.xtB.yw85JB@chimera> <200905042151.07953.rjw@sisk.pl> <alpine.DEB.2.00.0905041253380.23036@chino.kir.corp.google.com> <200905050023.38064.rjw@sisk.pl>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 May 2009, Rafael J. Wysocki wrote:

> Index: linux-2.6/kernel/power/process.c
> ===================================================================
> --- linux-2.6.orig/kernel/power/process.c
> +++ linux-2.6/kernel/power/process.c
> @@ -19,6 +19,8 @@
>   */
>  #define TIMEOUT	(20 * HZ)
>  
> +static bool tasks_frozen;
> +
>  static inline int freezeable(struct task_struct * p)
>  {
>  	if ((p == current) ||
> @@ -120,6 +122,10 @@ int freeze_processes(void)
>   Exit:
>  	BUG_ON(in_atomic());
>  	printk("\n");
> +
> +	if (!error)
> +		tasks_frozen = true;
> +
>  	return error;
>  }
>  
> @@ -145,6 +151,8 @@ static void thaw_tasks(bool nosig_only)
>  
>  void thaw_processes(void)
>  {
> +	tasks_frozen = false;
> +
>  	printk("Restarting tasks ... ");
>  	thaw_tasks(true);
>  	thaw_tasks(false);
> @@ -152,3 +160,7 @@ void thaw_processes(void)
>  	printk("done.\n");
>  }
>  
> +bool processes_are_frozen(void)
> +{
> +	return tasks_frozen;
> +}
> Index: linux-2.6/include/linux/freezer.h
> ===================================================================
> --- linux-2.6.orig/include/linux/freezer.h
> +++ linux-2.6/include/linux/freezer.h
> @@ -50,6 +50,7 @@ extern int thaw_process(struct task_stru
>  extern void refrigerator(void);
>  extern int freeze_processes(void);
>  extern void thaw_processes(void);
> +extern bool processes_are_frozen(void);
>  
>  static inline int try_to_freeze(void)
>  {
> @@ -170,6 +171,7 @@ static inline int thaw_process(struct ta
>  static inline void refrigerator(void) {}
>  static inline int freeze_processes(void) { BUG(); return 0; }
>  static inline void thaw_processes(void) {}
> +static inline bool processes_are_frozen(void) { return false; }
>  
>  static inline int try_to_freeze(void) { return 0; }
>  
> Index: linux-2.6/mm/page_alloc.c
> ===================================================================
> --- linux-2.6.orig/mm/page_alloc.c
> +++ linux-2.6/mm/page_alloc.c
> @@ -46,6 +46,7 @@
>  #include <linux/page-isolation.h>
>  #include <linux/page_cgroup.h>
>  #include <linux/debugobjects.h>
> +#include <linux/freezer.h>
>  
>  #include <asm/tlbflush.h>
>  #include <asm/div64.h>
> @@ -1599,7 +1600,8 @@ nofail_alloc:
>  					zonelist, high_zoneidx, alloc_flags);
>  		if (page)
>  			goto got_pg;
> -	} else if ((gfp_mask & __GFP_FS) && !(gfp_mask & __GFP_NORETRY)) {
> +	} else if ((gfp_mask & __GFP_FS) && !(gfp_mask & __GFP_NORETRY)
> +			&& !processes_are_frozen()) {
>  		if (!try_set_zone_oom(zonelist, gfp_mask)) {
>  			schedule_timeout_uninterruptible(1);
>  			goto restart;

Cool, that looks like the semantics of __GFP_NO_OOM_KILL without requiring 
a new gfp flag.  Thanks.
