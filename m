Return-Path: <linux-kernel-owner+w=401wt.eu-S1759541AbXEKBZM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759541AbXEKBZM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 21:25:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762927AbXEKBYt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 21:24:49 -0400
Received: from ozlabs.org ([203.10.76.45]:43044 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762739AbXEKBYs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 21:24:48 -0400
Subject: [PATCH 5/5] lguest console driver feedback tidyups
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>
In-Reply-To: <1178846632.23513.30.camel@localhost.localdomain>
References: <1178846246.23513.21.camel@localhost.localdomain>
	 <1178846354.23513.23.camel@localhost.localdomain>
	 <1178846490.23513.27.camel@localhost.localdomain>
	 <1178846572.23513.29.camel@localhost.localdomain>
	 <1178846632.23513.30.camel@localhost.localdomain>
Content-Type: text/plain
Date: Fri, 11 May 2007 11:24:35 +1000
Message-Id: <1178846675.23513.32.camel@localhost.localdomain>
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


