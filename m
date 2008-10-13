Return-Path: <linux-kernel-owner+w=401wt.eu-S1760212AbYJMVxu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760212AbYJMVxu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 17:53:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758217AbYJMVxE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 17:53:04 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:64073 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759687AbYJMVxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 17:53:00 -0400
Message-Id: <20081013215132.339790493@de.ibm.com>
References: <20081013215007.634620563@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Mon, 13 Oct 2008 23:50:11 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: rusty@rustcorp.com.au
Cc: jens.axboe@oracle.com, mingo@elte.hu, akpm@linux-foundation.org,
       schwidefsky@de.ibm.com, linux-kernel@vger.kernel.org,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH/RFC v2 4/6] stop_machine: special case for one cpu
Content-Disposition: inline; filename=004_stopmachine_single.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

If only one cpu is online we might as well use the non-smp variant of
stop_machine which should be much faster since no scheduling is needed.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 include/linux/stop_machine.h |   16 +++++++++++-----
 kernel/stop_machine.c        |    3 +++
 2 files changed, 14 insertions(+), 5 deletions(-)

Index: linux-2.6/include/linux/stop_machine.h
===================================================================
--- linux-2.6.orig/include/linux/stop_machine.h
+++ linux-2.6/include/linux/stop_machine.h
@@ -8,6 +8,16 @@
 #include <linux/cpumask.h>
 #include <asm/system.h>
 
+static inline int stop_machine_simple(int (*fn)(void *), void *data,
+				      const cpumask_t *cpus)
+{
+	int ret;
+	local_irq_disable();
+	ret = fn(data);
+	local_irq_enable();
+	return ret;
+}
+
 #if defined(CONFIG_STOP_MACHINE) && defined(CONFIG_SMP)
 
 /**
@@ -40,11 +50,7 @@ int __stop_machine(int (*fn)(void *), vo
 static inline int stop_machine(int (*fn)(void *), void *data,
 			       const cpumask_t *cpus)
 {
-	int ret;
-	local_irq_disable();
-	ret = fn(data);
-	local_irq_enable();
-	return ret;
+	return stop_machine_simple(fn, data, cpus);
 }
 #endif /* CONFIG_SMP */
 #endif /* _LINUX_STOP_MACHINE */
Index: linux-2.6/kernel/stop_machine.c
===================================================================
--- linux-2.6.orig/kernel/stop_machine.c
+++ linux-2.6/kernel/stop_machine.c
@@ -111,6 +111,9 @@ int __stop_machine(int (*fn)(void *), vo
 	struct work_struct *sm_work;
 	int i;
 
+	if (num_online_cpus() == 1)
+		return stop_machine_simple(fn, data, cpus);
+
 	/* Set up initial state. */
 	mutex_lock(&lock);
 	num_threads = num_online_cpus();

-- 
