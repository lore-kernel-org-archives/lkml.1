Return-Path: <linux-kernel-owner+w=401wt.eu-S1757832AbYGQRcl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757832AbYGQRcl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 13:32:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757900AbYGQRc2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 13:32:28 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60219 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757879AbYGQRc1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 13:32:27 -0400
Date: Thu, 17 Jul 2008 19:32:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [git pull] tracing fixes
Message-ID: <20080717173210.GA12828@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest tracing fixes git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git tracing-fixes-for-linus

Thanks,

	Ingo

------------------>
Ingo Molnar (4):
      ftrace: fix merge buglet
      ftrace: fix lockup with MAXSMP
      ftrace: do not trace scheduler functions
      ftrace: do not trace library functions


 arch/x86/kernel/Makefile |    3 +--
 kernel/Makefile          |    3 +--
 lib/Makefile             |   14 +++++---------
 3 files changed, 7 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 5112c84..da14061 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -8,8 +8,7 @@ CPPFLAGS_vmlinux.lds += -U$(UTS_MACHINE)
 
 ifdef CONFIG_FTRACE
 # Do not profile debug utilities
-CFLAGS_REMOVE_tsc_64.o = -pg
-CFLAGS_REMOVE_tsc_32.o = -pg
+CFLAGS_REMOVE_tsc.o = -pg
 CFLAGS_REMOVE_rtc.o = -pg
 endif
 
diff --git a/kernel/Makefile b/kernel/Makefile
index 0a7ed83..985ddb7 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -11,8 +11,6 @@ obj-y     = sched.o fork.o exec_domain.o panic.o printk.o profile.o \
 	    hrtimer.o rwsem.o nsproxy.o srcu.o semaphore.o \
 	    notifier.o ksysfs.o pm_qos_params.o sched_clock.o
 
-CFLAGS_REMOVE_sched.o = -mno-spe
-
 ifdef CONFIG_FTRACE
 # Do not trace debug files and internal ftrace files
 CFLAGS_REMOVE_lockdep.o = -pg
@@ -21,6 +19,7 @@ CFLAGS_REMOVE_mutex-debug.o = -pg
 CFLAGS_REMOVE_rtmutex-debug.o = -pg
 CFLAGS_REMOVE_cgroup-debug.o = -pg
 CFLAGS_REMOVE_sched_clock.o = -pg
+CFLAGS_REMOVE_sched.o = -mno-spe -pg
 endif
 
 obj-$(CONFIG_SYSCTL_SYSCALL_CHECK) += sysctl_check.o
diff --git a/lib/Makefile b/lib/Makefile
index 2c62a9c..818c4d4 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -2,21 +2,17 @@
 # Makefile for some libs needed in the kernel.
 #
 
+ifdef CONFIG_FTRACE
+ORIG_CFLAGS := $(KBUILD_CFLAGS)
+KBUILD_CFLAGS = $(subst -pg,,$(ORIG_CFLAGS))
+endif
+
 lib-y := ctype.o string.o vsprintf.o cmdline.o \
 	 rbtree.o radix-tree.o dump_stack.o \
 	 idr.o int_sqrt.o extable.o prio_tree.o \
 	 sha1.o irq_regs.o reciprocal_div.o argv_split.o \
 	 proportions.o prio_heap.o ratelimit.o
 
-ifdef CONFIG_FTRACE
-# Do not profile string.o, since it may be used in early boot or vdso
-CFLAGS_REMOVE_string.o = -pg
-# Also do not profile any debug utilities
-CFLAGS_REMOVE_spinlock_debug.o = -pg
-CFLAGS_REMOVE_list_debug.o = -pg
-CFLAGS_REMOVE_debugobjects.o = -pg
-endif
-
 lib-$(CONFIG_MMU) += ioremap.o
 lib-$(CONFIG_SMP) += cpumask.o
 
