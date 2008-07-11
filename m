Return-Path: <linux-kernel-owner+w=401wt.eu-S1760294AbYGKBPA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760294AbYGKBPA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 21:15:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757377AbYGKBN6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 21:13:58 -0400
Received: from ipmail01.adl6.internode.on.net ([203.16.214.146]:54307 "EHLO
	ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756963AbYGKBN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 21:13:57 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAF9Odkh5LFxA/2dsb2JhbACxSA
X-IronPort-AV: E=Sophos;i="4.30,341,1212330600"; 
   d="scan'208";a="146350272"
From: Dave Chinner <david@fromorbit.com>
To: xfs@oss.sgi.com
Cc: linux-kernel@vger.kernel.org, matthew@wil.cx,
       Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/6] Extend completions to provide XFS object flush requirements
Date: Fri, 11 Jul 2008 11:13:47 +1000
Message-Id: <1215738830-31048-4-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1215738830-31048-1-git-send-email-david@fromorbit.com>
References: <1215738830-31048-1-git-send-email-david@fromorbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

XFS object flushing doesn't quite match existing completion semantics.  It
mixed exclusive access with completion. That is, we need to mark an object as
being flushed before flushing it to disk, and then block any other attempt to
flush it until the completion occurs. We do this but adding an extra count
to the completion before we start using them. However, we still need
to determine if there is a completion in progress, and allow no-blocking
attempts fo completions to decrement the count.

To do this we introduce:

int try_wait_for_completion(struct completion *x)
	returns a failure status if done == 0, otherwise decrements done
	to zero and returns a "started" status. This is provided
	to allow counted completions to begin safely while holding
	object locks in inverted order.

int completion_done(struct completion *x)
	returns 1 if there is no waiter, 0 if there is a waiter
	(i.e. a completion in progress).

This replaces the use of semaphores for providing this exclusion
and completion mechanism.

Version 2:
o remove "flush" based API and just add the minimum necessary
  extensions to allow counting completions to do what is needed
  by XFS.
o docbook format comments

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 include/linux/completion.h |   45 ++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 45 insertions(+), 0 deletions(-)

diff --git a/include/linux/completion.h b/include/linux/completion.h
index d2961b6..57faa60 100644
--- a/include/linux/completion.h
+++ b/include/linux/completion.h
@@ -55,4 +55,49 @@ extern void complete_all(struct completion *);
 
 #define INIT_COMPLETION(x)	((x).done = 0)
 
+
+/**
+ *	try_wait_for_completion - try to decrement a completion without blocking
+ *	@x:	completion structure
+ *
+ *	Returns: 0 if a decrement cannot be done without blocking
+ *		 1 if a decrement succeeded.
+ *
+ *	If a completion is being used as a counting completion,
+ *	attempt to decrement the counter without blocking. This
+ *	enables us to avoid waiting if the resource the completion
+ *	is protecting is not available.
+ */
+static inline bool try_wait_for_completion(struct completion *x)
+{
+	int ret = 1;
+
+	spin_lock_irq(&x->wait.lock);
+	if (!x->done)
+		ret = 0;
+	else
+		x->done--;
+	spin_unlock_irq(&x->wait.lock);
+	return ret;
+}
+
+/**
+ *	completion_done - Test to see if a completion has any waiters
+ *	@x:	completion structure
+ *
+ *	Returns: 0 if there are waiters (wait_for_completion() in progress)
+ *		 1 if there are no waiters.
+ *
+ */
+static inline bool completion_done(struct completion *x)
+{
+	int ret = 1;
+
+	spin_lock_irq(&x->wait.lock);
+	if (!x->done)
+		ret = 0;
+	spin_unlock_irq(&x->wait.lock);
+	return ret;
+}
+
 #endif
-- 
1.5.6

