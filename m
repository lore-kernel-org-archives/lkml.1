Return-Path: <linux-kernel-owner+w=401wt.eu-S933833AbXGRQF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933833AbXGRQF0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 12:05:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932869AbXGRQFL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 12:05:11 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45407 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932387AbXGRQFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 12:05:07 -0400
Date: Wed, 18 Jul 2007 09:03:45 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Ian Kent <raven@themaw.net>, Chuck Ebbert <cebbert@redhat.com>,
       Bill Davidsen <davidsen@tmr.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch] CFS scheduler, -v19
In-Reply-To: <20070717074537.GA13539@elte.hu>
Message-ID: <alpine.LFD.0.999.0707180852540.27353@woody.linux-foundation.org>
References: <20070706173319.GA2356@elte.hu> <1184054902.12336.19.camel@Homer.simpson.net>
 <469512C1.6090406@tmr.com> <20070711205556.GA27266@elte.hu> <4697EC49.4070303@tmr.com>
 <469BE462.9030004@redhat.com> <20070716215541.GA27171@elte.hu>
 <1184648474.3188.33.camel@raven.themaw.net>
 <20070717074537.GA13539@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 17 Jul 2007, Ingo Molnar wrote:
> 
> * Ian Kent <raven@themaw.net> wrote:
> > 
> > In several places I have code similar to:
> > 
> > wait.tv_sec = time(NULL) + 1;
> > wait.tv_nsec = 0;

Ok, that definitely should work.

Does the patch below help?

> ah! It passes in a low-res time source into a high-res time interface 
> (pthread_cond_timedwait()). Could you change the time(NULL) + 1 to 
> time(NULL) + 2, or change it to:
> 
> 	gettimeofday(&wait, NULL);
> 	wait.tv_sec++;

This is wrong. It's wrong for two reasons:

 - it really shouldn't be needed. I don't think "time()" has to be 
   *exactly* in sync, but I don't think it can be off by a third of a 
   second or whatever (as the "30% CPU load" would seem to imply)

 - gettimeofday works on a timeval, pthread_cond_timedwait() works on a 
   timespec.

So if it actually makes a difference, it makes a difference for the 
*wrong* reason: the time is still totally nonsensical in the tv_nsec field 
(because it actually got filled in with msecs!), but now the tv_sec field 
is in sync, so it hides the bug.

Anyway, hopefully the patch below might help. But we probably should make 
this whole thing a much more generic routine (ie we have our internal 
"getnstimeofday()" that still is missing the second-overflow logic, and 
that is quite possibly the one that triggers the "30% off" behaviour).

Ingo, I'd suggest:
 - ger rid of "timespec_add_ns()", or at least make it return a return 
   value for when it overflows.
 - make all the people who overflow into tv_sec call a "fix_up_seconds()" 
   thing that does the xtime overflow handling.

		Linus

---
Subject: time: make sure sys_gettimeofday() and sys_time() are in sync
From: Ingo Molnar <mingo@elte.hu>

make sure sys_gettimeofday() and sys_time() results are coherent.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/time/timekeeping.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

Index: linux/kernel/time/timekeeping.c
===================================================================
--- linux.orig/kernel/time/timekeeping.c
+++ linux/kernel/time/timekeeping.c
@@ -92,6 +92,19 @@ static inline void __get_realtime_clock_
 	} while (read_seqretry(&xtime_lock, seq));
 
 	timespec_add_ns(ts, nsecs);
+	/*
+	 * Make sure xtime.tv_sec [returned by sys_time()] always
+	 * follows the gettimeofday() result precisely. This
+	 * condition is extremely unlikely, it can hit at most
+	 * once per second:
+	 */
+	if (unlikely(xtime.tv_sec != ts->tv_sec)) {
+		unsigned long flags;
+
+		write_seqlock_irqsave(&xtime_lock, flags);
+		update_wall_time();
+		write_sequnlock_irqrestore(&xtime_lock, flags);
+	}
 }
 
 /**

