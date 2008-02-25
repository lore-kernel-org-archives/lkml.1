Return-Path: <linux-kernel-owner+w=401wt.eu-S1760447AbYBYWJh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760447AbYBYWJh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 17:09:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756118AbYBYWJ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 17:09:27 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:41958 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753020AbYBYWJ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 17:09:26 -0500
Date: Mon, 25 Feb 2008 23:09:50 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Gregory Haskins <ghaskins@novell.com>
Cc: mingo@elte.hu, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       rostedt@goodmis.org, linux-rt-users@vger.kernel.org,
       linux-kernel@vger.kernel.org, bill.huey@gmail.com, kevin@hilman.org,
       cminyard@mvista.com, dsingleton@mvista.com, dwalker@mvista.com,
       npiggin@suse.de, dsaxena@plexity.net, ak@suse.de, acme@redhat.com,
       gregkh@suse.de, sdietrich@novell.com, pmorreale@novell.com,
       mkohari@novell.com
Subject: Re: [(RT RFC) PATCH v2 7/9] adaptive mutexes
Message-ID: <20080225220950.GI2659@elf.ucw.cz>
References: <20080225155959.11268.35541.stgit@novell1.haskins.net> <20080225160113.11268.538.stgit@novell1.haskins.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080225160113.11268.538.stgit@novell1.haskins.net>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> From: Peter W.Morreale <pmorreale@novell.com>
> 
> This patch adds the adaptive spin lock busywait to rtmutexes.  It adds
> a new tunable: rtmutex_timeout, which is the companion to the
> rtlock_timeout tunable.
> 
> Signed-off-by: Peter W. Morreale <pmorreale@novell.com>

Not signed off by you?

> diff --git a/kernel/Kconfig.preempt b/kernel/Kconfig.preempt
> index ac1cbad..864bf14 100644
> --- a/kernel/Kconfig.preempt
> +++ b/kernel/Kconfig.preempt
> @@ -214,6 +214,43 @@ config RTLOCK_DELAY
>  	 tunable at runtime via a sysctl.  A setting of 0 (zero) disables
>  	 the adaptive algorithm entirely.
>  
> +config ADAPTIVE_RTMUTEX
> +        bool "Adaptive real-time mutexes"
> +        default y
> +        depends on ADAPTIVE_RTLOCK
> +        help
> +         This option adds the adaptive rtlock spin/sleep algorithm to
> +         rtmutexes.  In rtlocks, a significant gain in throughput
> +         can be seen by allowing rtlocks to spin for a distinct
> +         amount of time prior to going to sleep for deadlock avoidence.
> + 
> +         Typically, mutexes are used when a critical section may need to
> +         sleep due to a blocking operation.  In the event the critical 
> +	 section does not need to sleep, an additional gain in throughput 
> +	 can be seen by avoiding the extra overhead of sleeping.

Watch the whitespace. ... and do we need yet another config options?

> +config RTMUTEX_DELAY
> +        int "Default delay (in loops) for adaptive mutexes"
> +        range 0 10000000
> +        depends on ADAPTIVE_RTMUTEX
> +        default "3000"
> +        help
> +         This allows you to specify the maximum delay a task will use
> +	 to wait for a rt mutex before going to sleep.  Note that that
> +	 although the delay is implemented as a preemptable loop, tasks
> +	 of like priority cannot preempt each other and this setting can
> +	 result in increased latencies.
> +	 
> +         The value is tunable at runtime via a sysctl.  A setting of 0
> +	 (zero) disables the adaptive algorithm entirely.

Ouch.

> +#ifdef CONFIG_ADAPTIVE_RTMUTEX
> +
> +#define mutex_adaptive_wait         adaptive_wait
> +#define mutex_prepare_adaptive_wait prepare_adaptive_wait
> +
> +extern int rtmutex_timeout;
> +
> +#define DECLARE_ADAPTIVE_MUTEX_WAITER(name) \
> +     struct adaptive_waiter name = { .owner = NULL,               \
> +                                     .timeout = rtmutex_timeout, }
> +
> +#else
> +
> +#define DECLARE_ADAPTIVE_MUTEX_WAITER(name)
> +
> +#define mutex_adaptive_wait(lock, intr, waiter, busy) 1
> +#define mutex_prepare_adaptive_wait(lock, busy) {}

More evil macros. Macro does not behave like a function, make it
inline function if you are replacing a function.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
