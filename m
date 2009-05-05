Return-Path: <linux-kernel-owner+w=401wt.eu-S1752975AbZEEQSU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752975AbZEEQSU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 12:18:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753702AbZEEQSH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 12:18:07 -0400
Received: from casper.infradead.org ([85.118.1.10]:39832 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752855AbZEEQSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 12:18:06 -0400
Message-Id: <20090505155437.232686598@chello.nl>
References: <20090505155020.309162852@chello.nl>
User-Agent: quilt/0.46-1
Date: Tue, 05 May 2009 17:50:25 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 5/7] perf_counter: fix the output lock
Content-Disposition: inline; filename=perf_counter-fix-output-lock.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use -1 instead of 0 as unlocked, since 0 is a valid cpu number.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/perf_counter.c |   39 ++++++++++++++++++++++++++++++++++-----
 1 file changed, 34 insertions(+), 5 deletions(-)

Index: linux-2.6/kernel/perf_counter.c
===================================================================
--- linux-2.6.orig/kernel/perf_counter.c
+++ linux-2.6/kernel/perf_counter.c
@@ -1409,6 +1417,7 @@ static int perf_mmap_data_alloc(struct p
 	}
 
 	data->nr_pages = nr_pages;
+	atomic_set(&data->lock, -1);
 
 	rcu_assign_pointer(counter->data, data);
 
@@ -1755,7 +1764,7 @@ static void perf_output_lock(struct perf
 	if (in_nmi() && atomic_read(&data->lock) == cpu)
 		return;
 
-	while (atomic_cmpxchg(&data->lock, 0, cpu) != 0)
+	while (atomic_cmpxchg(&data->lock, -1, cpu) != -1)
 		cpu_relax();
 
 	handle->locked = 1;
@@ -1784,7 +1793,7 @@ again:
 	 * NMI can happen here, which means we can miss a done_head update.
 	 */
 
-	cpu = atomic_xchg(&data->lock, 0);
+	cpu = atomic_xchg(&data->lock, -1);
 	WARN_ON_ONCE(cpu != smp_processor_id());
 
 	/*
@@ -1794,7 +1803,7 @@ again:
 		/*
 		 * Since we had it locked, we can lock it again.
 		 */
-		while (atomic_cmpxchg(&data->lock, 0, cpu) != 0)
+		while (atomic_cmpxchg(&data->lock, -1, cpu) != -1)
 			cpu_relax();
 
 		goto again;

-- 

