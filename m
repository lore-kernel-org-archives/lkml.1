Return-Path: <linux-kernel-owner+w=401wt.eu-S1758347AbYAOVOY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758347AbYAOVOY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 16:14:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755937AbYAOVON
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 16:14:13 -0500
Received: from tomts40.bellnexxia.net ([209.226.175.97]:62139 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753832AbYAOVOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 16:14:12 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq4HAG6wjEdMROHU/2dsb2JhbACBWKoo
Date: Tue, 15 Jan 2008 16:14:04 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>, Tim Bird <tim.bird@am.sony.com>,
       Sam Ravnborg <sam@ravnborg.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       Jan Kiszka <jan.kiszka@siemens.com>, John Stultz <johnstul@us.ibm.com>
Subject: Re: [RFC PATCH 17/30 v3] initialize the clock source to jiffies
	clock.
Message-ID: <20080115211404.GB17439@Krystal>
References: <20080115204907.838227723@goodmis.org> <20080115205024.650312976@goodmis.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080115205024.650312976@goodmis.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 16:11:09 up 73 days,  2:16,  5 users,  load average: 5.44, 2.49,
	1.29
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> The latency tracer can call clocksource_read very early in bootup and
> before the clock source variable has been initialized. This results in a
> crash at boot up (even before earlyprintk is initialized). Since the
> clock->read variable points to NULL.
> 
> This patch simply initializes the clock to use clocksource_jiffies, so
> that any early user of clocksource_read will not crash.
> 

Hrm, is it sane at all to use the jiffies as a clocksource at early
boot? I thought it was updated by the timer interrupt, which is only
activated late in the boot process.

> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> Acked-by: John Stultz <johnstul@us.ibm.com>
> ---
>  include/linux/clocksource.h |    3 +++
>  kernel/time/timekeeping.c   |    9 +++++++--
>  2 files changed, 10 insertions(+), 2 deletions(-)
> 
> Index: linux-compile.git/include/linux/clocksource.h
> ===================================================================
> --- linux-compile.git.orig/include/linux/clocksource.h	2008-01-14 13:14:14.000000000 -0500
> +++ linux-compile.git/include/linux/clocksource.h	2008-01-14 14:57:46.000000000 -0500
> @@ -274,6 +274,9 @@ extern struct clocksource* clocksource_g
>  extern void clocksource_change_rating(struct clocksource *cs, int rating);
>  extern void clocksource_resume(void);
>  
> +/* used to initialize clock */
> +extern struct clocksource clocksource_jiffies;
> +
>  #ifdef CONFIG_GENERIC_TIME_VSYSCALL
>  extern void update_vsyscall(struct timespec *ts, struct clocksource *c);
>  extern void update_vsyscall_tz(void);
> Index: linux-compile.git/kernel/time/timekeeping.c
> ===================================================================
> --- linux-compile.git.orig/kernel/time/timekeeping.c	2008-01-14 13:14:14.000000000 -0500
> +++ linux-compile.git/kernel/time/timekeeping.c	2008-01-14 14:57:46.000000000 -0500
> @@ -53,8 +53,13 @@ static inline void update_xtime_cache(u6
>  	timespec_add_ns(&xtime_cache, nsec);
>  }
>  
> -static struct clocksource *clock; /* pointer to current clocksource */
> -
> +/*
> + * pointer to current clocksource
> + *  Just in case we use clocksource_read before we initialize
> + *  the actual clock source. Instead of calling a NULL read pointer
> + *  we return jiffies.
> + */
> +static struct clocksource *clock = &clocksource_jiffies;
>  
>  #ifdef CONFIG_GENERIC_TIME
>  /**
> 
> -- 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
