Return-Path: <linux-kernel-owner+w=401wt.eu-S1753734AbYFSVEc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753734AbYFSVEc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 17:04:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751584AbYFSVEU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 17:04:20 -0400
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:58131 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582AbYFSVEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 17:04:14 -0400
Date: Thu, 19 Jun 2008 08:58:54 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, josh@freedesktop.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, dino@in.ibm.com, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, vegard.nossum@gmail.com,
       adobriyan@gmail.com, oleg@tv-sign.ru, bunk@kernel.org, rjw@sisk.pl
Subject: Re: [PATCH] Make rcutorture more vicious: reinstate boot-time testing
Message-ID: <20080619155854.GA5084@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080618122144.GA27143@linux.vnet.ibm.com> <20080618162649.GA18326@linux.vnet.ibm.com> <20080619092914.GB15228@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080619092914.GB15228@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2008 at 11:29:14AM +0200, Ingo Molnar wrote:
> 
> * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> 
> > Hello again!
> > 
> > This patch re-institutes the ability to build rcutorture directly into 
> > the Linux kernel.  The reason that this capability was removed was 
> > that this could result in your kernel being pretty much useless, as 
> > rcutorture would be running starting from early boot.  This problem 
> > has been avoided by (1) making rcutorture run only three seconds of 
> > every six by default, (2) adding a CONFIG_RCU_TORTURE_TEST_RUNNABLE 
> > that permits rcutorture to be quiesced at boot time, and (3) adding a 
> > sysctl in /proc named /proc/sys/kernel/rcutorture_runnable that 
> > permits rcutorture to be quiesced and unquiesced when built into the 
> > kernel.
> > 
> > Please note that this /proc file is -not- available when rcutorture is 
> > built as a module.  Please also note that to get the earlier 
> > take-no-prisoners behavior, you must use the boot command line to set 
> > rcutorture's "stutter" parameter to zero.
> > 
> > The rcutorture quiescing mechanism is currently quite crude: loops in 
> > each rcutorture process that poll a global variable once per tick. 
> > Suggestions for improvement are welcome.  The default action will be 
> > to reduce the polling rate to a few times per second.
> 
> applied to tip/core/rcu - thanks Paul!
> 
> FYI, yesterday's rcutorture-stutter feature survived a few hundred 
> random bootup tests in -tip testing already.
> 
> a possible area for enhancement would be the following code:
> 
> static void
> rcu_stutter_wait(void)
> {
>         while (stutter_pause_test || !rcutorture_runnable)
>                 schedule_timeout_interruptible(1);
> }
> 
> will cause HZ number of IRQs on nohz systems, even if rcutorture is 
> disabled. While it's fine to poll if rcutorture_runnable==1, the sleep 
> should be at least 1 second when !rcutorture_runnable.
> 
> [ Or it might even make sense to completely stop the threads from a 
>   sysctl handler - to make it event-driven and to cause no extra IRQs at 
>   all when rcutorture is disabled via /proc. ]

Here is a crude first cut (incorporated into an updated patch).

Thoughts?

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

 Documentation/RCU/torture.txt      |   21 
 Documentation/RCU/torture.txt.orig |    8 
 kernel/rcutorture.c                |   14 
 kernel/rcutorture.c.orig           |   59 
 kernel/sysctl.c                    |   13 
 kernel/sysctl.c.orig               | 2851 +++++++++++++++++++++++++++++++++++++
 lib/Kconfig.debug                  |   20 
 lib/Kconfig.debug.orig             |  679 ++++++++
 8 files changed, 3651 insertions(+), 14 deletions(-)

diff -urpNa linux-2.6.26-rc4-rcut1-stutter/Documentation/RCU/torture.txt linux-2.6.26-rc4-rcut2-proc/Documentation/RCU/torture.txt
--- linux-2.6.26-rc4-rcut1-stutter/Documentation/RCU/torture.txt	2008-06-18 05:15:43.000000000 -0700
+++ linux-2.6.26-rc4-rcut2-proc/Documentation/RCU/torture.txt	2008-06-18 08:11:19.000000000 -0700
@@ -10,13 +10,20 @@ status messages via printk(), which can 
 command (perhaps grepping for "torture").  The test is started
 when the module is loaded, and stops when the module is unloaded.
 
-However, actually setting this config option to "y" results in the system
-running the test immediately upon boot, and ending only when the system
-is taken down.  Normally, one will instead want to build the system
-with CONFIG_RCU_TORTURE_TEST=m and to use modprobe and rmmod to control
-the test, perhaps using a script similar to the one shown at the end of
-this document.  Note that you will need CONFIG_MODULE_UNLOAD in order
-to be able to end the test.
+CONFIG_RCU_TORTURE_TEST_RUNNABLE
+
+It is also possible to specify CONFIG_RCU_TORTURE_TEST=y, which will
+result in the tests being loaded into the base kernel.  In this case,
+the CONFIG_RCU_TORTURE_TEST_RUNNABLE config option is used to specify
+whether the RCU torture tests are to be started immediately during
+boot or whether the /proc/sys/kernel/rcutorture_runnable file is used
+to enable them.  This /proc file can be used to repeatedly pause and
+restart the tests, regardless of the initial state specified by the
+CONFIG_RCU_TORTURE_TEST_RUNNABLE config option.
+
+You will normally -not- want to start the RCU torture tests during boot
+(and thus the default is CONFIG_RCU_TORTURE_TEST_RUNNABLE=n), but doing
+this can sometimes be useful in finding boot-time bugs.
 
 
 MODULE PARAMETERS
diff -urpNa linux-2.6.26-rc4-rcut1-stutter/Documentation/RCU/torture.txt.orig linux-2.6.26-rc4-rcut2-proc/Documentation/RCU/torture.txt.orig
--- linux-2.6.26-rc4-rcut1-stutter/Documentation/RCU/torture.txt.orig	2008-04-16 19:49:44.000000000 -0700
+++ linux-2.6.26-rc4-rcut2-proc/Documentation/RCU/torture.txt.orig	2008-06-18 05:15:43.000000000 -0700
@@ -46,9 +46,15 @@ stat_interval	The number of seconds betw
 
 shuffle_interval
 		The number of seconds to keep the test threads affinitied
-		to a particular subset of the CPUs, defaults to 5 seconds.
+		to a particular subset of the CPUs, defaults to 3 seconds.
 		Used in conjunction with test_no_idle_hz.
 
+stutter		The length of time to run the test before pausing for this
+		same period of time.  Defaults to "stutter=5", so as
+		to run and pause for (roughly) five-second intervals.
+		Specifying "stutter=0" causes the test to run continuously
+		without pausing, which is the old default behavior.
+
 test_no_idle_hz	Whether or not to test the ability of RCU to operate in
 		a kernel that disables the scheduling-clock interrupt to
 		idle CPUs.  Boolean parameter, "1" to test, "0" otherwise.
diff -urpNa linux-2.6.26-rc4-rcut1-stutter/kernel/rcutorture.c linux-2.6.26-rc4-rcut2-proc/kernel/rcutorture.c
--- linux-2.6.26-rc4-rcut1-stutter/kernel/rcutorture.c	2008-06-18 04:54:41.000000000 -0700
+++ linux-2.6.26-rc4-rcut2-proc/kernel/rcutorture.c	2008-06-19 04:48:56.000000000 -0700
@@ -125,6 +125,13 @@ static struct list_head rcu_torture_remo
 
 static int stutter_pause_test = 0;
 
+#if defined(MODULE) || defined(CONFIG_RCU_TORTURE_TEST_RUNNABLE)
+#define RCUTORTURE_RUNNABLE_INIT 1
+#else
+#define RCUTORTURE_RUNNABLE_INIT 0
+#endif
+int rcutorture_runnable = RCUTORTURE_RUNNABLE_INIT;
+
 /*
  * Allocate an element from the rcu_tortures pool.
  */
@@ -188,8 +195,11 @@ rcu_random(struct rcu_random_state *rrsp
 static void
 rcu_stutter_wait(void)
 {
-	while (stutter_pause_test)
-		schedule_timeout_interruptible(1);
+	while (stutter_pause_test || !rcutorture_runnable)
+		if (rcutorture_runnable)
+			schedule_timeout_interruptible(1);
+		else
+			schedule_timeout_interruptible(HZ);
 }
 
 /*
diff -urpNa linux-2.6.26-rc4-rcut1-stutter/kernel/rcutorture.c.orig linux-2.6.26-rc4-rcut2-proc/kernel/rcutorture.c.orig
--- linux-2.6.26-rc4-rcut1-stutter/kernel/rcutorture.c.orig	2008-05-30 04:39:01.000000000 -0700
+++ linux-2.6.26-rc4-rcut2-proc/kernel/rcutorture.c.orig	2008-06-18 04:54:41.000000000 -0700
@@ -57,7 +57,8 @@ static int stat_interval;	/* Interval be
 				/*  Defaults to "only at end of test". */
 static int verbose;		/* Print more debug info. */
 static int test_no_idle_hz;	/* Test RCU's support for tickless idle CPUs. */
-static int shuffle_interval = 5; /* Interval between shuffles (in sec)*/
+static int shuffle_interval = 3; /* Interval between shuffles (in sec)*/
+static int stutter = 5;		/* Start/stop testing interval (in sec) */
 static char *torture_type = "rcu"; /* What RCU implementation to torture. */
 
 module_param(nreaders, int, 0444);
@@ -72,6 +73,8 @@ module_param(test_no_idle_hz, bool, 0444
 MODULE_PARM_DESC(test_no_idle_hz, "Test support for tickless idle CPUs");
 module_param(shuffle_interval, int, 0444);
 MODULE_PARM_DESC(shuffle_interval, "Number of seconds between shuffles");
+module_param(stutter, int, 0444);
+MODULE_PARM_DESC(stutter, "Number of seconds to run/halt test");
 module_param(torture_type, charp, 0444);
 MODULE_PARM_DESC(torture_type, "Type of RCU to torture (rcu, rcu_bh, srcu)");
 
@@ -91,6 +94,7 @@ static struct task_struct **fakewriter_t
 static struct task_struct **reader_tasks;
 static struct task_struct *stats_task;
 static struct task_struct *shuffler_task;
+static struct task_struct *stutter_task;
 
 #define RCU_TORTURE_PIPE_LEN 10
 
@@ -119,6 +123,8 @@ static atomic_t n_rcu_torture_mberror;
 static atomic_t n_rcu_torture_error;
 static struct list_head rcu_torture_removed;
 
+static int stutter_pause_test = 0;
+
 /*
  * Allocate an element from the rcu_tortures pool.
  */
@@ -179,6 +185,13 @@ rcu_random(struct rcu_random_state *rrsp
 	return swahw32(rrsp->rrs_state);
 }
 
+static void
+rcu_stutter_wait(void)
+{
+	while (stutter_pause_test)
+		schedule_timeout_interruptible(1);
+}
+
 /*
  * Operations vector for selecting different types of tests.
  */
@@ -537,6 +550,7 @@ rcu_torture_writer(void *arg)
 		}
 		rcu_torture_current_version++;
 		oldbatch = cur_ops->completed();
+		rcu_stutter_wait();
 	} while (!kthread_should_stop() && !fullstop);
 	VERBOSE_PRINTK_STRING("rcu_torture_writer task stopping");
 	while (!kthread_should_stop())
@@ -560,6 +574,7 @@ rcu_torture_fakewriter(void *arg)
 		schedule_timeout_uninterruptible(1 + rcu_random(&rand)%10);
 		udelay(rcu_random(&rand) & 0x3ff);
 		cur_ops->sync();
+		rcu_stutter_wait();
 	} while (!kthread_should_stop() && !fullstop);
 
 	VERBOSE_PRINTK_STRING("rcu_torture_fakewriter task stopping");
@@ -615,6 +630,7 @@ rcu_torture_reader(void *arg)
 		preempt_enable();
 		cur_ops->readunlock(idx);
 		schedule();
+		rcu_stutter_wait();
 	} while (!kthread_should_stop() && !fullstop);
 	VERBOSE_PRINTK_STRING("rcu_torture_reader task stopping");
 	while (!kthread_should_stop())
@@ -785,15 +801,34 @@ rcu_torture_shuffle(void *arg)
 	return 0;
 }
 
+/* Cause the rcutorture test to "stutter", starting and stopping all
+ * threads periodically.
+ */
+static int
+rcu_torture_stutter(void *arg)
+{
+	VERBOSE_PRINTK_STRING("rcu_torture_stutter task started");
+	do {
+		schedule_timeout_interruptible(stutter * HZ);
+		stutter_pause_test = 1;
+		if (!kthread_should_stop())
+			schedule_timeout_interruptible(stutter * HZ);
+		stutter_pause_test = 0;
+	} while (!kthread_should_stop());
+	VERBOSE_PRINTK_STRING("rcu_torture_stutter task stopping");
+	return 0;
+}
+
 static inline void
 rcu_torture_print_module_parms(char *tag)
 {
 	printk(KERN_ALERT "%s" TORTURE_FLAG
 		"--- %s: nreaders=%d nfakewriters=%d "
 		"stat_interval=%d verbose=%d test_no_idle_hz=%d "
-		"shuffle_interval = %d\n",
+		"shuffle_interval=%d stutter=%d\n",
 		torture_type, tag, nrealreaders, nfakewriters,
-		stat_interval, verbose, test_no_idle_hz, shuffle_interval);
+		stat_interval, verbose, test_no_idle_hz, shuffle_interval,
+		stutter);
 }
 
 static void
@@ -802,6 +837,11 @@ rcu_torture_cleanup(void)
 	int i;
 
 	fullstop = 1;
+	if (stutter_task) {
+		VERBOSE_PRINTK_STRING("Stopping rcu_torture_stutter task");
+		kthread_stop(stutter_task);
+	}
+	stutter_task = NULL;
 	if (shuffler_task) {
 		VERBOSE_PRINTK_STRING("Stopping rcu_torture_shuffle task");
 		kthread_stop(shuffler_task);
@@ -988,6 +1028,19 @@ rcu_torture_init(void)
 			goto unwind;
 		}
 	}
+	if (stutter < 0)
+		stutter = 0;
+	if (stutter) {
+		/* Create the stutter thread */
+		stutter_task = kthread_run(rcu_torture_stutter, NULL,
+					  "rcu_torture_stutter");
+		if (IS_ERR(stutter_task)) {
+			firsterr = PTR_ERR(stutter_task);
+			VERBOSE_PRINTK_ERRSTRING("Failed to create stutter");
+			stutter_task = NULL;
+			goto unwind;
+		}
+	}
 	return 0;
 
 unwind:
diff -urpNa linux-2.6.26-rc4-rcut1-stutter/kernel/sysctl.c linux-2.6.26-rc4-rcut2-proc/kernel/sysctl.c
--- linux-2.6.26-rc4-rcut1-stutter/kernel/sysctl.c	2008-05-30 04:39:01.000000000 -0700
+++ linux-2.6.26-rc4-rcut2-proc/kernel/sysctl.c	2008-06-18 07:35:26.000000000 -0700
@@ -82,6 +82,9 @@ extern int maps_protect;
 extern int sysctl_stat_interval;
 extern int latencytop_enabled;
 extern int sysctl_nr_open_min, sysctl_nr_open_max;
+#ifdef CONFIG_RCU_TORTURE_TEST
+extern int rcutorture_runnable;
+#endif /* #ifdef CONFIG_RCU_TORTURE_TEST */
 
 /* Constants used for minimum and  maximum */
 #if defined(CONFIG_DETECT_SOFTLOCKUP) || defined(CONFIG_HIGHMEM)
@@ -813,6 +816,16 @@ static struct ctl_table kern_table[] = {
 		.child		= key_sysctls,
 	},
 #endif
