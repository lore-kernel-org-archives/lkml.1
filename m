Return-Path: <linux-kernel-owner+w=401wt.eu-S1753937AbYIZNyA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753937AbYIZNyA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 09:54:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751916AbYIZNxv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 09:53:51 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:55487 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751506AbYIZNxv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 09:53:51 -0400
From: Julien Brunel <brunel@diku.dk>
To: nicolas.ferre@atmel.com, adaplas@gmail.com,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH] drivers/video: Bad error test before a dereference
Date: Fri, 26 Sep 2008 15:53:44 +0200
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809261553.45301.brunel@diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The error test that follows the call to backlight_device_register
semms not to concern the right variable.

A simplified version of the semantic match that finds this problem is
as follows: 
(http://www.emn.fr/x-info/coccinelle/)
// <smpl>
@def0@
expression x;
position p0;
@@
x@p0 = backlight_device_register(...)

@protected@
expression def0.x,E;
position def0.p0;
position p;
statement S;
@@
x@p0
... when != x = E
if (!IS_ERR(x) && ...) {<... x@p ...>} else S

@unprotected@
expression def0.x;
identifier fld;
position def0.p0;
position p != protected.p;
@@
x@p0
... when != x = E
* x@p->fld
// </smpl>

Signed-off-by: Julien Brunel <brunel@diku.dk>
Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/video/atmel_lcdfb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -u -p a/drivers/video/atmel_lcdfb.c b/drivers/video/atmel_lcdfb.c
--- a/drivers/video/atmel_lcdfb.c
+++ b/drivers/video/atmel_lcdfb.c
@@ -132,7 +132,7 @@ static void init_backlight(struct atmel_
 
 	bl = backlight_device_register("backlight", &sinfo->pdev->dev,
 			sinfo, &atmel_lcdc_bl_ops);
-	if (IS_ERR(sinfo->backlight)) {
+	if (IS_ERR(bl)) {
 		dev_err(&sinfo->pdev->dev, "error %ld on backlight register\n",
 				PTR_ERR(bl));
 		return;
