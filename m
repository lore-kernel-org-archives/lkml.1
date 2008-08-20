Return-Path: <linux-kernel-owner+w=401wt.eu-S1757017AbYHTUDB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757017AbYHTUDB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 16:03:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754856AbYHTUCv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 16:02:51 -0400
Received: from smtpauth.hypersurf.com ([209.237.0.8]:49583 "EHLO
	smtpauth.hypersurf.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753832AbYHTUCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 16:02:51 -0400
Message-ID: <48AC7790.8010207@hypersurf.com>
Date: Wed, 20 Aug 2008 12:59:12 -0700
From: Kevin Diggs <kevdig@hypersurf.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i486; en-US; rv:1.8b2) Gecko/20050724
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       david@fromorbit.com, arnd@arndb.de,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, kevdig@hypersurf.com
Subject: Re: {NOT a PATCH} Corrections please ...
References: <48AB73A3.9010404@hypersurf.com> <20080820095908.GC28492@elte.hu> <48ABF880.5010605@s5r6.in-berlin.de>
In-Reply-To: <48ABF880.5010605@s5r6.in-berlin.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:
>>* Kevin Diggs <kevdig@hypersurf.com> wrote:
>>
>>>	It was recommended that I use a completion in a driver I am 
>>>working on.  While figuring out how to use one,
> 
> 
> Kevin, as a side note:  LDD3 chapter 5 pages 114 ff has some guidance.
> http://lwn.net/Kernel/LDD3/
> I'm only pointing to it for the unlikely case that you didn't come
> across LDD3 yet.  The dead tree version is affordable too, and more
> comfortable to read than the online version.

Oh! I have that! That is how I figured out that complete() is used to
signal that the wait thingies don't have to wait anymore.

Here is the latest (maybe line wrap is set to 99 so it won't be goofed
anymore?):

--- include/linux/completion.h.orig	2008-08-13 00:56:52.000000000 -0700
+++ include/linux/completion.h	2008-08-20 01:47:21.000000000 -0700
@@ -10,6 +10,18 @@

  #include <linux/wait.h>

+/**
+ * struct completion - structure used to maintain state for a "completion"
+ *
+ * This is the opaque structure used to maintain the state for a "completion".
+ * Completions currently use a FIFO to queue threads that have to wait for
+ * the "completion" event.
+ *
+ * See also:  complete(), wait_for_completion() (and friends _timeout,
+ * _interruptible, _interruptible_timeout, and _killable), init_completion(),
+ * and macros DECLARE_COMPLETION(), DECLARE_COMPLETION_ONSTACK(), and
+ * INIT_COMPLETION().
+ */
  struct completion {
  	unsigned int done;
  	wait_queue_head_t wait;
@@ -21,6 +33,14 @@
  #define COMPLETION_INITIALIZER_ONSTACK(work) \
  	({ init_completion(&work); work; })

+/**
+ * DECLARE_COMPLETION: - declare and initialize a completion structure
+ * @work:  identifier for the completion structure
+ *
+ * This macro declares and initializes a completion structure. Generally used
+ * for static declarations. You should use the _ONSTACK variant for automatic
+ * variables.
+ */
  #define DECLARE_COMPLETION(work) \
  	struct completion work = COMPLETION_INITIALIZER(work)

@@ -29,6 +49,13 @@
   * completions - so we use the _ONSTACK() variant for those that
   * are on the kernel stack:
   */
+/**
+ * DECLARE_COMPLETION_ONSTACK: - declare and initialize a completion structure
+ * @work:  identifier for the completion structure
+ *
+ * This macro declares and initializes a completion structure on the kernel
+ * stack.
+ */
  #ifdef CONFIG_LOCKDEP
  # define DECLARE_COMPLETION_ONSTACK(work) \
  	struct completion work = COMPLETION_INITIALIZER_ONSTACK(work)
@@ -36,6 +63,13 @@
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
@@ -53,6 +87,13 @@
  extern void complete(struct completion *);
  extern void complete_all(struct completion *);

+/**
+ * INIT_COMPLETION: - reinitialize a completion structure
+ * @x:  completion structure to be reinitialized
+ *
+ * This macro should be used to reinitialize a completion structure so it can
+ * be reused. This is especially important after complete_all() is used.
+ */
  #define INIT_COMPLETION(x)	((x).done = 0)

  #endif


--- kernel/sched.c.orig	2008-08-13 02:22:42.000000000 -0700
+++ kernel/sched.c	2008-08-20 12:36:01.000000000 -0700
@@ -4363,6 +4363,15 @@
  }
  EXPORT_SYMBOL_GPL(__wake_up_sync);	/* For internal use only */

