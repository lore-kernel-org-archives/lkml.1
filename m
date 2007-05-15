Return-Path: <linux-kernel-owner+w=401wt.eu-S1761193AbXEOB2d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761193AbXEOB2d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 21:28:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757902AbXEOB20
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 21:28:26 -0400
Received: from ozlabs.org ([203.10.76.45]:47056 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757726AbXEOB2Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 21:28:25 -0400
Subject: [PATCH 5/6] lguest: console driver tidyups
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>
In-Reply-To: <1179192035.10836.32.camel@localhost.localdomain>
References: <1179191827.10836.24.camel@localhost.localdomain>
	 <1179191888.10836.26.camel@localhost.localdomain>
	 <1179191979.10836.29.camel@localhost.localdomain>
	 <1179192035.10836.32.camel@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 15 May 2007 11:21:38 +1000
Message-Id: <1179192098.10836.35.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

1) Use new lguest_send_dma & lguest_bind_dma functions.
2) sparse: lguest_cons can be static.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 drivers/char/hvc_lguest.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

===================================================================
--- a/drivers/char/hvc_lguest.c
+++ b/drivers/char/hvc_lguest.c
@@ -36,7 +36,7 @@ static int put_chars(u32 vtermno, const 
 	dma.len[1] = 0;
 	dma.addr[0] = __pa(buf);
 
-	hcall(LHCALL_SEND_DMA, LGUEST_CONSOLE_DMA_KEY, __pa(&dma), 0);
+	lguest_send_dma(LGUEST_CONSOLE_DMA_KEY, &dma);
 	return count;
 }
 
@@ -59,7 +59,7 @@ static int get_chars(u32 vtermno, char *
 	return count;
 }
 
-struct hv_ops lguest_cons = {
+static struct hv_ops lguest_cons = {
 	.get_chars = get_chars,
 	.put_chars = put_chars,
 };
@@ -75,14 +75,17 @@ console_initcall(cons_init);
 
 static int lguestcons_probe(struct lguest_device *lgdev)
 {
-	lgdev->private = hvc_alloc(0, lgdev->index+1, &lguest_cons, 256);
+	int err;
+
+	lgdev->private = hvc_alloc(0, lgdev_irq(lgdev), &lguest_cons, 256);
 	if (IS_ERR(lgdev->private))
 		return PTR_ERR(lgdev->private);
 
-	if (!hcall(LHCALL_BIND_DMA, LGUEST_CONSOLE_DMA_KEY, __pa(&cons_input),
-		   (1<<8) + lgdev->index+1))
+	err = lguest_bind_dma(LGUEST_CONSOLE_DMA_KEY, &cons_input, 1,
+			      lgdev_irq(lgdev));
+	if (err)
 		printk("lguest console: failed to bind buffer.\n");
-	return 0;
+	return err;
 }
 
 static struct lguest_driver lguestcons_drv = {


