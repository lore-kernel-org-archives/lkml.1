Return-Path: <linux-kernel-owner+w=401wt.eu-S933198AbXAaNdz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933198AbXAaNdz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 08:33:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933208AbXAaNdz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 08:33:55 -0500
Received: from nic.NetDirect.CA ([216.16.235.2]:33485 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933198AbXAaNdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 08:33:54 -0500
X-Originating-Ip: 74.109.98.130
Date: Wed, 31 Jan 2007 08:32:41 -0500 (EST)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Linux kernel mailing list <linux-kernel@vger.kernel.org>
cc: dhowells@redhat.com, rth@twiddle.net
Subject: [PATCH] Centralize the selection for debugging semaphores.
Message-ID: <Pine.LNX.4.64.0701310825500.4627@CPE00045a9c397f-CM001225dbafb6>
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


  Centralize the kernel config option for debugging semaphores and
modify the macro for frv to use that config option instead.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

  at the moment, two architectures have support for debugging
semaphores:  alpha (with a local Kconfig.debug option), and frv (with
a hard-coded "SEMAPHORE_DEBUG" macro).

  it would seem to make more sense to simply have a universal kernel
config option for debugging semaphores in lib/Kconfig.debug, and let
any architecture work off of that.

  obviously, only two architectures would take advantage of it right
now, but the "help" screen for the new config option mentions that,
and it's trivial to add new architectures.


 arch/alpha/Kconfig.debug    |    8 --------
 arch/frv/kernel/semaphore.c |    2 +-
 include/asm-frv/semaphore.h |   14 ++++++--------
 lib/Kconfig.debug           |   11 +++++++++++
 4 files changed, 18 insertions(+), 17 deletions(-)

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
index 5c26818..17c4524 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -181,6 +181,17 @@ config DEBUG_MUTEXES
 	 This feature allows mutex semantics violations to be detected and
 	 reported.

+config DEBUG_SEMAPHORE
+	bool "Semaphore debugging"
+	depends on DEBUG_KERNEL
+	default n
+	help
+	  If you say Y here then semaphore processing will issue lots of
+	  verbose debugging messages.  If you suspect a semaphore problem or a
+	  kernel hacker asks for this option then say Y.  Otherwise say N.
+
+	  At the moment, this is implemented only by alpha and frv.
+
 config DEBUG_RWSEMS
 	bool "RW-sem debugging: basic checks"
 	depends on DEBUG_KERNEL

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://www.fsdev.dreamhosters.com/wiki/index.php?title=Main_Page
========================================================================
