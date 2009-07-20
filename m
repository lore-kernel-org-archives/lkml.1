Return-Path: <linux-kernel-owner+w=401wt.eu-S1752805AbZGTHk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752805AbZGTHk2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 03:40:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752779AbZGTHk2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 03:40:28 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:51775 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273AbZGTHk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 03:40:27 -0400
Date: Mon, 20 Jul 2009 09:39:54 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       john stultz <johnstul@us.ibm.com>
Subject: Re: [RFC][PATCH] reuse ktime in sub-functions of tick_check_idle.
Message-ID: <20090720093954.224c1efe@skybase>
In-Reply-To: <20090718141456.GJ32618@elte.hu>
References: <20090715172851.21d618f3@skybase>
	<20090718141456.GJ32618@elte.hu>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 18 Jul 2009 16:14:56 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Martin Schwidefsky <schwidefsky@de.ibm.com> wrote:
> 
> > 
> > before:
> > 
> >  0)               |  tick_check_idle() {
> >  0)               |    tick_nohz_stop_idle() {
> >  0)               |      ktime_get() {
> >  0)               |        read_tod_clock() {
> >  0)   0.601 us    |        }
> >  0)   1.765 us    |      }
> >  0)   3.047 us    |    }
> >  0)               |    ktime_get() {
> >  0)               |      read_tod_clock() {
> >  0)   0.570 us    |      }
> >  0)   1.727 us    |    }
> >  0)               |    tick_do_update_jiffies64() {
> >  0)   0.609 us    |    }
> >  0)   8.055 us    |  }
> > 
> > after:
> > 
> >  0)               |  tick_check_idle() {
> >  0)               |    ktime_get() {
> >  0)               |      read_tod_clock() {
> >  0)   0.617 us    |      }
> >  0)   1.773 us    |    }
> >  0)               |    tick_do_update_jiffies64() {
> >  0)   0.593 us    |    }
> >  0)   4.477 us    |  }
> 
> Nice!

Yes, isn't it? I currently looking at the cpu wakeup path and try to
make it faster. The biggest one is probably the ktime_get optimization
but this one seems worthwhile as well.

> > @@ -579,22 +574,18 @@ static void tick_nohz_switch_to_nohz(voi
> >   * timer and do not touch the other magic bits which need to be done
> >   * when idle is left.
> >   */
> > -static void tick_nohz_kick_tick(int cpu)
> > +static void tick_nohz_kick_tick(int cpu, ktime_t now)
> >  {
> >  #if 0
> 
> hm?

You mean the tick_nohz_kick_tick function? Seems like old ballast, I
have no idea who might want to uncomment the #if 0 ever again. But if
they do the function should work, no?
 
> > @@ -614,11 +605,22 @@ static inline void tick_nohz_switch_to_n
> >   */
> >  void tick_check_idle(int cpu)
> >  {
> > +#ifdef CONFIG_NO_HZ
> > +	struct tick_sched *ts;
> > +#endif
> > +
> >  	tick_check_oneshot_broadcast(cpu);
> >  #ifdef CONFIG_NO_HZ
> > -	tick_nohz_stop_idle(cpu);
> > -	tick_nohz_update_jiffies();
> > -	tick_nohz_kick_tick(cpu);
> > +	ts = &per_cpu(tick_cpu_sched, cpu);
> > +	if (ts->idle_active || ts->tick_stopped) {
> > +		ktime_t now = ktime_get();
> > +		if (ts->idle_active)
> > +			tick_nohz_stop_idle(cpu, now);
> > +		if (ts->tick_stopped) {
> > +			tick_nohz_update_jiffies(now);
> > +			tick_nohz_kick_tick(cpu, now);
> > +		}
> > +	}
> >  #endif
> 
> Those ifdefs look quite ugly, dont they?

How about another inline function then:

@@ -603,9 +594,26 @@
 #endif
 }
 
+static inline void tick_check_nohz(int cpu)
+{
+	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
+	ktime_t now;
+
+	if (!ts->idle_active && !ts->tick_stopped)
+		return;
+	now = ktime_get();
+	if (ts->idle_active)
+		tick_nohz_stop_idle(cpu, now);
+	if (ts->tick_stopped) {
+		tick_nohz_update_jiffies(now);
+		tick_nohz_kick_tick(cpu, now);
+	}
+}
+
 #else
 
 static inline void tick_nohz_switch_to_nohz(void) { }
+static inline void tick_check_nohz(int cpu) { }
 
 #endif /* NO_HZ */
 
@@ -615,11 +623,7 @@
 void tick_check_idle(int cpu)
 {
 	tick_check_oneshot_broadcast(cpu);
-#ifdef CONFIG_NO_HZ
-	tick_nohz_stop_idle(cpu);
-	tick_nohz_update_jiffies();
-	tick_nohz_kick_tick(cpu);
-#endif
+	tick_check_nohz(cpu);
 }
 
 /*


-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

