Return-Path: <linux-kernel-owner+w=401wt.eu-S1754418AbYBRPAG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754418AbYBRPAG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 10:00:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751957AbYBRO7z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 09:59:55 -0500
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:60645 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938AbYBRO7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 09:59:54 -0500
Date: Mon, 18 Feb 2008 20:29:47 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Dipankar Sarma <dipankar@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] simplify cpu_hotplug_begin()/put_online_cpus()
Message-ID: <20080218145947.GA27127@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20080216172254.GA18521@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080216172254.GA18521@tv-sign.ru>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 16, 2008 at 08:22:54PM +0300, Oleg Nesterov wrote:

This looks neat and clean.

Acked-by: Gautham R Shenoy <ego@in.ibm.com>


> cpu_hotplug_begin() must be always called under cpu_add_remove_lock, this means
> that only one process can be cpu_hotplug.active_writer. So we don't need the
> cpu_hotplug.writer_queue, we can wake up the ->active_writer directly.
> 
> Also, fix the comment.
> 
> Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
> 
> --- 25/kernel/cpu.c~1_CPU_HP_LOCK	2008-02-15 16:59:17.000000000 +0300
> +++ 25/kernel/cpu.c	2008-02-16 18:36:37.000000000 +0300
> @@ -33,17 +33,13 @@ static struct {
>  	 * an ongoing cpu hotplug operation.
>  	 */
>  	int refcount;
> -	wait_queue_head_t writer_queue;
>  } cpu_hotplug;
> 
> -#define writer_exists() (cpu_hotplug.active_writer != NULL)
> -
>  void __init cpu_hotplug_init(void)
>  {
>  	cpu_hotplug.active_writer = NULL;
>  	mutex_init(&cpu_hotplug.lock);
>  	cpu_hotplug.refcount = 0;
> -	init_waitqueue_head(&cpu_hotplug.writer_queue);
>  }
> 
>  #ifdef CONFIG_HOTPLUG_CPU
> @@ -65,11 +61,8 @@ void put_online_cpus(void)
>  	if (cpu_hotplug.active_writer == current)
>  		return;
>  	mutex_lock(&cpu_hotplug.lock);
> -	cpu_hotplug.refcount--;
> -
> -	if (unlikely(writer_exists()) && !cpu_hotplug.refcount)
> -		wake_up(&cpu_hotplug.writer_queue);
> -
> +	if (!--cpu_hotplug.refcount && unlikely(cpu_hotplug.active_writer))
> +		wake_up_process(cpu_hotplug.active_writer);
>  	mutex_unlock(&cpu_hotplug.lock);
> 
>  }
> @@ -98,8 +91,8 @@ void cpu_maps_update_done(void)
>   * Note that during a cpu-hotplug operation, the new readers, if any,
>   * will be blocked by the cpu_hotplug.lock
>   *
> - * Since cpu_maps_update_begin is always called after invoking
> - * cpu_maps_update_begin, we can be sure that only one writer is active.
> + * Since cpu_hotplug_begin() is always called after invoking
> + * cpu_maps_update_begin(), we can be sure that only one writer is active.
>   *
>   * Note that theoretically, there is a possibility of a livelock:
>   * - Refcount goes to zero, last reader wakes up the sleeping
> @@ -115,19 +108,16 @@ void cpu_maps_update_done(void)
>   */
>  static void cpu_hotplug_begin(void)
>  {
> -	DECLARE_WAITQUEUE(wait, current);
> -
> -	mutex_lock(&cpu_hotplug.lock);
> -
>  	cpu_hotplug.active_writer = current;
> -	add_wait_queue_exclusive(&cpu_hotplug.writer_queue, &wait);
> -	while (cpu_hotplug.refcount) {
> -		set_current_state(TASK_UNINTERRUPTIBLE);
> +
> +	for (;;) {
> +		mutex_lock(&cpu_hotplug.lock);
> +		if (likely(!cpu_hotplug.refcount))
> +			break;
> +		__set_current_state(TASK_UNINTERRUPTIBLE);
>  		mutex_unlock(&cpu_hotplug.lock);
>  		schedule();
> -		mutex_lock(&cpu_hotplug.lock);
>  	}
> -	remove_wait_queue_locked(&cpu_hotplug.writer_queue, &wait);
>  }
> 
>  static void cpu_hotplug_done(void)

-- 
Thanks and Regards
gautham
