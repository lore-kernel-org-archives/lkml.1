Return-Path: <linux-kernel-owner+w=401wt.eu-S1754193AbZHaTMJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754193AbZHaTMJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 15:12:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752635AbZHaTMI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 15:12:08 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:57355 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751879AbZHaTMH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 15:12:07 -0400
Date: Mon, 31 Aug 2009 21:12:07 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] drivers/char/amiserial.c: Add local_irq_restore in error
 handling code
Message-ID: <Pine.LNX.4.64.0908312111400.17886@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The gotos to the labels fail_free_irq and fail_unregister only occur
between local_irq_save and local_irq_restore, so it would seem that this
code should also call local_irq_restore.

The semantic match that detects this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@rl@
expression l;
position p;
expression E,E1,E2;
@@

local_irq_save(l);
<... when != local_irq_restore(l)
     when != spin_unlock_irqrestore(E,l)
if (...) { ... when != local_irq_restore(l)
               when != spin_unlock_irqrestore(E1,l)
*    return@p ...;
}
...>
(
spin_unlock_irqrestore(E2,l);
|
local_irq_restore(l);
)
</smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/char/amiserial.c            |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/char/amiserial.c b/drivers/char/amiserial.c
index 6c32fbf..2131ecb 100644
--- a/drivers/char/amiserial.c
+++ b/drivers/char/amiserial.c
@@ -2056,6 +2056,7 @@ fail_free_irq:
 	free_irq(IRQ_AMIGA_TBE, state);
 fail_unregister:
 	tty_unregister_driver(serial_driver);
+	local_irq_restore(flags);
 fail_release_mem_region:
 	release_mem_region(CUSTOM_PHYSADDR+0x30, 4);
 fail_put_tty_driver:
