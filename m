Return-Path: <linux-kernel-owner+w=401wt.eu-S1767158AbXDTQBw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767158AbXDTQBw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 12:01:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767153AbXDTQBR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 12:01:17 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42887 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767149AbXDTQAs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 12:00:48 -0400
Message-Id: <20070420155502.679143273@chello.nl>
References: <20070420155154.898600123@chello.nl>
User-Agent: quilt/0.46-1
Date: Fri, 20 Apr 2007 17:51:57 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: miklos@szeredi.hu, akpm@linux-foundation.org, neilb@suse.de, dgc@sgi.com,
       tomoki.sekiyama.qu@hitachi.com, a.p.zijlstra@chello.nl,
       nikita@clusterfs.com, trond.myklebust@fys.uio.no,
       yingchao.zhou@gmail.com
Subject: [PATCH 03/10] lib: dampen the percpu_counter FBC_BATCH
Content-Disposition: inline; filename=percpu_counter_batch.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

With the current logic the percpu_counter's accuracy delta is quadric
wrt the number of cpus in the system, reduce this to O(n ln n).

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/percpu_counter.h |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

Index: linux-2.6-mm/include/linux/percpu_counter.h
===================================================================
--- linux-2.6-mm.orig/include/linux/percpu_counter.h
+++ linux-2.6-mm/include/linux/percpu_counter.h
@@ -11,6 +11,7 @@
 #include <linux/threads.h>
 #include <linux/percpu.h>
 #include <linux/types.h>
+#include <linux/log2.h>
 
 #ifdef CONFIG_SMP
 
@@ -20,11 +21,7 @@ struct percpu_counter {
 	s32 *counters;
 };
 
-#if NR_CPUS >= 16
-#define FBC_BATCH	(NR_CPUS*2)
-#else
-#define FBC_BATCH	(NR_CPUS*4)
-#endif
+#define FBC_BATCH	(8*ilog2(NR_CPUS))
 
 static inline void percpu_counter_init(struct percpu_counter *fbc, s64 amount)
 {

-- 

