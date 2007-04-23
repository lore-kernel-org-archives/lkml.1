Return-Path: <linux-kernel-owner+w=401wt.eu-S1161526AbXDWMiI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161526AbXDWMiI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 08:38:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161527AbXDWMiI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 08:38:08 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:33070 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161526AbXDWMiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 08:38:06 -0400
Date: Mon, 23 Apr 2007 18:05:58 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Oleg Nesterov <oleg@tv-sign.ru>, linux-kernel@vger.kernel.org,
       vatsa@in.ibm.com, paulmck@us.ibm.com, pavel@ucw.cz
Subject: Re: [RFC][PATCH -mm 3/3] freezer: Fix problem with kthread_stop
Message-ID: <20070423123558.GC25144@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20070419120131.GB13435@in.ibm.com> <20070420183118.GA695@elte.hu> <200704222128.49419.rjw@sisk.pl> <200704222141.00680.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704222141.00680.rjw@sisk.pl>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 22, 2007 at 09:40:59PM +0200, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Fix the problem with kthread_stop() that causes the freezer to fail if a
> freezable thread is attempting to stop a frozen one and that may cause the
> freezer to fail if the thread being stopped is freezable and
> try_to_freeze_tasks() is running concurrently with kthread_stop().
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
>  kernel/kthread.c |    9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> Index: linux-2.6.21-rc6-mm1/kernel/kthread.c
> ===================================================================
> --- linux-2.6.21-rc6-mm1.orig/kernel/kthread.c	2007-04-09 15:23:48.000000000 +0200
> +++ linux-2.6.21-rc6-mm1/kernel/kthread.c	2007-04-22 19:05:29.000000000 +0200
> @@ -13,6 +13,7 @@
>  #include <linux/file.h>
>  #include <linux/module.h>
>  #include <linux/mutex.h>
> +#include <linux/freezer.h>
>  #include <asm/semaphore.h>
> 
>  /*
> @@ -232,6 +233,14 @@ int kthread_stop(struct task_struct *k)
> 
>  	/* Now set kthread_should_stop() to true, and wake it up. */
>  	kthread_stop_info.k = k;
> +	if (!freezer_should_exempt(current)) {
> +		/* We are freezable, so we must make sure that the thread being
> +		 * stopped is not frozen and will not be frozen until it dies
> +		 */
> +		freezer_exempt(k);
> +		if (frozen(k))
> +			clear_frozen_flag(k);
> +	}

I'm trying hard to convince myself that this will work. May be I am
missing something here, but I find a potential race window (very small though) 
when k is entering the refrigerator.

Here's how.

kthread_stop(k)					k->refrigerator()
---------------------------------------------------------------------
						task_lock(k);
						1) check_if_exempted();
						/* not exempted. So 
						 * we will freeze
						 * ourself.
						 */
2) freezer_exempt(k);

3) if(frozen(k))
/* No, we're not yet frozen. So we
 * don't clear_frozen_flag(k) here
 */
						4) frozen_process(k);
						   task_unlock(k);
						
						5) for(;;) {
						 set_current_state(UNINTERRUPTIBLE);
						  if(!frozen_process(k))
						  /* k is frozen. We
						   * don't break :( 
						   */
						 
						  	schedule();
						}
						
>  	wake_up_process(k);
>  	put_task_struct(k);
> 

Thus the freezer can still fail, no?
IMO, we need the to take the task_lock for k here. Something like

> +	if (!freezer_should_exempt(current)) {
		task_lock(k);
> +		/* We are freezable, so we must make sure that the thread being
> +		 * stopped is not frozen and will not be frozen until it dies
> +		 */
> +		freezer_exempt(k);
> +		if (frozen(k))
> +			clear_frozen_flag(k);
		task_unlock(k);
> +	}


Thanks and Regards
gautham.
-- 
Gautham R Shenoy
Linux Technology Center
IBM India.
"Freedom comes with a price tag of responsibility, which is still a bargain,
because Freedom is priceless!"
