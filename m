Return-Path: <linux-kernel-owner+w=401wt.eu-S1752813AbXFNWKE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752813AbXFNWKE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 18:10:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752421AbXFNWJG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 18:09:06 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:36442 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752207AbXFNWJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 18:09:05 -0400
Message-Id: <20070614220446.724626895@chello.nl>
References: <20070614215817.389524447@chello.nl>
User-Agent: quilt/0.46-1
Date: Thu, 14 Jun 2007 23:58:23 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: miklos@szeredi.hu, akpm@linux-foundation.org, neilb@suse.de, dgc@sgi.com,
       tomoki.sekiyama.qu@hitachi.com, a.p.zijlstra@chello.nl,
       nikita@clusterfs.com, trond.myklebust@fys.uio.no,
       yingchao.zhou@gmail.com, andrea@suse.de
Subject: [PATCH 06/17] lib: percpu_counter_init_irq
Content-Disposition: inline; filename=percpu_counter_init_irq.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

provide a way to init percpu_counters that are supposed to be used from irq
safe contexts.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/percpu_counter.h |    4 ++++
 lib/percpu_counter.c           |    8 ++++++++
 2 files changed, 12 insertions(+)

Index: linux-2.6/include/linux/percpu_counter.h
===================================================================
--- linux-2.6.orig/include/linux/percpu_counter.h
+++ linux-2.6/include/linux/percpu_counter.h
@@ -31,6 +31,8 @@ struct percpu_counter {
 #endif
 
 void percpu_counter_init(struct percpu_counter *fbc, s64 amount);
+void percpu_counter_init_irq(struct percpu_counter *fbc, s64 amount);
+
 void percpu_counter_destroy(struct percpu_counter *fbc);
 void percpu_counter_set(struct percpu_counter *fbc, s64 amount);
 void __percpu_counter_mod(struct percpu_counter *fbc, s32 amount, s32 batch);
@@ -89,6 +91,8 @@ static inline void percpu_counter_init(s
 	fbc->count = amount;
 }
 
+#define percpu_counter_init_irq percpu_counter_init
+
 static inline void percpu_counter_destroy(struct percpu_counter *fbc)
 {
 }
Index: linux-2.6/lib/percpu_counter.c
===================================================================
--- linux-2.6.orig/lib/percpu_counter.c
+++ linux-2.6/lib/percpu_counter.c
@@ -87,6 +87,8 @@ s64 __percpu_counter_sum(struct percpu_c
 }
 EXPORT_SYMBOL(__percpu_counter_sum);
 
+static struct lock_class_key percpu_counter_irqsafe;
+
 void percpu_counter_init(struct percpu_counter *fbc, s64 amount)
 {
 	spin_lock_init(&fbc->lock);
@@ -100,6 +102,12 @@ void percpu_counter_init(struct percpu_c
 }
 EXPORT_SYMBOL(percpu_counter_init);
 
+void percpu_counter_init_irq(struct percpu_counter *fbc, s64 amount)
+{
+	percpu_counter_init(fbc, amount);
+	lockdep_set_class(&fbc->lock, &percpu_counter_irqsafe);
+}
+
 void percpu_counter_destroy(struct percpu_counter *fbc)
 {
 	free_percpu(fbc->counters);

-- 

