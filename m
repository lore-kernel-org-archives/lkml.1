Return-Path: <linux-kernel-owner+w=401wt.eu-S1162113AbXECPDc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162113AbXECPDc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 11:03:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1162116AbXECPDc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 11:03:32 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36487 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162113AbXECPD3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 11:03:29 -0400
Date: Thu, 3 May 2007 17:03:20 +0200
From: Tomas Janousek <tjanouse@redhat.com>
To: johnstul@us.ibm.com, linux-kernel@vger.kernel.org
Cc: tsmetana@redhat.com, riel@redhat.com
Subject: Broken process startup times after suspend (regression)
Message-ID: <20070503150320.GA21471@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="J2SCkAp4GZ/dPZZf"
Content-Disposition: inline
Organization: Red Hat Czech s.r.o., =?utf-8?Q?Purky?=
	=?utf-8?Q?=C5=88ova_99=2F71=2C_612_45_Brno=2C_Czech_Republic?=
	=?utf-8?Q?=3B?= registered in Brno under identification number
	CZ27690016
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--J2SCkAp4GZ/dPZZf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

the commits
  411187fb05cd11676b0979d9fbf3291db69dbce2 (GTOD: persistent clock support)
  c1d370e167d66b10bca3b602d3740405469383de (i386: use GTOD persistent clock
    support)
caused a change in the way uptime is measured and introduced a regression such
that it's no longer possible to obtain a correct process start time or the
system boot time.

These two commits make the monotonic time not jump by hudreds of seconds after
the kernel resumes from suspend, but they achieve it by moving the
wall_to_monotonic offset, which is used for all boot time / uptime
calculations. It's not possible to read the real boot time / process start
time then.

I was thinking about a solution and I am posting the least intrusive one I
found. I add a total_sleep_time variable which is to be added to
wall_to_monotonic when one wants the proper boot time. I do by no means say
it's the best one, I expect comments.

This requires a patch to procps that makes it use /proc/stat's btime instead
of "now - uptime". This was written by Tomas Smetana and I'm attaching it as
well. (It was posted upstream as it fixes another bug in ps as well.) Or we
could just make the /proc/uptime contain "now - btime" like it used to before
those two commits.

---
 fs/proc/proc_misc.c  |    2 +-
 include/linux/time.h |    1 +
 kernel/fork.c        |    1 +
 kernel/timer.c       |    6 ++++++
 4 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/fs/proc/proc_misc.c b/fs/proc/proc_misc.c
index e2c4c0a..a29309e 100644
--- a/fs/proc/proc_misc.c
+++ b/fs/proc/proc_misc.c
@@ -456,7 +456,7 @@ static int show_stat(struct seq_file *p, void *v)
 
 	user = nice = system = idle = iowait =
 		irq = softirq = steal = cputime64_zero;
-	jif = - wall_to_monotonic.tv_sec;
+	jif = - (wall_to_monotonic.tv_sec + total_sleep_time);
 	if (wall_to_monotonic.tv_nsec)
 		--jif;
 
diff --git a/include/linux/time.h b/include/linux/time.h
index 8ea8dea..cb87616 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -90,6 +90,7 @@ static inline struct timespec timespec_sub(struct timespec lhs,
 
 extern struct timespec xtime;
 extern struct timespec wall_to_monotonic;
+extern unsigned long total_sleep_time;
 extern seqlock_t xtime_lock __attribute__((weak));
 
 extern unsigned long read_persistent_clock(void);
diff --git a/kernel/fork.c b/kernel/fork.c
index 6af959c..c051f17 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1056,6 +1056,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 
 	p->lock_depth = -1;		/* -1 = no lock */
 	do_posix_clock_monotonic_gettime(&p->start_time);
+	p->start_time.tv_sec += total_sleep_time;
 	p->security = NULL;
 	p->io_context = NULL;
 	p->io_wait = NULL;
diff --git a/kernel/timer.c b/kernel/timer.c
index dd6c2c1..13eb201 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -759,9 +759,13 @@ unsigned long next_timer_interrupt(void)
  * at zero at system boot time, so wall_to_monotonic will be negative,
  * however, we will ALWAYS keep the tv_nsec part positive so we can use
  * the usual normalization.
+ *
+ * One needs to add total_sleep_time to wall_to_monotonic to get the real boot
+ * time.
  */
 struct timespec xtime __attribute__ ((aligned (16)));
 struct timespec wall_to_monotonic __attribute__ ((aligned (16)));
+unsigned long total_sleep_time;
 
 EXPORT_SYMBOL(xtime);
 
@@ -975,6 +979,7 @@ void __init timekeeping_init(void)
 	xtime.tv_nsec = 0;
 	set_normalized_timespec(&wall_to_monotonic,
 		-xtime.tv_sec, -xtime.tv_nsec);
+	total_sleep_time = 0;
 
 	write_sequnlock_irqrestore(&xtime_lock, flags);
 }
