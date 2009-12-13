Return-Path: <linux-kernel-owner+w=401wt.eu-S1751554AbZLMHiI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751554AbZLMHiI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 02:38:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751308AbZLMHiF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 02:38:05 -0500
Received: from hera.kernel.org ([140.211.167.34]:48666 "HELO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751300AbZLMHiB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 02:38:01 -0500
Date: Sun, 13 Dec 2009 07:36:42 GMT
From: "tip-bot for Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       hpa@zytor.com, mingo@redhat.com, stern@rowland.harvard.edu,
       a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
       rui.zhang@intel.com, lachlan@sgi.com, david@fromorbit.com,
       tglx@linutronix.de, rjw@sisk.pl, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, stern@rowland.harvard.edu,
       torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
       rui.zhang@intel.com, lachlan@sgi.com, tglx@linutronix.de,
       david@fromorbit.com, rjw@sisk.pl, mingo@elte.hu
In-Reply-To: <200912130007.30541.rjw@sisk.pl>
References: <200912130007.30541.rjw@sisk.pl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Make wakeup side and atomic variants of completion API irq safe
Message-ID: <tip-7539a3b3d1f892dd97eaf094134d7de55c13befe@git.kernel.org>
Git-Commit-ID: 7539a3b3d1f892dd97eaf094134d7de55c13befe
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7539a3b3d1f892dd97eaf094134d7de55c13befe
Gitweb:     http://git.kernel.org/tip/7539a3b3d1f892dd97eaf094134d7de55c13befe
Author:     Rafael J. Wysocki <rjw@sisk.pl>
AuthorDate: Sun, 13 Dec 2009 00:07:30 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 13 Dec 2009 08:12:46 +0100

sched: Make wakeup side and atomic variants of completion API irq safe

Alan Stern noticed that all the wakeup side (and atomic) variants of the
completion APIs should be irq safe, but the newly introduced
completion_done() and try_wait_for_completion() aren't. The use of the
irq unsafe variants in IRQ contexts can cause crashes/hangs.

Fix the problem by making them use spin_lock_irqsave() and
spin_lock_irqrestore().

Reported-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Zhang Rui <rui.zhang@intel.com>
Cc: pm list <linux-pm@lists.linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: David Chinner <david@fromorbit.com>
Cc: Lachlan McIlroy <lachlan@sgi.com>
LKML-Reference: <200912130007.30541.rjw@sisk.pl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index ff39cad..8b3532f 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -5908,14 +5908,15 @@ EXPORT_SYMBOL(wait_for_completion_killable);
  */
 bool try_wait_for_completion(struct completion *x)
 {
+	unsigned long flags;
 	int ret = 1;
 
-	spin_lock_irq(&x->wait.lock);
+	spin_lock_irqsave(&x->wait.lock, flags);
 	if (!x->done)
 		ret = 0;
 	else
 		x->done--;
-	spin_unlock_irq(&x->wait.lock);
+	spin_unlock_irqrestore(&x->wait.lock, flags);
 	return ret;
 }
 EXPORT_SYMBOL(try_wait_for_completion);
@@ -5930,12 +5931,13 @@ EXPORT_SYMBOL(try_wait_for_completion);
  */
 bool completion_done(struct completion *x)
 {
+	unsigned long flags;
 	int ret = 1;
 
-	spin_lock_irq(&x->wait.lock);
+	spin_lock_irqsave(&x->wait.lock, flags);
 	if (!x->done)
 		ret = 0;
-	spin_unlock_irq(&x->wait.lock);
+	spin_unlock_irqrestore(&x->wait.lock, flags);
 	return ret;
 }
 EXPORT_SYMBOL(completion_done);
