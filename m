Return-Path: <linux-kernel-owner+w=401wt.eu-S934919AbYCSUr5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934919AbYCSUr5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 16:47:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758390AbYCSTor
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:44:47 -0400
Received: from [198.99.130.12] ([198.99.130.12]:33907 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1758282AbYCSToo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:44:44 -0400
Date: Tue, 18 Mar 2008 13:00:19 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Nix <nix@esperi.org.uk>
Cc: clowncoder <vincent-perrier@club-internet.fr>,
       user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@timesys.com>
Subject: Re: [2.6.24.x] UML select()/poll() oversleeping reproducibly
Message-ID: <20080318170019.GA8747@c2.user-mode-linux.org>
References: <47B34BA0.30006@club-internet.fr> <20080214003853.GA15952@c2.user-mode-linux.org> <47B4BDCD.4080605@club-internet.fr> <20080215160205.GA6082@c2.user-mode-linux.org> <47B5CE40.9000005@club-internet.fr> <20080215184650.GA8810@c2.user-mode-linux.org> <87y78kx640.fsf_-_@hades.wkstn.nix> <20080317193415.GA12234@c2.user-mode-linux.org> <87k5k112kf.fsf@hades.wkstn.nix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87k5k112kf.fsf@hades.wkstn.nix>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below is another patch.

I was hurt and disappointed by your
> Eeuuuuw. :)
so I got rid of the 9/10 thing.

This version keeps track of the time between ticks (as reported by the
host's gettimeofday) and adjusts its sleeping and reporting ticks
accordingly.

It's still undersleeping a little - your little test once reported 19
seconds for a 20 second sleep.  Otherwise, it's reporting sleep times
that are right on the money.

				Jeff

-- 
Work email - jdike at linux dot intel dot com

Index: linux-2.6.22/arch/um/os-Linux/time.c
===================================================================
--- linux-2.6.22.orig/arch/um/os-Linux/time.c	2008-03-18 12:32:19.000000000 -0400
+++ linux-2.6.22/arch/um/os-Linux/time.c	2008-03-18 12:45:50.000000000 -0400
@@ -11,6 +11,7 @@
 #include "kern_constants.h"
 #include "os.h"
 #include "user.h"
+#include "kern_util.h"
 
 int set_interval(void)
 {
@@ -58,12 +59,17 @@ static inline long long timeval_to_ns(co
 long long disable_timer(void)
 {
 	struct itimerval time = ((struct itimerval) { { 0, 0 }, { 0, 0 } });
+	int remain, max = UM_NSEC_PER_SEC / UM_HZ;
 
 	if (setitimer(ITIMER_VIRTUAL, &time, &time) < 0)
 		printk(UM_KERN_ERR "disable_timer - setitimer failed, "
 		       "errno = %d\n", errno);
 
-	return timeval_to_ns(&time.it_value);
+	remain = timeval_to_ns(&time.it_value);
+	if (remain > max)
+		remain = max;
+
+	return remain;
 }
 
 long long os_nsecs(void)
@@ -79,7 +85,47 @@ static int after_sleep_interval(struct t
 {
 	return 0;
 }
+
+
+static void deliver_alarm(void)
+{
+	alarm_handler(SIGVTALRM, NULL);
+}
+
+static unsigned long long sleep_time(unsigned long long nsecs)
+{
+	return nsecs;
+}
+
 #else
+unsigned long long last_tick;
+unsigned long long skew;
+
+extern void alarm_handler(int sig, struct sigcontext *sc);
+
+static void deliver_alarm(void)
+{
+	unsigned long long this_tick = os_nsecs();
+	int one_tick = UM_NSEC_PER_SEC / UM_HZ;
+
+	if (last_tick == 0)
+		last_tick = this_tick - one_tick;
+
+	skew += this_tick - last_tick;
+
+	while (skew >= one_tick) {
+		alarm_handler(SIGVTALRM, NULL);
+		skew -= one_tick;
+	}
+
+	last_tick = this_tick;
+}
+
+static unsigned long long sleep_time(unsigned long long nsecs)
+{
+	return nsecs > skew ? nsecs - skew : 0;
+}
+
 static inline long long timespec_to_us(const struct timespec *ts)
 {
 	return ((long long) ts->tv_sec * UM_USEC_PER_SEC) +
@@ -102,6 +148,8 @@ static int after_sleep_interval(struct t
 	 */
 	if (start_usecs > usec)
 		start_usecs = usec;
+
+	start_usecs -= skew / UM_NSEC_PER_USEC;
 	tv = ((struct timeval) { .tv_sec  = start_usecs / UM_USEC_PER_SEC,
 				 .tv_usec = start_usecs % UM_USEC_PER_SEC });
 	interval = ((struct itimerval) { { 0, usec }, tv });
@@ -113,8 +161,6 @@ static int after_sleep_interval(struct t
 }
 #endif
 
-extern void alarm_handler(int sig, struct sigcontext *sc);
-
 void idle_sleep(unsigned long long nsecs)
 {
 	struct timespec ts;
@@ -126,10 +172,12 @@ void idle_sleep(unsigned long long nsecs
 	 */
 	if (nsecs == 0)
 		nsecs = UM_NSEC_PER_SEC / UM_HZ;
+
+	nsecs = sleep_time(nsecs);
 	ts = ((struct timespec) { .tv_sec	= nsecs / UM_NSEC_PER_SEC,
 				  .tv_nsec	= nsecs % UM_NSEC_PER_SEC });
 
 	if (nanosleep(&ts, &ts) == 0)
-		alarm_handler(SIGVTALRM, NULL);
+		deliver_alarm();
 	after_sleep_interval(&ts);
 }
