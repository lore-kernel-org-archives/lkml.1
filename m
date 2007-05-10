Return-Path: <linux-kernel-owner+w=401wt.eu-S1761146AbXEJKQO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761146AbXEJKQO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 06:16:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758409AbXEJKOH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 06:14:07 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56109 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760850AbXEJKOD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 06:14:03 -0400
Message-Id: <20070510101128.804168529@chello.nl>
References: <20070510100839.621199408@chello.nl>
User-Agent: quilt/0.46-1
Date: Thu, 10 May 2007 12:08:41 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: miklos@szeredi.hu, akpm@linux-foundation.org, neilb@suse.de, dgc@sgi.com,
       tomoki.sekiyama.qu@hitachi.com, a.p.zijlstra@chello.nl,
       nikita@clusterfs.com, trond.myklebust@fys.uio.no,
       yingchao.zhou@gmail.com
Subject: [PATCH 02/15] lib: percpu_counter variable batch
Content-Disposition: inline; filename=percpu_counter_batch.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Because the current batch setup has an quadric error bound on the counter,
allow for an alternative setup.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/percpu_counter.h |   10 +++++++++-
 lib/percpu_counter.c           |    6 +++---
 2 files changed, 12 insertions(+), 4 deletions(-)

Index: linux-2.6/include/linux/percpu_counter.h
===================================================================
--- linux-2.6.orig/include/linux/percpu_counter.h	2007-04-29 18:14:37.000000000 +0200
+++ linux-2.6/include/linux/percpu_counter.h	2007-04-29 18:15:26.000000000 +0200
@@ -38,9 +38,14 @@ static inline void percpu_counter_destro
 	free_percpu(fbc->counters);
 }
 
-void percpu_counter_mod(struct percpu_counter *fbc, s32 amount);
+void __percpu_counter_mod(struct percpu_counter *fbc, s32 amount, s32 batch);
 s64 percpu_counter_sum(struct percpu_counter *fbc);
 
+static inline void percpu_counter_mod(struct percpu_counter *fbc, s32 amount)
+{
+	__percpu_counter_mod(fbc, amount, FBC_BATCH);
+}
+
 static inline s64 percpu_counter_read(struct percpu_counter *fbc)
 {
 	return fbc->count;
@@ -76,6 +81,9 @@ static inline void percpu_counter_destro
 {
 }
 
+#define __percpu_counter_mod(fbc, amount, batch) \
+	percpu_counter_mod(fbc, amount)
+
 static inline void
 percpu_counter_mod(struct percpu_counter *fbc, s32 amount)
 {
Index: linux-2.6/lib/percpu_counter.c
===================================================================
--- linux-2.6.orig/lib/percpu_counter.c	2007-04-29 18:14:37.000000000 +0200
+++ linux-2.6/lib/percpu_counter.c	2007-04-29 18:14:40.000000000 +0200
@@ -5,7 +5,7 @@
 #include <linux/percpu_counter.h>
 #include <linux/module.h>
 
-void percpu_counter_mod(struct percpu_counter *fbc, s32 amount)
+void __percpu_counter_mod(struct percpu_counter *fbc, s32 amount, s32 batch)
 {
 	long count;
 	s32 *pcount;
@@ -13,7 +13,7 @@ void percpu_counter_mod(struct percpu_co
 
 	pcount = per_cpu_ptr(fbc->counters, cpu);
 	count = *pcount + amount;
-	if (count >= FBC_BATCH || count <= -FBC_BATCH) {
+	if (count >= batch || count <= -batch) {
 		spin_lock(&fbc->lock);
 		fbc->count += count;
 		*pcount = 0;
@@ -23,7 +23,7 @@ void percpu_counter_mod(struct percpu_co
 	}
 	put_cpu();
 }
-EXPORT_SYMBOL(percpu_counter_mod);
+EXPORT_SYMBOL(__percpu_counter_mod);
 
 /*
  * Add up all the per-cpu counts, return the result.  This is a more accurate

-- 

