Return-Path: <linux-kernel-owner+w=401wt.eu-S1760764AbYFIMVf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760764AbYFIMVf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 08:21:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754852AbYFIMVY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 08:21:24 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:48503 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756072AbYFIMVX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 08:21:23 -0400
Date: Mon, 9 Jun 2008 14:21:18 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: adaplas@gmail.com, linux-fbdev-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 3/4] drivers/video/fsl-diu-fb.c: add missing of_node_put
Message-ID: <Pine.LNX.4.64.0806091420450.16009@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

of_node_put is needed before discarding a value received from
of_find_node_by_type, eg in error handling code.

The semantic patch that makes the change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
struct device_node *n;
struct device_node *n1;
struct device_node *n2;
statement S;
identifier f1,f2;
expression E1,E2;
constant C;
@@

n = of_find_node_by_type(...)
...
if (!n) S
... when != of_node_put(n)
    when != n1 = f1(n,...)
    when != E1 = n
    when any
    when strict
(
+ of_node_put(n);
  return -C;
|
  of_node_put(n);
|
  n2 = f2(n,...)
|
  E2 = n
|
  return ...;
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---

diff -u -p a/drivers/video/fsl-diu-fb.c b/drivers/video/fsl-diu-fb.c
--- a/drivers/video/fsl-diu-fb.c
+++ b/drivers/video/fsl-diu-fb.c
@@ -1664,8 +1664,10 @@ static int __init fsl_diu_init(void)
 	}
 
 	prop = of_get_property(np, "d-cache-size", NULL);
-	if (prop == NULL)
+	if (prop == NULL) {
+		of_node_put(np);
 		return -ENODEV;
+	}
 
 	/* Freescale PLRU requires 13/8 times the cache size to do a proper
 	   displacement flush
@@ -1674,8 +1676,10 @@ static int __init fsl_diu_init(void)
 	coherence_data_size /= 8;
 
 	prop = of_get_property(np, "d-cache-line-size", NULL);
-	if (prop == NULL)
+	if (prop == NULL) {
+		of_node_put(np);
 		return -ENODEV;
+	}
 	d_cache_line_size = *prop;
 
 	of_node_put(np);
 	
