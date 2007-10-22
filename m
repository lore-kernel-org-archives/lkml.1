Return-Path: <linux-kernel-owner+w=401wt.eu-S1753184AbXJVIeZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184AbXJVIeZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 04:34:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751514AbXJVIeS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 04:34:18 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47993 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751482AbXJVIeR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 04:34:17 -0400
Date: Mon, 22 Oct 2007 10:33:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeff Dike <jdike@addtoit.com>
Cc: Andrew Morton <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fix wait_for_completion_interruptible declaration
	mismatch
Message-ID: <20071022083359.GB28528@elte.hu>
References: <20071012164424.GA7709@c2.user-mode-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071012164424.GA7709@c2.user-mode-linux.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeff Dike <jdike@addtoit.com> wrote:

> Without the fastcall, I get a declaration mismatch between the 
> definition here and the declaration in completion.h.
> 
> Signed-off-by: Jeff Dike <jdike@linux.intel.com>

indeed! Note that i went for the fix below instead - we can just remove 
all the fastcall attributes from these APIs, they are never used from 
assembly directly.

	Ingo

---------->
Subject: sched: fix fastcall mismatch in completion APIs
From: Ingo Molnar <mingo@elte.hu>

Jeff Dike noticed that wait_for_completion_interruptible()'s prototype
had a mismatched fastcall.

Fix this by removing the fastcall attributes from all the completion APIs.

Found-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/completion.h |   16 ++++++++--------
 kernel/sched.c             |   10 +++++-----
 2 files changed, 13 insertions(+), 13 deletions(-)

Index: linux/include/linux/completion.h
===================================================================
--- linux.orig/include/linux/completion.h
+++ linux/include/linux/completion.h
@@ -42,15 +42,15 @@ static inline void init_completion(struc
 	init_waitqueue_head(&x->wait);
 }
 
-extern void FASTCALL(wait_for_completion(struct completion *));
-extern int FASTCALL(wait_for_completion_interruptible(struct completion *x));
-extern unsigned long FASTCALL(wait_for_completion_timeout(struct completion *x,
-						   unsigned long timeout));
-extern unsigned long FASTCALL(wait_for_completion_interruptible_timeout(
-			struct completion *x, unsigned long timeout));
+extern void wait_for_completion(struct completion *);
+extern int wait_for_completion_interruptible(struct completion *x);
+extern unsigned long wait_for_completion_timeout(struct completion *x,
+						   unsigned long timeout);
+extern unsigned long wait_for_completion_interruptible_timeout(
+			struct completion *x, unsigned long timeout);
 
-extern void FASTCALL(complete(struct completion *));
-extern void FASTCALL(complete_all(struct completion *));
+extern void complete(struct completion *);
+extern void complete_all(struct completion *);
 
 #define INIT_COMPLETION(x)	((x).done = 0)
 
Index: linux/kernel/sched.c
===================================================================
--- linux.orig/kernel/sched.c
+++ linux/kernel/sched.c
@@ -3838,7 +3838,7 @@ __wake_up_sync(wait_queue_head_t *q, uns
 }
 EXPORT_SYMBOL_GPL(__wake_up_sync);	/* For internal use only */
 
-void fastcall complete(struct completion *x)
+void complete(struct completion *x)
 {
 	unsigned long flags;
 
@@ -3850,7 +3850,7 @@ void fastcall complete(struct completion
 }
 EXPORT_SYMBOL(complete);
 
-void fastcall complete_all(struct completion *x)
+void complete_all(struct completion *x)
 {
 	unsigned long flags;
 
@@ -3902,13 +3902,13 @@ wait_for_common(struct completion *x, lo
 	return timeout;
 }
 
-void fastcall __sched wait_for_completion(struct completion *x)
+void __sched wait_for_completion(struct completion *x)
 {
 	wait_for_common(x, MAX_SCHEDULE_TIMEOUT, TASK_UNINTERRUPTIBLE);
 }
 EXPORT_SYMBOL(wait_for_completion);
 
-unsigned long fastcall __sched
+unsigned long __sched
 wait_for_completion_timeout(struct completion *x, unsigned long timeout)
 {
 	return wait_for_common(x, timeout, TASK_UNINTERRUPTIBLE);
@@ -3924,7 +3924,7 @@ int __sched wait_for_completion_interrup
 }
 EXPORT_SYMBOL(wait_for_completion_interruptible);
 
-unsigned long fastcall __sched
+unsigned long __sched
 wait_for_completion_interruptible_timeout(struct completion *x,
 					  unsigned long timeout)
 {
