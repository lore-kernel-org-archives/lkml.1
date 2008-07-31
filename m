Return-Path: <linux-kernel-owner+w=401wt.eu-S1762284AbYGaC52@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762284AbYGaC52 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 22:57:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761116AbYGaCu7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 22:50:59 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:55961 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761047AbYGaCu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 22:50:58 -0400
Date: Wed, 30 Jul 2008 21:50:02 -0500
From: David Fries <david@fries.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>, linux-kernel@vger.kernel.org
Subject: [PATCH 21/30] W1: ds2490.c ds_write_bit, grouping error, disable readback
Message-ID: <20080731025002.GV12181@spacedout.fries.net>
References: <20080729020433.GA24424@spacedout.fries.net> <20080729161356.2de456fb.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080729161356.2de456fb.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.4i
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-3.0 (SpacedOut.fries.net [127.0.0.1]); Wed, 30 Jul 2008 21:50:02 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ds_write_bit doesn't read the input buffer, so add COMM_ICP and a
comment that it will no longer generate a read back data byte.  If
there is an extra data byte later on then it will cause an error and
discard what data was there.  Corrected operator ordering for
ds_send_control.

Signed-off-by: David Fries <david@fries.net>
Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
---
 drivers/w1/masters/ds2490.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/w1/masters/ds2490.c b/drivers/w1/masters/ds2490.c
index 6b188e8..6fabf58 100644
--- a/drivers/w1/masters/ds2490.c
+++ b/drivers/w1/masters/ds2490.c
@@ -525,7 +525,12 @@ static int ds_write_bit(struct ds_device *dev, u8 bit)
 	int err;
 	struct ds_status st;
 
-	err = ds_send_control(dev, COMM_BIT_IO | COMM_IM | (bit) ? COMM_D : 0, 0);
+	/* Set COMM_ICP to write without a readback.  Note, this will
+	 * produce one time slot, a down followed by an up with COMM_D
+	 * only determing the timing.
+	 */
+	err = ds_send_control(dev, COMM_BIT_IO | COMM_IM | COMM_ICP |
+		(bit ? COMM_D : 0), 0);
 	if (err)
 		return err;
 
-- 
1.4.4.4
