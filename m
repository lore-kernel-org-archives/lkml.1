Return-Path: <linux-kernel-owner+w=401wt.eu-S1754337AbXKTBTq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754337AbXKTBTq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 20:19:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754433AbXKTBNy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 20:13:54 -0500
Received: from relay1.sgi.com ([192.48.171.29]:49833 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754076AbXKTBNf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 20:13:35 -0500
Message-Id: <20071120011335.504174556@sgi.com>
References: <20071120011132.143632442@sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 19 Nov 2007 17:11:48 -0800
From: clameter@sgi.com
From: Christoph Lameter <clameter@sgi.com>
To: ak@suse.de
Cc: akpm@linux-foundation.org
Cc: travis@sgi.com
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org
Subject: [rfc 16/45] cpu alloc: blktrace conversion
Content-Disposition: inline; filename=0024-cpu-alloc-blktrace-conversion.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Christoph Lameter <clameter@sgi.com>
---
 block/blktrace.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: linux-2.6/block/blktrace.c
===================================================================
--- linux-2.6.orig/block/blktrace.c	2007-11-15 21:17:24.586154116 -0800
+++ linux-2.6/block/blktrace.c	2007-11-15 21:25:31.591154091 -0800
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
