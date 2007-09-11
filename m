Return-Path: <linux-kernel-owner+w=401wt.eu-S965483AbXIKUGA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965483AbXIKUGA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 16:06:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934259AbXIKUCK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 16:02:10 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37640 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934257AbXIKUCI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 16:02:08 -0400
Message-Id: <20070911200012.686147000@chello.nl>
References: <20070911195350.825778000@chello.nl>
User-Agent: quilt/0.45-1
Date: Tue, 11 Sep 2007 21:53:55 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: miklos@szeredi.hu, akpm@linux-foundation.org, neilb@suse.de, dgc@sgi.com,
       tomoki.sekiyama.qu@hitachi.com, a.p.zijlstra@chello.nl,
       nikita@clusterfs.com, trond.myklebust@fys.uio.no,
       yingchao.zhou@gmail.com, richard@rsk.demon.co.uk,
       torvalds@linux-foundation.org
Subject: [PATCH 05/23] lib: make percpu_counter_add take s64
Content-Disposition: inline; filename=percpu_counter_add64.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

percpu_counter is a s64 counter, make _add consitent.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/percpu_counter.h |    6 +++---
 lib/percpu_counter.c           |    4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

Index: linux-2.6/include/linux/percpu_counter.h
===================================================================
--- linux-2.6.orig/include/linux/percpu_counter.h
+++ linux-2.6/include/linux/percpu_counter.h
@@ -32,10 +32,10 @@ struct percpu_counter {
 
 void percpu_counter_init(struct percpu_counter *fbc, s64 amount);
 void percpu_counter_destroy(struct percpu_counter *fbc);
-void __percpu_counter_add(struct percpu_counter *fbc, s32 amount, s32 batch);
+void __percpu_counter_add(struct percpu_counter *fbc, s64 amount, s32 batch);
 s64 percpu_counter_sum(struct percpu_counter *fbc);
 
-static inline void percpu_counter_add(struct percpu_counter *fbc, s32 amount)
+static inline void percpu_counter_add(struct percpu_counter *fbc, s64 amount)
 {
 	__percpu_counter_add(fbc, amount, FBC_BATCH);
 }
@@ -79,7 +79,7 @@ static inline void percpu_counter_destro
 	percpu_counter_add(fbc, amount)
 
 static inline void
-percpu_counter_add(struct percpu_counter *fbc, s32 amount)
+percpu_counter_add(struct percpu_counter *fbc, s64 amount)
 {
 	preempt_disable();
 	fbc->count += amount;
Index: linux-2.6/lib/percpu_counter.c
===================================================================
--- linux-2.6.orig/lib/percpu_counter.c
+++ linux-2.6/lib/percpu_counter.c
@@ -14,9 +14,9 @@ static LIST_HEAD(percpu_counters);
 static DEFINE_MUTEX(percpu_counters_lock);
 #endif
 
-void __percpu_counter_add(struct percpu_counter *fbc, s32 amount, s32 batch)
+void __percpu_counter_add(struct percpu_counter *fbc, s64 amount, s32 batch)
 {
-	long count;
+	s64 count;
 	s32 *pcount;
 	int cpu = get_cpu();
 

--

