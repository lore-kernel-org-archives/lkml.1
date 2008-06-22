Return-Path: <linux-kernel-owner+w=401wt.eu-S1752833AbYFVM3F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752833AbYFVM3F (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 08:29:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751583AbYFVM2y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 08:28:54 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:5571 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462AbYFVM2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 08:28:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent:from;
        b=OMuKMCDRAICJPVA+5EHzFDtmaLzkJn73EP8E15/269/iS7jc+lFW8tKBOIZR1P0/Wy
         UkoAk3UhTn6yErxBkKp3h/WhpjghtvvS2x9rdwhmPYXFKvLYd4jU/E6PaGkMwdSVFG+j
         fDemihkXgNlbdtDzD+35mP48pdDvwAQyALb2I=
Date: Sun, 22 Jun 2008 14:28:45 +0200
To: a.p.zijlstra@chello.nl, arjan@linux.intel.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] softirq softlockup debugging
Message-ID: <20080622122845.GA10133@damson.getinternet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
From: Vegard Nossum <vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm debugging a problem with a softirq that gets stuck for a long time,
so I wrote this patch to help find out what's going wrong.

I actually think it can be useful in general as well, see for example
http://www.kerneloops.org/search.php?search=__do_softirq&btnG=Function+Search

..and these cases are virtually impossible to debug since we don't know
anything about *what* it was that got stuck. (The NMI watchdog could
help, though.)

The patch is #ifdef-ugly, I know... Suggestions are welcome.


Vegard


From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Sun, 22 Jun 2008 14:12:31 +0200
Subject: [PATCH] softirq softlockup debugging

>From the Kconfig: If a softlockup happens in a softirq, the softlockup
stack trace is utterly unhelpful; it will only show the stack up to
__do_softirq(), since this is where interrupts are reenabled.

This patch adds a line to the output of the softlockup report which
contains the address of the function that was last scheduled to run in
a softirq.

Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
---
 include/linux/interrupt.h |    3 +++
 kernel/softirq.c          |   13 +++++++++++++
 kernel/softlockup.c       |    6 ++++++
 lib/Kconfig.debug         |   10 ++++++++++
 4 files changed, 32 insertions(+), 0 deletions(-)

diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index f1fc747..97d47cf 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -296,6 +296,9 @@ extern void softirq_init(void);
 extern void raise_softirq_irqoff(unsigned int nr);
 extern void raise_softirq(unsigned int nr);
 
+#ifdef CONFIG_SOFTLOCKUP_SOFTIRQ_DEBUG
+extern void *get_last_softirq_action(int cpu);
+#endif
 
 /* Tasklets --- multithreaded analogue of BHs.
 
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 36e0617..b49899a 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -196,6 +196,15 @@ void local_bh_enable_ip(unsigned long ip)
 }
 EXPORT_SYMBOL(local_bh_enable_ip);
 
+#ifdef CONFIG_SOFTLOCKUP_SOFTIRQ_DEBUG
+static DEFINE_PER_CPU(void *, last_softirq_action);
+
+void *get_last_softirq_action(int cpu)
+{
+	return per_cpu(last_softirq_action, cpu);
+}
+#endif
+
 /*
  * We restart softirq processing MAX_SOFTIRQ_RESTART times,
  * and we fall back to softirqd after that.
@@ -231,6 +240,10 @@ restart:
 
 	do {
 		if (pending & 1) {
+#ifdef CONFIG_SOFTLOCKUP_SOFTIRQ_DEBUG
+			per_cpu(last_softirq_action, cpu) = h->action;
+#endif
+
 			h->action(h);
 			rcu_bh_qsctr_inc(cpu);
 		}
diff --git a/kernel/softlockup.c b/kernel/softlockup.c
index c828c23..2bf4fa1 100644
--- a/kernel/softlockup.c
+++ b/kernel/softlockup.c
@@ -10,8 +10,10 @@
 #include <linux/cpu.h>
 #include <linux/nmi.h>
 #include <linux/init.h>
+#include <linux/interrupt.h>
 #include <linux/delay.h>
 #include <linux/freezer.h>
+#include <linux/kallsyms.h>
 #include <linux/kthread.h>
 #include <linux/notifier.h>
 #include <linux/module.h>
@@ -120,6 +122,10 @@ void softlockup_tick(void)
 	printk(KERN_ERR "BUG: soft lockup - CPU#%d stuck for %lus! [%s:%d]\n",
 			this_cpu, now - touch_timestamp,
 			current->comm, task_pid_nr(current));
+#ifdef CONFIG_SOFTLOCKUP_SOFTIRQ_DEBUG
+	print_symbol(KERN_ERR "Last softirq was %s\n",
+		(unsigned long) get_last_softirq_action(this_cpu));
+#endif
 	if (regs)
 		show_regs(regs);
 	else
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index d2099f4..19a7dfc 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -159,6 +159,16 @@ config DETECT_SOFTLOCKUP
 	   can be detected via the NMI-watchdog, on platforms that
 	   support it.)
 
+config SOFTLOCKUP_SOFTIRQ_DEBUG
+	bool "Debug softirq lockups"
+	depends on DETECT_SOFTLOCKUP
+	default n
+	help
+	  If a softlockup happens in a softirq, the softlockup
+	  stack trace is utterly unhelpful; it will only show the
+	  stack up to __do_softirq(), since this is where interrupts
+	  are reenabled.
+
 config SCHED_DEBUG
 	bool "Collect scheduler debugging info"
 	depends on DEBUG_KERNEL && PROC_FS
-- 
1.5.4.1

