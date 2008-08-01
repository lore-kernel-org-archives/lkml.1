Return-Path: <linux-kernel-owner+w=401wt.eu-S1755077AbYHAWos@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755077AbYHAWos (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 18:44:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760710AbYHAWl7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 18:41:59 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:52143 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760598AbYHAWl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 18:41:57 -0400
Date: Fri, 1 Aug 2008 18:41:27 -0400
From: Jeff Dike <jdike@addtoit.com>
To: stable@kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
       Nix <nix@esperi.org.uk>
Subject: [PATCH 4/14] uml: track and make up lost ticks
Message-ID: <20080801224127.GA13725@c2.user-mode-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From a113552a171e5a30a8a478f7d4dcf8d0ff08f12f Mon Sep 17 00:00:00 2001

Alarm delivery could be noticably late in the !CONFIG_NOHZ case because lost
ticks weren't being taken into account.  This is now treated more carefully,
with the time between ticks being calculated and the appropriate number of
ticks delivered to the timekeeping system.

Cc: Nix <nix@esperi.org.uk>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---
 arch/um/include/process.h |    4 +-
 arch/um/os-Linux/signal.c |    1 +
 arch/um/os-Linux/time.c   |   54 +++++++++++++++++++++++++++++++++++++++++---
 3 files changed, 53 insertions(+), 6 deletions(-)

diff --git a/arch/um/include/process.h b/arch/um/include/process.h
index 5af9157..348f8a3 100644
--- a/arch/um/include/process.h
+++ b/arch/um/include/process.h
@@ -8,8 +8,8 @@
 
 #include <signal.h>
 
-extern void sig_handler(int sig, struct sigcontext sc);
-extern void alarm_handler(int sig, struct sigcontext sc);
+extern void sig_handler(int sig, struct sigcontext *sc);
+extern void alarm_handler(int sig, struct sigcontext *sc);
 
 #endif
 
diff --git a/arch/um/os-Linux/signal.c b/arch/um/os-Linux/signal.c
index 3f1694b..5aade60 100644
--- a/arch/um/os-Linux/signal.c
+++ b/arch/um/os-Linux/signal.c
@@ -12,6 +12,7 @@
 #include "as-layout.h"
 #include "kern_util.h"
 #include "os.h"
+#include "process.h"
 #include "sysdep/barrier.h"
 #include "sysdep/sigcontext.h"
 #include "user.h"
diff --git a/arch/um/os-Linux/time.c b/arch/um/os-Linux/time.c
index e492805..bee98f4 100644
--- a/arch/um/os-Linux/time.c
+++ b/arch/um/os-Linux/time.c
@@ -9,7 +9,9 @@
 #include <time.h>
 #include <sys/time.h>
 #include "kern_constants.h"
+#include "kern_util.h"
 #include "os.h"
+#include "process.h"
 #include "user.h"
 
 int set_interval(void)
@@ -58,12 +60,17 @@ static inline long long timeval_to_ns(const struct timeval *tv)
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
@@ -79,7 +86,44 @@ static int after_sleep_interval(struct timespec *ts)
 {
 	return 0;
 }
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
@@ -102,6 +146,8 @@ static int after_sleep_interval(struct timespec *ts)
 	 */
 	if (start_usecs > usec)
 		start_usecs = usec;
+
+	start_usecs -= skew / UM_NSEC_PER_USEC;
 	tv = ((struct timeval) { .tv_sec  = start_usecs / UM_USEC_PER_SEC,
 				 .tv_usec = start_usecs % UM_USEC_PER_SEC });
 	interval = ((struct itimerval) { { 0, usec }, tv });
@@ -113,8 +159,6 @@ static int after_sleep_interval(struct timespec *ts)
 }
 #endif
 
-extern void alarm_handler(int sig, struct sigcontext *sc);
-
 void idle_sleep(unsigned long long nsecs)
 {
 	struct timespec ts;
@@ -126,10 +170,12 @@ void idle_sleep(unsigned long long nsecs)
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
-- 
1.5.5.1
