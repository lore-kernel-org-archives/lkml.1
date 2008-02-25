Return-Path: <linux-kernel-owner+w=401wt.eu-S1758826AbYBYWDC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758826AbYBYWDC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 17:03:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750838AbYBYWCv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 17:02:51 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:39635 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753587AbYBYWCt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 17:02:49 -0500
Date: Mon, 25 Feb 2008 23:03:13 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Gregory Haskins <ghaskins@novell.com>
Cc: mingo@elte.hu, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       rostedt@goodmis.org, linux-rt-users@vger.kernel.org,
       linux-kernel@vger.kernel.org, bill.huey@gmail.com, kevin@hilman.org,
       cminyard@mvista.com, dsingleton@mvista.com, dwalker@mvista.com,
       npiggin@suse.de, dsaxena@plexity.net, ak@suse.de, acme@redhat.com,
       gregkh@suse.de, sdietrich@novell.com, pmorreale@novell.com,
       mkohari@novell.com
Subject: Re: [(RT RFC) PATCH v2 5/9] adaptive real-time lock support
Message-ID: <20080225220313.GG2659@elf.ucw.cz>
References: <20080225155959.11268.35541.stgit@novell1.haskins.net> <20080225160103.11268.25579.stgit@novell1.haskins.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080225160103.11268.25579.stgit@novell1.haskins.net>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> +/*
> + * Adaptive-rtlocks will busywait when possible, and sleep only if
> + * necessary. Note that the busyloop looks racy, and it is....but we do
> + * not care. If we lose any races it simply means that we spin one more
> + * time before seeing that we need to break-out on the next iteration.
> + *
> + * We realize this is a relatively large function to inline, but note that
> + * it is only instantiated 1 or 2 times max, and it makes a measurable
> + * performance different to avoid the call.
> + *
> + * Returns 1 if we should sleep
> + *
> + */
> +static inline int
> +adaptive_wait(struct rt_mutex *lock, struct rt_mutex_waiter *waiter,
> +	      struct adaptive_waiter *adaptive)
> +{
> +	int sleep = 0;
> +
> +	for (;;) {
> +		/*
> +		 * If the task was re-awoken, break out completely so we can
> +		 * reloop through the lock-acquisition code.
> +		 */
> +		if (!waiter->task)
> +			break;
> +
> +		/*
> +		 * We need to break if the owner changed so we can reloop
> +		 * and safely acquire the owner-pointer again with the
> +		 * wait_lock held.
> +		 */
> +		if (adaptive->owner != rt_mutex_owner(lock))
> +			break;
> +
> +		/*
> +		 * If we got here, presumably the lock ownership is still
> +		 * current.  We will use it to our advantage to be able to
> +		 * spin without disabling preemption...
> +		 */
> +
> +		/*
> +		 * .. sleep if the owner is not running..
> +		 */
> +		if (!adaptive->owner->se.on_rq) {
> +			sleep = 1;
> +			break;
> +		}
> +
> +		/*
> +		 * .. or is running on our own cpu (to prevent deadlock)
> +		 */
> +		if (task_cpu(adaptive->owner) == task_cpu(current)) {
> +			sleep = 1;
> +			break;
> +		}
> +
> +		cpu_relax();
> +	}
> +
> +	put_task_struct(adaptive->owner);
> +
> +	return sleep;
> +}
> +

You want to inline this?

> +static inline void
> +prepare_adaptive_wait(struct rt_mutex *lock, struct adaptive_waiter *adaptive)
...
> +#define prepare_adaptive_wait(lock, busy) {}

This is evil. Use empty inline function instead (same for the other
function, there you can maybe get away with it).
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
