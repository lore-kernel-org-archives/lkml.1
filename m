Return-Path: <linux-kernel-owner+w=401wt.eu-S933784AbXBZHVN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933784AbXBZHVN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 02:21:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933786AbXBZHVN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 02:21:13 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:57879 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933784AbXBZHVM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 02:21:12 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@osdl.org>
Subject: [PATCH -mm 4/6] Freezer: Remove PF_NOFREEZE from rcutorture thread
Date: Mon, 26 Feb 2007 08:08:51 +0100
User-Agent: KMail/1.9.5
Cc: Pavel Machek <pavel@ucw.cz>, LKML <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@tv-sign.ru>, Aneesh Kumar <aneesh.kumar@gmail.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>
References: <200702260800.49603.rjw@sisk.pl>
In-Reply-To: <200702260800.49603.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702260808.52465.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Remove PF_NOFREEZE from the rcutorture thread, adding a try_to_freeze() call as
required.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
---
 kernel/rcutorture.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-2.6.20-mm2/kernel/rcutorture.c
===================================================================
--- linux-2.6.20-mm2.orig/kernel/rcutorture.c	2007-02-22 23:51:54.000000000 +0100
+++ linux-2.6.20-mm2/kernel/rcutorture.c	2007-02-22 23:55:12.000000000 +0100
@@ -46,6 +46,7 @@
 #include <linux/byteorder/swabb.h>
 #include <linux/stat.h>
 #include <linux/srcu.h>
+#include <linux/freezer.h>
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Paul E. McKenney <paulmck@us.ibm.com> and "
@@ -585,7 +586,6 @@ rcu_torture_writer(void *arg)
 
 	VERBOSE_PRINTK_STRING("rcu_torture_writer task started");
 	set_user_nice(current, 19);
-	current->flags |= PF_NOFREEZE;
 
 	do {
 		schedule_timeout_uninterruptible(1);
@@ -607,6 +607,7 @@ rcu_torture_writer(void *arg)
 		}
 		rcu_torture_current_version++;
 		oldbatch = cur_ops->completed();
+		try_to_freeze();
 	} while (!kthread_should_stop() && !fullstop);
 	VERBOSE_PRINTK_STRING("rcu_torture_writer task stopping");
 	while (!kthread_should_stop())

