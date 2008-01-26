Return-Path: <linux-kernel-owner+w=401wt.eu-S1755995AbYAZJvw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755995AbYAZJvw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 04:51:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753481AbYAZJvo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 04:51:44 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:45895 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753152AbYAZJvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 04:51:42 -0500
Subject: Re: [PATCH 01/23 -v6] printk - dont wakeup klogd with interrupts
	disabled
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>, Tim Bird <tim.bird@am.sony.com>,
       Sam Ravnborg <sam@ravnborg.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       Jan Kiszka <jan.kiszka@siemens.com>, John Stultz <johnstul@us.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>, Pavel Machek <pavel@ucw.cz>,
       Steven Rostedt <srostedt@redhat.com>
In-Reply-To: <20080126042801.280369398@goodmis.org>
References: <20080126042152.526086719@goodmis.org>
	 <20080126042801.280369398@goodmis.org>
Content-Type: text/plain
Date: Sat, 26 Jan 2008 10:50:17 +0100
Message-Id: <1201341017.27573.17.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-01-25 at 23:21 -0500, Steven Rostedt wrote:

> @@ -1003,7 +1005,11 @@ void release_console_sem(void)
>  	console_locked = 0;
>  	up(&console_sem);
>  	spin_unlock_irqrestore(&logbuf_lock, flags);
> -	if (wake_klogd)
> +	/*
> +	 * If we try to wake up klogd while printing with the runqueue lock
> +	 * held, this will deadlock.
> +	 */
> +	if (wake_klogd && !runqueue_is_locked())
>  		wake_up_klogd();
>  }
>  EXPORT_SYMBOL(release_console_sem);

> +/**
> + * runqueue_is_locked
> + *
> + * Returns true if the current cpu runqueue is locked.
> + * This interface allows printk to be called with the runqueue lock
> + * held and know whether or not it is OK to wake up the klogd.
> + */
> +int runqueue_is_locked(void)
> +{
> +	int cpu = get_cpu();
> +	struct rq *rq = cpu_rq(cpu);
> +	int ret;
> +
> +	ret = spin_is_locked(&rq->lock);
> +	put_cpu();
> +	return ret;
> +}

Right, while this might appear to be sound, I hate to point out that we
only want to exclude it when current holds the rq->lock. This could lead
to spuriously missing klogd wakeups because other cpus hold our
rq->lock.

Now, is this klogd thing only relevant for dumping stuff into the log,
or also for writing stuff out to the serial line?

