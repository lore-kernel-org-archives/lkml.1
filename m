Return-Path: <linux-kernel-owner+w=401wt.eu-S1751338AbXBVAUV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751338AbXBVAUV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 19:20:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751354AbXBVAUV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 19:20:21 -0500
Received: from nic.NetDirect.CA ([216.16.235.2]:51616 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338AbXBVAUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 19:20:20 -0500
X-Originating-Ip: 74.109.98.130
Date: Wed, 21 Feb 2007 19:18:08 -0500 (EST)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Linux kernel mailing list <linux-kernel@vger.kernel.org>
cc: rth@twiddle.net
Subject: [PATCH] kconfig:  Centralize the selection of semaphore debugging
 in lib/Kconfig.debug.
Message-ID: <Pine.LNX.4.64.0702211910380.6566@CPE00045a9c397f-CM001225dbafb6>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.723, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, TW_RW 0.08)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


  Remove the Kconfig selection of semaphore debugging from the ALPHA
and FRV Kconfig files, and centralize it in lib/Kconfig.debug.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

  there doesn't seem to be much point in letting individual
architectures independently define the same Kconfig option when it can
just as easily be put in a single Kconfig file and made dependent on a
subset of architectures.  that way, at least the option shows up in
the same relative location in the menu each time.

  not compile tested, but at least "make ARCH=??? menuconfig" tested.


 arch/alpha/Kconfig.debug    |    8 --------
 arch/frv/kernel/semaphore.c |    2 +-
 include/asm-frv/semaphore.h |   14 ++++++--------
 lib/Kconfig.debug           |   10 ++++++++++
 4 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/arch/alpha/Kconfig.debug b/arch/alpha/Kconfig.debug
index 36d0106..f45f28c 100644
--- a/arch/alpha/Kconfig.debug
+++ b/arch/alpha/Kconfig.debug
@@ -16,14 +16,6 @@ config DEBUG_RWLOCK
 	  too many attempts.  If you suspect a rwlock problem or a kernel
 	  hacker asks for this option then say Y.  Otherwise say N.

-config DEBUG_SEMAPHORE
-	bool "Semaphore debugging"
-	depends on DEBUG_KERNEL
-	help
-	  If you say Y here then semaphore processing will issue lots of
-	  verbose debugging messages.  If you suspect a semaphore problem or a
-	  kernel hacker asks for this option then say Y.  Otherwise say N.
-
 config ALPHA_LEGACY_START_ADDRESS
 	bool "Legacy kernel start address"
 	depends on ALPHA_GENERIC
diff --git a/arch/frv/kernel/semaphore.c b/arch/frv/kernel/semaphore.c
index f278cdf..8e182ce 100644
--- a/arch/frv/kernel/semaphore.c
+++ b/arch/frv/kernel/semaphore.c
@@ -19,7 +19,7 @@ struct sem_waiter {
 	struct task_struct	*task;
 };

-#if SEMAPHORE_DEBUG
+#ifdef CONFIG_DEBUG_SEMAPHORE
 void semtrace(struct semaphore *sem, const char *str)
 {
 	if (sem->debug)
diff --git a/include/asm-frv/semaphore.h b/include/asm-frv/semaphore.h
index 907c5c3..0958652 100644
--- a/include/asm-frv/semaphore.h
+++ b/include/asm-frv/semaphore.h
@@ -20,8 +20,6 @@
 #include <linux/spinlock.h>
 #include <linux/rwsem.h>

-#define SEMAPHORE_DEBUG		0
-
 /*
  * the semaphore definition
  * - if counter is >0 then there are tokens available on the semaphore for down to collect
@@ -32,12 +30,12 @@ struct semaphore {
 	unsigned		counter;
 	spinlock_t		wait_lock;
 	struct list_head	wait_list;
-#if SEMAPHORE_DEBUG
+#ifdef CONFIG_DEBUG_SEMAPHORE
 	unsigned		__magic;
 #endif
 };

-#if SEMAPHORE_DEBUG
+#ifdef CONFIG_DEBUG_SEMAPHORE
 # define __SEM_DEBUG_INIT(name) , (long)&(name).__magic
 #else
 # define __SEM_DEBUG_INIT(name)
@@ -76,7 +74,7 @@ static inline void down(struct semaphore *sem)
 {
 	unsigned long flags;

-#if SEMAPHORE_DEBUG
+#ifdef CONFIG_DEBUG_SEMAPHORE
 	CHECK_MAGIC(sem->__magic);
 #endif

@@ -95,7 +93,7 @@ static inline int down_interruptible(struct semaphore *sem)
 	unsigned long flags;
 	int ret = 0;

-#if SEMAPHORE_DEBUG
+#ifdef CONFIG_DEBUG_SEMAPHORE
 	CHECK_MAGIC(sem->__magic);
 #endif

@@ -119,7 +117,7 @@ static inline int down_trylock(struct semaphore *sem)
 	unsigned long flags;
 	int success = 0;

-#if SEMAPHORE_DEBUG
+#ifdef CONFIG_DEBUG_SEMAPHORE
 	CHECK_MAGIC(sem->__magic);
 #endif

@@ -136,7 +134,7 @@ static inline void up(struct semaphore *sem)
 {
 	unsigned long flags;

-#if SEMAPHORE_DEBUG
+#ifdef CONFIG_DEBUG_SEMAPHORE
 	CHECK_MAGIC(sem->__magic);
 #endif

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 3f3e740..16e1b81 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -201,6 +201,16 @@ config DEBUG_MUTEXES
 	 This feature allows mutex semantics violations to be detected and
 	 reported.

+config DEBUG_SEMAPHORE
+	bool "Semaphore debugging"
+	depends on DEBUG_KERNEL
+	depends on ALPHA || FRV
+	default n
+	help
+	  If you say Y here then semaphore processing will issue lots of
+	  verbose debugging messages.  If you suspect a semaphore problem or a
+	  kernel hacker asks for this option then say Y.  Otherwise say N.
+
 config DEBUG_LOCK_ALLOC
 	bool "Lock debugging: detect incorrect freeing of live locks"
 	depends on DEBUG_KERNEL && TRACE_IRQFLAGS_SUPPORT && STACKTRACE_SUPPORT && LOCKDEP_SUPPORT

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
