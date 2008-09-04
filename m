Return-Path: <linux-kernel-owner+w=401wt.eu-S1755431AbYIDDjk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755431AbYIDDjk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 23:39:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753543AbYIDDjb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 23:39:31 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:19017 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753560AbYIDDja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 23:39:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=kPhLOtpDh6G5KiuUbMvxR9gojChi5aA4wjIhIq0O8rrlCpN/YkVgZ+Jy/9hKgKbrNl
         8vGxrU1WvmJk2n2q1qZy0ebB0Kl+APELKlnyItQpR0M6mzZqoIJcdrRyTwIK8wu9C5lQ
         ouym/BD0RKTOhb/QltTJNkDu2U9mrxClyrXxI=
Subject: [PATCH] bq27x00_battery: use unaligned access helper
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Rodolfo Giometti <giometti@linux.it>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 03 Sep 2008 20:39:28 -0700
Message-Id: <1220499569.2137.21.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove hand-rolled get_unaligned_be16, this points to a possible
bug as bq27x00_read does another endian byteswap which sparse
notices:

drivers/power/bq27x00_battery.c:81:14: warning: cast to restricted __be16
Which should probably be checked.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
New in next-20080902

Also all of these functions could (should) change to passing around a u16
rather than an int as the read function only ever reads 1 or two bytes.

 drivers/power/bq27x00_battery.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/power/bq27x00_battery.c b/drivers/power/bq27x00_battery.c
index 62d4948..a5a49e1 100644
--- a/drivers/power/bq27x00_battery.c
+++ b/drivers/power/bq27x00_battery.c
@@ -23,6 +23,7 @@
 #include <linux/platform_device.h>
 #include <linux/power_supply.h>
 #include <linux/idr.h>
+#include <asm/unaligned.h>
 
 #include <linux/i2c.h>
 
@@ -33,7 +34,6 @@
 #define BQ27x00_REG_RSOC		0x0B /* Relative State-of-Charge */
 #define BQ27x00_REG_AI			0x14
 #define BQ27x00_REG_FLAGS		0x0A
-#define HIGH_BYTE(A)			((A) << 8)
 
 /* If the system has several batteries we need a different name for each
  * of them...
@@ -239,7 +239,7 @@ static int bq27200_read(u8 reg, int *rt_value, int b_single,
 		err = i2c_transfer(client->adapter, msg, 1);
 		if (err >= 0) {
 			if (!b_single)
-				*rt_value = data[1] | HIGH_BYTE(data[0]);
+				*rt_value = get_unaligned_be16(data);
 			else
 				*rt_value = data[0];
 
-- 
1.6.0.1.514.g59380c



