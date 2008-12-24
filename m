Return-Path: <linux-kernel-owner+w=401wt.eu-S1752097AbYLXPXZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752097AbYLXPXZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2008 10:23:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751149AbYLXPXP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Dec 2008 10:23:15 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:38409 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751079AbYLXPXO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2008 10:23:14 -0500
Date: Wed, 24 Dec 2008 16:23:10 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: g.gebhardt@meilhaus.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 1/3] drivers/staging/comedi: Correct use of ! and &
Message-ID: <Pine.LNX.4.64.0812241622320.5475@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

0x20 has 0 as its rightmost bit and thus !inl(info->plx_regbase +
PLX_INTCSR) & 0x20 is always 0.  I assume that !(!inl(info->plx_regbase +
PLX_INTCSR) & 0x20) was intended.

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
 drivers/staging/comedi/drivers/me4000.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -u -p a/drivers/staging/comedi/drivers/me4000.c b/drivers/staging/comedi/drivers/me4000.c
--- a/drivers/staging/comedi/drivers/me4000.c
+++ b/drivers/staging/comedi/drivers/me4000.c
@@ -782,7 +782,7 @@ static int xilinx_download(comedi_device
 
 	/* Wait until /INIT pin is set */
 	udelay(20);
-	if (!inl(info->plx_regbase + PLX_INTCSR) & 0x20) {
+	if (!(inl(info->plx_regbase + PLX_INTCSR) & 0x20)) {
 		printk(KERN_ERR
 			"comedi%d: me4000: xilinx_download(): Can't init Xilinx\n",
 			dev->minor);
