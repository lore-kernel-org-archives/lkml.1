Return-Path: <linux-kernel-owner+w=401wt.eu-S932242AbXBWLzZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932242AbXBWLzZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 06:55:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932256AbXBWLzT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 06:55:19 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:48519 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932242AbXBWLys (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 06:54:48 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [RFC][PATCH 5/7] Freezer: Remove PF_NOFREEZE from rcutorture thread
Date: Fri, 23 Feb 2007 11:23:43 +0100
User-Agent: KMail/1.9.5
Cc: paulmck@linux.vnet.ibm.com, ego@in.ibm.com, akpm@osdl.org, mingo@elte.hu,
       vatsa@in.ibm.com, dipankar@in.ibm.com, venkatesh.pallipadi@intel.com,
       Pavel Machek <pavel@ucw.cz>, "Aneesh Kumar" <aneesh.kumar@gmail.com>
References: <200702231116.23607.rjw@sisk.pl>
In-Reply-To: <200702231116.23607.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702231123.44687.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Remove PF_NOFREEZE from the rcutorture thread, adding a try_to_freeze() call as
required.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
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

