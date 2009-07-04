Return-Path: <linux-kernel-owner+w=401wt.eu-S1754552AbZGDVd3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754552AbZGDVd3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jul 2009 17:33:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753518AbZGDVdV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Jul 2009 17:33:21 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:56177 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752936AbZGDVdU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jul 2009 17:33:20 -0400
Date: Sat, 4 Jul 2009 23:33:21 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: florian@openwrt.org, openwrt-devel@lists.openwrt.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 3/3] drivers/vlynq/vlynq.c: Fix resource size off by 1 error
Message-ID: <Pine.LNX.4.64.0907042332300.9841@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

In this case, the calls to request_mem_region, ioremap, and
release_mem_region all have a consistent length argument, len, but since in
other files (res->end - res->start) + 1, equivalent to resource_size(res),
is used for a resource-typed structure res, one could consider whether the
same should be done here.

The problem was found using the following semantic patch:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
struct resource *res;
@@

- (res->end - res->start) + 1
+ resource_size(res)

@@
struct resource *res;
@@

- res->end - res->start
+ BAD(resource_size(res))
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/vlynq/vlynq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -u -p 
a/drivers/vlynq/vlynq.c 
b/drivers/vlynq/vlynq.c
--- a/drivers/vlynq/vlynq.c 2009-06-24 21:18:50.000000000 +0200
+++ b/drivers/vlynq/vlynq.c 2009-07-04 21:37:28.000000000 +0200
@@ -703,7 +703,7 @@ static int vlynq_probe(struct platform_d
 	dev->mem_start = mem_res->start;
 	dev->mem_end = mem_res->end;
 
-	len = regs_res->end - regs_res->start;
+	len = resource_size(regs_res);
 	if (!request_mem_region(regs_res->start, len, dev_name(&dev->dev))) {
 		printk(KERN_ERR "%s: Can't request vlynq registers\n",
 		       dev_name(&dev->dev));
