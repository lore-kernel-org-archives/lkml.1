Return-Path: <linux-kernel-owner+w=401wt.eu-S1763852AbXHaDlq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763852AbXHaDlq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 23:41:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757083AbXHaDlh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 23:41:37 -0400
Received: from pythia.bakeyournoodle.com ([203.82.209.197]:52378 "EHLO
	pythia.bakeyournoodle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007AbXHaDlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 23:41:36 -0400
X-Greylist: delayed 366 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 Aug 2007 23:41:35 EDT
Date: Fri, 31 Aug 2007 13:41:34 +1000
To: Linux Kernel ML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Tony Luck <tony.luck@intel.com>,
       John Stultz <johnstul@us.ibm.com>
Subject: [PATCH] Fix discrepancy between VDSO based gettimeofday() and sys_gettimeofday().
Message-ID: <20070831034134.GP10345@bakeyournoodle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
From: tony@bakeyournoodle.com (Tony Breeds)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On platforms that copy sys_tz into the vdso (currently only x86_64, soon
to include powerpc), it is possible for the vdso to get out of sync if a
user calls (admittedly unusual) settimeofday(NULL, ptr).

This patch adds a hook for architectures that set CONFIG_GENERIC_TIME_VSYSCALL
to ensure when sys_tz is updated they can also updater their copy in the vdso.

Signed-off-by: Tony Breeds <tony@bakeyournoodle.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: John Stultz <johnstul@us.ibm.com>
---

Only compile tested for IA64
Testcase at: http://bakeyournoodle.com/~tony/settimeofday-0.0/
I guess this is aimed at 2.6.24

 arch/ia64/kernel/time.c       |    5 +++++
 arch/x86_64/kernel/vsyscall.c |   11 ++++++++++-
 include/linux/clocksource.h   |    5 +++++
 kernel/time.c                 |    2 ++
 4 files changed, 22 insertions(+), 1 deletions(-)

diff --git a/arch/ia64/kernel/time.c b/arch/ia64/kernel/time.c
index 98cfc90..2bb8421 100644
--- a/arch/ia64/kernel/time.c
+++ b/arch/ia64/kernel/time.c
@@ -371,6 +371,11 @@ ia64_setup_printk_clock(void)
 		ia64_printk_clock = ia64_itc_printk_clock;
 }
 
+/* IA64 doesn't cache the timezone */
+void update_vsyscall_tz(void)
+{
+}
+
 void update_vsyscall(struct timespec *wall, struct clocksource *c)
 {
         unsigned long flags;
diff --git a/arch/x86_64/kernel/vsyscall.c b/arch/x86_64/kernel/vsyscall.c
index 06c3494..4ff78b0 100644
--- a/arch/x86_64/kernel/vsyscall.c
+++ b/arch/x86_64/kernel/vsyscall.c
@@ -66,6 +66,16 @@ struct vsyscall_gtod_data __vsyscall_gtod_data __section_vsyscall_gtod_data =
 	.sysctl_enabled = 1,
 };
 
+void update_vsyscall_tz(void)
+{
+	unsigned long flags;
+
+	write_seqlock_irqsave(&vsyscall_gtod_data.lock, flags);
+	/* sys_tz has changed */
+	vsyscall_gtod_data.sys_tz = sys_tz;
+	write_sequnlock_irqrestore(&vsyscall_gtod_data.lock, flags);
+}
+
 void update_vsyscall(struct timespec *wall_time, struct clocksource *clock)
 {
 	unsigned long flags;
@@ -79,7 +89,6 @@ void update_vsyscall(struct timespec *wall_time, struct clocksource *clock)
 	vsyscall_gtod_data.clock.shift = clock->shift;
 	vsyscall_gtod_data.wall_time_sec = wall_time->tv_sec;
 	vsyscall_gtod_data.wall_time_nsec = wall_time->tv_nsec;
-	vsyscall_gtod_data.sys_tz = sys_tz;
 	vsyscall_gtod_data.wall_time_nsec = wall_time->tv_nsec;
 	vsyscall_gtod_data.wall_to_monotonic = wall_to_monotonic;
 	write_sequnlock_irqrestore(&vsyscall_gtod_data.lock, flags);
diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
index 16ea337..107787a 100644
--- a/include/linux/clocksource.h
+++ b/include/linux/clocksource.h
@@ -221,10 +221,15 @@ extern void clocksource_resume(void);
 
 #ifdef CONFIG_GENERIC_TIME_VSYSCALL
 extern void update_vsyscall(struct timespec *ts, struct clocksource *c);
+extern void update_vsyscall_tz(void);
 #else
 static inline void update_vsyscall(struct timespec *ts, struct clocksource *c)
 {
 }
+
+static inline void update_vsyscall_tz(void)
+{
+}
 #endif
 
 #endif /* _LINUX_CLOCKSOURCE_H */
diff --git a/kernel/time.c b/kernel/time.c
index 2289a8d..9a4873e 100644
--- a/kernel/time.c
+++ b/kernel/time.c
@@ -30,6 +30,7 @@
 #include <linux/module.h>
 #include <linux/timex.h>
 #include <linux/capability.h>
+#include <linux/clocksource.h>
 #include <linux/errno.h>
 #include <linux/syscalls.h>
 #include <linux/security.h>
@@ -163,6 +164,7 @@ int do_sys_settimeofday(struct timespec *tv, struct timezone *tz)
 	if (tz) {
 		/* SMP safe, global irq locking makes it work. */
 		sys_tz = *tz;
+		update_vsyscall_tz();
 		if (firsttime) {
 			firsttime = 0;
 			if (!tv)
-- 
1.5.2.5

Yours Tony

  linux.conf.au        http://linux.conf.au/ || http://lca2008.linux.org.au/
  Jan 28 - Feb 02 2008 The Australian Linux Technical Conference!

