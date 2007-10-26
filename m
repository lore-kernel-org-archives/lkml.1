Return-Path: <linux-kernel-owner+w=401wt.eu-S1763785AbXJZQGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763785AbXJZQGR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 12:06:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753677AbXJZQGG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 12:06:06 -0400
Received: from lizzard.sbs.de ([194.138.37.39]:21728 "EHLO lizzard.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752946AbXJZQGF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 12:06:05 -0400
X-Greylist: delayed 1634 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Oct 2007 12:06:05 EDT
Message-ID: <472209EB.50600@siemens.com>
Date: Fri, 26 Oct 2007 17:38:19 +0200
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] Fix plist initialisation for CONFIG_DEBUG_PI_LIST
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

PLIST_NODE_INIT (once used, only in -rt ATM) will fail when
CONFIG_DEBUG_PI_LIST is enabled as it then generates a &NULL
statement. This patch fixes the issue indirectly by turning
the _lock argument of PLIST_HEAD_INIT into a pointer and
adopting its users.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>

---
 include/linux/plist.h   |    4 ++--
 include/linux/rtmutex.h |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

Index: linux-2.6.23.1-rt/include/linux/plist.h
===================================================================
--- linux-2.6.23.1-rt.orig/include/linux/plist.h
+++ linux-2.6.23.1-rt/include/linux/plist.h
@@ -99,13 +99,13 @@ struct plist_node {
 /**
  * PLIST_HEAD_INIT - static struct plist_head initializer
  * @head:	struct plist_head variable name
- * @_lock:	lock to initialize for this list
+ * @_lock:	lock * to initialize for this list
  */
 #define PLIST_HEAD_INIT(head, _lock)			\
 {							\
 	.prio_list = LIST_HEAD_INIT((head).prio_list),	\
 	.node_list = LIST_HEAD_INIT((head).node_list),	\
-	PLIST_HEAD_LOCK_INIT(&(_lock))			\
+	PLIST_HEAD_LOCK_INIT(_lock)			\
 }
 
 /**
Index: linux-2.6.23.1-rt/include/linux/rtmutex.h
===================================================================
--- linux-2.6.23.1-rt.orig/include/linux/rtmutex.h
+++ linux-2.6.23.1-rt/include/linux/rtmutex.h
@@ -64,7 +64,7 @@ struct hrtimer_sleeper;
 
 #define __RT_MUTEX_INITIALIZER(mutexname) \
 	{ .wait_lock = RAW_SPIN_LOCK_UNLOCKED(mutexname) \
-	, .wait_list = PLIST_HEAD_INIT(mutexname.wait_list, mutexname.wait_lock) \
+	, .wait_list = PLIST_HEAD_INIT(mutexname.wait_list, &mutexname.wait_lock) \
 	, .owner = NULL \
 	__DEBUG_RT_MUTEX_INITIALIZER(mutexname)}
 
@@ -98,7 +98,7 @@ extern void rt_mutex_unlock(struct rt_mu
 
 #ifdef CONFIG_RT_MUTEXES
 # define INIT_RT_MUTEXES(tsk)						\
-	.pi_waiters	= PLIST_HEAD_INIT(tsk.pi_waiters, tsk.pi_lock),	\
+	.pi_waiters = PLIST_HEAD_INIT(tsk.pi_waiters, &tsk.pi_lock),	\
 	INIT_RT_MUTEX_DEBUG(tsk)
 #else
 # define INIT_RT_MUTEXES(tsk)
