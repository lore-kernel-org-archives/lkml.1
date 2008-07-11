Return-Path: <linux-kernel-owner+w=401wt.eu-S1758916AbYGKNsL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758916AbYGKNsL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 09:48:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758699AbYGKNrv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 09:47:51 -0400
Received: from zbr.yandex.ru ([213.180.219.33]:34968 "EHLO gavana.yandex.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755575AbYGKNru (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 09:47:50 -0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, David Fries <david@fries.net>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: [PATCH 21/30] W1: ds2490.c ds_write_bit, grouping error, disable readback
Date: Fri, 11 Jul 2008 17:51:36 +0400
Message-Id: <12157843061992-git-send-email-johnpol@2ka.mipt.ru>
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <12157843054074-git-send-email-johnpol@2ka.mipt.ru>
References: <12157843054074-git-send-email-johnpol@2ka.mipt.ru>
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
index 8ab2c86..7acf6d2 100644
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

