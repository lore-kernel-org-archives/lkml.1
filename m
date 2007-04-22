Return-Path: <linux-kernel-owner+w=401wt.eu-S1030844AbXDVUBi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030844AbXDVUBi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 16:01:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030869AbXDVUBW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 16:01:22 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57643 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030844AbXDVUBT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 16:01:19 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [RFC][PATCH -mm 3/3] freezer: Fix problem with kthread_stop
Date: Sun, 22 Apr 2007 21:40:59 +0200
User-Agent: KMail/1.9.5
Cc: Ingo Molnar <mingo@elte.hu>, ego@in.ibm.com,
       Oleg Nesterov <oleg@tv-sign.ru>, linux-kernel@vger.kernel.org,
       vatsa@in.ibm.com, paulmck@us.ibm.com, pavel@ucw.cz
References: <20070419120131.GB13435@in.ibm.com> <20070420183118.GA695@elte.hu> <200704222128.49419.rjw@sisk.pl>
In-Reply-To: <200704222128.49419.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704222141.00680.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Fix the problem with kthread_stop() that causes the freezer to fail if a
freezable thread is attempting to stop a frozen one and that may cause the
freezer to fail if the thread being stopped is freezable and
try_to_freeze_tasks() is running concurrently with kthread_stop().

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 kernel/kthread.c |    9 +++++++++
 1 file changed, 9 insertions(+)

Index: linux-2.6.21-rc6-mm1/kernel/kthread.c
===================================================================
--- linux-2.6.21-rc6-mm1.orig/kernel/kthread.c	2007-04-09 15:23:48.000000000 +0200
+++ linux-2.6.21-rc6-mm1/kernel/kthread.c	2007-04-22 19:05:29.000000000 +0200
@@ -13,6 +13,7 @@
 #include <linux/file.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
+#include <linux/freezer.h>
 #include <asm/semaphore.h>
 
 /*
@@ -232,6 +233,14 @@ int kthread_stop(struct task_struct *k)
 
 	/* Now set kthread_should_stop() to true, and wake it up. */
 	kthread_stop_info.k = k;
+	if (!freezer_should_exempt(current)) {
+		/* We are freezable, so we must make sure that the thread being
+		 * stopped is not frozen and will not be frozen until it dies
+		 */
+		freezer_exempt(k);
+		if (frozen(k))
+			clear_frozen_flag(k);
+	}
 	wake_up_process(k);
 	put_task_struct(k);
 
