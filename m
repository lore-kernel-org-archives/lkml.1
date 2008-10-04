Return-Path: <linux-kernel-owner+w=401wt.eu-S1754872AbYJDUFd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754872AbYJDUFd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 16:05:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754786AbYJDUFO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 16:05:14 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:58270 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753033AbYJDUFM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 16:05:12 -0400
Date: Sat, 4 Oct 2008 22:05:08 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: ben-linux@fluff.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 1/2] drivers/i2c/busses/i2c-s3c2410.c: Correct use of ! and
 &
Message-ID: <Pine.LNX.4.64.0810042203520.19286@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

In commit e6bafba5b4765a5a252f1b8d31cbf6d2459da337, a bug was fixed that
involved converting !x & y to !(x & y).  The code below shows the same
pattern, and thus should perhaps be fixed in the same way.  In particular,
the result of !readl(i2c->regs + S3C2410_IICCON) & S3C2410_IICCON_IRQEN is
always 0.

The semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@ expression E; constant C; @@
(
  !E & !C
|
- !E & C
+ !(E & C)
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/i2c/busses/i2c-s3c2410.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -u -p a/drivers/i2c/busses/i2c-s3c2410.c b/drivers/i2c/busses/i2c-s3c2410.c
--- a/drivers/i2c/busses/i2c-s3c2410.c
+++ b/drivers/i2c/busses/i2c-s3c2410.c
@@ -507,7 +507,7 @@ static int s3c24xx_i2c_doxfer(struct s3c
 	unsigned long timeout;
 	int ret;
 
-	if (!readl(i2c->regs + S3C2410_IICCON) & S3C2410_IICCON_IRQEN)
+	if (!(readl(i2c->regs + S3C2410_IICCON) & S3C2410_IICCON_IRQEN))
 		return -EIO;
 
 	ret = s3c24xx_i2c_set_master(i2c);
