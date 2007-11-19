Return-Path: <linux-kernel-owner+w=401wt.eu-S1754869AbXKSAKv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869AbXKSAKv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2007 19:10:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752162AbXKSAKm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Nov 2007 19:10:42 -0500
Received: from ozlabs.org ([203.10.76.45]:38053 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752120AbXKSAKl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2007 19:10:41 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: lguest <lguest@ozlabs.org>
Subject: [PATCH] lguest: Fix uninitialized members in example launcher
Date: Mon, 19 Nov 2007 11:10:25 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711191110.25836.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks valgrind!

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff -r 1041aeb944b2 Documentation/lguest/lguest.c
--- a/Documentation/lguest/lguest.c	Tue Nov 13 15:11:06 2007 +1100
+++ b/Documentation/lguest/lguest.c	Thu Nov 15 13:28:48 2007 +1100
@@ -1040,6 +1040,11 @@ static void add_virtqueue(struct device 
 		/ getpagesize();
 	p = get_pages(pages);
 
+	/* Initialize the virtqueue */
+	vq->next = NULL;
+	vq->last_avail_idx = 0;
+	vq->dev = dev;
+
 	/* Initialize the configuration. */
 	vq->config.num = num_descs;
 	vq->config.irq = devices.next_irq++;
@@ -1056,9 +1061,6 @@ static void add_virtqueue(struct device 
 	 * second.  */
 	for (i = &dev->vq; *i; i = &(*i)->next);
 	*i = vq;
-
-	/* Link virtqueue back to device. */
-	vq->dev = dev;
 
 	/* Set the routine to call when the Guest does something to this
 	 * virtqueue. */
@@ -1093,6 +1095,7 @@ static struct device *new_device(const c
 	dev->desc = new_dev_desc(type);
 	dev->handle_input = handle_input;
 	dev->name = name;
+	dev->vq = NULL;
 	return dev;
 }
 
