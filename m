Return-Path: <linux-kernel-owner+w=401wt.eu-S1762849AbYGaC6b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762849AbYGaC6b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 22:58:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756290AbYGaCvM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 22:51:12 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:55965 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759808AbYGaCvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 22:51:10 -0400
Date: Wed, 30 Jul 2008 21:50:11 -0500
From: David Fries <david@fries.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>, linux-kernel@vger.kernel.org
Subject: [PATCH 23/30] W1: ds2490.c simplify and fix ds_touch_bit
Message-ID: <20080731025011.GX12181@spacedout.fries.net>
References: <20080729020433.GA24424@spacedout.fries.net> <20080729161356.2de456fb.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080729161356.2de456fb.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.4i
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-3.0 (SpacedOut.fries.net [127.0.0.1]); Wed, 30 Jul 2008 21:50:11 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simplify and fix ds_touch_bit.  If a device is attached in the middle
of a bus search the status register will return more than the default
16 bytes.  The additional bytes indicate that it has detected a new
device.  The way ds_wait_status is coded, if it doesn't read 16 status
bytes it returns an error value.  ds_touch_bit then will detect that
error and return an error.  In that case it doesn't read the input
buffer and returns uninitialized data.  It doesn't stop there.  The
next transaction will not expect the extra byte in the input buffer
and the short read will cause an error and clear out both the old byte
and new data in the input buffer.

Just ignore the value of ds_wait_status.  It is still required to wait
until ds2490 is again idle and there is data to read when ds_recv_data
is called.  This also removes the while loop.  None of the other
commands wait and verify that the issued command is in the status
register.

Signed-off-by: David Fries <david@fries.net>
Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
---
 drivers/w1/masters/ds2490.c |   21 ++++-----------------
 1 files changed, 4 insertions(+), 17 deletions(-)

diff --git a/drivers/w1/masters/ds2490.c b/drivers/w1/masters/ds2490.c
index 1b632d5..c4ff70b 100644
--- a/drivers/w1/masters/ds2490.c
+++ b/drivers/w1/masters/ds2490.c
@@ -490,28 +490,15 @@ static int ds_set_pullup(struct ds_device *dev, int delay)
 
 static int ds_touch_bit(struct ds_device *dev, u8 bit, u8 *tbit)
 {
-	int err, count;
+	int err;
 	struct ds_status st;
-	u16 value = (COMM_BIT_IO | COMM_IM) | ((bit) ? COMM_D : 0);
-	u16 cmd;
 
-	err = ds_send_control(dev, value, 0);
+	err = ds_send_control(dev, COMM_BIT_IO | COMM_IM | (bit ? COMM_D : 0),
+		0);
 	if (err)
 		return err;
 
-	count = 0;
-	do {
-		err = ds_wait_status(dev, &st);
-		if (err)
-			return err;
-
-		cmd = st.command0 | (st.command1 << 8);
-	} while (cmd != value && ++count < 10);
-
-	if (err < 0 || count >= 10) {
-		printk(KERN_ERR "Failed to obtain status.\n");
-		return -EINVAL;
-	}
+	ds_wait_status(dev, &st);
 
 	err = ds_recv_data(dev, tbit, sizeof(*tbit));
 	if (err < 0)
-- 
1.4.4.4
