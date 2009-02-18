Return-Path: <linux-kernel-owner+w=401wt.eu-S1754751AbZBRMIf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754751AbZBRMIf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 07:08:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753671AbZBRMFu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 07:05:50 -0500
Received: from hera.kernel.org ([140.211.167.34]:50753 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753593AbZBRMFl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 07:05:41 -0500
From: Tejun Heo <tj@kernel.org>
To: rusty@rustcorp.com.au, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, jeremy@goop.org,
       cpw@sgi.com, mingo@elte.hu
Cc: Christoph Lameter <cl@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 05/10] alloc_percpu: add align argument to __alloc_percpu.
Date: Wed, 18 Feb 2009 21:04:31 +0900
Message-Id: <1234958676-27618-6-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1234958676-27618-1-git-send-email-tj@kernel.org>
References: <1234958676-27618-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 18 Feb 2009 12:05:03 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rusty Russell <rusty@rustcorp.com.au>

This prepares for a real __alloc_percpu, by adding an alignment argument.
Only one place uses __alloc_percpu directly, and that's for a string.

tj: af_inet also uses __alloc_percpu(), update it.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Jens Axboe <axboe@kernel.dk>
---
 block/blktrace.c       |    2 +-
 include/linux/percpu.h |    5 +++--
 net/ipv4/af_inet.c     |    4 ++--
 3 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/block/blktrace.c b/block/blktrace.c
index 39cc3bf..4877662 100644
--- a/block/blktrace.c
+++ b/block/blktrace.c
@@ -363,7 +363,7 @@ int do_blk_trace_setup(struct request_queue *q, char *name, dev_t dev,
 	if (!bt->sequence)
 		goto err;
 
-	bt->msg_data = __alloc_percpu(BLK_TN_MAX_MSG);
+	bt->msg_data = __alloc_percpu(BLK_TN_MAX_MSG, __alignof__(char));
 	if (!bt->msg_data)
 		goto err;
 
diff --git a/include/linux/percpu.h b/include/linux/percpu.h
index c80cfe1..1fdaee9 100644
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -108,9 +108,10 @@ static inline void percpu_free(void *__pdata)
 
 /* (legacy) interface for use without CPU hotplug handling */
 
-#define __alloc_percpu(size)	percpu_alloc_mask((size), GFP_KERNEL, \
+#define __alloc_percpu(size, align)	percpu_alloc_mask((size), GFP_KERNEL, \
 						  cpu_possible_map)
-#define alloc_percpu(type)	(type *)__alloc_percpu(sizeof(type))
+#define alloc_percpu(type)	(type *)__alloc_percpu(sizeof(type), \
+						       __alignof__(type))
 #define free_percpu(ptr)	percpu_free((ptr))
 /*
  * Use this to get to a cpu's version of the per-cpu object dynamically
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index 743f554..3a3dad8 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -1375,10 +1375,10 @@ EXPORT_SYMBOL_GPL(snmp_fold_field);
 int snmp_mib_init(void *ptr[2], size_t mibsize)
 {
 	BUG_ON(ptr == NULL);
-	ptr[0] = __alloc_percpu(mibsize);
+	ptr[0] = __alloc_percpu(mibsize, __alignof__(unsigned long long));
 	if (!ptr[0])
 		goto err0;
-	ptr[1] = __alloc_percpu(mibsize);
+	ptr[1] = __alloc_percpu(mibsize, __alignof__(unsigned long long));
 	if (!ptr[1])
 		goto err1;
 	return 0;
-- 
1.6.0.2

