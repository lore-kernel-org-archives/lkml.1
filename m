Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755229Ab0BOOKj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 09:10:39 -0500
Received: from anchor-post-1.mail.demon.net ([195.173.77.132]:61412 "EHLO
	anchor-post-1.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752158Ab0BOOKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 09:10:38 -0500
Subject: [PATCH] cfq: reorder cfq_queue removing padding on 64bit &
 allowing more objects/slab in it's kmem_cache
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: Jens Axboe <jens.axboe@oracle.com>, Vivek Goyal <vgoyal@redhat.com>,
       Corrado Zoccolo <czoccolo@gmail.com>, Jeff Moyer <jmoyer@redhat.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 15 Feb 2010 14:10:36 +0000
Message-ID: <1266243036.2149.21.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This removes 8 bytes of padding from struct cfq_queue on 64 bit builds,
shrinking it's size to 256 bytes, so fitting into 1 fewer cachelines and
allowing 1 more object/slab in it's kmem_cache.
 

Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
----
patch against 2.6.33-rc8
tested on x86_64 AMDX2

regards
Richard


diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 023f4e6..db4c127 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -116,10 +116,10 @@ struct cfq_queue {
 	unsigned long dispatch_start;
 	unsigned int allocated_slice;
 	/* time when first request from queue completed and slice started. */
+	unsigned int slice_dispatch;
 	unsigned long slice_start;
 	unsigned long slice_end;
 	long slice_resid;
-	unsigned int slice_dispatch;
 
 	/* pending metadata requests */
 	int meta_pending;
@@ -130,13 +130,13 @@ struct cfq_queue {
 	unsigned short ioprio, org_ioprio;
 	unsigned short ioprio_class, org_ioprio_class;
 
+	pid_t pid;
+
 	unsigned int seek_samples;
 	u64 seek_total;
 	sector_t seek_mean;
 	sector_t last_request_pos;
 
-	pid_t pid;
-
 	struct cfq_rb_root *service_tree;
 	struct cfq_queue *new_cfqq;
 	struct cfq_group *cfqg;