+/**
+ * complete: - signals a single thread waiting on this completion
+ * @x:  holds the state of this particular completion
+ *
+ * This will wake up a single thread waiting on this completion. Threads will be
+ * awakened in the same order in which they were queued.
+ *
+ * See also complete_all(), wait_for_completion() and related routines.
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
+ * This will wake up all threads waiting on this particular completion event.
+ */
  void complete_all(struct completion *x)
  {
  	unsigned long flags;
@@ -4425,12 +4440,31 @@
  	return timeout;
  }

+/**
+ * wait_for_completion: - waits for completion of a task
+ * @x:  holds the state of this particular completion
+ *
+ * This waits to be signaled for completion of a specific task. It is NOT
+ * interruptible and there is no timeout.
+ *
+ * See also similar routines (i.e. wait_for_completion_timeout()) with timeout
+ * and interrupt capability. Also see complete().
+ */
  void __sched wait_for_completion(struct completion *x)
  {
  	wait_for_common(x, MAX_SCHEDULE_TIMEOUT, TASK_UNINTERRUPTIBLE);
  }
  EXPORT_SYMBOL(wait_for_completion);

+/**
+ * wait_for_completion_timeout: - waits for completion of a task (w/timeout)
+ * @x:  holds the state of this particular completion
+ * @timeout:  timeout value in jiffies
+ *
+ * This waits for either a completion of a specific task to be signaled or for a
+ * specified timeout to expire. The timeout is in jiffies. It is not
+ * interruptible.
+ */
  unsigned long __sched
  wait_for_completion_timeout(struct completion *x, unsigned long timeout)
  {
@@ -4438,6 +4472,13 @@
  }
  EXPORT_SYMBOL(wait_for_completion_timeout);

+/**
+ * wait_for_completion_interruptible: - waits for completion of a task (w/intr)
+ * @x:  holds the state of this particular completion
+ *
+ * This waits for completion of a specific task to be signaled. It is
+ * interruptible.
+ */
  int __sched wait_for_completion_interruptible(struct completion *x)
  {
  	long t = wait_for_common(x, MAX_SCHEDULE_TIMEOUT, TASK_INTERRUPTIBLE);
@@ -4447,6 +4488,14 @@
  }
  EXPORT_SYMBOL(wait_for_completion_interruptible);

+/**
+ * wait_for_completion_interruptible_timeout: - waits for completion (w/(to,intr))
+ * @x:  holds the state of this particular completion
+ * @timeout:  timeout value in jiffies
+ *
+ * This waits for either a completion of a specific task to be signaled or for a
+ * specified timeout to expire. It is interruptible. The timeout is in jiffies.
+ */
  unsigned long __sched
  wait_for_completion_interruptible_timeout(struct completion *x,
  					  unsigned long timeout)
@@ -4455,6 +4504,13 @@
  }
  EXPORT_SYMBOL(wait_for_completion_interruptible_timeout);

+/**
+ * wait_for_completion_killable: - waits for completion of a task (killable)
+ * @x:  holds the state of this particular completion
+ *
+ * This waits to be signaled for completion of a specific task. It can be
+ * interrupted by a kill signal.
+ */
  int __sched wait_for_completion_killable(struct completion *x)
  {
  	long t = wait_for_common(x, MAX_SCHEDULE_TIMEOUT, TASK_KILLABLE);
