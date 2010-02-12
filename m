Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755950Ab0BLV46 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 16:56:58 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:56655 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755548Ab0BLV45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 16:56:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=tedjloAYqQ9j+QmmKPYWE7cip6F7Yq7mLSNDGXv4b6ULjS9Ejw5J7GhVhzmZDwKjoM
         HvS3QqgAjGM2P4B2+b6O/Q1gKR+WNgi9bFlnve8YBGt+UOXhfzGd+aB5T9TXgqY25lS/
         /fjONv5qjmusS4XnPWjC2wphh7WykLmGR196g=
From: Grazvydas Ignotas <notasas@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Anton Vorontsov <avorontsov@ru.mvista.com>,
       David Woodhouse <dwmw2@infradead.org>,
       Rodolfo Giometti <giometti@linux.it>,
       Grazvydas Ignotas <notasas@gmail.com>
Subject: [PATCH 1/4] power_supply: bq27x00: remove double endian swap
Date: Fri, 12 Feb 2010 23:56:46 +0200
Message-Id: <1266011806-31747-1-git-send-email-notasas@gmail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The bq27x00 registers are little endian, so just read them as such
and don't do double endian swap on LE machines.

This also gets rid of strange looking shift that was done after
reading 8bit register because endian swap in bq27x00_read() was
messing it up.

Signed-off-by: Grazvydas Ignotas <notasas@gmail.com>
---
 drivers/power/bq27x00_battery.c |   11 +++--------
 1 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/power/bq27x00_battery.c b/drivers/power/bq27x00_battery.c
index 62bb981..537915c 100644
--- a/drivers/power/bq27x00_battery.c
+++ b/drivers/power/bq27x00_battery.c
@@ -74,12 +74,7 @@ static enum power_supply_property bq27x00_battery_props[] = {
 static int bq27x00_read(u8 reg, int *rt_value, int b_single,
 			struct bq27x00_device_info *di)
 {
-	int ret;
-
-	ret = di->bus->read(reg, rt_value, b_single, di);
-	*rt_value = be16_to_cpu(*rt_value);
-
-	return ret;
+	return di->bus->read(reg, rt_value, b_single, di);
 }
 
 /*
@@ -161,7 +156,7 @@ static int bq27x00_battery_rsoc(struct bq27x00_device_info *di)
 		return ret;
 	}
 
-	return rsoc >> 8;
+	return rsoc;
 }
 
 #define to_bq27x00_device_info(x) container_of((x), \
@@ -238,7 +233,7 @@ static int bq27200_read(u8 reg, int *rt_value, int b_single,
 		err = i2c_transfer(client->adapter, msg, 1);
 		if (err >= 0) {
 			if (!b_single)
-				*rt_value = get_unaligned_be16(data);
+				*rt_value = get_unaligned_le16(data);
 			else
 				*rt_value = data[0];
 
-- 
1.6.3.3

