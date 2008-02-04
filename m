Return-Path: <linux-kernel-owner+w=401wt.eu-S1758746AbYBDXsQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758746AbYBDXsQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 18:48:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756792AbYBDXsA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 18:48:00 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:35161 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756218AbYBDXr7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 18:47:59 -0500
Date: Tue, 5 Feb 2008 00:48:13 +0100
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Timer cleanups
Message-ID: <20080204234813.GA1927@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Add anotations, so that timertop produces nicer results. Relative
expiry time can get negative, so it should be signed.

Signed-off-by: Pavel Machek <Pavel@suse.cz>


diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index 429d084..235fd6c 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -368,8 +368,8 @@ static int hpet_clocksource_register(voi
 	return 0;
 }
 
-/*
- * Try to setup the HPET timer
+/**
+ * hpet_enable - Try to setup the HPET timer. Returns 1 on success.
  */
 int __init hpet_enable(void)
 {
diff --git a/kernel/time/timer_list.c b/kernel/time/timer_list.c
index d3d94c1..0fab3ca 100644
--- a/kernel/time/timer_list.c
+++ b/kernel/time/timer_list.c
@@ -65,9 +65,9 @@ #ifdef CONFIG_TIMER_STATS
 	SEQ_printf(m, ", %s/%d", tmp, timer->start_pid);
 #endif
 	SEQ_printf(m, "\n");
-	SEQ_printf(m, " # expires at %Lu nsecs [in %Lu nsecs]\n",
+	SEQ_printf(m, " # expires at %Lu nsecs [in %Ld nsecs]\n",
 		(unsigned long long)ktime_to_ns(timer->expires),
-		(unsigned long long)(ktime_to_ns(timer->expires) - now));
+		(long long)(ktime_to_ns(timer->expires) - now));
 }
 
 static void
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 52db48e..6cbec10 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -219,6 +219,7 @@ int queue_delayed_work_on(int cpu, struc
 	struct timer_list *timer = &dwork->timer;
 	struct work_struct *work = &dwork->work;
 
+	timer_stats_timer_set_start_info(&dwork->timer);
 	if (!test_and_set_bit(WORK_STRUCT_PENDING, work_data_bits(work))) {
 		BUG_ON(timer_pending(timer));
 		BUG_ON(!list_empty(&work->entry));
@@ -580,6 +581,7 @@ EXPORT_SYMBOL(schedule_delayed_work);
 int schedule_delayed_work_on(int cpu,
 			struct delayed_work *dwork, unsigned long delay)
 {
+	timer_stats_timer_set_start_info(&dwork->timer);
 	return queue_delayed_work_on(cpu, keventd_wq, dwork, delay);
 }
 EXPORT_SYMBOL(schedule_delayed_work_on);

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
