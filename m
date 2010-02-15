Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754874Ab0BOQ0b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 11:26:31 -0500
Received: from lon1-post-1.mail.demon.net ([195.173.77.148]:33013 "EHLO
	lon1-post-1.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752765Ab0BOQ0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 11:26:30 -0500
Subject: Re: [PATCH v2]  cfq: reorder cfq_queue removing padding on 64bit &
 allowing more objects/slab in it's kmem_cache
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <jens.axboe@oracle.com>
Cc: Corrado Zoccolo <czoccolo@gmail.com>, Jeff Moyer <jmoyer@redhat.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20100215141626.GB5355@redhat.com>
References: <1266243036.2149.21.camel@localhost>
	 <20100215141626.GB5355@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 15 Feb 2010 16:26:28 +0000
Message-ID: <1266251188.7362.3.camel@localhost>
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


diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 023f4e6..e3dedfd 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -115,11 +115,11 @@ struct cfq_queue {
 	/* time when queue got scheduled in to dispatch first request. */
 	unsigned long dispatch_start;
 	unsigned int allocated_slice;
+	unsigned int slice_dispatch;
 	/* time when first request from queue completed and slice started. */
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


