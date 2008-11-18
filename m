Return-Path: <linux-kernel-owner+w=401wt.eu-S1752762AbYKQNZm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762AbYKQNZm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 08:25:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751767AbYKQNZM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 08:25:12 -0500
Received: from ozlabs.org ([203.10.76.45]:39400 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751582AbYKQNZK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 08:25:10 -0500
To: linux-kernel@vger.kernel.org
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Mon Nov 17 23:47:44 CST 2008
CC: akpm@linux-foundation.org
Subject: [PATCH 2/3] Clean up alloc_percpu: add align argument to __alloc_percpu.
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: netdev@vger.kernel.org
Message-Id: <20081117132509.757C5DDDE6@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This prepares for a real __alloc_percpu, by adding an alignment argument.
Currently there are two files which use this, so fix them up too.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au> 
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: netdev@vger.kernel.org
---
 block/blktrace.c       |    2 +-
 include/linux/percpu.h |    5 +++--
 net/ipv4/af_inet.c     |    4 ++--
 3 files changed, 6 insertions(+), 5 deletions(-)

diff -r d7e495785ad1 block/blktrace.c
--- a/block/blktrace.c	Mon Nov 17 20:23:37 2008 +1030
+++ b/block/blktrace.c	Mon Nov 17 20:56:22 2008 +1030
@@ -389,7 +389,7 @@
 	if (!bt->sequence)
 		goto err;
 
-	bt->msg_data = __alloc_percpu(BLK_TN_MAX_MSG);
+	bt->msg_data = __alloc_percpu(BLK_TN_MAX_MSG, __alignof__(char));
 	if (!bt->msg_data)
 		goto err;
 
diff -r d7e495785ad1 include/linux/percpu.h
--- a/include/linux/percpu.h	Mon Nov 17 20:23:37 2008 +1030
+++ b/include/linux/percpu.h	Mon Nov 17 20:56:22 2008 +1030
@@ -112,9 +112,10 @@
 
 /* (legacy) interface for use without CPU hotplug handling */
 
-#define __alloc_percpu(size)	percpu_alloc_mask((size), GFP_KERNEL, \
+#define __alloc_percpu(size, align)	percpu_alloc_mask((size), GFP_KERNEL, \
 						  cpu_possible_map)
-#define alloc_percpu(type)	(type *)__alloc_percpu(sizeof(type))
+#define alloc_percpu(type)	(type *)__alloc_percpu(sizeof(type), \
+						       __alignof__(type))
 #define free_percpu(ptr)	percpu_free((ptr))
 #define per_cpu_ptr(ptr, cpu)	percpu_ptr((ptr), (cpu))
 
diff -r d7e495785ad1 net/ipv4/af_inet.c
--- a/net/ipv4/af_inet.c	Mon Nov 17 20:23:37 2008 +1030
+++ b/net/ipv4/af_inet.c	Mon Nov 17 20:56:22 2008 +1030
@@ -1283,10 +1283,10 @@
 int snmp_mib_init(void *ptr[2], size_t mibsize)
 {
 	BUG_ON(ptr == NULL);
-	ptr[0] = __alloc_percpu(mibsize);
+	ptr[0] = __alloc_percpu(mibsize, __alignof__(unsigned long));
 	if (!ptr[0])
 		goto err0;
-	ptr[1] = __alloc_percpu(mibsize);
+	ptr[1] = __alloc_percpu(mibsize, __alignof__(unsigned long));
 	if (!ptr[1])
 		goto err1;
 	return 0;

