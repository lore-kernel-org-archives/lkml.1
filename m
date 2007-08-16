Return-Path: <linux-kernel-owner+w=401wt.eu-S932850AbXHPIaw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932850AbXHPIaw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 04:30:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764921AbXHPI2t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 04:28:49 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60326 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755131AbXHPI2q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 04:28:46 -0400
Message-Id: <20070816074626.987287000@chello.nl>
References: <20070816074525.065850000@chello.nl>
User-Agent: quilt/0.45-1
Date: Thu, 16 Aug 2007 09:45:35 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: miklos@szeredi.hu, akpm@linux-foundation.org, neilb@suse.de, dgc@sgi.com,
       tomoki.sekiyama.qu@hitachi.com, a.p.zijlstra@chello.nl,
       nikita@clusterfs.com, trond.myklebust@fys.uio.no,
       yingchao.zhou@gmail.com, richard@rsk.demon.co.uk,
       torvalds@linux-foundation.org
Subject: [PATCH 10/23] lib: percpu_counter_init_irq
Content-Disposition: inline; filename=percpu_counter_init_irq.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

provide a way to tell lockdep about percpu_counters that are supposed to be
used from irq safe contexts.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/percpu_counter.h |    3 +++
 lib/percpu_counter.c           |   12 ++++++++++++
 2 files changed, 15 insertions(+)

Index: linux-2.6/include/linux/percpu_counter.h
===================================================================
--- linux-2.6.orig/include/linux/percpu_counter.h
+++ linux-2.6/include/linux/percpu_counter.h
@@ -31,6 +31,7 @@ struct percpu_counter {
 #endif
 
 int percpu_counter_init(struct percpu_counter *fbc, s64 amount);
+int percpu_counter_init_irq(struct percpu_counter *fbc, s64 amount);
 void percpu_counter_destroy(struct percpu_counter *fbc);
 void percpu_counter_set(struct percpu_counter *fbc, s64 amount);
 void __percpu_counter_add(struct percpu_counter *fbc, s64 amount, s32 batch);
@@ -84,6 +85,8 @@ static inline int percpu_counter_init(st
 	return 0;
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
@@ -68,6 +68,8 @@ s64 __percpu_counter_sum(struct percpu_c
 }
 EXPORT_SYMBOL(__percpu_counter_sum);
 
+static struct lock_class_key percpu_counter_irqsafe;
+
 int percpu_counter_init(struct percpu_counter *fbc, s64 amount)
 {
 	spin_lock_init(&fbc->lock);
@@ -84,6 +86,16 @@ int percpu_counter_init(struct percpu_co
 }
 EXPORT_SYMBOL(percpu_counter_init);
 
+int percpu_counter_init_irq(struct percpu_counter *fbc, s64 amount)
+{
+	int err;
+
+	err = percpu_counter_init(fbc, amount);
+	if (!err)
+		lockdep_set_class(&fbc->lock, &percpu_counter_irqsafe);
+	return err;
+}
+
 void percpu_counter_destroy(struct percpu_counter *fbc)
 {
 	if (!fbc->counters)

--

