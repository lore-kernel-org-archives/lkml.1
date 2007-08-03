Return-Path: <linux-kernel-owner+w=401wt.eu-S932227AbXHCNBz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932227AbXHCNBz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 09:01:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762281AbXHCM51
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 08:57:27 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51269 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762254AbXHCM5Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 08:57:24 -0400
Message-Id: <20070803125234.881136000@chello.nl>
References: <20070803123712.987126000@chello.nl>
User-Agent: quilt/0.45-1
Date: Fri, 03 Aug 2007 14:37:18 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: miklos@szeredi.hu, akpm@linux-foundation.org, neilb@suse.de, dgc@sgi.com,
       tomoki.sekiyama.qu@hitachi.com, a.p.zijlstra@chello.nl,
       nikita@clusterfs.com, trond.myklebust@fys.uio.no,
       yingchao.zhou@gmail.com, richard@rsk.demon.co.uk,
       torvalds@linux-foundation.org
Subject: [PATCH 05/23] lib: percpu_counter_set
Content-Disposition: inline; filename=percpu_counter_set.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Provide a method to set a percpu counter to a specified value.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/percpu_counter.h |    6 ++++++
 lib/percpu_counter.c           |   14 ++++++++++++++
 2 files changed, 20 insertions(+)

Index: linux-2.6/include/linux/percpu_counter.h
===================================================================
--- linux-2.6.orig/include/linux/percpu_counter.h
+++ linux-2.6/include/linux/percpu_counter.h
@@ -32,6 +32,7 @@ struct percpu_counter {
 
 void percpu_counter_init(struct percpu_counter *fbc, s64 amount);
 void percpu_counter_destroy(struct percpu_counter *fbc);
+void percpu_counter_set(struct percpu_counter *fbc, s64 amount);
 void __percpu_counter_add(struct percpu_counter *fbc, s64 amount, s32 batch);
 s64 percpu_counter_sum(struct percpu_counter *fbc);
 
@@ -75,6 +76,11 @@ static inline void percpu_counter_destro
 {
 }
 
+static inline void percpu_counter_set(struct percpu_counter *fbc, s64 amount)
+{
+	fbc->count = amount;
+}
+
 #define __percpu_counter_add(fbc, amount, batch) \
 	percpu_counter_add(fbc, amount)
 
Index: linux-2.6/lib/percpu_counter.c
===================================================================
--- linux-2.6.orig/lib/percpu_counter.c
+++ linux-2.6/lib/percpu_counter.c
@@ -14,6 +14,20 @@ static LIST_HEAD(percpu_counters);
 static DEFINE_MUTEX(percpu_counters_lock);
 #endif
 
+void percpu_counter_set(struct percpu_counter *fbc, s64 amount)
+{
+	int cpu;
+
+	spin_lock(&fbc->lock);
+	for_each_possible_cpu(cpu) {
+		s32 *pcount = per_cpu_ptr(fbc->counters, cpu);
+		*pcount = 0;
+	}
+	fbc->count = amount;
+	spin_unlock(&fbc->lock);
+}
+EXPORT_SYMBOL(percpu_counter_set);
+
 void __percpu_counter_add(struct percpu_counter *fbc, s64 amount, s32 batch)
 {
 	s64 count;

--

