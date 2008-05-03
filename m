Return-Path: <linux-kernel-owner+w=401wt.eu-S1753715AbYECTpU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753715AbYECTpU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 15:45:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751775AbYECTpI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 15:45:08 -0400
Received: from www.tglx.de ([62.245.132.106]:37706 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751601AbYECTpH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 15:45:07 -0400
Date: Sat, 3 May 2008 21:44:10 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: [GIT pull} hrtimer updates
Message-ID: <alpine.LFD.1.10.0805032141070.6003@apollo.tec.linutronix.de>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull hrtimer updates from

  ssh://master.kernel.org/pub/scm/linux/kernel/git/tglx/linux-2.6-hrt.git master

 - permission fixups for /sys/devices/.../clocksource
 - fold duplicated inline function into hrtimer.h

Thanks,
	tglx

---
Heiko Carstens (2):
      clocksource: Fix permissions for available_clocksource
      clocksource: allow read access to available/current_clocksource

Oliver Hartkopp (1):
      hrtimer: remove duplicate helper function

 include/linux/hrtimer.h   |    9 +++++++++
 kernel/hrtimer.c          |    9 ---------
 kernel/time/clocksource.c |    4 ++--
 net/can/bcm.c             |    6 ------
 4 files changed, 11 insertions(+), 17 deletions(-)
diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
index 31a4d65..6d93dce 100644
--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -316,6 +316,15 @@ static inline int hrtimer_is_queued(struct hrtimer *timer)
 		(HRTIMER_STATE_ENQUEUED | HRTIMER_STATE_PENDING);
 }
 
+/*
+ * Helper function to check, whether the timer is running the callback
+ * function
+ */
+static inline int hrtimer_callback_running(struct hrtimer *timer)
+{
+	return timer->state & HRTIMER_STATE_CALLBACK;
+}
+
 /* Forward a hrtimer so it expires after now: */
 extern u64
 hrtimer_forward(struct hrtimer *timer, ktime_t now, ktime_t interval);
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 9af1d6a..421be5f 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -154,15 +154,6 @@ static void hrtimer_get_softirq_time(struct hrtimer_cpu_base *base)
 }
 
 /*
- * Helper function to check, whether the timer is running the callback
- * function
- */
-static inline int hrtimer_callback_running(struct hrtimer *timer)
-{
-	return timer->state & HRTIMER_STATE_CALLBACK;
-}
-
-/*
  * Functions and macros which are different for UP/SMP systems are kept in a
  * single place
  */
diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index 73961f3..dadde53 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -471,10 +471,10 @@ sysfs_show_available_clocksources(struct sys_device *dev, char *buf)
 /*
  * Sysfs setup bits:
  */
-static SYSDEV_ATTR(current_clocksource, 0600, sysfs_show_current_clocksources,
+static SYSDEV_ATTR(current_clocksource, 0644, sysfs_show_current_clocksources,
 		   sysfs_override_clocksource);
 
-static SYSDEV_ATTR(available_clocksource, 0600,
+static SYSDEV_ATTR(available_clocksource, 0444,
 		   sysfs_show_available_clocksources, NULL);
 
 static struct sysdev_class clocksource_sysclass = {
diff --git a/net/can/bcm.c b/net/can/bcm.c
index 74fd2d3..d9a3a9d 100644
--- a/net/can/bcm.c
+++ b/net/can/bcm.c
@@ -412,12 +412,6 @@ static void bcm_rx_changed(struct bcm_op *op, struct can_frame *data)
 	bcm_send_to_user(op, &head, data, 1);
 }
 
-/* TODO: move to linux/hrtimer.h */
-static inline int hrtimer_callback_running(struct hrtimer *timer)
-{
-        return timer->state & HRTIMER_STATE_CALLBACK;
-}
-
 /*
  * bcm_rx_update_and_send - process a detected relevant receive content change
  *                          1. update the last received data
