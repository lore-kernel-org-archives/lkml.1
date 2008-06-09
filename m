Return-Path: <linux-kernel-owner+w=401wt.eu-S1760878AbYFIMWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760878AbYFIMWR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 08:22:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756861AbYFIMWA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 08:22:00 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:48563 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754852AbYFIMV7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 08:21:59 -0400
Date: Mon, 9 Jun 2008 14:21:51 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: benh@kernel.crashing.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 4/4] drivers/macintosh/therm_adt746x.c: add missing of_node_put
Message-ID: <Pine.LNX.4.64.0806091421200.16009@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

of_node_put is needed before discarding a value received from
of_find_node_by_name, eg in error handling code.

The semantic patch that makes the change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
struct device_node *n;
struct device_node *n1;
statement S;
identifier f;
expression E;
constant C;
@@

n = of_find_node_by_name(...)
...
if (!n) S
... when != of_node_put(n)
    when != n1 = f(n,...)
    when != E = n
    when any
    when strict
(
+ of_node_put(n);
  return -C;
|
  of_node_put(n);
|
  n1 = f(n,...)
|
  E = n
|
  return ...;
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---

diff -u -p a/drivers/macintosh/therm_adt746x.c b/drivers/macintosh/therm_adt746x.c
--- a/drivers/macintosh/therm_adt746x.c
+++ b/drivers/macintosh/therm_adt746x.c
@@ -562,18 +562,24 @@ thermostat_init(void)
 		therm_type = ADT7460;
 	else if (of_device_is_compatible(np, "adt7467"))
 		therm_type = ADT7467;
-	else
+	else {
+		of_node_put(np);
 		return -ENODEV;
+	}
 
 	prop = of_get_property(np, "hwsensor-params-version", NULL);
 	printk(KERN_INFO "adt746x: version %d (%ssupported)\n", *prop,
 			 (*prop == 1)?"":"un");
-	if (*prop != 1)
+	if (*prop != 1) {
+		of_node_put(np);
 		return -ENODEV;
+	}
 
 	prop = of_get_property(np, "reg", NULL);
-	if (!prop)
+	if (!prop) {
+		of_node_put(np);
 		return -ENODEV;
+	}
 
 	/* look for bus either by path or using "reg" */
 	if (strstr(np->full_name, "/i2c-bus@") != NULL) {
@@ -610,5 +616,6 @@ thermostat_init(void)
 	
 	if (of_dev == NULL) {
 		printk(KERN_ERR "Can't register temperatures device !\n");
+		of_node_put(np);
 		return -ENODEV;
 	}
