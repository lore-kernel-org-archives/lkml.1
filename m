Return-Path: <linux-kernel-owner+w=401wt.eu-S1752363AbYLYUKR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752363AbYLYUKR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 15:10:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751996AbYLYUKD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 15:10:03 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:55638 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751990AbYLYUKB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 15:10:01 -0500
Date: Thu, 25 Dec 2008 21:09:57 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: pete@sensoray.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 1/2] drivers/staging/go7007: introduce missing kfree
Message-ID: <Pine.LNX.4.64.0812252109230.31651@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Error handling code following a kmalloc should free the allocated data.

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
 drivers/staging/go7007/s2250-board.c           |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/go7007/s2250-board.c b/drivers/staging/go7007/s2250-board.c
index fb6845e..a11ce63 100644
--- a/drivers/staging/go7007/s2250-board.c
+++ b/drivers/staging/go7007/s2250-board.c
@@ -166,6 +166,7 @@ static int write_reg(struct i2c_client *client, u8 reg, u8 value)
 
 	if (down_interruptible(&usb->i2c_lock) != 0) {
 		printk(KERN_INFO "i2c lock failed\n");
+		kfree(buf);
 		return -EINTR;
 	}
 	rc = go7007_usb_vendor_request(go, 0x55, dev_addr,
