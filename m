Return-Path: <linux-kernel-owner+w=401wt.eu-S1760935AbYGKN4l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760935AbYGKN4l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 09:56:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759540AbYGKNsW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 09:48:22 -0400
Received: from zbr.yandex.ru ([213.180.219.33]:34976 "EHLO gavana.yandex.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759394AbYGKNry (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 09:47:54 -0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, David Fries <david@fries.net>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: [PATCH 8/30] W1: recode w1_slave_found logic
Date: Fri, 11 Jul 2008 17:51:23 +0400
Message-Id: <12157843061715-git-send-email-johnpol@2ka.mipt.ru>
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <12157843054074-git-send-email-johnpol@2ka.mipt.ru>
References: <12157843054074-git-send-email-johnpol@2ka.mipt.ru>
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
index 24312e0..4bf2001 100644
--- a/drivers/w1/w1.c
+++ b/drivers/w1/w1.c
@@ -836,9 +836,7 @@ void w1_reconnect_slaves(struct w1_family *f, int attach)
 
 static void w1_slave_found(struct w1_master *dev, u64 rn)
 {
-	int slave_count;
 	struct w1_slave *sl;
-	struct list_head *ent;
 	struct w1_reg_num *tmp;
 	u64 rn_le = cpu_to_le64(rn);
 
@@ -846,24 +844,12 @@ static void w1_slave_found(struct w1_master *dev, u64 rn)
 
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

