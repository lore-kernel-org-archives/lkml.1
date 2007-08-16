Return-Path: <linux-kernel-owner+w=401wt.eu-S936064AbXHPIo1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936064AbXHPIo1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 04:44:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762393AbXHPIeG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 04:34:06 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33818 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934161AbXHPIeB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 04:34:01 -0400
Message-Id: <20070816074626.473901000@chello.nl>
References: <20070816074525.065850000@chello.nl>
User-Agent: quilt/0.45-1
Date: Thu, 16 Aug 2007 09:45:33 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: miklos@szeredi.hu, akpm@linux-foundation.org, neilb@suse.de, dgc@sgi.com,
       tomoki.sekiyama.qu@hitachi.com, a.p.zijlstra@chello.nl,
       nikita@clusterfs.com, trond.myklebust@fys.uio.no,
       yingchao.zhou@gmail.com, richard@rsk.demon.co.uk,
       torvalds@linux-foundation.org
Subject: [PATCH 08/23] lib: percpu_count_sum()
Content-Disposition: inline; filename=percpu_counter_sum.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Provide an accurate version of percpu_counter_read.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/percpu_counter.h |   18 +++++++++++++++++-
 lib/percpu_counter.c           |    6 +++---
 2 files changed, 20 insertions(+), 4 deletions(-)

Index: linux-2.6/include/linux/percpu_counter.h
===================================================================
--- linux-2.6.orig/include/linux/percpu_counter.h
+++ linux-2.6/include/linux/percpu_counter.h
@@ -34,13 +34,24 @@ void percpu_counter_init(struct percpu_c
 void percpu_counter_destroy(struct percpu_counter *fbc);
 void percpu_counter_set(struct percpu_counter *fbc, s64 amount);
 void __percpu_counter_add(struct percpu_counter *fbc, s64 amount, s32 batch);
-s64 percpu_counter_sum_positive(struct percpu_counter *fbc);
+s64 __percpu_counter_sum(struct percpu_counter *fbc);
 
 static inline void percpu_counter_add(struct percpu_counter *fbc, s64 amount)
 {
 	__percpu_counter_add(fbc, amount, FBC_BATCH);
 }
 
+static inline s64 percpu_counter_sum_positive(struct percpu_counter *fbc)
+{
+	s64 ret = __percpu_counter_sum(fbc);
+	return ret < 0 ? 0 : ret;
+}
+
+static inline s64 percpu_counter_sum(struct percpu_counter *fbc)
+{
+	return __percpu_counter_sum(fbc);
+}
+
 static inline s64 percpu_counter_read(struct percpu_counter *fbc)
 {
 	return fbc->count;
@@ -107,6 +118,11 @@ static inline s64 percpu_counter_sum_pos
 	return percpu_counter_read_positive(fbc);
 }
 
+static inline s64 percpu_counter_sum(struct percpu_counter *fbc)
+{
+	return percpu_counter_read(fbc);
+}
+
 #endif	/* CONFIG_SMP */
 
 static inline void percpu_counter_inc(struct percpu_counter *fbc)
Index: linux-2.6/lib/percpu_counter.c
===================================================================
--- linux-2.6.orig/lib/percpu_counter.c
+++ linux-2.6/lib/percpu_counter.c
@@ -52,7 +52,7 @@ EXPORT_SYMBOL(__percpu_counter_add);
  * Add up all the per-cpu counts, return the result.  This is a more accurate
  * but much slower version of percpu_counter_read_positive()
  */
-s64 percpu_counter_sum_positive(struct percpu_counter *fbc)
+s64 __percpu_counter_sum(struct percpu_counter *fbc)
 {
 	s64 ret;
 	int cpu;
@@ -64,9 +64,9 @@ s64 percpu_counter_sum_positive(struct p
 		ret += *pcount;
 	}
 	spin_unlock(&fbc->lock);
-	return ret < 0 ? 0 : ret;
+	return ret;
 }
-EXPORT_SYMBOL(percpu_counter_sum_positive);
+EXPORT_SYMBOL(__percpu_counter_sum);
 
 void percpu_counter_init(struct percpu_counter *fbc, s64 amount)
 {

--

