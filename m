Return-Path: <linux-kernel-owner+w=401wt.eu-S936141AbXHHDqs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936141AbXHHDqs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 23:46:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932449AbXHHDql
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 23:46:41 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:1780 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759754AbXHHDqk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 23:46:40 -0400
Date: Wed, 8 Aug 2007 05:47:02 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Andrew Morton <akpm@linux-foundation.org>
cc: Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] msleep() with hrtimers
In-Reply-To: <20070807162940.74f536f8.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0708080535140.1817@scrub.home>
References: <15327.1186166232@lwn.net> <20070807124009.9f6c2247.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0708080115020.1817@scrub.home> <20070807162940.74f536f8.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 7 Aug 2007, Andrew Morton wrote:

> On Wed, 8 Aug 2007 01:16:49 +0200 (CEST)
> Roman Zippel <zippel@linux-m68k.org> wrote:
> 
> > Hi,
> > 
> > On Tue, 7 Aug 2007, Andrew Morton wrote:
> > 
> > > I'd be surprised if there was significant overhead - the maximum frequency
> > > at which msleep() can be called is 1000Hz.  We'd need an awful lot of
> > > overhead for that to cause problems, surely?
> > > 
> > > <thinks he's missing something again>
> > 
> > _Anybody_ has yet to answer what's wrong with adding a nanosleep() and 
> > using that instead.
> > 
> 
> You mean that the implementation could be simplified if msleep() were to
> simply call do_nanosleep()?

The current msleep is fine and doesn't need any "fixing".
Not all the world is i386, _please_ keep hrtimer usage where it's 
required. Simple timer should be given preference unless the higher 
resolution is really needed, which is not the case here.

> That would work, although a bit of refactoring would be needed so that we
> could implement the TASK_UNINTERRUPTIBLE msleep() that way.

The function is not that big, so below is a nanosleep implementation based 
on Jonathan's patch. This will user give a choice, so there is no need to 
force all users to use hrtimer for a simple sleep.
Please apply this patch instead.

bye, Roman

Signed-off-by: Roman Zippel <zippel@linux-m68k.org>

---
 include/linux/delay.h |    5 +++++
 kernel/timer.c        |   49 +++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 54 insertions(+)

Index: linux-2.6/include/linux/delay.h
===================================================================
--- linux-2.6.orig/include/linux/delay.h
+++ linux-2.6/include/linux/delay.h
@@ -9,6 +9,7 @@
 
 extern unsigned long loops_per_jiffy;
 
+#include <linux/ktime.h>
 #include <asm/delay.h>
 
 /*
@@ -36,6 +37,10 @@ extern unsigned long loops_per_jiffy;
 #endif
 
 void calibrate_delay(void);
+
+void nanosleep(ktime_t time);
+int nanosleep_interruptible(ktime_t *time);
+
 void msleep(unsigned int msecs);
 unsigned long msleep_interruptible(unsigned int msecs);
 
Index: linux-2.6/kernel/timer.c
===================================================================
--- linux-2.6.orig/kernel/timer.c
+++ linux-2.6/kernel/timer.c
@@ -1377,3 +1377,52 @@ unsigned long msleep_interruptible(unsig
 }
 
 EXPORT_SYMBOL(msleep_interruptible);
+
+static int do_nanosleep(ktime_t *time, int sigs)
+{
+	enum hrtimer_mode mode = HRTIMER_MODE_REL;
+	int state = sigs ? TASK_INTERRUPTIBLE : TASK_UNINTERRUPTIBLE;
+	struct hrtimer_sleeper sleeper;
+
+	hrtimer_init_sleeper(&sleeper, current);
+	hrtimer_init(&sleeper.timer, CLOCK_MONOTONIC, mode);
+	sleeper.timer.expires = *time;
+
+	do {
+		set_current_state(state);
+		hrtimer_start(&sleeper.timer, sleeper.timer.expires, mode);
+		if (sleeper.task)
+			schedule();
+		hrtimer_cancel(&sleeper.timer);
+		mode = HRTIMER_MODE_ABS;
+		if (!sleeper.task)
+			return 1;
+	} while (!sigs || !signal_pending(current));
+
+	*time = sleeper.timer.expires;
+	return 0;
+}
+
+/**
+ * nanosleep - sleep safely even with waitqueue interruptions
+ * @time: Time to sleep for
+ */
+void nanosleep(ktime_t time)
+{
+	do_nanosleep(&time, 0);
+}
+EXPORT_SYMBOL(nanosleep);
+
+/**
+ * nanosleep_interruptible - sleep waiting for signals
+ * @time: Time to sleep for
+ */
+int nanosleep_interruptible(ktime_t *time)
+{
+	if (do_nanosleep(time, 1))
+		return 1;
+
+	*time = ktime_sub(*time, ktime_get());
+	return 0;
+}
+EXPORT_SYMBOL(nanosleep_interruptible);
