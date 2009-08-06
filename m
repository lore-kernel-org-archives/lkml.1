Return-Path: <linux-kernel-owner+w=401wt.eu-S1756645AbZHFUFf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756645AbZHFUFf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 16:05:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756618AbZHFUFe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 16:05:34 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:38867 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756084AbZHFUFd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 16:05:33 -0400
Date: Thu, 6 Aug 2009 22:05:18 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Marcel Holtmann <marcel@holtmann.org>, linux-bluetooth@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 2/3] drivers/bluetooth: Add kmalloc NULL tests
Message-ID: <Pine.LNX.4.64.0908062204290.19100@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Check that the result of kmalloc is not NULL before dereferencing it.
The patch also replaces kmalloc + memset by kzalloc.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression *x;
identifier f;
constant char *C;
@@

x = \(kmalloc\|kcalloc\|kzalloc\)(...);
... when != x == NULL
    when != x != NULL
    when != (x || ...)
(
kfree(x)
|
f(...,C,...,x,...)
|
*f(...,x,...)
|
*x->f
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/bluetooth/btmrvl_sdio.c     |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/bluetooth/btmrvl_sdio.c b/drivers/bluetooth/btmrvl_sdio.c
index 1cfa8b4..5b33b85 100644
--- a/drivers/bluetooth/btmrvl_sdio.c
+++ b/drivers/bluetooth/btmrvl_sdio.c
@@ -777,10 +777,11 @@ static int btmrvl_sdio_host_to_card(struct btmrvl_private *priv,
 	buf = payload;
 	if ((unsigned long) payload & (BTSDIO_DMA_ALIGN - 1)) {
 		tmpbufsz = ALIGN_SZ(nb, BTSDIO_DMA_ALIGN);
-		tmpbuf = kmalloc(tmpbufsz, GFP_KERNEL);
-		memset(tmpbuf, 0, tmpbufsz);
+		tmpbuf = kzalloc(tmpbufsz, GFP_KERNEL);
+		if (!tmpbuf)
+			return -ENOMEM;
 		buf = (u8 *) ALIGN_ADDR(tmpbuf, BTSDIO_DMA_ALIGN);
 		memcpy(buf, payload, nb);
 	}