+#ifdef CONFIG_RCU_TORTURE_TEST
+	{
+		.ctl_name       = CTL_UNNUMBERED,
+		.procname       = "rcutorture_runnable",
+		.data           = &rcutorture_runnable,
+		.maxlen         = sizeof(int),
+		.mode           = 0644,
+		.proc_handler   = &proc_dointvec,
+	},
+#endif
 /*
  * NOTE: do not add new entries to this table unless you have read
  * Documentation/sysctl/ctl_unnumbered.txt
diff -urpNa linux-2.6.26-rc4-rcut1-stutter/kernel/sysctl.c.orig linux-2.6.26-rc4-rcut2-proc/kernel/sysctl.c.orig
--- linux-2.6.26-rc4-rcut1-stutter/kernel/sysctl.c.orig	1969-12-31 16:00:00.000000000 -0800
+++ linux-2.6.26-rc4-rcut2-proc/kernel/sysctl.c.orig	2008-05-30 04:39:01.000000000 -0700
@@ -0,0 +1,2851 @@
+/*
+ * sysctl.c: General linux system control interface
+ *
+ * Begun 24 March 1995, Stephen Tweedie
+ * Added /proc support, Dec 1995
+ * Added bdflush entry and intvec min/max checking, 2/23/96, Tom Dyas.
+ * Added hooks for /proc/sys/net (minor, minor patch), 96/4/1, Mike Shaver.
+ * Added kernel/java-{interpreter,appletviewer}, 96/5/10, Mike Shaver.
+ * Dynamic registration fixes, Stephen Tweedie.
+ * Added kswapd-interval, ctrl-alt-del, printk stuff, 1/8/97, Chris Horn.
+ * Made sysctl support optional via CONFIG_SYSCTL, 1/10/97, Chris
+ *  Horn.
+ * Added proc_doulongvec_ms_jiffies_minmax, 09/08/99, Carlos H. Bauer.
+ * Added proc_doulongvec_minmax, 09/08/99, Carlos H. Bauer.
+ * Changed linked lists to use list.h instead of lists.h, 02/24/00, Bill
+ *  Wendling.
+ * The list_for_each() macro wasn't appropriate for the sysctl loop.
+ *  Removed it and replaced it with older style, 03/23/00, Bill Wendling
+ */
+
+#include <linux/module.h>
+#include <linux/mm.h>
+#include <linux/swap.h>
+#include <linux/slab.h>
+#include <linux/sysctl.h>
+#include <linux/proc_fs.h>
+#include <linux/security.h>
+#include <linux/ctype.h>
+#include <linux/utsname.h>
+#include <linux/smp_lock.h>
+#include <linux/fs.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/kobject.h>
+#include <linux/net.h>
+#include <linux/sysrq.h>
+#include <linux/highuid.h>
+#include <linux/writeback.h>
+#include <linux/hugetlb.h>
+#include <linux/initrd.h>
+#include <linux/key.h>
+#include <linux/times.h>
+#include <linux/limits.h>
+#include <linux/dcache.h>
+#include <linux/syscalls.h>
+#include <linux/nfs_fs.h>
+#include <linux/acpi.h>
+#include <linux/reboot.h>
+
+#include <asm/uaccess.h>
+#include <asm/processor.h>
+
+#ifdef CONFIG_X86
+#include <asm/nmi.h>
+#include <asm/stacktrace.h>
+#include <asm/io.h>
+#endif
+
+static int deprecated_sysctl_warning(struct __sysctl_args *args);
+
+#if defined(CONFIG_SYSCTL)
+
+/* External variables not in a header file. */
+extern int C_A_D;
+extern int print_fatal_signals;
+extern int sysctl_overcommit_memory;
+extern int sysctl_overcommit_ratio;
+extern int sysctl_panic_on_oom;
+extern int sysctl_oom_kill_allocating_task;
+extern int sysctl_oom_dump_tasks;
+extern int max_threads;
+extern int core_uses_pid;
+extern int suid_dumpable;
+extern char core_pattern[];
+extern int pid_max;
+extern int min_free_kbytes;
+extern int pid_max_min, pid_max_max;
+extern int sysctl_drop_caches;
+extern int percpu_pagelist_fraction;
+extern int compat_log;
+extern int maps_protect;
+extern int sysctl_stat_interval;
+extern int latencytop_enabled;
+extern int sysctl_nr_open_min, sysctl_nr_open_max;
+
+/* Constants used for minimum and  maximum */
+#if defined(CONFIG_DETECT_SOFTLOCKUP) || defined(CONFIG_HIGHMEM)
+static int one = 1;
+#endif
+
+#ifdef CONFIG_DETECT_SOFTLOCKUP
+static int sixty = 60;
+#endif
+
+#ifdef CONFIG_MMU
+static int two = 2;
+#endif
+
+static int zero;
+static int one_hundred = 100;
+
+/* this is needed for the proc_dointvec_minmax for [fs_]overflow UID and GID */
+static int maxolduid = 65535;
+static int minolduid;
+static int min_percpu_pagelist_fract = 8;
+
+static int ngroups_max = NGROUPS_MAX;
+
+#ifdef CONFIG_KMOD
+extern char modprobe_path[];
+#endif
+#ifdef CONFIG_CHR_DEV_SG
+extern int sg_big_buff;
+#endif
+
+#ifdef __sparc__
+extern char reboot_command [];
+extern int stop_a_enabled;
+extern int scons_pwroff;
+#endif
+
+#ifdef __hppa__
+extern int pwrsw_enabled;
+extern int unaligned_enabled;
+#endif
+
+#ifdef CONFIG_S390
+#ifdef CONFIG_MATHEMU
+extern int sysctl_ieee_emulation_warnings;
+#endif
+extern int sysctl_userprocess_debug;
+extern int spin_retry;
+#endif
+
+extern int sysctl_hz_timer;
+
+#ifdef CONFIG_BSD_PROCESS_ACCT
+extern int acct_parm[];
+#endif
+
+#ifdef CONFIG_IA64
+extern int no_unaligned_warning;
+#endif
+
+#ifdef CONFIG_RT_MUTEXES
+extern int max_lock_depth;
+#endif
+
+#ifdef CONFIG_PROC_SYSCTL
+static int proc_do_cad_pid(struct ctl_table *table, int write, struct file *filp,
+		  void __user *buffer, size_t *lenp, loff_t *ppos);
+static int proc_dointvec_taint(struct ctl_table *table, int write, struct file *filp,
+			       void __user *buffer, size_t *lenp, loff_t *ppos);
+#endif
+
+static struct ctl_table root_table[];
+static struct ctl_table_root sysctl_table_root;
+static struct ctl_table_header root_table_header = {
+	.ctl_table = root_table,
+	.ctl_entry = LIST_HEAD_INIT(sysctl_table_root.header_list),
+	.root = &sysctl_table_root,
+};
+static struct ctl_table_root sysctl_table_root = {
+	.root_list = LIST_HEAD_INIT(sysctl_table_root.root_list),
+	.header_list = LIST_HEAD_INIT(root_table_header.ctl_entry),
+};
+
+static struct ctl_table kern_table[];
+static struct ctl_table vm_table[];
+static struct ctl_table fs_table[];
+static struct ctl_table debug_table[];
+static struct ctl_table dev_table[];
+extern struct ctl_table random_table[];
+#ifdef CONFIG_INOTIFY_USER
+extern struct ctl_table inotify_table[];
+#endif
+
+#ifdef HAVE_ARCH_PICK_MMAP_LAYOUT
+int sysctl_legacy_va_layout;
+#endif
+
+extern int prove_locking;
+extern int lock_stat;
+
+/* The default sysctl tables: */
+
+static struct ctl_table root_table[] = {
+	{
+		.ctl_name	= CTL_KERN,
+		.procname	= "kernel",
+		.mode		= 0555,
+		.child		= kern_table,
+	},
+	{
+		.ctl_name	= CTL_VM,
+		.procname	= "vm",
+		.mode		= 0555,
+		.child		= vm_table,
+	},
+	{
+		.ctl_name	= CTL_FS,
+		.procname	= "fs",
+		.mode		= 0555,
+		.child		= fs_table,
+	},
+	{
+		.ctl_name	= CTL_DEBUG,
+		.procname	= "debug",
+		.mode		= 0555,
+		.child		= debug_table,
+	},
+	{
+		.ctl_name	= CTL_DEV,
+		.procname	= "dev",
+		.mode		= 0555,
+		.child		= dev_table,
+	},
+/*
+ * NOTE: do not add new entries to this table unless you have read
+ * Documentation/sysctl/ctl_unnumbered.txt
+ */
+	{ .ctl_name = 0 }
+};
+
+#ifdef CONFIG_SCHED_DEBUG
+static int min_sched_granularity_ns = 100000;		/* 100 usecs */
+static int max_sched_granularity_ns = NSEC_PER_SEC;	/* 1 second */
+static int min_wakeup_granularity_ns;			/* 0 usecs */
+static int max_wakeup_granularity_ns = NSEC_PER_SEC;	/* 1 second */
+#endif
+
+static struct ctl_table kern_table[] = {
+#ifdef CONFIG_SCHED_DEBUG
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "sched_min_granularity_ns",
+		.data		= &sysctl_sched_min_granularity,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= &sched_nr_latency_handler,
+		.strategy	= &sysctl_intvec,
+		.extra1		= &min_sched_granularity_ns,
+		.extra2		= &max_sched_granularity_ns,
+	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "sched_latency_ns",
+		.data		= &sysctl_sched_latency,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= &sched_nr_latency_handler,
+		.strategy	= &sysctl_intvec,
+		.extra1		= &min_sched_granularity_ns,
+		.extra2		= &max_sched_granularity_ns,
+	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "sched_wakeup_granularity_ns",
+		.data		= &sysctl_sched_wakeup_granularity,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_minmax,
+		.strategy	= &sysctl_intvec,
+		.extra1		= &min_wakeup_granularity_ns,
+		.extra2		= &max_wakeup_granularity_ns,
+	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "sched_child_runs_first",
+		.data		= &sysctl_sched_child_runs_first,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "sched_features",
+		.data		= &sysctl_sched_features,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "sched_migration_cost",
+		.data		= &sysctl_sched_migration_cost,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "sched_nr_migrate",
+		.data		= &sysctl_sched_nr_migrate,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
+#endif
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "sched_rt_period_us",
+		.data		= &sysctl_sched_rt_period,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= &sched_rt_handler,
+	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "sched_rt_runtime_us",
+		.data		= &sysctl_sched_rt_runtime,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &sched_rt_handler,
+	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "sched_compat_yield",
+		.data		= &sysctl_sched_compat_yield,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
+#ifdef CONFIG_PROVE_LOCKING
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "prove_locking",
+		.data		= &prove_locking,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
+#endif
+#ifdef CONFIG_LOCK_STAT
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "lock_stat",
+		.data		= &lock_stat,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
+#endif
+	{
+		.ctl_name	= KERN_PANIC,
+		.procname	= "panic",
+		.data		= &panic_timeout,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
+	{
+		.ctl_name	= KERN_CORE_USES_PID,
+		.procname	= "core_uses_pid",
+		.data		= &core_uses_pid,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
+	{
+		.ctl_name	= KERN_CORE_PATTERN,
+		.procname	= "core_pattern",
+		.data		= core_pattern,
+		.maxlen		= CORENAME_MAX_SIZE,
+		.mode		= 0644,
+		.proc_handler	= &proc_dostring,
+		.strategy	= &sysctl_string,
+	},
+#ifdef CONFIG_PROC_SYSCTL
+	{
+		.procname	= "tainted",
+		.data		= &tainted,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_taint,
+	},
+#endif
+#ifdef CONFIG_LATENCYTOP
+	{
+		.procname	= "latencytop",
+		.data		= &latencytop_enabled,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
+#endif
+#ifdef CONFIG_BLK_DEV_INITRD
+	{
+		.ctl_name	= KERN_REALROOTDEV,
+		.procname	= "real-root-dev",
+		.data		= &real_root_dev,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
+#endif
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "print-fatal-signals",
+		.data		= &print_fatal_signals,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
+#ifdef __sparc__
+	{
+		.ctl_name	= KERN_SPARC_REBOOT,
+		.procname	= "reboot-cmd",
+		.data		= reboot_command,
+		.maxlen		= 256,
+		.mode		= 0644,
+		.proc_handler	= &proc_dostring,
+		.strategy	= &sysctl_string,
+	},
+	{
+		.ctl_name	= KERN_SPARC_STOP_A,
+		.procname	= "stop-a",
+		.data		= &stop_a_enabled,
+		.maxlen		= sizeof (int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
+	{
+		.ctl_name	= KERN_SPARC_SCONS_PWROFF,
+		.procname	= "scons-poweroff",
+		.data		= &scons_pwroff,
+		.maxlen		= sizeof (int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
+#endif
+#ifdef __hppa__
+	{
+		.ctl_name	= KERN_HPPA_PWRSW,
+		.procname	= "soft-power",
+		.data		= &pwrsw_enabled,
+		.maxlen		= sizeof (int),
+	 	.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
+	{
+		.ctl_name	= KERN_HPPA_UNALIGNED,
+		.procname	= "unaligned-trap",
+		.data		= &unaligned_enabled,
+		.maxlen		= sizeof (int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
+#endif
+	{
+		.ctl_name	= KERN_CTLALTDEL,
+		.procname	= "ctrl-alt-del",
+		.data		= &C_A_D,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
+#ifdef CONFIG_KMOD
+	{
+		.ctl_name	= KERN_MODPROBE,
+		.procname	= "modprobe",
+		.data		= &modprobe_path,
+		.maxlen		= KMOD_PATH_LEN,
+		.mode		= 0644,
+		.proc_handler	= &proc_dostring,
+		.strategy	= &sysctl_string,
+	},
+#endif
+#if defined(CONFIG_HOTPLUG) && defined(CONFIG_NET)
+	{
+		.ctl_name	= KERN_HOTPLUG,
+		.procname	= "hotplug",
+		.data		= &uevent_helper,
+		.maxlen		= UEVENT_HELPER_PATH_LEN,
+		.mode		= 0644,
+		.proc_handler	= &proc_dostring,
+		.strategy	= &sysctl_string,
+	},
+#endif
+#ifdef CONFIG_CHR_DEV_SG
+	{
+		.ctl_name	= KERN_SG_BIG_BUFF,
+		.procname	= "sg-big-buff",
+		.data		= &sg_big_buff,
+		.maxlen		= sizeof (int),
+		.mode		= 0444,
+		.proc_handler	= &proc_dointvec,
+	},
+#endif
+#ifdef CONFIG_BSD_PROCESS_ACCT
+	{
+		.ctl_name	= KERN_ACCT,
+		.procname	= "acct",
+		.data		= &acct_parm,
+		.maxlen		= 3*sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
+#endif
+#ifdef CONFIG_MAGIC_SYSRQ
+	{
+		.ctl_name	= KERN_SYSRQ,
+		.procname	= "sysrq",
+		.data		= &__sysrq_enabled,
+		.maxlen		= sizeof (int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
+#endif
+#ifdef CONFIG_PROC_SYSCTL
+	{
+		.procname	= "cad_pid",
+		.data		= NULL,
+		.maxlen		= sizeof (int),
+		.mode		= 0600,
+		.proc_handler	= &proc_do_cad_pid,
+	},
+#endif
+	{
+		.ctl_name	= KERN_MAX_THREADS,
+		.procname	= "threads-max",
+		.data		= &max_threads,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
+	{
+		.ctl_name	= KERN_RANDOM,
+		.procname	= "random",
+		.mode		= 0555,
+		.child		= random_table,
+	},
+	{
+		.ctl_name	= KERN_OVERFLOWUID,
+		.procname	= "overflowuid",
+		.data		= &overflowuid,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_minmax,
+		.strategy	= &sysctl_intvec,
+		.extra1		= &minolduid,
+		.extra2		= &maxolduid,
+	},
+	{
+		.ctl_name	= KERN_OVERFLOWGID,
+		.procname	= "overflowgid",
+		.data		= &overflowgid,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_minmax,
+		.strategy	= &sysctl_intvec,
+		.extra1		= &minolduid,
+		.extra2		= &maxolduid,
+	},
+#ifdef CONFIG_S390
+#ifdef CONFIG_MATHEMU
+	{
+		.ctl_name	= KERN_IEEE_EMULATION_WARNINGS,
+		.procname	= "ieee_emulation_warnings",
+		.data		= &sysctl_ieee_emulation_warnings,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
+#endif
+#ifdef CONFIG_NO_IDLE_HZ
+	{
+		.ctl_name       = KERN_HZ_TIMER,
+		.procname       = "hz_timer",
+		.data           = &sysctl_hz_timer,
+		.maxlen         = sizeof(int),
+		.mode           = 0644,
+		.proc_handler   = &proc_dointvec,
+	},
+#endif
+	{
+		.ctl_name	= KERN_S390_USER_DEBUG_LOGGING,
+		.procname	= "userprocess_debug",
+		.data		= &sysctl_userprocess_debug,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
+#endif
+	{
+		.ctl_name	= KERN_PIDMAX,
+		.procname	= "pid_max",
+		.data		= &pid_max,
+		.maxlen		= sizeof (int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_minmax,
+		.strategy	= sysctl_intvec,
+		.extra1		= &pid_max_min,
+		.extra2		= &pid_max_max,
+	},
+	{
+		.ctl_name	= KERN_PANIC_ON_OOPS,
+		.procname	= "panic_on_oops",
+		.data		= &panic_on_oops,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
+#if defined CONFIG_PRINTK
+	{
+		.ctl_name	= KERN_PRINTK,
+		.procname	= "printk",
+		.data		= &console_loglevel,
+		.maxlen		= 4*sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
+	{
+		.ctl_name	= KERN_PRINTK_RATELIMIT,
+		.procname	= "printk_ratelimit",
+		.data		= &printk_ratelimit_jiffies,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_jiffies,
+		.strategy	= &sysctl_jiffies,
+	},
+	{
+		.ctl_name	= KERN_PRINTK_RATELIMIT_BURST,
+		.procname	= "printk_ratelimit_burst",
+		.data		= &printk_ratelimit_burst,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
+#endif
+	{
+		.ctl_name	= KERN_NGROUPS_MAX,
+		.procname	= "ngroups_max",
+		.data		= &ngroups_max,
+		.maxlen		= sizeof (int),
+		.mode		= 0444,
+		.proc_handler	= &proc_dointvec,
+	},
+#if defined(CONFIG_X86_LOCAL_APIC) && defined(CONFIG_X86)
+	{
+		.ctl_name       = KERN_UNKNOWN_NMI_PANIC,
+		.procname       = "unknown_nmi_panic",
+		.data           = &unknown_nmi_panic,
+		.maxlen         = sizeof (int),
+		.mode           = 0644,
+		.proc_handler   = &proc_dointvec,
+	},
+	{
+		.procname       = "nmi_watchdog",
+		.data           = &nmi_watchdog_enabled,
+		.maxlen         = sizeof (int),
+		.mode           = 0644,
+		.proc_handler   = &proc_nmi_enabled,
+	},
+#endif
+#if defined(CONFIG_X86)
+	{
+		.ctl_name	= KERN_PANIC_ON_NMI,
+		.procname	= "panic_on_unrecovered_nmi",
+		.data		= &panic_on_unrecovered_nmi,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
+	{
+		.ctl_name	= KERN_BOOTLOADER_TYPE,
+		.procname	= "bootloader_type",
+		.data		= &bootloader_type,
+		.maxlen		= sizeof (int),
+		.mode		= 0444,
+		.proc_handler	= &proc_dointvec,
+	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "kstack_depth_to_print",
+		.data		= &kstack_depth_to_print,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "io_delay_type",
+		.data		= &io_delay_type,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
+#endif
+#if defined(CONFIG_MMU)
+	{
+		.ctl_name	= KERN_RANDOMIZE,
+		.procname	= "randomize_va_space",
+		.data		= &randomize_va_space,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
+#endif
+#if defined(CONFIG_S390) && defined(CONFIG_SMP)
+	{
+		.ctl_name	= KERN_SPIN_RETRY,
+		.procname	= "spin_retry",
+		.data		= &spin_retry,
+		.maxlen		= sizeof (int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
+#endif
+#if	defined(CONFIG_ACPI_SLEEP) && defined(CONFIG_X86)
+	{
+		.procname	= "acpi_video_flags",
+		.data		= &acpi_realmode_flags,
+		.maxlen		= sizeof (unsigned long),
+		.mode		= 0644,
+		.proc_handler	= &proc_doulongvec_minmax,
+	},
+#endif
+#ifdef CONFIG_IA64
+	{
+		.ctl_name	= KERN_IA64_UNALIGNED,
+		.procname	= "ignore-unaligned-usertrap",
+		.data		= &no_unaligned_warning,
+		.maxlen		= sizeof (int),
+	 	.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
+#endif
+#ifdef CONFIG_DETECT_SOFTLOCKUP
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "softlockup_thresh",
+		.data		= &softlockup_thresh,
+		.maxlen		= sizeof(unsigned long),
+		.mode		= 0644,
+		.proc_handler	= &proc_doulongvec_minmax,
+		.strategy	= &sysctl_intvec,
+		.extra1		= &one,
+		.extra2		= &sixty,
+	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "hung_task_check_count",
+		.data		= &sysctl_hung_task_check_count,
+		.maxlen		= sizeof(unsigned long),
+		.mode		= 0644,
+		.proc_handler	= &proc_doulongvec_minmax,
+		.strategy	= &sysctl_intvec,
+	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "hung_task_timeout_secs",
+		.data		= &sysctl_hung_task_timeout_secs,
+		.maxlen		= sizeof(unsigned long),
+		.mode		= 0644,
+		.proc_handler	= &proc_doulongvec_minmax,
+		.strategy	= &sysctl_intvec,
+	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "hung_task_warnings",
+		.data		= &sysctl_hung_task_warnings,
+		.maxlen		= sizeof(unsigned long),
+		.mode		= 0644,
+		.proc_handler	= &proc_doulongvec_minmax,
+		.strategy	= &sysctl_intvec,
+	},
+#endif
+#ifdef CONFIG_COMPAT
+	{
+		.ctl_name	= KERN_COMPAT_LOG,
+		.procname	= "compat-log",
+		.data		= &compat_log,
+		.maxlen		= sizeof (int),
+	 	.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
+#endif
+#ifdef CONFIG_RT_MUTEXES
+	{
+		.ctl_name	= KERN_MAX_LOCK_DEPTH,
+		.procname	= "max_lock_depth",
+		.data		= &max_lock_depth,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
+#endif
+#ifdef CONFIG_PROC_FS
+	{
+		.ctl_name       = CTL_UNNUMBERED,
+		.procname       = "maps_protect",
+		.data           = &maps_protect,
+		.maxlen         = sizeof(int),
+		.mode           = 0644,
+		.proc_handler   = &proc_dointvec,
+	},
+#endif
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "poweroff_cmd",
+		.data		= &poweroff_cmd,
+		.maxlen		= POWEROFF_CMD_PATH_LEN,
+		.mode		= 0644,
+		.proc_handler	= &proc_dostring,
+		.strategy	= &sysctl_string,
+	},
+#ifdef CONFIG_KEYS
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "keys",
+		.mode		= 0555,
+		.child		= key_sysctls,
+	},
+#endif
+/*
+ * NOTE: do not add new entries to this table unless you have read
+ * Documentation/sysctl/ctl_unnumbered.txt
+ */
+	{ .ctl_name = 0 }
+};
+
+static struct ctl_table vm_table[] = {
+	{
+		.ctl_name	= VM_OVERCOMMIT_MEMORY,
+		.procname	= "overcommit_memory",
+		.data		= &sysctl_overcommit_memory,
+		.maxlen		= sizeof(sysctl_overcommit_memory),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
+	{
+		.ctl_name	= VM_PANIC_ON_OOM,
+		.procname	= "panic_on_oom",
+		.data		= &sysctl_panic_on_oom,
+		.maxlen		= sizeof(sysctl_panic_on_oom),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "oom_kill_allocating_task",
+		.data		= &sysctl_oom_kill_allocating_task,
+		.maxlen		= sizeof(sysctl_oom_kill_allocating_task),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "oom_dump_tasks",
+		.data		= &sysctl_oom_dump_tasks,
+		.maxlen		= sizeof(sysctl_oom_dump_tasks),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
+	{
+		.ctl_name	= VM_OVERCOMMIT_RATIO,
+		.procname	= "overcommit_ratio",
+		.data		= &sysctl_overcommit_ratio,
+		.maxlen		= sizeof(sysctl_overcommit_ratio),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
+	{
+		.ctl_name	= VM_PAGE_CLUSTER,
+		.procname	= "page-cluster", 
+		.data		= &page_cluster,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
+	{
+		.ctl_name	= VM_DIRTY_BACKGROUND,
+		.procname	= "dirty_background_ratio",
+		.data		= &dirty_background_ratio,
+		.maxlen		= sizeof(dirty_background_ratio),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_minmax,
+		.strategy	= &sysctl_intvec,
+		.extra1		= &zero,
+		.extra2		= &one_hundred,
+	},
+	{
+		.ctl_name	= VM_DIRTY_RATIO,
+		.procname	= "dirty_ratio",
+		.data		= &vm_dirty_ratio,
+		.maxlen		= sizeof(vm_dirty_ratio),
+		.mode		= 0644,
+		.proc_handler	= &dirty_ratio_handler,
+		.strategy	= &sysctl_intvec,
+		.extra1		= &zero,
+		.extra2		= &one_hundred,
+	},
+	{
+		.procname	= "dirty_writeback_centisecs",
+		.data		= &dirty_writeback_interval,
+		.maxlen		= sizeof(dirty_writeback_interval),
+		.mode		= 0644,
+		.proc_handler	= &dirty_writeback_centisecs_handler,
+	},
+	{
+		.procname	= "dirty_expire_centisecs",
+		.data		= &dirty_expire_interval,
+		.maxlen		= sizeof(dirty_expire_interval),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_userhz_jiffies,
+	},
+	{
+		.ctl_name	= VM_NR_PDFLUSH_THREADS,
+		.procname	= "nr_pdflush_threads",
+		.data		= &nr_pdflush_threads,
+		.maxlen		= sizeof nr_pdflush_threads,
+		.mode		= 0444 /* read-only*/,
+		.proc_handler	= &proc_dointvec,
+	},
+	{
+		.ctl_name	= VM_SWAPPINESS,
+		.procname	= "swappiness",
+		.data		= &vm_swappiness,
+		.maxlen		= sizeof(vm_swappiness),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_minmax,
+		.strategy	= &sysctl_intvec,
+		.extra1		= &zero,
+		.extra2		= &one_hundred,
+	},
+#ifdef CONFIG_HUGETLB_PAGE
+	 {
+		.procname	= "nr_hugepages",
+		.data		= &max_huge_pages,
+		.maxlen		= sizeof(unsigned long),
+		.mode		= 0644,
+		.proc_handler	= &hugetlb_sysctl_handler,
+		.extra1		= (void *)&hugetlb_zero,
+		.extra2		= (void *)&hugetlb_infinity,
+	 },
+	 {
+		.ctl_name	= VM_HUGETLB_GROUP,
+		.procname	= "hugetlb_shm_group",
+		.data		= &sysctl_hugetlb_shm_group,
+		.maxlen		= sizeof(gid_t),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	 },
+	 {
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "hugepages_treat_as_movable",
+		.data		= &hugepages_treat_as_movable,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &hugetlb_treat_movable_handler,
+	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "nr_overcommit_hugepages",
+		.data		= &sysctl_overcommit_huge_pages,
+		.maxlen		= sizeof(sysctl_overcommit_huge_pages),
+		.mode		= 0644,
+		.proc_handler	= &hugetlb_overcommit_handler,
+	},
+#endif
+	{
+		.ctl_name	= VM_LOWMEM_RESERVE_RATIO,
+		.procname	= "lowmem_reserve_ratio",
+		.data		= &sysctl_lowmem_reserve_ratio,
+		.maxlen		= sizeof(sysctl_lowmem_reserve_ratio),
+		.mode		= 0644,
+		.proc_handler	= &lowmem_reserve_ratio_sysctl_handler,
+		.strategy	= &sysctl_intvec,
+	},
+	{
+		.ctl_name	= VM_DROP_PAGECACHE,
+		.procname	= "drop_caches",
+		.data		= &sysctl_drop_caches,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= drop_caches_sysctl_handler,
+		.strategy	= &sysctl_intvec,
+	},
+	{
+		.ctl_name	= VM_MIN_FREE_KBYTES,
+		.procname	= "min_free_kbytes",
+		.data		= &min_free_kbytes,
+		.maxlen		= sizeof(min_free_kbytes),
+		.mode		= 0644,
+		.proc_handler	= &min_free_kbytes_sysctl_handler,
+		.strategy	= &sysctl_intvec,
+		.extra1		= &zero,
+	},
+	{
+		.ctl_name	= VM_PERCPU_PAGELIST_FRACTION,
+		.procname	= "percpu_pagelist_fraction",
+		.data		= &percpu_pagelist_fraction,
+		.maxlen		= sizeof(percpu_pagelist_fraction),
+		.mode		= 0644,
+		.proc_handler	= &percpu_pagelist_fraction_sysctl_handler,
+		.strategy	= &sysctl_intvec,
+		.extra1		= &min_percpu_pagelist_fract,
+	},
+#ifdef CONFIG_MMU
+	{
+		.ctl_name	= VM_MAX_MAP_COUNT,
+		.procname	= "max_map_count",
+		.data		= &sysctl_max_map_count,
+		.maxlen		= sizeof(sysctl_max_map_count),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec
+	},
+#endif
+	{
+		.ctl_name	= VM_LAPTOP_MODE,
+		.procname	= "laptop_mode",
+		.data		= &laptop_mode,
+		.maxlen		= sizeof(laptop_mode),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_jiffies,
+		.strategy	= &sysctl_jiffies,
+	},
+	{
+		.ctl_name	= VM_BLOCK_DUMP,
+		.procname	= "block_dump",
+		.data		= &block_dump,
+		.maxlen		= sizeof(block_dump),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+		.strategy	= &sysctl_intvec,
+		.extra1		= &zero,
+	},
+	{
+		.ctl_name	= VM_VFS_CACHE_PRESSURE,
+		.procname	= "vfs_cache_pressure",
+		.data		= &sysctl_vfs_cache_pressure,
+		.maxlen		= sizeof(sysctl_vfs_cache_pressure),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+		.strategy	= &sysctl_intvec,
+		.extra1		= &zero,
+	},
+#ifdef HAVE_ARCH_PICK_MMAP_LAYOUT
+	{
+		.ctl_name	= VM_LEGACY_VA_LAYOUT,
+		.procname	= "legacy_va_layout",
+		.data		= &sysctl_legacy_va_layout,
+		.maxlen		= sizeof(sysctl_legacy_va_layout),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+		.strategy	= &sysctl_intvec,
+		.extra1		= &zero,
+	},
+#endif
+#ifdef CONFIG_NUMA
+	{
+		.ctl_name	= VM_ZONE_RECLAIM_MODE,
+		.procname	= "zone_reclaim_mode",
+		.data		= &zone_reclaim_mode,
+		.maxlen		= sizeof(zone_reclaim_mode),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+		.strategy	= &sysctl_intvec,
+		.extra1		= &zero,
+	},
+	{
+		.ctl_name	= VM_MIN_UNMAPPED,
+		.procname	= "min_unmapped_ratio",
+		.data		= &sysctl_min_unmapped_ratio,
+		.maxlen		= sizeof(sysctl_min_unmapped_ratio),
+		.mode		= 0644,
+		.proc_handler	= &sysctl_min_unmapped_ratio_sysctl_handler,
+		.strategy	= &sysctl_intvec,
+		.extra1		= &zero,
+		.extra2		= &one_hundred,
+	},
+	{
+		.ctl_name	= VM_MIN_SLAB,
+		.procname	= "min_slab_ratio",
+		.data		= &sysctl_min_slab_ratio,
+		.maxlen		= sizeof(sysctl_min_slab_ratio),
+		.mode		= 0644,
+		.proc_handler	= &sysctl_min_slab_ratio_sysctl_handler,
+		.strategy	= &sysctl_intvec,
+		.extra1		= &zero,
+		.extra2		= &one_hundred,
+	},
+#endif
+#ifdef CONFIG_SMP
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "stat_interval",
+		.data		= &sysctl_stat_interval,
+		.maxlen		= sizeof(sysctl_stat_interval),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_jiffies,
+		.strategy	= &sysctl_jiffies,
+	},
+#endif
+#ifdef CONFIG_SECURITY
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "mmap_min_addr",
+		.data		= &mmap_min_addr,
+		.maxlen         = sizeof(unsigned long),
+		.mode		= 0644,
+		.proc_handler	= &proc_doulongvec_minmax,
+	},
+#endif
+#ifdef CONFIG_NUMA
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "numa_zonelist_order",
+		.data		= &numa_zonelist_order,
+		.maxlen		= NUMA_ZONELIST_ORDER_LEN,
+		.mode		= 0644,
+		.proc_handler	= &numa_zonelist_order_handler,
+		.strategy	= &sysctl_string,
+	},
+#endif
+#if (defined(CONFIG_X86_32) && !defined(CONFIG_UML))|| \
+   (defined(CONFIG_SUPERH) && defined(CONFIG_VSYSCALL))
+	{
+		.ctl_name	= VM_VDSO_ENABLED,
+		.procname	= "vdso_enabled",
+		.data		= &vdso_enabled,
+		.maxlen		= sizeof(vdso_enabled),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+		.strategy	= &sysctl_intvec,
+		.extra1		= &zero,
+	},
+#endif
+#ifdef CONFIG_HIGHMEM
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "highmem_is_dirtyable",
+		.data		= &vm_highmem_is_dirtyable,
+		.maxlen		= sizeof(vm_highmem_is_dirtyable),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_minmax,
+		.strategy	= &sysctl_intvec,
+		.extra1		= &zero,
+		.extra2		= &one,
+	},
+#endif
+/*
+ * NOTE: do not add new entries to this table unless you have read
+ * Documentation/sysctl/ctl_unnumbered.txt
+ */
+	{ .ctl_name = 0 }
+};
+
+#if defined(CONFIG_BINFMT_MISC) || defined(CONFIG_BINFMT_MISC_MODULE)
+static struct ctl_table binfmt_misc_table[] = {
+	{ .ctl_name = 0 }
+};
+#endif
+
+static struct ctl_table fs_table[] = {
+	{
+		.ctl_name	= FS_NRINODE,
+		.procname	= "inode-nr",
+		.data		= &inodes_stat,
+		.maxlen		= 2*sizeof(int),
+		.mode		= 0444,
+		.proc_handler	= &proc_dointvec,
+	},
+	{
+		.ctl_name	= FS_STATINODE,
+		.procname	= "inode-state",
+		.data		= &inodes_stat,
+		.maxlen		= 7*sizeof(int),
+		.mode		= 0444,
+		.proc_handler	= &proc_dointvec,
+	},
+	{
+		.procname	= "file-nr",
+		.data		= &files_stat,
+		.maxlen		= 3*sizeof(int),
+		.mode		= 0444,
+		.proc_handler	= &proc_nr_files,
+	},
+	{
+		.ctl_name	= FS_MAXFILE,
+		.procname	= "file-max",
+		.data		= &files_stat.max_files,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "nr_open",
+		.data		= &sysctl_nr_open,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_minmax,
+		.extra1		= &sysctl_nr_open_min,
+		.extra2		= &sysctl_nr_open_max,
+	},
+	{
+		.ctl_name	= FS_DENTRY,
+		.procname	= "dentry-state",
+		.data		= &dentry_stat,
+		.maxlen		= 6*sizeof(int),
+		.mode		= 0444,
+		.proc_handler	= &proc_dointvec,
+	},
+	{
+		.ctl_name	= FS_OVERFLOWUID,
+		.procname	= "overflowuid",
+		.data		= &fs_overflowuid,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_minmax,
+		.strategy	= &sysctl_intvec,
+		.extra1		= &minolduid,
+		.extra2		= &maxolduid,
+	},
+	{
+		.ctl_name	= FS_OVERFLOWGID,
+		.procname	= "overflowgid",
+		.data		= &fs_overflowgid,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_minmax,
+		.strategy	= &sysctl_intvec,
+		.extra1		= &minolduid,
+		.extra2		= &maxolduid,
+	},
+	{
+		.ctl_name	= FS_LEASES,
+		.procname	= "leases-enable",
+		.data		= &leases_enable,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
+#ifdef CONFIG_DNOTIFY
+	{
+		.ctl_name	= FS_DIR_NOTIFY,
+		.procname	= "dir-notify-enable",
+		.data		= &dir_notify_enable,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
+#endif
+#ifdef CONFIG_MMU
+	{
+		.ctl_name	= FS_LEASE_TIME,
+		.procname	= "lease-break-time",
+		.data		= &lease_break_time,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_minmax,
+		.strategy	= &sysctl_intvec,
+		.extra1		= &zero,
+		.extra2		= &two,
+	},
+	{
+		.procname	= "aio-nr",
+		.data		= &aio_nr,
+		.maxlen		= sizeof(aio_nr),
+		.mode		= 0444,
+		.proc_handler	= &proc_doulongvec_minmax,
+	},
+	{
+		.procname	= "aio-max-nr",
+		.data		= &aio_max_nr,
+		.maxlen		= sizeof(aio_max_nr),
+		.mode		= 0644,
+		.proc_handler	= &proc_doulongvec_minmax,
+	},
+#ifdef CONFIG_INOTIFY_USER
+	{
+		.ctl_name	= FS_INOTIFY,
+		.procname	= "inotify",
+		.mode		= 0555,
+		.child		= inotify_table,
+	},
+#endif	
+#endif
+	{
+		.ctl_name	= KERN_SETUID_DUMPABLE,
+		.procname	= "suid_dumpable",
+		.data		= &suid_dumpable,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
+#if defined(CONFIG_BINFMT_MISC) || defined(CONFIG_BINFMT_MISC_MODULE)
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "binfmt_misc",
+		.mode		= 0555,
+		.child		= binfmt_misc_table,
+	},
+#endif
+/*
+ * NOTE: do not add new entries to this table unless you have read
+ * Documentation/sysctl/ctl_unnumbered.txt
+ */
+	{ .ctl_name = 0 }
+};
+
+static struct ctl_table debug_table[] = {
+#if defined(CONFIG_X86) || defined(CONFIG_PPC)
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "exception-trace",
+		.data		= &show_unhandled_signals,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec
+	},
+#endif
+	{ .ctl_name = 0 }
+};
+
+static struct ctl_table dev_table[] = {
+	{ .ctl_name = 0 }
+};
+
+static DEFINE_SPINLOCK(sysctl_lock);
+
+/* called under sysctl_lock */
+static int use_table(struct ctl_table_header *p)
+{
+	if (unlikely(p->unregistering))
+		return 0;
+	p->used++;
+	return 1;
+}
+
+/* called under sysctl_lock */
+static void unuse_table(struct ctl_table_header *p)
+{
+	if (!--p->used)
+		if (unlikely(p->unregistering))
+			complete(p->unregistering);
+}
+
+/* called under sysctl_lock, will reacquire if has to wait */
+static void start_unregistering(struct ctl_table_header *p)
+{
+	/*
+	 * if p->used is 0, nobody will ever touch that entry again;
+	 * we'll eliminate all paths to it before dropping sysctl_lock
+	 */
+	if (unlikely(p->used)) {
+		struct completion wait;
+		init_completion(&wait);
+		p->unregistering = &wait;
+		spin_unlock(&sysctl_lock);
+		wait_for_completion(&wait);
+		spin_lock(&sysctl_lock);
+	}
+	/*
+	 * do not remove from the list until nobody holds it; walking the
+	 * list in do_sysctl() relies on that.
+	 */
+	list_del_init(&p->ctl_entry);
+}
+
+void sysctl_head_finish(struct ctl_table_header *head)
+{
+	if (!head)
+		return;
+	spin_lock(&sysctl_lock);
+	unuse_table(head);
+	spin_unlock(&sysctl_lock);
+}
+
+static struct list_head *
+lookup_header_list(struct ctl_table_root *root, struct nsproxy *namespaces)
+{
+	struct list_head *header_list;
+	header_list = &root->header_list;
+	if (root->lookup)
+		header_list = root->lookup(root, namespaces);
+	return header_list;
+}
+
+struct ctl_table_header *__sysctl_head_next(struct nsproxy *namespaces,
+					    struct ctl_table_header *prev)
+{
+	struct ctl_table_root *root;
+	struct list_head *header_list;
+	struct ctl_table_header *head;
+	struct list_head *tmp;
+
+	spin_lock(&sysctl_lock);
+	if (prev) {
+		head = prev;
+		tmp = &prev->ctl_entry;
+		unuse_table(prev);
+		goto next;
+	}
+	tmp = &root_table_header.ctl_entry;
+	for (;;) {
+		head = list_entry(tmp, struct ctl_table_header, ctl_entry);
+
+		if (!use_table(head))
+			goto next;
+		spin_unlock(&sysctl_lock);
+		return head;
+	next:
+		root = head->root;
+		tmp = tmp->next;
+		header_list = lookup_header_list(root, namespaces);
+		if (tmp != header_list)
+			continue;
+
+		do {
+			root = list_entry(root->root_list.next,
+					struct ctl_table_root, root_list);
+			if (root == &sysctl_table_root)
+				goto out;
+			header_list = lookup_header_list(root, namespaces);
+		} while (list_empty(header_list));
+		tmp = header_list->next;
+	}
+out:
+	spin_unlock(&sysctl_lock);
+	return NULL;
+}
+
+struct ctl_table_header *sysctl_head_next(struct ctl_table_header *prev)
+{
+	return __sysctl_head_next(current->nsproxy, prev);
+}
+
+void register_sysctl_root(struct ctl_table_root *root)
+{
+	spin_lock(&sysctl_lock);
+	list_add_tail(&root->root_list, &sysctl_table_root.root_list);
+	spin_unlock(&sysctl_lock);
+}
+
+#ifdef CONFIG_SYSCTL_SYSCALL
+/* Perform the actual read/write of a sysctl table entry. */
+static int do_sysctl_strategy(struct ctl_table_root *root,
+			struct ctl_table *table,
+			int __user *name, int nlen,
+			void __user *oldval, size_t __user *oldlenp,
+			void __user *newval, size_t newlen)
+{
+	int op = 0, rc;
+
+	if (oldval)
+		op |= 004;
+	if (newval)
+		op |= 002;
+	if (sysctl_perm(root, table, op))
+		return -EPERM;
+
+	if (table->strategy) {
+		rc = table->strategy(table, name, nlen, oldval, oldlenp,
+				     newval, newlen);
+		if (rc < 0)
+			return rc;
+		if (rc > 0)
+			return 0;
+	}
+
+	/* If there is no strategy routine, or if the strategy returns
+	 * zero, proceed with automatic r/w */
+	if (table->data && table->maxlen) {
+		rc = sysctl_data(table, name, nlen, oldval, oldlenp,
+				 newval, newlen);
+		if (rc < 0)
+			return rc;
+	}
+	return 0;
+}
+
+static int parse_table(int __user *name, int nlen,
+		       void __user *oldval, size_t __user *oldlenp,
+		       void __user *newval, size_t newlen,
+		       struct ctl_table_root *root,
+		       struct ctl_table *table)
+{
+	int n;
+repeat:
+	if (!nlen)
+		return -ENOTDIR;
+	if (get_user(n, name))
+		return -EFAULT;
+	for ( ; table->ctl_name || table->procname; table++) {
+		if (!table->ctl_name)
+			continue;
+		if (n == table->ctl_name) {
+			int error;
+			if (table->child) {
+				if (sysctl_perm(root, table, 001))
+					return -EPERM;
+				name++;
+				nlen--;
+				table = table->child;
+				goto repeat;
+			}
+			error = do_sysctl_strategy(root, table, name, nlen,
+						   oldval, oldlenp,
+						   newval, newlen);
+			return error;
+		}
+	}
+	return -ENOTDIR;
+}
+
+int do_sysctl(int __user *name, int nlen, void __user *oldval, size_t __user *oldlenp,
+	       void __user *newval, size_t newlen)
+{
+	struct ctl_table_header *head;
+	int error = -ENOTDIR;
+
+	if (nlen <= 0 || nlen >= CTL_MAXNAME)
+		return -ENOTDIR;
+	if (oldval) {
+		int old_len;
+		if (!oldlenp || get_user(old_len, oldlenp))
+			return -EFAULT;
+	}
+
+	for (head = sysctl_head_next(NULL); head;
+			head = sysctl_head_next(head)) {
+		error = parse_table(name, nlen, oldval, oldlenp, 
+					newval, newlen,
+					head->root, head->ctl_table);
+		if (error != -ENOTDIR) {
+			sysctl_head_finish(head);
+			break;
+		}
+	}
+	return error;
+}
+
+asmlinkage long sys_sysctl(struct __sysctl_args __user *args)
+{
+	struct __sysctl_args tmp;
+	int error;
+
+	if (copy_from_user(&tmp, args, sizeof(tmp)))
+		return -EFAULT;
+
+	error = deprecated_sysctl_warning(&tmp);
+	if (error)
+		goto out;
+
+	lock_kernel();
+	error = do_sysctl(tmp.name, tmp.nlen, tmp.oldval, tmp.oldlenp,
+			  tmp.newval, tmp.newlen);
+	unlock_kernel();
+out:
+	return error;
+}
+#endif /* CONFIG_SYSCTL_SYSCALL */
+
+/*
+ * sysctl_perm does NOT grant the superuser all rights automatically, because
+ * some sysctl variables are readonly even to root.
+ */
+
+static int test_perm(int mode, int op)
+{
+	if (!current->euid)
+		mode >>= 6;
+	else if (in_egroup_p(0))
+		mode >>= 3;
+	if ((mode & op & 0007) == op)
+		return 0;
+	return -EACCES;
+}
+
+int sysctl_perm(struct ctl_table_root *root, struct ctl_table *table, int op)
+{
+	int error;
+	int mode;
+
+	error = security_sysctl(table, op);
+	if (error)
+		return error;
+
+	if (root->permissions)
+		mode = root->permissions(root, current->nsproxy, table);
+	else
+		mode = table->mode;
+
+	return test_perm(mode, op);
+}
+
+static void sysctl_set_parent(struct ctl_table *parent, struct ctl_table *table)
+{
+	for (; table->ctl_name || table->procname; table++) {
+		table->parent = parent;
+		if (table->child)
+			sysctl_set_parent(table, table->child);
+	}
+}
+
+static __init int sysctl_init(void)
+{
+	sysctl_set_parent(NULL, root_table);
+#ifdef CONFIG_SYSCTL_SYSCALL_CHECK
+	{
+		int err;
+		err = sysctl_check_table(current->nsproxy, root_table);
+	}
+#endif
+	return 0;
+}
+
+core_initcall(sysctl_init);
+
+/**
+ * __register_sysctl_paths - register a sysctl hierarchy
+ * @root: List of sysctl headers to register on
+ * @namespaces: Data to compute which lists of sysctl entries are visible
+ * @path: The path to the directory the sysctl table is in.
+ * @table: the top-level table structure
+ *
+ * Register a sysctl table hierarchy. @table should be a filled in ctl_table
+ * array. A completely 0 filled entry terminates the table.
+ *
+ * The members of the &struct ctl_table structure are used as follows:
+ *
+ * ctl_name - This is the numeric sysctl value used by sysctl(2). The number
+ *            must be unique within that level of sysctl
+ *
+ * procname - the name of the sysctl file under /proc/sys. Set to %NULL to not
+ *            enter a sysctl file
+ *
+ * data - a pointer to data for use by proc_handler
+ *
+ * maxlen - the maximum size in bytes of the data
+ *
+ * mode - the file permissions for the /proc/sys file, and for sysctl(2)
+ *
+ * child - a pointer to the child sysctl table if this entry is a directory, or
+ *         %NULL.
+ *
+ * proc_handler - the text handler routine (described below)
+ *
+ * strategy - the strategy routine (described below)
+ *
+ * de - for internal use by the sysctl routines
+ *
+ * extra1, extra2 - extra pointers usable by the proc handler routines
+ *
+ * Leaf nodes in the sysctl tree will be represented by a single file
+ * under /proc; non-leaf nodes will be represented by directories.
+ *
+ * sysctl(2) can automatically manage read and write requests through
+ * the sysctl table.  The data and maxlen fields of the ctl_table
+ * struct enable minimal validation of the values being written to be
+ * performed, and the mode field allows minimal authentication.
+ *
+ * More sophisticated management can be enabled by the provision of a
+ * strategy routine with the table entry.  This will be called before
+ * any automatic read or write of the data is performed.
+ *
+ * The strategy routine may return
+ *
+ * < 0 - Error occurred (error is passed to user process)
+ *
+ * 0   - OK - proceed with automatic read or write.
+ *
+ * > 0 - OK - read or write has been done by the strategy routine, so
+ *       return immediately.
+ *
+ * There must be a proc_handler routine for any terminal nodes
+ * mirrored under /proc/sys (non-terminals are handled by a built-in
+ * directory handler).  Several default handlers are available to
+ * cover common cases -
+ *
+ * proc_dostring(), proc_dointvec(), proc_dointvec_jiffies(),
+ * proc_dointvec_userhz_jiffies(), proc_dointvec_minmax(), 
+ * proc_doulongvec_ms_jiffies_minmax(), proc_doulongvec_minmax()
+ *
+ * It is the handler's job to read the input buffer from user memory
+ * and process it. The handler should return 0 on success.
+ *
+ * This routine returns %NULL on a failure to register, and a pointer
+ * to the table header on success.
+ */
+struct ctl_table_header *__register_sysctl_paths(
+	struct ctl_table_root *root,
+	struct nsproxy *namespaces,
+	const struct ctl_path *path, struct ctl_table *table)
+{
+	struct list_head *header_list;
+	struct ctl_table_header *header;
+	struct ctl_table *new, **prevp;
+	unsigned int n, npath;
+
+	/* Count the path components */
+	for (npath = 0; path[npath].ctl_name || path[npath].procname; ++npath)
+		;
+
+	/*
+	 * For each path component, allocate a 2-element ctl_table array.
+	 * The first array element will be filled with the sysctl entry
+	 * for this, the second will be the sentinel (ctl_name == 0).
+	 *
+	 * We allocate everything in one go so that we don't have to
+	 * worry about freeing additional memory in unregister_sysctl_table.
+	 */
+	header = kzalloc(sizeof(struct ctl_table_header) +
+			 (2 * npath * sizeof(struct ctl_table)), GFP_KERNEL);
+	if (!header)
+		return NULL;
+
+	new = (struct ctl_table *) (header + 1);
+
+	/* Now connect the dots */
+	prevp = &header->ctl_table;
+	for (n = 0; n < npath; ++n, ++path) {
+		/* Copy the procname */
+		new->procname = path->procname;
+		new->ctl_name = path->ctl_name;
+		new->mode     = 0555;
+
+		*prevp = new;
+		prevp = &new->child;
+
+		new += 2;
+	}
+	*prevp = table;
+	header->ctl_table_arg = table;
+
+	INIT_LIST_HEAD(&header->ctl_entry);
+	header->used = 0;
+	header->unregistering = NULL;
+	header->root = root;
+	sysctl_set_parent(NULL, header->ctl_table);
+#ifdef CONFIG_SYSCTL_SYSCALL_CHECK
+	if (sysctl_check_table(namespaces, header->ctl_table)) {
+		kfree(header);
+		return NULL;
+	}
+#endif
+	spin_lock(&sysctl_lock);
+	header_list = lookup_header_list(root, namespaces);
+	list_add_tail(&header->ctl_entry, header_list);
+	spin_unlock(&sysctl_lock);
+
+	return header;
+}
+
+/**
+ * register_sysctl_table_path - register a sysctl table hierarchy
+ * @path: The path to the directory the sysctl table is in.
+ * @table: the top-level table structure
+ *
+ * Register a sysctl table hierarchy. @table should be a filled in ctl_table
+ * array. A completely 0 filled entry terminates the table.
+ *
+ * See __register_sysctl_paths for more details.
+ */
+struct ctl_table_header *register_sysctl_paths(const struct ctl_path *path,
+						struct ctl_table *table)
+{
+	return __register_sysctl_paths(&sysctl_table_root, current->nsproxy,
+					path, table);
+}
+
+/**
+ * register_sysctl_table - register a sysctl table hierarchy
+ * @table: the top-level table structure
+ *
+ * Register a sysctl table hierarchy. @table should be a filled in ctl_table
+ * array. A completely 0 filled entry terminates the table.
+ *
+ * See register_sysctl_paths for more details.
+ */
+struct ctl_table_header *register_sysctl_table(struct ctl_table *table)
+{
+	static const struct ctl_path null_path[] = { {} };
+
+	return register_sysctl_paths(null_path, table);
+}
+
+/**
+ * unregister_sysctl_table - unregister a sysctl table hierarchy
+ * @header: the header returned from register_sysctl_table
+ *
+ * Unregisters the sysctl table and all children. proc entries may not
+ * actually be removed until they are no longer used by anyone.
+ */
+void unregister_sysctl_table(struct ctl_table_header * header)
+{
+	might_sleep();
+
+	if (header == NULL)
+		return;
+
+	spin_lock(&sysctl_lock);
+	start_unregistering(header);
+	spin_unlock(&sysctl_lock);
+	kfree(header);
+}
+
+#else /* !CONFIG_SYSCTL */
+struct ctl_table_header *register_sysctl_table(struct ctl_table * table)
+{
+	return NULL;
+}
+
+struct ctl_table_header *register_sysctl_paths(const struct ctl_path *path,
+						    struct ctl_table *table)
+{
+	return NULL;
+}
+
+void unregister_sysctl_table(struct ctl_table_header * table)
+{
+}
+
+#endif /* CONFIG_SYSCTL */
+
+/*
+ * /proc/sys support
+ */
+
+#ifdef CONFIG_PROC_SYSCTL
+
+static int _proc_do_string(void* data, int maxlen, int write,
+			   struct file *filp, void __user *buffer,
+			   size_t *lenp, loff_t *ppos)
+{
+	size_t len;
+	char __user *p;
+	char c;
+
+	if (!data || !maxlen || !*lenp) {
+		*lenp = 0;
+		return 0;
+	}
+
+	if (write) {
+		len = 0;
+		p = buffer;
+		while (len < *lenp) {
+			if (get_user(c, p++))
+				return -EFAULT;
+			if (c == 0 || c == '\n')
+				break;
+			len++;
+		}
+		if (len >= maxlen)
+			len = maxlen-1;
+		if(copy_from_user(data, buffer, len))
+			return -EFAULT;
+		((char *) data)[len] = 0;
+		*ppos += *lenp;
+	} else {
+		len = strlen(data);
+		if (len > maxlen)
+			len = maxlen;
+
+		if (*ppos > len) {
+			*lenp = 0;
+			return 0;
+		}
+
+		data += *ppos;
+		len  -= *ppos;
+
+		if (len > *lenp)
+			len = *lenp;
+		if (len)
+			if(copy_to_user(buffer, data, len))
+				return -EFAULT;
+		if (len < *lenp) {
+			if(put_user('\n', ((char __user *) buffer) + len))
+				return -EFAULT;
+			len++;
+		}
+		*lenp = len;
+		*ppos += len;
+	}
+	return 0;
+}
+
+/**
+ * proc_dostring - read a string sysctl
+ * @table: the sysctl table
+ * @write: %TRUE if this is a write to the sysctl file
+ * @filp: the file structure
+ * @buffer: the user buffer
+ * @lenp: the size of the user buffer
+ * @ppos: file position
+ *
+ * Reads/writes a string from/to the user buffer. If the kernel
+ * buffer provided is not large enough to hold the string, the
+ * string is truncated. The copied string is %NULL-terminated.
+ * If the string is being read by the user process, it is copied
+ * and a newline '\n' is added. It is truncated if the buffer is
+ * not large enough.
+ *
+ * Returns 0 on success.
+ */
+int proc_dostring(struct ctl_table *table, int write, struct file *filp,
+		  void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	return _proc_do_string(table->data, table->maxlen, write, filp,
+			       buffer, lenp, ppos);
+}
+
+
+static int do_proc_dointvec_conv(int *negp, unsigned long *lvalp,
+				 int *valp,
+				 int write, void *data)
+{
+	if (write) {
+		*valp = *negp ? -*lvalp : *lvalp;
+	} else {
+		int val = *valp;
+		if (val < 0) {
+			*negp = -1;
+			*lvalp = (unsigned long)-val;
+		} else {
+			*negp = 0;
+			*lvalp = (unsigned long)val;
+		}
+	}
+	return 0;
+}
+
+static int __do_proc_dointvec(void *tbl_data, struct ctl_table *table,
+		  int write, struct file *filp, void __user *buffer,
+		  size_t *lenp, loff_t *ppos,
+		  int (*conv)(int *negp, unsigned long *lvalp, int *valp,
+			      int write, void *data),
+		  void *data)
+{
+#define TMPBUFLEN 21
+	int *i, vleft, first=1, neg, val;
+	unsigned long lval;
+	size_t left, len;
+	
+	char buf[TMPBUFLEN], *p;
+	char __user *s = buffer;
+	
+	if (!tbl_data || !table->maxlen || !*lenp ||
+	    (*ppos && !write)) {
+		*lenp = 0;
+		return 0;
+	}
+	
+	i = (int *) tbl_data;
+	vleft = table->maxlen / sizeof(*i);
+	left = *lenp;
+
+	if (!conv)
+		conv = do_proc_dointvec_conv;
+
+	for (; left && vleft--; i++, first=0) {
+		if (write) {
+			while (left) {
+				char c;
+				if (get_user(c, s))
+					return -EFAULT;
+				if (!isspace(c))
+					break;
+				left--;
+				s++;
+			}
+			if (!left)
+				break;
+			neg = 0;
+			len = left;
+			if (len > sizeof(buf) - 1)
+				len = sizeof(buf) - 1;
+			if (copy_from_user(buf, s, len))
+				return -EFAULT;
+			buf[len] = 0;
+			p = buf;
+			if (*p == '-' && left > 1) {
+				neg = 1;
+				p++;
+			}
+			if (*p < '0' || *p > '9')
+				break;
+
+			lval = simple_strtoul(p, &p, 0);
+
+			len = p-buf;
+			if ((len < left) && *p && !isspace(*p))
+				break;
+			if (neg)
+				val = -val;
+			s += len;
+			left -= len;
+
+			if (conv(&neg, &lval, i, 1, data))
+				break;
+		} else {
+			p = buf;
+			if (!first)
+				*p++ = '\t';
+	
+			if (conv(&neg, &lval, i, 0, data))
+				break;
+
+			sprintf(p, "%s%lu", neg ? "-" : "", lval);
+			len = strlen(buf);
+			if (len > left)
+				len = left;
+			if(copy_to_user(s, buf, len))
+				return -EFAULT;
+			left -= len;
+			s += len;
+		}
+	}
+
+	if (!write && !first && left) {
+		if(put_user('\n', s))
+			return -EFAULT;
+		left--, s++;
+	}
+	if (write) {
+		while (left) {
+			char c;
+			if (get_user(c, s++))
+				return -EFAULT;
+			if (!isspace(c))
+				break;
+			left--;
+		}
+	}
+	if (write && first)
+		return -EINVAL;
+	*lenp -= left;
+	*ppos += *lenp;
+	return 0;
+#undef TMPBUFLEN
+}
+
+static int do_proc_dointvec(struct ctl_table *table, int write, struct file *filp,
+		  void __user *buffer, size_t *lenp, loff_t *ppos,
+		  int (*conv)(int *negp, unsigned long *lvalp, int *valp,
+			      int write, void *data),
+		  void *data)
+{
+	return __do_proc_dointvec(table->data, table, write, filp,
+			buffer, lenp, ppos, conv, data);
+}
+
+/**
+ * proc_dointvec - read a vector of integers
+ * @table: the sysctl table
+ * @write: %TRUE if this is a write to the sysctl file
+ * @filp: the file structure
+ * @buffer: the user buffer
+ * @lenp: the size of the user buffer
+ * @ppos: file position
+ *
+ * Reads/writes up to table->maxlen/sizeof(unsigned int) integer
+ * values from/to the user buffer, treated as an ASCII string. 
+ *
+ * Returns 0 on success.
+ */
+int proc_dointvec(struct ctl_table *table, int write, struct file *filp,
+		     void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+    return do_proc_dointvec(table,write,filp,buffer,lenp,ppos,
+		    	    NULL,NULL);
+}
+
+#define OP_SET	0
+#define OP_AND	1
+#define OP_OR	2
+
+static int do_proc_dointvec_bset_conv(int *negp, unsigned long *lvalp,
+				      int *valp,
+				      int write, void *data)
+{
+	int op = *(int *)data;
+	if (write) {
+		int val = *negp ? -*lvalp : *lvalp;
+		switch(op) {
+		case OP_SET:	*valp = val; break;
+		case OP_AND:	*valp &= val; break;
+		case OP_OR:	*valp |= val; break;
+		}
+	} else {
+		int val = *valp;
+		if (val < 0) {
+			*negp = -1;
+			*lvalp = (unsigned long)-val;
+		} else {
+			*negp = 0;
+			*lvalp = (unsigned long)val;
+		}
+	}
+	return 0;
+}
+
+/*
+ *	Taint values can only be increased
+ */
+static int proc_dointvec_taint(struct ctl_table *table, int write, struct file *filp,
+			       void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	int op;
+
+	if (write && !capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	op = OP_OR;
+	return do_proc_dointvec(table,write,filp,buffer,lenp,ppos,
+				do_proc_dointvec_bset_conv,&op);
+}
+
+struct do_proc_dointvec_minmax_conv_param {
+	int *min;
+	int *max;
+};
+
+static int do_proc_dointvec_minmax_conv(int *negp, unsigned long *lvalp, 
+					int *valp, 
+					int write, void *data)
+{
+	struct do_proc_dointvec_minmax_conv_param *param = data;
+	if (write) {
+		int val = *negp ? -*lvalp : *lvalp;
+		if ((param->min && *param->min > val) ||
+		    (param->max && *param->max < val))
+			return -EINVAL;
+		*valp = val;
+	} else {
+		int val = *valp;
+		if (val < 0) {
+			*negp = -1;
+			*lvalp = (unsigned long)-val;
+		} else {
+			*negp = 0;
+			*lvalp = (unsigned long)val;
+		}
+	}
+	return 0;
+}
+
+/**
+ * proc_dointvec_minmax - read a vector of integers with min/max values
+ * @table: the sysctl table
+ * @write: %TRUE if this is a write to the sysctl file
+ * @filp: the file structure
+ * @buffer: the user buffer
+ * @lenp: the size of the user buffer
+ * @ppos: file position
+ *
+ * Reads/writes up to table->maxlen/sizeof(unsigned int) integer
+ * values from/to the user buffer, treated as an ASCII string.
+ *
+ * This routine will ensure the values are within the range specified by
+ * table->extra1 (min) and table->extra2 (max).
+ *
+ * Returns 0 on success.
+ */
+int proc_dointvec_minmax(struct ctl_table *table, int write, struct file *filp,
+		  void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	struct do_proc_dointvec_minmax_conv_param param = {
+		.min = (int *) table->extra1,
+		.max = (int *) table->extra2,
+	};
+	return do_proc_dointvec(table, write, filp, buffer, lenp, ppos,
+				do_proc_dointvec_minmax_conv, &param);
+}
+
+static int __do_proc_doulongvec_minmax(void *data, struct ctl_table *table, int write,
+				     struct file *filp,
+				     void __user *buffer,
+				     size_t *lenp, loff_t *ppos,
+				     unsigned long convmul,
+				     unsigned long convdiv)
+{
+#define TMPBUFLEN 21
+	unsigned long *i, *min, *max, val;
+	int vleft, first=1, neg;
+	size_t len, left;
+	char buf[TMPBUFLEN], *p;
+	char __user *s = buffer;
+	
+	if (!data || !table->maxlen || !*lenp ||
+	    (*ppos && !write)) {
+		*lenp = 0;
+		return 0;
+	}
+	
+	i = (unsigned long *) data;
+	min = (unsigned long *) table->extra1;
+	max = (unsigned long *) table->extra2;
+	vleft = table->maxlen / sizeof(unsigned long);
+	left = *lenp;
+	
+	for (; left && vleft--; i++, min++, max++, first=0) {
+		if (write) {
+			while (left) {
+				char c;
+				if (get_user(c, s))
+					return -EFAULT;
+				if (!isspace(c))
+					break;
+				left--;
+				s++;
+			}
+			if (!left)
+				break;
+			neg = 0;
+			len = left;
+			if (len > TMPBUFLEN-1)
+				len = TMPBUFLEN-1;
+			if (copy_from_user(buf, s, len))
+				return -EFAULT;
+			buf[len] = 0;
+			p = buf;
+			if (*p == '-' && left > 1) {
+				neg = 1;
+				p++;
+			}
+			if (*p < '0' || *p > '9')
+				break;
+			val = simple_strtoul(p, &p, 0) * convmul / convdiv ;
+			len = p-buf;
+			if ((len < left) && *p && !isspace(*p))
+				break;
+			if (neg)
+				val = -val;
+			s += len;
+			left -= len;
+
+			if(neg)
+				continue;
+			if ((min && val < *min) || (max && val > *max))
+				continue;
+			*i = val;
+		} else {
+			p = buf;
+			if (!first)
+				*p++ = '\t';
+			sprintf(p, "%lu", convdiv * (*i) / convmul);
+			len = strlen(buf);
+			if (len > left)
+				len = left;
+			if(copy_to_user(s, buf, len))
+				return -EFAULT;
+			left -= len;
+			s += len;
+		}
+	}
+
+	if (!write && !first && left) {
+		if(put_user('\n', s))
+			return -EFAULT;
+		left--, s++;
+	}
+	if (write) {
+		while (left) {
+			char c;
+			if (get_user(c, s++))
+				return -EFAULT;
+			if (!isspace(c))
+				break;
+			left--;
+		}
+	}
+	if (write && first)
+		return -EINVAL;
+	*lenp -= left;
+	*ppos += *lenp;
+	return 0;
+#undef TMPBUFLEN
+}
+
+static int do_proc_doulongvec_minmax(struct ctl_table *table, int write,
+				     struct file *filp,
+				     void __user *buffer,
+				     size_t *lenp, loff_t *ppos,
+				     unsigned long convmul,
+				     unsigned long convdiv)
+{
+	return __do_proc_doulongvec_minmax(table->data, table, write,
+			filp, buffer, lenp, ppos, convmul, convdiv);
+}
+
+/**
+ * proc_doulongvec_minmax - read a vector of long integers with min/max values
+ * @table: the sysctl table
+ * @write: %TRUE if this is a write to the sysctl file
+ * @filp: the file structure
+ * @buffer: the user buffer
+ * @lenp: the size of the user buffer
+ * @ppos: file position
+ *
+ * Reads/writes up to table->maxlen/sizeof(unsigned long) unsigned long
+ * values from/to the user buffer, treated as an ASCII string.
+ *
+ * This routine will ensure the values are within the range specified by
+ * table->extra1 (min) and table->extra2 (max).
+ *
+ * Returns 0 on success.
+ */
+int proc_doulongvec_minmax(struct ctl_table *table, int write, struct file *filp,
+			   void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+    return do_proc_doulongvec_minmax(table, write, filp, buffer, lenp, ppos, 1l, 1l);
+}
+
+/**
+ * proc_doulongvec_ms_jiffies_minmax - read a vector of millisecond values with min/max values
+ * @table: the sysctl table
+ * @write: %TRUE if this is a write to the sysctl file
+ * @filp: the file structure
+ * @buffer: the user buffer
+ * @lenp: the size of the user buffer
+ * @ppos: file position
+ *
+ * Reads/writes up to table->maxlen/sizeof(unsigned long) unsigned long
+ * values from/to the user buffer, treated as an ASCII string. The values
+ * are treated as milliseconds, and converted to jiffies when they are stored.
+ *
+ * This routine will ensure the values are within the range specified by
+ * table->extra1 (min) and table->extra2 (max).
+ *
+ * Returns 0 on success.
+ */
+int proc_doulongvec_ms_jiffies_minmax(struct ctl_table *table, int write,
+				      struct file *filp,
+				      void __user *buffer,
+				      size_t *lenp, loff_t *ppos)
+{
+    return do_proc_doulongvec_minmax(table, write, filp, buffer,
+				     lenp, ppos, HZ, 1000l);
+}
+
+
+static int do_proc_dointvec_jiffies_conv(int *negp, unsigned long *lvalp,
+					 int *valp,
+					 int write, void *data)
+{
+	if (write) {
+		if (*lvalp > LONG_MAX / HZ)
+			return 1;
+		*valp = *negp ? -(*lvalp*HZ) : (*lvalp*HZ);
+	} else {
+		int val = *valp;
+		unsigned long lval;
+		if (val < 0) {
+			*negp = -1;
+			lval = (unsigned long)-val;
+		} else {
+			*negp = 0;
+			lval = (unsigned long)val;
+		}
+		*lvalp = lval / HZ;
+	}
+	return 0;
+}
+
+static int do_proc_dointvec_userhz_jiffies_conv(int *negp, unsigned long *lvalp,
+						int *valp,
+						int write, void *data)
+{
+	if (write) {
+		if (USER_HZ < HZ && *lvalp > (LONG_MAX / HZ) * USER_HZ)
+			return 1;
+		*valp = clock_t_to_jiffies(*negp ? -*lvalp : *lvalp);
+	} else {
+		int val = *valp;
+		unsigned long lval;
+		if (val < 0) {
+			*negp = -1;
+			lval = (unsigned long)-val;
+		} else {
+			*negp = 0;
+			lval = (unsigned long)val;
+		}
+		*lvalp = jiffies_to_clock_t(lval);
+	}
+	return 0;
+}
+
+static int do_proc_dointvec_ms_jiffies_conv(int *negp, unsigned long *lvalp,
+					    int *valp,
+					    int write, void *data)
+{
+	if (write) {
+		*valp = msecs_to_jiffies(*negp ? -*lvalp : *lvalp);
+	} else {
+		int val = *valp;
+		unsigned long lval;
+		if (val < 0) {
+			*negp = -1;
+			lval = (unsigned long)-val;
+		} else {
+			*negp = 0;
+			lval = (unsigned long)val;
+		}
+		*lvalp = jiffies_to_msecs(lval);
+	}
+	return 0;
+}
+
+/**
+ * proc_dointvec_jiffies - read a vector of integers as seconds
+ * @table: the sysctl table
+ * @write: %TRUE if this is a write to the sysctl file
+ * @filp: the file structure
+ * @buffer: the user buffer
+ * @lenp: the size of the user buffer
+ * @ppos: file position
+ *
+ * Reads/writes up to table->maxlen/sizeof(unsigned int) integer
+ * values from/to the user buffer, treated as an ASCII string. 
+ * The values read are assumed to be in seconds, and are converted into
+ * jiffies.
+ *
+ * Returns 0 on success.
+ */
+int proc_dointvec_jiffies(struct ctl_table *table, int write, struct file *filp,
+			  void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+    return do_proc_dointvec(table,write,filp,buffer,lenp,ppos,
+		    	    do_proc_dointvec_jiffies_conv,NULL);
+}
+
+/**
+ * proc_dointvec_userhz_jiffies - read a vector of integers as 1/USER_HZ seconds
+ * @table: the sysctl table
+ * @write: %TRUE if this is a write to the sysctl file
+ * @filp: the file structure
+ * @buffer: the user buffer
+ * @lenp: the size of the user buffer
+ * @ppos: pointer to the file position
+ *
+ * Reads/writes up to table->maxlen/sizeof(unsigned int) integer
+ * values from/to the user buffer, treated as an ASCII string. 
+ * The values read are assumed to be in 1/USER_HZ seconds, and 
+ * are converted into jiffies.
+ *
+ * Returns 0 on success.
+ */
+int proc_dointvec_userhz_jiffies(struct ctl_table *table, int write, struct file *filp,
+				 void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+    return do_proc_dointvec(table,write,filp,buffer,lenp,ppos,
+		    	    do_proc_dointvec_userhz_jiffies_conv,NULL);
+}
+
+/**
+ * proc_dointvec_ms_jiffies - read a vector of integers as 1 milliseconds
+ * @table: the sysctl table
+ * @write: %TRUE if this is a write to the sysctl file
+ * @filp: the file structure
+ * @buffer: the user buffer
+ * @lenp: the size of the user buffer
+ * @ppos: file position
+ * @ppos: the current position in the file
+ *
+ * Reads/writes up to table->maxlen/sizeof(unsigned int) integer
+ * values from/to the user buffer, treated as an ASCII string. 
+ * The values read are assumed to be in 1/1000 seconds, and 
+ * are converted into jiffies.
+ *
+ * Returns 0 on success.
+ */
+int proc_dointvec_ms_jiffies(struct ctl_table *table, int write, struct file *filp,
+			     void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	return do_proc_dointvec(table, write, filp, buffer, lenp, ppos,
+				do_proc_dointvec_ms_jiffies_conv, NULL);
+}
+
+static int proc_do_cad_pid(struct ctl_table *table, int write, struct file *filp,
+			   void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	struct pid *new_pid;
+	pid_t tmp;
+	int r;
+
+	tmp = pid_vnr(cad_pid);
+
+	r = __do_proc_dointvec(&tmp, table, write, filp, buffer,
+			       lenp, ppos, NULL, NULL);
+	if (r || !write)
+		return r;
+
+	new_pid = find_get_pid(tmp);
+	if (!new_pid)
+		return -ESRCH;
+
+	put_pid(xchg(&cad_pid, new_pid));
+	return 0;
+}
+
+#else /* CONFIG_PROC_FS */
+
+int proc_dostring(struct ctl_table *table, int write, struct file *filp,
+		  void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	return -ENOSYS;
+}
+
+int proc_dointvec(struct ctl_table *table, int write, struct file *filp,
+		  void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	return -ENOSYS;
+}
+
+int proc_dointvec_minmax(struct ctl_table *table, int write, struct file *filp,
+		    void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	return -ENOSYS;
+}
+
+int proc_dointvec_jiffies(struct ctl_table *table, int write, struct file *filp,
+		    void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	return -ENOSYS;
+}
+
+int proc_dointvec_userhz_jiffies(struct ctl_table *table, int write, struct file *filp,
+		    void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	return -ENOSYS;
+}
+
+int proc_dointvec_ms_jiffies(struct ctl_table *table, int write, struct file *filp,
+			     void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	return -ENOSYS;
+}
+
+int proc_doulongvec_minmax(struct ctl_table *table, int write, struct file *filp,
+		    void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	return -ENOSYS;
+}
+
+int proc_doulongvec_ms_jiffies_minmax(struct ctl_table *table, int write,
+				      struct file *filp,
+				      void __user *buffer,
+				      size_t *lenp, loff_t *ppos)
+{
+    return -ENOSYS;
+}
+
+
+#endif /* CONFIG_PROC_FS */
+
+
+#ifdef CONFIG_SYSCTL_SYSCALL
+/*
+ * General sysctl support routines 
+ */
+
+/* The generic sysctl data routine (used if no strategy routine supplied) */
+int sysctl_data(struct ctl_table *table, int __user *name, int nlen,
+		void __user *oldval, size_t __user *oldlenp,
+		void __user *newval, size_t newlen)
+{
+	size_t len;
+
+	/* Get out of I don't have a variable */
+	if (!table->data || !table->maxlen)
+		return -ENOTDIR;
+
+	if (oldval && oldlenp) {
+		if (get_user(len, oldlenp))
+			return -EFAULT;
+		if (len) {
+			if (len > table->maxlen)
+				len = table->maxlen;
+			if (copy_to_user(oldval, table->data, len))
+				return -EFAULT;
+			if (put_user(len, oldlenp))
+				return -EFAULT;
+		}
+	}
+
+	if (newval && newlen) {
+		if (newlen > table->maxlen)
+			newlen = table->maxlen;
+
+		if (copy_from_user(table->data, newval, newlen))
+			return -EFAULT;
+	}
+	return 1;
+}
+
+/* The generic string strategy routine: */
+int sysctl_string(struct ctl_table *table, int __user *name, int nlen,
+		  void __user *oldval, size_t __user *oldlenp,
+		  void __user *newval, size_t newlen)
+{
+	if (!table->data || !table->maxlen) 
+		return -ENOTDIR;
+	
+	if (oldval && oldlenp) {
+		size_t bufsize;
+		if (get_user(bufsize, oldlenp))
+			return -EFAULT;
+		if (bufsize) {
+			size_t len = strlen(table->data), copied;
+
+			/* This shouldn't trigger for a well-formed sysctl */
+			if (len > table->maxlen)
+				len = table->maxlen;
+
+			/* Copy up to a max of bufsize-1 bytes of the string */
+			copied = (len >= bufsize) ? bufsize - 1 : len;
+
+			if (copy_to_user(oldval, table->data, copied) ||
+			    put_user(0, (char __user *)(oldval + copied)))
+				return -EFAULT;
+			if (put_user(len, oldlenp))
+				return -EFAULT;
+		}
+	}
+	if (newval && newlen) {
+		size_t len = newlen;
+		if (len > table->maxlen)
+			len = table->maxlen;
+		if(copy_from_user(table->data, newval, len))
+			return -EFAULT;
+		if (len == table->maxlen)
+			len--;
+		((char *) table->data)[len] = 0;
+	}
+	return 1;
+}
+
+/*
+ * This function makes sure that all of the integers in the vector
+ * are between the minimum and maximum values given in the arrays
+ * table->extra1 and table->extra2, respectively.
+ */
+int sysctl_intvec(struct ctl_table *table, int __user *name, int nlen,
+		void __user *oldval, size_t __user *oldlenp,
+		void __user *newval, size_t newlen)
+{
+
+	if (newval && newlen) {
+		int __user *vec = (int __user *) newval;
+		int *min = (int *) table->extra1;
+		int *max = (int *) table->extra2;
+		size_t length;
+		int i;
+
+		if (newlen % sizeof(int) != 0)
+			return -EINVAL;
+
+		if (!table->extra1 && !table->extra2)
+			return 0;
+
+		if (newlen > table->maxlen)
+			newlen = table->maxlen;
+		length = newlen / sizeof(int);
+
+		for (i = 0; i < length; i++) {
+			int value;
+			if (get_user(value, vec + i))
+				return -EFAULT;
+			if (min && value < min[i])
+				return -EINVAL;
+			if (max && value > max[i])
+				return -EINVAL;
+		}
+	}
+	return 0;
+}
+
+/* Strategy function to convert jiffies to seconds */ 
+int sysctl_jiffies(struct ctl_table *table, int __user *name, int nlen,
+		void __user *oldval, size_t __user *oldlenp,
+		void __user *newval, size_t newlen)
+{
+	if (oldval && oldlenp) {
+		size_t olen;
+
+		if (get_user(olen, oldlenp))
+			return -EFAULT;
+		if (olen) {
+			int val;
+
+			if (olen < sizeof(int))
+				return -EINVAL;
+
+			val = *(int *)(table->data) / HZ;
+			if (put_user(val, (int __user *)oldval))
+				return -EFAULT;
+			if (put_user(sizeof(int), oldlenp))
+				return -EFAULT;
+		}
+	}
+	if (newval && newlen) { 
+		int new;
+		if (newlen != sizeof(int))
+			return -EINVAL; 
+		if (get_user(new, (int __user *)newval))
+			return -EFAULT;
+		*(int *)(table->data) = new*HZ; 
+	}
+	return 1;
+}
+
+/* Strategy function to convert jiffies to seconds */ 
+int sysctl_ms_jiffies(struct ctl_table *table, int __user *name, int nlen,
+		void __user *oldval, size_t __user *oldlenp,
+		void __user *newval, size_t newlen)
+{
+	if (oldval && oldlenp) {
+		size_t olen;
+
+		if (get_user(olen, oldlenp))
+			return -EFAULT;
+		if (olen) {
+			int val;
+
+			if (olen < sizeof(int))
+				return -EINVAL;
+
+			val = jiffies_to_msecs(*(int *)(table->data));
+			if (put_user(val, (int __user *)oldval))
+				return -EFAULT;
+			if (put_user(sizeof(int), oldlenp))
+				return -EFAULT;
+		}
+	}
+	if (newval && newlen) { 
+		int new;
+		if (newlen != sizeof(int))
+			return -EINVAL; 
+		if (get_user(new, (int __user *)newval))
+			return -EFAULT;
+		*(int *)(table->data) = msecs_to_jiffies(new);
+	}
+	return 1;
+}
+
+
+
+#else /* CONFIG_SYSCTL_SYSCALL */
+
+
+asmlinkage long sys_sysctl(struct __sysctl_args __user *args)
+{
+	struct __sysctl_args tmp;
+	int error;
+
+	if (copy_from_user(&tmp, args, sizeof(tmp)))
+		return -EFAULT;
+
+	error = deprecated_sysctl_warning(&tmp);
+
+	/* If no error reading the parameters then just -ENOSYS ... */
+	if (!error)
+		error = -ENOSYS;
+
+	return error;
+}
+
+int sysctl_data(struct ctl_table *table, int __user *name, int nlen,
+		  void __user *oldval, size_t __user *oldlenp,
+		  void __user *newval, size_t newlen)
+{
+	return -ENOSYS;
+}
+
+int sysctl_string(struct ctl_table *table, int __user *name, int nlen,
+		  void __user *oldval, size_t __user *oldlenp,
+		  void __user *newval, size_t newlen)
+{
+	return -ENOSYS;
+}
+
+int sysctl_intvec(struct ctl_table *table, int __user *name, int nlen,
+		void __user *oldval, size_t __user *oldlenp,
+		void __user *newval, size_t newlen)
+{
+	return -ENOSYS;
+}
+
+int sysctl_jiffies(struct ctl_table *table, int __user *name, int nlen,
+		void __user *oldval, size_t __user *oldlenp,
+		void __user *newval, size_t newlen)
+{
+	return -ENOSYS;
+}
+
+int sysctl_ms_jiffies(struct ctl_table *table, int __user *name, int nlen,
+		void __user *oldval, size_t __user *oldlenp,
+		void __user *newval, size_t newlen)
+{
+	return -ENOSYS;
+}
+
+#endif /* CONFIG_SYSCTL_SYSCALL */
+
+static int deprecated_sysctl_warning(struct __sysctl_args *args)
+{
+	static int msg_count;
+	int name[CTL_MAXNAME];
+	int i;
+
+	/* Check args->nlen. */
+	if (args->nlen < 0 || args->nlen > CTL_MAXNAME)
+		return -ENOTDIR;
+
+	/* Read in the sysctl name for better debug message logging */
+	for (i = 0; i < args->nlen; i++)
+		if (get_user(name[i], args->name + i))
+			return -EFAULT;
+
+	/* Ignore accesses to kernel.version */
+	if ((args->nlen == 2) && (name[0] == CTL_KERN) && (name[1] == KERN_VERSION))
+		return 0;
+
+	if (msg_count < 5) {
+		msg_count++;
+		printk(KERN_INFO
+			"warning: process `%s' used the deprecated sysctl "
+			"system call with ", current->comm);
+		for (i = 0; i < args->nlen; i++)
+			printk("%d.", name[i]);
+		printk("\n");
+	}
+	return 0;
+}
+
+/*
+ * No sense putting this after each symbol definition, twice,
+ * exception granted :-)
+ */
+EXPORT_SYMBOL(proc_dointvec);
+EXPORT_SYMBOL(proc_dointvec_jiffies);
+EXPORT_SYMBOL(proc_dointvec_minmax);
+EXPORT_SYMBOL(proc_dointvec_userhz_jiffies);
+EXPORT_SYMBOL(proc_dointvec_ms_jiffies);
+EXPORT_SYMBOL(proc_dostring);
+EXPORT_SYMBOL(proc_doulongvec_minmax);
+EXPORT_SYMBOL(proc_doulongvec_ms_jiffies_minmax);
+EXPORT_SYMBOL(register_sysctl_table);
+EXPORT_SYMBOL(register_sysctl_paths);
+EXPORT_SYMBOL(sysctl_intvec);
+EXPORT_SYMBOL(sysctl_jiffies);
+EXPORT_SYMBOL(sysctl_ms_jiffies);
+EXPORT_SYMBOL(sysctl_string);
+EXPORT_SYMBOL(sysctl_data);
+EXPORT_SYMBOL(unregister_sysctl_table);
diff -urpNa linux-2.6.26-rc4-rcut1-stutter/lib/Kconfig.debug linux-2.6.26-rc4-rcut2-proc/lib/Kconfig.debug
--- linux-2.6.26-rc4-rcut1-stutter/lib/Kconfig.debug	2008-05-30 04:39:01.000000000 -0700
+++ linux-2.6.26-rc4-rcut2-proc/lib/Kconfig.debug	2008-06-18 06:32:48.000000000 -0700
@@ -531,16 +531,34 @@ config BOOT_PRINTK_DELAY
 config RCU_TORTURE_TEST
 	tristate "torture tests for RCU"
 	depends on DEBUG_KERNEL
-	depends on m
 	default n
 	help
 	  This option provides a kernel module that runs torture tests
 	  on the RCU infrastructure.  The kernel module may be built
 	  after the fact on the running kernel to be tested, if desired.
 
+	  Say Y here if you want RCU torture tests to be built into
+	  the kernel.
 	  Say M if you want the RCU torture tests to build as a module.
 	  Say N if you are unsure.
 
+config RCU_TORTURE_TEST_RUNNABLE
+	bool "torture tests for RCU runnable by default"
+	depends on RCU_TORTURE_TEST = y
+	default n
+	help
+	  This option provides a way to build the RCU torture tests
+	  directly into the kernel without them starting up at boot
+	  time.  You can use /proc/sys/kernel/rcutorture_runnable
+	  to manually override this setting.  This /proc file is
+	  available only when the RCU torture tests have been built
+	  into the kernel.
+
+	  Say Y here if you want the RCU torture tests to start during
+	  boot (you probably don't).
+	  Say N here if you want the RCU torture tests to start only
+	  after being manually enabled via /proc.
+
 config KPROBES_SANITY_TEST
 	bool "Kprobes sanity tests"
 	depends on DEBUG_KERNEL
diff -urpNa linux-2.6.26-rc4-rcut1-stutter/lib/Kconfig.debug.orig linux-2.6.26-rc4-rcut2-proc/lib/Kconfig.debug.orig
--- linux-2.6.26-rc4-rcut1-stutter/lib/Kconfig.debug.orig	1969-12-31 16:00:00.000000000 -0800
+++ linux-2.6.26-rc4-rcut2-proc/lib/Kconfig.debug.orig	2008-05-30 04:39:01.000000000 -0700
@@ -0,0 +1,679 @@
+
+config PRINTK_TIME
+	bool "Show timing information on printks"
+	depends on PRINTK
+	help
+	  Selecting this option causes timing information to be
+	  included in printk output.  This allows you to measure
+	  the interval between kernel operations, including bootup
+	  operations.  This is useful for identifying long delays
+	  in kernel startup.
+
+config ENABLE_WARN_DEPRECATED
+	bool "Enable __deprecated logic"
+	default y
+	help
+	  Enable the __deprecated logic in the kernel build.
+	  Disable this to suppress the "warning: 'foo' is deprecated
+	  (declared at kernel/power/somefile.c:1234)" messages.
+
+config ENABLE_MUST_CHECK
+	bool "Enable __must_check logic"
+	default y
+	help
+	  Enable the __must_check logic in the kernel build.  Disable this to
+	  suppress the "warning: ignoring return value of 'foo', declared with
+	  attribute warn_unused_result" messages.
+
+config FRAME_WARN
+	int "Warn for stack frames larger than (needs gcc 4.4)"
+	range 0 8192
+	default 1024 if !64BIT
+	default 2048 if 64BIT
+	help
+	  Tell gcc to warn at build time for stack frames larger than this.
+	  Setting this too low will cause a lot of warnings.
+	  Setting it to 0 disables the warning.
+	  Requires gcc 4.4
+
+config MAGIC_SYSRQ
+	bool "Magic SysRq key"
+	depends on !UML
+	help
+	  If you say Y here, you will have some control over the system even
+	  if the system crashes for example during kernel debugging (e.g., you
+	  will be able to flush the buffer cache to disk, reboot the system
+	  immediately or dump some status information). This is accomplished
+	  by pressing various keys while holding SysRq (Alt+PrintScreen). It
+	  also works on a serial console (on PC hardware at least), if you
+	  send a BREAK and then within 5 seconds a command keypress. The
+	  keys are documented in <file:Documentation/sysrq.txt>. Don't say Y
+	  unless you really know what this hack does.
+
+config UNUSED_SYMBOLS
+	bool "Enable unused/obsolete exported symbols"
+	default y if X86
+	help
+	  Unused but exported symbols make the kernel needlessly bigger.  For
+	  that reason most of these unused exports will soon be removed.  This
+	  option is provided temporarily to provide a transition period in case
+	  some external kernel module needs one of these symbols anyway. If you
+	  encounter such a case in your module, consider if you are actually
+	  using the right API.  (rationale: since nobody in the kernel is using
+	  this in a module, there is a pretty good chance it's actually the
+	  wrong interface to use).  If you really need the symbol, please send a
+	  mail to the linux kernel mailing list mentioning the symbol and why
+	  you really need it, and what the merge plan to the mainline kernel for
+	  your module is.
+
+config DEBUG_FS
+	bool "Debug Filesystem"
+	depends on SYSFS
+	help
+	  debugfs is a virtual file system that kernel developers use to put
+	  debugging files into.  Enable this option to be able to read and
+	  write to these files.
+
+	  If unsure, say N.
+
+config HEADERS_CHECK
+	bool "Run 'make headers_check' when building vmlinux"
+	depends on !UML
+	help
+	  This option will extract the user-visible kernel headers whenever
+	  building the kernel, and will run basic sanity checks on them to
+	  ensure that exported files do not attempt to include files which
+	  were not exported, etc.
+
+	  If you're making modifications to header files which are
+	  relevant for userspace, say 'Y', and check the headers
+	  exported to $(INSTALL_HDR_PATH) (usually 'usr/include' in
+	  your build tree), to make sure they're suitable.
+
+config DEBUG_SECTION_MISMATCH
+	bool "Enable full Section mismatch analysis"
+	depends on UNDEFINED
+	# This option is on purpose disabled for now.
+	# It will be enabled when we are down to a resonable number
+	# of section mismatch warnings (< 10 for an allyesconfig build)
+	help
+	  The section mismatch analysis checks if there are illegal
+	  references from one section to another section.
+	  Linux will during link or during runtime drop some sections
+	  and any use of code/data previously in these sections will
+	  most likely result in an oops.
+	  In the code functions and variables are annotated with
+	  __init, __devinit etc. (see full list in include/linux/init.h)
+	  which results in the code/data being placed in specific sections.
+	  The section mismatch analysis is always done after a full
+	  kernel build but enabling this option will in addition
+	  do the following:
+	  - Add the option -fno-inline-functions-called-once to gcc
+	    When inlining a function annotated __init in a non-init
+	    function we would lose the section information and thus
+	    the analysis would not catch the illegal reference.
+	    This option tells gcc to inline less but will also
+	    result in a larger kernel.
+	  - Run the section mismatch analysis for each module/built-in.o
+	    When we run the section mismatch analysis on vmlinux.o we
+	    lose valueble information about where the mismatch was
+	    introduced.
+	    Running the analysis for each module/built-in.o file
+	    will tell where the mismatch happens much closer to the
+	    source. The drawback is that we will report the same
+	    mismatch at least twice.
+	  - Enable verbose reporting from modpost to help solving
+	    the section mismatches reported.
+
+config DEBUG_KERNEL
+	bool "Kernel debugging"
+	help
+	  Say Y here if you are developing drivers or trying to debug and
+	  identify kernel problems.
+
+config DEBUG_SHIRQ
+	bool "Debug shared IRQ handlers"
+	depends on DEBUG_KERNEL && GENERIC_HARDIRQS
+	help
+	  Enable this to generate a spurious interrupt as soon as a shared
+	  interrupt handler is registered, and just before one is deregistered.
+	  Drivers ought to be able to handle interrupts coming in at those
+	  points; some don't and need to be caught.
+
+config DETECT_SOFTLOCKUP
+	bool "Detect Soft Lockups"
+	depends on DEBUG_KERNEL && !S390
+	default y
+	help
+	  Say Y here to enable the kernel to detect "soft lockups",
+	  which are bugs that cause the kernel to loop in kernel
+	  mode for more than 10 seconds, without giving other tasks a
+	  chance to run.
+
+	  When a soft-lockup is detected, the kernel will print the
+	  current stack trace (which you should report), but the
+	  system will stay locked up. This feature has negligible
+	  overhead.
+
+	  (Note that "hard lockups" are separate type of bugs that
+	   can be detected via the NMI-watchdog, on platforms that
+	   support it.)
+
+config SCHED_DEBUG
+	bool "Collect scheduler debugging info"
+	depends on DEBUG_KERNEL && PROC_FS
+	default y
+	help
+	  If you say Y here, the /proc/sched_debug file will be provided
+	  that can help debug the scheduler. The runtime overhead of this
+	  option is minimal.
+
+config SCHEDSTATS
+	bool "Collect scheduler statistics"
+	depends on DEBUG_KERNEL && PROC_FS
+	help
+	  If you say Y here, additional code will be inserted into the
+	  scheduler and related routines to collect statistics about
+	  scheduler behavior and provide them in /proc/schedstat.  These
+	  stats may be useful for both tuning and debugging the scheduler
+	  If you aren't debugging the scheduler or trying to tune a specific
+	  application, you can say N to avoid the very slight overhead
+	  this adds.
+
+config TIMER_STATS
+	bool "Collect kernel timers statistics"
+	depends on DEBUG_KERNEL && PROC_FS
+	help
+	  If you say Y here, additional code will be inserted into the
+	  timer routines to collect statistics about kernel timers being
+	  reprogrammed. The statistics can be read from /proc/timer_stats.
+	  The statistics collection is started by writing 1 to /proc/timer_stats,
+	  writing 0 stops it. This feature is useful to collect information
+	  about timer usage patterns in kernel and userspace. This feature
+	  is lightweight if enabled in the kernel config but not activated
+	  (it defaults to deactivated on bootup and will only be activated
+	  if some application like powertop activates it explicitly).
+
+config DEBUG_OBJECTS
+	bool "Debug object operations"
+	depends on DEBUG_KERNEL
+	help
+	  If you say Y here, additional code will be inserted into the
+	  kernel to track the life time of various objects and validate
+	  the operations on those objects.
+
+config DEBUG_OBJECTS_SELFTEST
+	bool "Debug objects selftest"
+	depends on DEBUG_OBJECTS
+	help
+	  This enables the selftest of the object debug code.
+
+config DEBUG_OBJECTS_FREE
+	bool "Debug objects in freed memory"
+	depends on DEBUG_OBJECTS
+	help
+	  This enables checks whether a k/v free operation frees an area
+	  which contains an object which has not been deactivated
+	  properly. This can make kmalloc/kfree-intensive workloads
+	  much slower.
+
+config DEBUG_OBJECTS_TIMERS
+	bool "Debug timer objects"
+	depends on DEBUG_OBJECTS
+	help
+	  If you say Y here, additional code will be inserted into the
+	  timer routines to track the life time of timer objects and
+	  validate the timer operations.
+
+config DEBUG_SLAB
+	bool "Debug slab memory allocations"
+	depends on DEBUG_KERNEL && SLAB
+	help
+	  Say Y here to have the kernel do limited verification on memory
+	  allocation as well as poisoning memory on free to catch use of freed
+	  memory. This can make kmalloc/kfree-intensive workloads much slower.
+
+config DEBUG_SLAB_LEAK
+	bool "Memory leak debugging"
+	depends on DEBUG_SLAB
+
+config SLUB_DEBUG_ON
+	bool "SLUB debugging on by default"
+	depends on SLUB && SLUB_DEBUG
+	default n
+	help
+	  Boot with debugging on by default. SLUB boots by default with
+	  the runtime debug capabilities switched off. Enabling this is
+	  equivalent to specifying the "slub_debug" parameter on boot.
+	  There is no support for more fine grained debug control like
+	  possible with slub_debug=xxx. SLUB debugging may be switched
+	  off in a kernel built with CONFIG_SLUB_DEBUG_ON by specifying
+	  "slub_debug=-".
+
+config SLUB_STATS
+	default n
+	bool "Enable SLUB performance statistics"
+	depends on SLUB && SLUB_DEBUG && SYSFS
+	help
+	  SLUB statistics are useful to debug SLUBs allocation behavior in
+	  order find ways to optimize the allocator. This should never be
+	  enabled for production use since keeping statistics slows down
+	  the allocator by a few percentage points. The slabinfo command
+	  supports the determination of the most active slabs to figure
+	  out which slabs are relevant to a particular load.
+	  Try running: slabinfo -DA
+
+config DEBUG_PREEMPT
+	bool "Debug preemptible kernel"
+	depends on DEBUG_KERNEL && PREEMPT && (TRACE_IRQFLAGS_SUPPORT || PPC64)
+	default y
+	help
+	  If you say Y here then the kernel will use a debug variant of the
+	  commonly used smp_processor_id() function and will print warnings
+	  if kernel code uses it in a preemption-unsafe way. Also, the kernel
+	  will detect preemption count underflows.
+
+config DEBUG_RT_MUTEXES
+	bool "RT Mutex debugging, deadlock detection"
+	depends on DEBUG_KERNEL && RT_MUTEXES
+	help
+	 This allows rt mutex semantics violations and rt mutex related
+	 deadlocks (lockups) to be detected and reported automatically.
+
+config DEBUG_PI_LIST
+	bool
+	default y
+	depends on DEBUG_RT_MUTEXES
+
+config RT_MUTEX_TESTER
+	bool "Built-in scriptable tester for rt-mutexes"
+	depends on DEBUG_KERNEL && RT_MUTEXES
+	help
+	  This option enables a rt-mutex tester.
+
+config DEBUG_SPINLOCK
+	bool "Spinlock and rw-lock debugging: basic checks"
+	depends on DEBUG_KERNEL
+	help
+	  Say Y here and build SMP to catch missing spinlock initialization
+	  and certain other kinds of spinlock errors commonly made.  This is
+	  best used in conjunction with the NMI watchdog so that spinlock
+	  deadlocks are also debuggable.
+
+config DEBUG_MUTEXES
+	bool "Mutex debugging: basic checks"
+	depends on DEBUG_KERNEL
+	help
+	 This feature allows mutex semantics violations to be detected and
+	 reported.
+
+config DEBUG_LOCK_ALLOC
+	bool "Lock debugging: detect incorrect freeing of live locks"
+	depends on DEBUG_KERNEL && TRACE_IRQFLAGS_SUPPORT && STACKTRACE_SUPPORT && LOCKDEP_SUPPORT
+	select DEBUG_SPINLOCK
+	select DEBUG_MUTEXES
+	select LOCKDEP
+	help
+	 This feature will check whether any held lock (spinlock, rwlock,
+	 mutex or rwsem) is incorrectly freed by the kernel, via any of the
+	 memory-freeing routines (kfree(), kmem_cache_free(), free_pages(),
+	 vfree(), etc.), whether a live lock is incorrectly reinitialized via
+	 spin_lock_init()/mutex_init()/etc., or whether there is any lock
+	 held during task exit.
+
+config PROVE_LOCKING
+	bool "Lock debugging: prove locking correctness"
+	depends on DEBUG_KERNEL && TRACE_IRQFLAGS_SUPPORT && STACKTRACE_SUPPORT && LOCKDEP_SUPPORT
+	select LOCKDEP
+	select DEBUG_SPINLOCK
+	select DEBUG_MUTEXES
+	select DEBUG_LOCK_ALLOC
+	default n
+	help
+	 This feature enables the kernel to prove that all locking
+	 that occurs in the kernel runtime is mathematically
+	 correct: that under no circumstance could an arbitrary (and
+	 not yet triggered) combination of observed locking
+	 sequences (on an arbitrary number of CPUs, running an
+	 arbitrary number of tasks and interrupt contexts) cause a
+	 deadlock.
+
+	 In short, this feature enables the kernel to report locking
+	 related deadlocks before they actually occur.
+
+	 The proof does not depend on how hard and complex a
+	 deadlock scenario would be to trigger: how many
+	 participant CPUs, tasks and irq-contexts would be needed
+	 for it to trigger. The proof also does not depend on
+	 timing: if a race and a resulting deadlock is possible
+	 theoretically (no matter how unlikely the race scenario
+	 is), it will be proven so and will immediately be
+	 reported by the kernel (once the event is observed that
+	 makes the deadlock theoretically possible).
+
+	 If a deadlock is impossible (i.e. the locking rules, as
+	 observed by the kernel, are mathematically correct), the
+	 kernel reports nothing.
+
+	 NOTE: this feature can also be enabled for rwlocks, mutexes
+	 and rwsems - in which case all dependencies between these
+	 different locking variants are observed and mapped too, and
+	 the proof of observed correctness is also maintained for an
+	 arbitrary combination of these separate locking variants.
+
+	 For more details, see Documentation/lockdep-design.txt.
+
+config LOCKDEP
+	bool
+	depends on DEBUG_KERNEL && TRACE_IRQFLAGS_SUPPORT && STACKTRACE_SUPPORT && LOCKDEP_SUPPORT
+	select STACKTRACE
+	select FRAME_POINTER if !X86 && !MIPS
+	select KALLSYMS
+	select KALLSYMS_ALL
+
+config LOCK_STAT
+	bool "Lock usage statistics"
+	depends on DEBUG_KERNEL && TRACE_IRQFLAGS_SUPPORT && STACKTRACE_SUPPORT && LOCKDEP_SUPPORT
+	select LOCKDEP
+	select DEBUG_SPINLOCK
+	select DEBUG_MUTEXES
+	select DEBUG_LOCK_ALLOC
+	default n
+	help
+	 This feature enables tracking lock contention points
+
+	 For more details, see Documentation/lockstat.txt
+
+config DEBUG_LOCKDEP
+	bool "Lock dependency engine debugging"
+	depends on DEBUG_KERNEL && LOCKDEP
+	help
+	  If you say Y here, the lock dependency engine will do
+	  additional runtime checks to debug itself, at the price
+	  of more runtime overhead.
+
+config TRACE_IRQFLAGS
+	depends on DEBUG_KERNEL
+	bool
+	default y
+	depends on TRACE_IRQFLAGS_SUPPORT
+	depends on PROVE_LOCKING
+
+config DEBUG_SPINLOCK_SLEEP
+	bool "Spinlock debugging: sleep-inside-spinlock checking"
+	depends on DEBUG_KERNEL
+	help
+	  If you say Y here, various routines which may sleep will become very
+	  noisy if they are called with a spinlock held.
+
+config DEBUG_LOCKING_API_SELFTESTS
+	bool "Locking API boot-time self-tests"
+	depends on DEBUG_KERNEL
+	help
+	  Say Y here if you want the kernel to run a short self-test during
+	  bootup. The self-test checks whether common types of locking bugs
+	  are detected by debugging mechanisms or not. (if you disable
+	  lock debugging then those bugs wont be detected of course.)
+	  The following locking APIs are covered: spinlocks, rwlocks,
+	  mutexes and rwsems.
+
+config STACKTRACE
+	bool
+	depends on DEBUG_KERNEL
+	depends on STACKTRACE_SUPPORT
+
+config DEBUG_KOBJECT
+	bool "kobject debugging"
+	depends on DEBUG_KERNEL
+	help
+	  If you say Y here, some extra kobject debugging messages will be sent
+	  to the syslog. 
+
+config DEBUG_HIGHMEM
+	bool "Highmem debugging"
+	depends on DEBUG_KERNEL && HIGHMEM
+	help
+	  This options enables addition error checking for high memory systems.
+	  Disable for production systems.
+
+config DEBUG_BUGVERBOSE
+	bool "Verbose BUG() reporting (adds 70K)" if DEBUG_KERNEL && EMBEDDED
+	depends on BUG
+	depends on ARM || AVR32 || M32R || M68K || SPARC32 || SPARC64 || \
+		   FRV || SUPERH || GENERIC_BUG || BLACKFIN || MN10300
+	default !EMBEDDED
+	help
+	  Say Y here to make BUG() panics output the file name and line number
+	  of the BUG call as well as the EIP and oops trace.  This aids
+	  debugging but costs about 70-100K of memory.
+
+config DEBUG_INFO
+	bool "Compile the kernel with debug info"
+	depends on DEBUG_KERNEL
+	help
+          If you say Y here the resulting kernel image will include
+	  debugging info resulting in a larger kernel image.
+	  This adds debug symbols to the kernel and modules (gcc -g), and
+	  is needed if you intend to use kernel crashdump or binary object
+	  tools like crash, kgdb, LKCD, gdb, etc on the kernel.
+	  Say Y here only if you plan to debug the kernel.
+
+	  If unsure, say N.
+
+config DEBUG_VM
+	bool "Debug VM"
+	depends on DEBUG_KERNEL
+	help
+	  Enable this to turn on extended checks in the virtual-memory system
+          that may impact performance.
+
+	  If unsure, say N.
+
+config DEBUG_WRITECOUNT
+	bool "Debug filesystem writers count"
+	depends on DEBUG_KERNEL
+	help
+	  Enable this to catch wrong use of the writers count in struct
+	  vfsmount.  This will increase the size of each file struct by
+	  32 bits.
+
+	  If unsure, say N.
+
+config DEBUG_LIST
+	bool "Debug linked list manipulation"
+	depends on DEBUG_KERNEL
+	help
+	  Enable this to turn on extended checks in the linked-list
+	  walking routines.
+
+	  If unsure, say N.
+
+config DEBUG_SG
+	bool "Debug SG table operations"
+	depends on DEBUG_KERNEL
+	help
+	  Enable this to turn on checks on scatter-gather tables. This can
+	  help find problems with drivers that do not properly initialize
+	  their sg tables.
+
+	  If unsure, say N.
+
+config FRAME_POINTER
+	bool "Compile the kernel with frame pointers"
+	depends on DEBUG_KERNEL && \
+		(X86 || CRIS || M68K || M68KNOMMU || FRV || UML || S390 || \
+		 AVR32 || SUPERH || BLACKFIN || MN10300)
+	default y if DEBUG_INFO && UML
+	help
+	  If you say Y here the resulting kernel image will be slightly larger
+	  and slower, but it might give very useful debugging information on
+	  some architectures or if you use external debuggers.
+	  If you don't debug the kernel, you can say N.
+
+config BOOT_PRINTK_DELAY
+	bool "Delay each boot printk message by N milliseconds"
+	depends on DEBUG_KERNEL && PRINTK && GENERIC_CALIBRATE_DELAY
+	help
+	  This build option allows you to read kernel boot messages
+	  by inserting a short delay after each one.  The delay is
+	  specified in milliseconds on the kernel command line,
+	  using "boot_delay=N".
+
+	  It is likely that you would also need to use "lpj=M" to preset
+	  the "loops per jiffie" value.
+	  See a previous boot log for the "lpj" value to use for your
+	  system, and then set "lpj=M" before setting "boot_delay=N".
+	  NOTE:  Using this option may adversely affect SMP systems.
+	  I.e., processors other than the first one may not boot up.
+	  BOOT_PRINTK_DELAY also may cause DETECT_SOFTLOCKUP to detect
+	  what it believes to be lockup conditions.
+
+config RCU_TORTURE_TEST
+	tristate "torture tests for RCU"
+	depends on DEBUG_KERNEL
+	depends on m
+	default n
+	help
+	  This option provides a kernel module that runs torture tests
+	  on the RCU infrastructure.  The kernel module may be built
+	  after the fact on the running kernel to be tested, if desired.
+
+	  Say M if you want the RCU torture tests to build as a module.
+	  Say N if you are unsure.
+
+config KPROBES_SANITY_TEST
+	bool "Kprobes sanity tests"
+	depends on DEBUG_KERNEL
+	depends on KPROBES
+	default n
+	help
+	  This option provides for testing basic kprobes functionality on
+	  boot. A sample kprobe, jprobe and kretprobe are inserted and
+	  verified for functionality.
+
+	  Say N if you are unsure.
+
+config BACKTRACE_SELF_TEST
+	tristate "Self test for the backtrace code"
+	depends on DEBUG_KERNEL
+	default n
+	help
+	  This option provides a kernel module that can be used to test
+	  the kernel stack backtrace code. This option is not useful
+	  for distributions or general kernels, but only for kernel
+	  developers working on architecture code.
+
+	  Say N if you are unsure.
+
+config LKDTM
+	tristate "Linux Kernel Dump Test Tool Module"
+	depends on DEBUG_KERNEL
+	depends on KPROBES
+	depends on BLOCK
+	default n
+	help
+	This module enables testing of the different dumping mechanisms by
+	inducing system failures at predefined crash points.
+	If you don't need it: say N
+	Choose M here to compile this code as a module. The module will be
+	called lkdtm.
+
+	Documentation on how to use the module can be found in
+	drivers/misc/lkdtm.c
+
+config FAULT_INJECTION
+	bool "Fault-injection framework"
+	depends on DEBUG_KERNEL
+	help
+	  Provide fault-injection framework.
+	  For more details, see Documentation/fault-injection/.
+
+config FAILSLAB
+	bool "Fault-injection capability for kmalloc"
+	depends on FAULT_INJECTION
+	help
+	  Provide fault-injection capability for kmalloc.
+
+config FAIL_PAGE_ALLOC
+	bool "Fault-injection capabilitiy for alloc_pages()"
+	depends on FAULT_INJECTION
+	help
+	  Provide fault-injection capability for alloc_pages().
+
+config FAIL_MAKE_REQUEST
+	bool "Fault-injection capability for disk IO"
+	depends on FAULT_INJECTION
+	help
+	  Provide fault-injection capability for disk IO.
+
+config FAULT_INJECTION_DEBUG_FS
+	bool "Debugfs entries for fault-injection capabilities"
+	depends on FAULT_INJECTION && SYSFS && DEBUG_FS
+	help
+	  Enable configuration of fault-injection capabilities via debugfs.
+
+config FAULT_INJECTION_STACKTRACE_FILTER
+	bool "stacktrace filter for fault-injection capabilities"
+	depends on FAULT_INJECTION_DEBUG_FS && STACKTRACE_SUPPORT
+	depends on !X86_64
+	select STACKTRACE
+	select FRAME_POINTER
+	help
+	  Provide stacktrace filter for fault-injection capabilities
+
+config LATENCYTOP
+	bool "Latency measuring infrastructure"
+	select FRAME_POINTER if !MIPS
+	select KALLSYMS
+	select KALLSYMS_ALL
+	select STACKTRACE
+	select SCHEDSTATS
+	select SCHED_DEBUG
+	depends on HAVE_LATENCYTOP_SUPPORT
+	help
+	  Enable this option if you want to use the LatencyTOP tool
+	  to find out which userspace is blocking on what kernel operations.
+
+config PROVIDE_OHCI1394_DMA_INIT
+	bool "Remote debugging over FireWire early on boot"
+	depends on PCI && X86
+	help
+	  If you want to debug problems which hang or crash the kernel early
+	  on boot and the crashing machine has a FireWire port, you can use
+	  this feature to remotely access the memory of the crashed machine
+	  over FireWire. This employs remote DMA as part of the OHCI1394
+	  specification which is now the standard for FireWire controllers.
+
+	  With remote DMA, you can monitor the printk buffer remotely using
+	  firescope and access all memory below 4GB using fireproxy from gdb.
+	  Even controlling a kernel debugger is possible using remote DMA.
+
+	  Usage:
+
+	  If ohci1394_dma=early is used as boot parameter, it will initialize
+	  all OHCI1394 controllers which are found in the PCI config space.
+
+	  As all changes to the FireWire bus such as enabling and disabling
+	  devices cause a bus reset and thereby disable remote DMA for all
+	  devices, be sure to have the cable plugged and FireWire enabled on
+	  the debugging host before booting the debug target for debugging.
+
+	  This code (~1k) is freed after boot. By then, the firewire stack
+	  in charge of the OHCI-1394 controllers should be used instead.
+
+	  See Documentation/debugging-via-ohci1394.txt for more information.
+
+config FIREWIRE_OHCI_REMOTE_DMA
+	bool "Remote debugging over FireWire with firewire-ohci"
+	depends on FIREWIRE_OHCI
+	help
+	  This option lets you use the FireWire bus for remote debugging
+	  with help of the firewire-ohci driver. It enables unfiltered
+	  remote DMA in firewire-ohci.
+	  See Documentation/debugging-via-ohci1394.txt for more information.
+
+	  If unsure, say N.
+
+source "samples/Kconfig"
+
+source "lib/Kconfig.kgdb"
