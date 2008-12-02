Return-Path: <linux-kernel-owner+w=401wt.eu-S1754401AbYLBNhI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754401AbYLBNhI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 08:37:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753922AbYLBNgs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 08:36:48 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:42365 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754910AbYLBNgq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 08:36:46 -0500
From: Nicolas Palix <npalix@diku.dk>
To: Paul Mackerras <paulus@samba.org>
Subject: [PATCH linux-next] drivers/macintosh: Add missing of_node_put in therm_adt746x.c
Date: Tue, 2 Dec 2008 14:36:44 +0100
User-Agent: KMail/1.9.10
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org, Julia Lawall <julia@diku.dk>,
       Nicolas Palix <npalix@diku.dk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812021436.44286.npalix@diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


of_node_put is needed before discarding a value received from
of_find_node_by_name, eg in error handling code or when the device
node is no longer used.

The semantic match that catches the bug is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@r exists@
local idexpression struct device_node *n;
position p1, p2;
struct device_node *n1;
statement S;
identifier f;
expression E;
expression *ptr != NULL;
@@

n@p1 = of_find_node_by_name(...)
...
if (!n) S
... when != of_node_put(n)
    when != n1 = f(n,...)
    when != E = n
    when any
    when strict
(
  return \(0\|<+...n...+>\|ptr\);
|
return@p2 ...;
|
  of_node_put(n);
|
  n1 = f(n,...)
|
  E = n
)

@script:python@
p1 << r.p1;
p2 << r.p2;
@@

print "* file: %s of_find_node_by_name %s return %s" % (p1[0].file,p1[0].line,p2[0].line)
// </smpl>

Signed-off-by: Nicolas Palix <npalix@diku.dk>
Signed-off-by: Julia Lawall <julia@diku.dk>
---
 drivers/macintosh/therm_adt746x.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/macintosh/therm_adt746x.c b/drivers/macintosh/therm_adt746x.c
index 22bf981..82607ad 100644
--- a/drivers/macintosh/therm_adt746x.c
+++ b/drivers/macintosh/therm_adt746x.c
@@ -554,7 +554,7 @@ thermostat_init(void)
 	const u32 *prop;
 	int i = 0, offset = 0;
 	int err;
-	
+
 	np = of_find_node_by_name(NULL, "fan");
 	if (!np)
 		return -ENODEV;
@@ -613,13 +613,13 @@ thermostat_init(void)
 	}
 
 	of_dev = of_platform_device_create(np, "temperatures", NULL);
-	
+	of_node_put(np);
+
 	if (of_dev == NULL) {
 		printk(KERN_ERR "Can't register temperatures device !\n");
-		of_node_put(np);
 		return -ENODEV;
 	}
-	
+
 	err = device_create_file(&of_dev->dev, &dev_attr_sensor1_temperature);
 	err |= device_create_file(&of_dev->dev, &dev_attr_sensor2_temperature);
 	err |= device_create_file(&of_dev->dev, &dev_attr_sensor1_limit);
-- 
Nicolas Palix
