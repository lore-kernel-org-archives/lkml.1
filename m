Return-Path: <linux-kernel-owner+w=401wt.eu-S1755753AbYHVAah@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755753AbYHVAah (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 20:30:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753661AbYHVA3z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 20:29:55 -0400
Received: from gw.goop.org ([64.81.55.164]:44933 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753137AbYHVA3y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 20:29:54 -0400
Message-ID: <48AE087C.4000408@goop.org>
Date: Thu, 21 Aug 2008 17:29:48 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Nick Piggin <nickpiggin@yahoo.com.au>, Andi Kleen <andi@firstfloor.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 1/2] smp_call_function: don't use lock in call_function_data
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no need for a lock in call_function_data, since it's only used
to decrement-and-test a counter.  Use an atomic instead.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 kernel/smp.c |   17 ++++-------------
 1 file changed, 4 insertions(+), 13 deletions(-)

===================================================================
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -10,6 +10,7 @@
 #include <linux/rcupdate.h>
 #include <linux/rculist.h>
 #include <linux/smp.h>
+#include <asm/atomic.h>
 
 bool __read_mostly smp_single_ipi_queue = false;
 
@@ -37,8 +38,7 @@
 
 struct call_function_data {
 	struct call_single_data csd;
-	spinlock_t lock;
-	unsigned int refs;
+	atomic_t refs;
 	cpumask_t cpumask;
 	struct rcu_head rcu_head;
 };
@@ -125,21 +125,13 @@
 	 */
 	rcu_read_lock();
 	list_for_each_entry_rcu(data, &queue->list, csd.list) {
-		int refs;
-
 		if (!cpu_isset(cpu, data->cpumask))
 			continue;
 
 		data->csd.func(data->csd.info);
 
-		spin_lock(&data->lock);
 		cpu_clear(cpu, data->cpumask);
-		WARN_ON(data->refs == 0);
-		data->refs--;
-		refs = data->refs;
-		spin_unlock(&data->lock);
-
-		if (refs)
+		if (!atomic_dec_and_test(&data->refs))
 			continue;
 
 		spin_lock(&queue->lock);
@@ -379,10 +371,9 @@
 		slowpath = 1;
 	}
 
-	spin_lock_init(&data->lock);
 	data->csd.func = func;
 	data->csd.info = info;
-	data->refs = num_cpus;
+	atomic_set(&data->refs, num_cpus);
 	data->cpumask = mask;
 
 	spin_lock_irqsave(&queue->lock, flags);


