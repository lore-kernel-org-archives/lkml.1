Return-Path: <linux-kernel-owner+w=401wt.eu-S932686AbYBUPz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932686AbYBUPz1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 10:55:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756984AbYBUPyL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 10:54:11 -0500
Received: from 75-130-111-13.dhcp.oxfr.ma.charter.com ([75.130.111.13]:41288
	"EHLO novell1.haskins.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755657AbYBUPyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 10:54:07 -0500
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH [RT] 02/14] spinlock: make preemptible-waiter feature a
	specific config option
To: mingo@elte.hu, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       rostedt@goodmis.org, linux-rt-users@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, bill.huey@gmail.com, kevin@hilman.org,
       cminyard@mvista.com, dsingleton@mvista.com, dwalker@mvista.com,
       npiggin@suse.de, dsaxena@plexity.net, ak@suse.de, gregkh@suse.de,
       sdietrich@novell.com, pmorreale@novell.com, mkohari@novell.com,
       ghaskins@novell.com
Date: Thu, 21 Feb 2008 10:26:36 -0500
Message-ID: <20080221152635.4804.52393.stgit@novell1.haskins.net>
In-Reply-To: <20080221152504.4804.8724.stgit@novell1.haskins.net>
References: <20080221152504.4804.8724.stgit@novell1.haskins.net>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We introduce a configuration variable for the feature to make it easier for
various architectures and/or configs to enable or disable it based on their
requirements.  

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 kernel/Kconfig.preempt |    9 +++++++++
 kernel/spinlock.c      |    7 +++----
 lib/Kconfig.debug      |    1 +
 3 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/kernel/Kconfig.preempt b/kernel/Kconfig.preempt
index 41a0d88..5b45213 100644
--- a/kernel/Kconfig.preempt
+++ b/kernel/Kconfig.preempt
@@ -86,6 +86,15 @@ config PREEMPT
 	default y
 	depends on PREEMPT_DESKTOP || PREEMPT_RT
 
+config DISABLE_PREEMPT_SPINLOCK_WAITERS
+        bool
+	default n
+
+config PREEMPT_SPINLOCK_WAITERS
+        bool
+	default y
+	depends on PREEMPT && SMP && !DISABLE_PREEMPT_SPINLOCK_WAITERS
+
 config PREEMPT_SOFTIRQS
 	bool "Thread Softirqs"
 	default n
diff --git a/kernel/spinlock.c b/kernel/spinlock.c
index b0e7f02..2e6a904 100644
--- a/kernel/spinlock.c
+++ b/kernel/spinlock.c
@@ -116,8 +116,7 @@ EXPORT_SYMBOL(__write_trylock_irqsave);
  * even on CONFIG_PREEMPT, because lockdep assumes that interrupts are
  * not re-enabled during lock-acquire (which the preempt-spin-ops do):
  */
-#if !defined(CONFIG_PREEMPT) || !defined(CONFIG_SMP) || \
-	defined(CONFIG_DEBUG_LOCK_ALLOC)
+#if !defined(CONFIG_PREEMPT_SPINLOCK_WAITERS)
 
 void __lockfunc __read_lock(raw_rwlock_t *lock)
 {
@@ -244,7 +243,7 @@ void __lockfunc __write_lock(raw_rwlock_t *lock)
 
 EXPORT_SYMBOL(__write_lock);
 
-#else /* CONFIG_PREEMPT: */
+#else /* CONFIG_PREEMPT_SPINLOCK_WAITERS */
 
 /*
  * This could be a long-held lock. We both prepare to spin for a long
@@ -334,7 +333,7 @@ BUILD_LOCK_OPS(spin, raw_spinlock);
 BUILD_LOCK_OPS(read, raw_rwlock);
 BUILD_LOCK_OPS(write, raw_rwlock);
 
-#endif /* CONFIG_PREEMPT */
+#endif /* CONFIG_PREEMPT_SPINLOCK_WAITERS */
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 9208791..f2889b2 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -233,6 +233,7 @@ config DEBUG_LOCK_ALLOC
 	bool "Lock debugging: detect incorrect freeing of live locks"
 	depends on DEBUG_KERNEL && TRACE_IRQFLAGS_SUPPORT && STACKTRACE_SUPPORT && LOCKDEP_SUPPORT
 	select DEBUG_SPINLOCK
+	select DISABLE_PREEMPT_SPINLOCK_WAITERS
 	select DEBUG_MUTEXES
 	select LOCKDEP
 	help

