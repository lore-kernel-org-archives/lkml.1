Return-Path: <linux-kernel-owner+w=401wt.eu-S1752075AbYFRQ3t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752075AbYFRQ3t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 12:29:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753133AbYFRQ3j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 12:29:39 -0400
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:41377 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518AbYFRQ3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 12:29:36 -0400
Date: Wed, 18 Jun 2008 09:26:49 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, josh@freedesktop.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       dino@in.ibm.com, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, vegard.nossum@gmail.com,
       adobriyan@gmail.com, oleg@tv-sign.ru, bunk@kernel.org, rjw@sisk.pl
Subject: [PATCH] Make rcutorture more vicious: reinstate boot-time testing
Message-ID: <20080618162649.GA18326@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080618122144.GA27143@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080618122144.GA27143@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello again!

This patch re-institutes the ability to build rcutorture directly into
the Linux kernel.  The reason that this capability was removed was that
this could result in your kernel being pretty much useless, as rcutorture
would be running starting from early boot.  This problem has been avoided
by (1) making rcutorture run only three seconds of every six by default,
(2) adding a CONFIG_RCU_TORTURE_TEST_RUNNABLE that permits rcutorture
to be quiesced at boot time, and (3) adding a sysctl in /proc named
/proc/sys/kernel/rcutorture_runnable that permits rcutorture to be
quiesced and unquiesced when built into the kernel.

Please note that this /proc file is -not- available when rcutorture
is built as a module.  Please also note that to get the earlier
take-no-prisoners behavior, you must use the boot command line to set
rcutorture's "stutter" parameter to zero.

The rcutorture quiescing mechanism is currently quite crude: loops
in each rcutorture process that poll a global variable once per tick.
Suggestions for improvement are welcome.  The default action will
be to reduce the polling rate to a few times per second.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Suggested-by: Ingo Molnar <mingo@elte.hu>
---

 Documentation/RCU/torture.txt |   21 ++++++++++++++-------
 kernel/rcutorture.c           |    9 ++++++++-
 kernel/sysctl.c               |   13 +++++++++++++
 lib/Kconfig.debug             |   20 +++++++++++++++++++-
 4 files changed, 54 insertions(+), 9 deletions(-)

diff -urpNa -X dontdiff linux-2.6.26-rc4-rcut1-stutter/Documentation/RCU/torture.txt linux-2.6.26-rc4-rcut2-proc/Documentation/RCU/torture.txt
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
diff -urpNa -X dontdiff linux-2.6.26-rc4-rcut1-stutter/kernel/rcutorture.c linux-2.6.26-rc4-rcut2-proc/kernel/rcutorture.c
--- linux-2.6.26-rc4-rcut1-stutter/kernel/rcutorture.c	2008-06-18 04:54:41.000000000 -0700
+++ linux-2.6.26-rc4-rcut2-proc/kernel/rcutorture.c	2008-06-18 07:38:11.000000000 -0700
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
@@ -188,7 +195,7 @@ rcu_random(struct rcu_random_state *rrsp
 static void
 rcu_stutter_wait(void)
 {
-	while (stutter_pause_test)
+	while (stutter_pause_test || !rcutorture_runnable)
 		schedule_timeout_interruptible(1);
 }
 
diff -urpNa -X dontdiff linux-2.6.26-rc4-rcut1-stutter/kernel/sysctl.c linux-2.6.26-rc4-rcut2-proc/kernel/sysctl.c
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
diff -urpNa -X dontdiff linux-2.6.26-rc4-rcut1-stutter/lib/Kconfig.debug linux-2.6.26-rc4-rcut2-proc/lib/Kconfig.debug
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
