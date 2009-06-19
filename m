Return-Path: <linux-kernel-owner+w=401wt.eu-S1756158AbZFSPxv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756158AbZFSPxv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 11:53:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751978AbZFSPxo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 11:53:44 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:42363 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904AbZFSPxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 11:53:44 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: a.zummo@towertech.it
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 1/1] RTC: ds1374, fix lock imbalance
Date: Fri, 19 Jun 2009 17:53:38 +0200
Message-Id: <1245426818-6617-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When i2c_smbus_read_byte_data fails in ds1374_work, we forgot to
unlock the held lock. Fix that.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/rtc/rtc-ds1374.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-ds1374.c b/drivers/rtc/rtc-ds1374.c
index 32b2773..713f7bf 100644
--- a/drivers/rtc/rtc-ds1374.c
+++ b/drivers/rtc/rtc-ds1374.c
@@ -283,7 +283,7 @@ static void ds1374_work(struct work_struct *work)
 
 	stat = i2c_smbus_read_byte_data(client, DS1374_REG_SR);
 	if (stat < 0)
-		return;
+		goto unlock;
 
 	if (stat & DS1374_REG_SR_AF) {
 		stat &= ~DS1374_REG_SR_AF;
@@ -302,7 +302,7 @@ static void ds1374_work(struct work_struct *work)
 out:
 	if (!ds1374->exiting)
 		enable_irq(client->irq);
-
+unlock:
 	mutex_unlock(&ds1374->mutex);
 }
 
-- 
1.6.3.2

