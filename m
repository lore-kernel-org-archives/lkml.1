Return-Path: <linux-kernel-owner+w=401wt.eu-S1756665AbYHTBdf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756665AbYHTBdf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 21:33:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752299AbYHTBd1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 21:33:27 -0400
Received: from smtpauth.hypersurf.com ([209.237.0.8]:64442 "EHLO
	smtpauth.hypersurf.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751442AbYHTBd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 21:33:26 -0400
Message-ID: <48AB73A3.9010404@hypersurf.com>
Date: Tue, 19 Aug 2008 18:30:11 -0700
From: Kevin Diggs <kevdig@hypersurf.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i486; en-US; rv:1.8b2) Gecko/20050724
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: david@fromorbit.com, stefanr@s5r6.in-berlin.de, arnd@arndb.de
Subject: {NOT a PATCH} Corrections please ...
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

	It was recommended that I use a completion in a driver I am working on. 
While figuring out how to use one, I noticed that there was no kernel 
doc block comments. I am trying to add them. I would rather not have to 
respin the patch for corrections.

--- include/linux/completion.h.orig	2008-08-13 00:56:52.000000000 -0700
+++ include/linux/completion.h	2008-08-19 17:47:49.000000000 -0700
@@ -10,6 +10,14 @@

  #include <linux/wait.h>

