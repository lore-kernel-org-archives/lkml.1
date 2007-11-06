Return-Path: <linux-kernel-owner+w=401wt.eu-S1758008AbXKFUBi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758008AbXKFUBi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 15:01:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757535AbXKFTwi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 14:52:38 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:45386 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755799AbXKFTwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 14:52:01 -0500
Message-Id: <20071106195200.625597439@sgi.com>
References: <20071106195144.983665861@sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 06 Nov 2007 11:51:57 -0800
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-mm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>
Cc: Eric Dumazet <dada1@cosmosbay.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 13/28] cpu alloc: blktrace conversion
Content-Disposition: inline; filename=cpu_alloc_blktrace
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 block/blktrace.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

Index: linux-2.6/block/blktrace.c
===================================================================
--- linux-2.6.orig/block/blktrace.c	2007-11-04 13:14:44.000000000 -0800
+++ linux-2.6/block/blktrace.c	2007-11-04 13:16:22.000000000 -0800
@@ -18,12 +18,12 @@
 #include <linux/kernel.h>
 #include <linux/blkdev.h>
 #include <linux/blktrace_api.h>
-#include <linux/percpu.h>
 #include <linux/init.h>
 #include <linux/mutex.h>
 #include <linux/debugfs.h>
 #include <linux/time.h>
 #include <asm/uaccess.h>
+#include <linux/cpu_alloc.h>
 
 static DEFINE_PER_CPU(unsigned long long, blk_trace_cpu_offset) = { 0, };
 static unsigned int blktrace_seq __read_mostly = 1;
@@ -155,7 +155,7 @@ void __blk_add_trace(struct blk_trace *b
 	t = relay_reserve(bt->rchan, sizeof(*t) + pdu_len);
 	if (t) {
 		cpu = smp_processor_id();
-		sequence = per_cpu_ptr(bt->sequence, cpu);
+		sequence = CPU_PTR(bt->sequence, cpu);
 
 		t->magic = BLK_IO_TRACE_MAGIC | BLK_IO_TRACE_VERSION;
 		t->sequence = ++(*sequence);
@@ -227,7 +227,7 @@ static void blk_trace_cleanup(struct blk
 	relay_close(bt->rchan);
 	debugfs_remove(bt->dropped_file);
 	blk_remove_tree(bt->dir);
-	free_percpu(bt->sequence);
+	CPU_FREE(bt->sequence);
 	kfree(bt);
 }
 
@@ -338,7 +338,7 @@ int do_blk_trace_setup(struct request_qu
 	if (!bt)
 		goto err;
 
-	bt->sequence = alloc_percpu(unsigned long);
+	bt->sequence = CPU_ALLOC(unsigned long, GFP_KERNEL | __GFP_ZERO);
 	if (!bt->sequence)
 		goto err;
 
@@ -387,7 +387,7 @@ err:
 	if (bt) {
 		if (bt->dropped_file)
 			debugfs_remove(bt->dropped_file);
-		free_percpu(bt->sequence);
+		CPU_FREE(bt->sequence);
 		if (bt->rchan)
 			relay_close(bt->rchan);
 		kfree(bt);

-- 
