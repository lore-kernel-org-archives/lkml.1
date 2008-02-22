Return-Path: <linux-kernel-owner+w=401wt.eu-S932152AbYBVTXf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932152AbYBVTXf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 14:23:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765878AbYBVTV2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 14:21:28 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2993 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1765733AbYBVTV0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 14:21:26 -0500
Date: Fri, 22 Feb 2008 20:14:20 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Gregory Haskins <ghaskins@novell.com>
Cc: mingo@elte.hu, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       rostedt@goodmis.org, linux-rt-users@vger.kernel.org,
       linux-kernel@vger.kernel.org, bill.huey@gmail.com, kevin@hilman.org,
       cminyard@mvista.com, dsingleton@mvista.com, dwalker@mvista.com,
       npiggin@suse.de, dsaxena@plexity.net, ak@suse.de, gregkh@suse.de,
       sdietrich@novell.com, pmorreale@novell.com, mkohari@novell.com
Subject: Re: [PATCH [RT] 07/14] adaptive real-time lock support
Message-ID: <20080222191419.GD6060@ucw.cz>
References: <20080221152504.4804.8724.stgit@novell1.haskins.net> <20080221152701.4804.80776.stgit@novell1.haskins.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080221152701.4804.80776.stgit@novell1.haskins.net>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> @@ -192,6 +192,26 @@ config RCU_TRACE
>  	  Say Y/M here if you want to enable RCU tracing in-kernel/module.
>  	  Say N if you are unsure.
>  
> +config ADAPTIVE_RTLOCK
> +        bool "Adaptive real-time locks"
> +	default y

tabs vs. spaces.

> +	 If unsure, say Y

Missing dot?

> @@ -7,6 +7,7 @@
>   *  Copyright (C) 2005-2006 Timesys Corp., Thomas Gleixner <tglx@timesys.com>
>   *  Copyright (C) 2005 Kihon Technologies Inc., Steven Rostedt
>   *  Copyright (C) 2006 Esben Nielsen
> + *  Copyright (C) 2008 Novell, Inc.

It would be nice to list some names, too.

> --- /dev/null
> +++ b/kernel/rtmutex_adaptive.h
> @@ -0,0 +1,134 @@
> +/*
> + * Adaptive RT lock support
> + *
> + * There are pros and cons when deciding between the two basic forms of
> + * locking primitives (spinning vs sleeping).  Without going into great
> + * detail on either one, we note that spinlocks have the advantage of
> + * lower overhead for short hold locks.  However, they also have a
> + * con in that they create indeterminate latencies since preemption
> + * must traditionally be disabled while the lock is held (to prevent deadlock).
> + *
> + * We want to avoid non-deterministic critical sections in -rt. Therefore,
> + * when realtime is enabled, most contexts are converted to threads, and
> + * likewise most spinlock_ts are converted to sleepable rt-mutex derived
> + * locks.  This allows the holder of the lock to remain fully preemptible,
> + * thus reducing a major source of latencies in the kernel.
> + *
> + * However, converting what was once a true spinlock into a sleeping lock
> + * may also decrease performance since the locks will now sleep under
> + * contention.  Since the fundamental lock used to be a spinlock, it is
> + * highly likely that it was used in a short-hold path and that release
> + * is imminent.  Therefore sleeping only serves to cause context-thrashing.
> + *
> + * Adaptive RT locks use a hybrid approach to solve the problem.  They
> + * spin when possible, and sleep when necessary (to avoid deadlock, etc).
> + * This significantly improves many areas of the performance of the -rt
> + * kernel.
> + *
> + * Copyright (C) 2008 Novell, Inc.,
> + *          Sven Dietrich, Peter Morreale, and Gregory Haskins

GPL?

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

Kerneldoc?

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