+/**
+ * struct completion - structure used to maintain state for a "completion"
+ *
+ * This is the opaque structure used to maintain the state for a 
"completion".
+ * See also:  complete(), wait_for_completion() (and friends _timeout,
+ * _interruptible, _interruptible_timeout, and _killable), 
init_completion(),
+ * and macros DECLARE_COMPLETION() and INIT_COMPLETION().
+ */
  struct completion {
  	unsigned int done;
  	wait_queue_head_t wait;
@@ -21,6 +29,14 @@
  #define COMPLETION_INITIALIZER_ONSTACK(work) \
  	({ init_completion(&work); work; })

+/**
+ * DECLARE_COMPLETION: - declare and initialize a completion structure
+ * @work:  identifier for the completion structure
+ *
+ * This macro declares and initializes a completion structure. 
Generally used
+ * for static declarations. You should use the _ONSTACK variant for 
automatic
+ * variables.
+ */
  #define DECLARE_COMPLETION(work) \
  	struct completion work = COMPLETION_INITIALIZER(work)

@@ -29,6 +45,13 @@
   * completions - so we use the _ONSTACK() variant for those that
   * are on the kernel stack:
   */
+/**
+ * DECLARE_COMPLETION_ONSTACK: - declare and initialize a completion 
structure
+ * @work:  identifier for the completion structure
+ *
+ * This macro declares and initializes a completion structure on the kernel
+ * stack.
+ */
  #ifdef CONFIG_LOCKDEP
  # define DECLARE_COMPLETION_ONSTACK(work) \
  	struct completion work = COMPLETION_INITIALIZER_ONSTACK(work)
@@ -36,6 +59,13 @@
  # define DECLARE_COMPLETION_ONSTACK(work) DECLARE_COMPLETION(work)
  #endif

+/**
+ * init_completion: - Initialize a dynamically allocated completion
+ * @x:  completion structure that is to be initialized
+ *
+ * This inline function will initialize a dynamically created completion
+ * structure.
+ */
  static inline void init_completion(struct completion *x)
  {
  	x->done = 0;
@@ -53,6 +83,13 @@
  extern void complete(struct completion *);
  extern void complete_all(struct completion *);

+/**
+ * INIT_COMPLETION: - reinitialize a completion structure
+ * @x:  completion structure to be reinitialized
+ *
+ * This macro should be used to reinitialize a completion structure so 
it can
+ * be reused. This is especially important after complete_all() is used.
+ */
  #define INIT_COMPLETION(x)	((x).done = 0)

  #endif


--- kernel/sched.c.orig	2008-08-13 02:22:42.000000000 -0700
+++ kernel/sched.c	2008-08-19 17:12:36.000000000 -0700
@@ -4363,6 +4363,15 @@
  }
  EXPORT_SYMBOL_GPL(__wake_up_sync);	/* For internal use only */

+/**
+ * complete: - signals a single thread waiting on this completion
+ * @x:  holds the state of this particular completion
+ *
+ * This will wake up a single thread waiting on this completion. 
Threads will be
+ * awakened in the same order in which they were queued.
+ *
+ * See also complete_all().
+ */
  void complete(struct completion *x)
  {
  	unsigned long flags;
@@ -4374,6 +4383,12 @@
  }
  EXPORT_SYMBOL(complete);

+/**
+ * complete_all: - signals all threads waiting on this completion
+ * @x:  holds the state of this particular completion
+ *
+ * This will wake up all threads waiting on this particular completion 
event.
+ */
  void complete_all(struct completion *x)
  {
  	unsigned long flags;
@@ -4425,12 +4440,30 @@
  	return timeout;
  }

+/**
+ * wait_for_completion: - waits for completion of a task
+ * @x:  holds the state of this particular completion
+ *
+ * This waits to be signaled for completion of a specific task. It is NOT
+ * interruptible and there is no timeout. If it is necessary for the 
thread to
+ * wait it will be added to the tail of the wait queue.
+ */
  void __sched wait_for_completion(struct completion *x)
  {
  	wait_for_common(x, MAX_SCHEDULE_TIMEOUT, TASK_UNINTERRUPTIBLE);
  }
  EXPORT_SYMBOL(wait_for_completion);

+/**
+ * wait_for_completion_timeout: - waits for completion of a task 
(w/timeout)
+ * @x:  holds the state of this particular completion
+ * @timeout:  timeout value in jiffies
+ *
+ * This waits for either a completion of a specific task to be signaled 
or for a
+ * specified timeout to expire. The timeout is in jiffies. It is not
+ * interruptible. If it is necessary for the thread to wait it will be
+ * added to the tail of the wait queue.
+ */
  unsigned long __sched
  wait_for_completion_timeout(struct completion *x, unsigned long timeout)
  {
@@ -4438,6 +4471,14 @@
  }
  EXPORT_SYMBOL(wait_for_completion_timeout);

+/**
+ * wait_for_completion_interruptible: - waits for completion of a task 
(w/intr)
+ * @x:  holds the state of this particular completion
+ *
+ * This waits for completion of a specific task to be signaled. It is
+ * interruptible. If it is necessary for the thread to wait it will be
+ * added to the tail of the wait queue.
+ */
  int __sched wait_for_completion_interruptible(struct completion *x)
  {
  	long t = wait_for_common(x, MAX_SCHEDULE_TIMEOUT, TASK_INTERRUPTIBLE);
@@ -4447,6 +4488,16 @@
  }
  EXPORT_SYMBOL(wait_for_completion_interruptible);

+/**
+ * wait_for_completion_interruptible_timeout: - waits for completion 
(w/(to,intr))
+ * @x:  holds the state of this particular completion
+ * @timeout:  timeout value in jiffies
+ *
+ * This waits for either a completion of a specific task to be signaled 
or for a
+ * specified timeout to expire. It is interruptible. The timeout is in 
jiffies.
+ * If it is necessary for the thread to wait it will be added to the 
tail of
+ * the wait queue.
+ */
  unsigned long __sched
  wait_for_completion_interruptible_timeout(struct completion *x,
  					  unsigned long timeout)
@@ -4455,6 +4506,14 @@
  }
  EXPORT_SYMBOL(wait_for_completion_interruptible_timeout);

+/**
+ * wait_for_completion_killable: - waits for completion of a task 
(killable)
+ * @x:  holds the state of this particular completion
+ *
+ * This waits to be signaled for completion of a specific task. It can be
+ * interrupted by a kill signal. If it is necessary for the thread to
+ * wait it will be added to the tail of the wait queue.
+ */
  int __sched wait_for_completion_killable(struct completion *x)
  {
  	long t = wait_for_common(x, MAX_SCHEDULE_TIMEOUT, TASK_KILLABLE);
