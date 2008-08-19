Return-Path: <linux-kernel-owner+w=401wt.eu-S1755192AbYHSIKz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192AbYHSIKz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 04:10:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753589AbYHSIKh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 04:10:37 -0400
Received: from smtpauth.hypersurf.com ([209.237.0.8]:50228 "EHLO
	smtpauth.hypersurf.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752752AbYHSIKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 04:10:35 -0400
Message-ID: <48AA7F47.5050805@hypersurf.com>
Date: Tue, 19 Aug 2008 01:07:35 -0700
From: Kevin Diggs <kevdig@hypersurf.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i486; en-US; rv:1.8b2) Gecko/20050724
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: [Fwd: Corrections please ...]
References: <48AA27AF.9070407@hypersurf.com> <20080819024125.GM19760@disturbed>
In-Reply-To: <20080819024125.GM19760@disturbed>
Content-Type: multipart/mixed;
 boundary="------------080403000003070805030906"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080403000003070805030906
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Dave Chinner wrote:
> On Mon, Aug 18, 2008 at 06:53:51PM -0700, Kevin Diggs wrote:
> 
>>Could someone ... anyone take a look at these kernel doc additions?
> 
> .....
> 
>>+/**
>>+ * complete: - signals a single thread waiting on this completion
>>+ * @x:  holds the state of this particular completion
>>+ *
>>+ * This will wake up a single thread waiting on this completion. If  
>>multiple
> 
> 
> Your mailer appears to be wrapping lines.
> 
> 
>>+ * threads are waiting ???
>>+ */
>> void complete(struct completion *x)
>> {
>>        unsigned long flags;
> 
> 
> complete() will only wake one waiting thread. If there are multiple
> waiters, then further calls to complete() are required to wake them,
> or a single call to complete_all() could be used.
> 
> 
>> EXPORT_SYMBOL(wait_for_completion);
>>
>>+/**

Take 2 ...

Files attached this time ...

kevin

--------------080403000003070805030906
Content-Type: text/plain;
 name="completion.h.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="completion.h.diff"

--- include/linux/completion.h.orig	2008-08-13 00:56:52.000000000 -0700
+++ include/linux/completion.h	2008-08-18 13:00:23.000000000 -0700
@@ -10,6 +10,16 @@
 
 #include <linux/wait.h>
 
+/**
+ * struct completion - structure used to maintain state for a "completion"
+ * @done:  counting variable used to signal completion
+ * @wait:  internal wait queue head; used for locking and synchronization
+ *
+ * This is the structure used to maintain the state for a "completion". See
+ * also:  complete(), wait_for_completion() (and friends _timeout,
+ * _interruptible, _interruptible_timeout, and _killable), init_completion(),
+ * and macros DECLARE_COMPLETION() and INIT_COMPLETION().
+ */
 struct completion {
 	unsigned int done;
 	wait_queue_head_t wait;
@@ -36,6 +46,13 @@
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

--------------080403000003070805030906
Content-Type: text/plain;
 name="sched.c.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="sched.c.diff"

--- kernel/sched.c.orig	2008-08-13 02:22:42.000000000 -0700
+++ kernel/sched.c	2008-08-19 00:42:41.000000000 -0700
@@ -4363,6 +4363,16 @@
 }
 EXPORT_SYMBOL_GPL(__wake_up_sync);	/* For internal use only */
 
+/**
+ * complete: - signals a single thread waiting on this completion
+ * @x:  holds the state of this particular completion
+ *
+ * This will wake up a single thread waiting on this completion. If multiple
+ * threads are waiting ??? (looking for comments on which thread/context will
+ * be awakened?)
+ *
+ * See also complete_all().
+ */
 void complete(struct completion *x)
 {
 	unsigned long flags;
@@ -4374,6 +4384,12 @@
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
@@ -4425,12 +4441,28 @@
 	return timeout;
 }
 
+/**
+ * wait_for_completion: - waits for completion of a task
+ * @x:  holds the state of this particular completion
+ *
+ * This waits to be signaled for completion of a specific task. It is NOT
+ * interruptible and there is no timeout.
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
@@ -4438,6 +4470,13 @@
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
@@ -4447,6 +4486,14 @@
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
@@ -4455,6 +4502,13 @@
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

--------------080403000003070805030906--
