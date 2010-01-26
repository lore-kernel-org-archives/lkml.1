Return-Path: <linux-kernel-owner+w=401wt.eu-S1753405Ab0AZUPu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405Ab0AZUPu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 15:15:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752897Ab0AZUPt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 15:15:49 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36513 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752722Ab0AZUPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 15:15:48 -0500
Date: Tue, 26 Jan 2010 12:14:58 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jason.wessel@windriver.com, johnstul@us.ibm.com, schwidefsky@de.ibm.com,
       tglx@linutronix.de
Cc: tip-bot for Thomas Gleixner <tglx@linutronix.de>,
       linux-tip-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
       hpa@zytor.com, mingo@redhat.com, johnstul@us.ibm.com,
       jason.wessel@windriver.com, schwidefsky@de.ibm.com
Subject: Re: [tip:timers/urgent] clocksource: Prevent potential kgdb dead
 lock
Message-Id: <20100126121458.43055709.akpm@linux-foundation.org>
In-Reply-To: <tip-7b7422a566aa0dc1e582ce263d4c7ff4a772700a@git.kernel.org>
References: <1264480000-6997-4-git-send-email-jason.wessel@windriver.com>
	<tip-7b7422a566aa0dc1e582ce263d4c7ff4a772700a@git.kernel.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Jan 2010 14:09:45 GMT tip-bot for Thomas Gleixner <tglx@linutronix.de> wrote:

> --- a/kernel/time/clocksource.c
> +++ b/kernel/time/clocksource.c
> @@ -343,7 +343,19 @@ static void clocksource_resume_watchdog(void)
>  {
>  	unsigned long flags;
>  
> -	spin_lock_irqsave(&watchdog_lock, flags);
> +	/*
> +	 * We use trylock here to avoid a potential dead lock when
> +	 * kgdb calls this code after the kernel has been stopped with
> +	 * watchdog_lock held. When watchdog_lock is held we just
> +	 * return and accept, that the watchdog might trigger and mark
> +	 * the monitored clock source (usually TSC) unstable.
> +	 *
> +	 * This does not affect the other caller clocksource_resume()
> +	 * because at this point the kernel is UP, interrupts are
> +	 * disabled and nothing can hold watchdog_lock.
> +	 */
> +	if (!spin_trylock_irqsave(&watchdog_lock, flags))
> +		return;
>  	clocksource_reset_watchdog();
>  	spin_unlock_irqrestore(&watchdog_lock, flags);
>  }
>
> @@ -458,8 +470,8 @@ void clocksource_resume(void)
>   * clocksource_touch_watchdog - Update watchdog
>   *
>   * Update the watchdog after exception contexts such as kgdb so as not
> - * to incorrectly trip the watchdog.
> - *
> + * to incorrectly trip the watchdog. This might fail when the kernel
> + * was stopped in code which holds watchdog_lock.
>   */
>  void clocksource_touch_watchdog(void)
>  {

It would be neater and a shade more reliable to add a separate
clocksource_try_touch_watchdog() for kgdb's use.  Which could be inside
#ifdef CONFIG_KGDB.

