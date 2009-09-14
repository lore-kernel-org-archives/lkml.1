Return-Path: <linux-kernel-owner+w=401wt.eu-S1753000AbZINPUM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753000AbZINPUM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 11:20:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751276AbZINPUL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 11:20:11 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40114 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750854AbZINPUK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 11:20:10 -0400
Date: Mon, 14 Sep 2009 17:19:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, John Stultz <johnstul@us.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Con Kolivas <kernel@kolivas.org>, linux-kernel@vger.kernel.org
Subject: Re: [crash, bisected] Re: clocksource: Resolve cpu hotplug dead
	lock with TSC unstable
Message-ID: <20090914151958.GA17791@elte.hu>
References: <20090909122006.GA18599@kernel.dk> <1252565738.7205.29.camel@laptop> <20090910065856.GL18599@kernel.dk> <20090910073317.GP18599@kernel.dk> <20090910074902.GA10634@elte.hu> <20090910075357.GT18599@kernel.dk> <20090910100214.GB21314@elte.hu> <20090910180049.GA10579@elte.hu> <20090911073747.GA8209@elte.hu> <20090911153305.3fe9a361@skybase>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090911153305.3fe9a361@skybase>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Martin Schwidefsky <schwidefsky@de.ibm.com> wrote:

> On Fri, 11 Sep 2009 09:37:47 +0200
> Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > * Ingo Molnar <mingo@elte.hu> wrote:
> > 
> > > 
> > > * Ingo Molnar <mingo@elte.hu> wrote:
> > > 
> > > > 
> > > > * Jens Axboe <jens.axboe@oracle.com> wrote:
> > > > 
> > > > > I went to try -tip btw, but it crashes on boot. Here's the 
> > > > > backtrace, typed manually, it's crashing in 
> > > > > queue_work_on+0x28/0x60.
> > > > > 
> > > > > Call Trace:
> > > > >         queue_work
> > > > >         schedule_work
> > > > >         clocksource_mark_unstable
> > > > >         mark_tsc_unstable
> > > > >         check_tsc_sync_source
> > > > >         native_cpu_up
> > > > >         relay_hotcpu_callback
> > > > >         do_forK_idle
> > > > >         _cpu_up
> > > > >         cpu_up
> > > > >         kernel_init
> > > > >         kernel_thread_helper
> > > > 
> > > > hm, that looks like an old bug i fixed days ago via:
> > > > 
> > > >   00a3273: Revert "x86: Make tsc=reliable override boot time stability checks"
> > > > 
> > > > Have you tested tip:master - do you still know which sha1?
> > > 
> > > Ok, i reproduced it on a testbox and bisected it, the crash is 
> > > caused by:
> > > 
> > >  7285dd7fd375763bfb8ab1ac9cf3f1206f503c16 is first bad commit
> > >  commit 7285dd7fd375763bfb8ab1ac9cf3f1206f503c16
> > >  Author: Thomas Gleixner <tglx@linutronix.de>
> > >  Date:   Fri Aug 28 20:25:24 2009 +0200
> > > 
> > >     clocksource: Resolve cpu hotplug dead lock with TSC unstable
> > >     
> > >     Martin Schwidefsky analyzed it:
> > > 
> > > I've reverted it in tip/master for now.
> > 
> > and that uncovers the circular locking bug that this commit was 
> > supposed to fix ...
> > 
> > Martin?
> 
> This patch should fix the obvious problem that the watchdog_work
> structure is not yet initialized if the clocksource watchdog is not
> running yet.
> --
> Subject: [PATCH] clocksource: statically initialize watchdog workqueue
> 
> From: Martin Schwidefsky <schwidefsky@de.ibm.com>
> 
> The watchdog timer is started after the watchdog clocksource and at least
> one watched clocksource have been registered. The clocksource work element
> watchdog_work is initialized just before the clocksource timer is started.
> This is too late for the clocksource_mark_unstable call from native_cpu_up.
> To fix this use a static initializer for watchdog_work.
> 
> Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
> ---
>  kernel/time/clocksource.c |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6/kernel/time/clocksource.c
> ===================================================================
> --- linux-2.6.orig/kernel/time/clocksource.c
> +++ linux-2.6/kernel/time/clocksource.c
> @@ -123,10 +123,12 @@ static DEFINE_MUTEX(clocksource_mutex);
>  static char override_name[32];
>  
>  #ifdef CONFIG_CLOCKSOURCE_WATCHDOG
> +static void clocksource_watchdog_work(struct work_struct *work);
> +
>  static LIST_HEAD(watchdog_list);
>  static struct clocksource *watchdog;
>  static struct timer_list watchdog_timer;
> -static struct work_struct watchdog_work;
> +static DECLARE_WORK(watchdog_work, clocksource_watchdog_work);
>  static DEFINE_SPINLOCK(watchdog_lock);
>  static cycle_t watchdog_last;
>  static int watchdog_running;
> @@ -230,7 +232,6 @@ static inline void clocksource_start_wat
>  {
>  	if (watchdog_running || !watchdog || list_empty(&watchdog_list))
>  		return;
> -	INIT_WORK(&watchdog_work, clocksource_watchdog_work);
>  	init_timer(&watchdog_timer);
>  	watchdog_timer.function = clocksource_watchdog;
>  	watchdog_last = watchdog->read(watchdog);

Now another box crashes during bootup. Reverting these two:

 f79e025: clocksource: Resolve cpu hotplug dead lock with TSC unstable, fix crash
 7285dd7: clocksource: Resolve cpu hotplug dead lock with TSC unstable

allows me to boot it.

plain 32-bit defconfig.

	Ingo
