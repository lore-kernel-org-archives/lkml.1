Return-Path: <linux-kernel-owner+w=401wt.eu-S1756803AbXLXO0B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756803AbXLXO0B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2007 09:26:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754805AbXLXOZv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Dec 2007 09:25:51 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:57695 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753072AbXLXOZu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2007 09:25:50 -0500
Date: Mon, 24 Dec 2007 15:25:47 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: airlied@linux.ie, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 11/38] drivers/char/drm: Use time_before, time_before_eq,
 etc.
Message-ID: <Pine.LNX.4.64.0712241525170.23999@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The functions time_before, time_before_eq, time_after, and time_after_eq
are more robust for comparing jiffies against other values.

A simplified version of the semantic patch making this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@ change_compare_np @
expression E;
@@

(
- jiffies <= E
+ time_before_eq(jiffies,E)
|
- jiffies >= E
+ time_after_eq(jiffies,E)
|
- jiffies < E
+ time_before(jiffies,E)
|
- jiffies > E
+ time_after(jiffies,E)
)

@ include depends on change_compare_np @
@@

#include <linux/jiffies.h>

@ no_include depends on !include && change_compare_np @
@@

  #include <linux/...>
+ #include <linux/jiffies.h>
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
---

diff -r -u -p a/drivers/char/drm/i830_irq.c b/drivers/char/drm/i830_irq.c
--- a/drivers/char/drm/i830_irq.c	2007-10-22 11:25:05.000000000 +0200
+++ b/drivers/char/drm/i830_irq.c	2007-12-23 20:30:39.000000000 +0100
@@ -90,7 +90,7 @@ static int i830_wait_irq(struct drm_devi
 		__set_current_state(TASK_INTERRUPTIBLE);
 		if (atomic_read(&dev_priv->irq_received) >= irq_nr)
 			break;
-		if ((signed)(end - jiffies) <= 0) {
+		if (time_before_eq(jiffies, end)) {
 			DRM_ERROR("timeout iir %x imr %x ier %x hwstam %x\n",
 				  I830_READ16(I830REG_INT_IDENTITY_R),
 				  I830_READ16(I830REG_INT_MASK_R),
