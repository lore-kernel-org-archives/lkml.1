Return-Path: <linux-kernel-owner+w=401wt.eu-S933792AbXBZHWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933792AbXBZHWU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 02:22:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933786AbXBZHVw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 02:21:52 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:57897 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964814AbXBZHVQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 02:21:16 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@osdl.org>
Subject: [PATCH -mm 1/6] Freezer: Read PF_BORROWED_MM in a nonracy way
Date: Mon, 26 Feb 2007 08:02:48 +0100
User-Agent: KMail/1.9.5
Cc: Pavel Machek <pavel@ucw.cz>, LKML <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@tv-sign.ru>, Aneesh Kumar <aneesh.kumar@gmail.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>
References: <200702260800.49603.rjw@sisk.pl>
In-Reply-To: <200702260800.49603.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702260802.49295.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

The reading of PF_BORROWED_MM in is_user_space() without task_lock() is racy.
Fix it.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
---
 kernel/power/process.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

Index: linux-2.6.20-mm2/kernel/power/process.c
===================================================================
--- linux-2.6.20-mm2.orig/kernel/power/process.c
+++ linux-2.6.20-mm2/kernel/power/process.c
@@ -8,6 +8,7 @@
 
 #undef DEBUG
 
+#include <linux/sched.h>
 #include <linux/smp_lock.h>
 #include <linux/interrupt.h>
 #include <linux/suspend.h>
@@ -92,7 +93,12 @@ static void cancel_freezing(struct task_
 
 static inline int is_user_space(struct task_struct *p)
 {
-	return p->mm && !(p->flags & PF_BORROWED_MM);
+	int ret;
+
+	task_lock(p);
+	ret = p->mm && !(p->flags & PF_BORROWED_MM);
+	task_unlock(p);
+	return ret;
 }
 
 static unsigned int try_to_freeze_tasks(int freeze_user_space)

