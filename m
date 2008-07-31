Return-Path: <linux-kernel-owner+w=401wt.eu-S1761500AbYGaCwY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761500AbYGaCwY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 22:52:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759463AbYGaCtT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 22:49:19 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:60543 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759415AbYGaCtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 22:49:17 -0400
Date: Wed, 30 Jul 2008 21:48:43 -0500
From: David Fries <david@fries.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>, linux-kernel@vger.kernel.org
Subject: [PATCH 8/30] W1: recode w1_slave_found logic
Message-ID: <20080731024843.GI12181@spacedout.fries.net>
References: <20080729020433.GA24424@spacedout.fries.net> <20080729161356.2de456fb.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080729161356.2de456fb.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.4i
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-3.0 (SpacedOut.fries.net [127.0.0.1]); Wed, 30 Jul 2008 21:48:43 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simplified the logic in w1_slave_found by using the new
w1_attach_slave_device function to find a slave and mark it as active
or add the device if the crc checks.

Signed-off-by: David Fries <david@fries.net>
Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
---
 drivers/w1/w1.c |   26 ++++++--------------------
 1 files changed, 6 insertions(+), 20 deletions(-)

diff --git a/drivers/w1/w1.c b/drivers/w1/w1.c
index 354c12a..cd5bd23 100644
--- a/drivers/w1/w1.c
+++ b/drivers/w1/w1.c
@@ -844,9 +844,7 @@ void w1_reconnect_slaves(struct w1_family *f, int attach)
 
 static void w1_slave_found(struct w1_master *dev, u64 rn)
 {
-	int slave_count;
 	struct w1_slave *sl;
-	struct list_head *ent;
 	struct w1_reg_num *tmp;
 	u64 rn_le = cpu_to_le64(rn);
 
@@ -854,24 +852,12 @@ static void w1_slave_found(struct w1_master *dev, u64 rn)
 
 	tmp = (struct w1_reg_num *) &rn;
 
-	slave_count = 0;
-	list_for_each(ent, &dev->slist) {
-
-		sl = list_entry(ent, struct w1_slave, w1_slave_entry);
-
-		if (sl->reg_num.family == tmp->family &&
-		    sl->reg_num.id == tmp->id &&
-		    sl->reg_num.crc == tmp->crc) {
-			set_bit(W1_SLAVE_ACTIVE, (long *)&sl->flags);
-			break;
-		}
-
-		slave_count++;
-	}
-
-	if (slave_count == dev->slave_count &&
-		rn && ((rn >> 56) & 0xff) == w1_calc_crc8((u8 *)&rn_le, 7)) {
-		w1_attach_slave_device(dev, tmp);
+	sl = w1_slave_search_device(dev, tmp);
+	if (sl) {
+		set_bit(W1_SLAVE_ACTIVE, (long *)&sl->flags);
+	} else {
+		if (rn && tmp->crc == w1_calc_crc8((u8 *)&rn_le, 7))
+			w1_attach_slave_device(dev, tmp);
 	}
 
 	atomic_dec(&dev->refcnt);
-- 
1.4.4.4
