Return-Path: <linux-kernel-owner+w=401wt.eu-S1762039AbYAUP21@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762039AbYAUP21 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 10:28:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760568AbYAUPYl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 10:24:41 -0500
Received: from ms-smtp-01.nyroc.rr.com ([24.24.2.55]:56804 "EHLO
	ms-smtp-01.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756339AbYAUPYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 10:24:03 -0500
Message-Id: <20080121152352.162073722@goodmis.org>
References: <20080121152231.579118762@goodmis.org>
User-Agent: quilt/0.46-1
Date: Mon, 21 Jan 2008 10:22:39 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>, Tim Bird <tim.bird@am.sony.com>,
       Sam Ravnborg <sam@ravnborg.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       Jan Kiszka <jan.kiszka@siemens.com>, John Stultz <johnstul@us.ibm.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [RFC PATCH 08/23 -v4] Fixup merge between xtime_cache and timkkeeping starvation fix
Content-Disposition: inline; filename=fixup-merge-between-xtime-cache-and-starvation.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  void update_wall_time(void)
>  {
> -	cycle_t offset;
> +	cycle_t cycle_now, offset;
> 
>  	/* Make sure we're fully resumed: */
>  	if (unlikely(timekeeping_suspended))
>  		return;
> 
>  #ifdef CONFIG_GENERIC_TIME
> -	offset = (clocksource_read(clock) - clock->cycle_last) & clock->mask;
> +	cycle_now = clocksource_read(clock);
>  #else
> -	offset = clock->cycle_interval;
> +	cycle_now = clock->cycle_last + clock->cycle_interval;
>  #endif
> +	offset = (cycle_now - clock->cycle_last) & clock->mask;

It seems this offset addition was to merge against the colliding
xtime_cache changes in mainline. However, I don't think its quite right,
and might be causing incorrect time() or vtime() results if NO_HZ is
enabled.

> +	clocksource_accumulate(clock, cycle_now);
> +
>  	clock->xtime_nsec += (s64)xtime.tv_nsec << clock->shift;
> 
>  	/* normally this loop will run just once, however in the
>  	 * case of lost or late ticks, it will accumulate correctly.
>  	 */
> -	while (offset >= clock->cycle_interval) {
> +	while (clock->cycle_accumulated >= clock->cycle_interval) {
>  		/* accumulate one interval */
>  		clock->xtime_nsec += clock->xtime_interval;
> -		clock->cycle_last += clock->cycle_interval;
> -		offset -= clock->cycle_interval;
> +		clock->cycle_accumulated -= clock->cycle_interval;
> 
>  		if (clock->xtime_nsec >= (u64)NSEC_PER_SEC << clock->shift) {
>  			clock->xtime_nsec -= (u64)NSEC_PER_SEC << clock->shift;
> @@ -482,7 +485,7 @@ void update_wall_time(void)
>  	}
> 
>  	/* correct the clock when NTP error is too big */
> -	clocksource_adjust(offset);
> +	clocksource_adjust(clock->cycle_accumulated);


I suspect the following is needed, but haven't been able to test it yet.


Fixup merge between xtime_cache and timekeeping starvation fix.

Signed-off-by: John Stultz <johnstul@us.ibm.com>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/time/timekeeping.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

Index: linux-mcount.git/kernel/time/timekeeping.c
===================================================================
--- linux-mcount.git.orig/kernel/time/timekeeping.c	2008-01-17 20:33:37.000000000 -0500
+++ linux-mcount.git/kernel/time/timekeeping.c	2008-01-17 20:33:39.000000000 -0500
@@ -449,7 +449,7 @@ static void clocksource_adjust(s64 offse
  */
 void update_wall_time(void)
 {
-	cycle_t cycle_now, offset;
+	cycle_t cycle_now;
 
 	/* Make sure we're fully resumed: */
 	if (unlikely(timekeeping_suspended))
@@ -460,7 +460,6 @@ void update_wall_time(void)
 #else
 	cycle_now = clock->cycle_last + clock->cycle_interval;
 #endif
-	offset = (cycle_now - clock->cycle_last) & clock->mask;
 	clocksource_accumulate(clock, cycle_now);
 
 	clock->xtime_nsec += (s64)xtime.tv_nsec << clock->shift;
@@ -491,7 +490,7 @@ void update_wall_time(void)
 	xtime.tv_nsec = (s64)clock->xtime_nsec >> clock->shift;
 	clock->xtime_nsec -= (s64)xtime.tv_nsec << clock->shift;
 
-	update_xtime_cache(cyc2ns(clock, offset));
+	update_xtime_cache(cyc2ns(clock, clock->cycle_accumulated));
 
 	/* check to see if there is a new clocksource to use */
 	change_clocksource();

-- 
