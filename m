Return-Path: <linux-kernel-owner+w=401wt.eu-S1751851AbZGEGgc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751851AbZGEGgc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 02:36:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751949AbZGEGgX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 02:36:23 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:48512 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751487AbZGEGgW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 02:36:22 -0400
Date: Sun, 5 Jul 2009 08:36:22 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: dmitry.torokhov@gmail.com, dtor@mail.ru, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 2/5] drivers/input: Use resource_size
Message-ID: <Pine.LNX.4.64.0907050835530.27464@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Use the function resource_size, which reduces the chance of introducing
off-by-one errors in calculating the resource size.

The semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
struct resource *res;
@@

- (res->end - res->start) + 1
+ resource_size(res)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/input/misc/cobalt_btns.c         |    2 +-
 drivers/input/serio/at32psif.c           |    2 +-
 drivers/input/touchscreen/atmel_tsadcc.c |    8 ++++----
 drivers/input/touchscreen/w90p910_ts.c   |    8 ++++----
 4 files changed, 10 insertions(+), 10 deletions(-)

diff -u -p a/drivers/input/misc/cobalt_btns.c b/drivers/input/misc/cobalt_btns.c
--- a/drivers/input/misc/cobalt_btns.c 2009-07-04 21:32:44.000000000 +0200
+++ b/drivers/input/misc/cobalt_btns.c 2009-07-04 21:37:23.000000000 +0200
@@ -116,7 +116,7 @@ static int __devinit cobalt_buttons_prob
 	}
 
 	bdev->poll_dev = poll_dev;
-	bdev->reg = ioremap(res->start, res->end - res->start + 1);
+	bdev->reg = ioremap(res->start, resource_size(res));
 	dev_set_drvdata(&pdev->dev, bdev);
 
 	error = input_register_polled_device(poll_dev);
diff -u -p a/drivers/input/serio/at32psif.c b/drivers/input/serio/at32psif.c
--- a/drivers/input/serio/at32psif.c 2008-12-07 19:29:06.000000000 +0100
+++ b/drivers/input/serio/at32psif.c 2009-07-04 21:37:23.000000000 +0200
@@ -231,7 +231,7 @@ static int __init psif_probe(struct plat
 		goto out_free_io;
 	}
 
-	psif->regs = ioremap(regs->start, regs->end - regs->start + 1);
+	psif->regs = ioremap(regs->start, resource_size(regs));
 	if (!psif->regs) {
 		ret = -ENOMEM;
 		dev_dbg(&pdev->dev, "could not map I/O memory\n");
diff -u -p a/drivers/input/touchscreen/atmel_tsadcc.c b/drivers/input/touchscreen/atmel_tsadcc.c
--- a/drivers/input/touchscreen/atmel_tsadcc.c 2009-03-13 13:37:47.000000000 +0100
+++ b/drivers/input/touchscreen/atmel_tsadcc.c 2009-07-04 21:37:23.000000000 +0200
@@ -204,14 +204,14 @@ static int __devinit atmel_tsadcc_probe(
 		goto err_free_dev;
 	}
 
-	if (!request_mem_region(res->start, res->end - res->start + 1,
+	if (!request_mem_region(res->start, resource_size(res),
 				"atmel tsadcc regs")) {
 		dev_err(&pdev->dev, "resources is unavailable.\n");
 		err = -EBUSY;
 		goto err_free_dev;
 	}
 
-	tsc_base = ioremap(res->start, res->end - res->start + 1);
+	tsc_base = ioremap(res->start, resource_size(res));
 	if (!tsc_base) {
 		dev_err(&pdev->dev, "failed to map registers.\n");
 		err = -ENOMEM;
@@ -286,7 +286,7 @@ err_free_irq:
 err_unmap_regs:
 	iounmap(tsc_base);
 err_release_mem:
-	release_mem_region(res->start, res->end - res->start + 1);
+	release_mem_region(res->start, resource_size(res));
 err_free_dev:
 	input_free_device(ts_dev->input);
 err_free_mem:
@@ -305,7 +305,7 @@ static int __devexit atmel_tsadcc_remove
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	iounmap(tsc_base);
-	release_mem_region(res->start, res->end - res->start + 1);
+	release_mem_region(res->start, resource_size(res));
 
 	clk_disable(ts_dev->clk);
 	clk_put(ts_dev->clk);
diff -u -p a/drivers/input/touchscreen/w90p910_ts.c b/drivers/input/touchscreen/w90p910_ts.c
--- a/drivers/input/touchscreen/w90p910_ts.c 2009-06-24 21:18:49.000000000 +0200
+++ b/drivers/input/touchscreen/w90p910_ts.c 2009-07-04 21:37:23.000000000 +0200
@@ -241,13 +241,13 @@ static int __devinit w90x900ts_probe(str
 		goto fail1;
 	}
 
-	if (!request_mem_region(res->start, res->end - res->start + 1,
+	if (!request_mem_region(res->start, resource_size(res),
 				pdev->name)) {
 		err = -EBUSY;
 		goto fail1;
 	}
 
-	w90p910_ts->ts_reg = ioremap(res->start, res->end - res->start + 1);
+	w90p910_ts->ts_reg = ioremap(res->start, resource_size(res));
 	if (!w90p910_ts->ts_reg) {
 		err = -ENOMEM;
 		goto fail2;
@@ -296,7 +296,7 @@ static int __devinit w90x900ts_probe(str
 
 fail4:	free_irq(w90p910_ts->irq_num, w90p910_ts);
 fail3:	iounmap(w90p910_ts->ts_reg);
-fail2:	release_mem_region(res->start, res->end - res->start + 1);
+fail2:	release_mem_region(res->start, resource_size(res));
 fail1:	input_free_device(input_dev);
 	kfree(w90p910_ts);
 	return err;
@@ -312,7 +312,7 @@ static int __devexit w90x900ts_remove(st
 	iounmap(w90p910_ts->ts_reg);
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	release_mem_region(res->start, res->end - res->start + 1);
+	release_mem_region(res->start, resource_size(res));
 
 	input_unregister_device(w90p910_ts->input);
 	kfree(w90p910_ts);
