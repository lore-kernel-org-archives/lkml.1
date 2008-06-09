Return-Path: <linux-kernel-owner+w=401wt.eu-S1758829AbYFIMUd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758829AbYFIMUd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 08:20:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754676AbYFIMUV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 08:20:21 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:48396 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751164AbYFIMUU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 08:20:20 -0400
Date: Mon, 9 Jun 2008 14:20:04 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: paulus@samba.org, linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 1/4] arch/powerpc: add missing of_node_put
Message-ID: <Pine.LNX.4.64.0806091418340.16009@ask.diku.dk>
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

diff -u -p a/arch/powerpc/platforms/pseries/nvram.c b/arch/powerpc/platforms/pseries/nvram.c
--- a/arch/powerpc/platforms/pseries/nvram.c
+++ b/arch/powerpc/platforms/pseries/nvram.c
@@ -131,8 +131,10 @@ int __init pSeries_nvram_init(void)
 		return -ENODEV;
 
 	nbytes_p = of_get_property(nvram, "#bytes", &proplen);
-	if (nbytes_p == NULL || proplen != sizeof(unsigned int))
+	if (nbytes_p == NULL || proplen != sizeof(unsigned int)) {
+		of_node_put(nvram);
 		return -EIO;
+	}
 
 	nvram_size = *nbytes_p;
 