@@ -1004,6 +1009,7 @@ static int timekeeping_resume(struct sys_device *dev)
 
 		xtime.tv_sec += sleep_length;
 		wall_to_monotonic.tv_sec -= sleep_length;
+		total_sleep_time += sleep_length;
 	}
 	/* re-base the last cycle value */
 	clock->cycle_last = clocksource_read(clock);

Regards,
-- 
Tomas Janousek, SW Engineer, Red Hat, Inc.

--J2SCkAp4GZ/dPZZf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="procps-3.2.7-ps-stime.patch"

--- procps-3.2.7/ps/output.c.jitter	2007-04-26 13:15:47.000000000 +0200
+++ procps-3.2.7/ps/output.c	2007-04-26 13:31:24.000000000 +0200
@@ -77,7 +77,6 @@
 static int wide_signals;  /* true if we have room */
 
 static unsigned long seconds_since_1970;
-static unsigned long time_of_boot;
 static unsigned long page_shift;
 
 
@@ -1952,7 +1951,6 @@
   // available space:  page_size*outbuf_pages-SPACE_AMOUNT
 
   seconds_since_1970 = time(NULL);
-  time_of_boot = seconds_since_1970 - seconds_since_boot;
 
   meminfo();
 
--- procps-3.2.7/ps/common.h.jitter	2005-01-27 04:43:22.000000000 +0100
+++ procps-3.2.7/ps/common.h	2007-04-26 12:44:01.000000000 +0200
@@ -302,6 +302,7 @@
 extern int             screen_cols;
 extern int             screen_rows;
 extern unsigned long   seconds_since_boot;
+extern unsigned long   time_of_boot;
 extern selection_node *selection_list;
 extern unsigned        simple_select;
 extern sort_node      *sort_list;
--- procps-3.2.7/ps/global.c.jitter	2005-10-30 01:43:34.000000000 +0200
+++ procps-3.2.7/ps/global.c	2007-04-26 13:26:38.000000000 +0200
@@ -70,6 +70,7 @@
 int             screen_cols = -1;
 int             screen_rows = -1;
 unsigned long   seconds_since_boot = -1;
+unsigned long   time_of_boot = -1;
 selection_node *selection_list = (selection_node *)0xdeadbeef;
 unsigned        simple_select = 0xffffffff;
 sort_node      *sort_list = (sort_node *)0xdeadbeef; /* ready-to-use sort list */
@@ -361,7 +362,23 @@
   look_up_our_self(&p);
   set_screen_size();
   set_personality();
-  
+  int fd;
+  char buf[BUFFSIZE];
+  const char *b;
+
+  /* get boot time from /proc/stat */
+  fd = open("/proc/stat", O_RDONLY, 0);
+  if (fd != -1) {
+    buf[BUFFSIZE-1] = 0;
+    read(fd, buf, BUFFSIZE-1);
+    b = strstr(buf, "btime ");
+    if (b) {
+      sscanf(b, "btime %lu", &time_of_boot);
+      seconds_since_boot = time(0) - time_of_boot;
+    }  
+    close(fd);
+  }
+    
   all_processes         = 0;
   bsd_c_option          = 0;
   bsd_e_option          = 0;
@@ -380,7 +397,6 @@
   negate_selection      = 0;
   page_size             = getpagesize();
   running_only          = 0;
-  seconds_since_boot    = uptime(0,0);
   selection_list        = NULL;
   simple_select         = 0;
   sort_list             = NULL;

--J2SCkAp4GZ/dPZZf--
