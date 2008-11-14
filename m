Return-Path: <linux-kernel-owner+w=401wt.eu-S1755450AbYKNSGX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755450AbYKNSGX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 13:06:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751129AbYKNSGI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 13:06:08 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:59119 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754061AbYKNSGG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 13:06:06 -0500
Date: Fri, 14 Nov 2008 19:06:03 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: rpurdie@linux.intel.com, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 2/3] drivers/video/backlight/da903x.c: introduce missing
 kfree
Message-ID: <Pine.LNX.4.64.0811141905330.10023@pc-004.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Error handling code following a kzalloc should free the allocated data.

The semantic match that finds the problem is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@r exists@
local idexpression x;
statement S;
expression E;
identifier f,l;
position p1,p2;
expression *ptr != NULL;
@@

(
if ((x@p1 = \(kmalloc\|kzalloc\|kcalloc\)(...)) == NULL) S
|
x@p1 = \(kmalloc\|kzalloc\|kcalloc\)(...);
...
if (x == NULL) S
)
<... when != x
     when != if (...) { <+...x...+> }
x->f = E
...>
(
 return \(0\|<+...x...+>\|ptr\);
|
 return@p2 ...;
)

@script:python@
p1 << r.p1;
p2 << r.p2;
@@

print "* file: %s kmalloc %s return %s" % (p1[0].file,p1[0].line,p2[0].line)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
---
 drivers/video/backlight/da903x.c    |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/video/backlight/da903x.c b/drivers/video/backlight/da903x.c
index 242c382..75388b9 100644
--- a/drivers/video/backlight/da903x.c
+++ b/drivers/video/backlight/da903x.c
@@ -119,6 +119,7 @@ static int da903x_backlight_probe(struct platform_device *pdev)
 	default:
 		dev_err(&pdev->dev, "invalid backlight device ID(%d)\n",
 				pdev->id);
+		kfree(data);
 		return -EINVAL;
 	}
 
